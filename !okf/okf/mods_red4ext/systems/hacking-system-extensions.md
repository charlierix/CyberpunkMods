---
type: Mechanic Pattern
title: Hacking System Extensions
description: Extending quickhack and hacking system classes to modify network breach and quickhack behavior.
tags: [systems hacking quickhack network]
timestamp: 2026-08-03T00:00:00Z
---

# Hacking System Extensions

Extending quickhack and hacking system classes to modify network breach and quickhack behavior.

## Approach

Mods reference `Quickhack` (1070 occurrences), `HackingSystem`, `HackingMinigameState`, `NetworkBreach`, and related classes to modify hacking behavior. This includes custom quickhack effects, modified breach protocol minigames, or extended network breach mechanics. The `@addMethod` pattern is commonly used to add new quickhack actions to device components.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/Hacking/Breach.reds` | References quickhack/hacking system |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/Hacking/Breach.reds` | References quickhack/hacking system |
| Auto Leveler-27010-2-31-01-1769096078 | `r6/scripts/Auto Leveler/AutoLevel.reds` | References quickhack/hacking system |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Services/CAAnimationService.reds` | References quickhack/hacking system |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds` | References quickhack/hacking system |

*24 more mods use this pattern.*

## Related Concepts

- [Vehicle Quickhack Interception](/vehicle/vehicle-quickhack-interception.md) — Wrapping VehicleComponentPS.GetQuickHackActions to intercept and modify vehicle quickhack options.
- [Access Point Modifications](/world/access-point-modifications.md) — Extending AccessPointControllerPS to modify access point hacking behavior.
- [Player Vision Mode](/player/player-vision-mode.md) — Intercepting PlayerVisionModeController to modify scanning and vision modes.
