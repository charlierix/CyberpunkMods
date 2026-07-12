---
type: "Service"
title: "App Misc Helpers"
description: "Miscellaneous app helpers (file, archive, debug, discord, git, image, log, Medusa, etc.) — 40 files."
resource: "WolvenKit.App/Helpers/AppFileHelper.cs"
tags: [app, helpers, misc, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Miscellaneous app helpers (file, archive, debug, discord, git, image, log, Medusa, etc.) — 40 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **40 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AppFileHelper.cs | 138 | class AppFileHelper |
| ArchiveXlHelper.cs | 266 | class will, class ArchiveXlHelper |
| CvmDependencyTools.cs | 149 | class CvmDependencyTools |
| CvmMaterialTools.cs | 272 | class CvmMaterialTools |
| CvmTools.cs | 55 | class CvmTools |
| ICvmTools.cs | 32 | interface ICvmTools |
| CollectionViewHelper.cs | 130 | class CollectionViewHelper |
| Commonfunctions.cs | 272 | class Commonfunctions |
| Cr2WTools.cs | 139 | class Cr2WTools |
| CvmDropdownHelper.cs | 241 | class takes, class CvmDropdownHelper |
| Debug_Helpers.cs | 9 | class WolvenDBG |
| DesktopBridgeHelper.cs | 66 | class DesktopBridgeHelper |
| DiscordHelper.cs | 89 | class DiscordHelper |
| DispatcherHelper.cs | 144 | class DispatcherHelper |
| DocumentTools.cs | 306 | class MultilayerProperties, class DocumentTools, class FilteredCacheEntry, record JournalPathOption |
| ExportArgsWrapper.cs | 39 | class ExportArgsWrapper |
| FilePathHelper.cs | 25 | class FilePathHelper |
| FolderPicker.cs | 205 | class FolderPicker, class FileOpenDialog, enum values, enum SIGDN, enum FOS |
| GitHelper.cs | 119 | class GitHelper |
| ImageDecoder.cs | 92 | class ImageDecoder, class XenConverter |

## Member Types

All **40** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AppFileHelper.cs |
| 2 | ArchiveXlHelper.cs |
| 3 | CvmDependencyTools.cs |
| 4 | CvmMaterialTools.cs |
| 5 | CvmTools.cs |
| 6 | ICvmTools.cs |
| 7 | CollectionViewHelper.cs |
| 8 | Commonfunctions.cs |
| 9 | Cr2WTools.cs |
| 10 | CvmDropdownHelper.cs |
| 11 | Debug_Helpers.cs |
| 12 | DesktopBridgeHelper.cs |
| 13 | DiscordHelper.cs |
| 14 | DispatcherHelper.cs |
| 15 | DocumentTools.cs |
| 16 | ExportArgsWrapper.cs |
| 17 | FilePathHelper.cs |
| 18 | FolderPicker.cs |
| 19 | GitHelper.cs |
| 20 | ImageDecoder.cs |
| 21 | ImportArgsWrapper.cs |
| 22 | ImportExportHelper.cs |
| 23 | InkCache.cs |
| 24 | InkWidgetHelper.cs |
| 25 | InkatlasImageGenerator.cs |
| 26 | ProcessHelper.cs |
| 27 | ProjectResourceTools.cs |
| 28 | RegistryHelpers.cs |
| 29 | SceneEditingHelper.cs |
| 30 | StringHelper.cs |
| 31 | StringHelperAnimNode.cs |
| 32 | StringHelperWorldNode.cs |
| 33 | TemplateFileTools.cs |
| 34 | TemplateFileTools.RadioExt.cs |
| 35 | TestHelper.cs |
| 36 | TimelineColorHelper.cs |
| 37 | TypeHelper.cs |
| 38 | UIHelper.cs |
| 39 | Win32.cs |
| 40 | YamlHelper.cs |

## Architecture

The analyzed files contain approximately **4351 lines** of code across **30 files** (of 40 total).

### Notable Types

- class AppFileHelper
- class ArchiveXlHelper
- class CollectionViewHelper
- class Commonfunctions
- class Cr2WTools
- class CvmDependencyTools
- class CvmDropdownHelper
- class CvmMaterialTools
- class CvmTools
- class DesktopBridgeHelper
- class DiscordHelper
- class DispatcherHelper
- class DocumentTools
- class ExportArgsWrapper
- class FileOpenDialog
- class FilePathHelper
- class FilteredCacheEntry
- class FolderPicker
- class GitHelper
- class ImageDecoder
- class ImportArgsWrapper
- class ImportExportHelper
- class InkCache
- class InkWidgetHelper
- class InkatlasImageGenerator
- class MultilayerProperties
- class ProcessHelper
- class ProjectResourceTools
- class RegistryHelpers
- class SceneEditingHelper
- class StringHelper
- class WolvenDBG
- class XenConverter
- class for
- class takes
- class will
- enum FOS
- enum SIGDN
- enum values
- interface ICvmTools
- interface IFileOpenDialog
- interface IShellItem
- record JournalPathOption

## Dependencies

- using ICSharpCode.SharpZipLib.Core
- using ICSharpCode.SharpZipLib.Zip
- using Microsoft.Win32
- using Splat
- using System
- using System.Collections.Generic
- using System.ComponentModel
- using System.Diagnostics
- using System.IO
- using System.Linq
- using System.Threading
- using System.Windows.Data
- using System.Xml
- using System.Xml.Linq
- using WolvenKit.App.ViewModels.Documents
- using WolvenKit.App.ViewModels.Shell
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.App/Helpers/` in the WolvenKit repository
