---
type: "Import"
title: "Misc Params"
description: "Imported misc params types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:21Z
---

# Overview

Imported misc params types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AIbehaviorAdvancedParameterizedBehavior | class | AIbehaviorParameterizedBehavior | — |
| AIbehaviorParameterizedBehavior | class | ISerializable | treeDefinition, argumentsOverrides |
| AIbehaviorSimpleParameterizedBehavior | class | AIbehaviorParameterizedBehavior | — |
| CMaterialParameter | class | ISerializable | parameterName, register |
| CMaterialParameterColor | class | CMaterialParameter | color |
| CMaterialParameterCpuNameU64 | class | CMaterialParameter | name |
| CMaterialParameterCube | class | CMaterialParameter | texture |
| CMaterialParameterDynamicTexture | class | CMaterialParameter | texture |
| CMaterialParameterFoliageParameters | class | CMaterialParameter | foliageProfile |
| CMaterialParameterGradient | class | CMaterialParameter | gradient |
| CMaterialParameterHairParameters | class | CMaterialParameter | hairProfile |
| CMaterialParameterMultilayerMask | class | CMaterialParameter | mask |
| CMaterialParameterMultilayerSetup | class | CMaterialParameter | setup |
| CMaterialParameterScalar | class | CMaterialParameter | scalar, min, max |
| CMaterialParameterSkinParameters | class | CMaterialParameter | skinProfile |
| CMaterialParameterStructBuffer | class | CMaterialParameter | — |
| CMaterialParameterTerrainSetup | class | CMaterialParameter | setup |
| CMaterialParameterTexture | class | CMaterialParameter | texture |
| CMaterialParameterTextureArray | class | CMaterialParameter | texture |
| CMaterialParameterVector | class | CMaterialParameter | vector |
| ECustomMaterialParam | enum | — | ECMP_CustomParam0, ECMP_CustomParam1, ECMP_CustomParam2, ECMP_CustomParam3, ECMP_CustomParam4 |
| STonemappingACESParams | struct | — | minStops, midGrayScale, toneCurveSaturation, desaturate, tonemapLuminance |
| SWeaponPlaneParams | struct | — | weaponNearPlaneCM |

# Citations

- `codeware/scripts/Base/Imports/AIbehaviorAdvancedParameterizedBehavior.reds`
- `codeware/scripts/Base/Imports/AIbehaviorParameterizedBehavior.reds`
- `codeware/scripts/Base/Imports/AIbehaviorSimpleParameterizedBehavior.reds`
- `codeware/scripts/Base/Imports/CMaterialParameter.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterColor.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterCpuNameU64.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterCube.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterDynamicTexture.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterFoliageParameters.reds`
- `codeware/scripts/Base/Imports/CMaterialParameterGradient.reds`
- ... and 13 more source files
