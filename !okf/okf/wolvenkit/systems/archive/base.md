---
type: "System"
title: "RED4 Archive Base Structure"
description: "Archive file structure: Archive, FileEntry, Header, Index, LxrsFooter, interfaces, shaders — 9 files."
resource: "WolvenKit.RED4/Archive/Base/Archive.cs"
tags: [systems, archive, base, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Archive file structure: Archive, FileEntry, Header, Index, LxrsFooter, interfaces, shaders — 9 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Archive.cs | 252 | class Archive |
| FileEntry.cs | 142 | class FileEntry |
| Header.cs | 36 | class Header |
| Index.cs | 50 | class Index, struct Dependency, struct FileSegment |
| LxrsFooter.cs | 87 | class LxrsFooter |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Archive.cs |
| 2 | FileEntry.cs |
| 3 | Header.cs |
| 4 | Index.cs |
| 5 | LxrsFooter.cs |

## Architecture

The analyzed files contain approximately **567 lines** of code across **5 files** (of 5 total).

### Notable Types

- class Archive
- class FileEntry
- class Header
- class Index
- class LxrsFooter
- struct Dependency
- struct FileSegment

## Dependencies

- using System.IO.MemoryMappedFiles
- using System.Text
- using WolvenKit.Common
- using WolvenKit.Common.Services
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Extensions
- using WolvenKit.Core.Interfaces
- using WolvenKit.RED4.Types.Exceptions
- using WolvenKit.RED4.Types.Pools

## Citations

[1] Source files under `WolvenKit.RED4/Archive/Base/` in the WolvenKit repository
