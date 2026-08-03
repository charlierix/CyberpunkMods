---
type: Mechanic Pattern
title: Reaction Manager Overrides
description: Wrapping ReactionManagerComponent to modify NPC reaction behavior.
tags: [systems npc reactions ai]
timestamp: 2026-08-03T00:00:00Z
---

# Reaction Manager Overrides

Wrapping ReactionManagerComponent to modify NPC reaction behavior.

## Approach

Mods wrap `ReactionManagerComponent` (15 wraps) to modify how NPCs react to stimuli. This includes changing aggro behavior, modified detection ranges, or custom reaction triggers. The reaction manager controls NPC awareness and combat engagement decisions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/Hooks.reds` | Wraps `ReactionManagerComponent.OnIncapacitatedEvent` |
| Drug Dealer 27800 6.5.6 2026-06-26T12-36Z 5em9eoSzt | `r6/scripts/DrugDealer/Job/SellDrugs/Interaction.reds` | Wraps `ReactionManagerComponent.OnPlayerProximityStartEvent` |
| DynamicEnemyMultiplier_1.1 31555 1.1 2026-07-17T00-18Z k8Iw8mCTa | `r6/scripts/DynamicEnemyMultiplier/CloneCombatBehavior.reds` | Wraps `ReactionManagerComponent.ShouldIgnoreCombatStim` |
| Reinforcements Gang Vs Gang-24243-2-0-0-1759309714 | `r6/scripts/reinforcements_gangvgang/ReinforcementsCall.reds` | Wraps `ReactionManagerComponent.HandleStimEvent` |
| Reinforcements System 21532 1.2 2026-06-16T14-22Z iubCuMHAW | `r6/scripts/ReinforcementsSystem/ReinforcementsCall.reds` | Wraps `ReactionManagerComponent.HandleStimEvent` |

*6 more mods use this pattern.*

## Related Concepts

- [Prevention System Overrides](/systems/prevention-system-overrides.md) — Wrapping PreventionSystem to modify police response and crime detection behavior.
- [AI Behavior Modification](/systems/ai-behavior-modification.md) — Modifying AI behavior classes and AISubAction records to alter NPC AI behavior.
- [NPC Puppet Extensions](/systems/npc-puppet-extensions.md) — Adding methods to NPCPuppet via @addMethod to extend NPC behavior and capabilities.
