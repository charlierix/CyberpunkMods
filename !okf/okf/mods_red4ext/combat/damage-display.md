---
type: Mechanic Pattern
title: Damage Number Display
description: Customizing how damage numbers are rendered in the HUD via DamageDigitsGameController.
tags: [combat ui damage-display]
timestamp: 2026-08-03T00:00:00Z
---

# Damage Number Display

Customizing how damage numbers are rendered in the HUD via DamageDigitsGameController.

## Approach

Mods extend `DamageDigitsGameController` via `@addMethod` to customize floating damage number rendering. This includes custom fonts, colors, positioning, or adding additional information to damage popups.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| BullseyesKnives 1.0.0 Beta 31418 1 2026-07-11T03-48Z 8ViLVPonV | `r6/scripts/BullseyeRicochet/BullseyeRicochet.reds` | Adds `DamageDigitsGameController.BullseyeCreateSegment` |

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Damage System Overrides](/combat/damage-system-overrides.md) — Replacing or extending DamageSystem methods to alter how damage is calculated and applied.
