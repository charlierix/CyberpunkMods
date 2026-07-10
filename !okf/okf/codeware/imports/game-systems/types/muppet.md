---
type: "Import"
title: "Game-Systems Types/Muppet"
description: "Imported game-systems types/muppet types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, muppet]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game-systems types/muppet types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameMuppetAbilities | struct | — | canLook, canCrouch, canSwitchWeapon, canShoot |
| gameMuppetAbility | struct | — | value |
| gameMuppetComparisonReportItem | struct | — | type, serverValue |
| gameMuppetComparisonReportItemType | enum | — | Different, WithinTolerance, Equal |
| gameMuppetDebugCommand | enum | — | None, Kill, KillAll |
| gameMuppetInputActionType | enum | — | Unknown, Impulse, Press |
| gameMuppetInventorySlotInfo | struct | — | itemCategory, quantity |
| gameMuppetMoveStyle | enum | — | Invalid, Walk, Sprint, Crouch, WalkAim |

# Citations

- `codeware/scripts/Base/Imports/gameMuppetAbilities.reds`
- `codeware/scripts/Base/Imports/gameMuppetAbility.reds`
- `codeware/scripts/Base/Imports/gameMuppetComparisonReportItem.reds`
- `codeware/scripts/Base/Imports/gameMuppetComparisonReportItemType.reds`
- `codeware/scripts/Base/Imports/gameMuppetDebugCommand.reds`
- `codeware/scripts/Base/Imports/gameMuppetInputActionType.reds`
- `codeware/scripts/Base/Imports/gameMuppetInventorySlotInfo.reds`
- `codeware/scripts/Base/Imports/gameMuppetMoveStyle.reds`
