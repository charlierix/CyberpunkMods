---
type: Mechanic Pattern
title: "NPCs & Puppets"
description: "NPC spawning, puppet behavior, and entity appearance management manipulation patterns"
tags: [world, npcs]
timestamp: 2026-07-04T00:00:00Z
---

# NPCs & Puppets

NPC spawning, puppet behavior, and entity appearance management manipulation patterns.

## NPC Appearance Modification

Modifying NPC appearance via ScriptedPuppet, entity appearance overrides, and visual customization.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:1037` | Observe('PlayerPuppet', 'OnAction', function(_, action) |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:898` | ObserveAfter('PlayerPuppet', 'OnGameAttached', function(this) |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:232` | request.sourceName = CName.new("PlayerPuppet") |
| Arasaka HUD-22720-1-0-1752541406 | `bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` | ObserveAfter('PlayerPuppet', 'OnGameAttached', function() |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:214` | ---@param this PlayerPuppet |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:368` | ObserveAfter("PlayerPuppet", "OnMakePlayerVisibleAfterSpawn", function(this, evt) |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:563` | ObserveBefore("PlayerPuppet", "OnGameAttached", function(_) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/entities.lua:14941` | ["entity_tweak"] = "Character.Johnny_Puppet_Photomode", |

*360 more mods use this pattern.*

## NPC Behavior Modification

Modifying NPC behavior patterns, AI logic, and interaction mechanics via Redscript overrides.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:31` | - !remove Items.NPCQualityRandomization |
| Emmjay's FF NSFW Threesome Pose Pack - PM 2.3-21744-2-0-1753681489 | `r6/tweaks/emmjay_threesome_nsfw_poses/emmjay_threesome_nsfw_poses.yaml:255` | photo_mode.character.johnnyNPCPoses: *AddPosesMasc |
| FxEffects-11366-2-0-1702367992 | `r6/tweaks/FxCombatTweaks/Fx.WeaponEffects.yaml:144` | npc_vfx_set: WeaponFxPackage.DefaultNPCSet |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:303` | -  !append Items.Base_HMG_NPC_Damage_Stats |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:9` | NPC_vfx_hitscan_trail: base\fx\weapons\trails\tech\electric_thermal_chemical\shotgun\w_tech_shotgun_ |
| The Zenitex Military Store-21735-1-2-1765449267 | `r6/tweaks/scorpiontank/0_scorpion_zenitex_store_vendors.yaml` | - !append TweakDBID("NPCStatPreset.AllDOTImmunity") |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:67` | -- NPCWatcher removed in Pure-CET variant (no RedScript dependency) |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:595` | if target:IsNPC() or target:IsReplacer() then |

*204 more mods use this pattern.*

## Custom NPC Spawning

Spawning custom NPCs with specific appearances, equipment, and behavioral parameters.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1915` | ObserveAfter('ScriptedPuppet', 'OnCommunicationEvent', function(this, evt); |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/TargetingHelper.lua:147` | and not Game['ScriptedPuppet::IsDefeated;GameObject'](target) |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:990` | if entity:IsA('ScriptedPuppet') then |
| KnockOutChildren_V110.zip-8614-1-1-1701965225 | `bin/x64/plugins/cyber_engine_tweaks/mods/KnockOutChildren/init.lua` | ObserveAfter('ScriptedPuppet', 'OnHit', function(this, hitEvent) |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:4884` | local isCompanion = gameObject ~= nil and ScriptedPuppet.IsPlayerCompanion(gameObject) |
| ScannerPlus-13165-2-0-2-1774111865 | `bin/x64/plugins/cyber_engine_tweaks/mods/ScannerPlus/init.lua:289` | if safeIsA(entity, 'NPCPuppet') or safeIsA(entity, 'ScriptedPuppet') then |
| jetpack | `processing/ragdoll.lua:113` | if not ScriptedPuppet.CanRagdoll(entity) then |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:913` | AMM.Spawn:SpawnNPC(spawn) |

*93 more mods use this pattern.*


## Related Concepts

- [Entity Spawning](..//systems/entity-spawning.md) — related manipulation pattern
- [Attitude System](..//systems/attitude.md) — related manipulation pattern
