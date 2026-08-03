---
type: Mechanic Pattern
title: Attachment Slot Tweaks
description: Modifying AttachmentSlots.* TweakDB records to alter equipment attachment slots.
tags: [player equipment tweakdb attachments]
timestamp: 2026-08-03T00:00:00Z
---

# Attachment Slot Tweaks

Modifying AttachmentSlots.* TweakDB records to alter equipment attachment slots.

## Approach

Mods modify `AttachmentSlots.*` TweakDB records to add or modify weapon attachment slots. This enables custom weapon attachments, modified slot configurations, or new attachment types.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Kolac Expanded-24491-1-3-1771507690 | `r6/tweaks/KolacExpanded/KolacVariants.yaml` | Modifies AttachmentSlots.* records |
| New Iconic Conventional Weapons-20694-1-0-1743523219 | `r6/tweaks/NewIconics/NewIconics.yaml` | Modifies AttachmentSlots.* records |
| Slots Should Be Clean 2.0-27788-1-0-1-1772116675 | `r6/tweaks/c3_slots_should_be_clean2/c3_slots_should_be_clean2.yaml` | Modifies AttachmentSlots.* records |
| Tremere - vampiric tech SMG-19727-1-0-0-1741537750 | `r6/tweaks/Tremere/Items.Xmod2_Tech_SMG_Blueprint.yaml` | Modifies AttachmentSlots.* records |
| cyberpunk-vr-port 30093 0.1.1 2026-08-03T09-27Z ozVyzbgII | `r6/tweaks/vrcigarette/AttachmentSlots.WeaponRight.yaml` | Modifies AttachmentSlots.* records |

## Related Concepts

- [Equipment System Manipulation](/player/equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
