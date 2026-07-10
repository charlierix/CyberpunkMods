---
type: Mechanic Pattern
title: "Custom Currency Systems"
description: "Creating custom currency systems or modifying eddie economy mechanics"
tags: [economy, currency, eddies]
timestamp: 2026-07-04T00:00:00Z
---

# Custom Currency Systems

Creating custom currency systems or modifying eddie economy mechanics.

## Approach

This technique involves creating custom currency systems or modifying eddie economy mechanics. Mods use this to intercept, modify, or extend the game's vendors & market system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| The Zenitex Military Store-21735-1-2-1765449267 | `r6/tweaks/scorpiontank/0_scorpion_zenitex_store_vendors.yaml` | - !append Vendors.TierScaledBaseMoney |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/place.lua` | variantType = "Zzz05_ApartmentToPurchaseVariant " |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `r6/tweaks/EnterableInteriors/EnterableInteriors.yaml` | filterName: UI-MappinTypes-ApartmentToPurchase |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:3690` | local moneyAmount = ts:GetItemQuantity(player, MarketSystem.Money()) |
| gambling-system-pachinko-19889-1-1-4-1765431915 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-pachinko/init.lua:185` | local playerMoney = Game.GetTransactionSystem():GetItemQuantity(GetPlayer(), MarketSystem.Money()) |
| wall_hang | `init.lua:504` | -- Purchase |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:3772` | local moneyAmount = ts:GetItemQuantity(player, MarketSystem.Money()) |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/RouletteMainMenu.lua:91` | local playerMoney = Game.GetTransactionSystem():GetItemQuantity(GetPlayer(), MarketSystem.Money()) |

*74 more mods use this pattern.*


## Related Concepts

- [Vendors & Market](./index.md) — parent concept
- [Virtual Atelier Framework](virtual-atelier-framework.md) — alternative approach
- [Vendor Inventory Modification](vendor-inventory-modification.md) — alternative approach
- [Market Pricing Manipulation](market-pricing.md) — alternative approach
