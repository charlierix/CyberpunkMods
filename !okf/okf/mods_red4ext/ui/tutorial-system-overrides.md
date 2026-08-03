---
type: Mechanic Pattern
title: Tutorial System Overrides
description: Observing tutorial popup controllers to modify tutorial behavior.
tags: [ui tutorial popups]
timestamp: 2026-08-03T00:00:00Z
---

# Tutorial System Overrides

Observing tutorial popup controllers to modify tutorial behavior.

## Approach

Mods observe `gameuiTutorialPopupGameController.PauseGame` (33 instances) via CET to intercept tutorial popups. This enables disabling tutorials, custom tutorial content, or modified tutorial timing.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `gameuiTutorialPopupGameController.PauseGame` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameSession.lua` | CET Observe `gameuiTutorialPopupGameController.PauseGame` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameSession.lua` | CET Observe `gameuiTutorialPopupGameController.PauseGame` |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua` | CET Observe `gameuiTutorialPopupGameController.PauseGame` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `gameuiTutorialPopupGameController.PauseGame` |

*21 more mods use this pattern.*

## Related Concepts

- [Menu Controller Overrides](/ui/menu-controller-overrides.md) — Wrapping menu game controllers to modify settings, pause menu, and main menu behavior.
- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
