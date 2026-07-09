---
type: "Import"
title: "Event-Handlers Types"
description: "Imported game engine types in the event-handlers domain (57 types)."
resource: "codeware/scripts/"
tags: "[imports, event-handlers]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game engine types in the event-handlers domain (57 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AbortSummoningActionEvent | class | ActionEvent | — |
| ChangeAspectRatioEvent | class | Event | — |
| ChangeCameraControlHintVisibilityEvent | class | Event | movementVisible, rotationVisible |
| ChangeRadioReceiverStation | unknown | — | — |
| ChangeRadioTierEvent | unknown | — | — |
| DoneActionEvent | unknown | — | — |
| EnableClientSideInteractionEvent | unknown | — | — |
| EnableStickerEditorEvent | class | Event | — |
| FearInPlaceEvent | class | AIEvent | — |
| ForceAttributeValueEvent | class | Event | — |
| ForceStickerTransformEvent | class | Event | — |
| HideCustomTooltipEvent | class | Event | — |
| JoinTrafficEvent | class | AIEvent | — |
| NotifyFootstepMaterialContextChangedEvent | class | Event | footwareType, surfaceFlavourName |
| OnAxis | class | inkPointerEvent | — |
| OnDoubleClick | class | inkPointerEvent | — |
| OnEnter | class | inkPointerEvent | — |
| OnFocusLost | class | inkFocusEvent | — |
| OnFocusReceived | class | inkFocusEvent | — |
| OnHold | class | inkPointerEvent | — |
| OnHoverOut | class | inkPointerEvent | — |
| OnHoverOver | class | inkPointerEvent | — |
| OnLeave | class | inkPointerEvent | — |
| OnPress | class | inkPointerEvent | — |
| OnRelative | class | inkPointerEvent | — |
| OnRelease | class | inkPointerEvent | — |
| OnRepeat | class | inkPointerEvent | — |
| OnVisibilityBlockerAffectedTBHEvent | class | Event | newTBHModifier |
| RecycleEventAdvanced | unknown | — | — |
| RequestNewHudEvent | class | Event | entriesResource |
| ResetStickersEvent | class | Event | — |
| RunAwayEvent | class | AIEvent | — |
| SetAttributeEnabledEvent | class | Event | — |
| SetAudioOverrideEvent | class | Event | enable |
| SetBackgroundEvent | class | Event | — |
| SetBlackBarsEvent | class | Event | — |
| SetCasinoChipsAmountEvent | class | Event | value |
| SetCategoryEnabledEvent | class | Event | — |
| SetFrameImageEvent | class | Event | — |
| SetNpcImageEvent | class | Event | — |
| SetScannableThroughWallsEvent | unknown | — | — |
| SetSelectedNpcEvent | class | Event | — |
| SetSelectedStickerEvent | class | Event | — |
| SetStickerImageEvent | class | Event | — |
| SetupColorBarForAttributeEvent | class | Event | attribute, startValue, minValue, maxValue, step |
| SetupGridSelectorForAttributeEvent | class | Event | attribute |
| SetupOptionButtonForAttributeEvent | class | Event | attribute, value |
| SetupOptionSelectorForAttributeEvent | class | Event | attribute, values, startDataValue, doApply |
| SetupScrollBarForAttributeEvent | class | Event | attribute, startValue, minValue, maxValue, step |
| ShowCustomTooltipEvent | class | Event | text, inputAction |
| SummonLogic | unknown | — | — |
| ToggleForbiddenVehicleAreaEvent | unknown | — | — |
| ToggleQuestCustomFPPLockOffEvent | unknown | — | — |
| ToggleRadioReceiver | unknown | — | — |
| TriggerDestructionEvent | class | Event | velocity |
| TryExitPhotomodeEvent | class | Event | — |
| UpdateBucketEnum | enum | — | Vehicle, Character, AttachedObject |

# Citations

- `codeware/scripts/Base/Imports/AbortSummoningActionEvent.reds`
- `codeware/scripts/Base/Imports/ChangeAspectRatioEvent.reds`
- `codeware/scripts/Base/Imports/ChangeCameraControlHintVisibilityEvent.reds`
- `codeware/scripts/Base/Imports/ChangeRadioReceiverStation.reds`
- `codeware/scripts/Base/Imports/ChangeRadioTierEvent.reds`
- `codeware/scripts/Base/Imports/DoneActionEvent.reds`
- `codeware/scripts/Base/Imports/EnableClientSideInteractionEvent.reds`
- `codeware/scripts/Base/Imports/EnableStickerEditorEvent.reds`
- `codeware/scripts/Base/Imports/FearInPlaceEvent.reds`
- `codeware/scripts/Base/Imports/ForceAttributeValueEvent.reds`
- ... and 47 more source files
