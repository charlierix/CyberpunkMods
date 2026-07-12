---
type: "ViewModel"
title: "Document ViewModels"
description: "Document editor view models (RDT tabs, mesh, texture, graph, widget, tweak, WScript, ink texture atlas) — 28 files."
resource: "WolvenKit.App/ViewModels/Documents/BehaviorGraphViewModel.cs"
tags: [app, viewmodels, documents, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Document editor view models (RDT tabs, mesh, texture, graph, widget, tweak, WScript, ink texture atlas) — 28 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **28 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| BehaviorGraphViewModel.cs | 168 | class BehaviorTabDefinition, class BehaviorGraphViewModel |
| ConnectionViewModel.cs | 44 | class ConnectionViewModel |
| DocumentViewModel.cs | 68 | class DocumentViewModel |
| GraphDocumentSearchHelper.cs | 309 | class GraphDocumentSearchHelper, class GraphDocumentSearchState, struct GraphDocumentSearchMatch, record struct |
| IDocumentViewModel.cs | 51 | class SaveAsParameters, interface IDocumentViewModel |
| IDocumentViewModel_old.cs | 27 | interface Old_IDocumentViewModel |
| NodeViewModel.cs | 248 | class NodeViewModel |
| PendingConnectionViewModel.cs | 30 | class PendingConnectionViewModel |
| PhaseNodeViewModel.cs | 27 | class PhaseNodeViewModel |
| QuestPhaseGraphViewModel.cs | 263 | class QuestPhaseGraphViewModel |
| QuestPhaseTabDefinition.cs | 12 | class QuestPhaseTabDefinition |
| RDTDataViewModel.cs | 290 | class RDTDataViewModel, delegate void |
| RDTGraphViewModel.cs | 225 | class RDTGraphViewModel, enum ConnectorFlow, enum ConnectorShape |
| RDTGraphViewModel2.cs | 92 | class RDTGraphViewModel2 |
| RDTInkTextureAtlasViewModel.cs | 271 | class RDTInkTextureAtlasViewModel, class InkTextureAtlasMapperViewModel, delegate void |
| RDTLayeredPreviewViewModel.cs | 87 | class RDTLayeredPreviewViewModel, class ImageEntry |
| RDTMeshViewModel.cs | 316 | class RDTMeshViewModel |
| RDTTextViewModel.cs | 30 | class RDTTextViewModel |
| RDTTextureViewModel.cs | 277 | class RDTTextureViewModel, delegate void |
| RDTWidgetViewModel.cs | 315 | class RDTWidgetViewModel |

## Member Types

All **28** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | BehaviorGraphViewModel.cs |
| 2 | ConnectionViewModel.cs |
| 3 | DocumentViewModel.cs |
| 4 | GraphDocumentSearchHelper.cs |
| 5 | IDocumentViewModel.cs |
| 6 | IDocumentViewModel_old.cs |
| 7 | NodeViewModel.cs |
| 8 | PendingConnectionViewModel.cs |
| 9 | PhaseNodeViewModel.cs |
| 10 | QuestPhaseGraphViewModel.cs |
| 11 | QuestPhaseTabDefinition.cs |
| 12 | RDTDataViewModel.cs |
| 13 | RDTGraphViewModel.cs |
| 14 | RDTGraphViewModel2.cs |
| 15 | RDTInkTextureAtlasViewModel.cs |
| 16 | RDTLayeredPreviewViewModel.cs |
| 17 | RDTMeshViewModel.cs |
| 18 | RDTTextViewModel.cs |
| 19 | RDTTextureViewModel.cs |
| 20 | RDTWidgetViewModel.cs |
| 21 | RedDocumentTabViewModel.cs |
| 22 | RedDocumentViewModel.cs |
| 23 | RedDocumentViewToolbarModel.cs |
| 24 | SceneGraphViewModel.cs |
| 25 | SocketViewModel.cs |
| 26 | TweakEntryViewModel.cs |
| 27 | TweakXLDocumentViewModel.cs |
| 28 | WScriptDocumentViewModel.cs |

## Architecture

The analyzed files contain approximately **4691 lines** of code across **28 files** (of 28 total).

### Notable Types

- class AddDependenciesFullEventArgs
- class BehaviorGraphViewModel
- class BehaviorTabDefinition
- class ConnectionViewModel
- class DocumentViewModel
- class FlatViewModel
- class GraphDocumentSearchHelper
- class GraphDocumentSearchState
- class GroupViewModel
- class ImageEntry
- class InkTextureAtlasMapperViewModel
- class NodeViewModel
- class PendingConnectionViewModel
- class PhaseNodeViewModel
- class QuestPhaseGraphViewModel
- class QuestPhaseTabDefinition
- class RDTDataViewModel
- class RDTGraphViewModel
- class RDTGraphViewModel2
- class RDTInkTextureAtlasViewModel
- class RDTLayeredPreviewViewModel
- class RDTMeshViewModel
- class RDTTextViewModel
- class RDTTextureViewModel
- class RDTWidgetViewModel
- class RedDocumentTabViewModel
- class RedDocumentViewModel
- class RedDocumentViewToolbarModel
- class SaveAsParameters
- class SceneGraphViewModel
- class SceneTabDefinition
- class SocketViewModel
- class TweakEntryViewModel
- class TweakXLDocumentViewModel
- class WScriptDocumentViewModel
- delegate void
- enum ConnectorFlow
- enum ConnectorShape
- enum ERedDocumentItemType
- enum RedDocumentItemType
- interface IDocumentViewModel
- interface Old_IDocumentViewModel
- record struct
- struct GraphDocumentSearchMatch

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using CommunityToolkit.Mvvm.Input
- using GraphNodeViewModel = WolvenKit.App.ViewModels.GraphEditor.NodeViewModel
- using Splat
- using System
- using System.Collections.Generic
- using System.Collections.ObjectModel
- using System.ComponentModel
- using System.IO
- using System.Linq
- using System.Threading.Tasks
- using System.Windows.Data
- using WolvenKit.App.Controllers
- using WolvenKit.App.Factories
- using WolvenKit.App.Helpers
- using WolvenKit.App.Models.Docking
- using WolvenKit.App.Services
- using WolvenKit.App.ViewModels.GraphEditor
- using WolvenKit.App.ViewModels.GraphEditor.Nodes.Behavior
- using WolvenKit.App.ViewModels.GraphEditor.Nodes.Quest

## Citations

[1] Source files under `WolvenKit.App/ViewModels/Documents/` in the WolvenKit repository
