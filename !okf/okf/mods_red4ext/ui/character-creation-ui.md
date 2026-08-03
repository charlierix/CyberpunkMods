---
type: Mechanic Pattern
title: Character Creation UI
description: Wrapping CharacterCreationStatsMenu to modify character creation interface.
tags: [ui character-creation appearance]
timestamp: 2026-08-03T00:00:00Z
---

# Character Creation UI

Wrapping CharacterCreationStatsMenu to modify character creation interface.

## Approach

Mods wrap `CharacterCreationStatsMenu` (9 wraps) to modify the character creation interface. This includes custom appearance options, modified stat allocation, or additional character creation features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `r6/scripts/Better Leveling (Revamp of Custom Level Cap)/BTL_00_Main.reds` | Wraps `CharacterCreationStatsMenu.ResetAllBtnBackToBaseline` |
| Graven's Customizable Character Creation-10348-1-0-1698021055 | `r6/scripts/Graven's Customizable Character Creation/gravenCharacterCreationBase.reds` | Wraps `CharacterCreationStatsMenu.OnInitialize` |
| NewGamePlus_1.3.1-15043-1-3-1-1775167014 | `red4ext/plugins/NewGamePlus/redscript/NGPlusCharacterInitialStats.reds` | Wraps `CharacterCreationStatsMenu.OnInitialize` |

## Related Concepts

- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
