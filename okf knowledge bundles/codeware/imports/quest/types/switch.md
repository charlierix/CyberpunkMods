---
type: "Import"
title: "Quest Types/Switch"
description: "Imported quest types/switch types (3 types)."
resource: "codeware/scripts/"
tags: "[imports, switch]"
timestamp: 2026-07-01T18:09:24Z
---

# Overview

Imported quest types/switch types (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questSwitchNameplate_NodeType | class | questIUIManagerNodeType | puppetRef, isPlayer, enable, alternativeName |
| questSwitchToScenario_NodeType | class | questIUIManagerNodeType | startScenarioName, endScenarioName, userData, forceOpenDuringFadeout |
| questSwitchWeaponModes | enum | — | PrimaryWeapon, SecondaryWeapon |

# Citations

- `codeware/scripts/Base/Imports/questSwitchNameplate_NodeType.reds`
- `codeware/scripts/Base/Imports/questSwitchToScenario_NodeType.reds`
- `codeware/scripts/Base/Imports/questSwitchWeaponModes.reds`
