---
type: "System"
title: "CRC Hash Algorithms"
description: "CRC hash algorithms (CRC32, CRC32C, CRC64) and safe proxy implementations — 6 files."
resource: "WolvenKit.Core/CRC/CRC64Algo.cs"
tags: [core, crc, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

CRC hash algorithms (CRC32, CRC32C, CRC64) and safe proxy implementations — 6 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **6 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CRC64Algo.cs | 91 | class Crc64 |
| Crc32Algorithm.cs | 184 | class supports, class Crc32Algorithm |
| Crc32CAlgorithm.cs | 197 | class supports, class Crc32CAlgorithm |
| MismatchCRC32Exception.cs | 24 | class MismatchCRC32Exception |
| SafeProxy.cs | 92 | class SafeProxy |
| SafeProxyC.cs | 24 | class SafeProxyC |

## Member Types

All **6** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CRC64Algo.cs |
| 2 | Crc32Algorithm.cs |
| 3 | Crc32CAlgorithm.cs |
| 4 | MismatchCRC32Exception.cs |
| 5 | SafeProxy.cs |
| 6 | SafeProxyC.cs |

## Architecture

The analyzed files contain approximately **612 lines** of code across **6 files** (of 6 total).

### Notable Types

- class Crc32Algorithm
- class Crc32CAlgorithm
- class Crc64
- class MismatchCRC32Exception
- class SafeProxy
- class SafeProxyC
- class supports

## Dependencies

- using System
- using System.Security.Cryptography
- using System.Text

## Citations

[1] Source files under `WolvenKit.Core/CRC/` in the WolvenKit repository
