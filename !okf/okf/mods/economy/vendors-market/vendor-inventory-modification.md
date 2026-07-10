---
type: Mechanic Pattern
title: "Vendor Inventory Modification"
description: "Modifying existing vendor inventories and stock via TweakDB vendor records"
tags: [economy, vendors, tweakdb]
timestamp: 2026-07-04T00:00:00Z
---

# Vendor Inventory Modification

Modifying existing vendor inventories and stock via TweakDB vendor records.

## Approach

This technique involves modifying existing vendor inventories and stock via tweakdb vendor records. Mods use this to intercept, modify, or extend the game's vendors & market system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A. Ubiquitous Chib - Heywood - Upcoming Merc-21088-1-2-0-1754859537 | `r6/tweaks/TheUbiquitousChib_Heywood.yaml:67` | vendorID: Vendors.vendorxl_custom |
| A. Ubiquitous Chib - Santo Domingo - Upcoming Merc-21490-1-2-0-1754861078 | `r6/tweaks/TheUbiquitousChib_SantoDomingo.yaml:90` | vendorID: Vendors.vendorxl_custom |
| A. Ubiquitous Chib - Westbrook - Upcoming Merc-21175-1-2-0-1754860503 | `r6/tweaks/TheUbiquitousChib_Westbrook.yaml:67` | vendorID: Vendors.vendorxl_custom |
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_mako.yaml:208` | Vendors.BlackMarketer_HUB: # add to Black Market if not picked up during gig |
| Ashfold's Treasures - Balanced (1.2)-19812-1-2-1740999564 | `r6/tweaks/vxl_ashfoldWardrobes_b_tta/Ashfold_Wardrobe_B_TTA.yml` | #Vendor items: |
| B. Ubiquitous Chib - Heywood - Legend of NC-21088-1-2-0-1754859589 | `r6/tweaks/TheUbiquitousChib_Heywood.yaml:58` | vendorID: Vendors.vendorxl_custom |
| Chill Heywood Apartment - Main File-26263-1-0-3-1776030342 | `r6/tweaks/DP77/DP77_Chill_Heywood_Apartment_VendorsXL.yaml` | #Entity and appearance setup for your vendor/npc [default is the Kabuki Gun Vendor]: |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/multiAuthor_ncpride_vendorA_tta.yml` | Character.MultiAuthor_Pride_VendorA_TTA: |

*199 more mods use this pattern.*


## Related Concepts

- [Vendors & Market](./index.md) — parent concept
- [Virtual Atelier Framework](virtual-atelier-framework.md) — alternative approach
- [Market Pricing Manipulation](market-pricing.md) — alternative approach
- [Custom Currency Systems](custom-currency.md) — alternative approach
