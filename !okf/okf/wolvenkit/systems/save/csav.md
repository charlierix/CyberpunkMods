---
type: "System"
title: "RED4 Save File Format (CSAV)"
description: "Cyberpunk save file structure: CyberpunkSaveFile, SaveFileInfo, SaveHeaderStruct, NodeEntry, NodeInfo — 5 files."
resource: "WolvenKit.RED4/Save/CSAV/CyberpunkSaveFile.cs"
tags: [systems, save, csav, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Cyberpunk save file structure: CyberpunkSaveFile, SaveFileInfo, SaveHeaderStruct, NodeEntry, NodeInfo — 5 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CyberpunkSaveFile.cs | 13 | class CyberpunkSaveFile |
| CyberpunkSaveFileInfo.cs | 7 | class CyberpunkSaveFileInfo |
| CyberpunkSaveHeaderStruct.cs | 32 | struct CyberpunkSaveHeaderStruct |
| NodeEntry.cs | 60 | class NodeEntry |
| NodeInfo.cs | 14 | class NodeInfo |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CyberpunkSaveFile.cs |
| 2 | CyberpunkSaveFileInfo.cs |
| 3 | CyberpunkSaveHeaderStruct.cs |
| 4 | NodeEntry.cs |
| 5 | NodeInfo.cs |

## Architecture

The analyzed files contain approximately **126 lines** of code across **5 files** (of 5 total).

### Notable Types

- class CyberpunkSaveFile
- class CyberpunkSaveFileInfo
- class NodeEntry
- class NodeInfo
- struct CyberpunkSaveHeaderStruct

## Dependencies

- using System.Diagnostics
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Save.Classes
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/Save/CSAV/` in the WolvenKit repository
