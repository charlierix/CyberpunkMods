---
type: "Import"
title: "Audio Settings"
description: "Imported audio settings types (55 types)."
resource: "codeware/scripts/"
tags: "[imports, settings]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio settings types (55 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAmbientAreaGroupingSettings | struct | — | GroupCountTag, GroupAvgDistanceRtpc, MinDistance, GroupingVerticallimit |
| audioAmbientAreaSettings | class | audioAudioMetadata | MetadataParent, EmitterDecorator, Priority, EventsOnEnter, EventsOnExit |
| audioBreathingSettings | class | audioAudioMetadata | exhaustionRtpc, idleFadeOutRtpc, initialState |
| audioBulletImpactSettings | class | audioEntitySettings | lowImpactSound, medImpactSound, hiImpactSound, critImpactSound, npcImpactSound |
| audioCombatVoSettings | class | audioAudioMetadata | answerGroupName, isPlayerAlly, contexts, voTriggerVariations, generalGruntSettings |
| audioCommonEntitySettings | struct | — | onAttachEvent, stopAllSoundsOnDetach |
| audioContextualVoiceGruntSettings | struct | — | painShort |
| audioDeviceSettings | class | audioEntitySettings | deviceSettings |
| audioDeviceStateSettings | struct | — | powerRestoredSound, turnOnSound, breakingSound |
| audioDismembermentSoundSettings | class | audioAudioMetadata | headEvent, armEvent, legEvent |
| audioDoorsSettings | class | audioDeviceSettings | openEvent, openFailedEvent, closeEvent, lockEvent, unlockEvent |
| audioDroneGlobalSettings | class | audioAudioMetadata | speedRtpc, thrustRtpc |
| audioDynamicReverbSettings | class | audioAudioMetadata | reverbType, crossover1, crossover2, maxDistance, smallReverb |
| audioElevatorSettings | class | audioEntitySettings | musicEvents, movementEvents, callingEvent, destinationReachedEvent, panelSelectionEvent |
| audioEntityEmitterSettings | struct | — | emitterName, emitterDecorators, isObjectPerPositionEmitter |
| audioEntitySettings | class | audioAudioMetadata | commonSettings, scanningSettings, auxiliaryMetadata, emitterDecoratorMetadata, preferSoundComponentPosition |
| audioEnvelopeSettings | class | audioAudioMetadata | attackTime, releaseTime, holdTime |
| audioFlybySettings | struct | — | movementSpeed |
| audioGeneralVoiceGruntSettings | struct | — | variationsCount, agressionShort, longFall, silentDeath, grappleMovement |
| audioGenericEntitySettings | class | audioEntitySettings | — |
| audioGrenadeEntitySettings | class | audioEntitySettings | explosionSound |
| audioLocomotionWaterContextSettings | struct | — | minDistanceBetweenImpulsesSquared, impulseMinRadius |
| audioLocomotionWaterSettings | class | audioAudioMetadata | defaultLegVfx, locomotionStatesLegVfx, customActionLegVfx, minSpeedToApplyImpulses, minHeelDepthToApplyImpulses |
| audioMeleeAttackSettings | struct | — | hitEvent, criticalHitEvent |
| audioMeleeWeaponNpcSettings | class | audioMeleeWeaponSettings | — |
| audioMeleeWeaponPlayerSettings | class | audioMeleeWeaponSettings | — |
| audioMeleeWeaponSettings | class | audioAudioMetadata | quickAttackSettings, strongAttackSettings, weaponHandlingSettings |
| audioMixSettings | class | audioAudioMetadata | masterVolume, sfxVolume, musicVolume, voVolume, uiMenuVolume |
| audioNpcGunChoirSettings | class | audioAudioMetadata | voices |
| audioNpcWeaponSettings | class | audioWeaponSettings | gunChoir, tails, obstructionEnabled, occlusionEnabled, repositionEnabled |
| audioPhysicalMaterialSettings | class | audioAudioMetadata | softImpact, solidImpact, hardImpact, useFoliageSystem, enableRollingOrScraping |
| audioPhysicalObstructionSettings | class | audioAudioMetadata | initialAbsorbtion, absorptionPerMeter |
| audioPhysicalPropSettings | class | audioAudioMetadata | shockwaveSound, damagedSound, destroyedSound, materialOverrides |
| audioPlayerWeaponSettings | class | audioWeaponSettings | fireSound, preFireSound, burstFireSound, autoFireSound, autoFireStop |
| audioQuadEmitterSettings | struct | — | Enabled, Radius, Angle |
| audioReflectionEmitterSettings | class | audioAudioMetadata | reflectionEvent, fadeout, reflectionDeltaThreshold, maxConcurrentReflections, broadcastChannel |
| audioReflectionMaterialSettings | class | audioAudioMetadata | lowPass, highPass, gain |
| audioScanningSettings | struct | — | scanningStartEvent, scanningCompleteEvent |
| audioShockwaveGlobalSettings | class | audioAudioMetadata | explosionPropagationSpeed, thumpPropagationSpeed, electroshockPropagationSpeed, revealPropagationSpeed |
| audioUiControlEventsSettingsMapItem | class | audioAudioMetadata | baseEvent, customActionsDictionary |
| audioUiGenericControlSettingsMap | class | audioAudioMetadata | uiControlMatrix |
| audioUiGenericControlSettingsMapItem | class | audioAudioMetadata | uiEventToAudioEventDictionary |
| audioUiSpecificControlSettingsMap | class | audioAudioMetadata | specificControlSettingsMatrix |
| audioUiSpecificControlSettingsMapItem | class | audioAudioMetadata | uiEventSettingsMatrix |
| audioVehicleDoorsSettings | struct | — | openEvent |
| audioVehicleDoorsSettingsMetadata | struct | — | door, hood |
| audioVehiclePartSettingsMap | class | audioAudioMetadata | minAcousticsIsolationFactorValue, partSettings |
| audioVehiclePartSettingsMapItem | struct | — | name, onDetachAcousticsIsolationFactorReduction |
| audioVehicleTemperatureSettings | struct | — | rpmThreshold, cooldownTime |
| audioWeaponAmmoSettingsMap | class | audioAudioMetadata | standardFlyby, sniperFlyby, shotFlyby, railFlyby, automaticFlyby |
| audioWeaponHandlingSettings | struct | — | equipEvent, unequippedEvent |
| audioWeaponSettings | class | audioAudioMetadata | bulletType, shellCasingType, weaponHandlingSettings, singleShotInSandevistan, chargeStartSound |
| audioWeaponSettingsGroup | class | audioAudioMetadata | playerSettings, playerSilenced, npcSettings, npcSilenced |
| audioWeaponShellCasingSettings | class | audioAudioMetadata | mode, direction, firstCollisionEventName, secondCollisionEventName, initialDelay |
| audioWeaponTailSettings | class | audioAudioMetadata | interiorDefault, interiorWide, interiorCar, exteriorWide, exteriorUrbanNarrow |

# Citations

- `codeware/scripts/Base/Imports/audioAmbientAreaGroupingSettings.reds`
- `codeware/scripts/Base/Imports/audioAmbientAreaSettings.reds`
- `codeware/scripts/Base/Imports/audioBreathingSettings.reds`
- `codeware/scripts/Base/Imports/audioBulletImpactSettings.reds`
- `codeware/scripts/Base/Imports/audioCombatVoSettings.reds`
- `codeware/scripts/Base/Imports/audioCommonEntitySettings.reds`
- `codeware/scripts/Base/Imports/audioContextualVoiceGruntSettings.reds`
- `codeware/scripts/Base/Imports/audioDeviceSettings.reds`
- `codeware/scripts/Base/Imports/audioDeviceStateSettings.reds`
- `codeware/scripts/Base/Imports/audioDismembermentSoundSettings.reds`
- ... and 45 more source files
