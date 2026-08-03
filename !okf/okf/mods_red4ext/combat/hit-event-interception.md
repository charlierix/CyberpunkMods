---
type: Mechanic Pattern
title: Hit Event Interception
description: Wrapping hit processing methods to intercept and modify damage before it resolves.
tags: [combat damage hit-events]
timestamp: 2026-08-03T00:00:00Z
---

# Hit Event Interception

Wrapping hit processing methods to intercept and modify damage before it resolves.

## Approach

Mods wrap `HitEvent` processing or `ReactToHitProcess` on combat targets to intercept damage events before they are applied. At this interception point, a mod can read attack data, modify damage values, apply conditional multipliers (e.g., stealth bonuses), or cancel the hit entirely. The wrapped method calls `wrappedMethod()` to preserve original behavior, then applies modifications to the event data.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/DebtCollector/DamageTracker.reds` | Wraps `GameObject.ReactToHitProcess` |
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/armorTweaks.reds` | References HitEvent/ReactToHit |
| BullseyesKnives 1.0.0 Beta 31418 1 2026-07-11T03-48Z 8ViLVPonV | `r6/scripts/BullseyeRicochet/BullseyeRicochet.reds` | References HitEvent/ReactToHit |
| Deadly Roads-7745-v2-31b-1701881641 | `r6/scripts/Deadly Roads/core/DeadlyRoads.reds` | References HitEvent/ReactToHit |
| Deck Of Spell 32170 1.0.0 2026-08-02T05-07Z ujWojTqiR | `r6/scripts/DeckOfSpells/elements_recovery.reds` | References HitEvent/ReactToHit |

*25 more mods use this pattern.*

## Related Concepts

- [Damage System Overrides](/combat/damage-system-overrides.md) — Replacing or extending DamageSystem methods to alter how damage is calculated and applied.
- [Attack Data Modification](/combat/attack-data-modification.md) — Manipulating AttackData structures to change attack properties like damage type, range, or impact.
