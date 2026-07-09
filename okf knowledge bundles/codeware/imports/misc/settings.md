---
type: "Import"
title: "Misc Settings"
description: "Imported misc settings types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, settings]"
timestamp: 2026-07-01T18:09:21Z
---

# Overview

Imported misc settings types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CEnvDisplaySettingsParams | struct | — | enableInstantAdaptation, enableEnvProbeInstantUpdate, allowBloom, allowAntialiasing, allowDOF |
| GICGIEditSettings | class | ISerializable | — |
| HACK_AREA_Settings | class | IAreaSettings | surfelScale, missingEnergyScale, overrideOnPureView, surfAlbedoOverrideRatio, surfAlbedoOverride |
| IAreaSettings | class | ISerializable | enable, disabledIndexedProperties |
| IKChainSettings | struct | — | chainName, ikEndPointOffset |
| RTAOAreaSettings | class | IAreaSettings | RangeNear, RangeFar, RadiusNear, RadiusFar, coneAoDiffuseStrength |
| RTXDIAreaSettings | class | IAreaSettings | diffuseSkyScale, specularSkyScale |
| SSAOAreaSettings | class | IAreaSettings | noiseFilterTolerance, blurTolerance, upsampleTolerance, rejectionFalloff, combineResolutionsBeforeBlur |
| SSSRAreaSettings | class | IAreaSettings | depthFadeStart, depthFadeEnd |

# Citations

- `codeware/scripts/Base/Imports/CEnvDisplaySettingsParams.reds`
- `codeware/scripts/Base/Imports/GICGIEditSettings.reds`
- `codeware/scripts/Base/Imports/HACK_AREA_Settings.reds`
- `codeware/scripts/Base/Imports/IAreaSettings.reds`
- `codeware/scripts/Base/Imports/IKChainSettings.reds`
- `codeware/scripts/Base/Imports/RTAOAreaSettings.reds`
- `codeware/scripts/Base/Imports/RTXDIAreaSettings.reds`
- `codeware/scripts/Base/Imports/SSAOAreaSettings.reds`
- `codeware/scripts/Base/Imports/SSSRAreaSettings.reds`
