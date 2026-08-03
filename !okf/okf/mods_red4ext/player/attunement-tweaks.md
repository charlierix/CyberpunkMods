---
type: Mechanic Pattern
title: Attunement Tweaks
description: Modifying Attunements.* TweakDB records to alter cyberware attunement mechanics.
tags: [player cyberware attunement tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Attunement Tweaks

Modifying Attunements.* TweakDB records to alter cyberware attunement mechanics.

## Approach

Mods modify `Attunements.*` TweakDB records to change how cyberware attunements work. This includes modified attunement bonuses, custom attunement types, or altered attunement requirements.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyphire Sniper Cyberware-14345-1-0-1713879194 | `r6/tweaks/CyphireEyesCyberware/CyphireSniperEyesCyberwareTEMPLATES.yaml` | Modifies Attunements.* records |
| Perkware 2.0 29611 2.1.3 2026-07-15T23-18Z UQrhQStni | `r6/tweaks/Perkware/Attunement/Localization.yaml` | Modifies Attunements.* records |
| Rootkit-29469-2-1778504485 | `r6/tweaks/Rootkit/Items.RootKit.yaml` | Modifies Attunements.* records |
| Time Dilation Overhaul 4931 2.32 2026-07-28T22-51Z q7jg7fhKQ | `r6/tweaks/TDO/apogee.yaml` | Modifies Attunements.* records |

## Related Concepts

- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
- [TweakDB Perk Modifications](/systems/tweakdb-perks.md) — Modifying NewPerks.* TweakDB records to add or alter perk definitions.
