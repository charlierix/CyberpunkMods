---
type: "Service"
title: "Common Services"
description: "Shared services (Hash, TweakDB, LocKey, CRUID, GeometryCache, Progress, Hook, WolvenTesting) — 14 files."
resource: "WolvenKit.Common/Services/CRUIDService.cs"
tags: [common, services, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Shared services (Hash, TweakDB, LocKey, CRUID, GeometryCache, Progress, Hook, WolvenTesting) — 14 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **14 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CRUIDService.cs | 122 | class CRUIDService |
| GeometryCacheService.cs | 153 | class GeometryCacheService |
| HashService.cs | 271 | class HashService |
| HookService.cs | 35 | class HookService, delegate void, delegate void, delegate void, delegate bool |
| IHookService.cs | 22 | interface IHookService |
| ILocKeyService.cs | 23 | interface ILocKeyService |
| IRedParserService.cs | 15 | interface IRedParserService |
| ISelectableTreeViewItemModel.cs | 8 | interface ISelectableTreeViewItemModel |
| IWindowFactory.cs | 50 | class PackSettings, interface IWindowFactory |
| LocKeyService.cs | 115 | class LocKeyService |
| PercentProgressService.cs | 55 | class PercentProgressService |
| ProgressService.cs | 166 | class ProgressService, class ProgressStatics, delegate used |
| TweakDBService.cs | 128 | class TweakDBService |
| WolvenTesting.cs | 11 | class WolvenTesting |

## Member Types

All **14** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CRUIDService.cs |
| 2 | GeometryCacheService.cs |
| 3 | HashService.cs |
| 4 | HookService.cs |
| 5 | IHookService.cs |
| 6 | ILocKeyService.cs |
| 7 | IRedParserService.cs |
| 8 | ISelectableTreeViewItemModel.cs |
| 9 | IWindowFactory.cs |
| 10 | LocKeyService.cs |
| 11 | PercentProgressService.cs |
| 12 | ProgressService.cs |
| 13 | TweakDBService.cs |
| 14 | WolvenTesting.cs |

## Architecture

The analyzed files contain approximately **1174 lines** of code across **14 files** (of 14 total).

### Notable Types

- class CRUIDService
- class GeometryCacheService
- class HashService
- class HookService
- class LocKeyService
- class PackSettings
- class PercentProgressService
- class ProgressService
- class ProgressStatics
- class TweakDBService
- class WolvenTesting
- delegate bool
- delegate used
- delegate void
- interface IHookService
- interface ILocKeyService
- interface IRedParserService
- interface ISelectableTreeViewItemModel
- interface IWindowFactory

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using System
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.ComponentModel
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Text.Json
- using System.Threading.Tasks
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Model
- using WolvenKit.Common.WinFormsEnums
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Extensions
- using WolvenKit.Core.Helpers
- using WolvenKit.Core.Interfaces
- using WolvenKit.Core.Unmanaged
- using WolvenKit.RED4.Archive.CR2W

## Citations

[1] Source files under `WolvenKit.Common/Services/` in the WolvenKit repository
