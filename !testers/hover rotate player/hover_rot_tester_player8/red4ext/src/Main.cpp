// ============================================================
// HoverRotTesterPlayer8 - RED4ext Plugin
// Real implementation of player body rotation via native functions.
//
// Architecture:
//   CET Lua computes quaternion via EulerAngles.new(roll, pitch, yaw):ToQuat()
//   CET calls redscript bridge:ApplyRotation(quat)
//   Redscript calls native HoverRotPlayer8_ApplyRotation(quat)
//   C++ writes quaternion to player transformComponent->worldTransform.Orientation
//
// Native functions registered:
//   HoverRotPlayer8_ApplyRotation(Quaternion) -> Bool
//   HoverRotPlayer8_GetStatus() -> String
//   HoverRotPlayer8_ReadPlayerOrientation() -> String
//
// SDK offsets (verified from SDK headers):
//   ent::Entity->transformComponent:     offset 0xB0
//   IPlacedComponent->worldTransform:    offset 0xE0
//   WorldTransform->Orientation:         offset 0x10 (Quaternion)
//   Total from IPlacedComponent base:    0xF0
// ============================================================

#include <RED4ext/RED4ext.hpp>
#include <RED4ext/Scripting/Natives/ScriptGameInstance.hpp>
#include <RED4ext/Scripting/Natives/entEntity.hpp>
#include <RED4ext/Scripting/Natives/entIPlacedComponent.hpp>
#include <RED4ext/Scripting/Utils.hpp>

#include <string>
#include <sstream>

// ============================================================
// Plugin State
// ============================================================

static RED4ext::v1::PluginHandle g_Handle = nullptr;
static const RED4ext::v1::Sdk* g_Sdk = nullptr;

// Diagnostics counters
static int32_t g_applyCallCount = 0;
static int32_t g_applySuccessCount = 0;
static int32_t g_applyFailCount = 0;
static int32_t g_readCallCount = 0;
static std::string g_lastError = "none";
static float g_lastQuat[4] = {0.0f, 0.0f, 0.0f, 1.0f}; // i, j, k, r

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
// Native Function: HoverRotPlayer8_ApplyRotation
// ============================================================
// Parameters: Quaternion quat
// Returns: Bool (true if written successfully)
//
// Gets the player entity via ExecuteGlobalFunction, casts to
// ent::Entity, accesses transformComponent at offset 0xB0,
// and writes the quaternion to worldTransform.Orientation.

void HoverRotPlayer8_ApplyRotationFunc(RED4ext::IScriptable* aContext,
                                        RED4ext::CStackFrame* aFrame,
                                        bool* aOut,
                                        int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_applyCallCount++;

    // Read Quaternion parameter from the script stack
    RED4ext::Quaternion quat;
    RED4ext::GetParameter(aFrame, &quat);
    aFrame->code++; // skip ParamEnd opcode

    // Store last quaternion for diagnostics
    g_lastQuat[0] = quat.i;
    g_lastQuat[1] = quat.j;
    g_lastQuat[2] = quat.k;
    g_lastQuat[3] = quat.r;

    // Get the player entity via global function
    RED4ext::ScriptGameInstance gameInstance;
    RED4ext::Handle<RED4ext::IScriptable> playerHandle;
    RED4ext::ExecuteGlobalFunction("GetPlayer;GameInstance", &playerHandle, gameInstance);

    if (!playerHandle)
    {
        g_applyFailCount++;
        g_lastError = "GetPlayer returned null";
        if (g_applyCallCount % 60 == 1)
        {
            LogInfo("[HoverRotPlayer8] ApplyRotation: GetPlayer returned null");
        }
        if (aOut) *aOut = false;
        return;
    }

    // Cast player IScriptable to ent::Entity to access transformComponent
    // This works because PlayerPuppet inherits (single inheritance chain)
    // from ent::Entity, so the memory layout is compatible.
    auto entity = reinterpret_cast<RED4ext::ent::Entity*>(playerHandle.instance);
    if (!entity)
    {
        g_applyFailCount++;
        g_lastError = "entity cast failed";
        LogInfo("[HoverRotPlayer8] ApplyRotation: entity cast failed");
        if (aOut) *aOut = false;
        return;
    }

    // Access transformComponent (IPlacedComponent* at offset 0xB0)
    RED4ext::ent::IPlacedComponent* transformComp = entity->transformComponent;
    if (!transformComp)
    {
        g_applyFailCount++;
        g_lastError = "transformComponent is null";
        if (g_applyCallCount % 60 == 1)
        {
            LogInfo("[HoverRotPlayer8] ApplyRotation: transformComponent is null");
        }
        if (aOut) *aOut = false;
        return;
    }

    // Write quaternion directly to worldTransform.Orientation
    // worldTransform is at offset 0xE0 in IPlacedComponent
    // Orientation is at offset 0x10 within WorldTransform
    transformComp->worldTransform.Orientation = quat;

    g_applySuccessCount++;

    // Throttled logging (first call, then every 60 calls ~1 second at 60fps)
    if (g_applyCallCount == 1)
    {
        LogInfo("[HoverRotPlayer8] ApplyRotation: FIRST CALL SUCCESS");
        std::ostringstream ss;
        ss << "[HoverRotPlayer8] quat(i=" << quat.i << " j=" << quat.j
           << " k=" << quat.k << " r=" << quat.r << ")";
        LogInfo(ss.str());
        ss.str("");
        ss << "[HoverRotPlayer8] entity ptr=" << entity
           << " transformComp ptr=" << transformComp;
        LogInfo(ss.str());
    }
    else if (g_applyCallCount % 300 == 0)
    {
        std::ostringstream ss;
        ss << "[HoverRotPlayer8] ApplyRotation #" << g_applyCallCount
           << " | ok=" << g_applySuccessCount
           << " fail=" << g_applyFailCount
           << " | quat(i=" << quat.i << " j=" << quat.j
           << " k=" << quat.k << " r=" << quat.r << ")";
        LogInfo(ss.str());
    }

    if (aOut) *aOut = true;
}

// ============================================================
// Native Function: HoverRotPlayer8_GetStatus
// ============================================================
// Returns: String with diagnostic counters and last error

void HoverRotPlayer8_GetStatusFunc(RED4ext::IScriptable* aContext,
                                    RED4ext::CStackFrame* aFrame,
                                    RED4ext::CString* aOut,
                                    int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    std::ostringstream ss;
    ss << "calls=" << g_applyCallCount
       << " ok=" << g_applySuccessCount
       << " fail=" << g_applyFailCount
       << " reads=" << g_readCallCount
       << " lastQ=(" << g_lastQuat[0] << "," << g_lastQuat[1]
       << "," << g_lastQuat[2] << "," << g_lastQuat[3] << ")"
       << " err=" << g_lastError;

    if (aOut)
    {
        *aOut = RED4ext::CString(ss.str().c_str());
    }
}

// ============================================================
// Native Function: HoverRotPlayer8_ReadPlayerOrientation
// ============================================================
// Returns: String with player current orientation quaternion
// Format: "i=X.XXX j=X.XXX k=X.XXX r=X.XXX"

void HoverRotPlayer8_ReadPlayerOrientationFunc(RED4ext::IScriptable* aContext,
                                                RED4ext::CStackFrame* aFrame,
                                                RED4ext::CString* aOut,
                                                int64_t a4)
{
    RED4EXT_UNUSED_PARAMETER(aContext);
    RED4EXT_UNUSED_PARAMETER(aFrame);
    RED4EXT_UNUSED_PARAMETER(a4);

    g_readCallCount++;

    // Get player
    RED4ext::ScriptGameInstance gameInstance;
    RED4ext::Handle<RED4ext::IScriptable> playerHandle;
    RED4ext::ExecuteGlobalFunction("GetPlayer;GameInstance", &playerHandle, gameInstance);

    if (!playerHandle)
    {
        if (aOut) *aOut = RED4ext::CString("NO_PLAYER");
        return;
    }

    auto entity = reinterpret_cast<RED4ext::ent::Entity*>(playerHandle.instance);
    if (!entity || !entity->transformComponent)
    {
        if (aOut) *aOut = RED4ext::CString("NO_TRANSFORM");
        return;
    }

    // Read current orientation from worldTransform
    auto& orient = entity->transformComponent->worldTransform.Orientation;
    std::ostringstream ss;
    ss << "i=" << orient.i
       << " j=" << orient.j
       << " k=" << orient.k
       << " r=" << orient.r;

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

    // HoverRotPlayer8_ApplyRotation(Quaternion) -> Bool
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer8_ApplyRotation",
            "HoverRotPlayer8_ApplyRotation",
            &HoverRotPlayer8_ApplyRotationFunc);
        func->flags = flags;
        func->AddParam("Quaternion", "quat");
        func->SetReturnType("Bool");
        rtti->RegisterFunction(func);
    }

    // HoverRotPlayer8_GetStatus() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer8_GetStatus",
            "HoverRotPlayer8_GetStatus",
            &HoverRotPlayer8_GetStatusFunc);
        func->flags = flags;
        func->SetReturnType("String");
        rtti->RegisterFunction(func);
    }

    // HoverRotPlayer8_ReadPlayerOrientation() -> String
    {
        auto func = RED4ext::CGlobalFunction::Create(
            "HoverRotPlayer8_ReadPlayerOrientation",
            "HoverRotPlayer8_ReadPlayerOrientation",
            &HoverRotPlayer8_ReadPlayerOrientationFunc);
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

        LogInfo("[HoverRotTesterPlayer8] ============================================");
        LogInfo("[HoverRotTesterPlayer8] Plugin loaded — native rotation functions");
        LogInfo("[HoverRotTesterPlayer8] 3 native functions: ApplyRotation, GetStatus, ReadPlayerOrientation");
        LogInfo("[HoverRotTesterPlayer8] Transform write: Entity[0xB0]->IPlacedComponent[0xE0]->WorldTransform[0x10]->Quaternion");

        auto rtti = RED4ext::CRTTISystem::Get();
        rtti->AddRegisterCallback(RegisterTypes);
        rtti->AddPostRegisterCallback(PostRegisterTypes);

        LogInfo("[HoverRotTesterPlayer8] RTTI callbacks registered");
        break;
    }
    case RED4ext::v1::EMainReason::Unload:
    {
        LogInfo("[HoverRotTesterPlayer8] Plugin unloading");
        std::ostringstream ss;
        ss << "[HoverRotTesterPlayer8] Final stats: "
           << g_applyCallCount << " calls, "
           << g_applySuccessCount << " success, "
           << g_applyFailCount << " fail, "
           << g_readCallCount << " reads";
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
    aInfo->name = L"HoverRotTesterPlayer8";
    aInfo->author = L"Cyberpunk Modding Project";
    aInfo->version = RED4EXT_V1_SEMVER(1, 0, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_LATEST;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1;
}
