---
type: "Model"
title: "App Misc Models"
description: "Application data models (docking, nodify, appearance, audio, CSV, filesystem, materials, mesh, import, JSON, launch profile, mod info, etc.) — 69 files."
resource: "WolvenKit.App/Models/Appearance.cs"
tags: [app, models, misc, model]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Application data models (docking, nodify, appearance, audio, CSV, filesystem, materials, mesh, import, JSON, launch profile, mod info, etc.) — 69 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **64 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Appearance.cs | 38 | class Appearance |
| AudioObject.cs | 14 | class AudioObject |
| Child.cs | 25 | class Child |
| CsvCommonFunctions.cs | 142 | class CsvCommonFunctions |
| CsvMaps.cs | 114 | class CBoolMap, class CFloatMap, class CInt16Map, class CInt32Map, class CInt64Map |
| DispatchedObservableCollection.cs | 11 | class DispatchedObservableCollection |
| DockState.cs | 42 | enum DockState, enum DockSide, enum DockState |
| IDockElement.cs | 19 | interface IDockElement |
| FancyProjectObject.cs | 51 | class WelcomePageViewModel, class FancyProjectObject |
| FileSystemArchive.cs | 101 | class FileSystemArchive |
| FileSystemModel.cs | 207 | class FileSystemModel |
| GroupModel3DExt.cs | 8 | class GroupModel3DExt |
| IBindable.cs | 9 | interface IBindable |
| INode.cs | 14 | interface INode |
| ITree.cs | 15 | interface ITree |
| IWolvenkitView.cs | 27 | interface IWolvenkitView |
| ImageUtility.cs | 241 | class ImageUtility |
| ImportModel.cs | 158 | class ImportableFile, class XBMDumpRecord, enum EObjectState |
| JsonAMM.cs | 14 | class JsonAMM |
| JsonAMM2.cs | 16 | class JsonAMM2 |

## Member Types

All **64** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Appearance.cs |
| 2 | AudioObject.cs |
| 3 | Child.cs |
| 4 | CsvCommonFunctions.cs |
| 5 | CsvMaps.cs |
| 6 | DispatchedObservableCollection.cs |
| 7 | DockState.cs |
| 8 | IDockElement.cs |
| 9 | FancyProjectObject.cs |
| 10 | FileSystemArchive.cs |
| 11 | FileSystemModel.cs |
| 12 | GroupModel3DExt.cs |
| 13 | IBindable.cs |
| 14 | INode.cs |
| 15 | ITree.cs |
| 16 | IWolvenkitView.cs |
| 17 | ImageUtility.cs |
| 18 | ImportModel.cs |
| 19 | JsonAMM.cs |
| 20 | JsonAMM2.cs |
| 21 | JsonObjectSpawner.cs |
| 22 | LaunchProfile.cs |
| 23 | LoadableModel.cs |
| 24 | Material.cs |
| 25 | MaterialXmlModel.cs |
| 26 | MeshComponent.cs |
| 27 | MeshViewHeaders.cs |
| 28 | MinimalGithubRelease.cs |
| 29 | ModInfo.cs |
| 30 | ModInfoEntry.cs |
| 31 | ModsInfo.cs |
| 32 | NodifyInterfaces.cs |
| 33 | RedReference.cs |
| 34 | ReferenceSocket.cs |
| 35 | ObservableCollectionEx.cs |
| 36 | PanelVisibility.cs |
| 37 | Pos.cs |
| 38 | CP77Mod.cs |
| 39 | IRecentlyUsedItemsService.cs |
| 40 | Cp77Project.cs |
| 41 | Tw3Project.cs |
| 42 | RecentlyUsedItemModel.cs |
| 43 | RecentlyUsedItemsService.cs |
| 44 | Prop.cs |
| 45 | ResourcePathWrapper.cs |
| 46 | Rig.cs |
| 47 | RigBone.cs |
| 48 | Rot.cs |
| 49 | SaveGame.cs |
| 50 | Sector.cs |
| 51 | SectorGroup.cs |
| 52 | SeparateMatrix.cs |
| 53 | SimpleGeometryData.cs |
| 54 | SlotSet.cs |
| 55 | SmartElement3DCollection.cs |
| 56 | SubmeshComponent.cs |
| 57 | TimelineEvent.cs |
| 58 | TimelineTrack.cs |
| 59 | TweakXL.cs |
| 60 | Vec3S.cs |
| 61 | Vec7.cs |
| 62 | Vec7S.cs |
| 63 | WKBillboardTextModel3D.cs |
| 64 | WKPackage.cs |

## Architecture

The analyzed files contain approximately **1700 lines** of code across **30 files** (of 64 total).

### Notable Types

- class Appearance
- class AudioObject
- class CBoolMap
- class CFloatMap
- class CInt16Map
- class CInt32Map
- class CInt64Map
- class CInt8Map
- class CNameMap
- class CStringMap
- class CUInt16Map
- class CUInt32Map
- class CUInt64Map
- class CUInt8Map
- class Child
- class CsvCommonFunctions
- class DispatchedObservableCollection
- class FancyProjectObject
- class FileSystemArchive
- class FileSystemModel
- class GroupModel3DExt
- class ImageUtility
- class ImportableFile
- class JsonAMM
- class JsonAMM2
- class JsonObjectSpawner
- class LaunchProfile
- class LoadableModel
- class Material
- class MaterialXmlModel
- class MeshComponent
- class MeshMaterial
- class MeshMaterialParam
- class MeshMesh_data
- class MeshMesh_dataLODs
- class MeshMesh_dataLODsLOD_info
- class MeshViewHeaders
- class MinimalGithubRelease
- class MinimalGithubReleaseAsset
- class ModInfo
- class ModInfoEntry
- class WelcomePageViewModel
- class XBMDumpRecord
- class for
- enum DockSide
- enum DockState
- enum EObjectState
- interface IBindable
- interface IDockElement
- interface INode

## Dependencies

- using CsvHelper
- using CsvHelper.Configuration
- using System
- using System.Collections.Generic
- using System.ComponentModel
- using System.Diagnostics.CodeAnalysis
- using System.Globalization
- using System.IO
- using System.Linq
- using System.Text
- using System.Threading.Tasks
- using WolvenKit.App.Models.ProjectManagement.Project
- using WolvenKit.Common
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Model.Cr2w
- using WolvenKit.Common.Services
- using WolvenKit.Core.Interfaces
- using WolvenKit.Functionality.Controllers
- using WolvenKit.RED3.CR2W.Types
- using WolvenKit.RED4.Archive

## Citations

[1] Source files under `WolvenKit.App/Models/` in the WolvenKit repository
