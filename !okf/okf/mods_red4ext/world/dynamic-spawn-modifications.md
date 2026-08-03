---
type: Mechanic Pattern
title: Dynamic Spawn Modifications
description: Modifying DynamicSpawnSystem.* TweakDB records to alter dynamic entity spawning.
tags: [world spawn tweakdb dynamic]
timestamp: 2026-08-03T00:00:00Z
---

# Dynamic Spawn Modifications

Modifying DynamicSpawnSystem.* TweakDB records to alter dynamic entity spawning.

## Approach

Mods modify `DynamicSpawnSystem.*` TweakDB records to change how entities are dynamically spawned in the world. This includes custom spawn locations, modified spawn conditions, or new dynamic spawn definitions for NPCs, items, or vehicles.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Disable Car Chases - All In One 30554 1.0.1 2026-06-16T20-01Z vD6JDH8pI | `r6/tweaks/disablecarchasesgigs.yaml` | Modifies DynamicSpawnSystem.* records |
| Much Better Eddies 30532 1.3 2026-07-12T02-46Z LACBAIygB | `r6/tweaks/BetterEddies/deadchannel.yaml` | Modifies DynamicSpawnSystem.* records |
| NewGamePlus_1.3.1-15043-1-3-1-1775167014 | `red4ext/plugins/NewGamePlus/tweaks/NGPlus_FastSoloBoss.yaml` | Modifies DynamicSpawnSystem.* records |
| Reinforcements Gang Vs Gang-24243-2-0-0-1759309714 | `r6/tweaks/reinforcements_gangvgang/reinforcements/6thStreet.yaml` | Modifies DynamicSpawnSystem.* records |
| Reinforcements System 21532 1.2 2026-06-16T14-22Z iubCuMHAW | `r6/tweaks/ReinforcementsSystem/reinforcements/6thStreet.yaml` | Modifies DynamicSpawnSystem.* records |

*1 more mods use this pattern.*

## Related Concepts

- [TweakDB Character Record Modification](/systems/tweakdb-character-records.md) — Modifying Character.* TweakDB records to alter NPC and character definitions.
- [Fact System Manipulation](/systems/fact-system-manipulation.md) — Using GetFact and SetFact to read and modify game quest facts that control game state.
