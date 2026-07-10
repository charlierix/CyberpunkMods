# Data & Utility Patterns

This directory documents data-handling and utility patterns that Cyberpunk 2077 mods use for persistence, serialization, and configuration management.

## Concepts

| Concept | Description | Mod Count |
|---------|-------------|-----------|
| [SQLite Databases](sqlite-databases.md) | SQLite database operations via lsqlite3 — CREATE TABLE, INSERT, SELECT, UPSERT patterns | 23 |
| [File I/O](file-io.md) | File read/write operations using io.open, io.lines, os.execute | 337 |
| [JSON Serialization](json-serialization.md) | JSON encode/decode for settings, data exchange, and state serialization | 214 |
| [Config Persistence](config-persistence.md) | Loading and saving configuration files (config.json, settings.json) with validation | 139 |