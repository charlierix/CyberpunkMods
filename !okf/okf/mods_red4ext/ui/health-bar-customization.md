---
type: Mechanic Pattern
title: Health Bar Customization
description: Wrapping health and stamina bar widget controllers to modify health/stamina display.
tags: [ui health-bar stamina hud]
timestamp: 2026-08-03T00:00:00Z
---

# Health Bar Customization

Wrapping health and stamina bar widget controllers to modify health/stamina display.

## Approach

Mods wrap `healthbarWidgetGameController` (16 wraps, 15 @addMethod) and `StaminabarWidgetGameController` (10 wraps) to modify health and stamina bar display. This includes custom health bar visuals, modified stamina display, or conditional bar visibility.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/shieldPointsUI.reds` | Wraps `healthbarWidgetGameController.UpdateCurrentHealthText` |
| Eye-Tracked HUD 30603 1.0.0 2026-06-20T15-56Z AgoGgivIA | `r6/scripts/Eye-Tracked HUD/EyeTrackedHUDController.reds` | Wraps `StaminabarWidgetGameController.EvaluateStaminaBarVisibility` |
| HUD Painter-14935-1-3-0-1768645929 | `r6/scripts/HUDPainter/HudPainterPreviewControllerStubs.reds` | Wraps `healthbarWidgetGameController.OnInitialize` |
| HUDitor-3315-1-1-0-1770366067 | `r6/scripts/HUDitor/preview.reds` | References health/stamina bar widgets |
| HealthPercentCombat-24328-1-3-1760635378 | `r6/scripts/HealthPercentCombat/HealthPercentCombat-ArmorUpPatch.reds` | Wraps `healthbarWidgetGameController.UpdateCurrentHealthText` |

*8 more mods use this pattern.*

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
