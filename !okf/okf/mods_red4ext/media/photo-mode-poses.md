---
type: Mechanic Pattern
title: Photo Mode Pose Tweaks
description: Modifying PhotoModePoses.* TweakDB records to add or alter photo mode poses.
tags: [media photo-mode tweakdb poses]
timestamp: 2026-08-03T00:00:00Z
---

# Photo Mode Pose Tweaks

Modifying PhotoModePoses.* TweakDB records to add or alter photo mode poses.

## Approach

Mods modify `PhotoModePoses.*` TweakDB records to add custom poses to photo mode or alter existing pose definitions. This is a static data approach — poses are defined as TweakDB records loaded at game start.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Emmjay's FF NSFW Threesome Pose Pack - PM 2.3-21744-2-0-1753681489 | `r6/tweaks/emmjay_threesome_nsfw_poses/emmjay_threesome_nsfw_poses.yaml` | Modifies PhotoModePoses.* records |
| PMU - Sitting Set - Masc-8361-2-31-1759810388 | `r6/tweaks/zwei/ZWEI_PMU_Sit_MascV.yaml` | Modifies PhotoModePoses.* records |

## Related Concepts

- [Photo Mode Overrides](/media/photo-mode-overrides.md) — Intercepting photo mode activation and rendering to customize photo mode behavior.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
