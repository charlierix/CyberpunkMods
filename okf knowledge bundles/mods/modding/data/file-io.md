---
type: Mechanic Pattern
title: File I/O
description: File read/write operations using io.open, io.lines, and os.execute for persistent mod state, logging, and data exchange.
tags: [file-io, persistence, lua, io-open, cet]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

File I/O is the most widespread data persistence mechanism in Cyberpunk 2077 mods. The CET Lua environment provides standard `io` library functions, allowing mods to read and write files within their mod directory. This is used for configuration files, log files, data caching, and inter-mod communication.

### Common Patterns

1. **Read-Write Config Cycle** — Mods open a file in `"r"` mode to load settings, and `"w"` mode to save them. The file handle is closed immediately after use to prevent resource leaks.
2. **Atomic Write via Temp File** — Some mods write to a temporary file first, then rename or copy it to the final path, preventing data corruption if the game crashes mid-write.
3. **Line-by-Line Reading with `io.lines`** — Used for parsing structured text files, CSV data, or log files without loading the entire file into memory.
4. **Append-Mode Logging** — Mods open log files in `"a"` mode to append entries without overwriting previous content.
5. **File Existence Check** — `io.open(path, "r")` followed by a nil check serves as a lightweight file-exists test.
6. **`os.execute` for System Operations** — Used for file deletion, directory listing, or platform-specific commands, though less common due to sandbox restrictions.
7. **Backup and Recovery** — Mods maintain backup copies of data files and fall back to them when the primary file is corrupted or missing.

### Key API Surface

| Function | Purpose |
|----------|---------|
| `io.open(path, mode)` | Open file: `"r"` read, `"w"` write, `"a"` append, `"w+"` read-write |
| `file:read("*all")` | Read entire file contents as a string |
| `file:write(data)` | Write string data to file |
| `file:close()` | Close file handle, flush buffers |
| `io.lines(path)` | Iterator over lines in a file |
| `os.execute(cmd)` | Execute a system command |
| `os.remove(path)` | Delete a file |

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ClockWidget | `lua/ClockWidget-20572.../init.lua` (L132) | `io.open(configPath, "w+")` for settings save; `"r"` for load |
| 0-Engine Pure CET | `lua/0-Engine Pure CET.../modules/Storage.lua` (L15) | Multi-file I/O: primary data, backup, temp file with atomic write pattern |
| Adaptive Traffic Headlights | `lua/Adaptive Traffic Headlights.../modules/settings.lua` (L227) | Multiple JSON config files: modsettings.json, weatherStateSettings.json, vehicleSettings.json |
| CrowdScheduler | `lua/CrowdScheduler-30232.../init.lua` (L202) | `io.open(CONFIG_PATH, "w")` for config.json save/load with corruption guard |
| GameSession | `lua/0-Engine Pure CET.../external/GameSession.lua` (L401) | Session data directory traversal with `io.open` for save state persistence |
| A CET Mod Logger | `lua/A CET Mod Logger.../init.lua` | Logging mod using file I/O for log output |
| Better Vehicle Radio | `lua/Better Vehicle Radio.../modules/util.lua` | Utility functions for file operations |
| Cyberscript Core | `lua/Cyberscript Core.../mod/modules/loader.lua` | Dynamic file loading for mod modules and scripts |
| Enterable Interiors | `lua/Enterable Interiors 2.6.0.../external/GameSession.lua` | Session state persistence via file I/O |
| Equipment-EX Unlocker | `lua/Equipment-Ex unlocker.../libs/flib.lua` | File library helper for config read/write |
| Batch Console Command Executor | `lua/Batch Console Command Executor.../init.lua` | File-based command execution and output logging |

*325 more mods use this pattern*

## Related Concepts

- [SQLite Databases](sqlite-databases.md) — Structured storage alternative to flat files
- [JSON Serialization](json-serialization.md) — Encoding used with file I/O for config persistence
- [Config Persistence](config-persistence.md) — Higher-level config file patterns built on file I/O