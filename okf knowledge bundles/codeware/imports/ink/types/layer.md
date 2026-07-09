---
type: "Import"
title: "Ink Types/Layer"
description: "Imported ink types/layer types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, layer]"
timestamp: 2026-07-01T18:09:15Z
---

# Overview

Imported ink types/layer types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkLayer | class | ISerializable | — |
| inkLayerDefinitionCollection | struct | — | menuLayer, hudLayer, offscreenLayer, photoModeLayer |
| inkLayerDefinition_NEW | struct | — | name, drawingPolicy, enabled, useGlobalStyleTheme, useGameInput |
| inkLayerDefinitionsSet | struct | — | layersDefinitions |
| inkLayerDrawingPolicy | enum | — | InOrder, InParallel |
| inkLayerProxy | class | ISerializable | — |

# Citations

- `codeware/scripts/Base/Imports/inkLayer.reds`
- `codeware/scripts/Base/Imports/inkLayerDefinitionCollection.reds`
- `codeware/scripts/Base/Imports/inkLayerDefinition_NEW.reds`
- `codeware/scripts/Base/Imports/inkLayerDefinitionsSet.reds`
- `codeware/scripts/Base/Imports/inkLayerDrawingPolicy.reds`
- `codeware/scripts/Base/Imports/inkLayerProxy.reds`
