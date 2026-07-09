---
type: Reference
title: "Iscriptable / Aicommand"
description: "18 types in IScriptable / AICommand. Includes: AICommand, AIBackgroundCombatCommand, AIBaseMountCommand."
tags: [iscriptable, references, aicommand]
timestamp: 2026-07-01T01:17:09.596774
---

# Iscriptable / Aicommand

## Overview

This concept covers 18 types (18 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **AICommand** subgroup under **IScriptable**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| AICommand | IScriptable | 2 | 3 | native | [34254.json](/api/cyberpunk-api/34254.json) |
| AIBackgroundCombatCommand | AICommand, IScriptable | 1 | 0 | - | [131731.json](/api/cyberpunk-api/131731.json) |
| AIBaseMountCommand | AICommand, IScriptable | 1 | 0 | abstract, native | [132555.json](/api/cyberpunk-api/132555.json) |
| AICombatRelatedCommand | AICommand, IScriptable | 1 | 0 | native | [34261.json](/api/cyberpunk-api/34261.json) |
| AIFollowerCommand | AICommand, IScriptable | 1 | 1 | - | [70566.json](/api/cyberpunk-api/70566.json) |
| AIMoveCommand | AICommand, IScriptable | 3 | 0 | native | [74345.json](/api/cyberpunk-api/74345.json) |
| AIVehicleCommand | AICommand, IScriptable | 2 | 0 | abstract, native | [80942.json](/api/cyberpunk-api/80942.json) |
| AIAssignRestrictMovementAreaCommand | AICommand, IScriptable | 1 | 0 | native | [94155.json](/api/cyberpunk-api/94155.json) |
| AITeleportCommand | AICommand, IScriptable | 3 | 0 | native | [94219.json](/api/cyberpunk-api/94219.json) |
| AIBaseUseWorkspotCommand | AICommand, IScriptable | 4 | 0 | abstract, native | [94223.json](/api/cyberpunk-api/94223.json) |
| AIEquipCommand | AICommand, IScriptable | 4 | 0 | native | [94232.json](/api/cyberpunk-api/94232.json) |
| AIUnequipCommand | AICommand, IScriptable | 2 | 0 | native | [94237.json](/api/cyberpunk-api/94237.json) |
| AIAssignRoleCommand | AICommand, IScriptable | 1 | 0 | - | [94240.json](/api/cyberpunk-api/94240.json) |
| AISwitchToPrimaryWeaponCommand | AICommand, IScriptable | 1 | 0 | native | [94316.json](/api/cyberpunk-api/94316.json) |
| AISwitchToSecondaryWeaponCommand | AICommand, IScriptable | 1 | 0 | native | [94318.json](/api/cyberpunk-api/94318.json) |
| AIStopCoverCommand | AICommand, IScriptable | 0 | 0 | - | [94337.json](/api/cyberpunk-api/94337.json) |
| AIJoinTargetsSquad | AICommand, IScriptable | 1 | 0 | - | [94342.json](/api/cyberpunk-api/94342.json) |
| AIScanTargetCommand | AICommand, IScriptable | 1 | 0 | - | [94364.json](/api/cyberpunk-api/94364.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 18 source files
