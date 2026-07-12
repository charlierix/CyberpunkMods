---
type: "System"
title: "Compression (Oodle/Kraken)"
description: "Oodle/Kraken compression system (Oodle, OodleLib, KrakenNative, OodleLZNative, CompressionSettings) — 5 files."
resource: "WolvenKit.Core/Compression/CompressionSettings.cs"
tags: [core, compression, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Oodle/Kraken compression system (Oodle, OodleLib, KrakenNative, OodleLZNative, CompressionSettings) — 5 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CompressionSettings.cs | 22 | class CompressionSettings |
| KrakenNative.cs | 41 | class KrakenNative |
| Oodle.cs | 300 | class Oodle, enum Compressor, enum CompressionLevel, enum FuzzSafe, enum CheckCRC |
| OodleLZNative.cs | 34 | class OodleLZNative |
| OodleLib.cs | 163 | class OodleLib, delegate int, delegate int, delegate long, delegate int |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CompressionSettings.cs |
| 2 | KrakenNative.cs |
| 3 | Oodle.cs |
| 4 | OodleLZNative.cs |
| 5 | OodleLib.cs |

## Architecture

The analyzed files contain approximately **560 lines** of code across **5 files** (of 5 total).

### Notable Types

- class CompressionSettings
- class KrakenNative
- class Oodle
- class OodleLZNative
- class OodleLib
- delegate int
- delegate long
- enum CheckCRC
- enum CompressionLevel
- enum Compressor
- enum FuzzSafe
- enum Status
- enum ThreadPhase
- enum Verbosity

## Dependencies

- using System
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Runtime.InteropServices
- using System.Threading.Tasks
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Extensions
- using static WolvenKit.Core.Compression.Oodle

## Citations

[1] Source files under `WolvenKit.Core/Compression/` in the WolvenKit repository
