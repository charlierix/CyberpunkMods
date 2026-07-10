---
type: Mechanic Pattern
title: JSON Serialization
description: JSON encode/decode for settings, data exchange, and state serialization in Cyberpunk 2077 mods.
tags: [json, serialization, persistence, lua, cet]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

CET provides a `json` global library with `json.encode()` and `json.decode()` functions, enabling mods to serialize Lua tables to JSON strings and deserialize JSON back to Lua tables. This is the dominant serialization format for mod configuration, data caching, and inter-mod data exchange.

### Common Patterns

1. **Settings Round-Trip** — Mods encode a default settings table with `json.encode()`, write it to a file on first run, then `json.decode()` the file contents on subsequent loads to restore settings.
2. **Deep Copy via JSON** — Some mods use `json.decode(json.encode(table))` as a quick deep-copy mechanism for Lua tables, avoiding manual recursive copy functions.
3. **Defensive Decode with pcall** — Mods wrap `json.decode()` in `pcall` to handle malformed or corrupted JSON files gracefully, falling back to default settings on failure.
4. **Data File Loading** — Mods bundle `.json` data files with static content (item lists, appearance data, quest configs) and load them at runtime via `io.open` + `json.decode`.
5. **State Serialization for SQLite** — Complex Lua tables are JSON-encoded and stored as TEXT columns in SQLite databases, combining relational structure with flexible document storage.
6. **Inter-Mod Communication** — Mods exchange structured data via JSON files in shared directories, using encode/decode as a lightweight message protocol.

### Key API Surface

| Function | Purpose |
|----------|---------|
| `json.encode(table)` | Serialize a Lua table to a JSON string |
| `json.decode(string)` | Deserialize a JSON string to a Lua table |
| `JSON.encode(table)` | Alternative casing used by some mods |
| `JSON.decode(string)` | Alternative casing used by some mods |
| `cjson.encode(table)` | cjson library variant |
| `cjson.decode(string)` | cjson library variant |

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ClockWidget | `lua/ClockWidget-20572.../init.lua` (L134) | `json.encode(settings)` for save; `json.decode(file:read("*all"))` for load with default fallback |
| Arasaka HUD | `lua/Arasaka HUD-22720.../modules/settings.lua` (L13) | `json.decode(data)` for load; `json.encode(ModSettings)` for save |
| 0-Engine Pure CET | `lua/0-Engine Pure CET.../modules/Storage.lua` (L20) | `pcall(json.decode, content)` with backup file fallback; `json.encode(cache)` for write |
| FreeLean | `lua/Free_Lean-26535.../init.lua` (L30) | `json.encode(FreeLean.settings)` for save; `json.decode(content)` for load |
| gambling-system-pachinko | `lua/gambling-system-pachinko.../JsonData.lua` (L22) | `json.decode(content)` for loading game data from JSON files |
| Cyberscript Core | `lua/Cyberscript Core.../mod/external/json.lua` | Custom JSON library implementation included as bundled dependency |
| Equipment-EX Unlocker | `lua/Equipment-Ex unlocker.../libs/flib.lua` | JSON encode/decode in file library helper for config persistence |
| GPC Weather Control | `lua/GPC Weather Control.../init.lua` | JSON settings file load/save with weather state management |
| grappling_hook | `lua/grappling_hook/data/dal.lua` | JSON-encoded TEXT stored in SQLite columns for complex data |
| GameEntityExaminerTool | `lua/GameEntityExaminerTool.../init.lua` | JSON serialization for entity inspection data export |
| CountdownTimerPatch23 | `lua/CountdownTimerPatch23.../init.lua` | JSON-based timer configuration persistence |
| Cyberpunk Glitch FPS | `lua/Cyberpunk Glitch FPS.../Glitch.lua` | JSON config for FPS overlay settings |

*202 more mods use this pattern*

## Related Concepts

- [File I/O](file-io.md) — File operations used alongside JSON for persistence
- [SQLite Databases](sqlite-databases.md) — SQLite stores JSON-encoded values in TEXT columns
- [Config Persistence](config-persistence.md) — Config files typically use JSON as the serialization format