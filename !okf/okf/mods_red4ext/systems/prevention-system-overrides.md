---
type: Mechanic Pattern
title: Prevention System Overrides
description: Wrapping PreventionSystem to modify police response and crime detection behavior.
tags: [systems prevention police crime]
timestamp: 2026-08-03T00:00:00Z
---

# Prevention System Overrides

Wrapping PreventionSystem to modify police response and crime detection behavior.

## Approach

Mods wrap `PreventionSystem` methods (30 wraps, 14 @addMethod) to modify how the game handles crime detection and police response. This includes changing police spawn behavior, modifying crime level thresholds, or disabling prevention entirely. The prevention system controls the wanted level and police response mechanics.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/CounterMeasure/NotifyNcpd/NotifyNcpd.reds` | References PreventionSystem |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/CounterMeasure/NotifyNcpd/NotifyNcpd.reds` | References PreventionSystem |
| Borderline Psycho 31363 1.4 2026-07-13T16-28Z q7jg7fhSv | `r6/scripts/z_BorderlinePsycho/BorderlinePsycho.reds` | References PreventionSystem |
| Completely Non-Manual Looting-16040-2-13-01-1727125795 | `r6/scripts/Completely Non-Manual Loot/CNML.reds` | References PreventionSystem |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Services/CAAnimationService.reds` | References PreventionSystem |

*24 more mods use this pattern.*

## Related Concepts

- [Combat State Transitions](/player/combat-state-transitions.md) — Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.
- [Reaction Manager Overrides](/systems/reaction-manager-overrides.md) — Wrapping ReactionManagerComponent to modify NPC reaction behavior.
- [Fact System Manipulation](/systems/fact-system-manipulation.md) — Using GetFact and SetFact to read and modify game quest facts that control game state.
