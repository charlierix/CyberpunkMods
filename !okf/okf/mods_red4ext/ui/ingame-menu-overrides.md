---
type: Mechanic Pattern
title: In-Game Menu Overrides
description: Wrapping gameuiInGameMenuGameController to modify in-game menu behavior.
tags: [ui menu ingame]
timestamp: 2026-08-03T00:00:00Z
---

# In-Game Menu Overrides

Wrapping gameuiInGameMenuGameController to modify in-game menu behavior.

## Approach

Mods wrap `gameuiInGameMenuGameController` (11 wraps, 7 @addMethod) to modify in-game menu behavior. This includes custom menu options, modified radial menu behavior, or additional menu entries.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/Hooks.reds` | Wraps `gameuiInGameMenuGameController.OnDeathScreenDelayEvent` |
| AutoWalkToggle 31218 2 2026-07-06T19-28Z VquAqYzZD | `r6/scripts/AutoRunToggle/AutoRunToggle.reds` | Wraps `gameuiInGameMenuGameController.OnInitialize` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFStashCraftingSystem.reds` | Wraps `gameuiInGameMenuGameController.OnInitialize` |
| Equipment-EX-6945-1-2-9-1773737132 | `r6/scripts/EquipmentEx/EquipmentEx.Global.reds` | Wraps `gameuiInGameMenuGameController.OnInitialize` |
| Fact Finder-12735-2-12-00-1709251155 | `r6/scripts/FactFinder/FactFinder.reds` | Wraps `gameuiInGameMenuGameController.OnInitialize` |

*2 more mods use this pattern.*

## Related Concepts

- [Menu Controller Overrides](/ui/menu-controller-overrides.md) — Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.
- [Ink Widget Extensions](/ui/ink-widget-extensions.md) — Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
