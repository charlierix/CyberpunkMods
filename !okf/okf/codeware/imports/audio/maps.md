---
type: "Import"
title: "Audio Maps"
description: "Imported audio maps types (32 types)."
resource: "codeware/scripts/"
tags: "[imports, maps]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio maps types (32 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAudBulletTimeModeMap | class | audioAudioMetadata | bulletTimeMapItems |
| audioAudBulletTimeModeMapItem | class | audioAudioMetadata | enterEvent, exitEvent, timeModeRTPC |
| audioAudioMaterialMetadataMapItem | class | audioAudioMetadata | footstepsMetadata, npcFootstepsMetadata, ragdollMetadata, physicalMaterial, obstructionData |
| audioAudioScenesMap | class | audioAudioMetadata | defaultScene, scenesToActivateByQuestEvent |
| audioCombatVoTriggerVariationsMap | class | audioAudioMetadata | voTriggerVariations |
| audioCombatVoTriggerVariationsMapItem | struct | — | name, shuffle |
| audioContextualAudEventMap | class | audioAudioMetadata | contextualAudEventMapItems |
| audioContextualAudEventMapItem | class | audioAudioMetadata | context, event |
| audioFoleyLoopMappingMetadata | class | audioAudioMetadata | loopsPerAppearance, loopsPerVisualTag |
| audioFoleyNPCAppearanceMappingMetadata | class | audioAudioMetadata | fallbackMetadata, NPCsPerAppearance, NPCsPerMainMaterial, NPCsPerAdditive |
| audioFoleyPlayerAppearanceMappingMetadata | class | audioAudioMetadata | fallbackMetadata, jacketSettings, topSettings, bottomSettings, jewelrySettings |
| audioFootstepDecalMaterialsMap | class | audioAudioMetadata | closestDecalDetectionRadius, entries |
| audioGenericNameEventMap | class | audioAudioMetadata | eventOverrides |
| audioLanguageMapItem | class | audioAudioMetadata | language |
| audioMeleeRigMap | class | audioAudioMetadata | mapItems |
| audioMeleeRigMapItem | class | audioAudioMetadata | matchingRigs |
| audioRadioStationMetadataMap | class | audioAudioMetadata | radioStations, switchStationEvent, turnOnRadioEvent, turnOffRadioEvent, defaultBackgroundJingle |
| audioUiControlMap | class | audioAudioMetadata | uiControlsByName |
| audioVehicleCollisionMap | class | audioAudioMetadata | minImpactVelocityThreshold, minRumbleVelocityThreshold, rumbleCooldown, scrapingMinTangentialVelocityThreshold, scrapingMaxCollisionCooldown |
| audioVehicleCollisionMapItem | struct | — | name, scrapingLoopStart |
| audioVehicleWheelMaterialsMap | class | audioAudioMetadata | vehicleWheelMaterials |
| audioVehicleWheelMaterialsMapItem | struct | — | name |
| audioVisualTagAppearanceMapping | class | audioAudioMetadata | mappings |
| audioVoiceContextMap | class | audioAudioMetadata | includes, contexts |
| audioVoiceContextMapItem | class | audioAudioMetadata | voTrigger, bark, grunt, answer, overridingVoContext |
| audioVoiceTagAppearanceMapping | class | audioAudioMetadata | mappings |
| audioVoiceTriggerLimitsMap | class | audioAudioMetadata | includes, triggers |
| audioVoiceTriggerLimitsMapItem | struct | — | name |
| audioVoiceTriggerPerSquadOrderMap | class | audioAudioMetadata | items |
| audioVoiceTriggerPerSquadOrderMapItem | struct | — | name |
| audioVoiceTriggerRewireMap | class | audioAudioMetadata | includes, items |
| audioVoiceTriggerRewireMapItem | struct | — | name, inputToBeActuallyPlayedName, allowReuse |

# Citations

- `codeware/scripts/Base/Imports/audioAudBulletTimeModeMap.reds`
- `codeware/scripts/Base/Imports/audioAudBulletTimeModeMapItem.reds`
- `codeware/scripts/Base/Imports/audioAudioMaterialMetadataMapItem.reds`
- `codeware/scripts/Base/Imports/audioAudioScenesMap.reds`
- `codeware/scripts/Base/Imports/audioCombatVoTriggerVariationsMap.reds`
- `codeware/scripts/Base/Imports/audioCombatVoTriggerVariationsMapItem.reds`
- `codeware/scripts/Base/Imports/audioContextualAudEventMap.reds`
- `codeware/scripts/Base/Imports/audioContextualAudEventMapItem.reds`
- `codeware/scripts/Base/Imports/audioFoleyLoopMappingMetadata.reds`
- `codeware/scripts/Base/Imports/audioFoleyNPCAppearanceMappingMetadata.reds`
- ... and 22 more source files
