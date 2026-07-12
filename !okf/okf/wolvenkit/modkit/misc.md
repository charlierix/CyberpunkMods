---
type: "System"
title: "Modkit Misc"
description: "Modkit misc files (ArchiveManager, extensions, exceptions) — 5 files."
resource: "WolvenKit.Modkit/Exceptions/ExportException.cs"
tags: [modkit, misc, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Modkit misc files (ArchiveManager, extensions, exceptions) — 5 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **73 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ExportException.cs | 14 | class ExportException |
| ImportException.cs | 12 | class PackException |
| C2dArrayExtensions.cs | 92 | class C2dArrayExtensions |
| CurveExtensions.cs | 26 | class RedLegacySingleChannelCurveExtensions |
| ArchiveManager.cs | 326 | class ArchiveManager |
| Build.cs | 185 | class ModTools |
| Export.cs | 72 | class ModTools |
| Import.cs | 259 | class ModTools |
| ModToolExtensions.cs | 42 | class ModToolExtensions |
| ModTools.Helper.cs | 166 | class ModTools, enum FindFileResult, record FindFileRecord |
| ModTools.Types.cs | 59 | class ModTools |
| ModTools.cs | 37 | class ModTools |
| Pack.cs | 75 | class ModTools |
| Rebuild.cs | 266 | class ModTools |
| RedConverter.cs | 201 | class ModTools |
| RedMod.cs | 60 | class RedMod |
| RedTypeFactory.cs | 158 | class is, class is, class RedTypeFactory |
| Serialization.cs | 276 | class Serialization, class Yaml, class Json |
| TweakDocument.cs | 13 | class TweakDocument |
| CArrayConverter.cs | 86 | class CArrayConverter, class CArrayConverterInner |

## Member Types

All **73** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ExportException.cs |
| 2 | ImportException.cs |
| 3 | C2dArrayExtensions.cs |
| 4 | CurveExtensions.cs |
| 5 | ArchiveManager.cs |
| 6 | Build.cs |
| 7 | Export.cs |
| 8 | Import.cs |
| 9 | ModToolExtensions.cs |
| 10 | ModTools.Helper.cs |
| 11 | ModTools.Types.cs |
| 12 | ModTools.cs |
| 13 | Pack.cs |
| 14 | Rebuild.cs |
| 15 | RedConverter.cs |
| 16 | RedMod.cs |
| 17 | RedTypeFactory.cs |
| 18 | Serialization.cs |
| 19 | TweakDocument.cs |
| 20 | CArrayConverter.cs |
| 21 | Converters.cs |
| 22 | ITypeConverterWithTypeDiscriminator.cs |
| 23 | IParserExtensions.cs |
| 24 | TweakTypeConverter.cs |
| 25 | Models.cs |
| 26 | SoundEvent.cs |
| 27 | SoundEventMetadata.cs |
| 28 | ArchiveTask.cs |
| 29 | BuildTask.cs |
| 30 | ConflictsTask.cs |
| 31 | ConsoleFunctions.cs |
| 32 | Cr2wTask.cs |
| 33 | ExportTask.cs |
| 34 | HashTask.cs |
| 35 | IConsoleFunctions.cs |
| 36 | ImportTask.cs |
| 37 | OodleTask.cs |
| 38 | PackTask.cs |
| 39 | UnbundleTask.cs |
| 40 | UncookTask.cs |
| 41 | WwiseTask.cs |
| 42 | AnimRootMotion.cs |
| 43 | AnimSIMD.cs |
| 44 | AnimSIMDEncoder.cs |
| 45 | AnimSpline.cs |
| 46 | Shared.cs |
| 47 | AnimationTools.cs |
| 48 | GLTFHelper.cs |
| 49 | MaterialExtractor.cs |
| 50 | StructFunctions.cs |
| 51 | Structs.cs |
| 52 | EntityTools.cs |
| 53 | MaterialTools.cs |
| 54 | MeshImportTools.cs |
| 55 | MeshTools.cs |
| 56 | MlmaskImportTools.cs |
| 57 | MlmaskTools.cs |
| 58 | MorphTargetImportTools.cs |
| 59 | MorphTargetTools.cs |
| 60 | OpusInfo.cs |
| 61 | OpusTools.cs |
| 62 | RigTools.cs |
| 63 | Unbundle.cs |
| 64 | Uncook.cs |
| 65 | ArchiveXlHelper.cs |
| 66 | DefaultMaterials.cs |
| 67 | YamlHelper.cs |
| 68 | soundEvents.json |
| 69 | ImportExportArgsConverter.cs |
| 70 | ScriptFile.cs |
| 71 | ScriptFunctions.cs |
| 72 | ScriptService.cs |
| 73 | WolvenKit.Modkit.csproj |

## Architecture

The analyzed files contain approximately **3516 lines** of code across **30 files** (of 73 total).

### Notable Types

- class ArchiveManager
- class C2dArrayExtensions
- class CArrayConverter
- class CArrayConverterInner
- class CBoolJsonConverter
- class CColorJsonConverter
- class CEulerAnglesJsonConverter
- class CFloatJsonConverter
- class CInt16JsonConverter
- class CInt32JsonConverter
- class CInt64JsonConverter
- class CInt8JsonConverter
- class CNameJsonConverter
- class CQuaternionJsonConverter
- class CResourceConverter
- class CResourceConverterFactory
- class CStringJsonConverter
- class CUint16JsonConverter
- class CUint32JsonConverter
- class CUint64JsonConverter
- class CUint8JsonConverter
- class CVector2JsonConverter
- class CVector3JsonConverter
- class ConflictEntry
- class Conflicts
- class ConsoleFunctions
- class CustomSoundsModel
- class ExportException
- class IParserExtensions
- class ITypeConverterWithTypeDiscriminator
- class Json
- class ModToolExtensions
- class ModTools
- class PackException
- class RedLegacySingleChannelCurveExtensions
- class RedMod
- class RedTypeFactory
- class ResolvedConflictEntry
- class ResolvedConflicts
- class Serialization
- class SoundEvent
- class SoundEventMetadata
- class TweakDocument
- class TweakTypeConverter
- class Yaml
- class is
- enum ECustomSoundType
- enum FindFileResult
- interface to
- record FindFileRecord

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using DynamicData
- using DynamicData.Kernel
- using EFileReadErrorCodes = WolvenKit.RED4.Archive.IO.EFileReadErrorCodes
- using System
- using System.Collections.Generic
- using System.Diagnostics
- using System.IO
- using System.Linq
- using System.Runtime.Serialization
- using System.Text.Json
- using System.Text.RegularExpressions
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Common.Extensions
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Model
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Common.Services
- using WolvenKit.Common.Tools

## Citations

[1] Source files under `WolvenKit.Modkit/Exceptions/` in the WolvenKit repository
