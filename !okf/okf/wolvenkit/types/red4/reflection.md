---
type: "System"
title: "RED4 Reflection System"
description: "Reflection system for runtime type info, property info, and type management — 8 files."
resource: "WolvenKit.RED4/Types/Reflection/ExtendedEnumInfo.cs"
tags: [types, red4, reflection, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Reflection system for runtime type info, property info, and type management — 8 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **8 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ExtendedEnumInfo.cs | 86 | class ExtendedEnumInfo |
| ExtendedPropertyInfo.cs | 155 | class ExtendedPropertyInfo |
| ExtendedTypeInfo.cs | 186 | class ExtendedTypeInfo |
| Flags.cs | 76 | class Flags |
| ICollectionDebugView.cs | 25 | class ICollectionDebugView |
| RedReflection.cs | 338 | class RedReflection |
| RedTypeInfo.cs | 252 | class Mixed, class RedTypeInfo, class SimpleRedTypeInfo, class FundamentalRedTypeInfo, class SpecialRedTypeInfo |
| RedTypeManager.cs | 181 | class RedTypeManager |

## Member Types

All **8** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ExtendedEnumInfo.cs |
| 2 | ExtendedPropertyInfo.cs |
| 3 | ExtendedTypeInfo.cs |
| 4 | Flags.cs |
| 5 | ICollectionDebugView.cs |
| 6 | RedReflection.cs |
| 7 | RedTypeInfo.cs |
| 8 | RedTypeManager.cs |

## Architecture

The analyzed files contain approximately **1299 lines** of code across **8 files** (of 8 total).

### Notable Types

- class ExtendedEnumInfo
- class ExtendedPropertyInfo
- class ExtendedTypeInfo
- class Flags
- class FundamentalRedTypeInfo
- class ICollectionDebugView
- class Mixed
- class RedReflection
- class RedTypeInfo
- class RedTypeManager
- class SimpleRedTypeInfo
- class SpecialRedTypeInfo
- enum BaseRedType
- enum FundamentalRedType
- enum SimpleRedType
- enum SpecialRedType

## Dependencies

- using System.Collections.Concurrent
- using System.Diagnostics
- using System.Reflection
- using WolvenKit.RED4.Types.Exceptions

## Citations

[1] Source files under `WolvenKit.RED4/Types/Reflection/` in the WolvenKit repository
