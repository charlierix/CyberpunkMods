---
type: "Test"
title: "Test Utilities"
description: "Test utility classes (DumpInfo, GameUnitTest, RedDatabase) — 3 files."
resource: "Tests/WolvenKit.Utility/DumpInfo.cs"
tags: [tests, utility, test]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Test utility classes (DumpInfo, GameUnitTest, RedDatabase) — 3 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| DumpInfo.cs | 262 | class DumpInfo |
| GameUnitTest.cs | 147 | class GameUnitTest |
| RedDatabase.cs | 171 | class RedDatabase, record ArchiveRecord |
| WolvenKit.Utility.csproj | 49 | N/A |
| appsettings.json | 7 | N/A |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | DumpInfo.cs |
| 2 | GameUnitTest.cs |
| 3 | RedDatabase.cs |
| 4 | WolvenKit.Utility.csproj |
| 5 | appsettings.json |

## Architecture

The analyzed files contain approximately **636 lines** of code across **5 files** (of 5 total).

### Notable Types

- class DumpInfo
- class GameUnitTest
- class RedDatabase
- record ArchiveRecord

## Dependencies

- using EFCore.BulkExtensions
- using EFileReadErrorCodes = WolvenKit.RED4.Archive.IO.EFileReadErrorCodes
- using Microsoft.Extensions.Configuration
- using Microsoft.Extensions.DependencyInjection
- using Microsoft.Extensions.Hosting
- using Microsoft.VisualStudio.TestTools.UnitTesting
- using Serilog
- using Splat
- using Splat.Microsoft.Extensions.DependencyInjection
- using System
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Text.Json
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Interfaces
- using WolvenKit.Common.Model.Database

## Citations

[1] Source files under `Tests/WolvenKit.Utility/` in the WolvenKit repository
