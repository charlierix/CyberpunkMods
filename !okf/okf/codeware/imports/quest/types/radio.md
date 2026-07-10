---
type: "Import"
title: "Quest Types/Radio"
description: "Imported quest types/radio types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, radio]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/radio types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questRadioAnnouncementNodeType | class | questIAudioNodeType | radioStationEvents |
| questRadioSongNodeType | class | questIAudioNodeType | radioStationEvents |
| questRadioStationAnnouncementEventStruct | struct | — | announcementScene, sceneInput, radioStationName, speaker |
| questRadioTrack_ConditionType | class | questISystemConditionType | radioTrack, inverted |
| questRadio_ConditionType | class | questISystemConditionType | inverted, limitToSpecifiedSpeakersStations, speakerType |

# Citations

- `codeware/scripts/Base/Imports/questRadioAnnouncementNodeType.reds`
- `codeware/scripts/Base/Imports/questRadioSongNodeType.reds`
- `codeware/scripts/Base/Imports/questRadioStationAnnouncementEventStruct.reds`
- `codeware/scripts/Base/Imports/questRadioTrack_ConditionType.reds`
- `codeware/scripts/Base/Imports/questRadio_ConditionType.reds`
