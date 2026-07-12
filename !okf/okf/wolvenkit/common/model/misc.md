---
type: "Model"
title: "Common Data Models"
description: "Data models (RedArchive, RedDBContext, RedFile, WkPackage, RedFileSystemModel, RedRelativePath, WolvenkitFileModel) — 25 files."
resource: "WolvenKit.Common/Model/Arguments/AbstractGlobalArgs.cs"
tags: [common, model, misc]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Data models (RedArchive, RedDBContext, RedFile, WkPackage, RedFileSystemModel, RedRelativePath, WolvenkitFileModel) — 25 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **20 source files** from the WolvenKit codebase.

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
| RedArchive.cs | 12 | class RedArchive |
| RedDBContext.cs | 81 | class RedDBContext |
| RedFile.cs | 16 | class RedFile |
| RedFileUse.cs | 10 | class RedFileUse |
| WkPackage.cs | 244 | class WKPackage |
| RedFileSystemModel.cs | 36 | class RedFileSystemModel |
| RedRelativePath.cs | 61 | class RedRelativePath |
| SAsciiString.cs | 44 | struct SAsciiString |
| WinFormsEnums.cs | 38 | enum DialogResult, enum MessageBoxButtons, enum MessageBoxIcon |
| WitcherPackSettings.cs | 41 | class WitcherPackSettings |
| WolvenkitFileModel.cs | 45 | class WolvenKitFileDefinitions, class FileCategoryModel, class AddFileModel |

## Member Types

All **20** member source files assigned to this concept:

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
| 10 | RedArchive.cs |
| 11 | RedDBContext.cs |
| 12 | RedFile.cs |
| 13 | RedFileUse.cs |
| 14 | WkPackage.cs |
| 15 | RedFileSystemModel.cs |
| 16 | RedRelativePath.cs |
| 17 | SAsciiString.cs |
| 18 | WinFormsEnums.cs |
| 19 | WitcherPackSettings.cs |
| 20 | WolvenkitFileModel.cs |

## Architecture

The analyzed files contain approximately **1406 lines** of code across **20 files** (of 20 total).

### Notable Types

- class AbstractGlobalArgs
- class AddFileModel
- class CommonConvertArgs
- class CommonExportArgs
- class CommonImportArgs
- class ConvertArgs
- class EntityExportArgs
- class ExportArgs
- class FileCategoryModel
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
- class RedArchive
- class RedDBContext
- class RedFile
- class RedFileSystemModel
- class RedFileUse
- class RedRelativePath
- class RequestFileDeleteArgs
- class RequestFileOpenArgs
- class RequestFilesChangeArgs
- class UsedWith
- class WKPackage
- class WitcherPackSettings
- class WkitScriptAccess
- class WolvenKitFileDefinitions
- class XbmExportArgs
- class XbmImportArgs
- class public
- enum DialogResult
- enum EntityExportType
- enum MessageBoxButtons
- enum MessageBoxIcon
- struct SAsciiString

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
