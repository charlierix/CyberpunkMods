---
type: "System"
title: "RED4 TweakDB System"
description: "TweakDB binary database reader/writer: TweakDB, TweakDBReader, TweakDBWriter, pools (Flats, GroupTags, Queries, Records), Header, Record, Structs, Enums — 14 files."
resource: "WolvenKit.RED4/TweakDB/EFileReadErrorCodes.cs"
tags: [systems, tweakdb, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

TweakDB binary database reader/writer: TweakDB, TweakDBReader, TweakDBWriter, pools (Flats, GroupTags, Queries, Records), Header, Record, Structs, Enums — 14 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **14 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| EFileReadErrorCodes.cs | 9 | enum EFileReadErrorCodes |
| Enums.cs | 49 | enum ETweakType, enum ERedType |
| FlatsPool.cs | 108 | class FlatsPool |
| GroupTagsPool.cs | 69 | class GroupTagsPool |
| Header.cs | 29 | struct Header |
| FlatValueCache.cs | 34 | class FlatValueCache |
| TweakDBStringHelper.cs | 180 | class TweakDBStringHelper |
| QueriesPool.cs | 69 | class QueriesPool |
| Record.cs | 12 | class Record |
| RecordsPool.cs | 69 | class RecordsPool |
| Structs.cs | 38 | struct FileHeader, struct FileOffsets |
| TweakDB.cs | 168 | class TweakDB, record to |
| TweakDBReader.cs | 272 | class TweakDBReader, record FlatTypeInfo |
| TweakDBWriter.cs | 199 | class TweakDBWriter |

## Member Types

All **14** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | EFileReadErrorCodes.cs |
| 2 | Enums.cs |
| 3 | FlatsPool.cs |
| 4 | GroupTagsPool.cs |
| 5 | Header.cs |
| 6 | FlatValueCache.cs |
| 7 | TweakDBStringHelper.cs |
| 8 | QueriesPool.cs |
| 9 | Record.cs |
| 10 | RecordsPool.cs |
| 11 | Structs.cs |
| 12 | TweakDB.cs |
| 13 | TweakDBReader.cs |
| 14 | TweakDBWriter.cs |

## Architecture

The analyzed files contain approximately **1305 lines** of code across **14 files** (of 14 total).

### Notable Types

- class FlatValueCache
- class FlatsPool
- class GroupTagsPool
- class QueriesPool
- class Record
- class RecordsPool
- class TweakDB
- class TweakDBReader
- class TweakDBStringHelper
- class TweakDBWriter
- enum EFileReadErrorCodes
- enum ERedType
- enum ETweakType
- record FlatTypeInfo
- record to
- struct FileHeader
- struct FileOffsets
- struct Header

## Dependencies

- using System.Collections
- using System.Runtime.InteropServices
- using WolvenKit.Core.CRC
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/TweakDB/` in the WolvenKit repository
