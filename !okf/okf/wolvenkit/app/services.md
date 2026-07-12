---
type: "Service"
title: "App Services"
description: "Application services (ProjectManager, SettingsManager, AppScriptService, WatcherService, UpdateService, PluginService, NodeSelection, ArchiveManager, etc.) — 33 files."
resource: "WolvenKit.App/Services/AppArchiveManager.cs"
tags: [app, services, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Application services (ProjectManager, SettingsManager, AppScriptService, WatcherService, UpdateService, PluginService, NodeSelection, ArchiveManager, etc.) — 33 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **33 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AppArchiveManager.cs | 268 | class AppArchiveManager |
| AppHookService.cs | 34 | class AppHookService, delegate bool |
| AppIdleStateService.cs | 98 | class AppIdleStateService |
| AppScriptService.Hook.cs | 286 | class AppScriptService, record InvalidRTTIEventArgsWrapper, record InvalidEnumValueEventArgsWrapper |
| AppScriptService.Ui.cs | 112 | class AppScriptService |
| AppScriptService.cs | 109 | class AppScriptService |
| ArchiveXlItemService.cs | 290 | class ArchiveXlClothingItem, class ArchiveXlItemService |
| ConverterCacheService.cs | 54 | class ConverterCacheService, interface IConverterCacheService |
| GraphClipboardManager.cs | 106 | class GraphClipboardManager |
| HashServiceExt.cs | 204 | class HashServiceExt |
| IAppArchiveManager.cs | 24 | interface IAppArchiveManager |
| IModifierViewStateService.cs | 41 | interface IModifierViewStateService |
| INodeSelectionService.cs | 21 | interface INodeSelectionService |
| IPluginService.cs | 133 | class PluginExtensions, class IdAttribute, enum EPlugin, enum EPluginStatus, interface IPluginService |
| IProjectManager.cs | 18 | interface IProjectManager |
| IRefreshableDetails.cs | 13 | interface IRefreshableDetails |
| IScriptableControl.cs | 13 | interface IScriptableControl |
| ISettingsDto.cs | 86 | interface ISettingsDto |
| ISettingsManager.cs | 203 | interface ISettingsManager |
| IUpdateService.cs | 13 | interface IUpdateService |

## Member Types

All **33** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AppArchiveManager.cs |
| 2 | AppHookService.cs |
| 3 | AppIdleStateService.cs |
| 4 | AppScriptService.Hook.cs |
| 5 | AppScriptService.Ui.cs |
| 6 | AppScriptService.cs |
| 7 | ArchiveXlItemService.cs |
| 8 | ConverterCacheService.cs |
| 9 | GraphClipboardManager.cs |
| 10 | HashServiceExt.cs |
| 11 | IAppArchiveManager.cs |
| 12 | IModifierViewStateService.cs |
| 13 | INodeSelectionService.cs |
| 14 | IPluginService.cs |
| 15 | IProjectManager.cs |
| 16 | IRefreshableDetails.cs |
| 17 | IScriptableControl.cs |
| 18 | ISettingsDto.cs |
| 19 | ISettingsManager.cs |
| 20 | IUpdateService.cs |
| 21 | IWatcherService.cs |
| 22 | LocKeyServiceExt.cs |
| 23 | ModifierViewStateService.cs |
| 24 | NodePropertiesSelectionService.cs |
| 25 | NodePropertyUpdateService.cs |
| 26 | NodeSelectionService.cs |
| 27 | PluginService.cs |
| 28 | ProjectManager.cs |
| 29 | SettingsDto.cs |
| 30 | SettingsManager.cs |
| 31 | TimelineService.cs |
| 32 | UpdateService.cs |
| 33 | WatcherService.cs |

## Architecture

The analyzed files contain approximately **3847 lines** of code across **30 files** (of 33 total).

### Notable Types

- class AppArchiveManager
- class AppHookService
- class AppIdleStateService
- class AppScriptService
- class ArchiveXlClothingItem
- class ArchiveXlItemService
- class ConverterCacheService
- class EventSelectionRequestedEventArgs
- class GraphClipboardManager
- class HashServiceExt
- class IdAttribute
- class LocKeyServiceExt
- class ModifierViewStateService
- class NodePropertiesSelectionService
- class NodePropertyUpdateService
- class NodePropertyUpdatedEventArgs
- class NodeSelectionService
- class PluginExtensions
- class PluginService
- class ProjectManager
- class SettingsDto
- class SettingsManager
- delegate bool
- enum EPlugin
- enum EPluginStatus
- interface IAppArchiveManager
- interface IConverterCacheService
- interface IModifierViewStateService
- interface INodeSelectionService
- interface IPluginService
- interface IProjectManager
- interface IRefreshableDetails
- interface IScriptableControl
- interface ISettingsDto
- interface ISettingsManager
- interface IUpdateService
- interface IWatcherService
- record InvalidEnumValueEventArgsWrapper
- record InvalidRTTIEventArgsWrapper

## Dependencies

- using Microsoft.ClearScript.V8
- using Splat
- using System
- using System.Collections.Concurrent
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Runtime.CompilerServices
- using System.Threading
- using System.Threading.Tasks
- using System.Windows
- using WolvenKit.App.Controllers
- using WolvenKit.App.Helpers
- using WolvenKit.App.Interaction
- using WolvenKit.App.Models.ProjectManagement.Project
- using WolvenKit.App.Scripting
- using WolvenKit.App.ViewModels.GraphEditor
- using WolvenKit.App.ViewModels.Shell
- using WolvenKit.App.ViewModels.Tools

## Citations

[1] Source files under `WolvenKit.App/Services/` in the WolvenKit repository
