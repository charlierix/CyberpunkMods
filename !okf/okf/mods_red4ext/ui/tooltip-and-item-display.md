---
type: Mechanic Pattern
title: Tooltip and Item Display
description: Wrapping item tooltip and helper classes to modify item information display.
tags: [ui tooltips items display]
timestamp: 2026-08-03T00:00:00Z
---

# Tooltip and Item Display

Wrapping item tooltip and helper classes to modify item information display.

## Approach

Mods wrap `ItemTooltipBottomModule` (13 wraps), `UIItemsHelper` (18 wraps), and `ItemActionsHelper` to modify how item information is displayed. This includes custom tooltip content, modified item stats display, or additional item action options.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Auto Leveler-27010-2-31-01-1769096078 | `r6/scripts/Auto Leveler/AutoLevel.reds` | References item tooltip/helpers |
| Completely Non-Manual Looting-16040-2-13-01-1727125795 | `r6/scripts/Completely Non-Manual Loot/CNML.reds` | References item tooltip/helpers |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Main/CAMainSystem.reds` | Wraps `ItemActionsHelper.ProcessItemAction` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Needs/DFNeedConsumables.reds` | Wraps `ItemActionsHelper.ProcessItemAction` |
| Doctrine Hydra V1.0.3 32034 1.0.3 2026-08-03T07-48Z psSjsvrFY | `r6/scripts/DoctrineMultiTargetLauncher/30_modules_ui_migration.reds` | Wraps `UIItemsHelper.GetSlotName` |

*13 more mods use this pattern.*

## Related Concepts

- [Inventory UI Overrides](/ui/inventory-ui-overrides.md) — Wrapping inventory-related game controllers to modify inventory and backpack display.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
