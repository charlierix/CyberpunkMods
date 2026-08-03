---
type: Mechanic Pattern
title: TweakDB Character Record Modification
description: Modifying Character.* TweakDB records to alter NPC and character definitions.
tags: [systems tweakdb characters npc]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Character Record Modification

Modifying Character.* TweakDB records to alter NPC and character definitions.

## Approach

Mods modify `Character.*` TweakDB records to change NPC stats, appearances, equipment, or behavior profiles. This is used for custom NPCs, modified enemy difficulty, or altered character appearances. Changes are static and applied at load time.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Artistic-13066-1-4-5-1774982712 | `r6/tweaks/Artistic/Artistic.yaml` | Modifies Character.* TweakDB records |
| DropPointsReimagined-29563-1-0-0-1778351569 | `r6/tweaks/DropPointsReimagined/Package/Price/PerWeightUnit.yaml` | Modifies Character.* TweakDB records |
| Fresh Start-18223-1-5-2-1778280888 | `r6/tweaks/FreshStart/FreshStart.yaml` | Modifies Character.* TweakDB records |
| Friendly Cerberus-12283-1-0-1705082382 | `r6/tweaks/friendly_cerberus_robot/friendly_cerberus_robot.yaml` | Modifies Character.* TweakDB records |
| Graven's Attribute Expansion-10250-1-01-1698033259 | `r6/tweaks/HpPerLevel.yaml` | Modifies Character.* TweakDB records |

*29 more mods use this pattern.*

## Related Concepts

- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
- [Drug Dealer Modifications](/economy/drug-dealer-modifications.md) — Modifying DrugDealer.* TweakDB records to alter drug dealer vendor behavior.
