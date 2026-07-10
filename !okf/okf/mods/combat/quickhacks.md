---
type: Mechanic Pattern
title: "Quickhacks"
description: "Quickhack system, hacking abilities, and breach protocol manipulation patterns"
tags: [combat, quickhacks]
timestamp: 2026-07-04T00:00:00Z
---

# Quickhacks

Quickhack system, hacking abilities, and breach protocol manipulation patterns.

## Custom Quickhack Creation

Creating new quickhack abilities via TweakDB QuickhackData records with custom effects and costs.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Quickhack Fixes PTBR-20361-1-2-18-1753242026 | `archive/pc/mod/quickhackfixesPTBR.archive.xl` | extend: Quickhack_Fixes.archive.xl |
| SCOFIL - Luv's Glasses-20890-1-0-1744498194 | `r6/tweaks/Scofil1996/SCOFIL_Luv_Glasses.yaml` | tags: [ScofilCustomLuvGlassesMod, FaceArmor, Stylish, Rich, Clothing, QuickhackUploadMod] |
| quickhack fixes ukr 1.3.3-21785-1-3-3-1780254721 | `archive/pc/mod/quickhack_fixes_ukr.archive.xl` | extend: Quickhack_Fixes.archive.xl |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:15` | --     .blackboard.vision.*       scanning, quickhacking flags |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/gameStatusEffectType.lua` | Quickhack = 49, |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/fact.lua:1676` | [0x00000016AF1EEEEF] = { id = "Items.ContagionProgram", name = "CONTAGION", kind = "Quickhack", qual |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/GameUI.lua:888` | Observe('HUDManager', 'OnQuickHackUIVisibleChanged', function(_, quickhacking) |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/psiberx/GameUI.lua:891` | Observe('HUDManager', 'OnQuickHackUIVisibleChanged', function(_, quickhacking) |

*132 more mods use this pattern.*

## Quickhack Cost & Effect Tuning

Modifying quickhack RAM costs, durations, cooldowns, and effect parameters.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/gamedataStatPoolType.lua` | QuickHackDuration = 30, |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/perks.lua:184` | { alias = "CloudCache", type = "Hacking_Area_07_Perk_2", max = 2, attr = "Intelligence", req = 14, s |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/native_settings_ui.lua:296` | description = "Percentage chance that hacking minigame dialog will play (as long as cooldown is not  |
| ScannerPlus-13165-2-0-2-1774111865 | `bin/x64/plugins/cyber_engine_tweaks/mods/ScannerPlus/init.lua:533` | parts[#parts + 1] = 'HCK ' .. hackStr .. ' RAM' |
| Less Lethal Cops mod | `r6/tweaks/less_lethal_cops/PreventionData.NCPDDataMatrix_inline0.yaml` | hackLoopDurationInGoodSpot: 300 |
| NanoDrone 1.6-3419-1-6-1710086061 | `bin/x64/plugins/cyber_engine_tweaks/mods/nanoDrone/localization/en-us.lua` | ["qh_cost_mult"] = "QuickHack cost multiplier", |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `bin/x64/plugins/cyber_engine_tweaks/mods/CustomHackingSystem/Modules/TweakDBUtils.lua:109` | function API.CreateRemoteBreachQuickhack(quickhackName,gameplayCategory,quickhackInteractionBaseUI,c |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Features/Self/SelfConfig.lua` | ConfigManager.Register("toggle.self.cooldown.quickhack", Self.StatModifiers.Cooldown.toggleQuickhack |

*23 more mods use this pattern.*

## Breach Protocol Modification

Modifying breach protocol minigame mechanics, datamine rewards, and breach sequences.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/Character.valentinos_Boss_ranged3.yaml:132` | - QuickHack.RemoteBreach |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/attributes.lua` | { alias = "Intelligence", type = "Intelligence", min = 3, max = 20, skills = { "BreachProtocol", "Qu |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:52` | toggleHackingMinigame = true, |
| Less Lethal Cops mod | `r6/tweaks/less_lethal_cops/Character.arr_ncpd_police_melee2_baton_ma.yaml:112` | - QuickHack.RemoteBreach |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `bin/x64/plugins/cyber_engine_tweaks/mods/CustomHackingSystem/Modules/HackTemplate.lua` | HackTemplate.lua - How to create a Hacking Minigame and it's programs ? |
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/Perks/perk_intelligence_part3.reds` | if !Equals(evt.minigameState, HackingMinigameState.Succeeded) { |
| Much Better Netrunning | `bin/x64/plugins/cyber_engine_tweaks/mods/BetterNetrunning/nativeSettingsUI.lua:43` | nativeSettings.addSwitch("/BetterNetrunning/Breaching", GetLocKey("DisplayName-BetterNetrunning-EMPU |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds:1047` | @addField(HackingMinigameGameController) |

*19 more mods use this pattern.*


## Related Concepts

- [Status Effects](..//systems/status-effects.md) — related manipulation pattern
- [Targeting System](..//systems/targeting.md) — related manipulation pattern
