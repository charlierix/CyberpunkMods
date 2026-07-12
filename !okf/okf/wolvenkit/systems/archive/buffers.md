---
type: "System"
title: "RED4 Archive Buffer Types"
description: "Buffer type definitions for archive data (CR2WList, RedPackage, Collision, Foliage, Tiles, GeometryCache, etc.) — 20 files."
resource: "WolvenKit.RED4/Archive/Buffer/AnimFacialSetupBakedDataBuffer.cs"
tags: [systems, archive, buffers, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Buffer type definitions for archive data (CR2WList, RedPackage, Collision, Foliage, Tiles, GeometryCache, etc.) — 20 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **20 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AnimFacialSetupBakedDataBuffer.cs | 91 | class AnimFacialSetupBakedDataBuffer, class FacialSetup_BakedPartData, class FacialTrackMapping, class FacialPoseLimit, class FacialInfluencedPose |
| AnimFacialSetupCorrectivePosesDataBuffer.cs | 12 | class AnimFacialSetupCorrectivePosesDataBuffer |
| AnimFacialSetupMainPosesDataBuffer.cs | 39 | class AnimFacialSetupMainPosesDataBuffer, class AnimFacialSetupPosesPartData, class FacialSetup_PoseTrackInfo, class FacialTransform |
| CGIDataBuffer.cs | 158 | class CGIDataBuffer, class CGIBrck, class CGISurf, class CGIUkBrckItem, class CGIUkColorItem |
| CR2WList.cs | 42 | class CR2WList |
| CR2WWrapper.cs | 10 | class CR2WWrapper |
| CollisionBuffer.cs | 45 | class CollisionBuffer, class CollisionActor, class CollisionShape, class CollisionShapeSimple, class CollisionShapeMesh |
| CookedInstanceTransformsBuffer.cs | 15 | class CookedInstanceTransformsBuffer |
| FoliageBuffer.cs | 24 | class FoliageBuffer, class Foliage_Class1, class Foliage_BucketClass |
| GeometryCacheBuffer.cs | 129 | class GeometryCacheBuffer, class GeometryCacheEntry, class CVXMCacheEntry, class CVXMCacheFaceData, class MeshCacheEntry |
| ModifiersBuffer.cs | 11 | class ModifiersBuffer |
| RazerChromaAnimationBuffer.cs | 59 | class RazerChromaAnimationBuffer, class FChromaSDKColorFrame, class FChromaSDKColorFrame1D, class FChromaSDKColorFrame2D, class FChromaSDKColors |
| RedPackage.cs | 56 | class RedPackageSettings, class RedPackage, enum RedPackageType |
| RedPackageStructs.cs | 133 | struct RedPackageHeader, struct RedPackageImportHeader, struct RedPackageNameHeader, struct RedPackageChunkHeader, struct RedPackageFieldHeader |
| SavedModifierGroupStatTypesBuffer.cs | 17 | class SavedModifierGroupStatTypesBuffer, class SavedModifierGroupStatTypesBuffer_Entry |
| TilesBuffer.cs | 127 | class TilesBuffer, class TileConnectedFace, class TileFaceInfo, class TilesBufferUk2, class TilesBufferUk3 |
| TilesStruct.cs | 53 | struct TilesBufferHeader |
| WorldTransformsBuffer.cs | 10 | class WorldTransformsBuffer |
| worldNodeData.cs | 72 | class worldNodeData |
| worldNodeDataBuffer.cs | 20 | class worldNodeDataBuffer, class RedDictionary |

## Member Types

All **20** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AnimFacialSetupBakedDataBuffer.cs |
| 2 | AnimFacialSetupCorrectivePosesDataBuffer.cs |
| 3 | AnimFacialSetupMainPosesDataBuffer.cs |
| 4 | CGIDataBuffer.cs |
| 5 | CR2WList.cs |
| 6 | CR2WWrapper.cs |
| 7 | CollisionBuffer.cs |
| 8 | CookedInstanceTransformsBuffer.cs |
| 9 | FoliageBuffer.cs |
| 10 | GeometryCacheBuffer.cs |
| 11 | ModifiersBuffer.cs |
| 12 | RazerChromaAnimationBuffer.cs |
| 13 | RedPackage.cs |
| 14 | RedPackageStructs.cs |
| 15 | SavedModifierGroupStatTypesBuffer.cs |
| 16 | TilesBuffer.cs |
| 17 | TilesStruct.cs |
| 18 | WorldTransformsBuffer.cs |
| 19 | worldNodeData.cs |
| 20 | worldNodeDataBuffer.cs |

## Architecture

The analyzed files contain approximately **1123 lines** of code across **20 files** (of 20 total).

### Notable Types

- class AnimFacialSetupBakedDataBuffer
- class AnimFacialSetupCorrectivePosesDataBuffer
- class AnimFacialSetupMainPosesDataBuffer
- class AnimFacialSetupPosesPartData
- class CGIBrck
- class CGIDataBuffer
- class CGIFact
- class CGIProb
- class CGISurf
- class CGITetr
- class CGIUkBrckItem
- class CGIUkColorItem
- class CGIVolt
- class CR2WList
- class CR2WWrapper
- class CVXMCacheEntry
- class CVXMCacheFaceData
- class CollisionActor
- class CollisionBuffer
- class CollisionShape
- class CollisionShapeMesh
- class CollisionShapeSimple
- class CookedInstanceTransformsBuffer
- class FChromaSDKColorFrame
- class FChromaSDKColorFrame1D
- class FChromaSDKColorFrame2D
- class FChromaSDKColors
- class FacialCorrectiveInfluencedPose
- class FacialCorrectiveInfo
- class FacialInfluencedPose
- class FacialMainPoseInfo
- class FacialParts
- class FacialPoseLimit
- class FacialPoseSides
- class FacialSetup_BakedPartData
- class FacialSetup_PoseTrackInfo
- class FacialTrackMapping
- class FacialTransform
- class FoliageBuffer
- class Foliage_BucketClass
- class Foliage_Class1
- class GeometryCacheBuffer
- class GeometryCacheEntry
- class MeshCacheEntry
- class ModifiersBuffer
- class RazerChromaAnimationBuffer
- class RedDictionary
- class RedPackage
- class RedPackageSettings
- class SavedModifierGroupStatTypesBuffer

## Dependencies

- using WolvenKit.RED4.Archive.CR2W
- using WolvenKit.RED4.Types
- using static WolvenKit.RED4.Types.Enums

## Citations

[1] Source files under `WolvenKit.RED4/Archive/Buffer/` in the WolvenKit repository
