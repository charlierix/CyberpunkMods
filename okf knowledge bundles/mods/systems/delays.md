---
type: Mechanic Pattern
title: "Delay System"
description: "Delayed execution, timers, and scheduled game event manipulation patterns"
tags: [systems, delays]
timestamp: 2026-07-04T00:00:00Z
---

# Delay System

Delayed execution, timers, and scheduled game event manipulation patterns.

## Delayed Execution

Scheduling delayed execution of game logic via delaySystem, SetTimeout, and SetInterval.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:26` | --   Engine.SetTimeout / SetInterval / SetNextTick / ClearTimer |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/see.lua:8274` | GameInstance.GetDelaySystem():DelayEvent(enti,CreateRagdollApplyImpulseEvent(triggerOrigin, totalPP, |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameHUD.lua` | self:SetTimeout(self.simpleMessage.duration) |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:451` | _hudTimer = _Mod.SetTimeout(delay or 0.5, function() |
| NowPlayingDisplay - standalone-21570-1-3-4-1775976603 | `bin/x64/plugins/cyber_engine_tweaks/mods/NowPlayingDisplay-standalone/init.lua:224` | Engine.SetTimeout(0.5, function() |
| jetpack | `init.lua:310` | function wrappers.GetDelaySystem() return Game.GetDelaySystem() end |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:436` | _hudTimer = _Mod.SetTimeout(delay or 0.5, function() |
| Cyberpunk Story Quest Fixes | `bin/x64/plugins/cyber_engine_tweaks/mods/anygoodname_cp77_story_quest_fixes/init.lua:126` | local journalManager, questsSystem, transactionSystem, delaySystem, vehicleSystem |

*171 more mods use this pattern.*


## Related Concepts

- [Callback System](..//systems/callbacks.md) — related manipulation pattern
