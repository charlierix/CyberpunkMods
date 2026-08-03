---
type: Mechanic Pattern
title: Crafting System Overrides
description: Wrapping CraftingLogicController and CraftingSystem to modify crafting recipes and behavior.
tags: [economy crafting items]
timestamp: 2026-08-03T00:00:00Z
---

# Crafting System Overrides

Wrapping CraftingLogicController and CraftingSystem to modify crafting recipes and behavior.

## Approach

Mods wrap `CraftingLogicController` and `CraftingSystem` methods to alter crafting behavior. This includes custom recipe requirements, modified crafting costs, additional craftable items, or conditional crafting availability. Some mods also modify crafting-related TweakDB records for recipe definitions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Craft All-23494-1-0-0-1755273337 | `r6/scripts/Craft All/Craft All.reds` | References crafting system |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFStashCraftingSystem.reds` | References crafting system |
| Enhanced Craft-4378-4-0-9-1779642516 | `r6/scripts/EnhancedCraft/common/EnhancedCraft-Fields.reds` | References crafting system |
| Find-EX-8340-1-2-0-1697203025 | `r6/scripts/FindEx/FindEx.Global.reds` | Wraps `CraftingLogicController.Init` |
| Immersive Crafting Access-16154-0-0-5-1723163219 | `r6/scripts/ImmersiveCraftingAccess/ImmersiveCraftingAccess.reds` | References crafting system |

*8 more mods use this pattern.*

## Related Concepts

- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
