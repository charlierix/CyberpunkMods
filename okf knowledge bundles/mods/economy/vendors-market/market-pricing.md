---
type: Mechanic Pattern
title: "Market Pricing Manipulation"
description: "Modifying market pricing, item values, and purchase/sell price multipliers"
tags: [economy, pricing, market]
timestamp: 2026-07-04T00:00:00Z
---

# Market Pricing Manipulation

Modifying market pricing, item values, and purchase/sell price multipliers.

## Approach

This technique involves modifying market pricing, item values, and purchase/sell price multipliers. Mods use this to intercept, modify, or extend the game's vendors & market system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:3690` | local moneyAmount = ts:GetItemQuantity(player, MarketSystem.Money()) |
| gambling-system-pachinko-19889-1-1-4-1765431915 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-pachinko/init.lua:185` | local playerMoney = Game.GetTransactionSystem():GetItemQuantity(GetPlayer(), MarketSystem.Money()) |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:3772` | local moneyAmount = ts:GetItemQuantity(player, MarketSystem.Money()) |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/RouletteMainMenu.lua:91` | local playerMoney = Game.GetTransactionSystem():GetItemQuantity(GetPlayer(), MarketSystem.Money()) |
| NanoDrone 1.6-3419-1-6-1710086061 | `bin/x64/plugins/cyber_engine_tweaks/mods/nanoDrone/modules/data.lua:140` | function data.getVendorPrice() |
| davidsapogee-16784-v2-25-3-1741706742 | `bin/x64/plugins/cyber_engine_tweaks/mods/DavidsApogee/init.lua:692` | return TS:GetItemQuantity(V, MarketSystem.Money()) |
| gambling-system-blackjack-19575-1-1-4-1765431443 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-blackjack/BlackjackMainMenu.lua:27` | --local playerMoney = Game.GetTransactionSystem():GetItemQuantity(GetPlayer(), MarketSystem.Money()) |
| Atelier Price Fixer-28279-1-4-0-1774797187 | `bin/x64/plugins/cyber_engine_tweaks/mods/AtelierPriceFixer/init.lua` | -- Atelier Price Fixer — TweakDB injection overlay |

*58 more mods use this pattern.*


## Related Concepts

- [Vendors & Market](./index.md) — parent concept
- [Virtual Atelier Framework](virtual-atelier-framework.md) — alternative approach
- [Vendor Inventory Modification](vendor-inventory-modification.md) — alternative approach
- [Custom Currency Systems](custom-currency.md) — alternative approach
