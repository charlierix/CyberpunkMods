---
type: Mechanic Pattern
title: "Photo Mode"
description: "Photo mode system, pose packs, and screenshot control manipulation patterns"
tags: [ui, photomode]
timestamp: 2026-07-04T00:00:00Z
---

# Photo Mode

Photo mode system, pose packs, and screenshot control manipulation patterns.

## Pose Pack Creation

Creating custom photo mode pose packs with new character poses and expressions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Emmjay's FF NSFW Threesome Pose Pack - PM 2.3-21744-2-0-1753681489 | `r6/tweaks/emmjay_threesome_nsfw_poses/emmjay_threesome_nsfw_poses.yaml:1` | PhotoModePoseCategories.EmmjayNSFWPoses: |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:134` | local blackboardPM = Game.GetBlackboardSystem():Get(blackboardDefs.PhotoMode) |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1818` | Observe("gameuiPhotoModeMenuController", "OnPhotoModeLastInputDeviceEvent", function(this, wasKeyboa |
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:303` | Warn_DisableLookAtCamera_PhotoMode_Info = "Désactiver l'option 'Regarder l'appareil photo' en mode p |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:250` | BeginItem_TabPhotoModeNibblesReplacer = "Substituidor da Carequinha no Modo Fotografia", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:236` | BeginItem_TabPhotoModeNibblesReplacer = "Fotograf Modu Nibbles Replacer", |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/modules/util.lua` | local photo_mode_def = all_script_definitions.PhotoMode |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:186` | local photoModeBB = bbSystem:Get(GetAllBlackboardDefs().PhotoMode) |

*113 more mods use this pattern.*

## Photo Mode Settings

Modifying photo mode camera settings, effects, and UI options.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Arasaka Elite Ninja-27459-1-0-1770766524 | `archive/pc/mod/PHNTM_Arasaka_Elite_Ninja.xl` | a0_003_wa__mantisblade_photomode_upperarm_left: {hide: [0]} |
| Arasaka Elite Soldier-26758-1-2-1770784590 | `archive/pc/mod/PHNTM_Arasaka_Elite_Soldier.xl` | a0_003_wa__mantisblade_photomode_upperarm_left: {hide: [0]} |
| Emmjay's FF NSFW Threesome Pose Pack - PM 2.3-21744-2-0-1753681489 | `archive/pc/mod/emmjay_threesome_nsfw_poses.xl` | - entity: base\characters\entities\player\photo_mode\player_wa_photomode.ent |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:134` | local blackboardPM = Game.GetBlackboardSystem():Get(blackboardDefs.PhotoMode) |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1818` | Observe("gameuiPhotoModeMenuController", "OnPhotoModeLastInputDeviceEvent", function(this, wasKeyboa |
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:303` | Warn_DisableLookAtCamera_PhotoMode_Info = "Désactiver l'option 'Regarder l'appareil photo' en mode p |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:250` | BeginItem_TabPhotoModeNibblesReplacer = "Substituidor da Carequinha no Modo Fotografia", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:236` | BeginItem_TabPhotoModeNibblesReplacer = "Fotograf Modu Nibbles Replacer", |

*123 more mods use this pattern.*


## Related Concepts

- [Camera](..//ui/camera.md) — related manipulation pattern
