---
type: Mechanic Pattern
title: "Callback System"
description: "Event callback registration and game event hook manipulation patterns"
tags: [systems, callbacks]
timestamp: 2026-07-04T00:00:00Z
---

# Callback System

Event callback registration and game event hook manipulation patterns.

## Callback Registration

Registering callbacks for game events via GetCallbackSystem to react to entity, combat, and UI events.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/EventProxy.lua:237` | function EventProxy.RegisterCallback(target, event, callback) |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:513` | Game.GetCallbackSystem():RegisterCallback("Input/Key", config.key_input_event:Target(), config.key_i |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/EventProxy.lua:235` | function EventProxy.RegisterCallback(target, event, callback) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/EventProxy.lua:237` | function EventProxy.RegisterCallback(target, event, callback) |
| Free_Lean-26535-1-4-1767654336 | `bin/x64/plugins/cyber_engine_tweaks/mods/FreeLean/init.lua:506` | local callbackSystem = Game.GetCallbackSystem() |
| Interactive Accessories-22472-1-0-1751421384 | `bin/x64/plugins/cyber_engine_tweaks/mods/InteractiveAccessories/modules/input.lua` | Game.GetCallbackSystem():UnregisterCallback("Input/Key", self.inputListener:Target()) |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/keanuWheeze/inputManager.lua:37` | Game.GetCallbackSystem():RegisterCallback('Input/Key', input.inputListener:Target(), input.inputList |
| Mod My Traffic-24470-1-3-1759967698 | `bin/x64/plugins/cyber_engine_tweaks/mods/Mod My Traffic/init.lua:807` | Game.GetCallbackSystem():UnregisterCallback("Entity/AfterAttach", listener:Target(), listener:Functi |

*231 more mods use this pattern.*

## Event-Driven Mod Architecture

Building complete event-driven mod architectures using callback registration for reactive game logic.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:72` | local function addEventListener(event, callback) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:72` | local function addEventListener(event, callback) |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:72` | local function addEventListener(event, callback) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:72` | local function addEventListener(event, callback) |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/GameSession.lua:72` | local function addEventListener(event, callback) |
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/Modules/GameSession.lua:72` | local function addEventListener(event, callback) |
| Sprintware-29163-1-0-0-1777156169 | `bin/x64/plugins/cyber_engine_tweaks/mods/sprintware/modules/GameSession.lua:72` | local function addEventListener(event, callback) |
| Vehicle Customizer-19243-3-8-1758040135 | `bin/x64/plugins/cyber_engine_tweaks/mods/Vehicle Customizer/GameSession.lua:72` | local function addEventListener(event, callback) |

*83 more mods use this pattern.*


## Related Concepts

- [Delay System](..//systems/delays.md) — related manipulation pattern
