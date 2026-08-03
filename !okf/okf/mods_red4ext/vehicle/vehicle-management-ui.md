---
type: Mechanic Pattern
title: Vehicle Management UI
description: Wrapping VehiclesManagerPopupGameController to modify the vehicle management interface.
tags: [vehicle ui management]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle Management UI

Wrapping VehiclesManagerPopupGameController to modify the vehicle management interface.

## Approach

Mods wrap `VehiclesManagerPopupGameController` (11 wraps, 4 @addMethod) to modify the vehicle management UI. This includes custom vehicle list display, modified vehicle calling behavior, or additional vehicle management features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| FindMyRide 1.1.0 31610 1.1.0 2026-07-31T15-52Z mPgaPVeOM | `r6/scripts/FindMyRide/FindMyRide.reds` | Wraps `VehiclesManagerPopupGameController.SetupVirtualList` |
| Limited HUD 2592 2.22.4 2026-07-26T18-22Z LACBAIyo3 | `r6/scripts/LHUD/modules/actionButtons.reds` | References VehiclesManagerPopup |
| Realistic Transport Dispatch 28220 1.2.2 2026-07-01T06-48Z G5yE5CJYJ | `Realistic Transport Dispatch/r6/scripts/RealisticTransportDispatch/RealisticTransportDispatch.reds` | Wraps `VehiclesManagerPopupGameController.OnShowAnimFinished` |
| Vehicle Call Plus-27683-1-1-3-1776218501 | `r6/scripts/Vehicle Call Plus/VehicleCall_Cooldowns.reds` | Wraps `VehiclesManagerPopupGameController.OnPlayerAttach` |

## Related Concepts

- [Vehicle System Overrides](/vehicle/vehicle-system-overrides.md) — Overriding VehicleSystem methods via CET to modify vehicle spawning and management.
- [In-Game Menu Overrides](/ui/ingame-menu-overrides.md) — Wrapping gameuiInGameMenuGameController to modify in-game menu behavior.
