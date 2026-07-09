---
type: "Import"
title: "Minimap Types"
description: "Imported game engine types in the minimap domain (6 types)."
resource: "codeware/scripts/"
tags: "[imports, minimap]"
timestamp: 2026-07-01T18:09:18Z
---

# Overview

Imported game engine types in the minimap domain (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| MinimapDataNode | class | worldNode | encodedShapesRef, streamingDistance, localBounds, allInteriorShapes |
| MinimapDataNodeInstance | class | worldINodeInstance | — |
| MinimapHazardWarningMappinController | class | BaseMinimapMappinController | — |
| minimapEncodedShapes | class | CResource | QuantizationScale, QuantizationBias, BoxQuantizationScale, BoxQuantizationBias, NumPoints |
| minimapuiGeometryWidget | class | inkCanvas | widgetTemplates, settings |
| minimapuiSettings | struct | — | showTime |

# Citations

- `codeware/scripts/Base/Imports/MinimapDataNode.reds`
- `codeware/scripts/Base/Imports/MinimapDataNodeInstance.reds`
- `codeware/scripts/Base/Imports/MinimapHazardWarningMappinController.reds`
- `codeware/scripts/Base/Imports/minimapEncodedShapes.reds`
- `codeware/scripts/Base/Imports/minimapuiGeometryWidget.reds`
- `codeware/scripts/Base/Imports/minimapuiSettings.reds`
