---
type: Mechanic Pattern
title: Menu Controller Overrides
description: Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.
tags: [ui menus settings pause-menu]
timestamp: 2026-08-03T00:00:00Z
---

# Menu Controller Overrides

Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.

## Approach

Mods wrap `SettingsMainGameController` (24 wraps), `PauseMenuGameController` (12 wraps), `SingleplayerMenuGameController` (11 wraps), and `MenuScenario_HubMenu` to modify menu behavior. This includes custom settings options, modified pause menu functionality, or additional menu entries. The `@addMethod(SettingsMainGameController)` pattern (28 instances) is used to add mod settings integration via the Mod Settings framework.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| (DriveCE) Mod Settings-10032-2-0-0-1697876886 | `r6/scripts/DriveCarefullyExpanded/DriveCarefullyExpanded.reds` | Wraps `SettingsMainGameController.IsResetButtonEnabled` |
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/PreGame.reds` | References menu controllers |
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Wraps `SettingsMainGameController.OnUninitialize` |
| Custom Map Markers 3819 2.6.3 2026-08-01T19-36Z mPgaPVet3 | `r6/scripts/CustomMapMarkers/additions/MenuScenario_HubMenu.reds` | References menu controllers |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFStashCraftingSystem.reds` | References menu controllers |

*38 more mods use this pattern.*

## Related Concepts

- [Ink Widget Extensions](/ui/ink-widget-extensions.md) — Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
- [ScriptableService Registration](/systems/scriptable-service-registration.md) — Using the ScriptableService pattern to create persistent background services that run throughout the game session.
