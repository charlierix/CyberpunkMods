---
type: "Import"
title: "Audio Types/Melee"
description: "Imported audio types/melee types (10 types)."
resource: "codeware/scripts/"
tags: "[imports, melee]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported audio types/melee types (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioMeleeHitPerMaterialType | enum | — | Light, Light_Hard, Light_Soft, Light_Solid, Light_Flesh |
| audioMeleeHitSoundMetadata | class | audioAudioMetadata | meleeSoundsByMaterial |
| audioMeleeHitType | enum | — | Light, Normal, Heavy, Slash, Cut |
| audioMeleeHitTypeMeleeSoundDictionary | class | audioInlinedAudioMetadata | entries, entryType |
| audioMeleeHitTypeMeleeSoundDictionaryItem | class | audioInlinedAudioMetadata | key, value |
| audioMeleeMaterialType | enum | — | Hard, Soft, Solid, Flesh, Robot |
| audioMeleeRigTypeMeleeWeaponConfigurationMap | struct | — | mapItems |
| audioMeleeRigTypeMeleeWeaponConfigurationMapItem | struct | — | name |
| audioMeleeSound | struct | — | events |
| audioMeleeWeaponVariations | class | audioAudioMetadata | playerWeaponConfigurationName, NPCWeaponConfigurationName |

# Citations

- `codeware/scripts/Base/Imports/audioMeleeHitPerMaterialType.reds`
- `codeware/scripts/Base/Imports/audioMeleeHitSoundMetadata.reds`
- `codeware/scripts/Base/Imports/audioMeleeHitType.reds`
- `codeware/scripts/Base/Imports/audioMeleeHitTypeMeleeSoundDictionary.reds`
- `codeware/scripts/Base/Imports/audioMeleeHitTypeMeleeSoundDictionaryItem.reds`
- `codeware/scripts/Base/Imports/audioMeleeMaterialType.reds`
- `codeware/scripts/Base/Imports/audioMeleeRigTypeMeleeWeaponConfigurationMap.reds`
- `codeware/scripts/Base/Imports/audioMeleeRigTypeMeleeWeaponConfigurationMapItem.reds`
- `codeware/scripts/Base/Imports/audioMeleeSound.reds`
- `codeware/scripts/Base/Imports/audioMeleeWeaponVariations.reds`
