---
type: Mechanic Pattern
title: "Input & Hotkeys"
description: "Input system, hotkey registration, and control mapping manipulation patterns"
tags: [ui, input, hotkeys]
timestamp: 2026-07-04T00:00:00Z
---

# Input & Hotkeys

Input system, hotkey registration, and control mapping manipulation patterns.

## Hotkey Registration

Registering custom hotkeys via RegisterHotkey to trigger mod-specific actions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Appearance FR-11713-1-0-1703089504 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua:561` | Warn_TargetNpcVehicleHotkey = "Cibler un PNJ ou un véhicule pour définir les touches de raccourci", |
| Appearance Menu Mod - PT-BR-17703-1-2-1753920668 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua:603` | Warn_TargetNpcVehicleHotkey = "Mire em um PNJ ou veículo para definir teclas de atalho", |
| Appearance Menu Mod TR-16957-1-0-1727995593 | `Appearance Menu Mod Trk‡e/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/tr_TR.lua:564` | Warn_TargetNpcVehicleHotkey = "Kisayol Tuslarini Ayarlamak için NPC'yi veya Araci Hedefleyin", |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:69` | veh_input = { key = "veh_input", default_value = EInputKey.IK_F1.value }, |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:479` | registerHotkey("ToggleClock", "Toggle Clock", function() |
| Cyberpunk Glitch FPS-28256-v6-0-1776762686 | `Cyberpunk Glitch FPS/bin/x64/plugins/cyber_engine_tweaks/mods/GlitchFPS/Glitch.lua:109` | toggleHudHint = "Bind it in CET Hotkeys", |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/core.lua:767` | registerHotkey('OpenInteractMenu', 'Open Interact Menu (CET mode)', function() |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:24` | - registerHotkey(): Bind hotkeys |

*139 more mods use this pattern.*

## Input Interception

Intercepting player input events to modify or block default controls and create custom control schemes.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Baronz Chair 2.21 2.3 and 2.31 game versions-24785-1-1-0-1766786868 | `r6/tweaks/oranje3_baronz_chair/oranje3_baronz_chair.yaml:212` | turnUpdateInputDiffForFastChange: 1 |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/EventProxy.lua:96` | local function isGlobalInput(target) |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:215` | function dumpTableToJson(inputTable, isCustomOrder, sortIfNoCustomOrderFound, excludeKeys) |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:621` | ImGui.InputTextMultiline( |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/modules/ui.lua:233` | rgba, changed = ImGui.ColorEdit4("##" .. name, rgba, ImGuiColorEditFlags.NoInputs) |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:212` | ACM.collabTag = ImGui.InputTextWithHint(" ##collabTag", "Modder Tag", ACM.collabTag, 50) |
| Arasaka HUD-22720-1-0-1752541406 | `bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` | local hide_hud_names = { "input_hints", "action_buttons", "healthbar", "vehicle_hud" } |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:453` | registerInput("BatchConsoleExecutorBind", "Execute Keybind Batch Console Commands", function(keypres |

*256 more mods use this pattern.*

## Control Mapping

Modifying control mappings, key bindings, and input-to-action translation.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:571` | ObserveBefore("inkSettingsSelectorControllerKeyBinding", "ListenForInput", function(self) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/inputManager.lua:21` | if input.listeningKeybindWidget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBin |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/keanuWheeze/inputManager.lua:15` | if input.listeningKeybindWidget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBin |
| NC Headphones v1.0-28365-1-0-1774153989 | `NC Headphones release/bin/x64/plugins/cyber_engine_tweaks/mods/Noise Cancelling Headphones/modules/inputManager.lua:15` | if input.listeningKeybindWidget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBin |
| Sprintware-29163-1-0-0-1777156169 | `bin/x64/plugins/cyber_engine_tweaks/mods/sprintware/modules/Input.lua` | Input.listeningKeybindWidget:OnKeyBindingEvent(KeyBindingEvent.new({ keyName = key })) |
| Vehicle Speed Limit-15542-1-2-2-1766933606 | `bin/x64/plugins/cyber_engine_tweaks/mods/VehicleSpeedLimit/modules/keanuWheeze/inputManager.lua:15` | if input.listeningKeybindWidget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBin |
| Drive a Bus-17099-1-2-0-1760190156 | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveBus/init.lua:75` | if DAB.listening_keybind_widget and key:find("IK_Pad") and action == "IACT_Release" then -- OnKeyBin |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/init.lua:151` | if FlyingTank.listening_keybind_widget and key:find("IK_Pad") and action == "IACT_Release" then -- O |

*17 more mods use this pattern.*


## Related Concepts

- [HUD & Menus](..//ui/hud-menus.md) — related manipulation pattern
