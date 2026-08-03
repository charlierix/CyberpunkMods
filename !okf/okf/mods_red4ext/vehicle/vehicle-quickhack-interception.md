---
type: Mechanic Pattern
title: Vehicle Quickhack Interception
description: Wrapping VehicleComponentPS.GetQuickHackActions to intercept and modify vehicle quickhack options.
tags: [vehicle quickhack hacking security]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle Quickhack Interception

Wrapping VehicleComponentPS.GetQuickHackActions to intercept and modify vehicle quickhack options.

## Approach

Mods wrap `VehicleComponentPS.GetQuickHackActions` to intercept the quickhack actions available on vehicles. This enables custom vehicle quickhack options, gating quickhacks behind security systems, or disabling certain vehicle quickhacks. The wrapped method calls `wrappedMethod()` to get the default actions, then modifies the action list based on mod logic.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/Hacking/QuickHackInterceptor.reds` | Wraps `VehicleComponentPS.GetQuickHackActions` |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/Hacking/QuickHackInterceptor.reds` | Wraps `VehicleComponentPS.GetQuickHackActions` |
| Immersive Crafting-22824-1-0-5-1760029324 | `r6/scripts/immersive_crafting/immersive_crafting.reds` | Intercepts vehicle quickhack actions |
| Much Better Netrunning 27237 2.20 2026-07-03T02-38Z lcXrcZgIw | `r6/scripts/BetterNetrunning/Core/DeviceUnlockUtils.reds` | Intercepts vehicle quickhack actions |
| VehicleSecurityRework v1.4.0-5092-1-4-0-1732392843 | `r6/scripts/VehicleSecurityRework/Quickhacks/DeviceActionsTemplate.reds` | Wraps `VehicleComponentPS.GetQuickHackActions` |

*1 more mods use this pattern.*

## Related Concepts

- [Hacking System Extensions](/systems/hacking-system-extensions.md) — Extending quickhack and hacking system classes to modify network breach and quickhack behavior.
- [Vehicle Component Extensions](/vehicle/vehicle-component-extensions.md) — Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
