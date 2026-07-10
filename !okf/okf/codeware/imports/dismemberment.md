---
type: "Import"
title: "Dismemberment Types"
description: "Imported game engine types in the dismemberment domain (18 types)."
resource: "codeware/scripts/"
tags: "[imports, dismemberment]"
timestamp: 2026-07-01T18:09:07Z
---

# Overview

Imported game engine types in the dismemberment domain (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| DismemberedBodyPartEvent | class | Event | bones |
| entdismembermentAppearanceMatch | struct | — | Character, SetByUser |
| entdismembermentBodyMaterialConfig | struct | — | FleshBodyMask, CyberBodyMask |
| entdismembermentCullObject | struct | — | Plane, CapsulePointA, CapsuleRadius, NearestAnimIndex |
| entdismembermentDangleInfo | struct | — | DangleSegmentLenght, DangleBendStiffness, DangleCollisionSphereRadius |
| entdismembermentDebris | class | CResource | items |
| entdismembermentDebrisResourceItem | struct | — | rig, mesh |
| entdismembermentEffectResource | class | ISerializable | Name, AppearanceNames, BodyPartMask, Offset, Placement |
| entdismembermentMeshInfo | struct | — | Mesh, MeshAppearance, ShouldReceiveDecal, WoundType, CullMesh |
| entdismembermentPhysicsInfo | struct | — | DensityScale |
| entdismembermentResourceSetE | enum | — | NONE, BARE, BARE1, BARE2, BARE3 |
| entdismembermentSimulationTypeE | enum | — | NONE, DANGLE |
| entdismembermentWoundConfig | class | ISerializable | WoundName, ResourceSet |
| entdismembermentWoundConfigContainer | class | ISerializable | AppearanceName, Wounds |
| entdismembermentWoundDecal | struct | — | OffsetA, Scale, FadePower, Material |
| entdismembermentWoundMeshes | struct | — | ResourceSet, FillMeshes |
| entdismembermentWoundResource | class | ISerializable | Name, WoundType, BodyPart, CullObject, GarmentMorphStrength |
| entdismembermentWoundsConfigSet | struct | — | Configs |

# Citations

- `codeware/scripts/Base/Imports/DismemberedBodyPartEvent.reds`
- `codeware/scripts/Base/Imports/entdismembermentAppearanceMatch.reds`
- `codeware/scripts/Base/Imports/entdismembermentBodyMaterialConfig.reds`
- `codeware/scripts/Base/Imports/entdismembermentCullObject.reds`
- `codeware/scripts/Base/Imports/entdismembermentDangleInfo.reds`
- `codeware/scripts/Base/Imports/entdismembermentDebris.reds`
- `codeware/scripts/Base/Imports/entdismembermentDebrisResourceItem.reds`
- `codeware/scripts/Base/Imports/entdismembermentEffectResource.reds`
- `codeware/scripts/Base/Imports/entdismembermentMeshInfo.reds`
- `codeware/scripts/Base/Imports/entdismembermentPhysicsInfo.reds`
- ... and 8 more source files
