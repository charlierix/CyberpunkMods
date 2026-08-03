---
type: Mechanic Pattern
title: Attack Data Modification
description: Manipulating AttackData structures to change attack properties like damage type, range, or impact.
tags: [combat attack-data damage]
timestamp: 2026-08-03T00:00:00Z
---

# Attack Data Modification

Manipulating AttackData structures to change attack properties like damage type, range, or impact.

## Approach

Mods reference `AttackData` structures within hit events or damage calculations to modify attack properties. This includes changing damage types, adding elemental effects, modifying attack ranges, or altering impact force values.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/armorTweaks.reds` | References AttackData |
| Deadly Roads-7745-v2-31b-1701881641 | `r6/scripts/Deadly Roads/core/DeadlyRoads.reds` | References AttackData |
| ExplosionShake V2.11 31285 2.11 2026-07-13T15-41Z 8ViLVPoT0 | `r6/scripts/ExplosionShake.reds` | References AttackData |
| MEArmorSystem 30548 1.0.4 2026-06-24T22-55Z 6ZNKZci2Q | `r6/scripts/EnemyArmorOverhaul/damageArmor.reds` | References AttackData |
| Melee Attacks Fixes And Enhancements-16921-0-41-1761400779 | `r6/scripts/MeleeAttacksFixesAndImprovements.reds` | References AttackData |

*14 more mods use this pattern.*

## Related Concepts

- [Hit Event Interception](/combat/hit-event-interception.md) — Wrapping hit processing methods to intercept and modify damage before it resolves.
- [TweakDB Attack Record Modification](/combat/tweakdb-attack-records.md) — Modifying Attacks.* TweakDB records to alter static attack damage values and properties.
