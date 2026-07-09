---
type: Mechanic Pattern
title: "Crowd & Traffic"
description: "Pedestrian crowd density, traffic spawning, and ambient life manipulation patterns"
tags: [world, crowd, traffic]
timestamp: 2026-07-04T00:00:00Z
---

# Crowd & Traffic

Pedestrian crowd density, traffic spawning, and ambient life manipulation patterns.

## Crowd Density

Modifying pedestrian crowd density, spawn rates, and ambient life population.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:403` | or not vehicle:IsCrowdVehicle() |
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/Character.valentinos_Boss_ranged3.yaml:17` | crowdMemberSettings: Crowds.DefaultCrowdPackage |
| CrowdScheduler-30232-0-92-1780508208 | `bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua:2` | Crowd Scheduler for Cyberpunk 2077 |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:3820` | ["item"] = "Items.crowd_cigarette_i_stick", |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:909` | "citizen", "civilian", "crowd", "child", "corpo_worker", |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:18` | local isLightCrowd = nil |
| Legion THE FIRMWARE-27399-1-1a-1771536241 | `bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/init.lua:275` | -- Always skip civilians and crowd NPCs (regardless of smart targeting) |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:4889` | if not MinimapWidgetsConfig.ShowEnemies and this.isAlive and attitude ~= Enum.new('EAIAttitude', 'AI |

*92 more mods use this pattern.*

## Traffic Spawning

Modifying vehicle traffic spawning, traffic patterns, and vehicle AI behavior.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Batcycle Archive XL-14088-1-1-1715404706 | `r6/tweaks/ezio_archive_xl/batcycle_babs.yaml` | traffic_audio_resource: v_mbike_yaiba_asmx_kusanagi_traffic |
| Yaiba Kusanagi Persona Archive XL-13944-1-1-1712470624 | `r6/tweaks/ezio_archive_xl/yaiba_kusanagi_persona.yaml` | traffic_audio_resource: v_mbike_yaiba_asmx_kusanagi_traffic |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:78` | print("[AdaptiveTrafficHeadlights] Vehicles and Headlights config loaded and ready.") |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:76` | ["vehicle_add_to_traffic"] = { |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:419` | GameOptions.SetBool('Traffic', 'StopSpawn', false) |
| Legion THE FIRMWARE-27399-1-1a-1771536241 | `bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/modules/utils.lua` | local joinTrafficCommand = AIVehicleJoinTrafficCommand.new() |
| Mod My Traffic-24470-1-3-1759967698 | `bin/x64/plugins/cyber_engine_tweaks/mods/Mod My Traffic/init.lua:22` | local vehicleEntries = {} -- vehicle entries we have configured to act as replacements for traffic v |
| No More Duplicate Vehicles-24064-1-0-1-1757288024 | `bin/x64/plugins/cyber_engine_tweaks/mods/No More Duplicate Vehicles/init.lua:403` | local description = "This setting controls how duplicate vehicles in traffic are swapped to a new ap |

*65 more mods use this pattern.*

## Ambient Behavior

Modifying pedestrian behavior patterns, ambient NPC routines, and crowd reaction systems.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:663` | Label_PedestrianHit = "Piéton renversé", |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:716` | Label_PedestrianHit = "Pedestre atingido", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:667` | Label_PedestrianHit = "Yaya Vurulmasi", |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/entities.lua:30291` | ["entity_entpath"] = "base\\quest\\main_quests\\prologue\\q004\\characters\\bd_tutorial_npcs\\q004_b |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:910` | "pedestrian", "bystander", "police", "ncpd", |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:2821` | {label = AMM.LocalizableString("Label_PedestrianHit"), param = "pedestrian_hit"}, |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds:37794` | public static func GetInnerShapesPedestrianCrossingPath() -> CName = n"inner_shapes_pedestrian_cross |
| Night City Motorsports-28713-2-0-1776645682 | `release2.0/bin/x64/plugins/cyber_engine_tweaks/mods/MT_Ecosystem/modules/settings.lua:336` | ns.addSwitch(path .. "/racing", "Suppress Traffic During Races", "Clears ambient traffic and pedestr |

*12 more mods use this pattern.*


## Related Concepts

- [NPCs & Puppets](..//world/npcs.md) — related manipulation pattern
- [Vehicle Systems](..//world/vehicle-systems/index.md) — related manipulation pattern
