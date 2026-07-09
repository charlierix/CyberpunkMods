---
type: Mechanic Pattern
title: "Virtual Atelier Framework"
description: "Using the Virtual Atelier framework to create custom stores with custom inventories"
tags: [economy, atelier, vendors]
timestamp: 2026-07-04T00:00:00Z
---

# Virtual Atelier Framework

Using the Virtual Atelier framework to create custom stores with custom inventories.

## Approach

This technique involves using the virtual atelier framework to create custom stores with custom inventories. Mods use this to intercept, modify, or extend the game's vendors & market system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Atelier Price Fixer-28279-1-4-0-1774797187 | `bin/x64/plugins/cyber_engine_tweaks/mods/AtelierPriceFixer/init.lua` | -- Atelier Price Fixer — TweakDB injection overlay |
| Weapon Conditioning-10479-1-2-1-1776102382 | `r6/scripts/Weapon Conditioning/InventoryFix/WorldItemStatsManager.reds:199` | // Fillup untagged weapons in Vendors in virtual Atelier stuff |
| ArasakaOfficeJob V1.3.4-29054-2-1781029231 | `r6/scripts/ArasakaOfficeJob/ArasakaDropPointDelivery.reds:8` | // Architecture mirrors Virtual Atelier Delivery's drop-point-prompt |
| Much Better Eddies | `bin/x64/plugins/cyber_engine_tweaks/mods/BetterEddies/nativeSettingsUI.lua:598` | Localizer.Get("UI-MBE-NSU-EnablePADesc", "Reprice Virtual Atelier store items onto MBE's ladder, ove |
| All Weapon Attachment Shops - Base-26883-v1-5-1770442848 | `gleta-WA-Shops-base/r6/scripts/WeaponAttachmentShops/VirtualAtelier-AllWeaponMods.reds:5` | // Dynamic Atelier Icon Pathing thanks to beckylou on nexusmods in the Craft All Scope Variants comm |
| Amber Talisman Virtual Atelier-28828-1-2-1780004200 | `r6/scripts/amber_talisman_atelier.reds:5` | "Amber Talisman Atelier Store", |
| Contraband Atelier-22382-1-1-1759214580 | `r6/scripts/c0ntraband/c0ntraband_virtual_atelier.reds` | "Contraband Atelier", |
| Masuryan's Atelier Store-20211-3-2-1773150932 | `r6/scripts/masuryans_store/masuryans_store.reds:5` | "Masuryan's Atelier Store", |

*11 more mods use this pattern.*


## Related Concepts

- [Vendors & Market](./index.md) — parent concept
- [Vendor Inventory Modification](vendor-inventory-modification.md) — alternative approach
- [Market Pricing Manipulation](market-pricing.md) — alternative approach
- [Custom Currency Systems](custom-currency.md) — alternative approach
