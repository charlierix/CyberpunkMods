---
type: Mechanic Pattern
title: Ink Widget Extensions
description: Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
tags: [ui ink widgets extensions]
timestamp: 2026-08-03T00:00:00Z
---

# Ink Widget Extensions

Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.

## Approach

Mods use `@addMethod(inkGameController)` (39 instances) and `@addMethod(inkWidget)` (21 instances) to add new methods to base UI classes. This enables custom widget behavior, extended game controller functionality, or UI utility methods available across all UI controllers. Since these are base classes, additions affect all UI elements that inherit from them.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Utility/InkAnimUtility.reds` | Adds `inkWidget.EaseInOpacity` |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Utility/InkAnimUtility.reds` | Adds `inkWidget.EaseInOpacity` |
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/shieldPointsUI.reds` | Adds methods to ink widget classes |
| BrowserExtensionFramework-10038-0-9-7-1758341320 | `r6/scripts/BrowserExtension/browserController.overrides.reds` | Adds methods to ink widget classes |
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Adds methods to ink widget classes |

*62 more mods use this pattern.*

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Inventory UI Overrides](/ui/inventory-ui-overrides.md) — Wrapping inventory-related game controllers to modify inventory and backpack display.
