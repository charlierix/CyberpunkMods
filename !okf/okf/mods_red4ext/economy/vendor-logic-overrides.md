---
type: Mechanic Pattern
title: Vendor Logic Overrides
description: Wrapping Vendor class methods to change vendor interaction behavior at runtime.
tags: [economy vendors runtime]
timestamp: 2026-08-03T00:00:00Z
---

# Vendor Logic Overrides

Wrapping Vendor class methods to change vendor interaction behavior at runtime.

## Approach

Mods use `@wrapMethod(Vendor)` to override vendor interaction logic at runtime. This enables dynamic pricing, conditional item availability, custom vendor behaviors, or integration with other game systems. Unlike TweakDB modifications, these overrides are computed per-interaction.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/injector.reds` | Wraps `Vendor.PlayerCanBuy` |
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `r6/scripts/Better Leveling Addon/Extra Street Credit Tier/BTL_00_ExtraStreetCred.reds` | Wraps `Vendor.OnVendorMenuOpen` |
| DropPointsReimagined-29563-1-0-0-1778351569 | `r6/scripts/DropPointsReimagined/Overrides/Vendor.reds` | Wraps `Vendor.OnVendorMenuOpen` |
| Much Better Eddies 30532 1.3 2026-07-12T02-46Z LACBAIygB | `r6/scripts/BetterEddies/Pricing/SellDisplayWrap.reds` | Wraps `Vendor.OnVendorMenuOpen` |
| Smarter Scrapper-2687-2-3-6-1774445898 | `r6/scripts/smarterScrapper.reds` | Wraps `Vendor.PerformItemTransfer` |

*2 more mods use this pattern.*

## Related Concepts

- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
- [Vendor UI Overrides](/ui/vendor-ui-overrides.md) — Wrapping vendor and ripperdoc game controllers to modify vendor interaction UI.
