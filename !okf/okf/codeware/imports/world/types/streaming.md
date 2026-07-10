---
type: "Import"
title: "World Types/Streaming"
description: "Imported world types/streaming types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, streaming]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/streaming types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldStreamingBlock | class | CResource | descriptors, index |
| worldStreamingBlockIndex | struct | — | rldGridCell |
| worldStreamingSectorCategory | enum | — | Exterior, Interior, Quest, Navigation, AlwaysLoaded |
| worldStreamingSectorDescriptor | struct | — | data, streamingBox, numNodeRanges, blockIndex, category |
| worldStreamingSectorInplaceContent | class | CResource | inplaceResources |
| worldStreamingSectorVariant | struct | — | nodeRef, parentVariantID, rangeIndex |
| worldStreamingTestCheckpointType | enum | — | BeginMove, EndMove |
| worldStreamingTestSummary | class | ISerializable | gameDefinition, noCrowds, testDurationSeconds, initialBytesRead, bytesReadDuringTest |
| worldStreamingWorld | class | CResource | version, blockRefs, environmentDefinition, worldBoundingBox, persistentStateData |

# Citations

- `codeware/scripts/Base/Imports/worldStreamingBlock.reds`
- `codeware/scripts/Base/Imports/worldStreamingBlockIndex.reds`
- `codeware/scripts/Base/Imports/worldStreamingSectorCategory.reds`
- `codeware/scripts/Base/Imports/worldStreamingSectorDescriptor.reds`
- `codeware/scripts/Base/Imports/worldStreamingSectorInplaceContent.reds`
- `codeware/scripts/Base/Imports/worldStreamingSectorVariant.reds`
- `codeware/scripts/Base/Imports/worldStreamingTestCheckpointType.reds`
- `codeware/scripts/Base/Imports/worldStreamingTestSummary.reds`
- `codeware/scripts/Base/Imports/worldStreamingWorld.reds`
