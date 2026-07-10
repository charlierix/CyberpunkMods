---
type: "Import"
title: "Rendering Types"
description: "Imported rendering types types (79 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:29Z
---

# Overview

Imported rendering types types (79 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ColorBalance | struct | — | Red, Blue |
| DynamicTexture | class | ITexture | width, height, scaleToViewport, mipChain, samplesCount |
| GlobalLightingTrajectory | struct | — | latitude, moonRotationOffset |
| GlobalLightingTrajectoryOverride | struct | — | overrideScale, sunRotationOffset, timeOfYearSeason |
| ImageTextureGenerator | class | IDynamicTextureGenerator | — |
| PhotomodeLightObject | class | GameObject | — |
| RenderDecalNormalsBlendingMode | enum | — | AlphaBlending, Reorient |
| RenderDecalOrderPriority | enum | — | Priority0, Priority1, Priority2, Priority3 |
| RenderSceneLayer | enum | — | Default, Cyberspace, WorldMap |
| RenderSettingFactors | struct | — | resolutionAberrationScale, resolutionFilmGrainScale |
| RenderingFunctionalTests | class | IScriptable | — |
| ShaderDefine | struct | — | name |
| StaticShaderInputLayout | enum | — | DebugVertexBase, DebugVertexUV, DebugVertexUV_Fullscreen, NoBuffers_Fullscreen, NoBuffers_PointList |
| TonemappingModeACES | class | ITonemappingMode | params |
| TonemappingModeACESApprox | class | ITonemappingMode | — |
| TonemappingModeLinear | class | ITonemappingMode | — |
| TonemappingModeLottes | class | ITonemappingMode | maxInput, contrast, midIn, midOut, crosstalk |
| TonemappingModeLottesACES | class | ITonemappingMode | maxInput, contrast, midIn, midOut |
| envUtilsNeighborMode | enum | — | eCLOSEST, eONLY_GLOBAL, eONLY_SELF, eFILL_SURROUNDING |
| envUtilsReflectionProbeAmbientContributionMode | enum | — | eNO_AMBIENT_CONTRIBUTION, eALLOW_AMBIENT_CONTRIBUTION, eOVERRIDE_GI_AMBIENT |
| rendCaptureContextType | enum | — | SceneGamedef, AnimViewer |
| rendChunk | struct | — | chunkVertices, numVertices, materialId, baseRenderMask, renderMask |
| rendContactShadowReciever | enum | — | CSR_None, CSR_All, CSR_CharacterOnly |
| rendEParticleSortingMode | enum | — | PSM_None, PSM_Billboard, PSM_Regular |
| rendEPathTracingLightUsage | enum | — | PTLU_Everywhere, PTLU_OnlyInPathTracing, PTLU_ExcludeFromPathTracing |
| rendEStreamingObserverMode | enum | — | Point, Box |
| rendEmitterLOD | struct | — | lodSwitchDistance, birthRate, emitterDelaySettings, isEnabled |
| rendEmitterSimulationShaders | struct | — | — |
| rendFont | class | CResource | — |
| rendGIGroup | enum | — | GI_Group0, GI_Group1 |
| rendGIVolume | enum | — | GI_Exterior, GI_Interior1, GI_Interior2, GI_Interior3, GI_Interior4 |
| rendHistogramBias | struct | — | mulCoef |
| rendIRenderTextureBlob | class | IRenderResourceBlob | header |
| rendIndexBufferChunk | struct | — | pe |
| rendLightAttenuation | enum | — | LA_InverseSquare, LA_Linear |
| rendLightGroup | enum | — | LG_Group0, LG_Group1, LG_Group2, LG_Group3, LG_Group4 |
| rendOpacityMicromapChunk | struct | — | mChunkIndex, terialIdentifier, mDigest, mIndexBuffer16bit, mArrayBufferOffset |
| rendOpacityMicromapUsageCounts | struct | — | bdivisionLevel, unt |
| rendParticleBurst | struct | — | burstTime, spawnTimeRange |
| rendRayTracedShadowsPlatform | enum | — | RLSP_All, RLSP_PC, RLSP_Consoles |
| rendRenderMeshBlob | class | IRenderResourceBlob | header |
| rendRenderMeshBlobHeader | struct | — | version, bonePositions, renderChunks, speedTreeWind, customData |
| rendRenderMultilayerMaskBlob | class | IRenderResourceBlob | header |
| rendRenderMultilayerMaskBlobHeader | struct | — | version, atlasHeight, maskWidth, maskWidthLow, maskTileSize |
| rendRenderMultilayerMaskBlobPC | class | rendRenderMultilayerMaskBlob | — |
| rendRenderMultilayerMaskBlobPS4 | class | rendRenderMultilayerMaskBlob | — |
| rendRenderMultilayerMaskBlobProspero | class | rendRenderMultilayerMaskBlob | — |
| rendRenderMultilayerMaskBlobScarlett | class | rendRenderMultilayerMaskBlob | — |
| rendRenderMultilayerMaskBlobXboxOne | class | rendRenderMultilayerMaskBlob | — |
| rendRenderParticleBlob | class | IRenderResourceBlob | header, updaterData, gpuSimShaders |
| rendRenderParticleBlobEmitterInfo | struct | — | emitterHash, backLightingFactor, maskInsideCar, maskAboveWater, maxParticles |
| rendRenderParticleBlobHeader | struct | — | version |
| rendRenderTextureBlobHeader | struct | — | version, textureInfo, histogramData |
| rendRenderTextureBlobMemoryLayout | struct | — | rowPitch |
| rendRenderTextureBlobPC | class | rendIRenderTextureBlob | — |
| rendRenderTextureBlobPS4 | class | rendIRenderTextureBlob | — |
| rendRenderTextureBlobPlacement | struct | — | offset |
| rendRenderTextureBlobProspero | class | rendIRenderTextureBlob | — |
| rendRenderTextureBlobScarlett | class | rendIRenderTextureBlob | — |
| rendRenderTextureBlobSizeInfo | struct | — | width, depth |
| rendRenderTextureBlobStreamable | class | rendIRenderTextureBlob | — |
| rendRenderTextureBlobTextureInfo | struct | — | type, sliceSize, sliceCount |
| rendRenderTextureBlobXboxOne | class | rendIRenderTextureBlob | — |
| rendResolutionMultiplier | enum | — | X1, X2, X4 |
| rendSLightFlickering | struct | — | positionOffset, flickerPeriod |
| rendScreenshotMode | enum | — | NONE, NORMAL, NORMAL_MULTISAMPLE, LAYERED, HIGH_RESOLUTION |
| rendTextureRegion | class | ISerializable | name, isStretch, regionParts |
| rendTextureRegionPart | class | ISerializable | innerRegion, outerRegion |
| rendVertexBufferChunk | struct | — | vertexLayout |
| rendWindShapeAnchorPointDepth | enum | — | AP_CENTER, AP_FRONT, AP_BACK |
| rendWindShapeAnchorPointHorz | enum | — | AP_CENTER, AP_RIGHT, AP_LEFT |
| rendWindShapeAnchorPointVert | enum | — | AP_CENTER, AP_TOP, AP_BOTTOM |
| renddimEPreset | enum | — | _228x128, _456x256, _480x270, _640x480, _960x540 |
| renderDevEnvProbeView | enum | — | RADIANCE, ALBEDO, NORMAL, ROUGHNESS, METALNESS |
| renderDevGIProbeView | enum | — | RADIANCE, SKY_VISIBILITY, ENV_ID, FLAG_0, FLAG_1 |
| renderDevSurfelView | enum | — | ALBEDO, NORMAL, SHADOWS, CLOSEST_PROBE, EMISSIVE |
| renderDevTXAADebugMode | enum | — | TXAA_NoDebug, TXAA_ShowHistoryBlendFactor |
| shadowsShadowCastingMode | enum | — | Default, Always, Never |
| visWorldOccluderType | enum | — | Default, None, Detail, MinorInterior, MajorInterior |

# Citations

- `codeware/scripts/Base/Imports/ColorBalance.reds`
- `codeware/scripts/Base/Imports/DynamicTexture.reds`
- `codeware/scripts/Base/Imports/GlobalLightingTrajectory.reds`
- `codeware/scripts/Base/Imports/GlobalLightingTrajectoryOverride.reds`
- `codeware/scripts/Base/Imports/ImageTextureGenerator.reds`
- `codeware/scripts/Base/Imports/PhotomodeLightObject.reds`
- `codeware/scripts/Base/Imports/RenderDecalNormalsBlendingMode.reds`
- `codeware/scripts/Base/Imports/RenderDecalOrderPriority.reds`
- `codeware/scripts/Base/Imports/RenderSceneLayer.reds`
- `codeware/scripts/Base/Imports/RenderSettingFactors.reds`
- ... and 69 more source files
