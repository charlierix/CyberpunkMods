---
type: "Import"
title: "World Types/Static"
description: "Imported world types/static types (14 types)."
resource: "codeware/scripts/"
tags: "[imports, static]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/static types (14 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldStaticCollisionShapeCategories_CollisionNode | struct | — | arr |
| worldStaticDecalNode | class | worldNode | material, autoHideDistance, verticalFlip, horizontalFlip, alpha |
| worldStaticFogVolumeNode | class | worldNode | priority, absolute, applyHeightFalloff, densityFalloff, blendFalloff |
| worldStaticGpsLocationEntranceMarkerNode | class | worldNode | — |
| worldStaticLaneCollisions | struct | — | lane, deadEndStart |
| worldStaticLightNode | class | worldNode | type, color, radius, unit, intensity |
| worldStaticMarkerNode | class | worldSocketNode | isEnabled, tags, data |
| worldStaticMeshNode | class | worldMeshNode | — |
| worldStaticOccluderMeshNode | class | worldNode | occluderType, color, autohideDistanceScale, mesh |
| worldStaticParticleNode | class | worldNode | emissionRate, particleSystem, forcedAutoHideDistance, forcedAutoHideRange |
| worldStaticQuestMarkerNode | class | worldNode | questType, questLabel, mapFilteringTag, questMarkerHeight |
| worldStaticSoundEmitterNode | class | worldNode | radius, audioName, Settings, usePhysicsObstruction, occlusionEnabled |
| worldStaticStickerNode | class | worldNode | labels, showBackground, textColor, backgroundColor, sprites |
| worldStaticVectorFieldNode | class | worldNode | direction, autoHideDistance |

# Citations

- `codeware/scripts/Base/Imports/worldStaticCollisionShapeCategories_CollisionNode.reds`
- `codeware/scripts/Base/Imports/worldStaticDecalNode.reds`
- `codeware/scripts/Base/Imports/worldStaticFogVolumeNode.reds`
- `codeware/scripts/Base/Imports/worldStaticGpsLocationEntranceMarkerNode.reds`
- `codeware/scripts/Base/Imports/worldStaticLaneCollisions.reds`
- `codeware/scripts/Base/Imports/worldStaticLightNode.reds`
- `codeware/scripts/Base/Imports/worldStaticMarkerNode.reds`
- `codeware/scripts/Base/Imports/worldStaticMeshNode.reds`
- `codeware/scripts/Base/Imports/worldStaticOccluderMeshNode.reds`
- `codeware/scripts/Base/Imports/worldStaticParticleNode.reds`
- ... and 4 more source files
