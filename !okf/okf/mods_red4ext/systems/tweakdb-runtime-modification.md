---
type: Mechanic Pattern
title: Runtime TweakDB Modification
description: Using CET or REDScript to modify TweakDB records at runtime rather than via static YAML files.
tags: [systems tweakdb runtime lua]
timestamp: 2026-08-03T00:00:00Z
---

# Runtime TweakDB Modification

Using CET or REDScript to modify TweakDB records at runtime rather than via static YAML files.

## Approach

Mods use CET Lua APIs (`TweakDB:GetRecord`, `TweakDB:SetFlat`) or REDScript TweakDB interfaces to modify TweakDB records at runtime. This enables dynamic modifications based on game state, conditional item stats, or TweakDB changes that depend on player choices. Unlike static YAML tweaks, runtime modifications can change during gameplay.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ActualCantoBlackwall 25849 1.0.0.1 2026-07-27T14-38Z VquAqYzfW | `bin/x64/plugins/cyber_engine_tweaks/mods/ActualCantoBlackwall/init.lua` | Uses TweakDB at runtime |
| Always Free Camera V1.5 31472 2 2026-07-16T09-54Z SlR4l6sf5 | `bin/x64/plugins/cyber_engine_tweaks/mods/AlwaysFreeCamera/init.lua` | Uses TweakDB at runtime |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `bin/x64/plugins/cyber_engine_tweaks/mods/CustomHackingSystem/init.lua` | Uses TweakDB at runtime |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `bin/x64/plugins/cyber_engine_tweaks/mods/CustomHackingSystem/init.lua` | Uses TweakDB at runtime |
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `bin/x64/plugins/cyber_engine_tweaks/mods/BetterLeveling/init.lua` | Uses TweakDB at runtime |

*49 more mods use this pattern.*

## Related Concepts

- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
- [TweakDB Status Effect Records](/systems/tweakdb-status-effects.md) — Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.
- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
