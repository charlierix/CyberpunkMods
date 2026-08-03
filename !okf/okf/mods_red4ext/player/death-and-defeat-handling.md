---
type: Mechanic Pattern
title: Death and Defeat Handling
description: Wrapping OnDeath and OnDefeated on PlayerPuppet and ScriptedPuppet to intercept death/defeat events.
tags: [player death defeat npc]
timestamp: 2026-08-03T00:00:00Z
---

# Death and Defeat Handling

Wrapping OnDeath and OnDefeated on PlayerPuppet and ScriptedPuppet to intercept death/defeat events.

## Approach

Mods wrap `PlayerPuppet.OnDeath`, `ScriptedPuppet.OnDefeated`, and `NPCPuppet` death methods to intercept when characters die or are defeated. This enables custom death behavior, modified defeat handling, death penalties, or revival mechanics.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/DebtCollector/DebtCollector.reds` | Wraps `PlayerPuppet.OnDeath` |
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/Hooks.reds` | Wraps `ScriptedPuppet.OnDefeated` |
| Deck Of Spell 32170 1.0.0 2026-08-02T05-07Z ujWojTqiR | `r6/scripts/DeckOfSpells/elements_recovery.reds` | Wraps `ScriptedPuppet.OnDefeated` |
| Drug Dealer 27800 6.5.6 2026-06-26T12-36Z 5em9eoSzt | `r6/scripts/DrugDealer/Spawn/EntitySpawnSystem.reds` | Wraps `ScriptedPuppet.OnDefeated` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameSession.lua` | CET Observe `PlayerPuppet.OnDeath` |

*22 more mods use this pattern.*

## Related Concepts

- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
- [Combat State Transitions](/player/combat-state-transitions.md) — Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.
