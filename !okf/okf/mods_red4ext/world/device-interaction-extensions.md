---
type: Mechanic Pattern
title: Device Interaction Extensions
description: Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
tags: [world devices interaction]
timestamp: 2026-08-03T00:00:00Z
---

# Device Interaction Extensions

Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.

## Approach

Mods wrap `ScriptableDeviceComponentPS` (22 wraps, 16 @addMethod) and reference `InteractiveDevice` to modify device interaction behavior. This includes custom device actions, modified interaction options, or integration of new device functionality. The `OnInstantiated` method (16 wraps) is commonly wrapped to initialize device state. Mods also extend `ShardCaseContainer` and `DataTerm` for specific device types.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Main.reds` | Wraps `ShardCaseContainer.OnInteraction` |
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | References device component classes |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/Hacking/QuickHackInterceptor.reds` | References device component classes |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/Hacking/QuickHackInterceptor.reds` | References device component classes |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/Main/Quickhacks/QuickhackExtensions.reds` | References device component classes |

*32 more mods use this pattern.*

## Related Concepts

- [Access Point Modifications](/world/access-point-modifications.md) — Extending AccessPointControllerPS to modify access point hacking behavior.
- [Vending Machine Extensions](/world/vending-machine-extensions.md) — Extending VendingMachine class to modify vending machine behavior.
- [Hacking System Extensions](/systems/hacking-system-extensions.md) — Extending quickhack and hacking system classes to modify network breach and quickhack behavior.
