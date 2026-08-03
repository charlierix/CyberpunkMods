---
type: Mechanic Pattern
title: Player Development Overrides
description: Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
tags: [player perks skills progression]
timestamp: 2026-08-03T00:00:00Z
---

# Player Development Overrides

Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.

## Approach

Mods wrap `PlayerDevelopmentData` methods (15 wraps, 33 @addMethod) to modify how the player gains perks, attributes, and skills. This includes custom perk trees, modified leveling curves, or additional development options. The `@addMethod` pattern is used to add new methods to the player development system.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Auto Leveler-27010-2-31-01-1769096078 | `r6/scripts/Auto Leveler/AutoLevel.reds` | Wraps `PlayerDevelopmentData.OnRestored` |
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `r6/scripts/Better Leveling (Revamp of Custom Level Cap)/BTL_00_Main.reds` | References PlayerDevelopmentData |
| Daemon Netrunning (Revamp)-23894-1-2-1-1759846597 | `r6/scripts/Daemon Netrunning (Revamp)/DNR_Core.reds` | References PlayerDevelopmentData |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Main/DFMainSystem.reds` | References PlayerDevelopmentData |
| Dash Fix-16272-1-0-0-1723844109 | `r6/scripts/DashFix/DashFix.reds` | References PlayerDevelopmentData |

*13 more mods use this pattern.*

## Related Concepts

- [TweakDB Perk Modifications](/systems/tweakdb-perks.md) — Modifying NewPerks.* TweakDB records to add or alter perk definitions.
- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
