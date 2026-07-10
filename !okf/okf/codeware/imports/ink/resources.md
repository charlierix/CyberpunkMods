---
type: "Import"
title: "Ink Resources"
description: "Imported ink resources types (14 types)."
resource: "codeware/scripts/"
tags: "[imports, resources]"
timestamp: 2026-07-01T18:09:16Z
---

# Overview

Imported ink resources types (14 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkCreditsResource | class | CResource | sections |
| inkEngineSettingsResource | class | CResource | fallbackCompositionResource, fallbackShapeCollectionResource, fallbackIconAtlasResource, inputKeyIconsDefinitionResource, fallbackFontFamilyPath |
| inkFontFamilyResource | class | CResource | familyName, fontStyles |
| inkFullscreenCompositionResource | class | CResource | compositionPresets, backgroundMenuTextureUHDRes, backgroundMenuTextureFHDRes, previewSettings |
| inkGameSettingsResource | class | CResource | compositionResource, permanentTextureAtlases, permanentTextureAtlasesPC, permanentTextureAtlasesDurango, permanentTextureAtlasesOrbis |
| inkHudEntriesResource | class | CResource | rootWidget, themeOverride, entries |
| inkLayersResource | class | CResource | layerDefinitions, preGameLayerDefinitions, permanentLayerDefinitions, layerDefinitionsSet |
| inkMenuResource | class | CResource | menusEntries, scenariosNames, initialScenarioName |
| inkShapeCollectionResource | class | CResource | presets |
| inkStyleResource | class | CResource | styles, styleImports, themes, overrides, hideInInheritingStyles |
| inkStyleResourceWrapper | class | ISerializable | styleResource |
| inkTypographyResource | class | CResource | languages |
| inkWidgetBrushResource | class | CResource | brush |
| inkWidgetResourceVersion | enum | — | Default, BrushToAtlas |

# Citations

- `codeware/scripts/Base/Imports/inkCreditsResource.reds`
- `codeware/scripts/Base/Imports/inkEngineSettingsResource.reds`
- `codeware/scripts/Base/Imports/inkFontFamilyResource.reds`
- `codeware/scripts/Base/Imports/inkFullscreenCompositionResource.reds`
- `codeware/scripts/Base/Imports/inkGameSettingsResource.reds`
- `codeware/scripts/Base/Imports/inkHudEntriesResource.reds`
- `codeware/scripts/Base/Imports/inkLayersResource.reds`
- `codeware/scripts/Base/Imports/inkMenuResource.reds`
- `codeware/scripts/Base/Imports/inkShapeCollectionResource.reds`
- `codeware/scripts/Base/Imports/inkStyleResource.reds`
- ... and 4 more source files
