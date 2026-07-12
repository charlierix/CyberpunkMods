---
type: "ViewModel"
title: "Graph Editor Base ViewModels"
description: "Graph editor base view models (RedGraph, NodeViewModel, ConnectionViewModel, connectors, IGraphProvider) — 12 files."
resource: "WolvenKit.App/ViewModels/GraphEditor/BaseConnectorViewModel.cs"
tags: [app, viewmodels, graph, editor, base, viewmodel]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Graph editor base view models (RedGraph, NodeViewModel, ConnectionViewModel, connectors, IGraphProvider) — 12 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **110 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| BaseConnectorViewModel.cs | 30 | class BaseConnectorViewModel |
| ConnectionViewModel.cs | 20 | class ConnectionViewModel |
| IDynamicInputNode.cs | 20 | interface IDynamicInputNode, interface IDynamicOutputNode |
| IGraphProvider.cs | 8 | interface IGraphProvider |
| InputConnectorViewModel.cs | 10 | class InputConnectorViewModel |
| NodeViewModel.cs | 300 | class NodeViewModel, class if |
| BehaviorNodeViewModel.cs | 285 | class BehaviorNodeViewModel |
| GraphNodeStyling.cs | 282 | class GraphNodeStyling |
| NodeProperties.cs | 213 | class DictionaryExtensions, class NodeProperties |
| BaseQuestViewModel.cs | 279 | class BaseQuestViewModel |
| DynamicQuestViewModel.cs | 29 | class DynamicQuestViewModel, class DynamicQuestViewModel |
| QuestConditionHelper.cs | 224 | class QuestConditionHelper |
| QuestConnectionViewModel.cs | 18 | class QuestConnectionViewModel |
| QuestInputConnectorViewModel.cs | 13 | class QuestInputConnectorViewModel |
| QuestOutputConnectorViewModel.cs | 13 | class QuestOutputConnectorViewModel |
| graphGraphNodeDefinitionWrapper.cs | 17 | class graphGraphNodeDefinitionWrapper, class graphGraphNodeDefinitionWrapper |
| questAICommandNodeBaseWrapper.cs | 10 | class questAICommandNodeBaseWrapper |
| questAchievementManagerNodeDefinitionWrapper.cs | 19 | class questAchievementManagerNodeDefinitionWrapper |
| questAudioNodeDefinitionWrapper.cs | 19 | class questAudioNodeDefinitionWrapper |
| questCharacterManagerNodeDefinitionWrapper.cs | 19 | class questCharacterManagerNodeDefinitionWrapper |

## Member Types

All **110** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | BaseConnectorViewModel.cs |
| 2 | ConnectionViewModel.cs |
| 3 | IDynamicInputNode.cs |
| 4 | IGraphProvider.cs |
| 5 | InputConnectorViewModel.cs |
| 6 | NodeViewModel.cs |
| 7 | BehaviorNodeViewModel.cs |
| 8 | GraphNodeStyling.cs |
| 9 | NodeProperties.cs |
| 10 | BaseQuestViewModel.cs |
| 11 | DynamicQuestViewModel.cs |
| 12 | QuestConditionHelper.cs |
| 13 | QuestConnectionViewModel.cs |
| 14 | QuestInputConnectorViewModel.cs |
| 15 | QuestOutputConnectorViewModel.cs |
| 16 | graphGraphNodeDefinitionWrapper.cs |
| 17 | questAICommandNodeBaseWrapper.cs |
| 18 | questAchievementManagerNodeDefinitionWrapper.cs |
| 19 | questAudioNodeDefinitionWrapper.cs |
| 20 | questCharacterManagerNodeDefinitionWrapper.cs |
| 21 | questCheckpointNodeDefinitionWrapper.cs |
| 22 | questClearForcedBehavioursNodeDefinitionWrapper.cs |
| 23 | questCombatNodeDefinitionWrapper.cs |
| 24 | questConditionNodeDefinitionWrapper.cs |
| 25 | questConfigurableAICommandNodeWrapper.cs |
| 26 | questCrowdManagerNodeDefinitionWrapper.cs |
| 27 | questCutControlNodeDefinitionWrapper.cs |
| 28 | questDeletionMarkerNodeDefinitionWrapper.cs |
| 29 | questDisableableNodeDefinitionWrapper.cs |
| 30 | questDynamicSpawnSystemNodeDefinitionWrapper.cs |
| 31 | questEmbeddedGraphNodeDefinitionWrapper.cs |
| 32 | questEndNodeDefinitionWrapper.cs |
| 33 | questEntityManagerNodeDefinitionWrapper.cs |
| 34 | questEnvironmentManagerNodeDefinitionWrapper.cs |
| 35 | questEquipItemNodeDefinitionWrapper.cs |
| 36 | questEventManagerNodeDefinitionWrapper.cs |
| 37 | questFXManagerNodeDefinitionWrapper.cs |
| 38 | questFactsDBManagerNodeDefinitionWrapper.cs |
| 39 | questFlowControlNodeDefinitionWrapper.cs |
| 40 | questForcedBehaviourNodeDefinitionWrapper.cs |
| 41 | questGameManagerNodeDefinitionWrapper.cs |
| 42 | questIONodeDefinitionWrapper.cs |
| 43 | questInputNodeDefinitionWrapper.cs |
| 44 | questInstancedCrowdControlNodeDefinitionWrapper.cs |
| 45 | questInteractiveObjectManagerNodeDefinitionWrapper.cs |
| 46 | questItemManagerNodeDefinitionWrapper.cs |
| 47 | questJournalNodeDefinitionWrapper.cs |
| 48 | questLogicalAndNodeDefinitionWrapper.cs |
| 49 | questLogicalBaseNodeDefinitionWrapper.cs |
| 50 | questLogicalHubNodeDefinitionWrapper.cs |
| 51 | questLogicalXorNodeDefinitionWrapper.cs |
| 52 | questMappinManagerNodeDefinitionWrapper.cs |
| 53 | questMiscAICommandNodeWrapper.cs |
| 54 | questMovePuppetNodeDefinitionWrapper.cs |
| 55 | questNodeDefinitionWrapper.cs |
| 56 | questOutputNodeDefinitionWrapper.cs |
| 57 | questPauseConditionNodeDefinitionWrapper.cs |
| 58 | questPhaseNodeDefinitionWrapper.cs |
| 59 | questPhoneManagerNodeDefinitionWrapper.cs |
| 60 | questPuppetAIManagerNodeDefinitionWrapper.cs |
| 61 | questRandomizerNodeDefinitionWrapper.cs |
| 62 | questRenderFxManagerNodeDefinitionWrapper.cs |
| 63 | questRewardManagerNodeDefinitionWrapper.cs |
| 64 | questSceneManagerNodeDefinitionWrapper.cs |
| 65 | questSceneNodeDefinitionWrapper.cs |
| 66 | questSendAICommandNodeDefinitionWrapper.cs |
| 67 | questSignalStoppingNodeDefinitionWrapper.cs |
| 68 | questSpawnManagerNodeDefinitionWrapper.cs |
| 69 | questStartEndNodeDefinitionWrapper.cs |
| 70 | questStartNodeDefinitionWrapper.cs |
| 71 | questSwitchNodeDefinitionWrapper.cs |
| 72 | questTeleportPuppetNodeDefinitionWrapper.cs |
| 73 | questTimeManagerNodeDefinitionWrapper.cs |
| 74 | questTransformAnimatorNodeDefinitionWrapper.cs |
| 75 | questTriggerManagerNodeDefinitionWrapper.cs |
| 76 | questTypedSignalStoppingNodeDefinitionWrapper.cs |
| 77 | questUIManagerNodeDefinitionWrapper.cs |
| 78 | questUseWorkspotNodeDefinitionWrapper.cs |
| 79 | questVehicleNodeCommandDefinitionWrapper.cs |
| 80 | questVehicleNodeDefinitionWrapper.cs |
| 81 | questVisionModesManagerNodeDefinitionWrapper.cs |
| 82 | questVoicesetManagerNodeDefinitionWrapper.cs |
| 83 | questWorldDataManagerNodeDefinitionWrapper.cs |
| 84 | tempshitMapPinManagerNodeDefinitionWrapper.cs |
| 85 | BaseSceneViewModel.cs |
| 86 | DynamicSceneViewModel.cs |
| 87 | SceneConnectionViewModel.cs |
| 88 | SceneInputConnectorViewModel.cs |
| 89 | SceneOutputConnectorViewModel.cs |
| 90 | scnAndNodeWrapper.cs |
| 91 | scnChoiceNodeWrapper.cs |
| 92 | scnCutControlNodeWrapper.cs |
| 93 | scnDeletionMarkerNodeWrapper.cs |
| 94 | scnEndNodeWrapper.cs |
| 95 | scnFlowControlNodeWrapper.cs |
| 96 | scnHubNodeWrapper.cs |
| 97 | scnInterruptManagerNodeWrapper.cs |
| 98 | scnQuestNodeWrapper.cs |
| 99 | scnRandomizerNodeWrapper.cs |
| 100 | scnRewindableSectionNodeWrapper.cs |
| 101 | scnSceneGraphNodeWrapper.cs |
| 102 | scnSectionNodeWrapper.cs |
| 103 | scnStartNodeWrapper.cs |
| 104 | scnXorNodeWrapper.cs |
| 105 | OutputConnectorViewModel.cs |
| 106 | PendingConnectionViewModel.cs |
| 107 | RedGraph.Behavior.cs |
| 108 | RedGraph.Quest.cs |
| 109 | RedGraph.Scene.cs |
| 110 | RedGraph.cs |

## Architecture

The analyzed files contain approximately **2089 lines** of code across **30 files** (of 110 total).

### Notable Types

- class BaseConnectorViewModel
- class BaseQuestViewModel
- class BehaviorNodeViewModel
- class ConnectionViewModel
- class DictionaryExtensions
- class DynamicQuestViewModel
- class GraphNodeStyling
- class InputConnectorViewModel
- class NodeProperties
- class NodeViewModel
- class QuestConditionHelper
- class QuestConnectionViewModel
- class QuestInputConnectorViewModel
- class QuestOutputConnectorViewModel
- class graphGraphNodeDefinitionWrapper
- class if
- class questAICommandNodeBaseWrapper
- class questAchievementManagerNodeDefinitionWrapper
- class questAudioNodeDefinitionWrapper
- class questCharacterManagerNodeDefinitionWrapper
- class questCheckpointNodeDefinitionWrapper
- class questClearForcedBehavioursNodeDefinitionWrapper
- class questCombatNodeDefinitionWrapper
- class questConditionNodeDefinitionWrapper
- class questConfigurableAICommandNodeWrapper
- class questCrowdManagerNodeDefinitionWrapper
- class questCutControlNodeDefinitionWrapper
- class questDeletionMarkerNodeDefinitionWrapper
- class questDisableableNodeDefinitionWrapper
- class questDynamicSpawnSystemNodeDefinitionWrapper
- interface IDynamicInputNode
- interface IDynamicOutputNode
- interface IGraphProvider

## Dependencies

- using Splat
- using System
- using System.Collections.Generic
- using System.IO
- using System.Linq
- using System.Reflection
- using System.Windows
- using System.Windows.Media
- using System.Xml
- using WolvenKit.App.Extensions
- using WolvenKit.App.Services
- using WolvenKit.App.ViewModels.GraphEditor.Nodes
- using WolvenKit.App.ViewModels.GraphEditor.Nodes.Quest.Internal
- using WolvenKit.Core.Interfaces
- using WolvenKit.Core.Services
- using WolvenKit.Interfaces.Extensions
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.App/ViewModels/GraphEditor/` in the WolvenKit repository
