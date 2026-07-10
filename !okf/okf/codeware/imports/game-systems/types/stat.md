---
type: "Import"
title: "Game-Systems Types/Stat"
description: "Imported game-systems types/stat types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, stat]"
timestamp: 2026-07-01T18:09:10Z
---

# Overview

Imported game-systems types/stat types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameStatIDType | enum | — | EntityID, ItemID, Invalid |
| gameStatModifierBase | unknown | — | — |
| gameStatModifierGroup | struct | — | statModifierArray, statModifiersLimitModifier, statModifierGroupRecordID, drawBasedOnStatType, optimiseCombinedModifiers |
| gameStatModifierHandle | struct | — | — |
| gameStatModifierSave | unknown | — | — |
| gameStatPoolModifierProperty | enum | — | RangeBegin, RangeEnd, StartDelay, ValuePerSec, Enabled |
| gamedataStatType_1300DEPRECATED | enum | — | Acceleration, Accuracy, Adrenaline, AimFOV, AimInTime |

# Citations

- `codeware/scripts/Base/Imports/gameStatIDType.reds`
- `codeware/scripts/Base/Imports/gameStatModifierBase.reds`
- `codeware/scripts/Base/Imports/gameStatModifierGroup.reds`
- `codeware/scripts/Base/Imports/gameStatModifierHandle.reds`
- `codeware/scripts/Base/Imports/gameStatModifierSave.reds`
- `codeware/scripts/Base/Imports/gameStatPoolModifierProperty.reds`
- `codeware/scripts/Base/Imports/gamedataStatType_1300DEPRECATED.reds`
