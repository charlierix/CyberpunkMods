---
type: Mechanic Pattern
title: "Mappins"
description: "Map markers, quest mappins, and navigation point system manipulation patterns"
tags: [world, mappins]
timestamp: 2026-07-04T00:00:00Z
---

# Mappins

Map markers, quest mappins, and navigation point system manipulation patterns.

## Mappin Creation

Creating custom map markers, quest waypoints, and navigation points via GetMappinSystem.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Ashfold's Treasures - Balanced (1.2)-19812-1-2-1740999564 | `r6/tweaks/vxl_ashfoldWardrobes_b_tta/Ashfold_Wardrobe_B_TTA.yml` | #Mappin icon on maps |
| Chill Heywood Apartment - Main File-26263-1-0-3-1776030342 | `r6/tweaks/DP77/DP77_Chill_Heywood_Apartment_VendorsXL.yaml` | #Mappin icon on maps, default: Clothing |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/multiAuthor_ncpride_vendorA_tta.yml` | #Mappin icon on maps |
| Gomorrah Standalone-23350-2-0-1778351476 | `r6/tweaks/##########VendorsXL/Urmland_Street_Changes.yaml` | #Mappin icon on maps, default: Clothing |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1096` | local function updateMappinsVisibility(this) |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:63` | function BuildMappings() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:823` | ["helperTitle"] = "Map : Set Mappin", |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/init.lua:15` | function AddToMapPinDB(tweakDBToGet, MappinToAdd) |

*114 more mods use this pattern.*

## Mappin Visibility

Modifying mappin visibility, quest marker display rules, and navigation UI behavior.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Minimap Widgets CHS v0.3 For 2.6.1-22419-0-3-1754618618 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/localization/zh-cn.lua:287` | menu_title_ShowMappin = "扩展地图标记", |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:18` | ShowMappins = false, |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:18` | ShowMappins = false, |
| CyberTrials-16094-2-31-1761092030 | `bin/x64/plugins/cyber_engine_tweaks/mods/CyberTrials/init.lua:434` | Observe("WorldMapMenuGameController", "ShowMappinTooltip", function (this, controller) |
| Metro System 1.92-3560-1-92-1699051271 | `bin/x64/plugins/cyber_engine_tweaks/mods/trainSystem/modules/utils/observers.lua:59` | if not nodeData:ShouldShowMappinOnWorldMap() then |
| Metro rE3worked 0.2.2-8476-0-2-2-1701185866 | `bin/x64/plugins/cyber_engine_tweaks/mods/trainSystem/modules/utils/observers.lua:59` | if not nodeData:ShouldShowMappinOnWorldMap() then |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds:19483` | public native class gameeventsToggleStealthMappinVisibilityEvent extends Event { |
| BetterFuelSystem-26393-1-4-1774621486 | `bin/x64/plugins/cyber_engine_tweaks/mods/BetterFuelSystem/modules/GasStationMarkers.lua:268` | if ms.SetMappinVisibility then |

*5 more mods use this pattern.*


## Related Concepts

- [Quest System](..//systems/quest-system.md) — related manipulation pattern
