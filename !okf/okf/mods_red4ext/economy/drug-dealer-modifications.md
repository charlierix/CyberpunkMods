---
type: Mechanic Pattern
title: Drug Dealer Modifications
description: Modifying DrugDealer.* TweakDB records to alter drug dealer vendor behavior.
tags: [economy drug-dealer tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Drug Dealer Modifications

Modifying DrugDealer.* TweakDB records to alter drug dealer vendor behavior.

## Approach

Mods modify `DrugDealer.*` TweakDB records to change what drug dealers sell, their inventory composition, or pricing. This is a specialized vendor modification pattern for the drug dealer NPC type.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drug Dealer 27800 6.5.6 2026-06-26T12-36Z 5em9eoSzt | `r6/tweaks/DrugDealer/DrugDealer.Drug.Base.yaml` | Modifies DrugDealer.* records |

## Related Concepts

- [Vendor Inventory Modification](/economy/vendor-inventory-modification.md) — Modifying Vendors.* TweakDB records to change what items vendors sell and at what prices.
- [TweakDB Character Record Modification](/systems/tweakdb-character-records.md) — Modifying Character.* TweakDB records to alter NPC and character definitions.
