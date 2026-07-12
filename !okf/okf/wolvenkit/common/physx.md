---
type: "System"
title: "PhysX Collision Data"
description: "PhysX collision data structures (BV4Tree, BV4TriangleMesh, BigConvexData, ConvexHullData, ConvexMesh) — 8 files."
resource: "WolvenKit.Common/PhysX/BV4Tree.cs"
tags: [common, physx, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

PhysX collision data structures (BV4Tree, BV4TriangleMesh, BigConvexData, ConvexHullData, ConvexMesh) — 8 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **8 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| BV4Tree.cs | 56 | class BV4Tree |
| BV4TriangleMesh.cs | 106 | class BV4TriangleMesh, enum InternalMeshSerialFlag |
| BigConvexData.cs | 88 | class BigConvexData |
| ConvexHullData.cs | 68 | class ConvexHullData |
| ConvexMesh.cs | 58 | class ConvexMesh |
| PhysXHelper.cs | 32 | class PhysXHeader, class PhysXHelper |
| PhysXMesh.cs | 6 | class PhysXMesh |
| Structs.cs | 70 | struct Bounds3, struct Plane, struct HullPolygonData, struct InternalObjectsData, struct Valency |

## Member Types

All **8** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | BV4Tree.cs |
| 2 | BV4TriangleMesh.cs |
| 3 | BigConvexData.cs |
| 4 | ConvexHullData.cs |
| 5 | ConvexMesh.cs |
| 6 | PhysXHelper.cs |
| 7 | PhysXMesh.cs |
| 8 | Structs.cs |

## Architecture

The analyzed files contain approximately **484 lines** of code across **8 files** (of 8 total).

### Notable Types

- class BV4Tree
- class BV4TriangleMesh
- class BigConvexData
- class ConvexHullData
- class ConvexMesh
- class PhysXHeader
- class PhysXHelper
- class PhysXMesh
- enum InternalMeshSerialFlag
- struct Bounds3
- struct DataStruct
- struct HullPolygonData
- struct InternalObjectsData
- struct LocalBounds
- struct PackedQuantizedAABB
- struct Plane
- struct QuantizedAABB
- struct Valency

## Dependencies

No specific namespace dependencies detected.

## Citations

[1] Source files under `WolvenKit.Common/PhysX/` in the WolvenKit repository
