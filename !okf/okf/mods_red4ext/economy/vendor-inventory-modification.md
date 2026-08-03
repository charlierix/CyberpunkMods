---
type: Mechanic Pattern
title: Vendor Inventory Modification
description: Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
tags: [economy vendors tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Vendor Inventory Modification

Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.

## Approach

Mods modify `Vendors.*` TweakDB records via YAML tweak files to add items to vendor inventories, change stock quantities, or adjust buy/sell prices. This is the most common economy manipulation pattern — it modifies static game data rather than runtime behavior.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 01. Igla Double Tap - Longer Barrel-29554-1-0-1778467633 | `r6/tweaks/Igla Double Tap/Igla_DoubleTap.yaml` | Modifies Vendors.* TweakDB records |
| 03. EX-1 Cybercriminal-28768-1-0-1775734058 | `r6/tweaks/EX1/EX1_Cybercriminal.yaml` | Modifies Vendors.* TweakDB records |
| ACHILLES 3FX-27613-1-0-1-1773480076 | `r6/tweaks/c3_achilles_3fx/c3_achilles_3fx.yaml` | Modifies Vendors.* TweakDB records |
| AK-77-14716-1-0-1715688582 | `r6/tweaks/AK_77.yaml` | Modifies Vendors.* TweakDB records |
| Artistic-13066-1-4-5-1774982712 | `r6/tweaks/Artistic/Artistic.yaml` | Modifies Vendors.* TweakDB records |

*73 more mods use this pattern.*

## Related Concepts

- [Vendor Logic Overrides](/economy/vendor-logic-overrides.md) — Wrapping Vendor class methods to change vendor interaction behavior at runtime.
- [Price Adjustment via TweakDB](/economy/price-adjustment.md) — Modifying Price.* TweakDB records to alter item pricing globally.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
