---
type: Mechanic Pattern
title: Loading Screen Customization
description: Customizing loading screen display via LoadingScreenProgressBarController.
tags: [media loading-screen ui]
timestamp: 2026-08-03T00:00:00Z
---

# Loading Screen Customization

Customizing loading screen display via LoadingScreenProgressBarController.

## Approach

Mods observe `LoadingScreenProgressBarController.SetProgress` via CET to intercept loading screen progress updates. This enables custom loading screen visuals, progress indicators, or loading screen modifications.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `LoadingScreenProgressBarController.SetProgress` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `LoadingScreenProgressBarController.SetProgress` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameUI.lua` | CET Observe `LoadingScreenProgressBarController.SetProgress` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `LoadingScreenProgressBarController.SetProgress` |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/External/GameUI.lua` | CET Observe `LoadingScreenProgressBarController.SetProgress` |

*17 more mods use this pattern.*

## Related Concepts

- [Menu Controller Overrides](/ui/menu-controller-overrides.md) — Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.
- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
