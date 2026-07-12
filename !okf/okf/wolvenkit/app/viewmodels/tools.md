---
type: "ViewModel"
title: "Tool Panel ViewModels"
description: "Tool panel view models (AssetBrowser, ProjectExplorer, Properties, Log, HashTool, TweakBrowser, LocKeyBrowser, AudioPlayer) — 25 files."
resource: "WolvenKit.App/ViewModels/Tools/AssetBrowserViewModel.cs"
tags: [app, viewmodels, tools, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Tool panel view models (AssetBrowser, ProjectExplorer, Properties, Log, HashTool, TweakBrowser, LocKeyBrowser, AudioPlayer) — 25 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **25 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AssetBrowserViewModel.cs | 311 | class AssetBrowserViewModel, enum ESearchKeys |
| AudioPlayerViewModel.cs | 92 | class AudioPlayerViewModel |
| ChunkViewModel.ContextMenu.cs | 319 | class ChunkViewModel |
| ChunkViewModel.Descriptor.cs | 249 | class ChunkViewModel |
| ChunkViewModel.ExpansionStates.cs | 286 | class CustomLoopException, class ChunkViewModel |
| ChunkViewModel.MeshFunctions.cs | 67 | class ChunkViewModel |
| ChunkViewModel.SearchAndReplace.cs | 306 | class ChunkViewModel |
| ChunkViewModel.UserInteractionStates.cs | 180 | class ChunkViewModel |
| ChunkViewModel.Value.cs | 278 | class ChunkViewModel |
| CollectionItemViewModel.cs | 53 | class CollectionItemViewModel |
| EditorDifficultyLevel.cs | 9 | enum EditorDifficultyLevel |
| EditorDifficultyLevelFieldFactory.cs | 249 | class to, class per, class EditorDifficultyLevelInformation |
| ExportableItemViewModel.cs | 67 | class ExportableItemViewModel |
| FileSystemViewModel.cs | 25 | class FileSystemViewModel |
| HashToolViewModel.cs | 8 | class HashToolViewModel |
| ImportExportItemViewModel.cs | 54 | class ImportExportItemViewModel |
| ImportableItemViewModel.cs | 196 | class ImportableItemViewModel |
| LocKeyBrowserViewModel.cs | 148 | class LocKeyBrowserViewModel, record LocKeyViewModel |
| LogViewModel.cs | 165 | class LogViewModel |
| ProjectExplorerViewModel.cs | 292 | class ProjectExplorerViewModel |

## Member Types

All **25** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AssetBrowserViewModel.cs |
| 2 | AudioPlayerViewModel.cs |
| 3 | ChunkViewModel.ContextMenu.cs |
| 4 | ChunkViewModel.Descriptor.cs |
| 5 | ChunkViewModel.ExpansionStates.cs |
| 6 | ChunkViewModel.MeshFunctions.cs |
| 7 | ChunkViewModel.SearchAndReplace.cs |
| 8 | ChunkViewModel.UserInteractionStates.cs |
| 9 | ChunkViewModel.Value.cs |
| 10 | CollectionItemViewModel.cs |
| 11 | EditorDifficultyLevel.cs |
| 12 | EditorDifficultyLevelFieldFactory.cs |
| 13 | ExportableItemViewModel.cs |
| 14 | FileSystemViewModel.cs |
| 15 | HashToolViewModel.cs |
| 16 | ImportExportItemViewModel.cs |
| 17 | ImportableItemViewModel.cs |
| 18 | LocKeyBrowserViewModel.cs |
| 19 | LogViewModel.cs |
| 20 | ProjectExplorerViewModel.cs |
| 21 | PropertiesViewModel.cs |
| 22 | RedDirectoryViewModel.cs |
| 23 | RedFileViewModel.cs |
| 24 | ToolViewModel.cs |
| 25 | TweakBrowserViewModel.cs |

## Architecture

The analyzed files contain approximately **4111 lines** of code across **25 files** (of 25 total).

### Notable Types

- class AssetBrowserViewModel
- class AudioPlayerViewModel
- class ChunkViewModel
- class CollectionItemViewModel
- class CustomLoopException
- class EditorDifficultyLevelInformation
- class ExportableItemViewModel
- class FileSystemViewModel
- class HashToolViewModel
- class ImportExportItemViewModel
- class ImportableItemViewModel
- class LocKeyBrowserViewModel
- class LogViewModel
- class ProjectExplorerViewModel
- class PropertiesViewModel
- class RedDirectoryViewModel
- class RedFileViewModel
- class ToolViewModel
- class TweakBrowserViewModel
- class per
- class to
- enum AudioPreviewExtensions
- enum ESearchKeys
- enum EditorDifficultyLevel
- enum MeshPreviewExtensions
- enum TexturePreviewExtensions
- record LocKeyViewModel
- record in

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using CommunityToolkit.Mvvm.Input
- using DynamicData
- using Microsoft.EntityFrameworkCore
- using Microsoft.Win32
- using NAudio.Extras
- using NAudioWpfDemo.AudioPlaybackDemo
- using System
- using System.Collections
- using System.Collections.Generic
- using System.Collections.ObjectModel
- using System.Diagnostics.CodeAnalysis
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Text.RegularExpressions
- using System.Threading
- using System.Threading.Tasks
- using System.Windows

## Citations

[1] Source files under `WolvenKit.App/ViewModels/Tools/` in the WolvenKit repository
