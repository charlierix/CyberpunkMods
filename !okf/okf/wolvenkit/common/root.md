---
type: "Config"
title: "Common Root Files"
description: "Common root files (Annotations, Constants, GameType, ObjectDumper) — 4 files."
resource: "WolvenKit.Common/Annotations.cs"
tags: [common, root, config]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Common root files (Annotations, Constants, GameType, ObjectDumper) — 4 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **118 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Annotations.cs | 249 | class CanBeNullAttribute, class NotNullAttribute, class ItemNotNullAttribute, class ItemCanBeNullAttribute, class StringFormatMethodAttribute |
| Constants.cs | 11 | class Constants |
| JsonHeader.cs | 28 | class DataTypes, class JsonHeader |
| RedFileDto.cs | 81 | class RedFileDto |
| RedTypeDto.cs | 17 | class RedTypeDto |
| inkWidgetSerializer.cs | 195 | class inkWidgetSerializer |
| BlockCompression.cs | 155 | class BlockCompression, struct BC4_UNORM, enum BlockCompressionType |
| DDSUtils.cs | 261 | class DDSUtils, class DDSInfo, enum ConvertableFileTypes |
| DDS_ENUMS.cs | 227 | enum TEX_MISC_FLAG, enum TEX_MISC_FLAG2, enum TEX_DIMENSION, enum TEX_ALPHA_MODE, enum DDSFLAGS |
| DDS_HEADER.cs | 81 | struct DDS_HEADER |
| DDS_HEADER_DXT10.cs | 24 | struct DDS_HEADER_DXT10 |
| DDS_Metadata.cs | 111 | struct DDSMetadata |
| DDS_PIXELFORMAT.cs | 33 | struct DDS_PIXELFORMAT |
| MissingFormatException.cs | 28 | class MissingFormatException |
| Texconv.cs | 255 | class Texconv |
| TexconvNative.cs | 152 | class TexconvNative, class ManagedBlob, class Blob, struct TexMetadata, enum ESaveFileTypes |
| GameMismatchException.cs | 12 | class GameMismatchException |
| InvalidChunkTypeException.cs | 21 | class InvalidChunkTypeException, class ModkitExportException |
| InvalidFileTypeException.cs | 17 | class InvalidFileTypeException |
| InvalidGameContextException.cs | 22 | class InvalidGameContextException |

## Member Types

All **118** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Annotations.cs |
| 2 | Constants.cs |
| 3 | JsonHeader.cs |
| 4 | RedFileDto.cs |
| 5 | RedTypeDto.cs |
| 6 | inkWidgetSerializer.cs |
| 7 | BlockCompression.cs |
| 8 | DDSUtils.cs |
| 9 | DDS_ENUMS.cs |
| 10 | DDS_HEADER.cs |
| 11 | DDS_HEADER_DXT10.cs |
| 12 | DDS_Metadata.cs |
| 13 | DDS_PIXELFORMAT.cs |
| 14 | MissingFormatException.cs |
| 15 | Texconv.cs |
| 16 | TexconvNative.cs |
| 17 | GameMismatchException.cs |
| 18 | InvalidChunkTypeException.cs |
| 19 | InvalidFileTypeException.cs |
| 20 | InvalidGameContextException.cs |
| 21 | DictionaryExtensions.cs |
| 22 | EnumerableExtensions.cs |
| 23 | FileSystemInfoExtensions.cs |
| 24 | Stringextensions.cs |
| 25 | TexHelperExtensions.cs |
| 26 | GameType.cs |
| 27 | IArchiveManager.cs |
| 28 | IFileSystemViewModel.cs |
| 29 | IGameArchive.cs |
| 30 | IGameFile.cs |
| 31 | IModTools.cs |
| 32 | ISelectableViewModel.cs |
| 33 | AbstractGlobalArgs.cs |
| 34 | ConvertArgs.cs |
| 35 | ExportArgs.cs |
| 36 | GlobalConvertArgs.cs |
| 37 | GlobalExportArgs.cs |
| 38 | GlobalImportArgs.cs |
| 39 | ImportArgs.cs |
| 40 | ImportExportArguments.cs |
| 41 | RequestFileOpenArgs.cs |
| 42 | RedArchive.cs |
| 43 | RedDBContext.cs |
| 44 | RedFile.cs |
| 45 | RedFileUse.cs |
| 46 | WkPackage.cs |
| 47 | RedFileSystemModel.cs |
| 48 | RedRelativePath.cs |
| 49 | SAsciiString.cs |
| 50 | WinFormsEnums.cs |
| 51 | WitcherPackSettings.cs |
| 52 | WolvenkitFileModel.cs |
| 53 | ObjectDumper.cs |
| 54 | BV4Tree.cs |
| 55 | BV4TriangleMesh.cs |
| 56 | BigConvexData.cs |
| 57 | ConvexHullData.cs |
| 58 | ConvexMesh.cs |
| 59 | PhysXHelper.cs |
| 60 | PhysXMesh.cs |
| 61 | Structs.cs |
| 62 | CR2WBuffer.cs |
| 63 | CR2WEmbedded.cs |
| 64 | CR2WExport.cs |
| 65 | CR2WFile.cs |
| 66 | CR2WFileHelpers.cs |
| 67 | CR2WHeaderData.cs |
| 68 | CR2WHeaderStructs.cs |
| 69 | CR2WImport.cs |
| 70 | CR2WName.cs |
| 71 | CR2WProperty.cs |
| 72 | CR2WReaderExtensions.cs |
| 73 | CR2WVerify.cs |
| 74 | ILocalizedStringSource.cs |
| 75 | IVariableEditor.cs |
| 76 | Red3TypeHelpers.cs |
| 77 | BinaryReaderExtensions.cs |
| 78 | CExtents.cs |
| 79 | CWind.cs |
| 80 | SLodProfile.cs |
| 81 | SRTStructs.cs |
| 82 | Srtfile.cs |
| 83 | Arrays.cs |
| 84 | CustomRedConverter.cs |
| 85 | Enums.cs |
| 86 | Fundamentals.cs |
| 87 | ICustomRedConverter.cs |
| 88 | ParseableBuffers.cs |
| 89 | PrimitiveConverter.cs |
| 90 | RedFileDtoConverter.cs |
| 91 | RedJsonPatches.cs |
| 92 | RedJsonSerializer.cs |
| 93 | RedJsonSerializerOptions.cs |
| 94 | Simples.cs |
| 95 | CommonFunctions.cs |
| 96 | GeometryCacheReader.cs |
| 97 | Red4ParserService.cs |
| 98 | RedImage.Lut.cs |
| 99 | RedImage.cs |
| 100 | missinghashes.json |
| 101 | CRUIDService.cs |
| 102 | GeometryCacheService.cs |
| 103 | HashService.cs |
| 104 | HookService.cs |
| 105 | IHookService.cs |
| 106 | ILocKeyService.cs |
| 107 | IRedParserService.cs |
| 108 | ISelectableTreeViewItemModel.cs |
| 109 | IWindowFactory.cs |
| 110 | LocKeyService.cs |
| 111 | PercentProgressService.cs |
| 112 | ProgressService.cs |
| 113 | TweakDBService.cs |
| 114 | WolvenTesting.cs |
| 115 | FileHelper.cs |
| 116 | HashHelper.cs |
| 117 | ProcessUtil.cs |
| 118 | WolvenKit.Common.csproj |

## Architecture

The analyzed files contain approximately **2399 lines** of code across **30 files** (of 118 total).

### Notable Types

- class Blob
- class BlockCompression
- class CanBeNullAttribute
- class Class1
- class Constants
- class DDSInfo
- class DDSUtils
- class DataTypes
- class DictionaryExtensions
- class EnumerableExtensions
- class FileSystemInfoExtensions
- class GameMismatchException
- class InvalidChunkTypeException
- class InvalidFileTypeException
- class InvalidGameContextException
- class InvokerParameterNameAttribute
- class ItemCanBeNullAttribute
- class ItemNotNullAttribute
- class JsonHeader
- class ManagedBlob
- class MissingFormatException
- class ModkitExportException
- class NonNegativeValueAttribute
- class NotNullAttribute
- class RedFileDto
- class RedTypeDto
- class StringExtensions
- class StringFormatMethodAttribute
- class TexHelperExtensions
- class Texconv
- class TexconvNative
- class ValueProviderAttribute
- class ValueRangeAttribute
- class inkWidgetSerializer
- enum BlockCompressionType
- enum ConvertableFileTypes
- enum D3D10_RESOURCE_DIMENSION
- enum DDSFLAGS
- enum DXGI_FORMAT
- enum ESaveFileTypes
- enum GameType
- enum TEX_ALPHA_MODE
- enum TEX_DIMENSION
- enum TEX_MISC_FLAG
- enum TEX_MISC_FLAG2
- enum TGA_FLAGS
- interface IArchiveManager
- interface IFileSystemViewModel
- interface IWitcherGameArchive
- interface Tw3GameFile

## Dependencies

- using DirectXTexNet
- using Semver
- using System
- using System.Collections.Generic
- using System.IO
- using System.Reflection
- using System.Runtime.InteropServices
- using System.Text.Json.Serialization
- using System.Xml
- using System.Xml.Schema
- using System.Xml.Serialization
- using WolvenKit.Core
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Archive.CR2W
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.Common/` in the WolvenKit repository
