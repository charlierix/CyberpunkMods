---
type: "ViewModel"
title: "Dialog ViewModels"
description: "Dialog view models for user interactions (file operations, project settings, import/export, materials, etc.) — 47 files."
resource: "WolvenKit.App/ViewModels/Dialogs/AddArchiveXlFilesDialogViewModel.cs"
tags: [app, viewmodels, dialogs, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Dialog view models for user interactions (file operations, project settings, import/export, materials, etc.) — 47 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **47 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AddArchiveXlFilesDialogViewModel.cs | 153 | class AddArchiveXlFilesDialogViewModel |
| AddInkatlasDialogViewModel.cs | 95 | class AddInkatlasDialogViewModel |
| AddItemsToStoreDialogViewModel.cs | 66 | class AddItemsToStoreDialogViewModel |
| AddPropFileDialogViewModel.cs | 154 | class AddPropFileDialogViewModel |
| AddQuestDialogViewModel.cs | 14 | class AddQuestDialogViewModel |
| AddRadioExtFilesDialogViewModel.cs | 175 | class RadioSongItem, class AddRadioExtFilesDialogViewModel |
| ChangeComponentPropertiesDialogViewModel.cs | 57 | class ChangeComponentPropertiesDialogViewModel |
| ChooseCollectionViewModel.cs | 71 | class ChooseCollectionViewModel, interface IDisplayable |
| ConvertHairToCCXLMaterialsDialogViewModel.cs | 46 | class ConvertHairToCCXLMaterialsDialogViewModel |
| CopyMeshAppearancesDialogViewModel.cs | 97 | class CopyMeshAppearancesDialogViewModel |
| CreateMaterialsDialogViewModel.cs | 30 | class CreateMaterialsDialogViewModel |
| CreatePhotoModeAppViewModel.cs | 288 | class CreatePhotoModeAppViewModel |
| DeleteOrDuplicateComponentDialogViewModel.cs | 60 | class DeleteOrDuplicateComponentDialogViewModel |
| DeleteOrMoveFilesListDialogViewModel.cs | 24 | class DeleteOrMoveFilesListDialogViewModel |
| DialogViewModel.cs | 19 | class DialogViewModel, class DialogWindowViewModel, delegate void |
| ExportArgsDialogViewModel.cs | 227 | class ExportArgsDialogViewModel |
| ExtractAmbigiousDialogViewModel.cs | 10 | class ExtractAmbigiousDialogViewModel |
| ExtractEmbeddedFileDialogViewModel.cs | 40 | class ExtractEmbeddedFileDialogViewModel |
| FirstSetupViewModel.cs | 293 | class FirstSetupViewModel, delegate void |
| FolderPathInputDialogViewModel.cs | 55 | class FolderPathInputDialogViewModel |

## Member Types

All **47** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AddArchiveXlFilesDialogViewModel.cs |
| 2 | AddInkatlasDialogViewModel.cs |
| 3 | AddItemsToStoreDialogViewModel.cs |
| 4 | AddPropFileDialogViewModel.cs |
| 5 | AddQuestDialogViewModel.cs |
| 6 | AddRadioExtFilesDialogViewModel.cs |
| 7 | ChangeComponentPropertiesDialogViewModel.cs |
| 8 | ChooseCollectionViewModel.cs |
| 9 | ConvertHairToCCXLMaterialsDialogViewModel.cs |
| 10 | CopyMeshAppearancesDialogViewModel.cs |
| 11 | CreateMaterialsDialogViewModel.cs |
| 12 | CreatePhotoModeAppViewModel.cs |
| 13 | DeleteOrDuplicateComponentDialogViewModel.cs |
| 14 | DeleteOrMoveFilesListDialogViewModel.cs |
| 15 | DialogViewModel.cs |
| 16 | ExportArgsDialogViewModel.cs |
| 17 | ExtractAmbigiousDialogViewModel.cs |
| 18 | ExtractEmbeddedFileDialogViewModel.cs |
| 19 | FirstSetupViewModel.cs |
| 20 | FolderPathInputDialogViewModel.cs |
| 21 | ImportArgsDialogViewModel.cs |
| 22 | InputDialogViewModel.cs |
| 23 | InstallerWizardViewModel.cs |
| 24 | LaunchProfileViewModel.cs |
| 25 | LaunchProfilesViewModel.cs |
| 26 | LocalizationStringViewModel.cs |
| 27 | MaterialsRepositoryDialogViewModel.cs |
| 28 | NewFileViewModel.cs |
| 29 | OpenFileViewModel.cs |
| 30 | PlayerHeadDialogViewModel.cs |
| 31 | ProjectSettingsDialogViewModel.cs |
| 32 | ProjectWizardViewModel.cs |
| 33 | RenameDialogViewModel.cs |
| 34 | SaveGameSelectionDialogModel.cs |
| 35 | SceneInputDialogViewModel.cs |
| 36 | ScriptManagerViewModel.cs |
| 37 | SearchAndReplaceDialogViewModel.cs |
| 38 | SelectAnimationPathViewModel.cs |
| 39 | SelectDropdownEntryDialogViewModel.cs |
| 40 | ShowChecklistDialogueViewModel.cs |
| 41 | ShowDictionaryForCopyDialogViewModel.cs |
| 42 | SoundModdingViewModel.cs |
| 43 | StringsGUIImporterIDDialogViewModel.cs |
| 44 | StringsGuiScriptsPrefixDialogViewModel.cs |
| 45 | TypeSelectorDialogViewModel.cs |
| 46 | UpdateDialogViewModel.cs |
| 47 | UserWizardViewModel.cs |

## Architecture

The analyzed files contain approximately **2984 lines** of code across **30 files** (of 47 total).

### Notable Types

- class AddArchiveXlFilesDialogViewModel
- class AddInkatlasDialogViewModel
- class AddItemsToStoreDialogViewModel
- class AddPropFileDialogViewModel
- class AddQuestDialogViewModel
- class AddRadioExtFilesDialogViewModel
- class ChangeComponentPropertiesDialogViewModel
- class ChooseCollectionViewModel
- class ConvertHairToCCXLMaterialsDialogViewModel
- class CopyMeshAppearancesDialogViewModel
- class CreateMaterialsDialogViewModel
- class CreatePhotoModeAppViewModel
- class DeleteOrDuplicateComponentDialogViewModel
- class DeleteOrMoveFilesListDialogViewModel
- class DialogViewModel
- class DialogWindowViewModel
- class ExportArgsDialogViewModel
- class ExtractAmbigiousDialogViewModel
- class ExtractEmbeddedFileDialogViewModel
- class FirstSetupViewModel
- class FolderPathInputDialogViewModel
- class ImportArgsDialogViewModel
- class InputDialogViewModel
- class InstallerWizardViewModel
- class LaunchProfileViewModel
- class LaunchProfilesViewModel
- class LocalizationStringViewModel
- class MaterialsRepositoryViewModel
- class NewFileViewModel
- class OpenFileViewModel
- class PlayerHeadDialogViewModel
- class RadioSongItem
- class UncookExtensionViewModel
- delegate Task
- delegate void
- interface IDisplayable
- record class
- record should

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using CommunityToolkit.Mvvm.Input
- using DynamicData
- using System
- using System.Collections.Generic
- using System.Collections.ObjectModel
- using System.ComponentModel
- using System.IO
- using System.Linq
- using WolvenKit.App.Extensions
- using WolvenKit.App.Helpers
- using WolvenKit.App.Models.ProjectManagement.Project
- using WolvenKit.App.Services
- using WolvenKit.Core
- using WolvenKit.Interfaces.Extensions
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.App/ViewModels/Dialogs/` in the WolvenKit repository
