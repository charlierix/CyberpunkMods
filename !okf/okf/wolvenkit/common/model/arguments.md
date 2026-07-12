---
type: "Model"
title: "Import/Export Arguments"
description: "Import/export argument models (Convert, Export, Import args, global args, request file open) — 9 files."
resource: "WolvenKit.Common/Model/Arguments/AbstractGlobalArgs.cs"
tags: [common, model, arguments]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Import/export argument models (Convert, Export, Import args, global args, request file open) — 9 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **9 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AbstractGlobalArgs.cs | 44 | class AbstractGlobalArgs |
| ConvertArgs.cs | 25 | class ConvertArgs, class CommonConvertArgs |
| ExportArgs.cs | 266 | class ExportArgs, class CommonExportArgs, class GeneralExportArgs, class OpusExportArgs, class MorphTargetExportArgs |
| GlobalConvertArgs.cs | 44 | class GlobalConvertArgs |
| GlobalExportArgs.cs | 32 | class GlobalExportArgs |
| GlobalImportArgs.cs | 31 | class GlobalImportArgs |
| ImportArgs.cs | 261 | class ImportArgs, class CommonImportArgs, class OpusImportArgs, class FntImportArgs, class XbmImportArgs |
| ImportExportArguments.cs | 41 | class WkitScriptAccess, class public, class UsedWith, class ImportExportArgs |
| RequestFileOpenArgs.cs | 34 | class RequestFileDeleteArgs, class RequestFileOpenArgs, class RequestFilesChangeArgs |

## Member Types

All **9** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AbstractGlobalArgs.cs |
| 2 | ConvertArgs.cs |
| 3 | ExportArgs.cs |
| 4 | GlobalConvertArgs.cs |
| 5 | GlobalExportArgs.cs |
| 6 | GlobalImportArgs.cs |
| 7 | ImportArgs.cs |
| 8 | ImportExportArguments.cs |
| 9 | RequestFileOpenArgs.cs |

## Architecture

The analyzed files contain approximately **778 lines** of code across **9 files** (of 9 total).

### Notable Types

- class AbstractGlobalArgs
- class CommonConvertArgs
- class CommonExportArgs
- class CommonImportArgs
- class ConvertArgs
- class EntityExportArgs
- class ExportArgs
- class FntExportArgs
- class FntImportArgs
- class GeneralExportArgs
- class GlobalConvertArgs
- class GlobalExportArgs
- class GlobalImportArgs
- class GltfImportArgs
- class ImportArgs
- class ImportExportArgs
- class InkAtlasExportArgs
- class MeshExportArgs
- class MlmaskExportArgs
- class MorphTargetExportArgs
- class OpusExportArgs
- class OpusImportArgs
- class RequestFileDeleteArgs
- class RequestFileOpenArgs
- class RequestFilesChangeArgs
- class UsedWith
- class WkitScriptAccess
- class XbmExportArgs
- class XbmImportArgs
- class public
- enum EntityExportType

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using DynamicData
- using Microsoft.Extensions.Logging
- using SharpGLTF.Validation
- using System
- using System.Collections.Generic
- using System.ComponentModel
- using System.ComponentModel.DataAnnotations
- using System.IO
- using System.Linq
- using System.Runtime.CompilerServices
- using WolvenKit.Core.Interfaces
- using WolvenKit.RED4.Archive
- using WolvenKit.RED4.CR2W
- using WolvenKit.RED4.Types
- using static WolvenKit.RED4.Types.Enums

## Citations

[1] Source files under `WolvenKit.Common/Model/Arguments/` in the WolvenKit repository
