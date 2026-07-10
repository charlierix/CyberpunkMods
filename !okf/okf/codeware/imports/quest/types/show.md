---
type: "Import"
title: "Quest Types/Show"
description: "Imported quest types/show types (13 types)."
resource: "codeware/scripts/"
tags: "[imports, show]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/show types (13 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questShowBracket_NodeSubType | class | questITutorial_NodeSubType | bracketID, visible, visibleOnUILayer, bracketType, anchor |
| questShowCustomQuestNotification_NodeType | class | questIUIManagerNodeType | customQuestNotificationData |
| questShowCustomTooltip_NodeType | class | questIUIManagerNodeType | setTooltip, text, inputAction, holdIndicationType, queuePriority |
| questShowDialogIndicator_NodeType | class | questIUIManagerNodeType | params |
| questShowDialogIndicator_NodeTypeParams | struct | — | objectRef |
| questShowHighlight_NodeSubType | class | questITutorial_NodeSubType | entityReference, enable |
| questShowLevelUpNotification_NodeType | class | questIUIManagerNodeType | levelUpData |
| questShowNarrativeEvent_NodeType | class | questIUIManagerNodeType | eventText, textColor, durationSec |
| questShowOnscreen_NodeType | class | questIUIManagerNodeType | message, localizedMessage, duration, show |
| questShowOverlay_NodeSubType | class | questITutorial_NodeSubType | overlayLibrary, libraryItemName, visible, pauseGame, lockPlayerMovement |
| questShowPointOfNoReturnPrompt_NodeType | class | questIUIManagerNodeType | — |
| questShowPopup_NodeSubType | class | questITutorial_NodeSubType | path, open, closeAtInput, pauseGame, hideInMenu |
| questShowWorldNode_NodeType | class | questIWorldDataManagerNodeType | objectRef, isPlayer, show, componentName |

# Citations

- `codeware/scripts/Base/Imports/questShowBracket_NodeSubType.reds`
- `codeware/scripts/Base/Imports/questShowCustomQuestNotification_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowCustomTooltip_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowDialogIndicator_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowDialogIndicator_NodeTypeParams.reds`
- `codeware/scripts/Base/Imports/questShowHighlight_NodeSubType.reds`
- `codeware/scripts/Base/Imports/questShowLevelUpNotification_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowNarrativeEvent_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowOnscreen_NodeType.reds`
- `codeware/scripts/Base/Imports/questShowOverlay_NodeSubType.reds`
- ... and 3 more source files
