#pragma once

// ============================================================
// OrbHackingBridge.hpp -- Executor Validation Hook Support
// ============================================================
//
// Provides helper functions for the IsPossible hook.
// The main hook logic is in Main.cpp.
//
// ============================================================

#include <string>
#include <cstdint>

class OrbHackingBridge {
public:
    static bool HasCE2DroneTag(void* entity);
    static std::string GetEntityInfo(void* entity);
    static uint64_t GetEntityID(void* entity);
};
