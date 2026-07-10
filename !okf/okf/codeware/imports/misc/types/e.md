---
type: "Import"
title: "Misc Types/E"
description: "Imported misc types/e types (49 types)."
resource: "codeware/scripts/"
tags: "[imports, e]"
timestamp: 2026-07-01T18:09:19Z
---

# Overview

Imported misc types/e types (49 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| EAreaLightShape | enum | — | ALS_Sphere, ALS_Capsule |
| EColorChannel | enum | — | COLCHANNEL_Red, COLCHANNEL_Green, COLCHANNEL_Blue, COLCHANNEL_Alpha |
| EColorPrimary | enum | — | PRIM_REC709, PRIM_DCIP3, PRIM_BT2020 |
| ECookingPlatform | enum | — | PLATFORM_None, PLATFORM_PC, PLATFORM_XboxOne, PLATFORM_PS4, PLATFORM_PS5 |
| ECubeSourceTextureType | enum | — | CST_CrossHorizontal, CST_CrossVertical, CST_Panorama |
| EDecalRenderMode | enum | — | DRM_AllStatic, DRM_ObjectType, DRM_AllDynamic, DRM_All |
| EDepthCollisionEffect | enum | — | DCE_Bounce, DCE_Glide, DCE_Kill |
| EDynamicDecalSpawnPriority | enum | — | RDDS_Normal, RDDS_Highest |
| EEasingType | enum | — | EET_In, EET_Out, EET_InOut |
| EEmitterGroup | enum | — | EG_Default, EG_Group0, EG_Group1, EG_Group2, EG_Group3 |
| EEntityHighlightType | enum | — | EHE_None, EHE_FillAndOutline, EHE_FillOnly, EHE_OutlineOnly |
| EEnvColorGroup | enum | — | ECG_Default, ECG_Sky, ECG_Group0, ECG_Group1, ECG_Group2 |
| EFreeVectorAxes | enum | — | FVA_One, FVA_Two, FVA_Three, FVA_Four |
| EInputAction | enum | — | IACT_None, IACT_Press, IACT_Release, IACT_Axis |
| ELightShadowCastingMode | enum | — | LSCM_None, LSCM_Normal, LSCM_OnlyDynamic, LSCM_OnlyStatic, LSCM_NormalAndContact |
| ELightShadowSoftnessMode | enum | — | LSSM_ExtraSoft, LSSM_Soft, LSSM_Default, LSSM_Sharp, LSSM_ExtraSharp |
| ELightType | enum | — | LT_Point, LT_Spot, LT_Area |
| ELightUnit | enum | — | LU_Lumen, LU_Watt, LU_Lux, LU_Nit, LU_EV100 |
| EMaterialModifier | enum | — | EMATMOD_HitProxy, EMATMOD_WindData, EMATMOD_ParticleParams, EMATMOD_RemoteCamera, EMATMOD_Mirror |
| EMaterialPriority | enum | — | EMP_Normal, EMP_Front |
| EMaterialShadingRateMode | enum | — | MSRM_Default, MSRM_Disable, MSRM_Force2x2 |
| EMaterialVertexFactory | enum | — | MVF_Terrain, MVF_MeshStatic, MVF_MeshSkinned, MVF_MeshExtSkinned, MVF_GarmentMeshSkinned |
| EMeshParticleOrientationMode | enum | — | MPOM_Normal, MPOM_MovementDirection, MPOM_NoRotation |
| EMeshShadowImportanceBias | enum | — | MSIB_EvenLessImportant, MSIB_LessImportant, MSIB_Default, MSIB_MoreImportant, MSIB_EvenMoreImportant |
| EMeshStreamType | enum | — | MST_Position_3F, MST_SkinningIndices_4U8, MST_SkinningWeights_4F, MST_SkinningIndicesExt_4U8, MST_SkinningWeightsExt_4F |
| EMeshVertexType | enum | — | MVT_StaticMesh, MVT_ProceduralMesh, MVT_SkinnedMesh, MVT_ExtSkinnedMesh, MVT_GarmentSkinnedMesh |
| ENoiseType | enum | — | NT_Random, NT_Simplex2D, NT_Simplex3D |
| EParticleEventSpawnObject | enum | — | PESO_Particle, PESO_Decal |
| EParticleEventType | enum | — | PET_Any, PET_Death, PET_OverLife, PET_OverDistance, PET_Collision |
| ERenderDynamicDecalAtlas | enum | — | RDDA_1x1, RDDA_2x1, RDDA_2x2, RDDA_4x2, RDDA_4x4 |
| ERenderDynamicDecalProjection | enum | — | RDDP_Ortho, RDDP_Sphere |
| ERenderMaterialType | enum | — | RMT_Standard, RMT_Subsurface, RMT_Cloth, RMT_Eye, RMT_Hair |
| ERenderMeshStreams | enum | — | RMS_PositionSkinning, RMS_TexCoords, RMS_TangentFrame, RMS_Extended, RMS_Custom0 |
| ERenderObjectType | enum | — | ROT_Static, ROT_Terrain, ROT_Road, ROT_Skinned, ROT_Character |
| ERenderProxyType | enum | — | RPT_None, RPT_Mesh, RPT_PointLight, RPT_SpotLight, RPT_AreaLight |
| ERenderingMode | enum | — | RM_HitProxies, RM_Shaded, RM_Shaded_NoAmbient, RM_GBufferOnly, RM_SafeMode |
| ESaveFormat | enum | — | SF_PNG, SF_EXR, SF_PNG_AND_EXR |
| ETextureAddressing | enum | — | TA_Wrap, TA_Mirror, TA_Clamp, TA_MirrorOnce, TA_Border |
| ETextureAnimationMode | enum | — | TAM_Speed, TAM_LifeTime |
| ETextureComparisonFunction | enum | — | TCF_None, TCF_Less, TCF_Equal, TCF_LessEqual, TCF_Greater |
| ETextureCompression | enum | — | TCM_None, TCM_DXTNoAlpha, TCM_DXTAlpha, TCM_RGBE, TCM_Normalmap |
| ETextureFilteringMag | enum | — | TFMag_Point, TFMag_Linear |
| ETextureFilteringMin | enum | — | TFMin_Point, TFMin_Linear, TFMin_Anisotropic, TFMin_AnisotropicLow |
| ETextureFilteringMip | enum | — | TFMip_None, TFMip_Point, TFMip_Linear |
| ETextureRawFormat | enum | — | TRF_Invalid, TRF_TrueColor, TRF_DeepColor, TRF_Grayscale, TRF_HDRFloat |
| ETimeOfYearSeason | enum | — | ETOYS_Spring, ETOYS_Summer, ETOYS_Autumn, ETOYS_Winter |
| ETransitionType | enum | — | EET_Linear, EET_Sine, EET_Cubic, EET_Quad, EET_Quart |
| curveEInterpolationType | enum | — | EIT_Constant, EIT_Linear, EIT_BezierQuadratic, EIT_BezierCubic, EIT_Hermite |
| curveESegmentsLinkType | enum | — | ESLT_Normal, ESLT_Smooth, ESLT_SmoothSymmetric |

# Citations

- `codeware/scripts/Base/Imports/EAreaLightShape.reds`
- `codeware/scripts/Base/Imports/EColorChannel.reds`
- `codeware/scripts/Base/Imports/EColorPrimary.reds`
- `codeware/scripts/Base/Imports/ECookingPlatform.reds`
- `codeware/scripts/Base/Imports/ECubeSourceTextureType.reds`
- `codeware/scripts/Base/Imports/EDecalRenderMode.reds`
- `codeware/scripts/Base/Imports/EDepthCollisionEffect.reds`
- `codeware/scripts/Base/Imports/EDynamicDecalSpawnPriority.reds`
- `codeware/scripts/Base/Imports/EEasingType.reds`
- `codeware/scripts/Base/Imports/EEmitterGroup.reds`
- ... and 39 more source files
