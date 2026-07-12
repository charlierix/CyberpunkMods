---
type: "System"
title: "RED4 Save IO"
description: "Save file reader/writer and node writer — 4 files."
resource: "WolvenKit.RED4/Save/IO/CyberpunkSaveReader.cs"
tags: [systems, save, io, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Save file reader/writer and node writer — 4 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **4 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CyberpunkSaveReader.cs | 296 | class CyberpunkSaveReader |
| CyberpunkSaveWriter.cs | 120 | class CyberpunkSaveWriter |
| Enums.cs | 9 | enum EFileReadErrorCodes |
| NodeWriter.cs | 105 | class NodeWriter, class NodeMeta |

## Member Types

All **4** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CyberpunkSaveReader.cs |
| 2 | CyberpunkSaveWriter.cs |
| 3 | Enums.cs |
| 4 | NodeWriter.cs |

## Architecture

The analyzed files contain approximately **530 lines** of code across **4 files** (of 4 total).

### Notable Types

- class CyberpunkSaveReader
- class CyberpunkSaveWriter
- class NodeMeta
- class NodeWriter
- enum EFileReadErrorCodes

## Dependencies

- using System.Diagnostics
- using System.Text
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/Save/IO/` in the WolvenKit repository
