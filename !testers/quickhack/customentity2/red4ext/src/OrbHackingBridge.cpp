// ============================================================
// OrbHackingBridge.cpp -- Executor Validation Hook Support
// ============================================================

#include "OrbHackingBridge.hpp"
#include <sstream>

bool OrbHackingBridge::HasCE2DroneTag(void* entity) {
    if (!entity) return false;

    // TODO: Implement with RED4ext RTTI:
    // auto ent = reinterpret_cast<RED4ext::Entity*>(entity);
    // auto tags = ent->GetTags();
    // for (uint32_t i = 0; i < tags.size; i++) {
    //     if (tags[i] == RED4ext::CName("CE2_DRONE")) return true;
    // }
    // return false;

    // Placeholder: always return true
    return true;
}

std::string OrbHackingBridge::GetEntityInfo(void* entity) {
    if (!entity) return "NULL";
    return "ENTITY_INFO_UNAVAILABLE";
}

uint64_t OrbHackingBridge::GetEntityID(void* entity) {
    if (!entity) return 0;
    // TODO: return reinterpret_cast<RED4ext::Entity*>(entity)->GetEntityID();
    return 0;
}
