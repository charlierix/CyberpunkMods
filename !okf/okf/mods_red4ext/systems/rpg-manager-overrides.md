---
type: Mechanic Pattern
title: RPG Manager Overrides
description: Wrapping RPGManager methods to modify RPG progression and reward systems.
tags: [systems rpg progression rewards]
timestamp: 2026-08-03T00:00:00Z
---

# RPG Manager Overrides

Wrapping RPGManager methods to modify RPG progression and reward systems.

## Approach

Mods wrap `RPGManager` methods (18 wraps) to modify RPG progression mechanics. This includes changed XP rewards, modified level scaling, or custom progression rules. The RPG manager controls experience gain, level-up mechanics, and reward calculation.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `r6/scripts/Better Leveling (Revamp of Custom Level Cap)/BTL_00_Main.reds` | Wraps `RPGManager.CalculateMinorActivityReward` |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Main/CAMainSystem.reds` | Wraps `RPGManager.ConsumeItem` |
| Craft All-23494-1-0-0-1755273337 | `r6/scripts/Craft All/Craft All.reds` | Wraps `RPGManager.ProcessOnLootedPackages` |
| Doctrine Hydra V1.0.3 32034 1.0.3 2026-08-03T07-48Z psSjsvrFY | `r6/scripts/DoctrineMultiTargetLauncher/35_module_slot_matching.reds` | Wraps `RPGManager.GetModsSlotIDs` |
| Kolac Expanded-24491-1-3-1771507690 | `r6/scripts/KolacExpanded/KolacExpanded.reds` | Wraps `RPGManager.GetModsSlotIDs` |

*7 more mods use this pattern.*

## Related Concepts

- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
