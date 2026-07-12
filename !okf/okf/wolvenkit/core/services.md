---
type: "Service"
title: "Core Services"
description: "Core service interfaces and implementations (FilepathValidation, ICr2wCompiler, IHashService, IProgressService, ITweakDBService, LogEntry, LoggerTypes, SerilogWrapper) — 8 files."
resource: "WolvenKit.Core/Services/FilepathValidationTools.cs"
tags: [core, services, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Core service interfaces and implementations (FilepathValidation, ICr2wCompiler, IHashService, IProgressService, ITweakDBService, LogEntry, LoggerTypes, SerilogWrapper) — 8 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **8 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| FilepathValidationTools.cs | 178 | class FilepathValidationTools |
| ICr2wCompiler.cs | 9 | interface ICr2wCompiler |
| IHashService.cs | 23 | interface IHashService |
| IProgressService.cs | 21 | enum EStatus, interface IProgressService |
| ITweakDBService.cs | 16 | interface ITweakDBService |
| LogEntry.cs | 22 | class LogEntry |
| LoggerTypes.cs | 46 | class LogStringEventArgs, enum SystemLogFlag, enum ToolLogFlag, enum WccLogFlag |
| SerilogWrapper.cs | 53 | class SerilogWrapper |

## Member Types

All **8** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | FilepathValidationTools.cs |
| 2 | ICr2wCompiler.cs |
| 3 | IHashService.cs |
| 4 | IProgressService.cs |
| 5 | ITweakDBService.cs |
| 6 | LogEntry.cs |
| 7 | LoggerTypes.cs |
| 8 | SerilogWrapper.cs |

## Architecture

The analyzed files contain approximately **368 lines** of code across **8 files** (of 8 total).

### Notable Types

- class FilepathValidationTools
- class LogEntry
- class LogStringEventArgs
- class SerilogWrapper
- enum EStatus
- enum SystemLogFlag
- enum ToolLogFlag
- enum WccLogFlag
- interface ICr2wCompiler
- interface IHashService
- interface IProgressService
- interface ITweakDBService

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using System
- using System.Collections.Generic
- using System.ComponentModel
- using System.IO
- using System.Linq
- using System.Text.RegularExpressions
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Interfaces

## Citations

[1] Source files under `WolvenKit.Core/Services/` in the WolvenKit repository
