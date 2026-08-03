---
type: Mechanic Pattern
title: TweakDB Perk Modifications
description: Modifying NewPerks.* TweakDB records to add or alter perk definitions.
tags: [systems tweakdb perks]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Perk Modifications

Modifying NewPerks.* TweakDB records to add or alter perk definitions.

## Approach

Mods modify `NewPerks.*` TweakDB records to add custom perks, modify perk effects, or change perk prerequisites. This is the static data approach to perk modification — changes are loaded at game start and persist throughout the session.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| All Guns Are Cool-10969-1-1-1739533762 | `r6/tweaks/AllGunsAreCool/AllGunsAreCool.yaml` | Modifies NewPerks.* TweakDB records |
| Better Borrowed Time - KILL 100-26218-0-3-1766572021 | `r6/tweaks/BetterBorrowedTime/BetterBorrowedTime.yaml` | Modifies NewPerks.* TweakDB records |
| Hardcore Netrunning-17136-1-2-1772992233 | `Hardcore Netrunning/r6/tweaks/HardcoreNetrunning.yaml` | Modifies NewPerks.* TweakDB records |
| Immersive Throwables-25074-1-0-0-1760684438 | `r6/tweaks/ImmersiveThrowables/NewPerks.Cool_Right_Milestone_2.yaml` | Modifies NewPerks.* TweakDB records |
| ImmersiveGrenades-25334-3-3-0-1779622581 | `r6/tweaks/ImmersiveGrenades/Overrides/Perk/NewPerks.Tech_Inbetween_Left_3.yaml` | Modifies NewPerks.* TweakDB records |

*10 more mods use this pattern.*

## Related Concepts

- [Player Development Overrides](/player/player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
- [Monowire Perk Tweaks](/player/monowire-perk-tweaks.md) — Modifying MonowirePerkTree.* TweakDB records to alter monowire cyberware perks.
- [Attunement Tweaks](/player/attunement-tweaks.md) — Modifying Attunements.* TweakDB records to alter cyberware attunement mechanics.
