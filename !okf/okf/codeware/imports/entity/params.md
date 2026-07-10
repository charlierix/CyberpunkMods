---
type: "Import"
title: "Entity Params"
description: "Imported entity params types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:08Z
---

# Overview

Imported entity params types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| entAnimParamSlotFunction | enum | — | RenderingPlane, Visibility |
| entAnimTrackParameter | struct | — | animTrackName, defaultValue |
| entCorpseParameter | class | entEntityParameter | lod, bakedPose, bakedBoneNames, forceLOD0Components, baseRig |
| entEntityParameter | unknown | — | — |
| entEntityParametersBuffer | struct | — | — |
| entEntityParametersStorage | class | ISerializable | parameters |
| entGarmentParameter | class | entEntityParameter | componentsData, collarArea |

# Citations

- `codeware/scripts/Base/Imports/entAnimParamSlotFunction.reds`
- `codeware/scripts/Base/Imports/entAnimTrackParameter.reds`
- `codeware/scripts/Base/Imports/entCorpseParameter.reds`
- `codeware/scripts/Base/Imports/entEntityParameter.reds`
- `codeware/scripts/Base/Imports/entEntityParametersBuffer.reds`
- `codeware/scripts/Base/Imports/entEntityParametersStorage.reds`
- `codeware/scripts/Base/Imports/entGarmentParameter.reds`
