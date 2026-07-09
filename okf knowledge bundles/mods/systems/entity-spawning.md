---
type: Mechanic Pattern
title: "Entity Spawning"
description: "DynamicSpawnSystem, entity creation, and NPC spawning manipulation patterns"
tags: [systems, entity, spawning]
timestamp: 2026-07-04T00:00:00Z
---

# Entity Spawning

DynamicSpawnSystem, entity creation, and NPC spawning manipulation patterns.

## Dynamic Spawn System

Using DynamicSpawnSystem and GetDynamicEntitySystem to spawn entities at runtime.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/AIControl.lua:74` | followerRole.followerRef = Game.CreateEntityReference('#player', {}) |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:376` | local entitySystem = Game.GetDynamicEntitySystem() |
| KnockOutChildren_V110.zip-8614-1-1-1701965225 | `bin/x64/plugins/cyber_engine_tweaks/mods/KnockOutChildren/init.lua` | local newNpcEntityID = Game.GetDynamicEntitySystem():CreateEntity(entitySpec) |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnListener.lua` | Game.GetDynamicEntitySystem():DeleteEntity(val.entityID) |
| Mod My Traffic-24470-1-3-1759967698 | `bin/x64/plugins/cyber_engine_tweaks/mods/Mod My Traffic/init.lua:810` | local entitySystem = GameInstance.GetDynamicEntitySystem() |
| gambling-system-pachinko-19889-1-1-4-1765431915 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-pachinko/SpotManager.lua:163` | local dynamicEntitySystem = Game.GetDynamicEntitySystem() |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Modules/director.lua:43` | _entitySystem = _entitySystem or Game.GetDynamicEntitySystem() |
| Cyberpunk Story Quest Fixes | `bin/x64/plugins/cyber_engine_tweaks/mods/anygoodname_cp77_story_quest_fixes/init.lua:663` | moveOnSpline.splineRef = CreateEntityReference("#mq059_speedspline_rayfield_loc_1", {}).reference |

*65 more mods use this pattern.*

## AMM Spawn Framework

Using the Appearance Menu Mod (AMM) spawn framework for placing custom entities and props.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| H10 Food Vendor-21329-2-0-0-1754166718 | `r6/tweaks/H10FoodVendor.yaml:62` | - Items.MediumQualityFood2				# RAMMMMEN |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:8` | -- Load AMM if available -- |
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:105` | Warn_AMMonlyfunctions_ingame = "L'AMM ne fonctionne que dans le jeu", |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:102` | Warn_AMMonlyfunctions_ingame = "O AMM só funciona dentro do jogo", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:105` | Warn_AMMonlyfunctions_ingame = "AMM sadece oyun içinde çalisir", |
| Arasaka Hideout - AMM Preset - v0.2-10346-0-2-1698377567 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua:11` | -- name -> This will be displayed in AMM's Decor tab spawn list. |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/fact.lua:2` | [0x00000010FE92A980] = { id = "Ammo.HandgunAmmo", name = "HANDGUN AMMO", kind = "Ammo", max = 500, c |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:744` | -- Primary method: AITeleportCommand with doNavTest=false (from AMM) |

*25 more mods use this pattern.*

## NPC Spawning

Spawning custom NPCs with specific appearances, equipment, and behaviors.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/housing.lua:10` | local ID = WorldFunctionalTests.SpawnEntity(spawnIteme.ItemPath, spawnTransform, '') |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnUtil.lua:258` | WorldFunctionalTests.SpawnEntity(ent, transform, '') |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:394` | local isV = AMM:GetNPCName(self.fakePuppet) == "V" |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/HolographicValueDisplay.lua:73` | local entityID = Game.GetStaticEntitySystem():SpawnEntity(spec) |
| gambling-system-blackjack-19575-1-1-4-1765431443 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-blackjack/CardEngine.lua:235` | local entityID = Game.GetStaticEntitySystem():SpawnEntity(cardSpec) |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/module/SpawnUtil.lua:280` | WorldFunctionalTests.SpawnEntity(ent, transform, '') |
| Gambling-29866-1-1779352615 | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/HolographicValueDisplay.lua:73` | local entityID = Game.GetStaticEntitySystem():SpawnEntity(spec) |
| Kinda Realistic Flashlight-12559-4-0-0-1774906094 | `bin/x64/plugins/cyber_engine_tweaks/mods/KindaRealisticFlashlight/Libs/Flashlight.lua:343` | Game.GetStaticEntitySystem():SpawnEntity(Flashlight.GetSpawningSpec()) |

*16 more mods use this pattern.*


## Related Concepts

- [NPCs & Puppets](..//world/npcs.md) — related manipulation pattern
- [Entity Lookup](..//systems/entity-lookup.md) — related manipulation pattern
