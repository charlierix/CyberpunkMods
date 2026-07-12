---
type: "ViewModel"
title: "Shell ViewModels"
description: "Main application shell view models (AppViewModel, ChunkViewModel, MenuBar, Ribbon, StatusBar, Red*ViewModels) — 14 files."
resource: "WolvenKit.App/ViewModels/Shell/AppViewModel.ComplexFiles.cs"
tags: [app, viewmodels, shell, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Main application shell view models (AppViewModel, ChunkViewModel, MenuBar, Ribbon, StatusBar, Red*ViewModels) — 14 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **14 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AppViewModel.ComplexFiles.cs | 257 | class AppViewModel |
| AppViewModel.WScript.cs | 272 | class AppViewModel |
| AppViewModel.cs | 274 | class AppViewModel, class DockedViewVisibleChangedEventArgs |
| ChunkPropertyViewModel.cs | 86 | class ChunkPropertyViewModel |
| ChunkViewModel.cs | 287 | class ChunkViewModel |
| GroupedChunkViewModel.cs | 24 | class GroupedChunkViewModel |
| IAppViewModel.cs | 63 | interface IAppViewModel |
| MenuBarViewModel.cs | 191 | class MenuBarViewModel |
| PaneViewModel.cs | 45 | class PaneViewModel |
| RedBoolViewModel.cs | 10 | class RedBoolViewModel |
| RedColorViewModel.cs | 34 | class RedColorViewModel |
| RedStringViewModel.cs | 9 | class RedStringViewModel |
| RibbonViewModel.cs | 111 | class RibbonViewModel |
| StatusBarViewModel.cs | 125 | class StatusBarViewModel |

## Member Types

All **14** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AppViewModel.ComplexFiles.cs |
| 2 | AppViewModel.WScript.cs |
| 3 | AppViewModel.cs |
| 4 | ChunkPropertyViewModel.cs |
| 5 | ChunkViewModel.cs |
| 6 | GroupedChunkViewModel.cs |
| 7 | IAppViewModel.cs |
| 8 | MenuBarViewModel.cs |
| 9 | PaneViewModel.cs |
| 10 | RedBoolViewModel.cs |
| 11 | RedColorViewModel.cs |
| 12 | RedStringViewModel.cs |
| 13 | RibbonViewModel.cs |
| 14 | StatusBarViewModel.cs |

## Architecture

The analyzed files contain approximately **1788 lines** of code across **14 files** (of 14 total).

### Notable Types

- class AppViewModel
- class ChunkPropertyViewModel
- class ChunkViewModel
- class DockedViewVisibleChangedEventArgs
- class GroupedChunkViewModel
- class MenuBarViewModel
- class PaneViewModel
- class RedBoolViewModel
- class RedColorViewModel
- class RedStringViewModel
- class RibbonViewModel
- class StatusBarViewModel
- interface IAppViewModel

## Dependencies

- using CKeyValuePair = WolvenKit.RED4.Types.CKeyValuePair
- using CommunityToolkit.Mvvm.ComponentModel
- using CommunityToolkit.Mvvm.Input
- using DynamicData
- using DynamicData.Binding
- using FileSystem = Microsoft.VisualBasic.FileIO.FileSystem
- using IRedArray = WolvenKit.RED4.Types.IRedArray
- using IRedString = WolvenKit.RED4.Types.IRedString
- using ISerializable = WolvenKit.RED4.Types.ISerializable
- using Mat4 = System.Numerics.Matrix4x4
- using Microsoft.Extensions.Logging
- using Microsoft.VisualBasic.FileIO
- using Microsoft.Win32
- using NativeMethods = WolvenKit.App.Helpers.NativeMethods
- using Octokit
- using Quat = System.Numerics.Quaternion
- using Rect = System.Windows.Rect
- using Semver
- using System
- using System.Collections

## Citations

[1] Source files under `WolvenKit.App/ViewModels/Shell/` in the WolvenKit repository
