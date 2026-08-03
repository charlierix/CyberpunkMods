---
type: Mechanic Pattern
title: Game Object Extensions
description: Adding methods to GameObject base class to extend all game entities.
tags: [systems game-object extensions]
timestamp: 2026-08-03T00:00:00Z
---

# Game Object Extensions

Adding methods to GameObject base class to extend all game entities.

## Approach

Mods use `@addMethod(GameObject)` (11 instances) and `@wrapMethod(GameObject)` to extend the base game object class. Since all entities inherit from GameObject, these additions affect all game objects. This is a powerful but broad pattern used for utility methods that need to be available on any entity.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Completely Non-Manual Looting-16040-2-13-01-1727125795 | `r6/scripts/Completely Non-Manual Loot/CNML.reds` | Adds `GameObject.ShouldBeQuest` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Services/DFPlayerStateService.reds` | Wraps `GameObject.ProcessDamageReceived` |
| Immersive Hit-24225-1-0-1-1759399866 | `r6/scripts/Immsersive Hit/IMH_Modules.reds` | Adds `GameObject.OnIMH_ClearFxEvent` |
| Limited HUD 2592 2.22.4 2026-07-26T18-22Z LACBAIyo3 | `r6/scripts/LHUD/core/common.reds` | Adds `GameObject.QueueLHUDEvent` |
| ShaderDrift-16279-0-9-0-1770918250 | `r6/scripts/ShaderDrift/ShaderDrift.reds` | Wraps `GameObject.OnVehicleHit` |

*2 more mods use this pattern.*

## Related Concepts

- [ScriptableService Registration](/systems/scriptable-service-registration.md) — Using the ScriptableService pattern to create persistent background services that run throughout the game session.
- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
