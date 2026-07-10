---
type: "Import"
title: "Audio Types/Foley"
description: "Imported audio types/foley types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, foley]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported audio types/foley types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioFoleyActionType | enum | — | FastHeavy, FastMedium, FastLight, NormalHeavy, NormalMedium |
| audioFoleyAppearanceName | class | audioAudioMetadata | void |
| audioFoleyGlobalMetadata | class | audioAudioMetadata | fadeoutTime, fadeoutRtpc |
| audioFoleyItemPriority | enum | — | P0, P1, P2, P3, P4 |
| audioFoleyItemType | enum | — | Jacket, Top, Bottom, Jewelry |
| audioFoleyLoopMetadata | struct | — | startEvent |
| audioFoleyNPCMetadata | class | audioAudioMetadata | fastHeavy, fastMedium, fastLight, normalHeavy, normalMedium |

# Citations

- `codeware/scripts/Base/Imports/audioFoleyActionType.reds`
- `codeware/scripts/Base/Imports/audioFoleyAppearanceName.reds`
- `codeware/scripts/Base/Imports/audioFoleyGlobalMetadata.reds`
- `codeware/scripts/Base/Imports/audioFoleyItemPriority.reds`
- `codeware/scripts/Base/Imports/audioFoleyItemType.reds`
- `codeware/scripts/Base/Imports/audioFoleyLoopMetadata.reds`
- `codeware/scripts/Base/Imports/audioFoleyNPCMetadata.reds`
