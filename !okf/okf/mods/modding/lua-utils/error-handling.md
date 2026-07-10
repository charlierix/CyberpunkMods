---
type: Mechanic Pattern
title: Lua Error Handling Patterns
description: Protected calls using pcall and xpcall for safe execution, graceful degradation, and error recovery across CET mods.
tags: [lua, cet, pcall, xpcall, error-handling, safety, graceful-degradation]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Cyberpunk 2077 CET mods use `pcall` (protected call) and `xpcall` (protected call with custom error handler) extensively to guard against runtime crashes. Since a single unhandled Lua error in CET can destabilize the entire modding runtime, wrapping risky operations in `pcall` is a critical defensive pattern.

**Canonical patterns:**

```lua
-- Safe module loading
local ok, config = pcall(require, "modules/config")
if not ok then
    print("Config load failed: " .. tostring(config))
    config = {}
end

-- Safe game API call
local success, result = pcall(function()
    return Game.GetPlayer():GetTargetEntity()
end)
if success then
    -- use result
end

-- Safe JSON decode
local decodeOk, decoded = pcall(function() return json.decode(jsonString) end)
```

Key characteristics:
- `pcall` returns `(true, result)` on success or `(false, error_message)` on failure
- Commonly wraps `require()` for optional module dependencies
- Used around `Game.*` API calls that may fail if game state is invalid
- JSON encode/decode is universally wrapped in pcall
- `xpcall` with a custom handler is used for logging stack traces on error
- Pattern: check first return value, log error, provide fallback/default value
- Critical: some engine-level errors bypass pcall and crash CET directly

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `mods/lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua` (L1342) | `pcall(entry.fn, entry.player)` for safe event dispatch in lifecycle management |
| 3D World Map Explorer | `mods/lua/3D World Map Explorer-21208-1-5-0-1776474737/bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua` (L2333) | `pcall(function() return json.decode(jString) end)` for safe JSON parsing |
| Arrest | `mods/lua/Arrest-22114-1-0-4-1755437024/Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/init.lua` | `pcall(function()` wrapping entire initialization for safe startup |
| Better Vehicle Radio | `mods/lua/Better Vehicle Radio-8864-2-3-1716736144/bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua` (L646) | `pcall(require, "modules\\config")` for safe optional module loading |
| ContentTokenActivator | `mods/lua/ContentTokenActivator-16449-1-0-0-1725060141/bin/x64/plugins/cyber_engine_tweaks/mods/ContentTokenActivator/init.lua` | `pcall(function()` for plugin detection at startup |
| Cyberpunk Glitch FPS | `mods/lua/Cyberpunk Glitch FPS-28256-v6-0-1776762686/Cyberpunk Glitch FPS/bin/x64/plugins/cyber_engine_tweaks/mods/GlitchFPS/Glitch.lua` (L3071) | `pcall(function()` for safe game state queries |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/json.lua` (L1869) | `pcall(grok_one, self, text, 1, options)` for recursive JSON parser safety |
| EnemyMultipier | `mods/lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua` (L1520) | `pcall(function()` for safe game API calls in spawn logic |
| Equipment-Ex unlocker | `mods/lua/Equipment-Ex unlocker-11444-2-1-1703019878/bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/cetUtils.lua` (L475) | `pcall(function() return Game.GetLocalizedTextByKey(...))` for safe localization |

*355 more mods use this pattern*

## Related Concepts

- [OOP Patterns](oop-patterns.md) — Constructors often wrapped in pcall for safe instantiation
- [String Operations](string-operations.md) — JSON parsing (string-based) universally guarded by pcall
- [Data & Utility Patterns](../data/index.md) — File I/O and JSON serialization guarded by pcall
