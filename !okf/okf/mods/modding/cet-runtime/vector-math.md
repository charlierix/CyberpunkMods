---
type: Mechanic Pattern
title: CET Vector and Quaternion Math
description: Use native Vector4, Vector3, Quaternion, and EulerAngles types for spatial computation, transforms, and rotation.
tags: [cet, lua, math, vector4, vector3, quaternion, eulerAngles, transforms]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

CET exposes native REDengine math types as Lua-accessible userdata objects. These types are fundamental for any mod that manipulates entity positions, camera angles, rotations, or spatial relationships.

**Canonical usage:**

```lua
-- Construct vectors
local pos = Vector4.new(x, y, z, 1.0)  -- w=1 for positions, w=0 for directions
local angle = EulerAngles.new(0, 0, yaw)  -- roll, pitch, yaw in degrees

-- Vector operations via singleton
local dist = GetSingleton('Vector4'):Distance(pos1, pos2)

-- Quaternion operations
local axis = Vector4.new(0, 1, 0, 0)  -- up axis
local rotQuat = GetSingleton('Quaternion'):SetAxisAngle(axis, radians)
local rotated = GetSingleton('Quaternion'):Transform(rotQuat, pos)
local blended = GetSingleton('Quaternion'):Slerp(q1, q2, 0.5)  -- spherical interpolation

-- Teleport with EulerAngles for orientation
teleport:Teleport(player, pos, EulerAngles.new(0, 0, yaw))

-- Camera positioning
o:SetLocalCamPosition(Vector4.new(0, 0, 0, 1))

-- Animation curve keyframe points
table.insert(points, Vector4.new(time, value, 0, 1))
```

Key characteristics:
- `Vector4.new(x, y, z, w)` — w=1 for positions, w=0 for direction vectors
- `Vector3.new(x, y, z)` — 3-component variant, less common than Vector4
- `EulerAngles.new(roll, pitch, yaw)` — rotation in degrees (note: roll, pitch, yaw order)
- `Quaternion` — accessed as singleton for static methods (SetAxisAngle, Transform, Slerp)
- Quaternion methods use out-parameter pattern converted to return values by CET
- Vector math is frequently combined with Observe hooks and Cron timers for frame-by-frame updates
- These are value types; modifications create new instances rather than mutating in place

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua` | Vector operations for engine core utilities |
| Arrest | `lua/Arrest-22114-1-0-4-1755437024/Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua` | Vector4 for arrest positioning and teleport |
| EnemyMultipier | `lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua` | Vector math for enemy spawn positioning |
| Enterable Interiors 2.6.0 | `lua/Enterable Interiors 2.6.0-13209-2-6-0-1763996310/bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/init.lua` | Vector4 for interior teleport coordinates |
| ghost_forward | `lua/ghost_forward/init.lua` (152 lines) | L79: EulerAngles.new for teleport yaw; L145: Vector4.new for camera position |
| grappling_hook | `lua/grappling_hook/core/animation_curve.lua` (195 lines) | L133: Vector4.new for animation keyframe points |
| jetpack | `lua/jetpack/core/animation_curve.lua` (195 lines) | L133: Vector4.new for animation keyframe points |
| GameEntityExaminerTool | `lua/GameEntityExaminerTool-14711-2-2-1757088537/bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua` | Vector math for entity examination positioning |
| MarmurBank V-1-0-5.zip | `lua/MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719/bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/external/Util.lua` | Vector operations for bank location utilities |
| Simple_CET_Teleport_Manager | `lua/Simple_CET_Teleport_Manager-23248-1-5-1756182210/bin/x64/plugins/cyber_engine_tweaks/mods/Simple_CET_Teleport_Manager/init.lua` | Vector4 and EulerAngles for teleport management |

*71 more mods use this pattern*

## Related Concepts

- [Observe Pattern](observe-pattern.md) — Vector math often used inside Observe callbacks for position manipulation
- [Singleton Access](singleton-access.md) — Quaternion and Vector4 singletons provide static math operations
- [Cron Timers](cron-timers.md) — Vector interpolation driven by periodic timer callbacks
