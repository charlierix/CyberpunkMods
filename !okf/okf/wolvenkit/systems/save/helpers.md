---
type: "Service"
title: "RED4 Save Helpers"
description: "Save file helper utilities (compression, exceptions, extensions, hash, inventory, parser) — 7 files."
resource: "WolvenKit.RED4/Save/Helper/Compression.cs"
tags: [systems, save, helpers, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Save file helper utilities (compression, exceptions, extensions, hash, inventory, parser) — 7 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **7 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Compression.cs | 291 | class Compression, delegate DataChunkInfo |
| Exceptions.cs | 7 | class InvalidFormatException |
| Extensions.cs | 58 | class Extensions |
| Interfaces.cs | 14 | interface INodeData, interface INodeParser |
| InventoryHelper.cs | 159 | class InventoryHelper |
| ParserHelper.cs | 81 | class ParserHelper |
| SaveHashHelper.cs | 103 | class SaveHashHelper |

## Member Types

All **7** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Compression.cs |
| 2 | Exceptions.cs |
| 3 | Extensions.cs |
| 4 | Interfaces.cs |
| 5 | InventoryHelper.cs |
| 6 | ParserHelper.cs |
| 7 | SaveHashHelper.cs |

## Architecture

The analyzed files contain approximately **713 lines** of code across **7 files** (of 7 total).

### Notable Types

- class Compression
- class Extensions
- class InvalidFormatException
- class InventoryHelper
- class ParserHelper
- class SaveHashHelper
- delegate DataChunkInfo
- interface INodeData
- interface INodeParser

## Dependencies

- using K4os.Compression.LZ4
- using System.Diagnostics
- using System.Reflection
- using System.Text
- using WolvenKit.Common.FNV1A
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Save.Classes
- using WolvenKit.RED4.Save.IO
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/Save/Helper/` in the WolvenKit repository
