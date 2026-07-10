---
type: "Import"
title: "Audio Types/Radio"
description: "Imported audio types/radio types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, radio]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported audio types/radio types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioRadioBlip | struct | — | blipEventName |
| audioRadioSoundType | enum | — | Song, AnnouncementScene |
| audioRadioSpeakerType | enum | — | Stanley, MaximumMike, PoliceDispatch, Kurtz, Ash |
| audioRadioStationJingleMetadata | struct | — | introJingleEvent, middleJingleEvent, outroDuration |
| audioRadioStationMetadata | class | audioAudioMetadata | tracks, blips, speaker |
| audioRadioStationSongEventStruct | struct | — | radioStationName |
| audioRadioTrack | struct | — | trackEventName, primaryLocKey |
| audioRadioTracksMetadata | class | audioAudioMetadata | radioTracks |

# Citations

- `codeware/scripts/Base/Imports/audioRadioBlip.reds`
- `codeware/scripts/Base/Imports/audioRadioSoundType.reds`
- `codeware/scripts/Base/Imports/audioRadioSpeakerType.reds`
- `codeware/scripts/Base/Imports/audioRadioStationJingleMetadata.reds`
- `codeware/scripts/Base/Imports/audioRadioStationMetadata.reds`
- `codeware/scripts/Base/Imports/audioRadioStationSongEventStruct.reds`
- `codeware/scripts/Base/Imports/audioRadioTrack.reds`
- `codeware/scripts/Base/Imports/audioRadioTracksMetadata.reds`
