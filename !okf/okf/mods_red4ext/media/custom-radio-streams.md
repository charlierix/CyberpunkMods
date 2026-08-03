---
type: Mechanic Pattern
title: Custom Radio Streams
description: Adding custom radio stations via Channels.* TweakDB records and audio archive files.
tags: [media radio tweakdb audio]
timestamp: 2026-08-03T00:00:00Z
---

# Custom Radio Streams

Adding custom radio stations via Channels.* TweakDB records and audio archive files.

## Approach

Mods add custom radio stations by modifying `Channels.*` TweakDB records and including audio archive files. This is primarily a data-driven approach — the radio station metadata is defined in TweakDB, and the audio streams are packaged as archive files. Many radio mods are archive-only with no code.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Artistic-13066-1-4-5-1774982712 | `r6/tweaks/Artistic/Artistic.yaml` | Adds/modifies radio Channels.* records |
| 12.26 limbus radio-18791-1-8-7-1766193756 | `archive/` | Radio stream mod (archive-only or no-code) |
| 201.5 HANABIE.-20921-1-0-1744465889 | `archive/` | Radio stream mod (archive-only or no-code) |
| 3 LOFI Radio Stream-19122-1-1-1737059666 | `3 LOFI Radio Stream/archive/pc/mod/3 LOFI Radio Stream.archive` | Custom radio stream via archive files |
| 323.5 KTRK-20791-1-0-1743921184 | `archive/` | Radio stream mod (archive-only or no-code) |

*8 more mods use this pattern.*

## Related Concepts

- [Radio Station Manipulation](/media/radio-station-manipulation.md) — Wrapping radio controller classes to modify in-vehicle radio behavior.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
