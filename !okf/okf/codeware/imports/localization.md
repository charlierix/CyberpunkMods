---
type: "Import"
title: "Localization Types"
description: "Imported game engine types in the localization domain (25 types)."
resource: "codeware/scripts/"
tags: "[imports, localization]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the localization domain (25 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| LanguageSpecificImagData | struct | — | languageID, partNameForLanguage |
| LanguageSpecificImageController | class | inkLogicController | languages, fallbackTextureAtlas, fallbackPartName |
| LanguageSpecificVideoController | class | inkLogicController | isLooped, specificVideoForLanguage, languages, fallbackVideo |
| locHolocallActorMode | enum | — | Default, ActorUsesHolocall, ActorDoesntUseHolocall |
| locVoLanguageDataEntry | struct | — | languageCode, lengthMapReport, voMapChunks |
| locVoLanguageDataMap | class | ISerializable | entries |
| locVoLengthEntry | struct | — | stringId, maleLength |
| locVoLineEntry | struct | — | stringId, maleResPath |
| locVoResource | class | CResource | — |
| locVoiceTag | struct | — | voiceTag, id |
| locVoiceTagGender | enum | — | Undefined, Male, Female |
| locVoiceTagListResource | class | CResource | voiceTags |
| locVoiceoverContext | enum | — | Vo_Context_Quest, Vo_Context_Community, Vo_Context_Combat, Vo_Context_Minor_Activity, Default_Vo_Context |
| locVoiceoverExpression | enum | — | Vo_Expression_Spoken, Vo_Expression_Phone, Vo_Expression_InnerDialog, Vo_Expression_Loudspeaker_Room, Vo_Expression_Loudspeaker_Street |
| locVoiceoverLengthMap | class | ISerializable | entries |
| locVoiceoverMap | class | ISerializable | entries |
| localizationPersistenceCLNumberDateContainer | class | ISerializable | clNumber, clTimestamp, clGeneratedIds |
| localizationPersistenceLocDataMap | class | ISerializable | entries |
| localizationPersistenceLocDataMapEntry | struct | — | langCode, subtitlePath |
| localizationPersistenceOnScreenEntries | class | ISerializable | entries |
| localizationPersistenceOnScreenEntry | struct | — | primaryKey, femaleVariant |
| localizationPersistenceSubtitleEntries | class | ISerializable | entries |
| localizationPersistenceSubtitleEntry | struct | — | stringId, maleVariant |
| localizationPersistenceSubtitleMap | class | ISerializable | entries |
| localizationPersistenceSubtitleMapEntry | struct | — | subtitleGroup |

# Citations

- `codeware/scripts/Base/Imports/LanguageSpecificImagData.reds`
- `codeware/scripts/Base/Imports/LanguageSpecificImageController.reds`
- `codeware/scripts/Base/Imports/LanguageSpecificVideoController.reds`
- `codeware/scripts/Base/Imports/locHolocallActorMode.reds`
- `codeware/scripts/Base/Imports/locVoLanguageDataEntry.reds`
- `codeware/scripts/Base/Imports/locVoLanguageDataMap.reds`
- `codeware/scripts/Base/Imports/locVoLengthEntry.reds`
- `codeware/scripts/Base/Imports/locVoLineEntry.reds`
- `codeware/scripts/Base/Imports/locVoResource.reds`
- `codeware/scripts/Base/Imports/locVoiceTag.reds`
- ... and 15 more source files
