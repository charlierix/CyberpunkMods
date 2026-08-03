---
type: Mechanic Pattern
title: Damage System Overrides
description: Replacing or extending DamageSystem methods to alter how damage is calculated and applied.
tags: [combat damage damage-system]
timestamp: 2026-08-03T00:00:00Z
---

# Damage System Overrides

Replacing or extending DamageSystem methods to alter how damage is calculated and applied.

## Approach

Mods use `@wrapMethod(DamageSystem)` to override damage calculation pipelines. This allows modifying damage types, applying custom damage reduction (e.g., armor calculations), or redirecting damage application. Unlike hit event interception, this operates at the system level rather than per-hit.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/armorTweaks.reds` | Wraps `DamageSystem.ProcessArmor` |
| Deadly Roads-7745-v2-31b-1701881641 | `r6/scripts/Deadly Roads/core/DeadlyRoads.reds` | References DamageSystem |
| Deck Of Spell 32170 1.0.0 2026-08-02T05-07Z ujWojTqiR | `r6/scripts/DeckOfSpells/elements_recovery.reds` | Wraps `DamageSystem.ProcessPipeline` |
| ExplosionShake V2.11 31285 2.11 2026-07-13T15-41Z 8ViLVPoT0 | `r6/scripts/ExplosionShake.reds` | Wraps `DamageSystem.ProcessLocalizedDamage` |
| ImmersiveShootingAI 22782 1.1 2026-06-16T09-25Z Z0ER0BulY | `r6/scripts/ImmersiveShootingAI/accuracy.reds` | Wraps `DamageSystem.ProcessOneShotProtection` |

*12 more mods use this pattern.*

## Related Concepts

- [Hit Event Interception](/combat/hit-event-interception.md) — Wrapping hit processing methods to intercept and modify damage before it resolves.
- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
