---
type: "Test"
title: "Integration Tests"
description: "Integration tests for ViewModels and tools — 2 files."
resource: "Tests/WolvenKit.IntegrationTests/App/ViewModels/Tools/ProjectExplorerConvertToJsonUITests.cs"
tags: [tests, integration, test]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Integration tests for ViewModels and tools — 2 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **3 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ProjectExplorerConvertToJsonUITests.cs | 166 | class Const, class ProjectExplorerConvertToJsonIntegrationTests |
| IntegrationTestHost.cs | 46 | class IntegrationTestHost |
| WolvenKit.IntegrationTests.csproj | 41 | N/A |

## Member Types

All **3** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ProjectExplorerConvertToJsonUITests.cs |
| 2 | IntegrationTestHost.cs |
| 3 | WolvenKit.IntegrationTests.csproj |

## Architecture

The analyzed files contain approximately **253 lines** of code across **3 files** (of 3 total).

### Notable Types

- class Const
- class IntegrationTestHost
- class ProjectExplorerConvertToJsonIntegrationTests

## Dependencies

- using Assert = Xunit.Assert
- using DynamicData
- using HandyControl.Tools
- using Microsoft.Extensions.DependencyInjection
- using Microsoft.Extensions.Hosting
- using Microsoft.VisualStudio.TestTools.UnitTesting
- using Splat
- using Splat.Microsoft.Extensions.DependencyInjection
- using System
- using System.IO
- using System.Linq
- using System.Text.RegularExpressions
- using System.Threading
- using System.Threading.Tasks
- using System.Windows.Threading
- using WolvenKit
- using WolvenKit.App.Controllers
- using WolvenKit.App.Helpers
- using WolvenKit.App.Models
- using WolvenKit.App.Models.ProjectManagement.Project

## Citations

[1] Source files under `Tests/WolvenKit.IntegrationTests/App/ViewModels/Tools/` in the WolvenKit repository
