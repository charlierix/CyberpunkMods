---
type: Mechanic Pattern
title: Vending Machine Extensions
description: Extending VendingMachine class to modify vending machine behavior.
tags: [world vending-machine devices]
timestamp: 2026-08-03T00:00:00Z
---

# Vending Machine Extensions

Extending VendingMachine class to modify vending machine behavior.

## Approach

Mods use `@addMethod(VendingMachine)` (18 instances) to add new methods to vending machines. This enables custom vending machine behavior, modified purchase logic, or additional vending machine features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds` | References VendingMachine |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds` | References VendingMachine |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds` | References VendingMachine |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Utils/DFResourceUtils.reds` | References VendingMachine |
| EnhancedDevices-AllFiles-6927-2-5-3-1694680785 | `r6/scripts/EnhancedDevices/_GetQuickHackActions.reds` | References VendingMachine |

*6 more mods use this pattern.*

## Related Concepts

- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
- [Vendor Logic Overrides](/economy/vendor-logic-overrides.md) — Wrapping Vendor class methods to change vendor interaction behavior at runtime.
