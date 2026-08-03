---
type: Mechanic Pattern
title: TweakDB Item Record Modification
description: Modifying Items.* TweakDB records to add, alter, or remove item definitions.
tags: [systems tweakdb items]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Item Record Modification

Modifying Items.* TweakDB records to add, alter, or remove item definitions.

## Approach

Mods modify `Items.*` TweakDB records via YAML tweak files to add custom items, modify existing item stats, or change item properties. This is the most common TweakDB manipulation pattern (157 mods). Changes are applied at game load time as static data. Items include weapons, clothing, consumables, and cyberware. Many mods combine this with archive file modifications for custom visual assets.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 01. Igla Double Tap - Longer Barrel-29554-1-0-1778467633 | `r6/tweaks/Igla Double Tap/Igla_DoubleTap.yaml` | Modifies Items.* TweakDB records |
| 03. EX-1 Cybercriminal-28768-1-0-1775734058 | `r6/tweaks/EX1/EX1_Cybercriminal.yaml` | Modifies Items.* TweakDB records |
| 2BT Skirts Skirts Skirts And A Dress-21070-2-0-1746284646 | `r6/tweaks/2BT/2bt_skirts.yaml` | Modifies Items.* TweakDB records |
| A Normal Pizza Option-25788-1-0-0-1763760710 | `r6/tweaks/morepizzaoptions/MorePizzaOptions.yaml` | Modifies Items.* TweakDB records |
| AK-77-14716-1-0-1715688582 | `r6/tweaks/AK_77.yaml` | Modifies Items.* TweakDB records |

*152 more mods use this pattern.*

## Related Concepts

- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
- [Runtime TweakDB Modification](/systems/tweakdb-runtime-modification.md) — Using CET or REDScript to modify TweakDB records at runtime rather than via static YAML files.
