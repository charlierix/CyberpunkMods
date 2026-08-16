// HoverRotTesterPlayer7 - RED4ext Plugin
// Hooks the player's per-frame update to override orientation.
//
// This plugin compiles against the RED4ext SDK v1 API.
// The actual hook registration requires proper type information for
// HookManager, GameInstance, and Entity. Once the correct function to
// hook is identified via reverse engineering, uncomment and adapt
// the hook registration code.

#include <RED4ext/RED4ext.hpp>
#include <cstring>
#include <cmath>

// ============================================================
// Local type definitions (not directly in SDK headers)
// ============================================================

// Transform is not a single struct in the SDK - define locally
struct Transform {
    RED4ext::Vector3 position;
    RED4ext::Quaternion orientation;
    RED4ext::Vector3 scale;
};

// Entity is not directly usable - define minimal stub
// In the full SDK, Entity provides GetComponent, GetWorldTransform, SetWorldTransform
struct Entity {
    // These would be virtual methods in the real SDK
    Transform GetWorldTransform() { return Transform{}; }
    void SetWorldTransform(const Transform& t) {}
};

// ============================================================
// Plugin State (v1 API)
// ============================================================

static RED4ext::v1::PluginHandle g_Handle = nullptr;
static const RED4ext::v1::Sdk* g_Sdk = nullptr;
static bool g_IsReady = false;

// Shared rotation state (read from TweakDB, set by CET mod)
struct RotationState {
    bool active = false;
    float pitch = 0.0f;
    float yaw = 0.0f;
    float roll = 0.0f;
    int strategy = 3;
};

static RotationState g_state;
static bool g_hooksRegistered = false;

// ============================================================
// Logging Helper
// ============================================================

static void LogInfo(const char* aMessage) {
    if (g_Sdk && g_Sdk->logger && g_Handle) {
        g_Sdk->logger->Info(g_Handle, aMessage);
    }
}

// ============================================================
// Quaternion math
// ============================================================

static RED4ext::Quaternion EulerToQuat(float pitchDeg, float yawDeg, float rollDeg) {
    float p = pitchDeg * 3.14159265358979323846f / 180.0f * 0.5f;
    float y = yawDeg * 3.14159265358979323846f / 180.0f * 0.5f;
    float r = rollDeg * 3.14159265358979323846f / 180.0f * 0.5f;

    float cp = cosf(p), sp = sinf(p);
    float cy = cosf(y), sy = sinf(y);
    float cr = cosf(r), sr = sinf(r);

    RED4ext::Quaternion q;
    q.r = cr * cp * cy + sr * sp * sy;
    q.i = cr * sp * cy - sr * cp * sy;
    q.j = cr * cp * sy + sr * sp * cy;
    q.k = sr * cp * cy - cr * sp * sy;
    return q;
}

// ============================================================
// Hook: Player Update (Post-hook) - Documentation
// ============================================================

// Post-hook runs AFTER the original function (locomotion clamps orientation).
// We override the orientation with the desired quaternion.
//
// Candidate function names to hook (by CName via reflection):
//   "UpdateTick"                              - Entity per-frame tick
//   "OnUpdate"                                - General entity update
//   "gamePlayerPuppet::OnUpdate"              - Player-specific update
//   "ScriptablePuppet::OnUpdate"              - Scripted puppet update
//   "gamePuppetBase::OnTick"                  - Base puppet tick
//   "gameLocomotionStateMachinePlayer::Update" - Locomotion SM update (most targeted)
//
// Example hook (to be enabled once full SDK types are available):
//
// static void PostUpdateHook(Entity* self, float deltaTime) {
//     if (!g_state.active || g_state.strategy != 3) return;
//     Transform transform = self->GetWorldTransform();
//     transform.orientation = EulerToQuat(g_state.pitch, g_state.yaw, g_state.roll);
//     self->SetWorldTransform(transform);
// }
//
// Alternative: Direct component field write via reflection
//
// Instead of SetWorldTransform (which may be overridden by locomotion),
// write directly to the component's orientation field using CClass/CProperty
// with memory offset. This bypasses any setter logic.
//
// static void WriteOrientationViaReflection(Entity* player) {
//     auto* component = player->GetComponent(RED4ext::CName("entTransformComponent"));
//     if (!component) return;
//     auto* cls = component->GetCClass();
//     if (!cls) return;
//     auto* prop = cls->FindProperty(RED4ext::CName("orientation"));
//     if (!prop) return;
//     uint8_t* ptr = reinterpret_cast<uint8_t*>(component);
//     RED4ext::Quaternion* orientationPtr =
//         reinterpret_cast<RED4ext::Quaternion*>(ptr + prop->offset);
//     *orientationPtr = EulerToQuat(g_state.pitch, g_state.yaw, g_state.roll);
// }

// ============================================================
// Plugin Entry Points (v1 API)
// ============================================================

RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle,
                                        RED4ext::v1::EMainReason aReason,
                                        const RED4ext::v1::Sdk* aSdk) {
    switch (aReason) {
    case RED4ext::v1::EMainReason::Load: {
        g_Handle = aHandle;
        g_Sdk = aSdk;
        g_IsReady = false;

        LogInfo("[HoverRotTesterPlayer7] Plugin loaded -- player orientation hook");

        // Register hooks by CName (reflection-based lookup)
        // Uncomment and adapt once the correct function name is verified
        // and the full SDK types (HookManager, GameInstance, Entity) are available.
        //
        // if (aSdk && aSdk->hooking) {
        //     // aSdk->hooking->Add(aHandle, RED4ext::CName("UpdateTick"),
        //     //                   &PostUpdateHook, &g_OriginalUpdate);
        //     // g_hooksRegistered = true;
        // }

        LogInfo("[HoverRotTesterPlayer7] Hook registration placeholder ready");
        g_IsReady = true;
        break;
    }
    case RED4ext::v1::EMainReason::Unload: {
        LogInfo("[HoverRotTesterPlayer7] Plugin unloading");

        // Remove hooks to prevent crashes
        // if (g_hooksRegistered && aSdk && aSdk->hooking) {
        //     // aSdk->hooking->Remove(aHandle, g_HookTarget);
        //     g_hooksRegistered = false;
        // }

        g_IsReady = false;
        break;
    }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo) {
    aInfo->name = L"HoverRotTesterPlayer7";
    aInfo->author = L"Cyberpunk Modding Project";
    aInfo->version = RED4EXT_V1_SEMVER(1, 0, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_LATEST;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports() {
    return RED4EXT_API_VERSION_1;
}
