---
type: Mechanic Pattern
title: Access Point Modifications
description: Extending AccessPointControllerPS to modify access point hacking behavior.
tags: [world access-point hacking devices]
timestamp: 2026-08-03T00:00:00Z
---

# Access Point Modifications

Extending AccessPointControllerPS to modify access point hacking behavior.

## Approach

Mods use `@addMethod(AccessPointControllerPS)` (16 instances) to extend access point behavior. This enables custom access point hacking, modified breach rewards, or integration with the hacking system for access point-specific features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Daemon Netrunning (Revamp)-23894-1-2-1-1759846597 | `r6/scripts/Daemon Netrunning (Revamp)/DNR_Core.reds` | References AccessPointControllerPS |
| Much Better Netrunning 27237 2.20 2026-07-03T02-38Z lcXrcZgIw | `r6/scripts/BetterNetrunning/Breach/BreachHelpers.reds` | Adds `AccessPointControllerPS.GetMainframe` |

## Related Concepts

- [Hacking System Extensions](/systems/hacking-system-extensions.md) — Extending quickhack and hacking system classes to modify network breach and quickhack behavior.
- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
