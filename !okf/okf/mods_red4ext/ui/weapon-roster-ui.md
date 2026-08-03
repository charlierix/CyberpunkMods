---
type: Mechanic Pattern
title: Weapon Roster UI
description: Wrapping WeaponRosterGameController to modify weapon selection display.
tags: [ui weapons roster hud]
timestamp: 2026-08-03T00:00:00Z
---

# Weapon Roster UI

Wrapping WeaponRosterGameController to modify weapon selection display.

## Approach

Mods wrap `WeaponRosterGameController` (14 wraps, 12 @addMethod) to modify the weapon selection UI. This includes custom weapon display, modified sorting, or additional weapon roster features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Environmental Weapon Handling 29803 1.2.1 2026-06-16T11-31Z hF7PF40bO | `r6/scripts/EnvironmentalWeaponHandling/EnvironmentalWeaponHUD.reds` | Wraps `WeaponRosterGameController.OnInitialize` |
| Eye-Tracked HUD 30603 1.0.0 2026-06-20T15-56Z AgoGgivIA | `r6/scripts/Eye-Tracked HUD/EyeTrackedHUDController.reds` | Wraps `WeaponRosterGameController.OnInitialize` |
| HUD Painter-14935-1-3-0-1768645929 | `r6/scripts/HUDPainter/HudPainterPreviewControllerStubs.reds` | Wraps `WeaponRosterGameController.OnInitialize` |
| Immersive Cyberware-21916-1-0-2-1755792059 | `r6/scripts/ImmersiveCyberware/handCyberware.reds` | Wraps `WeaponRosterGameController.OnUpdate` |
| Limited HUD 2592 2.22.4 2026-07-26T18-22Z LACBAIyo3 | `r6/scripts/LHUD/modules/weaponRoster.reds` | Adds `WeaponRosterGameController.OnLHUDEvent` |

*1 more mods use this pattern.*

## Related Concepts

- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
- [First Equip System](/player/first-equip-system.md) — Wrapping FirstEquipSystem and EquipCycleDecisions to modify weapon equipping behavior.
