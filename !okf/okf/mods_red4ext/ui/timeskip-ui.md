---
type: Mechanic Pattern
title: Timeskip UI
description: Wrapping TimeskipGameController to modify the time-skip interaction.
tags: [ui timeskip time]
timestamp: 2026-08-03T00:00:00Z
---

# Timeskip UI

Wrapping TimeskipGameController to modify the time-skip interaction.

## Approach

Mods wrap `TimeskipGameController` (24 wraps, 18 @addMethod) to modify the time-skip feature. This includes custom time-skip behavior, modified time progression, or additional time-skip options.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/cyberwareScripts/toolHandRepair.reds` | Wraps `TimeskipGameController.OnCloseAfterFinishing` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/UI/DFTimeskipMenuUI.reds` | Wraps `TimeskipGameController.OnInitialize` |
| Immersive Timeskip-5115-2-2-2-1767878170 | `r6/scripts/ImmersiveTimeskip/base/TimeskipGameController-added.reds` | Adds `TimeskipGameController.TweakWidgetAppearance` |
| Survival System-7510-v0-91b-1734794608 | `r6/scripts/Survival System/core/ControllerTimeskip.reds` | Wraps `TimeskipGameController.OnInitialize` |

## Related Concepts

- [Fact System Manipulation](/systems/fact-system-manipulation.md) — Using GetFact and SetFact to read and modify game quest facts that control game state.
- [Menu Controller Overrides](/ui/menu-controller-overrides.md) — Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.
