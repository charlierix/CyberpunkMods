---
type: Mechanic Pattern
title: CET GetSingleton Access
description: Access native game system singletons and static utility classes via GetSingleton() for runtime interaction.
tags: [cet, lua, singletons, game-systems, api-access]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

`GetSingleton()` returns a reference to a native C++ singleton object or static class, allowing Lua code to call its methods directly. This is the bridge between CET's Lua runtime and the game's internal systems.

**Canonical usage:**

```lua
-- Access game managers
local rpgManager = GetSingleton("gameRPGManager")

-- Access UI system state
local isPreGame = GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()

-- Access math utility classes (Vector4, Quaternion as static methods)
local distance = GetSingleton('Vector4'):Distance(vector1, vector2)
local quat = GetSingleton('Quaternion'):SetAxisAngle(axis_unit, radians)
local transformed = GetSingleton('Quaternion'):Transform(quat, vector)
local interpolated = GetSingleton('Quaternion'):Slerp(from_quat, to_quat, percent)
```

Key characteristics:
- `GetSingleton` is a global CET function, not a Lua standard function
- Returns a userdata object representing the native singleton
- Method calls on the returned object map directly to native C++ methods
- Math types (Vector4, Quaternion, etc.) are accessed as singletons for static/utility methods
- Common targets: `gameRPGManager`, `inkMenuScenario`, `Vector4`, `Quaternion`, `GameTimeSystem`
- The returned object is not garbage-collected; it represents a persistent native instance

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua` | Game session state via singleton access |
| Cyberscript Core | `lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/AIControl.lua` | AI control system singleton access |
| ghost_forward | `lua/ghost_forward/init.lua` (152 lines) | L50: GetSingleton('inkMenuScenario') for pre-game detection |
| grappling_hook | `lua/grappling_hook/core/gameobj_accessor.lua` (525 lines) | L465: GetSingleton("gameRPGManager") for RPG state access |
| jetpack | `lua/jetpack/core/math_vector.lua` (592 lines) | L172: Quaternion:SetAxisAngle; L187: Quaternion:Transform; L222: Quaternion:Slerp |
| low_flying_v | `lua/low_flying_v/core/math_vector.lua` | Math utility singletons for vehicle positioning |
| MagazineReload | `lua/MagazineReload-25511-1-4-1773098387/bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/GameSession.lua` | Game session singleton for reload mechanics |
| Vehicle Customizer | `lua/Vehicle Customizer-19243-3-8-1758040135/bin/x64/plugins/cyber_engine_tweaks/mods/Vehicle Customizer/GameSession.lua` | Vehicle system singleton access |
| GameEntityExaminerTool | `lua/GameEntityExaminerTool-14711-2-2-1757088537/bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua` | Entity inspection via game singletons |
| Sprintware | `lua/Sprintware-29163-1-0-0-1777156169/bin/x64/plugins/cyber_engine_tweaks/mods/sprintware/modules/GameSession.lua` | Game session singleton for sprint tracking |

*91 more mods use this pattern*

## Related Concepts

- [Observe Pattern](observe-pattern.md) — Singletons are frequently accessed inside Observe callbacks
- [Vector Math](vector-math.md) — Vector4 and Quaternion singletons provide static math operations
- [Cron Timers](cron-timers.md) — Singleton state checked in periodic timer callbacks
