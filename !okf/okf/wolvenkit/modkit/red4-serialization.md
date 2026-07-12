---
type: "System"
title: "Modkit RED4 Serialization"
description: "RED4 serialization system (JSON/YAML serialization, TweakDocument) — 5 files."
resource: "WolvenKit.Modkit/RED4/Serialization/Serialization.cs"
tags: [modkit, red4, serialization, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

RED4 serialization system (JSON/YAML serialization, TweakDocument) — 5 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **7 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Serialization.cs | 276 | class Serialization, class Yaml, class Json |
| TweakDocument.cs | 13 | class TweakDocument |
| CArrayConverter.cs | 86 | class CArrayConverter, class CArrayConverterInner |
| Converters.cs | 220 | class CFloatJsonConverter, class CBoolJsonConverter, class CUint8JsonConverter, class CUint16JsonConverter, class CUint32JsonConverter |
| ITypeConverterWithTypeDiscriminator.cs | 126 | class ITypeConverterWithTypeDiscriminator, interface to |
| IParserExtensions.cs | 49 | class IParserExtensions |
| TweakTypeConverter.cs | 232 | class TweakTypeConverter |

## Member Types

All **7** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Serialization.cs |
| 2 | TweakDocument.cs |
| 3 | CArrayConverter.cs |
| 4 | Converters.cs |
| 5 | ITypeConverterWithTypeDiscriminator.cs |
| 6 | IParserExtensions.cs |
| 7 | TweakTypeConverter.cs |

## Architecture

The analyzed files contain approximately **1002 lines** of code across **7 files** (of 7 total).

### Notable Types

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
- class IParserExtensions
- class ITypeConverterWithTypeDiscriminator
- class Json
- class Serialization
- class TweakDocument
- class TweakTypeConverter
- class Yaml
- interface to

## Dependencies

- using Activator = System.Activator
- using System
- using System.Collections
- using System.Collections.Generic
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Text.Json
- using System.Text.Json.Serialization
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.TweakDB
- using WolvenKit.RED4.Types
- using YamlDotNet.Core
- using YamlDotNet.Core.Events
- using YamlDotNet.Core.Tokens
- using YamlDotNet.Serialization

## Citations

[1] Source files under `WolvenKit.Modkit/RED4/Serialization/` in the WolvenKit repository
