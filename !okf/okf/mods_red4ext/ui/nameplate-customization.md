---
type: Mechanic Pattern
title: Nameplate Customization
description: Wrapping NameplateVisualsLogicController to modify NPC nameplate display.
tags: [ui nameplate npc hud]
timestamp: 2026-08-03T00:00:00Z
---

# Nameplate Customization

Wrapping NameplateVisualsLogicController to modify NPC nameplate display.

## Approach

Mods wrap `NameplateVisualsLogicController` (14 wraps) to modify NPC nameplate rendering. This includes custom nameplate visibility, modified health bar display on nameplates, or additional nameplate information.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| HealthPercentage 31422 1 2026-07-11T06-21Z ozVyzbgEE | `r6/scripts/EnemyHealthPercent/EnemyHealthPercent.reds` | Wraps `NameplateVisualsLogicController.OnInitialize` |
| Immersive Cyberware-21916-1-0-2-1755792059 | `r6/scripts/ImmersiveCyberware/lenses/HealthScanner.reds` | Wraps `NameplateVisualsLogicController.UpdateHealthbarVisibility` |
| Limited HUD 2592 2.22.4 2026-07-26T18-22Z LACBAIyo3 | `r6/scripts/LHUD/modules/worldMarkersEnemy.reds` | Wraps `NameplateVisualsLogicController.SetVisualData` |
| MEArmorSystem 30548 1.0.4 2026-06-24T22-55Z 6ZNKZci2Q | `r6/scripts/EnemyArmorOverhaul/enemyAddrenalineBar.reds` | Wraps `NameplateVisualsLogicController.UpdateHealthbarVisibility` |

## Related Concepts

- [Health Bar Customization](/ui/health-bar-customization.md) — Wrapping health and stamina bar widget controllers to modify health/stamina display.
- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
