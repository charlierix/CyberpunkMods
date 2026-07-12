---
type: "UI"
title: "WPF Value Converters"
description: "WPF value converters and data template selectors for UI binding — 34 files."
resource: "WolvenKit/Converters/BooleanToSfStepTypeConverter.cs"
tags: [ui, converters]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

WPF value converters and data template selectors for UI binding — 34 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **34 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| BooleanToSfStepTypeConverter.cs | 23 | class BooleanToSfStepTypeConverter |
| CellStyleConverter.cs | 20 | class CellStyleConverter |
| CollectionToCollectionConverter.cs | 45 | class CollectionToCollectionTypeConverter |
| CommonConverters.cs | 45 | class ValueConverterGroup, class LogColorConverter |
| DropdownTemplateSelector.cs | 24 | class DropdownTemplateSelector |
| EditableVariableDataTemplateSelector.cs | 45 | class EditableVariableDataTemplateSelector |
| EditorLevelToColorConverter.cs | 53 | class EditorLevelToColorConverter |
| EnumDescriptionConverter.cs | 35 | class EnumDescriptionConverter |
| ExtensionToImageConverter.cs | 307 | class ExtensionToImageConverter, class ExtensionToBitmapConverter |
| HasMenuChildrenVisibilityConverter.cs | 57 | class HasMenuChildrenVisibilityConverter |
| HeightMultiplierToPixelsConverter.cs | 28 | class HeightMultiplierToPixelsConverter |
| IGameArchiveToMenuItemStringConverter.cs | 28 | class IGameArchiveToMenuItemStringConverter |
| IRedTypeToCNameConverter.cs | 22 | class IRedTypeToCNameConverter |
| IntToVisibilityConverter.cs | 28 | class IntToVisibilityConverter, class IntToVisibilityConverterInverted |
| InverseBooleanToVisibilityConverter.cs | 24 | class InverseBooleanToVisibilityConverter |
| IsLastItemInContainerConverter.cs | 36 | class IsLastItemInContainerConverter |
| LessThanConverter.cs | 41 | class LessThanConverter |
| MathConverter.cs | 161 | class MathConverter |
| MsToSecondsConverter.cs | 24 | class MsToSecondsConverter |
| MultiBooleanToVisibilityConverter.cs | 29 | class MultiBooleanToVisibilityConverter |

## Member Types

All **34** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | BooleanToSfStepTypeConverter.cs |
| 2 | CellStyleConverter.cs |
| 3 | CollectionToCollectionConverter.cs |
| 4 | CommonConverters.cs |
| 5 | DropdownTemplateSelector.cs |
| 6 | EditableVariableDataTemplateSelector.cs |
| 7 | EditorLevelToColorConverter.cs |
| 8 | EnumDescriptionConverter.cs |
| 9 | ExtensionToImageConverter.cs |
| 10 | HasMenuChildrenVisibilityConverter.cs |
| 11 | HeightMultiplierToPixelsConverter.cs |
| 12 | IGameArchiveToMenuItemStringConverter.cs |
| 13 | IRedTypeToCNameConverter.cs |
| 14 | IntToVisibilityConverter.cs |
| 15 | InverseBooleanToVisibilityConverter.cs |
| 16 | IsLastItemInContainerConverter.cs |
| 17 | LessThanConverter.cs |
| 18 | MathConverter.cs |
| 19 | MsToSecondsConverter.cs |
| 20 | MultiBooleanToVisibilityConverter.cs |
| 21 | NodeIconConverter.cs |
| 22 | NullVisibilityConverter.cs |
| 23 | NumericConverters.cs |
| 24 | PathTypeToThicknessConverter.cs |
| 25 | PropertyGridEditors.cs |
| 26 | RedEditorTemplateSelector.cs |
| 27 | RedTypeToChunkViewModelCollectionConverter.cs |
| 28 | RedTypeToChunkViewModelConverter.cs |
| 29 | RelayCommandToVisibilityConverter.cs |
| 30 | StringColorConverter.cs |
| 31 | StringToBrushConverter.cs |
| 32 | TreeFlatIconConverter.cs |
| 33 | TreeViewItemTemplateSelector.cs |
| 34 | TweakDBIDConverter.cs |

## Architecture

The analyzed files contain approximately **2123 lines** of code across **30 files** (of 34 total).

### Notable Types

- class BaseTypeEditor
- class BooleanToSfStepTypeConverter
- class CFloatDoubleConverter
- class CellStyleConverter
- class ChunkPtrEditor
- class CollectionToCollectionTypeConverter
- class ColorEditor
- class CurveEditor
- class DropdownTemplateSelector
- class EditableVariableDataTemplateSelector
- class EditorLevelToColorConverter
- class EnumDescriptionConverter
- class EnumEditor
- class ExtensionToBitmapConverter
- class ExtensionToImageConverter
- class HasMenuChildrenVisibilityConverter
- class HeightMultiplierToPixelsConverter
- class IGameArchiveToMenuItemStringConverter
- class IRedTypeToCNameConverter
- class IntToVisibilityConverter
- class IntToVisibilityConverterInverted
- class InverseBooleanToVisibilityConverter
- class IsLastItemInContainerConverter
- class LessThanConverter
- class LogColorConverter
- class MathConverter
- class MsToSecondsConverter
- class MultiBooleanToVisibilityConverter
- class NodeIconConverter
- class NullVisibilityConverter
- class PathTypeToThicknessConverter
- class PropertyGridEditors
- class RedEditorTemplateSelector
- class RedTypeToChunkViewModelCollectionConverter
- class RedTypeToChunkViewModelConverter
- class RefEditor
- class RelayCommandToVisibilityConverter
- class StringColorConverter
- class ValueConverterGroup

## Dependencies

- using System
- using System.Collections.Generic
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Windows
- using System.Windows.Controls
- using System.Windows.Data
- using System.Windows.Media
- using WolvenKit.App.ViewModels.Shell
- using WolvenKit.App.ViewModels.Tools.EditorDifficultyLevel
- using WolvenKit.Common
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit/Converters/` in the WolvenKit repository
