---
type: "System"
title: "RED4 CR2W File Format"
description: "CR2W file format: CR2WFile, CR2WFileInfo, CR2WHeaderData, CR2WPackage, and section types — 11 files."
resource: "WolvenKit.RED4/Archive/CR2W/CR2WFile.cs"
tags: [systems, archive, cr2w, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

CR2W file format: CR2WFile, CR2WFileInfo, CR2WHeaderData, CR2WPackage, and section types — 11 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **11 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CR2WFile.cs | 212 | class CR2WMetaData, class CR2WFile |
| CR2WFileInfo.cs | 31 | class CR2WFileInfo |
| CR2WHeaderData.cs | 49 | class CR2WHeaderData |
| CR2WHeaderStructs.cs | 48 | struct CR2WFileHeader, struct CR2WTable |
| CR2WPackage.cs | 15 | class CR2WPackage |
| CR2WBuffer.cs | 43 | struct CR2WBufferInfo |
| CR2WEmbedded.cs | 60 | class CR2WEmbedded, struct CR2WEmbeddedInfo |
| CR2WExport.cs | 34 | class CR2WExport, struct CR2WExportInfo |
| CR2WImport.cs | 27 | class CR2WImport, struct CR2WImportInfo |
| CR2WName.cs | 18 | class CR2WName, struct CR2WNameInfo |
| CR2WProperty.cs | 27 | class CR2WProperty, struct CR2WPropertyInfo |

## Member Types

All **11** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CR2WFile.cs |
| 2 | CR2WFileInfo.cs |
| 3 | CR2WHeaderData.cs |
| 4 | CR2WHeaderStructs.cs |
| 5 | CR2WPackage.cs |
| 6 | CR2WBuffer.cs |
| 7 | CR2WEmbedded.cs |
| 8 | CR2WExport.cs |
| 9 | CR2WImport.cs |
| 10 | CR2WName.cs |
| 11 | CR2WProperty.cs |

## Architecture

The analyzed files contain approximately **564 lines** of code across **11 files** (of 11 total).

### Notable Types

- class CR2WEmbedded
- class CR2WExport
- class CR2WFile
- class CR2WFileInfo
- class CR2WHeaderData
- class CR2WImport
- class CR2WMetaData
- class CR2WName
- class CR2WPackage
- class CR2WProperty
- struct CR2WBufferInfo
- struct CR2WEmbeddedInfo
- struct CR2WExportInfo
- struct CR2WFileHeader
- struct CR2WImportInfo
- struct CR2WNameInfo
- struct CR2WPropertyInfo
- struct CR2WTable

## Dependencies

- using System.Runtime.InteropServices
- using WolvenKit.RED4.Archive.IO
- using WolvenKit.RED4.Types
- using WolvenKit.RED4.Types.Pools

## Citations

[1] Source files under `WolvenKit.RED4/Archive/CR2W/` in the WolvenKit repository
