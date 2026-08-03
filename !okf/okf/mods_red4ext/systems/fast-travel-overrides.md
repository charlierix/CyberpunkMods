---
type: Mechanic Pattern
title: Fast Travel Overrides
description: Observing FastTravelSystem events to intercept and modify fast travel behavior.
tags: [systems fast-travel travel]
timestamp: 2026-08-03T00:00:00Z
---

# Fast Travel Overrides

Observing FastTravelSystem events to intercept and modify fast travel behavior.

## Approach

Mods observe `FastTravelSystem.OnPerformFastTravelRequest`, `OnLoadingScreenFinished`, and `OnUpdateFastTravelPointRecordRequest` via CET to intercept fast travel events. This enables custom fast travel behavior, restricted travel destinations, or modified travel costs.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `FastTravelSystem.OnUpdateFastTravelPointRecordRequest` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameSession.lua` | CET Observe `FastTravelSystem.OnUpdateFastTravelPointRecordRequest` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameSession.lua` | CET Observe `FastTravelSystem.OnUpdateFastTravelPointRecordRequest` |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua` | CET Observe `FastTravelSystem.OnUpdateFastTravelPointRecordRequest` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `FastTravelSystem.OnToggleFastTravelAvailabilityOnMapRequest` |

*21 more mods use this pattern.*

## Related Concepts

- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
- [Loading Screen Customization](/media/loading-screen-customization.md) — Customizing loading screen display via LoadingScreenProgressBarController.
