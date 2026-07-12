---
type: "Config"
title: "Core Root and Misc"
description: "Core root files and misc (Constants, Enums, CommonFunctions, NativeMethods, WikiLinks, CSharpCompilerTools, REDAttribute, RED4Attribute, Wem, UnmanagedMemory, GCHelper, LookupTable) — 12 files."
resource: "WolvenKit.Core/CRC/CRC64Algo.cs"
tags: [core, root, config]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Core root files and misc (Constants, Enums, CommonFunctions, NativeMethods, WikiLinks, CSharpCompilerTools, REDAttribute, RED4Attribute, Wem, UnmanagedMemory, GCHelper, LookupTable) — 12 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **55 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CRC64Algo.cs | 91 | class Crc64 |
| Crc32Algorithm.cs | 184 | class supports, class Crc32Algorithm |
| Crc32CAlgorithm.cs | 197 | class supports, class Crc32CAlgorithm |
| MismatchCRC32Exception.cs | 24 | class MismatchCRC32Exception |
| SafeProxy.cs | 92 | class SafeProxy |
| SafeProxyC.cs | 24 | class SafeProxyC |
| CommonFunctions.cs | 114 | class CommonFunctions |
| CompressionSettings.cs | 22 | class CompressionSettings |
| KrakenNative.cs | 41 | class KrakenNative |
| Oodle.cs | 300 | class Oodle, enum Compressor, enum CompressionLevel, enum FuzzSafe, enum CheckCRC |
| OodleLZNative.cs | 34 | class OodleLZNative |
| OodleLib.cs | 163 | class OodleLib, delegate int, delegate int, delegate long, delegate int |
| Constants.cs | 17 | class Constants |
| CSharpCompilerTools.cs | 89 | class CSharpCompilerTools |
| Enums.cs | 344 | enum EInterpolationType, enum ESegmentsLinkType, enum EWolvenKitFile, enum ERedScriptExtension, enum ETweakExtension |
| DecompressionException.cs | 15 | class DecompressionException |
| InvalidPtrException.cs | 25 | class InvalidPtrException |
| MissingTypeException.cs | 16 | class MissingTypeException |
| TypeMismatchException.cs | 20 | class TypeMismatchException, class MissingRTTIException |
| WolvenKitException.cs | 14 | class WolvenKitException |

## Member Types

All **55** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CRC64Algo.cs |
| 2 | Crc32Algorithm.cs |
| 3 | Crc32CAlgorithm.cs |
| 4 | MismatchCRC32Exception.cs |
| 5 | SafeProxy.cs |
| 6 | SafeProxyC.cs |
| 7 | CommonFunctions.cs |
| 8 | CompressionSettings.cs |
| 9 | KrakenNative.cs |
| 10 | Oodle.cs |
| 11 | OodleLZNative.cs |
| 12 | OodleLib.cs |
| 13 | Constants.cs |
| 14 | CSharpCompilerTools.cs |
| 15 | Enums.cs |
| 16 | DecompressionException.cs |
| 17 | InvalidPtrException.cs |
| 18 | MissingTypeException.cs |
| 19 | TypeMismatchException.cs |
| 20 | WolvenKitException.cs |
| 21 | BinaryReaderExtensions.cs |
| 22 | BinaryWriterExtensions.cs |
| 23 | Ensure.cs |
| 24 | EnumExtensions.cs |
| 25 | IEnumerableExtensions.cs |
| 26 | RandomExtensions.cs |
| 27 | StreamExtensions.cs |
| 28 | StringExtensions.cs |
| 29 | StringPathExtensions.cs |
| 30 | TypeExtensions.cs |
| 31 | FNV1A32HashAlgorithm.cs |
| 32 | FNV1A64HashAlgorithm.cs |
| 33 | GCHelper.cs |
| 34 | LookupTable.cs |
| 35 | IByteSource.cs |
| 36 | IGameArchive.cs |
| 37 | IGameFile.cs |
| 38 | ILoggerService.cs |
| 39 | INotificationService.cs |
| 40 | Murmur32.cs |
| 41 | NativeMethods.cs |
| 42 | REDAttribute.cs |
| 43 | REDAttribute.cs |
| 44 | FilepathValidationTools.cs |
| 45 | ICr2wCompiler.cs |
| 46 | IHashService.cs |
| 47 | IProgressService.cs |
| 48 | ITweakDBService.cs |
| 49 | LogEntry.cs |
| 50 | LoggerTypes.cs |
| 51 | SerilogWrapper.cs |
| 52 | UnmanagedMemory.cs |
| 53 | WikiLinks.cs |
| 54 | WolvenKit.Core.csproj |
| 55 | Wem.cs |

## Architecture

The analyzed files contain approximately **3008 lines** of code across **30 files** (of 55 total).

### Notable Types

- class ArgumentNullOrEmptyException
- class BinaryReaderExtensions
- class BineryWriterExtensions
- class CSharpCompilerTools
- class CommonFunctions
- class CompressionSettings
- class Constants
- class Crc32Algorithm
- class Crc32CAlgorithm
- class Crc64
- class DecompressionException
- class Ensure
- class EnumExtensions
- class IEnumerableExtensions
- class InvalidPtrException
- class KrakenNative
- class MismatchCRC32Exception
- class MissingRTTIException
- class MissingTypeException
- class Oodle
- class OodleLZNative
- class OodleLib
- class RandomExtensions
- class SafeProxy
- class SafeProxyC
- class StreamExtensions
- class StringExtensions
- class StringPathExtensions
- class TypeExtensions
- class TypeMismatchException
- class WolvenKitException
- class supports
- delegate int
- delegate long
- enum ArchiveManagerScope
- enum CheckCRC
- enum CompressionLevel
- enum Compressor
- enum EArchiveSource
- enum EArchiveType
- enum EBool
- enum EConvertableFileFormat
- enum EConvertableOutput
- enum ECookedFileFormat
- enum ECookedTextureFormat
- enum ECustomImageKeys
- enum EExportState
- enum EFileReadErrorCodes
- enum EGameLanguage
- enum EImportFlags

## Dependencies

- using Microsoft.Win32
- using Semver
- using System
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Runtime.InteropServices
- using System.Security.Cryptography
- using System.Text
- using System.Threading.Tasks
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Extensions

## Citations

[1] Source files under `WolvenKit.Core/CRC/` in the WolvenKit repository
