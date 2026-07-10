---
type: Mechanic Pattern
title: Lua String Operations
description: Text processing using string.match, string.find, string.gsub, and string.format for parsing, formatting, and data transformation in CET mods.
tags: [lua, cet, string, formatting, parsing, regex, pattern-matching]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Lua's string library provides lightweight pattern matching and formatting capabilities used extensively across CET mods. Unlike full regex, Lua patterns use a simplified syntax (`%d`, `%a`, `%w`, `.*`, `+`, `-`) that covers most practical text processing needs without external dependencies.

**Common operations:**

```lua
-- Formatting log messages and UI text
local msg = string.format("[%s] %s: %s", level, tag, message)

-- Pattern matching for version/path detection
if string.find(path:lower(), "v002") then ... end

-- Substitution for data cleanup
local cleaned = string.gsub(input, " ", "")

-- Capture groups for parsing
local key, val = string.match(line, "^(%S+)%s*=%s*(.+)$")
```

Key characteristics:
- `string.format` is the most common call, used for log messages, UI labels, and debug output
- `string.gsub` handles text cleanup, path normalization, and template substitution
- `string.find` performs substring and pattern search, often case-insensitive via `:lower()`
- `string.match` extracts captures from structured text (config lines, serialized data)
- Lua patterns differ from regex: `%d` not `\d`, `.*` is greedy, `.-` is lazy, no alternation
- `string.format` specifiers: `%s` strings, `%d` integers, `%02d` zero-padded, `%q` quoted

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `mods/lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua` (L1065) | `string.format('[%q] = ', k)` for table key serialization |
| A CET Mod Logger | `mods/lua/A CET Mod Logger-23208-1-5-1755463327/bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua` (L1204) | `string.format("[CETModLogger] %s: %s", key, tostring(value))` for log output |
| Adaptive Traffic Headlights | `mods/lua/Adaptive Traffic Headlights-24020-2-1-0-1758756478/bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua` (L542) | `string.find(path:lower(), "v002")` for version-specific code paths |
| Appearance Creator Mod | `mods/lua/Appearance Creator Mod-10795-1-0-1-1699493978/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/External/BigNum.lua` (L985) | `string.gsub(num, " ", "")` for whitespace removal in numeric parsing |
| Arasaka HUD | `mods/lua/Arasaka HUD-22720-1-0-1752541406/bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` (L123) | `string.format("Initializing %s (%s) by Ripperdoc.", ...)` for startup logging |
| ClockWidget | `mods/lua/ClockWidget-20572-1-6-1781010500/bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua` (L765) | `string.format("[ClockWidget DBG] Camera State Check -> ...")` for debug output |
| CountdownTimerPatch23 | `mods/lua/CountdownTimerPatch23-21947-2-3-1749235215/bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/init.lua` (L352) | `string.format("Patch 2.3 in %dd : %02dhr : %02dm : %02ds", ...)` for countdown display |
| CrowdScheduler | `mods/lua/CrowdScheduler-30232-0-92-1780508208/bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua` (L339) | `string.format("%02d:00", i)` for generating hour labels |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/init.lua` (L106) | `string.format("[%d-%02d-%02d  %02d:%02d:%02d]", ...)` for timestamp formatting |

*627 more mods use this pattern*

## Related Concepts

- [OOP Patterns](oop-patterns.md) — String formatting embedded in class methods for display and logging
- [Error Handling](error-handling.md) — JSON string parsing guarded by pcall
- [Data & Utility Patterns](../data/index.md) — JSON serialization built on string operations
