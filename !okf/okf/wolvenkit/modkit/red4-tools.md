---
type: "System"
title: "Modkit RED4 Tools"
description: "RED4 modding tools for specific asset types (animation, common, ML, collision, mesh, morph target, etc.) — 9 files."
resource: "WolvenKit.Modkit/RED4/Tools/Animation/AnimRootMotion.cs"
tags: [modkit, red4, tools, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

RED4 modding tools for specific asset types (animation, common, ML, collision, mesh, morph target, etc.) — 9 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AnimRootMotion.cs | 242 | class ROOT_MOTION, enum RootMotionType |
| AnimSIMD.cs | 201 | class SIMD |
| AnimSIMDEncoder.cs | 215 | class SIMDEncoder |
| AnimSpline.cs | 216 | class CompressedBuffer |
| Shared.cs | 210 | class Const, class Fun, class Gltf, struct TWVec3, struct TGVec3 |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AnimRootMotion.cs |
| 2 | AnimSIMD.cs |
| 3 | AnimSIMDEncoder.cs |
| 4 | AnimSpline.cs |
| 5 | Shared.cs |

## Architecture

The analyzed files contain approximately **1084 lines** of code across **5 files** (of 5 total).

### Notable Types

- class CompressedBuffer
- class Const
- class Fun
- class Gltf
- class ROOT_MOTION
- class SIMD
- class SIMDEncoder
- enum RootMotionType
- record struct
- struct RGQuat
- struct RWQuat
- struct SGVec3
- struct SWVec3
- struct TGVec3
- struct TWVec3

## Dependencies

- using ICSharpCode.SharpZipLib
- using JointsRotationsAtTimes = System.Collections.Generic.Dictionary<ushort, System.Collections.Generic.Dictionary<float, System.Numerics.Quaternion>>
- using JointsScalesAtTimes = System.Collections.Generic.Dictionary<ushort, System.Collections.Generic.Dictionary<float, System.Numerics.Vector3>>
- using JointsTranslationsAtTimes = System.Collections.Generic.Dictionary<ushort, System.Collections.Generic.Dictionary<float, System.Numerics.Vector3>>
- using Quat = System.Numerics.Quaternion
- using RotationsAtTimes = System.Collections.Generic.Dictionary<float, System.Numerics.Quaternion>
- using ScalesAtTimes = System.Collections.Generic.Dictionary<float, System.Numerics.Vector3>
- using SharpGLTF.IO
- using SharpGLTF.Schema2
- using System
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Text.Json
- using TranslationsAtTimes = System.Collections.Generic.Dictionary<float, System.Numerics.Vector3>
- using Vec3 = System.Numerics.Vector3
- using Vec4 = System.Numerics.Vector4
- using WkVector4 = WolvenKit.RED4.Types.Vector4
- using WolvenKit.Core.Extensions
- using WolvenKit.Core.Interfaces

## Citations

[1] Source files under `WolvenKit.Modkit/RED4/Tools/Animation/` in the WolvenKit repository
