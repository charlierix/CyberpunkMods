---
type: Mechanic Pattern
title: Inventory UI Overrides
description: Wrapping inventory-related game controllers to modify inventory and backpack display.
tags: [ui inventory backpack]
timestamp: 2026-08-03T00:00:00Z
---

# Inventory UI Overrides

Wrapping inventory-related game controllers to modify inventory and backpack display.

## Approach

Mods wrap `BackpackMainGameController` (21 wraps, 26 @addMethod), `gameuiInventoryGameController` (16 wraps, 24 @addMethod), `InventoryItemDisplayController` (18 wraps, 18 @addMethod), and `InventoryDataManagerV2` (12 wraps, 16 @addMethod) to modify inventory UI behavior. This includes custom item display, modified sorting, additional inventory columns, or custom item actions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cutscene Weapon Swapper-20743-1-4-1-1745154157 | `r6/scripts/CutsceneWeaponSwapper.reds` | References inventory UI controllers |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFStashCraftingSystem.reds` | Wraps `gameuiInventoryGameController.OnSetUserData` |
| Doctrine Hydra V1.0.3 32034 1.0.3 2026-08-03T07-48Z psSjsvrFY | `r6/scripts/DoctrineMultiTargetLauncher/30_modules_ui_migration.reds` | Wraps `InventoryDataManagerV2.GetAttachmentSlotsForInventory` |
| Enhanced Craft-4378-4-0-9-1779642516 | `r6/scripts/EnhancedCraft/naming/EnhancedCraft-System.reds` | References inventory UI controllers |
| Equipment-EX-6945-1-2-9-1773737132 | `r6/scripts/EquipmentEx/EquipmentEx.Global.reds` | Wraps `BackpackMainGameController.OnInitialize` |

*18 more mods use this pattern.*

## Related Concepts

- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
- [Tooltip and Item Display](/ui/tooltip-and-item-display.md) — Wrapping item tooltip and helper classes to modify item information display.
