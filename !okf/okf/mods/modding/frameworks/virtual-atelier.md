---
type: Mechanic Pattern
title: Virtual Atelier Store Framework
description: Virtual Atelier framework for creating custom vendor shops with Redscript-based store registration and item catalog management.
tags: [redscript, red4ext, virtual-atelier, vendor, store, shop, framework, economy]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Virtual Atelier is a Redscript-based modding framework that enables mods to create custom vendor stores within Cyberpunk 2077's in-game economy. Mods integrate by registering a store with the Virtual Atelier API, defining available items, prices, and stock rules through Redscript classes.

**Canonical store registration:**

```reds
// Register a custom atelier store
@wrapMethod(VirtualAtelier)
public func RegisterStore(store: ref<MyCustomStore>) -> Void {
    wrappedMethod();
    // Custom store registration logic
}

// Define store with item catalog
public class MyCustomStore extends VirtualAtelierStore {
    public func GetItems() -> array<ref<VirtualAtelierItem>> {
        return MyItems;
    }
}
```

Key characteristics:
- Store modules are primarily Redscript (`.reds`) files defining store classes and item catalogs
- Some mods include CET Lua components for price adjustment and dynamic stock management
- The Atelier Price Fixer mod wraps Virtual Atelier hooks for price normalization and tier classification
- Store registration follows a pattern of extending base Virtual Atelier classes and overriding item/price methods
- Mods like Masuryan's Atelier, Rockerboy/Rockergirl Atelier define complete standalone stores with hundreds of items
- Weapon Attachment Shops framework extends Virtual Atelier for weapon mod distribution
- Cross-framework: Atelier Price Fixer modifies both Lua and Redscript layers of Virtual Atelier stores

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/Hooks.reds` | @wrapMethod hooks on Virtual Atelier store methods for price fixing |
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/StoreTier.reds` | Store tier classification system for Atelier stores |
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/PriceTable.reds` (L295) | Price table definitions for Atelier store items |
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/SubCatClassifier.reds` (L221) | Sub-category classifier for Atelier item categorization |
| Weapon Conditioning | `mods/lua, red/Weapon Conditioning-10479-1-2-1-1776102382/r6/scripts/Weapon Conditioning/InventoryFix/WorldItemStatsManager.reds` (L347) | Virtual Atelier integration for weapon condition display in store UI |
| All Weapon Attachment Shops | `mods/red/All Weapon Attachment Shops - Base-26883-v1-5-1770442848/gleta-WA-Shops-base/r6/scripts/WeaponAttachmentShops/VirtualAtelier-AllWeaponMods.reds` (L295) | Full Virtual Atelier store implementation for weapon attachment shops |
| Amber Talisman Virtual Atelier | `mods/red, arch/Amber Talisman Virtual Atelier-28828-1-2-1780004200/r6/scripts/amber_talisman_atelier.reds` | Custom Virtual Atelier store for Amber Talisman items |
| Contraband Atelier | `mods/red, arch/Contraband Atelier-22382-1-1-1759214580/r6/scripts/c0ntraband/c0ntraband_virtual_atelier.reds` | Contraband store built on Virtual Atelier framework |
| Masuryan's Atelier Store | `mods/red, arch/Masuryan's Atelier Store-20211-3-2-1773150932/r6/scripts/masuryans_store/masuryans_store.reds` (L878) | Full store implementation with 800+ lines of item catalog |
| Rockerboy Atelier | `mods/red, arch/Rockerboy Atelier-12376-2-8-1777072870/r6/scripts/RockerboyAtelier.reds` (L523) | Rockerboy-themed Virtual Atelier store with item catalog |
| Rockergirl Atelier | `mods/red, arch/Rockergirl Atelier-4717-2-33-1766613414/r6/scripts/RockergirlAtelier.reds` (L509) | Rockergirl-themed Virtual Atelier store with item catalog |

*79 more mods use this pattern*

## Related Concepts

- [Appearance Menu Mod](appearance-menu-mod.md) — AMM provides appearance-focused framework; Atelier focuses on economy/vendor
- [TweakXL](tweakxl.md) — TweakDB modifications often combined with Atelier for item stat definitions
- [Wrap Method](../redscript/wrap-method.md) — Atelier Price Fixer uses @wrapMethod to intercept store methods
