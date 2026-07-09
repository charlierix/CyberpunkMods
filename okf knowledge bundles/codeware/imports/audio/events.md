---
type: "Import"
title: "Audio Events"
description: "Imported audio events types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio events types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| MusicEvent | class | Event | eventName |
| VoicePlayEvent | class | Event | eventName, gruntType, gruntInterruptMode, isV |
| VoicePlayedEvent | class | Event | eventName, gruntType, isV |
| audioMeleeEvent | struct | — | event |
| gameaudioeventsEmitterEvent | class | Event | emitterName |
| gameaudioeventsHitEvent | class | Event | attackType, hitPosition, physicsMaterial, damage, isTargetPuppet |

# Citations

- `codeware/scripts/Base/Imports/MusicEvent.reds`
- `codeware/scripts/Base/Imports/VoicePlayEvent.reds`
- `codeware/scripts/Base/Imports/VoicePlayedEvent.reds`
- `codeware/scripts/Base/Imports/audioMeleeEvent.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsEmitterEvent.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsHitEvent.reds`
