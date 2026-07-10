---
type: Mechanic Pattern
title: "Status Effects"
description: "Applying and removing status effects on entities manipulation patterns"
tags: [systems, status, effects]
timestamp: 2026-07-04T00:00:00Z
---

# Status Effects

Applying and removing status effects on entities manipulation patterns.

## Apply/Remove Status Effects

Using StatusEffectSystem to programmatically apply or remove status effects on entities.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:133` | $base: Perks.ApplyStatusEffectOnPlayer |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:200` | $type: ApplyStatusEffectEffector |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:1046` | Observe('StatusEffectSystem', 'ApplyStatusEffect', function(_, target, effect) |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:103` | if StatusEffectSystem.ObjectHasStatusEffect(GetPlayer(), TweakDBID("GameplayRestriction.NoCombat"))  |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/interactionUI.lua:137` | StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), "GameplayRestriction.NoCombat") |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:444` | StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), TweakDBID.new("GameplayRestriction.NoJump"), |
| Immersive Meditations - Dark Future version-23336-4-0-1767955577 | `bin/x64/plugins/cyber_engine_tweaks/mods/Dedrameditate_mod/init.lua:115` | Game.GetStatusEffectSystem():ApplyStatusEffect(Game.GetPlayer():GetEntityID(), "HousingStatusEffect. |
| Immersive Relic English-30028-1-4-1780279387 | `bin/x64/plugins/cyber_engine_tweaks/mods/Immersive Relic/init.lua:247` | local se = safeCall(Game.GetStatusEffectSystem) |

*138 more mods use this pattern.*

## Custom Status Effects

Creating new status effect records via TweakDB with custom durations, effects, and stacking rules.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:105` | BaseStatusEffect.Misoru_ChimpClock: # status effect used to track clock per sec |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:200` | $type: ApplyStatusEffectEffector |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:79` | StatusEffectAdded = EventEmitter.new(), |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:103` | if StatusEffectSystem.ObjectHasStatusEffect(GetPlayer(), TweakDBID("GameplayRestriction.NoCombat"))  |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameUI.lua:950` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:1381` | Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, evt) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/GameUI.lua:947` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:444` | StatusEffectHelper.RemoveStatusEffect(Game.GetPlayer(), TweakDBID.new("GameplayRestriction.NoJump"), |

*192 more mods use this pattern.*

## Effect Triggering

Triggering status effects based on game events, combat states, or environmental conditions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameUI.lua:951` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameUI.lua:950` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:1381` | Observe('NPCPuppet', 'OnStatusEffectApplied', function(self, evt) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/GameUI.lua:947` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:652` | Observe("OverclockListener", "OnStatusEffectApplied", function(this, statusEffect) |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/psiberx/GameUI.lua:950` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/external/GameUI.lua:947` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/Modules/GameUI.lua:956` | Observe('PlayerPuppet', 'OnStatusEffectApplied', function(_, evt) |

*95 more mods use this pattern.*


## Related Concepts

- [Stats System](..//systems/stats.md) — related manipulation pattern
- [Quickhacks](..//combat/quickhacks.md) — related manipulation pattern
