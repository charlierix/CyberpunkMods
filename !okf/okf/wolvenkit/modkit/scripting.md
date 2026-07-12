---
type: "System"
title: "Modkit Scripting"
description: "Modkit scripting system resources — 4 files."
resource: "WolvenKit.Modkit/Scripting/ImportExportArgsConverter.cs"
tags: [modkit, scripting, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Modkit scripting system resources — 4 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **4 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ImportExportArgsConverter.cs | 132 | class ImportExportArgsConverter |
| ScriptFile.cs | 254 | class ScriptFile, enum BlockType, enum ScriptType, enum HookType |
| ScriptFunctions.cs | 227 | class ScriptFunctions, enum OpenAs |
| ScriptService.cs | 162 | class ScriptService |

## Member Types

All **4** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ImportExportArgsConverter.cs |
| 2 | ScriptFile.cs |
| 3 | ScriptFunctions.cs |
| 4 | ScriptService.cs |

## Architecture

The analyzed files contain approximately **775 lines** of code across **4 files** (of 4 total).

### Notable Types

- class ImportExportArgsConverter
- class ScriptFile
- class ScriptFunctions
- class ScriptService
- enum BlockType
- enum HookType
- enum OpenAs
- enum ScriptType

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using Microsoft.ClearScript
- using Microsoft.ClearScript.JavaScript
- using Microsoft.ClearScript.V8
- using System
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.Diagnostics
- using System.IO
- using System.Threading.Tasks
- using WolvenKit.Core.Interfaces

## Citations

[1] Source files under `WolvenKit.Modkit/Scripting/` in the WolvenKit repository
