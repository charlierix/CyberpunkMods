---
type: "Import"
title: "Quest States"
description: "Imported quest states types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:28Z
---

# Overview

Imported quest states types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questChangeVoicesetState_NodeType | class | questIVoicesetManager_NodeType | params |
| questChangeVoicesetState_NodeTypeParams | struct | — | puppetRef, enableVoicesetLines, inputsToBlock |
| questCharacterState_ConditionType | class | questICharacterConditionType | subType |
| questCharacterState_PlayerSubType | class | questICharacterConditionSubType | locomotionComparisonType, locomotionState, upperBodyComparisonType, upperBodyState, weaponComparisonType |
| questCharacterState_PuppetSubType | class | questICharacterConditionSubType | puppetRef, upperBodyComparisonType, upperBodyState, highLevelComparisonType, highLevelState |
| questDrillingState | enum | — | Undefined, Started, Finished |
| questDrillingState_ConditionType | class | questIObjectConditionType | objectRef, state |
| questEUIMenuState | enum | — | Open, Closed |
| questLootTokenState | enum | — | Enabled, Disabled, Sealed, Unsealed |
| questMappinState_ConditionType | class | questIJournalConditionType | mappinPath, active |
| questMenuState_ConditionType | class | questIUIConditionType | state |
| questMultiplayerHeistState | enum | — | Invalid, Failure, Victory |
| questScanningState | enum | — | NotScanned, Scanned |
| questSetConveyorState_NodeType | class | questIInteractiveObjectManagerNodeType | objectRef, enable |
| questSetDestructionStateAction | enum | — | Undefined, Trigger |
| questSetFocusClueState_NodeType | class | questIVisionModeNodeType | objectRef, clueId, clueState |
| questSetInteractionState_NodeType | class | questIInteractiveObjectManagerNodeType | objectRef, enable |
| questSetMultiplayerHeistState_NodeType | class | questIMultiplayerHeistNodeType | state |
| questSetScanningState_NodeType | class | questIVisionModeNodeType | objectRef, state |
| questSetTriggerState_NodeType | class | questITriggerManagerNodeType | params |
| questSetTriggerState_NodeTypeParams | struct | — | objectRef |
| questUIContextState_ConditionType | class | questIUIConditionType | state, active |
| questVariantState | struct | — | — |

# Citations

- `codeware/scripts/Base/Imports/questChangeVoicesetState_NodeType.reds`
- `codeware/scripts/Base/Imports/questChangeVoicesetState_NodeTypeParams.reds`
- `codeware/scripts/Base/Imports/questCharacterState_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterState_PlayerSubType.reds`
- `codeware/scripts/Base/Imports/questCharacterState_PuppetSubType.reds`
- `codeware/scripts/Base/Imports/questDrillingState.reds`
- `codeware/scripts/Base/Imports/questDrillingState_ConditionType.reds`
- `codeware/scripts/Base/Imports/questEUIMenuState.reds`
- `codeware/scripts/Base/Imports/questLootTokenState.reds`
- `codeware/scripts/Base/Imports/questMappinState_ConditionType.reds`
- ... and 13 more source files
