---
type: "System"
title: "RED3 (Witcher 3) CR2W Support"
description: "Witcher 3 / REDengine 3 CR2W file support (CR2WFile, buffers, exports, imports, names, properties, SRT files) — 33 files."
resource: "WolvenKit.Common/RED3/CR2W/CR2WBuffer.cs"
tags: [common, red3, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Witcher 3 / REDengine 3 CR2W file support (CR2WFile, buffers, exports, imports, names, properties, SRT files) — 33 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **12 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CR2WBuffer.cs | 134 | class CR2WBufferWrapper, struct CR2WBuffer |
| CR2WEmbedded.cs | 141 | class CR2WEmbeddedWrapper, class name, struct CR2WEmbedded |
| CR2WExport.cs | 321 | class CR2WExportWrapper, struct CR2WExport |
| CR2WFile.cs | 292 | class CR2WFile, enum EChunkDisplayMode |
| CR2WFileHelpers.cs | 24 | class CR2WFileHelper |
| CR2WHeaderData.cs | 53 | class CR2WHeaderData |
| CR2WHeaderStructs.cs | 60 | struct CR2WFileHeader, struct CR2WTable |
| CR2WImport.cs | 61 | class CR2WImportWrapper, struct CR2WImport |
| CR2WName.cs | 53 | class CR2WNameWrapper, struct CR2WName |
| CR2WProperty.cs | 56 | class CR2WPropertyWrapper, struct CR2WProperty |
| CR2WReaderExtensions.cs | 75 | class CR2WReaderExtensions |
| CR2WVerify.cs | 305 | class CR2WVerify |

## Member Types

All **12** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CR2WBuffer.cs |
| 2 | CR2WEmbedded.cs |
| 3 | CR2WExport.cs |
| 4 | CR2WFile.cs |
| 5 | CR2WFileHelpers.cs |
| 6 | CR2WHeaderData.cs |
| 7 | CR2WHeaderStructs.cs |
| 8 | CR2WImport.cs |
| 9 | CR2WName.cs |
| 10 | CR2WProperty.cs |
| 11 | CR2WReaderExtensions.cs |
| 12 | CR2WVerify.cs |

## Architecture

The analyzed files contain approximately **1575 lines** of code across **12 files** (of 12 total).

### Notable Types

- class CR2WBufferWrapper
- class CR2WEmbeddedWrapper
- class CR2WExportWrapper
- class CR2WFile
- class CR2WFileHelper
- class CR2WHeaderData
- class CR2WImportWrapper
- class CR2WNameWrapper
- class CR2WPropertyWrapper
- class CR2WReaderExtensions
- class CR2WVerify
- class name
- enum EChunkDisplayMode
- struct CR2WBuffer
- struct CR2WEmbedded
- struct CR2WExport
- struct CR2WFileHeader
- struct CR2WImport
- struct CR2WName
- struct CR2WProperty
- struct CR2WTable

## Dependencies

- using CR2WTypeManager = WolvenKit.RED3.CR2W.Types.CR2WTypeManager
- using CVariable = WolvenKit.RED3.CR2W.Types.CVariable
- using RED.CRC32
- using System
- using System.Collections.Generic
- using System.Diagnostics
- using System.IO
- using System.IO.MemoryMappedFiles
- using System.Linq
- using System.Runtime.InteropServices
- using System.Runtime.Serialization
- using System.Text
- using System.Text.Json.Serialization
- using System.Threading.Tasks
- using System.Xml.Serialization
- using WolvenKit.Common
- using WolvenKit.Common.Extensions
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Model
- using WolvenKit.Common.Model.Cr2w

## Citations

[1] Source files under `WolvenKit.Common/RED3/CR2W/` in the WolvenKit repository
