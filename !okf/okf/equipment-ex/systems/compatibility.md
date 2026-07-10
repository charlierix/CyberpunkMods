---
type: System
title: Compatibility Manager
description: Abstract class managing cross-mod compatibility checks and version detection.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/CompatibilityManager.reds"
tags: ['equipment-ex', 'redscript', 'systems']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Abstract class managing cross-mod compatibility checks and version detection.

This concept covers 9 member declarations from 1 source file(s): CompatibilityManager.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `CompatibilityManager` | 8 methods |
| Method |  `RequiredCodeware()` -> `String` | — |
| Method |  `RequiredArchiveXL()` -> `String` | — |
| Method |  `RequiredTweakXL()` -> `String` | — |
| Method |  `CheckRequirements()` -> `Bool` | — |
| Method |  `CheckConflicts(game: GameInstance, out conflicts: array<String>)` -> `Bool` | — |
| Method |  `CheckConflicts(game: GameInstance)` -> `Bool` | — |
| Method |  `IsUserNotified()` -> `Bool` | — |
| Method |  `MarkAsNotified()` | — |

# Notable Methods

## CompatibilityManager

| Method | Parameters | Returns |
|--------|------------|---------|
| `RequiredCodeware` | `` | `String` |
| `RequiredArchiveXL` | `` | `String` |
| `RequiredTweakXL` | `` | `String` |
| `CheckRequirements` | `` | `Bool` |
| `CheckConflicts` | `game: GameInstance, out conflicts: array<String>` | `Bool` |
| `CheckConflicts` | `game: GameInstance` | `Bool` |
| `IsUserNotified` | `` | `Bool` |
| `MarkAsNotified` | `` | `` |

# Citations

- [CompatibilityManager.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/CompatibilityManager.reds)
