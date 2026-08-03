---
type: Mechanic Pattern
title: Cosmetic Archive Modifications
description: Archive-only mods that modify visual assets (clothing, appearances, textures, environments) without code changes.
tags: [world cosmetic archive visual]
timestamp: 2026-08-03T00:00:00Z
---

# Cosmetic Archive Modifications

Archive-only mods that modify visual assets (clothing, appearances, textures, environments) without code changes.

## Approach

These mods modify game visual assets through archive file replacements without any code. This includes custom clothing, character appearances, texture replacements, environmental decorations, and physics modifications. The archive files replace or add to the game's existing visual asset packages. While these mods don't manipulate game mechanics through code, they complement system logic by providing visual assets that other mods reference.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A New Dawn Beyond Night City 15524 2.3 2026-06-24T00-55Z 5em9eoSld | `archive/` | Cosmetic mod (no code) |
| Ada Wong RE4R Dress Hyst AIO Archive XL-7949-1-1-1682769778 | `archive/` | Cosmetic mod (no code) |
| Apartments Enhanced - H10 addon-19521-2-02a-1764055469 | `archive/` | Cosmetic mod (no code) |
| ApplyFovEverywhere-20478-25-3-27-0-1743032142 | `archive/` | Cosmetic mod (no code) |
| Citizen Breast Physics FOMOD-21520-1-2-2-1764937228 | `curvy/packed/archive/pc/mod/citizen_breast_physics.archive` | Visual asset modification via archive |

*20 more mods use this pattern.*

## Related Concepts

- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
- [Custom Radio Streams](/media/custom-radio-streams.md) — Adding custom radio stations via Channels.* TweakDB records and audio archive files.
