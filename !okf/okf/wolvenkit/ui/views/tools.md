---
type: "UI"
title: "WPF Tool Views"
description: "WPF tool panel views (asset browser, project explorer, properties, log, etc.) — 20 files."
resource: "WolvenKit/Views/Tools/AssetBrowserView.xaml"
tags: [ui, views, tools]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

WPF tool panel views (asset browser, project explorer, properties, log, etc.) — 20 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **20 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AssetBrowserView.xaml | 201 | N/A |
| AssetBrowserView.xaml.cs | 271 | class AssetBrowserView |
| AudioPlayerView.xaml | 115 | N/A |
| AudioPlayerView.xaml.cs | 31 | class AudioPlayerView |
| HashToolView.xaml | 242 | N/A |
| HashToolView.xaml.cs | 88 | class HashToolView |
| LocKeyBrowserView.xaml | 216 | N/A |
| LocKeyBrowserView.xaml.cs | 45 | class LocKeyBrowserView |
| LogView.xaml | 225 | N/A |
| LogView.xaml.cs | 252 | class LogView, record LogEntry |
| ProjectExplorerView.xaml | 197 | N/A |
| ProjectExplorerView.xaml.cs | 234 | class ProjectExplorerView |
| PropertiesView.xaml | 200 | N/A |
| PropertiesView.xaml.cs | 87 | class PropertiesView |
| RedColorPicker.xaml | 107 | N/A |
| RedColorPicker.xaml.cs | 139 | class RedColorPicker |
| RedTreeView.xaml | 195 | N/A |
| RedTreeView.xaml.cs | 276 | class RedTreeView |
| TweakBrowserView.xaml | 216 | record type |
| TweakBrowserView.xaml.cs | 39 | class TweakBrowserView |

## Member Types

All **20** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AssetBrowserView.xaml |
| 2 | AssetBrowserView.xaml.cs |
| 3 | AudioPlayerView.xaml |
| 4 | AudioPlayerView.xaml.cs |
| 5 | HashToolView.xaml |
| 6 | HashToolView.xaml.cs |
| 7 | LocKeyBrowserView.xaml |
| 8 | LocKeyBrowserView.xaml.cs |
| 9 | LogView.xaml |
| 10 | LogView.xaml.cs |
| 11 | ProjectExplorerView.xaml |
| 12 | ProjectExplorerView.xaml.cs |
| 13 | PropertiesView.xaml |
| 14 | PropertiesView.xaml.cs |
| 15 | RedColorPicker.xaml |
| 16 | RedColorPicker.xaml.cs |
| 17 | RedTreeView.xaml |
| 18 | RedTreeView.xaml.cs |
| 19 | TweakBrowserView.xaml |
| 20 | TweakBrowserView.xaml.cs |

## Architecture

The analyzed files contain approximately **3376 lines** of code across **20 files** (of 20 total).

### Notable Types

- class AssetBrowserView
- class AudioPlayerView
- class HashToolView
- class LocKeyBrowserView
- class LogView
- class ProjectExplorerView
- class PropertiesView
- class RedColorPicker
- class RedTreeView
- class TweakBrowserView
- record LogEntry
- record type

## Dependencies

- using DynamicData
- using HandyControl.Data
- using HandyControl.Tools.Extension
- using MahApps.Metro.Controls
- using NAudioWpfDemo.AudioPlaybackDemo
- using ReactiveUI
- using Serilog.Events
- using Splat
- using Syncfusion.UI.Xaml.Grid
- using Syncfusion.UI.Xaml.ScrollAxis
- using Syncfusion.UI.Xaml.TreeGrid
- using System
- using System.Collections.ObjectModel
- using System.Diagnostics
- using System.IO
- using System.Linq
- using System.Reactive.Disposables
- using System.Reactive.Linq
- using System.Text.RegularExpressions
- using System.Windows

## Citations

[1] Source files under `WolvenKit/Views/Tools/` in the WolvenKit repository
