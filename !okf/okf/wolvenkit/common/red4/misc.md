---
type: "System"
title: "RED4 Common Utilities"
description: "RED4 common utilities (CommonFunctions, GeometryCacheReader, Red4ParserService, RedImage) — 17 files."
resource: "WolvenKit.Common/RED4/CR2W/JSON/Arrays.cs"
tags: [common, red4, misc, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

RED4 common utilities (CommonFunctions, GeometryCacheReader, Red4ParserService, RedImage) — 17 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **12 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Arrays.cs | 320 | class ArrayConverterFactory, class CArrayConverter, class CArrayFixedSizeConverter, class CStaticConverter |
| CustomRedConverter.cs | 23 | class CustomRedConverter |
| Enums.cs | 75 | class EnumConverterFactory, class CBitFieldConverter, class CEnumConverter |
| Fundamentals.cs | 142 | class CBoolConverter, class CDoubleConverter, class CFloatConverter, class CInt8Converter, class CInt16Converter |
| ICustomRedConverter.cs | 13 | interface ICustomRedConverter |
| ParseableBuffers.cs | 269 | class ParseableBufferConverter, class CollisionShapeConverter, class RazerChromaAnimationBufferConverter |
| PrimitiveConverter.cs | 342 | class CByteArrayConverter, class CKeyValuePairConverter, class HandleConverterFactory, class HandleConverter, class ResourceConverterFactory |
| RedFileDtoConverter.cs | 325 | class RedFileDtoConverter |
| RedJsonPatches.cs | 13 | class RedJsonPatches |
| RedJsonSerializer.cs | 254 | class RedJsonSerializer |
| RedJsonSerializerOptions.cs | 7 | class RedJsonSerializerOptions |
| Simples.cs | 317 | class CDateTimeConverter, class CGuidConverter, class CNameConverter, class CRUIDConverter, class CStringConverter |

## Member Types

All **12** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Arrays.cs |
| 2 | CustomRedConverter.cs |
| 3 | Enums.cs |
| 4 | Fundamentals.cs |
| 5 | ICustomRedConverter.cs |
| 6 | ParseableBuffers.cs |
| 7 | PrimitiveConverter.cs |
| 8 | RedFileDtoConverter.cs |
| 9 | RedJsonPatches.cs |
| 10 | RedJsonSerializer.cs |
| 11 | RedJsonSerializerOptions.cs |
| 12 | Simples.cs |

## Architecture

The analyzed files contain approximately **2100 lines** of code across **12 files** (of 12 total).

### Notable Types

- class ArrayConverterFactory
- class BufferConverterFactory
- class CArrayConverter
- class CArrayFixedSizeConverter
- class CBitFieldConverter
- class CBoolConverter
- class CByteArrayConverter
- class CDateTimeConverter
- class CDoubleConverter
- class CEnumConverter
- class CFloatConverter
- class CGuidConverter
- class CInt16Converter
- class CInt32Converter
- class CInt64Converter
- class CInt8Converter
- class CKeyValuePairConverter
- class CNameConverter
- class CRUIDConverter
- class CStaticConverter
- class CStringConverter
- class CUInt16Converter
- class CUInt32Converter
- class CUInt64Converter
- class CUInt8Converter
- class CVariantConverter
- class CollisionShapeConverter
- class CustomRedConverter
- class DataBufferConverter
- class EnumConverterFactory
- class HandleConverter
- class HandleConverterFactory
- class ParseableBufferConverter
- class RazerChromaAnimationBufferConverter
- class RedFileDtoConverter
- class RedJsonPatches
- class RedJsonSerializer
- class RedJsonSerializerOptions
- class ResourceConverterFactory
- class ResourceReferenceConverter
- interface ICustomRedConverter

## Dependencies

- using Microsoft.EntityFrameworkCore.Metadata.Internal
- using Semver
- using System
- using System.Buffers
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.ComponentModel
- using System.Drawing
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Text.Encodings.Web
- using System.Text.Json
- using System.Text.Json.Serialization
- using System.Text.Json.Serialization.Metadata
- using System.Text.Unicode
- using System.Threading.Tasks
- using WolvenKit.Common.Conversion
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Archive

## Citations

[1] Source files under `WolvenKit.Common/RED4/CR2W/JSON/` in the WolvenKit repository
