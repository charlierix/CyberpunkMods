---
type: "Import"
title: "Rendering Settings"
description: "Imported rendering settings types (40 types)."
resource: "codeware/scripts/"
tags: "[imports, settings]"
timestamp: 2026-07-01T18:09:29Z
---

# Overview

Imported rendering settings types (40 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AmbientOverrideAreaSettings | class | IAreaSettings | color |
| AtmosphereAreaSettings | class | IAreaSettings | skydomeColor, skylightColor, groundReflectance, sunMinZ, horizonMinZ |
| BloomAreaSettings | class | IAreaSettings | blurSizeX, blurSizeY, mipColors, mipLuminanceClamp, luminanceThresholdMin |
| BlurAreaSettings | class | IAreaSettings | circularBlurRadius |
| CharacterBrighteningAreaSettings | class | IAreaSettings | effectStrengthMultiplier, minDistance, maxDistance, envMultiplier |
| ChromaticAberrationAreaSettings | class | IAreaSettings | chromaticAberrationEnabled, chromaticAberrationMargin, chromaticAberrationSize, chromaticAberrationExp, subpixelDispersal |
| CloudAreaSettings | class | IAreaSettings | cloudSunShadowFaloff, cloudSunScattering, cloudMoonScattering, cloudLightColor, cloudAmbientIntensity |
| ColorGradingAreaSettings | class | IAreaSettings | contrast, contrastPivot, saturation, hue, brightness |
| ContactShadowsSettings | class | IAreaSettings | contactShadows |
| DistantFogAreaSettings | class | IAreaSettings | range, albedoNear, albedoFar, nearDistance, farDistance |
| DistantIrradianceeSettings | class | IAreaSettings | distantRange, distantHeightRange, distantLights, distantLightsRange, blendDistance |
| DistantLightsAreaSettings | class | IAreaSettings | distantLightStartDistance, distantLightFadeDistance |
| DistantProxiesSettings | class | IAreaSettings | distantProxiesEmissive, distantProxiesEmissiveHeight, distantProxiesEmissivePower, distantProxiesBboxzBlend |
| EmissiveColorSettings | class | IAreaSettings | tint, saturation, brigtness, exposure, cameraLuminance |
| EnvironmentColorGroupsSettings | class | IAreaSettings | skyTint, colorGroup |
| ExposureAreaSettings | class | IAreaSettings | exposureAdaptationSpeedUp, exposureAdaptationSpeedDown, exposurePercentageThresholdLow, exposurePercentageThresholdHigh, exposureCompensation |
| ExposureCompensationAreaSettings | class | IAreaSettings | exposureCompensation |
| ExposureCompensationOffsetAreaSettings | class | IAreaSettings | exposureCompensationOffset |
| FilmGrainAreaSettings | class | IAreaSettings | strength, luminanceBias, grainSize, applyAfterUpsampling |
| GlobalIlluminationSettings | class | IAreaSettings | multiBouceScale, multiBouceSaturation, emissiveScale, diffuseScale, localLightsScale |
| GlobalLightOverrideAreaSettings | class | IAreaSettings | color, lightAzimuth, lightElevation |
| HeatHazeAreaSettings | class | IAreaSettings | effectStrength, startDistance, maxDistance, patternScale, movementSpeedScale |
| ImageBasedFlareAreaSettings | class | IAreaSettings | treshold, dispersal, haloWidth, distortion, curve |
| LightAreaSettings | class | IAreaSettings | latitude, season, sunRotationOffset, sunColor, sunSize |
| LightColorSettings | class | IAreaSettings | light |
| LightDirectionSettings | class | IAreaSettings | direction |
| LightGroupsAreaSettings | class | IAreaSettings | groupFade |
| MotionBlurAreaSettings | class | IAreaSettings | strength |
| PathTracingSettings | class | IAreaSettings | albedoModulation, diffuseGlobalScale, diffuseSunScale, diffuseSkyScale, diffuseLocalLightsScale |
| RainAreaSettings | class | IAreaSettings | numParticles, radius, heightRange, globalLightResponse, tiling |
| RenderFeaturesAreaSettings | class | IAreaSettings | allowGlobalIllumination, allowScreenSpaceReflections, allowVolumetricFog |
| ShaftsAreaSettings | struct | — | shaftsLevelIndex, shaftsThresholdsScale |
| SharpeningAreaSettings | class | IAreaSettings | sharpeningStrength, sharpeningStrengthWhenUpsaling, sharpeningStrengthUpscalingTreshold |
| TonemappingAreaSettings | class | IAreaSettings | mode, hdrMode |
| VignetteAreaSettings | class | IAreaSettings | vignetteEnabled, vignetteRadius, vignetteExp, vignetteColor |
| VolumetricFogAreaSettings | class | IAreaSettings | albedo, range, fogHeight, fogHeightFalloff, fogHeightMaxCut |
| WaterAreaSettings | class | IAreaSettings | blurMin, blurMax, blurExponent, depth, density |
| WindAreaSettings | class | IAreaSettings | strength, direction |
| rendEmitterDelaySettings | struct | — | emitterDelay, useEmitterDelayRange |
| rendEmitterDurationSettings | struct | — | emitterDuration, useEmitterDurationRange |

# Citations

- `codeware/scripts/Base/Imports/AmbientOverrideAreaSettings.reds`
- `codeware/scripts/Base/Imports/AtmosphereAreaSettings.reds`
- `codeware/scripts/Base/Imports/BloomAreaSettings.reds`
- `codeware/scripts/Base/Imports/BlurAreaSettings.reds`
- `codeware/scripts/Base/Imports/CharacterBrighteningAreaSettings.reds`
- `codeware/scripts/Base/Imports/ChromaticAberrationAreaSettings.reds`
- `codeware/scripts/Base/Imports/CloudAreaSettings.reds`
- `codeware/scripts/Base/Imports/ColorGradingAreaSettings.reds`
- `codeware/scripts/Base/Imports/ContactShadowsSettings.reds`
- `codeware/scripts/Base/Imports/DistantFogAreaSettings.reds`
- ... and 30 more source files
