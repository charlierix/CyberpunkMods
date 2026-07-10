---
type: Mechanic Pattern
title: "Settings & Mod Config"
description: "Game settings system, mod configuration, and user preference manipulation patterns"
tags: [ui, settings]
timestamp: 2026-07-04T00:00:00Z
---

# Settings & Mod Config

Game settings system, mod configuration, and user preference manipulation patterns.

## Mod Settings Framework

Using the ModSettings framework to create configurable settings menus for mod users.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameLocale.lua` | return Game.NameToString(Game.GetSettingsSystem():GetVar(languageGroupPath, languageVarName):GetValu |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:422` | local settingsSystem = Game.GetSettingsSystem(); |
| Arasaka HUD-22720-1-0-1752541406 | `bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` | ModSettingsConfig = |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/modules/radio.lua:100` | return Game.GetSettingsSystem():GetVar("/audio/misc", "StreamerMode"):GetValue() |
| CrowdScheduler-30232-0-92-1780508208 | `bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua:89` | -- CRITICAL: Game.GetSettingsSystem():GetVar(group, name) and GetGroup(badPath) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/CorruptNCPDLang.lua:106` | local l = Game.GetSettingsSystem():GetVar("/language", "OnScreen"):GetValue().value |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:1054` | if Game.GetSettingsSystem() then |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:1054` | if Game.GetSettingsSystem() then |

*277 more mods use this pattern.*

## User Preferences

Persisting user preferences and integrating with the game settings system.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameLocale.lua` | return Game.NameToString(Game.GetSettingsSystem():GetVar(languageGroupPath, languageVarName):GetValu |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:422` | local settingsSystem = Game.GetSettingsSystem(); |
| Arasaka HUD-22720-1-0-1752541406 | `bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` | local settings_system = Game.GetSettingsSystem() |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/modules/radio.lua:100` | return Game.GetSettingsSystem():GetVar("/audio/misc", "StreamerMode"):GetValue() |
| CrowdScheduler-30232-0-92-1780508208 | `bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua:89` | -- CRITICAL: Game.GetSettingsSystem():GetVar(group, name) and GetGroup(badPath) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/CorruptNCPDLang.lua:106` | local l = Game.GetSettingsSystem():GetVar("/language", "OnScreen"):GetValue().value |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:1054` | if Game.GetSettingsSystem() then |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:1054` | if Game.GetSettingsSystem() then |

*96 more mods use this pattern.*


## Related Concepts

- [Callback System](..//systems/callbacks.md) — related manipulation pattern
