---
type: Mechanic Pattern
title: "Targeting System"
description: "Target acquisition, lock-on, and targeting query manipulation patterns"
tags: [systems, targeting]
timestamp: 2026-07-04T00:00:00Z
---

# Targeting System

Target acquisition, lock-on, and targeting query manipulation patterns.

## Target Acquisition

Using GetTargetingSystem to query or modify what entities the player or NPCs are targeting.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:111` | ACM.target = ACM:GetTarget() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/AIControl.lua:89` | followers[TargetingHelper.GetTargetId(targetPuppet)] = targetPuppet |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:448` | -- Use Game.GetTargetingSystem() to find entities in range |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:331` | Game.GetTargetingSystem():GetComponentClosestToCrosshair(Game.GetPlayer(), nil):GetEntity():GetVehic |
| K_O_Cybernetic_Kinematic_System-16917-1-42-1728093225 | `bin/x64/plugins/cyber_engine_tweaks/mods/K_O_Cybernetic_Kinematic_System/init.lua:134` | Observe("TargetingSystem", "OnAimStartBegin", function(this, instigator) |
| Legion THE FIRMWARE-27399-1-1a-1771536241 | `bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/init.lua:239` | local ts = Game.GetTargetingSystem() |
| grappling_hook | `init.lua:355` | function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end |
| jetpack | `init.lua:305` | function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end     -- gametargetingTarg |

*110 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](..//combat/damage-weapons/index.md) — related manipulation pattern
- [Quickhacks](..//combat/quickhacks.md) — related manipulation pattern
