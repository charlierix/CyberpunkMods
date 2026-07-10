---
type: "Import"
title: "Audio Types/Advert"
description: "Imported audio types/advert types (3 types)."
resource: "codeware/scripts/"
tags: "[imports, advert]"
timestamp: 2026-07-01T18:09:05Z
---

# Overview

Imported audio types/advert types (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAdvertIndoorFilter | enum | — | Always, OnlyIndoor, OnlyOutdoor |
| audioAdvertMetadata | class | audioEmitterMetadata | advertSoundNames, minSilenceTime, maxSilenceTime, minDistance, filter |
| audioAdvertSoundMetadata | class | audioAudioMetadata | audioEvent1, audioEvent2, audioEvent3, audioEvent4, useCustomDelays |

# Citations

- `codeware/scripts/Base/Imports/audioAdvertIndoorFilter.reds`
- `codeware/scripts/Base/Imports/audioAdvertMetadata.reds`
- `codeware/scripts/Base/Imports/audioAdvertSoundMetadata.reds`
