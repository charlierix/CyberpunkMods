---
type: "Import"
title: "Quest Maps"
description: "Imported quest maps types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, maps]"
timestamp: 2026-07-01T18:09:28Z
---

# Overview

Imported quest maps types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| JournalPointOfInterestMappin | class | JournalEntry | staticNodeRef, dynamicEntityRef, securityAreaRef, mappinData, offset |
| JournalQuestMultiMapPin | class | JournalQuestMapPinBase | references, slotName, mappinData, offset, uiAnimation |
| JournalQuestPointOfInterestMapPin | class | JournalQuestMapPinBase | — |
| questIsInMirrorsAreaMapArrayElement | struct | — | objectRef |
| questMappinGPSDistance | class | questIDistance | mappinPath |
| questNodeCollisionMapArrayElement | struct | — | objectRef |
| questNodeVisibilityMapArrayElement | struct | — | globalNodeRef |
| questPrefabVariantMapArrayElement | struct | — | globalNodeRef |

# Citations

- `codeware/scripts/Base/Imports/JournalPointOfInterestMappin.reds`
- `codeware/scripts/Base/Imports/JournalQuestMultiMapPin.reds`
- `codeware/scripts/Base/Imports/JournalQuestPointOfInterestMapPin.reds`
- `codeware/scripts/Base/Imports/questIsInMirrorsAreaMapArrayElement.reds`
- `codeware/scripts/Base/Imports/questMappinGPSDistance.reds`
- `codeware/scripts/Base/Imports/questNodeCollisionMapArrayElement.reds`
- `codeware/scripts/Base/Imports/questNodeVisibilityMapArrayElement.reds`
- `codeware/scripts/Base/Imports/questPrefabVariantMapArrayElement.reds`
