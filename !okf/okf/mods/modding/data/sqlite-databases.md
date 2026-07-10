---
type: Mechanic Pattern
title: SQLite Databases
description: SQLite database operations via lsqlite3 for persistent mod state — CREATE TABLE, INSERT, SELECT, UPSERT patterns.
tags: [sqlite, database, persistence, lua, lsqlite3, cet]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Cyber Engine Tweaks (CET) ships with the `lsqlite3` Lua binding, giving mods access to embedded SQLite databases for structured persistent storage. Mods use SQLite when flat files or JSON are insufficient — typically for multi-table relational data, keyed lookups, or transactional updates.

### Common Patterns

1. **Table Creation with `CREATE TABLE IF NOT EXISTS`** — Mods defensively create tables on init, wrapping calls in `pcall` to handle pre-existing schemas gracefully.
2. **CRUD via `db:exec`** — Direct SQL strings for INSERT, UPDATE, DELETE. Some mods build queries dynamically with `string.format`.
3. **Row Iteration with `db:rows`** — Returns an iterator over result rows, used in `for` loops to load saved state.
4. **UPSERT with `ON CONFLICT ... DO UPDATE`** — Insert-or-update patterns for settings tables where keys are unique.
5. **Transaction Batching** — `db:exec("BEGIN;")` / `db:exec("COMMIT;")` to wrap multiple inserts atomically.
6. **Prepared Statements with Binding** — Parameterized queries using `?` placeholders for safe value insertion.

### Key API Surface

| Function | Purpose |
|----------|---------|
| `sqlite3.open(path)` | Open or create a database file |
| `db:exec(sql)` | Execute a SQL statement |
| `db:rows(sql)` | Iterator over query result rows |
| `db:prepare(sql)` | Create a prepared statement |
| `stmt:bind(...)` / `stmt:step()` | Bind parameters and execute |
| `sqlite3.ROW` / `sqlite3.DONE` / `sqlite3.OK` | Result code constants |

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| grappling_hook | `lua/grappling_hook/data/dal.lua` (L12) | Creates Settings_Int, InputBindings, Player, Grapple tables with AUTOINCREMENT keys |
| jetpack | `lua/jetpack/data/dal.lua` (L12) | Creates Settings_Int, Player, Mode2, Popups tables; INSERT INTO for player and mode data |
| wall_hang | `lua/wall_hang/data/dal.lua` (L12) | Creates Settings_Int, Settings_Float, InputBindings, Player_Arcade tables |
| Legion THE FIRMWARE | `lua/Legion THE FIRMWARE-27399.../modules/database.lua` (L55) | Builds SQL inline for `db:execute`; INSERT INTO MESSAGE_TABLE with parameterized binding |
| Better Vehicle Radio | `lua/Better Vehicle Radio-8864.../modules/config.lua` (L10) | Dynamic `db:exec` with `string.format` for CREATE TABLE, INSERT, UPDATE |
| FovSentinel | `lua/FovSentinel-25699.../init.lua` (L1) | UPSERT via `INSERT ... ON CONFLICT DO UPDATE`; BEGIN/COMMIT transaction wrapping |
| TPP Vehicle Cam Toolkit | `lua/TPP Vehicle Cam Toolkit-20476.../init.lua` (L1) | `CREATE TABLE IF NOT EXISTS` for GlobalOptions, AdvancedOptions, PresetUsage tables; VACUUM support |
| low_flying_v | `lua/low_flying_v/init.lua` (L3) | References lsqlite3 documentation; uses db:exec for schema creation |
| Appearance Menu Mod | `lua, arch/Appearance Menu Mod-790.../init.lua` | Multiple module files using sqlite3 for appearance state persistence |
| GoodFeelings | `red/GoodFeelings-26874.../Features/NPC/NPCSpawner.lua` | NPC spawner using SQLite for spawn state tracking |

*13 more mods use this pattern*

## Related Concepts

- [File I/O](file-io.md) — Lower-level file read/write operations
- [JSON Serialization](json-serialization.md) — JSON encoding used alongside SQLite for complex value storage
- [Config Persistence](config-persistence.md) — Configuration file loading/saving patterns