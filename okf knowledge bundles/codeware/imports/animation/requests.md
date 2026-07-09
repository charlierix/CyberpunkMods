---
type: "Import"
title: "Animation Requests"
description: "Imported animation requests types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, requests]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported animation requests types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimNode_AddIkRequest | class | animAnimNode_OnePoseInput | ikChain, targetBone, positionOffset, rotationOffset, poleVector |
| animAnimNode_AddSnapToTerrainIkRequest | class | animAnimNode_OnePoseInput | animDeltaZ, leftFootRequest, rightFootRequest, hipsRequest |
| animAnimNode_ReadIkRequest | class | animAnimNode_OnePoseInput | ikChain, outTransform |
| animHipsIkRequest | struct | — | leftLegIkChain, hipsTransformIndex, rightFootTransformIndex |
| animLookAtRequestForPart | struct | — | bodyPart, attachLeftHandToRightHand |
| animSnapToTerrainIkRequest | struct | — | ikChain, poleVectorRefTransformIndex |

# Citations

- `codeware/scripts/Base/Imports/animAnimNode_AddIkRequest.reds`
- `codeware/scripts/Base/Imports/animAnimNode_AddSnapToTerrainIkRequest.reds`
- `codeware/scripts/Base/Imports/animAnimNode_ReadIkRequest.reds`
- `codeware/scripts/Base/Imports/animHipsIkRequest.reds`
- `codeware/scripts/Base/Imports/animLookAtRequestForPart.reds`
- `codeware/scripts/Base/Imports/animSnapToTerrainIkRequest.reds`
