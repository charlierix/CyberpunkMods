---
type: Mechanic Pattern
title: CET Observe() Pattern
description: Hook into native game object methods using CET's Observe() to intercept or augment game events.
tags: [cet, lua, hooks, observe, events, game-objects]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

The `Observe()` function is CET's primary hooking mechanism. It wraps a native C++ class method, calling the supplied Lua function after the original method executes. This allows mods to react to game events — player attachment, UI initialization, input actions — without modifying the original game code.

**Canonical usage:**

```lua
-- Hook into PlayerPuppet's OnGameAttached (called when player entity spawns)
Observe("PlayerPuppet", "OnGameAttached", function(obj)
    -- obj is the native object instance
    -- original method has already run
end)

-- Hook into input action events
Observe("PlayerPuppet", "OnAction", function(_, action)
    -- inspect action name, type, etc.
end)

-- Hook into UI controller lifecycle
Observe('QuestTrackerGameController', 'OnInitialize', function()
    -- UI is ready, safe to interact with widgets
end)

Observe('QuestTrackerGameController', 'OnUninitialize', function()
    -- cleanup when UI is torn down
end)
```

Key characteristics:
- Hooks must be registered during `init.lua` execution (inside `registerForEvent('onInit', ...)` or at top level)
- The callback fires **after** the original native method completes
- Multiple mods can observe the same method; all callbacks fire in sequence
- The first parameter is the native object instance (often unused, replaced with `_`)
- Observers persist across save loads; they are registered once at mod init

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/EventProxy.lua` | Event proxy library using Observe for cross-mod communication |
| 3D World Map Explorer | `lua/3D World Map Explorer-21208-1-5-0-1776474737/bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua` | Observes QuestTracker initialization for map overlay |
| Adaptive Traffic Headlights | `lua/Adaptive Traffic Headlights-24020-2-1-0-1758756478/bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua` | Monitors player attachment for headlight initialization |
| ClockWidget | `lua/ClockWidget-20572-1-6-1781010500/bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua` | UI lifecycle observation for widget rendering |
| EnemyMultipier | `lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua` | Observes game session for enemy stat scaling |
| grappling_hook | `lua/grappling_hook/init.lua` (706 lines) | L293: Observe PlayerPuppet.OnGameAttached; L297: OnAction; L303: QuestTracker.OnInitialize |
| jetpack | `lua/jetpack/init.lua` (481 lines) | L246: Observe PlayerPuppet.OnGameAttached; L250: OnAction; L256: QuestTracker.OnInitialize |
| ghost_forward | `lua/ghost_forward/init.lua` (152 lines) | L52: Observe QuestTracker.OnInitialize; L58: OnUninitialize |
| Interactive Accessories | `lua/Interactive Accessories-22472-1-0-1751421384/bin/x64/plugins/cyber_engine_tweaks/mods/InteractiveAccessories/init.lua` | Observes player and UI for accessory toggling |
| KillsCounterDisplay | `lua/KillsCounterDisplay-20752-1-1-1743928008/bin/x64/plugins/cyber_engine_tweaks/mods/KillsCounterDisplay/init.lua` | Observes game events for kill tracking |

*149 more mods use this pattern*

## Related Concepts

- [Singleton Access](singleton-access.md) — Often used alongside Observe to access game systems within hooks
- [Cron Timers](cron-timers.md) — Combined with Observe for periodic updates after game events
- [Vector Math](vector-math.md) — Used inside Observe callbacks for position/transform manipulation
