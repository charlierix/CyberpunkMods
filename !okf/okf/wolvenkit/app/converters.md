---
type: "UI"
title: "App Value Converters"
description: "Application value converters for WPF binding — 8 files."
resource: "WolvenKit.App/Converters/ActiveDocumentConverter.cs"
tags: [app, converters, ui]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Application value converters for WPF binding — 8 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **8 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ActiveDocumentConverter.cs | 33 | class ActiveDocumentConverter |
| BoolToBrushConverter.cs | 34 | class BoolToBrushConverter |
| ColorToSolidColorBrushConverter.cs | 22 | class ColorToSolidColorBrushConverter |
| FlowToDirectionConverter.cs | 31 | class FlowToDirectionConverter |
| JsonArchiveConverter.cs | 15 | class JsonArchiveConverter |
| JsonFileEntryConverter.cs | 51 | class JsonFileEntryConverter |
| ListToStringConverter.cs | 72 | class ListToStringConverter |
| StringPathToItemStringConverter.cs | 19 | class StringPathToItemStringConverter |

## Member Types

All **8** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ActiveDocumentConverter.cs |
| 2 | BoolToBrushConverter.cs |
| 3 | ColorToSolidColorBrushConverter.cs |
| 4 | FlowToDirectionConverter.cs |
| 5 | JsonArchiveConverter.cs |
| 6 | JsonFileEntryConverter.cs |
| 7 | ListToStringConverter.cs |
| 8 | StringPathToItemStringConverter.cs |

## Architecture

The analyzed files contain approximately **277 lines** of code across **8 files** (of 8 total).

### Notable Types

- class ActiveDocumentConverter
- class BoolToBrushConverter
- class ColorToSolidColorBrushConverter
- class FlowToDirectionConverter
- class JsonArchiveConverter
- class JsonFileEntryConverter
- class ListToStringConverter
- class StringPathToItemStringConverter

## Dependencies

- using Nodify
- using System
- using System.Collections.Generic
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Text
- using System.Text.Json
- using System.Text.Json.Serialization
- using System.Text.RegularExpressions
- using System.Windows.Data
- using System.Windows.Media
- using WolvenKit.App.ViewModels.Documents
- using WolvenKit.Common
- using WolvenKit.Common.FNV1A
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Archive

## Citations

[1] Source files under `WolvenKit.App/Converters/` in the WolvenKit repository
