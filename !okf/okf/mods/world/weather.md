---
type: Mechanic Pattern
title: "Weather"
description: "Weather system control, precipitation, fog, and environment effect manipulation patterns"
tags: [world, weather]
timestamp: 2026-07-04T00:00:00Z
---

# Weather

Weather system control, precipitation, fog, and environment effect manipulation patterns.

## Weather State Control

Forcing or modifying weather states via GetWeatherSystem (rain, fog, clear, etc.).

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Baronz Chair 2.21 2.3 and 2.31 game versions-24785-1-1-0-1766786868 | `r6/tweaks/oranje3_baronz_chair/oranje3_baronz_chair.yaml:354` | driveLayout: LocKey#oranje3_baronz_chair_drivetrain |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/dinohood_EEX_fix_tta.yml` | Items.lokiina_dinohood_rainbow_EEX: |
| Mr. Blue Eyes and Akira Bodyguard - 11.0.0-22696-11-0-0-1760414864 | `r6/tweaks/Akira_Bodyguard/Akira_Bodyguard.yaml` | - Items.Preset_Katana_Training |
| Nomad Trailer Apartment-27369-2-0-1773573312 | `archive/pc/mod/Nomad_Trailer_Boundary.xl` | {"streaming":{"sectors":[{"nodeDeletions":[{"resource":"base\\surfaces\\materials\\terrain\\soil\\so |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:494` | driveLayout: LocKey#oranje3_m9_project_drivetrain |
| Oranje 3 The Wobbler Monowheel 2.3 2.31-21069-1-10-1766742137 | `r6/tweaks/monowheel/oranje3_monowheel.yaml:351` | driveLayout: LocKey#oranje3_monowheel_drivetrain |
| Oranje3 911 Turbo Trike 2.3 2.31 2.21-24365-1-1-0-1766783118 | `r6/tweaks/oranje3_johnnys_trike/oranje3_johnnys_trike.yaml:56` | $base: Vehicle.FxWheels_AllTerrain_XL |
| void_Buttons-16527-1-3-1737740890 | `r6/tweaks/yellingintothevoid/void_Buttons.yaml:15` | - { base_color: gold,   logoa: mox_dancers,     logob: braindance,             logoc: mox_ftd,       |

*250 more mods use this pattern.*

## Custom Weather

Creating custom weather types, environmental effects, and atmospheric modifications.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:2993` | weatherfile("CustomWeatherStates/NovaCity2WeatherStates.json") |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:3037` | weatherfile("CustomWeatherStates/NovaCity2WeatherStates.json") |
| Dynamic Wardrobe-27791-2-1-1773744332 | `r6/scripts/Dynamic Wardrobe/Events/WeatherTimeHandler.reds:47` | player.m_wardrobeWeatherCallbackId = weatherSystem.RegisterWeatherListener(weatherListener); |
| Immersive Companion Generative Texting-25894-5-0-0-1766456471 | `generative-texting-context-aware-main/r6/scripts/generative-texting-context-aware-main/ContextEventManager.reds:61` | this.lastWeatherType = weatherSystem.GetRainIntensityType(); |
| DynamicNPCItems-v1.5-16158-1-5-1742833376 | `r6/scripts/DynamicNPCItems/Main.reds:239` | this.m_weatherCallbackId = GameInstance.GetWeatherSystem(GetGameInstance()).RegisterWeatherListener( |


## Related Concepts

- [World State](..//systems/world-state.md) — related manipulation pattern
