---
type: Mechanic Pattern
title: "HUD & Menus"
description: "HUD widgets, menu screens, and ink UI system integration manipulation patterns"
tags: [ui, hud, menus]
timestamp: 2026-07-04T00:00:00Z
---

# HUD & Menus

HUD widgets, menu screens, and ink UI system integration manipulation patterns.

## Ink Widget Creation

Creating custom ink UI widgets, HUD elements, and menu screens via inkWidget API.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/EventProxy.lua:25` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:139` | Game.GetUISystem():QueueEvent(NotifyShardRead.new({ title = head, text = body })) |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:509` | local gameRes = Game.GetUISystem() and Game.GetUISystem():GetCurrentWindowSize() or {X = 1920, Y = 1 |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:531` | inkWidgetRef.SetVisible(self.subText, true) |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:436` | local inkSystem = Game.GetInkSystem() |
| CountdownTimerPatch23-21947-2-3-1749235215 | `bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/init.lua:219` | local inkSystem = GameInstance.GetInkSystem() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/EventProxy.lua:23` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/EventProxy.lua:25` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |

*214 more mods use this pattern.*

## Menu Modification

Modifying existing game menus, adding tabs, changing menu layouts via inkScreen and inkMenuScenario.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:127` | return GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame() |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:439` | local layer = inkSystem:GetLayer(CName.new("inkHUDLayer")) |
| CountdownTimerPatch23-21947-2-3-1749235215 | `bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/init.lua:220` | local hudRoot = inkSystem:GetLayer(CName.new("inkHUDLayer")):GetVirtualWindow() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:127` | return GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame() |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:127` | return GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame() |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:127` | return GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame() |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/GameSession.lua:127` | return GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame() |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/utils.lua:89` | :GetLayer("inkHUDLayer") |

*139 more mods use this pattern.*

## Custom HUD Widgets

Adding custom HUD widgets, compass elements, status indicators, and on-screen overlays.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/EventProxy.lua:25` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:531` | inkWidgetRef.SetVisible(self.subText, true) |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:439` | local layer = inkSystem:GetLayer(CName.new("inkHUDLayer")) |
| CountdownTimerPatch23-21947-2-3-1749235215 | `bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/init.lua:220` | local hudRoot = inkSystem:GetLayer(CName.new("inkHUDLayer")):GetVirtualWindow() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/EventProxy.lua:23` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/EventProxy.lua:25` | ['inkWidget'] = 'sampleUISoundsLogicController::OnPress', |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/roster.lua` | local rosterController = roster.utils.GetGameControllerFromInkLayer("inkHUDLayer", "gameuiWeaponRost |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/utils.lua:89` | :GetLayer("inkHUDLayer") |

*200 more mods use this pattern.*


## Related Concepts

- [Input & Hotkeys](..//ui/input-hotkeys.md) — related manipulation pattern
