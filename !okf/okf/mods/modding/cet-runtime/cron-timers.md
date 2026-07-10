---
type: Mechanic Pattern
title: CET Cron and Timer Scheduling
description: Schedule delayed, periodic, and interval-based callbacks using CET's Cron library and native timer functions.
tags: [cet, lua, timers, scheduling, cron, setinterval, settimeout]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

CET provides multiple scheduling mechanisms for deferred and recurring execution. The most common is the `Cron` library (bundled as `external/Cron.lua`), which offers `Cron.After`, `Cron.Every`, and `Cron.Update`. Native `SetTimeout` and `SetInterval` functions provide simpler one-shot and repeating timers.

**Canonical usage:**

```lua
-- Require the Cron library (commonly bundled in external/ or modules/)
local Cron = require("modules/Cron")

-- One-shot delayed callback
Cron.After(0.1, function()
    -- runs 0.1 seconds after scheduling
end)

-- Recurring callback every 10 seconds
local cronCallback = function()
    -- periodic logic here
end
Cron.Every(10.0, cronCallback, nil)

-- Must call Cron.Update in the onUpdate event for timers to fire
registerForEvent('onUpdate', function(delta)
    Cron.Update(delta)
end)

-- Native CET timers (simpler, no library needed)
SetTimeout(1000, function()  -- milliseconds
    -- runs after 1 second
end)

SetInterval(500, function()  -- milliseconds
    -- runs every 500ms
end)
```

Key characteristics:
- `Cron.Update(delta)` must be called every frame for Cron timers to fire — typically in `onUpdate`
- `Cron.After(seconds, callback)` — one-shot delay in seconds (float)
- `Cron.Every(seconds, callback, context)` — recurring interval in seconds (float)
- `SetTimeout(milliseconds, callback)` — native CET one-shot timer in milliseconds
- `SetInterval(milliseconds, callback)` — native CET recurring timer in milliseconds
- Cron library is typically vendored per-mod as `external/Cron.lua` or `modules/Cron.lua`
- Timers are cleared on game reload; must be re-registered in `onInit`

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/Cron.lua` | Bundled Cron library implementation |
| Adaptive Traffic Headlights | `lua/Adaptive Traffic Headlights-24020-2-1-0-1758756478/bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua` | L4: require Cron; L536: Cron.Every(10.0, callback); L541: Cron.Update(delta) |
| Arrest | `lua/Arrest-22114-1-0-4-1755437024/Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/init.lua` | L41: Cron.Update(delta) in update loop |
| Appearance Creator Mod | `lua/Appearance Creator Mod-10795-1-0-1-1699493978/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/External/Cron.lua` | Vendored Cron library |
| CountdownTimerPatch23 | `lua/CountdownTimerPatch23-21947-2-3-1749235215/bin/x64/plugins/cyber_engine_tweaks/mods/countdown23/Cron.lua` | Cron library for countdown timer mod |
| Cyberscript Core | `lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/Cron.lua` | Bundled Cron for cyberscript modules |
| EnemyMultipier | `lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/Cron.lua` | Vendored Cron for enemy scaling intervals |
| Equipment-Ex unlocker | `lua/Equipment-Ex unlocker-11444-2-1-1703019878/bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/Cron.lua` | Cron library for equipment unlock timing |
| Immersive Relic English | `lua/Immersive Relic English-30028-1-4-1780279387/bin/x64/plugins/cyber_engine_tweaks/mods/Immersive Relic/init.lua` | Timer-based relic activation scheduling |
| ImmersiveOdometerFuel0E | `lua, red, arch/ImmersiveOdometerFuel0E-23834-4-4-1778757655/bin/x64/plugins/cyber_engine_tweaks/mods/VehicleMileage/init.lua` | Cron-based fuel/mileage update loop |

*87 more mods use this pattern*

## Related Concepts

- [Observe Pattern](observe-pattern.md) — Cron timers often initialized inside Observe callbacks for game-ready detection
- [Singleton Access](singleton-access.md) — Singleton state frequently polled within periodic timer callbacks
- [Vector Math](vector-math.md) — Position updates driven by timer callbacks for smooth interpolation
