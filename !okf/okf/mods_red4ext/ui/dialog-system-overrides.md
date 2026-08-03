---
type: Mechanic Pattern
title: Dialog System Overrides
description: Overriding InteractionUIBase and dialog controllers to modify dialog interaction behavior.
tags: [ui dialog interaction]
timestamp: 2026-08-03T00:00:00Z
---

# Dialog System Overrides

Overriding InteractionUIBase and dialog controllers to modify dialog interaction behavior.

## Approach

Mods use CET `Override` on `InteractionUIBase.OnDialogsData`, `OnDialogsSelectIndex`, and `dialogWidgetGameController.OnDialogsActivateHub` (6 instances each) to modify dialog behavior. This enables custom dialog options, modified hub menu interactions, or extended dialog system features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/Modules/hud.lua` | CET Override `dialogWidgetGameController.OnDialogsActivateHub` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/InteractionUI.lua` | CET Override `dialogWidgetGameController.OnDialogsActivateHub` |
| Gambling System - Roulette 15450 1.1.3 2026-06-13T22-43Z 5em9eoS1b | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/External/interactionUI.lua` | CET Override `dialogWidgetGameController.OnDialogsActivateHub` |
| Panam's Voicemail-23407-2-2-1755674552 | `bin/x64/plugins/cyber_engine_tweaks/mods/panam_wanted_mod/modules/interactionUI.lua` | CET Override `dialogWidgetGameController.OnDialogsActivateHub` |
| SkillTrainers V-1-0-7.zip-12689-1-0-7-1771082449 | `bin/x64/plugins/cyber_engine_tweaks/mods/skilltrainers/external/InteractionUI.lua` | CET Override `dialogWidgetGameController.OnDialogsActivateHub` |

*1 more mods use this pattern.*

## Related Concepts

- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
- [In-Game Menu Overrides](/ui/ingame-menu-overrides.md) — Wrapping gameuiInGameMenuGameController to modify in-game menu behavior.
