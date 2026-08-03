---
type: Mechanic Pattern
title: Minimap and World Map Customization
description: Wrapping minimap and world map controllers to modify map display and interaction.
tags: [ui minimap worldmap map]
timestamp: 2026-08-03T00:00:00Z
---

# Minimap and World Map Customization

Wrapping minimap and world map controllers to modify map display and interaction.

## Approach

Mods wrap `MinimapContainerController` (18 wraps), `WorldMapMenuGameController` (28 wraps, 40 @addMethod), and `WorldMapTooltipController` (10 wraps) to modify map behavior. This includes custom map markers, modified minimap display, or additional world map features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Wraps `MinimapContainerController.InitializePlayer` |
| Custom Map Markers 3819 2.6.3 2026-08-01T19-36Z mPgaPVet3 | `r6/scripts/CustomMapMarkers/additions/MinimapContainerController.reds` | Wraps `MinimapContainerController.OnInitialize` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Services/DFPlayerStateService.reds` | Wraps `WorldMapTooltipController.SetData` |
| Drug Dealer 27800 6.5.6 2026-06-26T12-36Z 5em9eoSzt | `r6/scripts/DrugDealer/Map/Mappins.reds` | Wraps `WorldMapTooltipController.SetData` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `r6/scripts/DualSense Support/Minimap Battery Level.reds` | Wraps `MinimapContainerController.OnInitialize` |

*17 more mods use this pattern.*

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Fast Travel Overrides](/systems/fast-travel-overrides.md) — Observing FastTravelSystem events to intercept and modify fast travel behavior.
