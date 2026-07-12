---
type: "Test"
title: "Unit Tests"
description: "Unit tests for binary extensions, compression, FNV1A, hash, filepath validation, murmur3, texconv, tweakdb, wwise — 11 files."
resource: "Tests/WolvenKit.UnitTests/App/Models/ProjectManagement/Project/Cp77ProjectTest.cs"
tags: [tests, unit, test]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Unit tests for binary extensions, compression, FNV1A, hash, filepath validation, murmur3, texconv, tweakdb, wwise — 11 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **13 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Cp77ProjectTest.cs | 49 | class Cp77ProjectTest |
| BinaryReaderExtensionTests.cs | 119 | class BinaryReaderExtensionTests |
| BinaryWriterExtensionTests.cs | 138 | class BinaryWriterExtensionTests |
| CompressionTests.cs | 113 | class CompressionTests |
| FNV1A64Tests.cs | 134 | class FNV1A64Tests |
| FilepathValidationToolsTests.cs | 110 | class FilepathValidationToolsTests |
| HashTests.cs | 293 | class HashTests, class MyComparer |
| Murmur3Tests.cs | 29 | class Murmur3Tests |
| oodle.txt | 118 | N/A |
| TexconvTests.cs | 205 | class TexconvTests |
| TweakDBTests.cs | 223 | class TweakDBTests |
| WolvenKit.UnitTests.csproj | 123 | N/A |
| WwiseTests.cs | 32 | class WwiseTests |

## Member Types

All **13** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Cp77ProjectTest.cs |
| 2 | BinaryReaderExtensionTests.cs |
| 3 | BinaryWriterExtensionTests.cs |
| 4 | CompressionTests.cs |
| 5 | FNV1A64Tests.cs |
| 6 | FilepathValidationToolsTests.cs |
| 7 | HashTests.cs |
| 8 | Murmur3Tests.cs |
| 9 | oodle.txt |
| 10 | TexconvTests.cs |
| 11 | TweakDBTests.cs |
| 12 | WolvenKit.UnitTests.csproj |
| 13 | WwiseTests.cs |

## Architecture

The analyzed files contain approximately **1686 lines** of code across **13 files** (of 13 total).

### Notable Types

- class BinaryReaderExtensionTests
- class BinaryWriterExtensionTests
- class CompressionTests
- class Cp77ProjectTest
- class FNV1A64Tests
- class FilepathValidationToolsTests
- class HashTests
- class Murmur3Tests
- class MyComparer
- class TexconvTests
- class TweakDBTests
- class WwiseTests

## Dependencies

- using Microsoft.IO
- using Microsoft.VisualStudio.TestTools.UnitTesting
- using System
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Runtime.InteropServices
- using System.Text
- using WolvenKit.App.Models.ProjectManagement.Project
- using WolvenKit.Common
- using WolvenKit.Common.DDS
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Model
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Extensions
- using WolvenKit.Core.Murmur3
- using WolvenKit.Core.Services
- using Xunit

## Citations

[1] Source files under `Tests/WolvenKit.UnitTests/App/Models/ProjectManagement/Project/` in the WolvenKit repository
