---
type: Mechanic Pattern
title: TweakXL Framework
description: TweakXL advanced TweakDB modification framework for injecting, overriding, and creating game balance records via Redscript and Lua.
tags: [redscript, red4ext, tweakxl, tweakdb, balance, records, framework, injection]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

TweakXL is a Red4ext/Redscript-based framework that provides advanced TweakDB modification capabilities beyond vanilla TweakDB overrides. It allows mods to inject new records, modify existing ones, and create complex balance changes through a structured API rather than raw TweakDB YAML files.

**Integration patterns:**

```reds
// TweakXL global access
import TweakXL.*

// Inject a new TweakDB record
TweakXL.CreateRecord("MyMod.CustomItem", t"Base.Items.ClothingItem");

// Modify existing record values
TweakXL.SetFlat("Base.Items.ClothingItem.quality", "Quest");

// Lua-side TweakXL reference for CET mods
local tweakxl = require("TweakXL")
if tweakxl then
    tweakxl.SetFlat("Items.MyCustomWeapon.damage", 150)
end
```

Key characteristics:
- TweakXL.Global.reds provides the core injection and modification API
- Mods reference TweakXL from both Redscript (for direct record manipulation) and Lua (for CET-side config)
- The `all in one` mod bundles the complete TweakXL runtime in its `red4ext/plugins/TweakXL/` directory
- Gambling system mods (pachinko, roulette, blackjack) reference TweakXL for economy balance tweaks
- PLR2.0 uses TweakXL for perk and leveling system modifications via Lua-side Set Values module
- Merc Protocol references TweakXL in utility scripts for gameplay balance adjustments
- Night City Motorsports uses TweakXL for rival NPC stat definitions
- Pattern: Lua `init.lua` checks for TweakXL availability and applies balance overrides at startup
- Atelier Price Fixer integrates TweakXL for store tier price modifications

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| gambling-system-pachinko | `mods/lua/gambling-system-pachinko-19889-1-1-4-1765431915/bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-pachinko/init.lua` (L391) | TweakXL reference for pachinko reward economy balance |
| Appearance Menu Mod | `mods/lua, arch/Appearance Menu Mod-790-2-12-5-1749642728/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/update_notes.lua` (L2216) | TweakXL compatibility notes in AMM update history |
| Gambling System - Roulette | `mods/lua, arch/Gambling System - Roulette/bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua` (L1336) | TweakXL reference for roulette payout balance tuning |
| gambling-system-blackjack | `mods/lua, arch/gambling-system-blackjack-19575-1-1-4-1765431443/bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-blackjack/init.lua` (L446) | TweakXL reference for blackjack economy balance |
| PLR2.0 | `mods/lua, arch/PLR2.0-6925-2-01-1689771887/bin/x64/plugins/cyber_engine_tweaks/mods/PLR2.0/init.lua` | TweakXL integration for perk/leveling system modifications |
| PLR2.0 | `mods/lua, arch/PLR2.0-6925-2-01-1689771887/bin/x64/plugins/cyber_engine_tweaks/mods/PLR2.0/modules/Set Values.lua` (L305) | TweakXL SetFlat calls for perk value definitions |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/red4ext/plugins/TweakXL/Scripts/TweakXL.Global.reds` (L126) | Core TweakXL global API implementation (bundled) |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/red4ext/plugins/TweakXL/Scripts/TweakXL.reds` | TweakXL main Redscript module (bundled) |
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/StoreTier.reds` | TweakXL integration for atelier store tier price modifications |
| Merc Protocol | `mods/lua, red/Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259/r6/scripts/MercProtocol/utils.reds` (L140) | TweakXL utility references for gameplay balance adjustments |
| Night City Motorsports | `mods/lua, red/Night City Motorsports-28713-2-0-1776645682/release2.0/bin/x64/plugins/cyber_engine_tweaks/mods/MT_Ecosystem/modules/named_rivals.lua` (L273) | TweakXL for rival NPC stat definitions in racing ecosystem |

*28 more mods use this pattern*

## Related Concepts

- [Virtual Atelier](virtual-atelier.md) — Atelier stores combine TweakXL for item stat definitions and pricing
- [Replace Method](../redscript/replace-method.md) — TweakXL uses @replaceMethod for TweakDB record overrides
- [Error Handling](../lua-utils/error-handling.md) — TweakXL Lua calls often wrapped in pcall for safe balance application
