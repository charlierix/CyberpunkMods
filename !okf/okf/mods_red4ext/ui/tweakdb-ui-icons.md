---
type: Mechanic Pattern
title: TweakDB UI Icon Modification
description: Modifying UIIcon.* TweakDB records to add or alter UI icons.
tags: [ui icons tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB UI Icon Modification

Modifying UIIcon.* TweakDB records to add or alter UI icons.

## Approach

Mods modify `UIIcon.*` TweakDB records to add custom icons or modify existing icon references. This is used for custom item icons, perk icons, or UI element graphics. Changes are static and loaded at game start.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A Normal Pizza Option-25788-1-0-0-1763760710 | `r6/tweaks/morepizzaoptions/MorePizzaOptions.yaml` | Modifies UIIcon.* records |
| Artistic-13066-1-4-5-1774982712 | `r6/tweaks/Artistic/Artistic.yaml` | Modifies UIIcon.* records |
| Combat Pants-14224-1-0-1713144460 | `707 combat pants/r6/tweaks/caibro_militech_pants.yaml` | Modifies UIIcon.* records |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/tweaks/Consumable Animations/ConsumableAnimations.ConsumableCigarettes.yaml` | Modifies UIIcon.* records |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/tweaks/Dark Future/DarkFuture.BaseGameUpdate_ConsumableItemData.yaml` | Modifies UIIcon.* records |

*32 more mods use this pattern.*

## Related Concepts

- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
- [Inventory UI Overrides](/ui/inventory-ui-overrides.md) — Wrapping inventory-related game controllers to modify inventory and backpack display.
