---
type: "Import"
title: "Material Types"
description: "Imported game engine types in the material domain (20 types)."
resource: "codeware/scripts/"
tags: "[imports, material]"
timestamp: 2026-07-01T18:09:18Z
---

# Overview

Imported game engine types in the material domain (20 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| MaterialLayerDef | struct | — | name, colorPalette |
| MaterialParameterInstance | struct | — | name |
| MaterialPass | struct | — | stagePassNameRegular, depthStencilMode, blendMode, stencilWriteMask, orderIndex |
| MaterialTechnique | struct | — | passes, streamsToBind |
| MaterialUsedParameter | struct | — | name |
| MicroblendDef | struct | — | name |
| MorphTargetMesh | class | resStreamedResource | baseMesh, targets, boundingBox, baseTextureParamName, blob |
| MorphTargetMeshEntry | struct | — | name, faceRegion, boneRigMatrices |
| MorphTargetsDiffTextureSize | enum | — | TEXTURE_SIZE_1024x1024, TEXTURE_SIZE_512x512, TEXTURE_SIZE_256x256 |
| MorphTargetsFaceRegion | enum | — | FACE_REGION_EYES, FACE_REGION_NOSE, FACE_REGION_MOUTH, FACE_REGION_JAW, FACE_REGION_EARS |
| MorphTargetsTextureBlendInfo | struct | — | blend, name |
| Multilayer_Layer | struct | — | matTile, microblend, microblendContrast, microblendOffsetU, opacity |
| Multilayer_LayerOverrideSelection | struct | — | colorScale, roughLevelsIn, metalLevelsIn |
| Multilayer_LayerTemplate | class | CResource | overrides, defaultOverrides, colorTexture, normalTexture, roughnessTexture |
| Multilayer_LayerTemplateOverrides | struct | — | colorScale, roughLevelsOut, metalLevelsOut |
| Multilayer_LayerTemplateOverridesColor | struct | — | n |
| Multilayer_LayerTemplateOverridesLevels | struct | — | n |
| Multilayer_LayerTemplateOverridesNormalStrength | struct | — | n |
| Multilayer_Mask | class | CResource | renderResourceBlob |
| Multilayer_Setup | class | CResource | layers, ratio, useNormal |

# Citations

- `codeware/scripts/Base/Imports/MaterialLayerDef.reds`
- `codeware/scripts/Base/Imports/MaterialParameterInstance.reds`
- `codeware/scripts/Base/Imports/MaterialPass.reds`
- `codeware/scripts/Base/Imports/MaterialTechnique.reds`
- `codeware/scripts/Base/Imports/MaterialUsedParameter.reds`
- `codeware/scripts/Base/Imports/MicroblendDef.reds`
- `codeware/scripts/Base/Imports/MorphTargetMesh.reds`
- `codeware/scripts/Base/Imports/MorphTargetMeshEntry.reds`
- `codeware/scripts/Base/Imports/MorphTargetsDiffTextureSize.reds`
- `codeware/scripts/Base/Imports/MorphTargetsFaceRegion.reds`
- ... and 10 more source files
