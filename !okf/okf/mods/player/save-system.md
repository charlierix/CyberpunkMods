---
type: Mechanic Pattern
title: "Save System"
description: "Game session persistence, save/load, and checkpoint management manipulation patterns"
tags: [player, save, system]
timestamp: 2026-07-04T00:00:00Z
---

# Save System

Game session persistence, save/load, and checkpoint management manipulation patterns.

## Session State Persistence

Using GameSession to store and retrieve mod-specific persistent state across save/load cycles.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:27` | --   Engine.GetData / SetData / SaveData / ClearData |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:917` | ObserveBefore('inkISystemRequestsHandler', 'RequestSaveUserSettings', function(this) |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:59` | local function SaveGuiSettings() |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:315` | Settings.SaveWeatherStates() |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:687` | if AMM and AMM.SaveFileFromACM then |
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:10` | Button_SavesAppearance = "Sauvegarder l'apparence", |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:9` | Button_SavesAppearance = "Salvar aparência", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:10` | Button_SavesAppearance = "Görünümü Kaydet", |

*264 more mods use this pattern.*

## Save Event Hooks

Registering callbacks for save/load events to trigger mod logic on session changes.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameUI.lua:618` | ['OnLoadGame'] = 'LoadGame', |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameUI.lua:617` | ['OnLoadGame'] = 'LoadGame', |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/init.lua:8` | GameSession.OnLoad(function() |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/GameUI.lua:614` | ['OnLoadGame'] = 'LoadGame', |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:566` | local function OnSaveLoaded() |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/init.lua:113` | GameSession.OnSave(function() |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/psiberx/GameUI.lua:617` | ['OnLoadGame'] = 'LoadGame', |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/external/GameUI.lua:622` | ['OnLoadGame'] = 'LoadGame', |

*85 more mods use this pattern.*

## Custom Persistent Data

Implementing custom persistent data structures that survive across game sessions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:27` | --   Engine.GetData / SetData / SaveData / ClearData |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:26` | SaveData = 'SaveData', |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:26` | SaveData = 'SaveData', |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:26` | SaveData = 'SaveData', |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/GameSession.lua:26` | SaveData = 'SaveData', |
| Mod My Traffic-24470-1-3-1759967698 | `bin/x64/plugins/cyber_engine_tweaks/mods/Mod My Traffic/init.lua:514` | vehicleEntries, newVehicles = LoadData(dataToSave) |
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/Modules/GameSession.lua:26` | SaveData = 'SaveData', |
| Sprintware-29163-1-0-0-1777156169 | `bin/x64/plugins/cyber_engine_tweaks/mods/sprintware/modules/GameSession.lua:26` | SaveData = 'SaveData', |

*44 more mods use this pattern.*


## Related Concepts

- [Callback System](..//systems/callbacks.md) — related manipulation pattern
