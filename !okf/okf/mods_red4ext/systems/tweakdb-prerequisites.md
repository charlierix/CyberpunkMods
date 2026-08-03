---
type: Mechanic Pattern
title: TweakDB Prerequisite Modifications
description: Modifying Prereqs.* TweakDB records to alter game prerequisite conditions.
tags: [systems tweakdb prerequisites conditions]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Prerequisite Modifications

Modifying Prereqs.* TweakDB records to alter game prerequisite conditions.

## Approach

Mods modify `Prereqs.*` TweakDB records to change prerequisite conditions for perks, items, or game states. This enables custom unlock conditions, modified requirement checks, or conditional game behavior based on TweakDB-defined prerequisites.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ActualCantoBlackwall 25849 1.0.0.1 2026-07-27T14-38Z VquAqYzfW | `r6/tweaks/ActualCantoBlackwall/ActualCantoBlackwall.yaml` | Modifies Prereqs.* records |
| All Guns Are Cool-10969-1-1-1739533762 | `r6/tweaks/AllGunsAreCool/AllGunsAreCool.yaml` | Modifies Prereqs.* records |
| Black Storm-16080-1-1-1723878860 | `r6/tweaks/Black_Storm/Black_Storm.yaml` | Modifies Prereqs.* records |
| Cyphire Sniper Cyberware-14345-1-0-1713879194 | `r6/tweaks/CyphireEyesCyberware/CyphireSniperEyesCyberwareTEMPLATES.yaml` | Modifies Prereqs.* records |
| Heat Converter-11820-1-2-1-1754289864 | `r6/tweaks/SeijaxCyberware/HeatConverter.yaml` | Modifies Prereqs.* records |

*15 more mods use this pattern.*

## Related Concepts

- [TweakDB Perk Modifications](/systems/tweakdb-perks.md) — Modifying NewPerks.* TweakDB records to add or alter perk definitions.
- [TweakDB Effector Modifications](/systems/tweakdb-effectors.md) — Modifying Effectors.* TweakDB records to alter game effectors that apply stat modifications.
