---
type: Mechanic Pattern
title: Lua Math Operations
description: Numeric utilities including lerp, clamp, math.floor, math.ceil, trigonometric functions, and interpolation across CET mods.
tags: [lua, cet, math, lerp, clamp, interpolation, trigonometry, rounding]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

CET mods rely on Lua's standard math library for gameplay calculations, UI positioning, animation curves, and value normalization. Two utility functions — `lerp` (linear interpolation) and `clamp` (value clamping) — are so commonly needed that many mods define them locally rather than relying on a shared library.

**Canonical utility functions:**

```lua
-- Linear interpolation between two values
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Clamp value to range
local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

-- Rounding to nearest integer
local rounded = math.floor(value + 0.5)

-- Radial positioning
local x = math.cos(angle) * radius
local y = math.sin(angle) * radius
```

Key characteristics:
- `math.floor` and `math.ceil` for integer conversion and rounding
- `math.abs` for distance/normalization calculations
- `math.sin`/`math.cos` for circular motion, radial layouts, and oscillating effects
- `lerp` is defined locally in many mods; no standard CET library provides it
- `clamp` ensures values stay within engine-valid ranges (e.g., crowd density 0-2)
- Performance pattern: caching `local floor = math.floor` to avoid global table lookup
- Interpolation used for smooth transitions, camera movement, and UI animation

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `mods/lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua` (L1342) | `math.floor(interval)` for timing calculations |
| 3D World Map Explorer | `mods/lua/3D World Map Explorer-21208-1-5-0-1776474737/bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua` (L2333) | `math.abs(zoomValue)` for zoom level normalization |
| A CET Mod Logger | `mods/lua/A CET Mod Logger-23208-1-5-1755463327/bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/Modules/WindowUtils.lua` (L162) | `math.floor(position / gridSize + 0.5) * gridSize` for grid snapping |
| Adaptive Traffic Headlights | `mods/lua/Adaptive Traffic Headlights-24020-2-1-0-1758756478/bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua` (L542) | `local floor = math.floor` performance caching pattern |
| Appearance Creator Mod | `mods/lua/Appearance Creator Mod-10795-1-0-1-1699493978/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/External/BigNum.lua` (L985) | `math.floor(math.log10(RADIX))` for radix computation in BigNum |
| CountdownTimerPatch23 | `mods/lua/CountdownTimerPatch23-21947-2-3-1749235215/bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/init.lua` (L352) | `math.floor(seconds / 86400)` for day calculation from epoch |
| CrowdScheduler | `mods/lua/CrowdScheduler-30232-0-92-1780508208/bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua` (L339) | Clamp to valid engine range (0=Low, 1=Medium, 2=High) for crowd density |
| Cyberpunk Glitch FPS | `mods/lua/Cyberpunk Glitch FPS-28256-v6-0-1776762686/Cyberpunk Glitch FPS/bin/x64/plugins/cyber_engine_tweaks/mods/GlitchFPS/Glitch.lua` (L3071) | `local function clamp(v, a, b)` utility definition for value clamping |
| EnemyMultipier | `mods/lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua` (L1520) | `math.cos(angle) * radius` for radial spawn positioning |

*462 more mods use this pattern*

## Related Concepts

- [OOP Patterns](oop-patterns.md) — Math utility classes use setmetatable for fluent interpolation APIs
- [String Operations](string-operations.md) — Formatted output of computed math values via string.format
- [ImGui Patterns](../imgui/index.md) — UI positioning calculations using math operations
