---
type: Mechanic Pattern
title: First Equip System
description: Wrapping FirstEquipSystem and EquipCycleDecisions to modify weapon equipping behavior.
tags: [player weapons equip]
timestamp: 2026-08-03T00:00:00Z
---

# First Equip System

Wrapping FirstEquipSystem and EquipCycleDecisions to modify weapon equipping behavior.

## Approach

Mods wrap `FirstEquipSystem` and `EquipCycleDecisions` to modify how weapons are equipped for the first time. This includes custom first-equip behavior, modified equip cycles, or conditional equip rules. The `EquipCycleDecisions` class controls the state machine for weapon equip decisions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | References FirstEquipSystem/EquipCycleDecisions |
| Weapon Handling Control-11474-2-2-2-1762730218 | `r6/scripts/WeaponHandlingControl/WeaponHandlingControl.reds` | References FirstEquipSystem/EquipCycleDecisions |
| cyberpunk-vr-port 30093 0.1.1 2026-08-03T09-27Z ozVyzbgII | `r6/scripts/CyberpunkVRPort_NoAnims/vrport_no_anims.reds` | Wraps `FirstEquipSystem.HasPlayedFirstEquip` |

## Related Concepts

- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
- [Movement State Events](/player/movement-state-events.md) — Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
