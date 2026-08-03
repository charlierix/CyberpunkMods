---
type: Mechanic Pattern
title: Price Adjustment via TweakDB
description: Modifying Price.* TweakDB records to alter item pricing globally.
tags: [economy pricing tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Price Adjustment via TweakDB

Modifying Price.* TweakDB records to alter item pricing globally.

## Approach

Mods modify `Price.*` TweakDB records to globally adjust item prices. This includes buy prices, sell prices, and price multipliers for different item categories. Changes are static and applied at game load time.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Artistic-13066-1-4-5-1774982712 | `r6/tweaks/Artistic/Artistic.yaml` | Modifies Price.* records |
| Immersive Cyberware-21916-1-0-2-1755792059 | `r6/tweaks/ImmersiveCyberware/lenses/common.yaml` | Modifies Price.* records |
| New Iconic Conventional Weapons-20694-1-0-1743523219 | `r6/tweaks/NewIconics/NewIconics.yaml` | Modifies Price.* records |
| Nue x-MOD2-20741-1-0-0-1743706626 | `r6/tweaks/Nue x-MOD2/Items.m1klos_Nue_XMOD2.yaml` | Modifies Price.* records |
| Perkware 2.0 29611 2.1.3 2026-07-15T23-18Z UQrhQStni | `r6/tweaks/Perkware/PerkwarePrices.yaml` | Modifies Price.* records |

*9 more mods use this pattern.*

## Related Concepts

- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
