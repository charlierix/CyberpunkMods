---
type: Mechanic Pattern
title: Config Persistence
description: Loading and saving configuration files (config.json, settings.json) with validation, defaults, and corruption recovery.
tags: [config, persistence, settings, lua, cet, json]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Configuration persistence is the mechanism by which mods save user preferences and settings between game sessions. Most CET mods store configuration as JSON files in their mod directory, using `io.open` for file access and `json.encode`/`json.decode` for serialization. The pattern is nearly universal: load on init, save on change or shutdown.

### Common Patterns

1. **Default-First Init** — On first run, mods detect the absence of a config file and write a default configuration. Subsequent loads read the file and merge/validate against built-in defaults.
2. **Load-on-Init, Save-on-Change** — Config is loaded during `onInit` and saved whenever the user modifies settings via an overlay or native settings UI. Some mods also save on `onShutdown`.
3. **Clamp and Validate** — Loaded values are clamped to valid ranges to prevent corrupted or hand-edited configs from injecting out-of-bounds data. Unknown fields are ignored, not injected.
4. **Multiple Config Files** — Complex mods split configuration across multiple files (e.g., `modsettings.json`, `weatherStateSettings.json`, `vehicleSettings.json`) to separate concerns.
5. **Corruption Recovery** — Mods wrap config loading in `pcall` to catch JSON parse errors, falling back to defaults if the file is corrupted. Some maintain backup files.
6. **Named Config Paths** — Mods define a local constant like `CONFIG_PATH = "config.json"` that resolves relative to the mod's CET directory, keeping the path logic centralized.
7. **Native Settings Integration** — Mods using the `nativeSettings` API register options that map directly to the persisted config file, providing a native game menu interface.

### Key API Surface

| Function | Purpose |
|----------|---------|
| `io.open(path, "r")` | Read config file |
| `io.open(path, "w")` | Write config file |
| `json.encode(config)` | Serialize settings table to JSON |
| `json.decode(content)` | Deserialize JSON to settings table |
| `pcall(json.decode, ...)` | Safe decode with error handling |
| `nativeSettings.add*()` | Register native game menu options |

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| CrowdScheduler | `lua/CrowdScheduler-30232.../init.lua` (L169) | `CONFIG_PATH = "config.json"` with clamp/validate on load; corruption guard for hand-edited files |
| Adaptive Traffic Headlights | `lua/Adaptive Traffic Headlights.../modules/settings.lua` (L227) | Multiple config files: `modsettings.json`, `weatherStateSettings.json`, `vehicleSettings.json` |
| FreeLean | `lua/Free_Lean-26535.../init.lua` (L25) | `settingsFile = "settings.json"` with JSON encode/decode for save/load |
| GPC Weather Control | `lua/GPC Weather Control.../init.lua` (L82) | `io.open("settings.json", "r")` for load; `"w+"` for save with weather state management |
| Immersive Relic | `lua/Immersive Relic English.../settings.lua` (L11) | `configpath = "usersettings.json"` for user-configurable settings |
| Legion THE FIRMWARE | `lua/Legion THE FIRMWARE.../modules/config.lua` (L18) | Creates `config.json` on first run with error logging for open/write failures |
| ClockWidget | `lua/ClockWidget-20572.../init.lua` (L132) | `io.open(configPath, "w+")` for settings save with JSON round-trip |
| 3D World Map Explorer | `lua/3D World Map Explorer.../init.lua` | Config persistence for map exploration settings |
| Batch Console Command Executor | `lua/Batch Console Command Executor.../init.lua` | Config file for saved console commands |
| Equipment-EX Unlocker | `lua/Equipment-Ex unlocker.../init.lua` | Config integration with EquipmentEX wardrobe system |
| NC Headphones | `lua/NC Headphones v1.0.../modules/settings.lua` | Settings module for noise cancelling headphone config |
| Minimap Widgets | `lua/Minimap Widgets.../init.lua` | Config persistence for minimap widget preferences |
| Improved Neon Rims Controls | `lua/Improved Neon Rims Controls.../modules/settingsMenu.lua` | Settings menu module for neon rim configuration |

*125 more mods use this pattern*

## Related Concepts

- [File I/O](file-io.md) — Low-level file operations underlying config persistence
- [JSON Serialization](json-serialization.md) — JSON encode/decode used for config file format
- [SQLite Databases](sqlite-databases.md) — Some mods use SQLite instead of JSON files for config storage