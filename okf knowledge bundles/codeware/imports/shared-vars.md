---
type: "Import"
title: "Shared-Vars Types"
description: "Imported game engine types in the shared-vars domain (11 types)."
resource: "codeware/scripts/"
tags: "[imports, shared-vars]"
timestamp: 2026-07-01T18:09:32Z
---

# Overview

Imported game engine types in the shared-vars domain (11 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| SharedVarBool | struct | — | varName |
| SharedVarFloat | struct | — | varName |
| SharedVarInt | struct | — | varName |
| SharedVarName | struct | — | varName |
| SharedVarPosition | struct | — | varName |
| SharedVarTarget | struct | — | varName |
| sharedCommandResult | enum | — | Success, NeedOptions, Fail, Abort |
| sharedMenuCollection | struct | — | items |
| sharedMenuItem | struct | — | id, tooltip, isEnabled, isChecked |
| sharedMenuItemType | enum | — | Action, Checked, Group, Separator |
| sharedResourceCommandOutcome | struct | — | result, message |

# Citations

- `codeware/scripts/Base/Imports/SharedVarBool.reds`
- `codeware/scripts/Base/Imports/SharedVarFloat.reds`
- `codeware/scripts/Base/Imports/SharedVarInt.reds`
- `codeware/scripts/Base/Imports/SharedVarName.reds`
- `codeware/scripts/Base/Imports/SharedVarPosition.reds`
- `codeware/scripts/Base/Imports/SharedVarTarget.reds`
- `codeware/scripts/Base/Imports/sharedCommandResult.reds`
- `codeware/scripts/Base/Imports/sharedMenuCollection.reds`
- `codeware/scripts/Base/Imports/sharedMenuItem.reds`
- `codeware/scripts/Base/Imports/sharedMenuItemType.reds`
- ... and 1 more source files
