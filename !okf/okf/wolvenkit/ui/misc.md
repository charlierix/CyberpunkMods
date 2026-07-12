---
type: "ViewModel"
title: "WPF Misc ViewModels"
description: "WPF misc view models (curve editor, path editor, settings page, validators) — 5 files."
resource: "WolvenKit/ViewModels/CurveEditorViewModel.cs"
tags: [ui, viewmodels, misc, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

WPF misc view models (curve editor, path editor, settings page, validators) — 5 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CurveEditorViewModel.cs | 353 | class CurveEditorViewModel |
| PathEditor.cs | 90 | class FolderPathEditorBase, class MultiFolderPathEditor, class SingleFolderPathEditor, class MultiFilePathEditor, class SingleFilePathEditor |
| SettingsPageViewModel.cs | 23 | class SettingsPageViewModel |
| DepotPathValidationRule.cs | 38 | class DepotPathValidationRule |
| ItemNameValidationRule.cs | 36 | class ItemNameValidationRule |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CurveEditorViewModel.cs |
| 2 | PathEditor.cs |
| 3 | SettingsPageViewModel.cs |
| 4 | DepotPathValidationRule.cs |
| 5 | ItemNameValidationRule.cs |

## Architecture

The analyzed files contain approximately **540 lines** of code across **5 files** (of 5 total).

### Notable Types

- class CurveEditorViewModel
- class DepotPathValidationRule
- class FolderPathEditorBase
- class ItemNameValidationRule
- class MultiFilePathEditor
- class MultiFolderPathEditor
- class SettingsPageViewModel
- class SingleFilePathEditor
- class SingleFolderPathEditor

## Dependencies

- using Math = System.Math
- using Point = System.Windows.Point
- using Syncfusion.Windows.PropertyGrid
- using System
- using System.Collections.Generic
- using System.Collections.ObjectModel
- using System.ComponentModel
- using System.Linq
- using System.Reflection
- using System.Runtime.CompilerServices
- using System.Windows
- using System.Windows.Data
- using System.Windows.Input
- using System.Windows.Media
- using WolvenKit.App.Services
- using WolvenKit.App.ViewModels.HomePage
- using WolvenKit.App.ViewModels.Shell
- using WolvenKit.Common.Annotations
- using WolvenKit.RED4.Types
- using WolvenKit.Views.Editors

## Citations

[1] Source files under `WolvenKit/ViewModels/` in the WolvenKit repository
