---
type: Mechanic Pattern
title: CET ImGui Overlays
description: Using CET ImGui API to create custom UI overlays and mod configuration windows.
tags: [ui imgui lua cet overlays]
timestamp: 2026-08-03T00:00:00Z
---

# CET ImGui Overlays

Using CET ImGui API to create custom UI overlays and mod configuration windows.

## Approach

Mods use the Cyber Engine Tweaks (CET) ImGui API to draw custom UI overlays, configuration windows, and debug displays. This is a Lua-only pattern that creates immediate-mode GUI elements rendered on top of the game. Common uses include mod settings panels, debug overlays, and custom HUD elements that don't integrate with the native ink widget system.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ActualCantoBlackwall 25849 1.0.0.1 2026-07-27T14-38Z VquAqYzfW | `bin/x64/plugins/cyber_engine_tweaks/mods/ActualCantoBlackwall/init.lua` | Uses CET ImGui for UI |
| CompassBar-22655-2-0-1770283479 | `bin/x64/plugins/cyber_engine_tweaks/mods/CompassBar/init.lua` | Uses CET ImGui for UI |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/init.lua` | Uses CET ImGui for UI |
| DriveVibration-28682-0-0-1-1775470587 | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveVibration/init.lua` | Uses CET ImGui for UI |
| Easy Teleport-26570-1-0-4-1767111735 | `bin/x64/plugins/cyber_engine_tweaks/mods/easy_teleport/ui.lua` | Uses CET ImGui for UI |

*24 more mods use this pattern.*

## Related Concepts

- [Ink Widget Extensions](/ui/ink-widget-extensions.md) — Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
- [Runtime TweakDB Modification](/systems/tweakdb-runtime-modification.md) — Using CET or REDScript to modify TweakDB records at runtime rather than via static YAML files.
