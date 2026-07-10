---
type: "Import"
title: "Game-Ui Types"
description: "Imported game-ui types types (35 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game-ui types types (35 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameuiBinkVideoStatus | enum | — | Idle, NotStarted, Initializing, Playing, Finished |
| gameuiCensorshipInfo | struct | — | censorFlag, censorFlagAction |
| gameuiCharacterCustomizationAction | struct | — | type, applyToUISlot |
| gameuiCharacterCustomizationActionType | enum | — | Activate, Deactivate, EquipItem, UnequipItem, Refresh |
| gameuiCharacterCustomizationOptionImpl | class | CharacterCustomizationOption | — |
| gameuiCharacterCustomizationOptionVersionPrereq | struct | — | optionName |
| gameuiCharacterCustomizationOptionVersionUpdateInfo | struct | — | curOptionNames, optionPrereqs, newDefinitionName |
| gameuiCharacterCustomizationPreset | class | CResource | isMale, bodyGroups, headGroups, armsGroups, perspectiveInfo |
| gameuiCharacterCustomizationUiPreset | class | CResource | isMaleVO, values |
| gameuiCharacterCustomizationUiPresetInfo | struct | — | name |
| gameuiCharacterCustomizationUiPresetValue | struct | — | optionName, value |
| gameuiCharacterCustomizationVersionUpdateInfo | struct | — | newVersion |
| gameuiCharacterCustomization_BrokenNoseStage | enum | — | CCBN_Disabled, CCBN_Stage1, CCBN_Stage2, CCBN_FinalScene |
| gameuiCharacterRandomizationInfo | struct | — | minRating |
| gameuiChoiceIndicatorType | enum | — | Default, Speech, Call, Arrow, Hand |
| gameuiChoiceListVisualizerType | enum | — | Interaction, Dialog |
| gameuiCustomizationGroup | struct | — | name, morphs |
| gameuiCyberspaceElementType | enum | — | CyberspaceNPC, CyberspaceFakeObject |
| gameuiCyberspaceUIObject | class | GameObject | slotName, mappinType, caption |
| gameuiDelayedNextVOEvt | class | Event | — |
| gameuiDialogListChoiceVisualizer | class | gameuiIChoiceVisualizer | — |
| gameuiEIconOrientation | enum | — | Upright, Entity |
| gameuiEntityPreviewGameObject | class | GameObject | cameraSettings |
| gameuiGenericNotificationType | enum | — | Generic, QuestUpdate, Vendor, ZoneAlert, VehicleAlert |
| gameuiHudScalingSensitiveWidget | struct | — | widget, adjustTranslation, targetMarginAtDoubleScale |
| gameuiIChoiceVisualizer | class | ISerializable | — |
| gameuiInkChoiceVisualizer | class | gameuiIChoiceVisualizer | isDynamic, type |
| gameuiLootVisualizer | class | gameuiIChoiceVisualizer | — |
| gameuiOptionsGroup | struct | — | name |
| gameuiPerspectiveInfo | struct | — | name, tpp |
| gameuiPuppetPreviewCameraSetup | struct | — | slotName, interpolationTime |
| gameuiRandomNewsFeedAnimator | class | inkLogicController | textWidget, animDuration |
| gameuiResolutionSensitiveWidget | struct | — | widget |
| gameuiRoadEditorSegment | struct | — | length, hasCheckpoint, decorationSettings |
| gameuiVOWithDelay | struct | — | playDelay |

# Citations

- `codeware/scripts/Base/Imports/gameuiBinkVideoStatus.reds`
- `codeware/scripts/Base/Imports/gameuiCensorshipInfo.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationAction.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationActionType.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationOptionImpl.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationOptionVersionPrereq.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationOptionVersionUpdateInfo.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationPreset.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationUiPreset.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationUiPresetInfo.reds`
- ... and 25 more source files
