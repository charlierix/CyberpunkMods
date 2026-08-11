// ============================================================
// Main.cpp -- RED4ext Plugin: Executor Validation Hook
// ============================================================
//
// Purpose: Hook BaseScriptableAction::IsPossible to bypass
//   executor validation for drones tagged with CE2_DRONE.
//   This allows spawned drones to be accepted as valid executors
//   for device quickhack actions.
//
// Problem: The device action system's IsPossible() check rejects
//   spawned drones as executors for quickhack actions, even though
//   drones are valid GameObjects (Drone -> ScriptablePuppet ->
//   ScriptableEntity -> GameObject). The check likely fails because
//   drones lack player-specific clearance or capabilities.
//
// Solution: Hook IsPossible to return true when the executor is
//   our CE2_DRONE-tagged drone, bypassing the validation gate.
//
// Deploy: bin/x64/plugins/red4ext/plugins/OrbHackingBridge/OrbHackingBridge.dll
//
// ============================================================

#include <RED4ext/RED4ext.hpp>
#include <Windows.h>
#include <string>

// ============================================================
// Plugin State
// ============================================================

static RED4ext::v1::PluginHandle g_Handle = nullptr;
static const RED4ext::v1::Sdk* g_Sdk = nullptr;
static bool g_IsReady = false;

// ============================================================
// Hook Storage
// ============================================================

static void* g_OriginalIsPossible = nullptr;
static void* g_HookTarget = nullptr; // Set when actual address is known

using IsPossible_t = bool (*)(void* this_, void* executor);

// ============================================================
// Logging Helper
// ============================================================

static void LogInfo(const char* aMessage) {
    if (g_Sdk && g_Sdk->logger && g_Handle) {
        g_Sdk->logger->Info(g_Handle, aMessage);
    }
}

// ============================================================
// Entity Tag Checking
// ============================================================

static bool HasCE2DroneTag(void* executor) {
    if (!executor) return false;

    // TODO: Implement using RED4ext RTTI:
    // auto entity = reinterpret_cast<RED4ext::Entity*>(executor);
    // auto tags = entity->GetTags();
    // for (auto& tag : tags) {
    //     if (tag == RED4ext::CName("CE2_DRONE")) return true;
    // }
    // return false;

    LogInfo("[OrbHackingBridge] HasCE2DroneTag: placeholder returning true");
    return true;
}

// ============================================================
// Hook: IsPossible
// ============================================================

static bool IsPossible_Hook(void* this_, void* executor) {
    if (executor && HasCE2DroneTag(executor)) {
        LogInfo("[OrbHackingBridge] IsPossible: bypassing validation for CE2_DRONE executor");
        return true;
    }

    if (g_OriginalIsPossible) {
        auto original = reinterpret_cast<IsPossible_t>(g_OriginalIsPossible);
        return original(this_, executor);
    }

    return true;
}

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

        LogInfo("[OrbHackingBridge] Plugin loaded -- executor validation hook");

        // Register the IsPossible hook using RED4ext's hooking system.
        //
        // Pattern (pseudo-code, needs actual function address):
        //   auto rtti = RED4ext::CRTTISystem::Get();
        //   auto cls = rtti->GetClass(RED4ext::CName("BaseScriptableAction"));
        //   auto func = cls->GetMethod(RED4ext::CName("IsPossible"));
        //   g_HookTarget = func->GetAddress();
        //   aSdk->hooking->Attach(aHandle, g_HookTarget,
        //                         &IsPossible_Hook, &g_OriginalIsPossible);

        LogInfo("[OrbHackingBridge] IsPossible hook registered (placeholder)");
        g_IsReady = true;
        break;
    }
    case RED4ext::v1::EMainReason::Unload: {
        LogInfo("[OrbHackingBridge] Plugin unloading");

        // Detach hook if it was attached:
        // if (g_HookTarget && aSdk && aSdk->hooking) {
        //     aSdk->hooking->Detach(aHandle, g_HookTarget);
        // }

        g_IsReady = false;
        break;
    }
    }

    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo) {
    aInfo->name = L"OrbHackingBridge";
    aInfo->author = L"CE2";
    aInfo->version = RED4EXT_V1_SEMVER(1, 0, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_LATEST;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports() {
    return RED4EXT_API_VERSION_1;
}
