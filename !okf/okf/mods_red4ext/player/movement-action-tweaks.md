---
type: Mechanic Pattern
title: Movement Action Tweaks
description: Modifying MovementActions.* TweakDB records to alter movement mechanics.
tags: [player movement tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Movement Action Tweaks

Modifying MovementActions.* TweakDB records to alter movement mechanics.

## Approach

Mods modify `MovementActions.*` TweakDB records to change movement-related actions. This includes sprint speed, jump height, dodge mechanics, or other movement parameters defined as static TweakDB data.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Melee Overhaul-20792-1-0-1-1744018227 | `MeleeOverhaul/r6/tweaks/MeleeOverhaul/EnemyAI/Chasing/CatchUpDistance.yaml` | Modifies MovementActions.* records |
| Sandevistan Enhanced-20953-1-0-0-1744552512 | `Sandevistan Enhanced/r6/tweaks/Sandevistan/Sandevistan/SandevistanCondition.yaml` | Modifies MovementActions.* records |

## Related Concepts

- [Movement State Events](/player/movement-state-events.md) — Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
- [TweakDB Base Stats Modification](/player/tweakdb-base-stats.md) — Modifying BaseStats.* TweakDB records to alter base character statistics.
