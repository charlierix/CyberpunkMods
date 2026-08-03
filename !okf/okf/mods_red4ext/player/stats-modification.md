---
type: Mechanic Pattern
title: Stats System Modification
description: Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
tags: [player stats modifiers]
timestamp: 2026-08-03T00:00:00Z
---

# Stats System Modification

Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.

## Approach

Mods reference `StatsSystem` (417 occurrences), `gameStatModifierType`, and `gameStatModifierData` to modify character stats at runtime. This includes applying custom stat modifiers, reading stat values for conditional behavior, or modifying stat calculation pipelines. Some mods also modify `BaseStats.*` TweakDB records for static stat definitions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/Core/System.reds` | References StatsSystem/stat modifiers |
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | References StatsSystem/stat modifiers |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/CustomHackingSystem/Main/CustomHackingSystem.reds` | References StatsSystem/stat modifiers |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/CustomHackingSystem/Main/CustomHackingSystem.reds` | References StatsSystem/stat modifiers |
| Anti-Tracking Breach-27505-2-0-1773756783 | `r6/scripts/Anti-TrackingBreach/AntiTrackingBreach.reds` | References StatsSystem/stat modifiers |

*55 more mods use this pattern.*

## Related Concepts

- [TweakDB Base Stats Modification](/player/tweakdb-base-stats.md) — Modifying BaseStats.* TweakDB records to alter base character statistics.
- [Damage System Overrides](/combat/damage-system-overrides.md) — Replacing or extending DamageSystem methods to alter how damage is calculated and applied.
- [RPG Manager Overrides](/systems/rpg-manager-overrides.md) — Wrapping RPGManager methods to modify RPG progression and reward systems.
