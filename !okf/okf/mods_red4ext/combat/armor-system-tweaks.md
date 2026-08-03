---
type: Mechanic Pattern
title: Armor System Tweaks
description: Modifying ArmorUp.* TweakDB records to alter armor calculation and damage reduction.
tags: [combat armor tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Armor System Tweaks

Modifying ArmorUp.* TweakDB records to alter armor calculation and damage reduction.

## Approach

Mods modify `ArmorUp.*` TweakDB records to change how armor mitigates damage. This allows custom armor rating curves, damage type resistances, or conditional armor effectiveness.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/tweaks/ArmorUp/z_vendors.yaml` | Modifies ArmorUp.* records |

## Related Concepts

- [Damage System Overrides](/combat/damage-system-overrides.md) — Replacing or extending DamageSystem methods to alter how damage is calculated and applied.
- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
