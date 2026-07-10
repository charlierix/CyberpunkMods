---
type: "Import"
title: "Mesh Types"
description: "Imported game engine types in the mesh domain (39 types)."
resource: "codeware/scripts/"
tags: "[imports, mesh]"
timestamp: 2026-07-01T18:09:18Z
---

# Overview

Imported game engine types in the mesh domain (39 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| MergedMesh | class | CMesh | — |
| meshChunkFlags | struct | — | renderInScene, isTwoSided, isConsoleLOD0 |
| meshChunkIndicesOffset | struct | — | start, boneIndex |
| meshChunkMaterials | struct | — | materialNames |
| meshChunkOffset | struct | — | chunkIndex, count |
| meshCookedClothMeshTopologyData | struct | — | gfxIndexToTriangles, gfxBarycentrics, phxLodSwitchData, gfxNumIndicesToTriangles, gfxNumBarycentrics |
| meshDestructionBond | struct | — | bondIndex |
| meshGfxClothChunkData | struct | — | simulation |
| meshImportedSnapTags | struct | — | includeTags |
| meshLocalMaterialHeader | struct | — | offset |
| meshMeshImportedSnapPoint | class | ISerializable | localToCloud, range, rotationAlignmentSteps, snapTags |
| meshMeshMaterialBuffer | struct | — | rawDataHeaders |
| meshMeshParamBakedDestructionData | class | meshMeshParameter | regionData |
| meshMeshParamBendedRoad | class | meshMeshParameter | occInds, occVerts, occSkinWeights, occSkinInds, collInds |
| meshMeshParamCloth | class | meshMeshParameter | lodChunkIndices, chunks, drivers, capsules |
| meshMeshParamCloth_Graphical | class | meshMeshParameter | lodChunkIndices, chunks, latchers |
| meshMeshParamCompiledPhysics | class | meshMeshParameter | collection |
| meshMeshParamDeformableShapesData | class | meshMeshParameter | ownerIndex, startingPose, finalPose |
| meshMeshParamDestructionBonds | class | meshMeshParameter | bonds |
| meshMeshParamDestructionBoneChunkMapping | class | meshMeshParameter | boneChunkMasks |
| meshMeshParamDestructionChunkIndicesOffsets | class | meshMeshParameter | offsets, chunkOffsets |
| meshMeshParamDestructionStepData | class | meshMeshParameter | offsets, isInstantRemovable |
| meshMeshParamGarmentSupport | class | meshMeshParameter | chunkCapVertices, customMorph |
| meshMeshParamGpuBuffer | class | meshMeshParameter | stride |
| meshMeshParamImportedSnapPoint | class | meshMeshParameter | snapFeatureData |
| meshMeshParamOccluderData | class | meshMeshParameter | occluderResource, defaultOccluderType, autoHideDistanceScale |
| meshMeshParamPhysics | class | meshMeshParameter | physicsData |
| meshMeshParamShadowMeshCreationData | class | meshMeshParameter | geometries, bonesPerGeometry |
| meshMeshParamSpeedTreeWind | class | meshMeshParameter | — |
| meshMeshParamTerrain | class | meshMeshParameter | chunkBoundingBoxes |
| meshMeshParamTopologyData | class | meshMeshParameter | offsets, sizes |
| meshMeshParamTopologyMetadata | class | meshMeshParameter | offsets, sizes |
| meshMeshParamUICollisionData | class | meshMeshParameter | uvs, trianglesIndices, vertices |
| meshMeshParamWaterPatchData | class | meshMeshParameter | animLoop, animLength, nodes |
| meshMeshParamWorkspotOffsets | class | meshMeshParameter | names, offsets |
| meshMeshParameter | class | ISerializable | — |
| meshPhxClothChunkData | struct | — | — |
| meshRawClothData | struct | — | state |
| meshRegionData | struct | — | chunkDataIntact, chunkMaskIntact, isStaticRemains |

# Citations

- `codeware/scripts/Base/Imports/MergedMesh.reds`
- `codeware/scripts/Base/Imports/meshChunkFlags.reds`
- `codeware/scripts/Base/Imports/meshChunkIndicesOffset.reds`
- `codeware/scripts/Base/Imports/meshChunkMaterials.reds`
- `codeware/scripts/Base/Imports/meshChunkOffset.reds`
- `codeware/scripts/Base/Imports/meshCookedClothMeshTopologyData.reds`
- `codeware/scripts/Base/Imports/meshDestructionBond.reds`
- `codeware/scripts/Base/Imports/meshGfxClothChunkData.reds`
- `codeware/scripts/Base/Imports/meshImportedSnapTags.reds`
- `codeware/scripts/Base/Imports/meshLocalMaterialHeader.reds`
- ... and 29 more source files
