---
type: Mechanic Pattern
title: NPC Puppet Extensions
description: Adding methods to NPCPuppet via @addMethod to extend NPC behavior and capabilities.
tags: [systems npc extensions]
timestamp: 2026-08-03T00:00:00Z
---

# NPC Puppet Extensions

Adding methods to NPCPuppet via @addMethod to extend NPC behavior and capabilities.

## Approach

Mods use `@addMethod(NPCPuppet)` (26 instances) to add new methods to the NPC entity class. This enables custom NPC behavior, extended NPC state tracking, or integration of NPC-specific mod features. NPCPuppet is the base class for all NPC entities, so additions here affect all NPCs.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Deck Of Spell 32170 1.0.0 2026-08-02T05-07Z ujWojTqiR | `r6/scripts/DeckOfSpells/elements_recovery.reds` | Adds `NPCPuppet.RecordDeckElementsDamage` |
| DynamicEnemyMultiplier_1.1 31555 1.1 2026-07-17T00-18Z k8Iw8mCTa | `r6/scripts/DynamicEnemyMultiplier/CloneCombatBehavior.reds` | Adds `NPCPuppet.SEMSetOriginal` |
| MEArmorSystem 30548 1.0.4 2026-06-24T22-55Z 6ZNKZci2Q | `r6/scripts/EnemyArmorOverhaul/npcPuppetAdditions.reds` | Adds `NPCPuppet.MEAddAddrenaline` |
| Much Better Eddies 30532 1.3 2026-07-12T02-46Z LACBAIygB | `r6/scripts/BetterEddies/DeadChannel/DeadChannelDroneAttitude.reds` | Adds `NPCPuppet.MBE_DCAllyAttitudeFix` |
| Reinforcements Gang Vs Gang-24243-2-0-0-1759309714 | `r6/scripts/reinforcements_gangvgang/SpawnAttiutudeFixer.reds` | Adds `NPCPuppet.GRAttitudeFix` |

*3 more mods use this pattern.*

## Related Concepts

- [Reaction Manager Overrides](/systems/reaction-manager-overrides.md) — Wrapping ReactionManagerComponent to modify NPC reaction behavior.
- [Death and Defeat Handling](/player/death-and-defeat-handling.md) — Wrapping OnDeath and OnDefeated on PlayerPuppet and ScriptedPuppet to intercept death/defeat events.
