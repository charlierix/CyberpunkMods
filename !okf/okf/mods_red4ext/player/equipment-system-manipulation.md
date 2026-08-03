---
type: Mechanic Pattern
title: Equipment System Manipulation
description: Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
tags: [player equipment inventory]
timestamp: 2026-08-03T00:00:00Z
---

# Equipment System Manipulation

Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.

## Approach

Mods wrap `EquipmentSystemPlayerData` (28 wraps, 14 @addMethod) to modify equipment behavior. This includes custom equipment slots, modified equip/unequip logic, or integration with other systems. Some mods also modify `AttachmentSlots.*` TweakDB records for equipment slot configuration.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | References EquipmentSystemPlayerData |
| Auto Leveler-27010-2-31-01-1769096078 | `r6/scripts/Auto Leveler/AutoLevel.reds` | References EquipmentSystemPlayerData |
| Daemon Netrunning (Revamp)-23894-1-2-1-1759846597 | `r6/scripts/Daemon Netrunning (Revamp)/DNR_Core.reds` | References EquipmentSystemPlayerData |
| Dynamic Wardrobe-27791-2-1-1773744332 | `r6/scripts/Dynamic Wardrobe/Events/SceneHandler.reds` | Wraps `EquipmentSystemPlayerData.UnequipWardrobeSet` |
| Equipment-EX-6945-1-2-9-1773737132 | `r6/scripts/EquipmentEx/EquipmentEx.Global.reds` | Wraps `EquipmentSystemPlayerData.OnAttach` |

*13 more mods use this pattern.*

## Related Concepts

- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
- [Inventory UI Overrides](/ui/inventory-ui-overrides.md) — Wrapping inventory-related game controllers to modify inventory and backpack display.
- [Attachment Slot Tweaks](/player/attachment-slot-tweaks.md) — Modifying AttachmentSlots.* TweakDB records to alter equipment attachment slots.
