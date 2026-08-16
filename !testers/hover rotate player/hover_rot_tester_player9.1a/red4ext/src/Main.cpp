// ============================================================
// HoverRotTesterPlayer9.1a - RED4ext Plugin
//
// Diagnostic logging plugin that fills the 2 unmet goals from tester 9.1:
//   1. Bone/skeleton access (CET's GetSkeleton() returned nil)
//   2. Render-source identification (compare bone transforms during mouse-look)
//
// Native functions registered:
//   HoverRotPlayer9_1a_DumpComponents()       -> String  — all component class names
//   HoverRotPlayer9_1a_DumpSkeleton()         -> String  — bone hierarchy + transforms
//   HoverRotPlayer9_1a_DumpEntityTransform()  -> String  — entity worldTransform readback
//   HoverRotPlayer9_1a_GetStatus()            -> String  — plugin diagnostics
//
// Architecture (proven from Tester 8):
//   CET Lua calls redscript bridge methods
//   Redscript calls native C++ global functions
//   C++ reads player entity via ExecuteGlobalFunction("GetPlayer;GameInstance")
//   C++ accesses component data via raw memory offsets (verified from SDK headers)
//
// SDK offsets (verified from SDK headers):
//   ent::Entity->components:              offset 0xA0 (DynArray<Handle<IComponent>>)
//   ent::Entity->transformComponent:      offset 0xB0 (IPlacedComponent*)
//   IPlacedComponent->worldTransform:     offset 0xE0 (WorldTransform)
//   WorldTransform->Position:             offset 0x00 (WorldPosition: FixedPoint x/y/z, 12 bytes)
//   WorldTransform->Orientation:          offset 0x10 (Quaternion: i/j/k/r, 16 bytes)
//
//   IScriptable->nativeType:              offset 0x30 (CClass*)
//   CClass->name:                         offset 0x18 (CName)
//
//   ent::AnimatedComponent->rig:          offset 0x138 (Ref<anim::Rig> — first 8 bytes = pointer)
//   anim::Rig->parentIndices:             offset 0x40 (int16_t*)
//   anim::Rig->referencePoseLS:           offset 0x48 (QsTransform*)
//   anim::Rig->boneNames:                  offset 0x50 (DynArray<CName>)
//   anim::Rig->referencePoseMS:            offset 0x60 (DynArray<QsTransform>)
//   anim::Rig->aPoseLS:                    offset 0xB8 (DynArray<QsTransform>)
//   anim::Rig->aPoseMS:                    offset 0xC8 (DynArray<QsTransform>)
//
//   QsTransform->Translation:             offset 0x00 (Vector4: X/Y/Z/W, 16 bytes)
//   QsTransform->Rotation:                offset 0x10 (Quaternion: i/j/k/r, 16 bytes)
//   QsTransform->Scale:                    offset 0x20 (Vector4: X/Y/Z/W, 16 bytes)
//   QsTransform total size:                0x30 bytes
//
//   DynArray layout:                      entries*(8) + size(4) + capacity(4) = 16 bytes
//   Handle<IComponent> size:              16 bytes (instance* + controlBlock*)
//   CName size:                            8 bytes (uint64_t hash)
// ============================================================

#include <RED4ext/RED4ext.hpp>
#include <RED4ext/Scripting/Natives/ScriptGameInstance.hpp>
#include <RED4ext/Scripting/Natives/entEntity.hpp>
#include <RED4ext/Scripting/Natives/entIPlacedComponent.hpp>
#include <RED4ext/Scripting/Utils.hpp>
#include <RED4ext/CName.hpp>
#include <RED4ext/CName-inl.hpp>

#include <string>
#include <sstream>
#include <cstdint>

// ============================================================
// Plugin State
// ============================================================

static RED4ext::v1::PluginHandle g_Handle = nullptr;
static const RED4ext::v1::Sdk* g_Sdk = nullptr;

static int32_t g_dumpCompCalls = 0;
static int32_t g_dumpSkelCalls = 0;
static int32_t g_dumpEntityCalls = 0;
static int32_t g_statusCalls = 0;
static int32_t g_errorCount = 0;
static std::string g_lastError = "none";
static int32_t g_lastBoneCount = -1;
static int32_t g_lastCompCount = -1;

// ============================================================
// Logging Helpers
// ============================================================

static void LogInfo(const char* aMessage)
{
    if (g_Sdk && g_Sdk->logger && g_Handle)
    {
        g_Sdk->logger->Info(g_Handle, aMessage);
    }
}

static void LogInfo(const std::string& aMessage)
{
    LogInfo(aMessage.c_str());
}

// ============================================================
// Raw Memory Access Helpers
// ============================================================

// Minimal DynArray header for raw access
struct DynArrayRaw
{
    void* entries;       // 00
    uint32_t size;       // 08
    uint32_t capacity;   // 0C
};

// Read a pointer at a given byte offset from a base pointer
static void* ReadPtrAt(void* base, uintptr_t offset)
{
    return *reinterpret_cast<void**>(reinterpret_cast<uint8_t*>(base) + offset);
}

// Read a DynArrayRaw at a given byte offset from a base pointer
static DynArrayRaw* ReadDynArrayAt(void* base, uintptr_t offset)
{
    return reinterpret_cast<DynArrayRaw*>(
        reinterpret_cast<uint8_t*>(base) + offset);
}

// Read a CName at a given byte offset from a base pointer
static RED4ext::CName ReadCNameAt(void* base, uintptr_t offset)
{
    return *reinterpret_cast<RED4ext::CName*>(
        reinterpret_cast<uint8_t*>(base) + offset);
}

// Read an int16_t at a given byte offset from an int16_t array
static int16_t ReadInt16At(void* base, uintptr_t index)
{
    return reinterpret_cast<int16_t*>(base)[index];
}

// Read a float at a given byte offset from a base pointer
static float ReadFloatAt(void* base, uintptr_t offset)
{
    return *reinterpret_cast<float*>(
        reinterpret_cast<uint8_t*>(base) + offset);
}

// Get component class name string from an IComponent instance
static std::string GetComponentClassName(void* componentInstance)
{
    if (!componentInstance) return "null_instance";

    // IScriptable::nativeType is CClass* at offset 0x30
    auto* nativeType = reinterpret_cast<RED4ext::CClass**>(
        reinterpret_cast<uint8_t*>(componentInstance) + 0x30);
    if (!nativeType || !*nativeType) return "null_type";

    // CClass::name is CName at offset 0x18
    RED4ext::CClass* cls = *nativeType;
    RED4ext::CName name = *reinterpret_cast<RED4ext::CName*>(
        reinterpret_cast<uint8_t*>(cls) + 0x18);

    const char* nameStr = name.ToString();
    if (nameStr)
    {
        return std::string(nameStr);
    }

    // Fallback: log the hash
    std::ostringstream ss;
    ss << "CName_hash_" << std::hex << (uint64_t)name;
    return ss.str();
}

// ============================================================
// Get Player Entity
// ============================================================

static RED4ext::ent::Entity* GetPlayerEntity()
{
    RED4ext::ScriptGameInstance gameInstance;
    RED4ext::Handle<RED4ext::IScriptable> playerHandle;
    RED4ext::ExecuteGlobalFunction("GetPlayer;GameInstance", &playerHandle, gameInstance);

    if (!playerHandle)
    {
        return nullptr;
    }

    return reinterpret_cast<RED4ext::ent::Entity*>(playerHandle.instance);
}

// ============================================================
// Native Function: HoverRotPlayer9_1a_DumpComponents
// ============================================================
// Returns: String — all component class names, one per line
// Format: "index|className"

void HoverRotPlayer9_1a_DumpComponentsFunc(RED4ext::IScriptable* aContext,
                                             RED4ext::CStackFrame* aFrame,
                                             RED4ext::CString* aOut,
                                             int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_dumpCompCalls++;

    auto* entity = GetPlayerEntity();
    if (!entity)
    {
        g_errorCount++;
        g_lastError = "DumpComponents: GetPlayer returned null";
        if (aOut) *aOut = RED4ext::CString("ERROR: GetPlayer returned null");
        return;
    }

    // Entity->components is DynArray<Handle<IComponent>> at offset 0xA0
    DynArrayRaw* compsArray = ReadDynArrayAt(entity, 0xA0);
    if (!compsArray || !compsArray->entries)
    {
        g_errorCount++;
        g_lastError = "DumpComponents: components array is null";
        if (aOut) *aOut = RED4ext::CString("ERROR: components array is null");
        return;
    }

    std::ostringstream ss;
    int32_t count = 0;

    // Each Handle<IComponent> is 16 bytes: instance(8) + controlBlock(8)
    for (uint32_t i = 0; i < compsArray->size; i++)
    {
        // Read instance pointer from Handle (first 8 bytes)
        void* instance = ReadPtrAt(
            reinterpret_cast<uint8_t*>(compsArray->entries) + i * 16, 0);

        if (!instance) continue;

        std::string className = GetComponentClassName(instance);
        ss << i << "|" << className << "\n";
        count++;
    }

    g_lastCompCount = count;

    if (g_dumpCompCalls == 1)
    {
        std::ostringstream logSs;
        logSs << "[HoverRotTesterPlayer9_1a] DumpComponents FIRST CALL: " << count << " components";
        LogInfo(logSs.str());
    }

    if (aOut)
    {
        *aOut = RED4ext::CString(ss.str().c_str());
    }
}

// ============================================================
// Native Function: HoverRotPlayer9_1a_DumpSkeleton
// ============================================================
// Returns: String — bone hierarchy with transforms
// Format per line: "boneIndex|boneName|parentIdx|tx|ty|tz|qi|qj|qk|qr"
// If no rig found, returns error message

void HoverRotPlayer9_1a_DumpSkeletonFunc(RED4ext::IScriptable* aContext,
                                           RED4ext::CStackFrame* aFrame,
                                           RED4ext::CString* aOut,
                                           int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_dumpSkelCalls++;

    auto* entity = GetPlayerEntity();
    if (!entity)
    {
        g_errorCount++;
        g_lastError = "DumpSkeleton: GetPlayer returned null";
        if (aOut) *aOut = RED4ext::CString("ERROR: GetPlayer returned null");
        return;
    }

    // Find AnimatedComponent in components array
    DynArrayRaw* compsArray = ReadDynArrayAt(entity, 0xA0);
    if (!compsArray || !compsArray->entries)
    {
        g_errorCount++;
        g_lastError = "DumpSkeleton: components array is null";
        if (aOut) *aOut = RED4ext::CString("ERROR: components array is null");
        return;
    }

    void* animatedComponent = nullptr;
    std::string animCompClassName;

    for (uint32_t i = 0; i < compsArray->size; i++)
    {
        void* instance = ReadPtrAt(
            reinterpret_cast<uint8_t*>(compsArray->entries) + i * 16, 0);

        if (!instance) continue;

        std::string className = GetComponentClassName(instance);

        // Check for AnimatedComponent (may appear as entAnimatedComponent or AnimatedComponent)
        if (className == "entAnimatedComponent" || className == "AnimatedComponent")
        {
            animatedComponent = instance;
            animCompClassName = className;

            // Read rig pointer at offset 0x138 (first 8 bytes of Ref<anim::Rig>)
            void* rigPtr = ReadPtrAt(animatedComponent, 0x138);

            if (rigPtr)
            {               // Found an AnimatedComponent with a loaded rig
                break;
            }
            // If rig is null, keep searching for another AnimatedComponent
        }
    }

    if (!animatedComponent)
    {
        g_errorCount++;
        g_lastError = "DumpSkeleton: no AnimatedComponent found";
        if (aOut) *aOut = RED4ext::CString("ERROR: no AnimatedComponent found in components");
        return;
    }

    // Read rig pointer from AnimatedComponent at offset 0x138
    void* rigPtr = ReadPtrAt(animatedComponent, 0x138);
    if (!rigPtr)
    {
        g_errorCount++;
        g_lastError = "DumpSkeleton: rig pointer is null (resource not loaded?)";
        if (aOut) *aOut = RED4ext::CString("ERROR: rig pointer is null — resource may not be loaded");
        return;
    }

    // Now read rig data using verified offsets
    // boneNames: DynArray<CName> at rig+0x50
    DynArrayRaw* boneNamesArray = ReadDynArrayAt(rigPtr, 0x50);
    if (!boneNamesArray || !boneNamesArray->entries || boneNamesArray->size == 0)
    {
        g_errorCount++;
        g_lastError = "DumpSkeleton: boneNames array is empty or null";
        if (aOut) *aOut = RED4ext::CString("ERROR: boneNames array is empty or null");
        return;
    }

    // parentIndices: int16_t* at rig+0x40
    int16_t* parentIndices = reinterpret_cast<int16_t*>(ReadPtrAt(rigPtr, 0x40));

    // aPoseMS: DynArray<QsTransform> at rig+0xC8 (animated pose in model space)
    DynArrayRaw* aPoseMSArray = ReadDynArrayAt(rigPtr, 0xC8);

    // referencePoseMS: DynArray<QsTransform> at rig+0x60 (reference pose in model space)
    DynArrayRaw* refPoseMSArray = ReadDynArrayAt(rigPtr, 0x60);

    uint32_t boneCount = boneNamesArray->size;
    g_lastBoneCount = static_cast<int32_t>(boneCount);

    std::ostringstream ss;
    ss << "=== Skeleton Dump (" << boneCount << " bones) ===\n";
    ss << "Rig ptr: " << rigPtr << "\n";
    ss << "ParentIndices ptr: " << (parentIndices ? "valid" : "null") << "\n";
    ss << "APoseMS entries: " << (aPoseMSArray ? aPoseMSArray->size : 0) << "\n";
    ss << "RefPoseMS entries: " << (refPoseMSArray ? refPoseMSArray->size : 0) << "\n";
    ss << "---\n";

    for (uint32_t i = 0; i < boneCount; i++)
    {
        // Bone name: CName at boneNamesArray->entries + i * 8
        RED4ext::CName boneName = *reinterpret_cast<RED4ext::CName*>(
            reinterpret_cast<uint8_t*>(boneNamesArray->entries) + i * 8);
        const char* boneNameStr = boneName.ToString();
        std::string name = boneNameStr ? std::string(boneNameStr) : "unknown";

        // Parent index
        int16_t parentIdx = parentIndices ? parentIndices[i] : -1;

        ss << i << "|" << name << "|" << static_cast<int>(parentIdx);

        // Bone transform from aPoseMS (animated pose, model space)
        // Each QsTransform is 0x30 bytes: Translation(Vector4 0x10) + Rotation(Quaternion 0x10) + Scale(Vector4 0x10)
        if (aPoseMSArray && aPoseMSArray->entries && i < aPoseMSArray->size)
        {
            uint8_t* xf = reinterpret_cast<uint8_t*>(aPoseMSArray->entries) + i * 0x30;
            // Translation: floats at offsets 0x00, 0x04, 0x08, 0x0C
            float tx = ReadFloatAt(xf, 0x00);
            float ty = ReadFloatAt(xf, 0x04);
            float tz = ReadFloatAt(xf, 0x08);
            // Rotation: floats at offsets 0x10, 0x14, 0x18, 0x1C
            float qi = ReadFloatAt(xf, 0x10);
            float qj = ReadFloatAt(xf, 0x14);
            float qk = ReadFloatAt(xf, 0x18);
            float qr = ReadFloatAt(xf, 0x1C);

            ss << "|" << tx << "|" << ty << "|" << tz
               << "|" << qi << "|" << qj << "|" << qk << "|" << qr;
        }
        else
        {
            ss << "|0.0|0.0|0.0|0.0|0.0|0.0|1.0"; // identity quaternion
        }

        ss << "\n";
    }

    if (g_dumpSkelCalls == 1)
    {
        std::ostringstream logSs;
        logSs << "[HoverRotTesterPlayer9_1a] DumpSkeleton FIRST CALL: " << boneCount << " bones found";
        LogInfo(logSs.str());
    }

    if (aOut)
    {
        *aOut = RED4ext::CString(ss.str().c_str());
    }
}

// ============================================================
// Native Function: HoverRotPlayer9_1a_DumpEntityTransform
// ============================================================
// Returns: String — entity worldTransform (position + orientation)
// Format: "pos_x|pos_y|pos_z|orient_i|orient_j|orient_k|orient_r"

void HoverRotPlayer9_1a_DumpEntityTransformFunc(RED4ext::IScriptable* aContext,
                                                 RED4ext::CStackFrame* aFrame,
                                                 RED4ext::CString* aOut,
                                                 int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_dumpEntityCalls++;

    auto* entity = GetPlayerEntity();
    if (!entity)
    {
        g_errorCount++;
        g_lastError = "DumpEntityTransform: GetPlayer returned null";
        if (aOut) *aOut = RED4ext::CString("ERROR: GetPlayer returned null");
        return;
    }

    // Entity->transformComponent is IPlacedComponent* at offset 0xB0
    auto* transformComp = entity->transformComponent;
    if (!transformComp)
    {
        g_errorCount++;
        g_lastError = "DumpEntityTransform: transformComponent is null";
        if (aOut) *aOut = RED4ext::CString("ERROR: transformComponent is null");
        return;
    }

    // worldTransform is at offset 0xE0 in IPlacedComponent
    // WorldTransform: Position(WorldPosition 12 bytes) + padding(4 bytes) + Orientation(Quaternion 16 bytes)
    uint8_t* worldTransform = reinterpret_cast<uint8_t*>(&transformComp->worldTransform);

    // Position: FixedPoint x/y/z at offsets 0x00, 0x04, 0x08
    // FixedPoint is int32_t internally — we read raw value and also estimate float
    int32_t posXRaw = *reinterpret_cast<int32_t*>(worldTransform + 0x00);
    int32_t posYRaw = *reinterpret_cast<int32_t*>(worldTransform + 0x04);
    int32_t posZRaw = *reinterpret_cast<int32_t*>(worldTransform + 0x08);

    // Orientation: Quaternion i/j/k/r at offsets 0x10, 0x14, 0x18, 0x1C
    float orientI = ReadFloatAt(worldTransform, 0x10);
    float orientJ = ReadFloatAt(worldTransform, 0x14);
    float orientK = ReadFloatAt(worldTransform, 0x18);
    float orientR = ReadFloatAt(worldTransform, 0x1C);

    std::ostringstream ss;
    ss << "posRaw(" << posXRaw << "," << posYRaw << "," << posZRaw << ")"
       << "|orient(" << orientI << "," << orientJ << "," << orientK << "," << orientR << ")";

    if (g_dumpEntityCalls == 1)
    {
        std::ostringstream logSs;
        logSs << "[HoverRotTesterPlayer9_1a] DumpEntityTransform FIRST CALL: " << ss.str();
        LogInfo(logSs.str());
    }

    if (aOut)
    {
        *aOut = RED4ext::CString(ss.str().c_str());
    }
}

// ============================================================
// Native Function: HoverRotPlayer9_1a_GetStatus
// ============================================================
// Returns: String — plugin diagnostics

void HoverRotPlayer9_1a_GetStatusFunc(RED4ext::IScriptable* aContext,
                                       RED4ext::CStackFrame* aFrame,
                                       RED4ext::CString* aOut,
                                       int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_statusCalls++;

    std::ostringstream ss;
    ss << "plugin=HoverRotTesterPlayer9_1a"
       << "|loaded=true"
       << "|dumpComp=" << g_dumpCompCalls
       << "|dumpSkel=" << g_dumpSkelCalls
       << "|dumpEntity=" << g_dumpEntityCalls
       << "|status=" << g_statusCalls
       << "|errors=" << g_errorCount
       << "|lastBoneCount=" << g_lastBoneCount
       << "|lastCompCount=" << g_lastCompCount
       << "|err=" << g_lastError;

    if (aOut)
    {
        *aOut = RED4ext::CString(ss.str().c_str());
    }
}

// ============================================================
// RTTI Registration
// ============================================================

RED4EXT_C_EXPORT void RED4EXT_CALL RegisterTypes()
{
    // No custom types to register — only global functions
}

RED4EXT_C_EXPORT void RED4EXT_CALL PostRegisterTypes()
{
    auto rtti = RED4ext::CRTTISystem::Get();
    RED4ext::CBaseFunction::Flags flags = {.isNative = true, .isStatic = true};

    // HoverRotPlayer9_1a_DumpComponents() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer9_1a_DumpComponents",
            "HoverRotPlayer9_1a_DumpComponents",
            &HoverRotPlayer9_1a_DumpComponentsFunc);
        func->flags = flags;
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }

    // HoverRotPlayer9_1a_DumpSkeleton() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer9_1a_DumpSkeleton",
            "HoverRotPlayer9_1a_DumpSkeleton",
            &HoverRotPlayer9_1a_DumpSkeletonFunc);
        func->flags = flags;
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }

    // HoverRotPlayer9_1a_DumpEntityTransform() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer9_1a_DumpEntityTransform",
            "HoverRotPlayer9_1a_DumpEntityTransform",
            &HoverRotPlayer9_1a_DumpEntityTransformFunc);
        func->flags = flags;
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }

    // HoverRotPlayer9_1a_GetStatus() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer9_1a_GetStatus",
            "HoverRotPlayer9_1a_GetStatus",
            &HoverRotPlayer9_1a_GetStatusFunc);
        func->flags = flags;
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }
}

// ============================================================
// Plugin Entry Points (v1 API)
// ============================================================

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle,
                                        RED4ext::v1::EMainReason aReason,
                                        const RED4ext::v1::Sdk* aSdk)
{
    switch (aReason)
    {
    case RED4ext::v1::EMainReason::Load:
    {
        g_Handle = aHandle;
        g_Sdk = aSdk;

        LogInfo("[HoverRotTesterPlayer9_1a] ============================================");
        LogInfo("[HoverRotTesterPlayer9_1a] Plugin loaded — diagnostic logging functions");
        LogInfo("[HoverRotTesterPlayer9_1a] 4 native functions: DumpComponents, DumpSkeleton, DumpEntityTransform, GetStatus");
        LogInfo("[HoverRotTesterPlayer9_1a] Bone access: Entity[0xA0]->components->AnimatedComponent[0x138]->Rig[0x50]->boneNames");

        auto rtti = RED4ext::CRTTISystem::Get();
        rtti->AddRegisterCallback(RegisterTypes);
        rtti->AddPostRegisterCallback(PostRegisterTypes);

        LogInfo("[HoverRotTesterPlayer9_1a] RTTI callbacks registered");
        break;
    }
    case RED4ext::v1::EMainReason::Unload:
    {
        LogInfo("[HoverRotTesterPlayer9_1a] Plugin unloading");
        std::ostringstream ss;
        ss << "[HoverRotTesterPlayer9_1a] Final stats: dumpComp=" << g_dumpCompCalls
           << " dumpSkel=" << g_dumpSkelCalls
           << " dumpEntity=" << g_dumpEntityCalls
           << " errors=" << g_errorCount;
        LogInfo(ss.str());
        g_Handle = nullptr;
        g_Sdk = nullptr;
        break;
    }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo)
{
    aInfo->name = L"HoverRotTesterPlayer9_1a";
    aInfo->author = L"Cyberpunk Modding Project";
    aInfo->version = RED4EXT_V1_SEMVER(1, 0, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_LATEST;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1;
}
