---
type: "System"
title: "RED4 JSON Conversion"
description: "JSON conversion system for RED4 types (RedFileDto, RedTypeDto, inkWidgetSerializer, JsonHeader) — 4 files."
resource: "WolvenKit.Common/Conversion/JsonHeader.cs"
tags: [common, conversion, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

JSON conversion system for RED4 types (RedFileDto, RedTypeDto, inkWidgetSerializer, JsonHeader) — 4 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **4 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| JsonHeader.cs | 28 | class DataTypes, class JsonHeader |
| RedFileDto.cs | 81 | class RedFileDto |
| RedTypeDto.cs | 17 | class RedTypeDto |
| inkWidgetSerializer.cs | 195 | class inkWidgetSerializer |

## Member Types

All **4** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | JsonHeader.cs |
| 2 | RedFileDto.cs |
| 3 | RedTypeDto.cs |
| 4 | inkWidgetSerializer.cs |

## Architecture

The analyzed files contain approximately **321 lines** of code across **4 files** (of 4 total).

### Notable Types

- class DataTypes
- class JsonHeader
- class RedFileDto
- class RedTypeDto
- class inkWidgetSerializer

## Dependencies

- using Semver
- using System
- using System.Collections.Generic
- using System.Reflection
- using System.Text.Json.Serialization
- using System.Xml
- using System.Xml.Schema
- using System.Xml.Serialization
- using WolvenKit.Core
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Archive.CR2W
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.Common/Conversion/` in the WolvenKit repository
