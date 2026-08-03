---
type: Mechanic Pattern
title: Quest Tracker UI
description: Observing and wrapping QuestTrackerGameController to modify quest tracker display.
tags: [ui quest-tracker quests]
timestamp: 2026-08-03T00:00:00Z
---

# Quest Tracker UI

Observing and wrapping QuestTrackerGameController to modify quest tracker display.

## Approach

Mods observe `QuestTrackerGameController.OnInitialize` and `OnUninitialize` (33 instances each) via CET to intercept quest tracker initialization. This enables custom quest tracking display, modified quest tracker behavior, or additional quest information in the HUD.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFInteractionSystem.reds` | Wraps `QuestTrackerGameController.OnStateChanges` |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `QuestTrackerGameController.OnInitialize` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameSession.lua` | CET Observe `QuestTrackerGameController.OnInitialize` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameSession.lua` | CET Observe `QuestTrackerGameController.OnInitialize` |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua` | CET Observe `QuestTrackerGameController.OnInitialize` |

*31 more mods use this pattern.*

## Related Concepts

- [Fact System Manipulation](/systems/fact-system-manipulation.md) — Using GetFact and SetFact to read and modify game quest facts that control game state.
- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
