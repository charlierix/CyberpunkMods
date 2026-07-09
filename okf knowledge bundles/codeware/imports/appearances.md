---
type: "Import"
title: "Appearances Types"
description: "Imported game engine types in the appearances domain (10 types)."
resource: "codeware/scripts/"
tags: "[imports, appearances]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported game engine types in the appearances domain (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AppearancesReadyTPPRepresentationEvent | class | Event | — |
| appearanceAlternateAppearanceEntry | struct | — | Original, AlternateAppearanceIndex |
| appearanceAppearanceDefinition | class | ISerializable | name, parentAppearance, partsMasks, partsValues, partsOverrides |
| appearanceAppearancePart | struct | — | resource |
| appearanceAppearancePartOverrides | struct | — | partResource, componentsOverrides |
| appearanceAppearanceResource | class | resStreamedResource | alternateAppearanceSettingName, alternateAppearanceSuffixes, alternateAppearanceMapping, censorshipMapping, Wounds |
| appearanceCensorshipEntry | struct | — | Original, CensorFlags |
| appearanceChunkMaskSettings | struct | — | chunksIds, meshGeometryHash |
| appearanceCookedAppearanceData | class | CResource | dependencies, totalSizeOnDisk |
| appearancePartComponentOverrides | struct | — | componentName, chunkMask, initialTransform, acceptDismemberment |

# Citations

- `codeware/scripts/Base/Imports/AppearancesReadyTPPRepresentationEvent.reds`
- `codeware/scripts/Base/Imports/appearanceAlternateAppearanceEntry.reds`
- `codeware/scripts/Base/Imports/appearanceAppearanceDefinition.reds`
- `codeware/scripts/Base/Imports/appearanceAppearancePart.reds`
- `codeware/scripts/Base/Imports/appearanceAppearancePartOverrides.reds`
- `codeware/scripts/Base/Imports/appearanceAppearanceResource.reds`
- `codeware/scripts/Base/Imports/appearanceCensorshipEntry.reds`
- `codeware/scripts/Base/Imports/appearanceChunkMaskSettings.reds`
- `codeware/scripts/Base/Imports/appearanceCookedAppearanceData.reds`
- `codeware/scripts/Base/Imports/appearancePartComponentOverrides.reds`
