---
type: Mechanic Pattern
title: TweakDB Effector Modifications
description: Modifying Effectors.* TweakDB records to alter game effectors that apply stat modifications.
tags: [systems tweakdb effectors stats]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Effector Modifications

Modifying Effectors.* TweakDB records to alter game effectors that apply stat modifications.

## Approach

Mods modify `Effectors.*` TweakDB records to change how effectors apply stat modifications. Effectors are TweakDB-defined components that modify stats based on conditions — such as perk bonuses, equipment effects, or status effect modifiers. This is a lower-level stat modification approach compared to direct stat system manipulation.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Jackpot-15925-1-1-1725605473 | `r6/tweaks/Jackpot_Overture/Jackpot_Overture.yaml` | Modifies Effectors.* records |
| MEArmorSystem 30548 1.0.4 2026-06-24T22-55Z 6ZNKZci2Q | `r6/tweaks/EnemyArmorOverhaul/bosses.yaml` | Modifies Effectors.* records |
| Melee Overhaul-20792-1-0-1-1744018227 | `MeleeOverhaul/r6/tweaks/MeleeOverhaul/EnemyAI/BaseStats/Effectors.HitReactionTBHIncrease_inline6.value.yaml` | Modifies Effectors.* records |
| Pyromania Unchained-19517-1-1-3-1740934944 | `r6/tweaks/PyromaniaUnchained/AllExplosions.yaml` | Modifies Effectors.* records |
| Rebar Club-15874-1-1-1723878737 | `r6/tweaks/Rebar club/Rebar club.yaml` | Modifies Effectors.* records |

*5 more mods use this pattern.*

## Related Concepts

- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
- [TweakDB Status Effect Records](/systems/tweakdb-status-effects.md) — Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.
