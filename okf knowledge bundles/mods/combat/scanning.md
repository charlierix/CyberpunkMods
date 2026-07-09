---
type: Mechanic Pattern
title: "Scanning"
description: "Entity scanner, scan data, and scanner component manipulation patterns"
tags: [combat, scanning]
timestamp: 2026-07-04T00:00:00Z
---

# Scanning

Entity scanner, scan data, and scanner component manipulation patterns.

## Scanner Data Modification

Modifying ScannerData and scanner component output to add custom scan information.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Crowd Scanner Expansion-13470-1-13-1721847600 | `r6/scripts/backgroundScanner/Core/ScannerBackstory.reds` | public func GetType() -> ScannerDataType { |
| Kiroshi Crowd Scanner-1654-1-2-1-1697246253 | `r6/scripts/backgroundScanner/Core/ScannerBackstory.reds` | public func GetType() -> ScannerDataType { |
| Kiroshi Optics - Deep Scan Protocol - 2.3-27018-2-3-1-1777021434 | `r6/scripts/backgroundScanner/Core/ScannerBackstory.reds` | public func GetType() -> ScannerDataType { |

## Scan Visual Customization

Customizing scanner visual effects, scan highlighting, and scan UI elements.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:8` | vfx_hitscan_trail: base\fx\weapons\trails\tech\electric_thermal_chemical\shotgun\w_tech_shotgun_trai |
| The Zenitex Military Store-21735-1-2-1765449267 | `archive/pc/mod/scorpion_zenitex_store.xl` | - base\scorpion_base\zenitex_store\data\localization\zenitex_store_scannable.json |
| void_Modular_Harness-16348-1-1-1725743180 | `r6/tweaks/yellingintothevoid/void_Modular_Harness.yaml:137` | Items.yv_harness_scanner_${base_color}: |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:15` | --     .blackboard.vision.*       scanning, quickhacking flags |
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:6` | BeginItem_TabNameScan = "Scan", |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:5` | BeginItem_TabNameScan = "Escanear", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:6` | BeginItem_TabNameScan = "Tara", |
| Arasaka Hideout - AMM Preset - v0.2-10346-0-2-1698377567 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua:1118` | name = "Hand Scanner a", |

*199 more mods use this pattern.*


## Related Concepts

- [Targeting System](..//systems/targeting.md) — related manipulation pattern
