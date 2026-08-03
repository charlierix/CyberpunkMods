---
type: Mechanic Pattern
title: Fact System Manipulation
description: Using GetFact and SetFact to read and modify game quest facts that control game state.
tags: [systems facts quest state]
timestamp: 2026-08-03T00:00:00Z
---

# Fact System Manipulation

Using GetFact and SetFact to read and modify game quest facts that control game state.

## Approach

Mods use `GetFact` (263 occurrences) and `SetFact`/`SetFactValue` (258 occurrences) to read and modify game quest facts. Facts are boolean/integer game state variables that control quest progression, NPC behavior, and world state. This enables mods to check game state, trigger quest-like behavior, or modify game progression. Some mods also use `QuestSystem` for more advanced quest manipulation.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Main.reds` | Uses GetFact/SetFact |
| BrowserExtensionFramework-10038-0-9-7-1758341320 | `r6/scripts/BrowserExtension/browserController.overrides.reds` | Uses GetFact/SetFact |
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Uses GetFact/SetFact |
| Completely Non-Manual Looting-16040-2-13-01-1727125795 | `r6/scripts/Completely Non-Manual Loot/CNML.reds` | Uses GetFact/SetFact |
| Computer Anywhere 12520 2.2.0 2026-07-30T18-54Z Co8doeA0Q | `r6/scripts/liftcheck.reds` | Uses GetFact/SetFact |

*39 more mods use this pattern.*

## Related Concepts

- [Prevention System Overrides](/systems/prevention-system-overrides.md) — Wrapping PreventionSystem to modify police response and crime detection behavior.
- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
