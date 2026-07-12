---
type: "Test"
title: "Functional Tests"
description: "Functional tests (CR2W read/write, ModKit, ModkitConvert, GameUnitTest) — 6 files."
resource: "Tests/WolvenKit.FunctionalTests/Cr2wReadTest.cs"
tags: [tests, functional, test]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Functional tests (CR2W read/write, ModKit, ModkitConvert, GameUnitTest) — 6 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **8 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Cr2wReadTest.cs | 340 | class Cr2wReadTest |
| Cr2wWriteTest.cs | 333 | class Cr2wWriteTest |
| GameUnitTest.cs | 132 | class GameUnitTest |
| ModKitTests.cs | 269 | class ModKitTests |
| TestResult.cs | 84 | class ReadTestResult, class TestResult, class WriteTestResult, class ArchiveTestResult, enum ReadResultType |
| ModkitConvertTests.cs | 335 | class ModkitConvertTests |
| WolvenKit.FunctionalTests.csproj | 66 | N/A |
| appsettings.json | 7 | N/A |

## Member Types

All **8** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Cr2wReadTest.cs |
| 2 | Cr2wWriteTest.cs |
| 3 | GameUnitTest.cs |
| 4 | ModKitTests.cs |
| 5 | TestResult.cs |
| 6 | ModkitConvertTests.cs |
| 7 | WolvenKit.FunctionalTests.csproj |
| 8 | appsettings.json |

## Architecture

The analyzed files contain approximately **1566 lines** of code across **8 files** (of 8 total).

### Notable Types

- class ArchiveTestResult
- class Cr2wReadTest
- class Cr2wWriteTest
- class GameUnitTest
- class ModKitTests
- class ModkitConvertTests
- class ReadTestResult
- class TestResult
- class WriteTestResult
- enum ReadResultType
- enum WriteResultType

## Dependencies

- using Microsoft.Extensions.Configuration
- using Microsoft.Extensions.DependencyInjection
- using Microsoft.Extensions.Hosting
- using Microsoft.VisualStudio.TestTools.UnitTesting
- using Serilog
- using Splat.Microsoft.Extensions.DependencyInjection
- using System
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Text
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Common.Interfaces
- using WolvenKit.Common.Model
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Common.Services
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Extensions

## Citations

[1] Source files under `Tests/WolvenKit.FunctionalTests/` in the WolvenKit repository
