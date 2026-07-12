---
type: "Config"
title: "App Root Files"
description: "Application root files (Colors, Constants, Enums, Equipment_Enums, Globals, AssemblyInfo, MySink) — 17 files."
resource: "WolvenKit.App/AssemblyInfo.cs"
tags: [app, root, config]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Application root files (Colors, Constants, Enums, Equipment_Enums, Globals, AssemblyInfo, MySink) — 17 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **437 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AssemblyInfo.cs | 5 | N/A |
| Colors.cs | 22 | class WkitColors, class WkitBrushes |
| Constants.cs | 121 | class Constants, class PhotomodeEntityAnimations |
| IGameController.cs | 83 | interface IGameController |
| IGameControllerFactory.cs | 61 | class GameControllerFactory, interface IGameControllerFactory |
| MockGameController.cs | 34 | class MockGameController |
| RED4Controller.cs | 299 | class RED4Controller |
| Tw3Controller.cs | 257 | class Tw3Controller |
| ActiveDocumentConverter.cs | 33 | class ActiveDocumentConverter |
| BoolToBrushConverter.cs | 34 | class BoolToBrushConverter |
| ColorToSolidColorBrushConverter.cs | 22 | class ColorToSolidColorBrushConverter |
| FlowToDirectionConverter.cs | 31 | class FlowToDirectionConverter |
| JsonArchiveConverter.cs | 15 | class JsonArchiveConverter |
| JsonFileEntryConverter.cs | 51 | class JsonFileEntryConverter |
| ListToStringConverter.cs | 72 | class ListToStringConverter |
| StringPathToItemStringConverter.cs | 19 | class StringPathToItemStringConverter |
| Enums.cs | 75 | enum EManagerType, enum EProjectType, enum EAppStatus, enum EDockedViews, enum ScriptSource |
| Equipment_Enums.cs | 411 | class EquipmentItemData, enum EquipmentItemSlot, enum ArchiveXlHidingTags, enum GarmentSupportTags, enum EquipmentWeaponSlot |
| ICommandExtensions.cs | 23 | class ICommandExtensions |
| MeasureExtensions.cs | 29 | class ThicknessExtensions, class CornerRadiusExtensions, class GridLengthExtensions, class RectExtensions |

## Member Types

All **437** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AssemblyInfo.cs |
| 2 | Colors.cs |
| 3 | Constants.cs |
| 4 | IGameController.cs |
| 5 | IGameControllerFactory.cs |
| 6 | MockGameController.cs |
| 7 | RED4Controller.cs |
| 8 | Tw3Controller.cs |
| 9 | ActiveDocumentConverter.cs |
| 10 | BoolToBrushConverter.cs |
| 11 | ColorToSolidColorBrushConverter.cs |
| 12 | FlowToDirectionConverter.cs |
| 13 | JsonArchiveConverter.cs |
| 14 | JsonFileEntryConverter.cs |
| 15 | ListToStringConverter.cs |
| 16 | StringPathToItemStringConverter.cs |
| 17 | Enums.cs |
| 18 | Equipment_Enums.cs |
| 19 | ICommandExtensions.cs |
| 20 | MeasureExtensions.cs |
| 21 | NodeViewModelExtensions.cs |
| 22 | RichTextBoxExtensions.cs |
| 23 | SharpDXExtensions.cs |
| 24 | ChunkViewmodelFactory.cs |
| 25 | DialogViewModelFactory.cs |
| 26 | DocumentTabViewmodelFactory.cs |
| 27 | DocumentViewmodelFactory.cs |
| 28 | IChunkViewmodelFactory.cs |
| 29 | IDialogViewModelFactory.cs |
| 30 | IDocumentTabViewmodelFactory.cs |
| 31 | IDocumentViewmodelFactory.cs |
| 32 | INodeWrapperFactory.cs |
| 33 | IPageViewModelFactory.cs |
| 34 | IPaneViewModelFactory.cs |
| 35 | NodeWrapperFactory.cs |
| 36 | PageViewModelFactory.cs |
| 37 | PaneViewModelFactory.cs |
| 38 | Globals.cs |
| 39 | AppFileHelper.cs |
| 40 | ArchiveXlHelper.cs |
| 41 | CvmDependencyTools.cs |
| 42 | CvmMaterialTools.cs |
| 43 | CvmTools.cs |
| 44 | ICvmTools.cs |
| 45 | CollectionViewHelper.cs |
| 46 | Commonfunctions.cs |
| 47 | Cr2WTools.cs |
| 48 | CvmDropdownHelper.cs |
| 49 | Debug_Helpers.cs |
| 50 | DesktopBridgeHelper.cs |
| 51 | DiscordHelper.cs |
| 52 | DispatcherHelper.cs |
| 53 | DocumentTools.cs |
| 54 | ExportArgsWrapper.cs |
| 55 | FilePathHelper.cs |
| 56 | FolderPicker.cs |
| 57 | GitHelper.cs |
| 58 | ImageDecoder.cs |
| 59 | ImportArgsWrapper.cs |
| 60 | ImportExportHelper.cs |
| 61 | InkCache.cs |
| 62 | InkWidgetHelper.cs |
| 63 | InkatlasImageGenerator.cs |
| 64 | ProcessHelper.cs |
| 65 | ProjectResourceTools.cs |
| 66 | RegistryHelpers.cs |
| 67 | SceneEditingHelper.cs |
| 68 | StringHelper.cs |
| 69 | StringHelperAnimNode.cs |
| 70 | StringHelperWorldNode.cs |
| 71 | TemplateFileTools.cs |
| 72 | TemplateFileTools.RadioExt.cs |
| 73 | TestHelper.cs |
| 74 | TimelineColorHelper.cs |
| 75 | TypeHelper.cs |
| 76 | UIHelper.cs |
| 77 | Win32.cs |
| 78 | YamlHelper.cs |
| 79 | InteractionEnums.cs |
| 80 | Interactions.cs |
| 81 | ChecklistDialogOptions.cs |
| 82 | SceneInputDialogOptions.cs |
| 83 | ShowDictAsCopyableListDialogOptions.cs |
| 84 | Appearance.cs |
| 85 | AudioObject.cs |
| 86 | Child.cs |
| 87 | CsvCommonFunctions.cs |
| 88 | CsvMaps.cs |
| 89 | DispatchedObservableCollection.cs |
| 90 | DockState.cs |
| 91 | IDockElement.cs |
| 92 | FancyProjectObject.cs |
| 93 | FileSystemArchive.cs |
| 94 | FileSystemModel.cs |
| 95 | GroupModel3DExt.cs |
| 96 | IBindable.cs |
| 97 | INode.cs |
| 98 | ITree.cs |
| 99 | IWolvenkitView.cs |
| 100 | ImageUtility.cs |
| 101 | ImportModel.cs |
| 102 | JsonAMM.cs |
| 103 | JsonAMM2.cs |
| 104 | JsonObjectSpawner.cs |
| 105 | LaunchProfile.cs |
| 106 | LoadableModel.cs |
| 107 | Material.cs |
| 108 | MaterialXmlModel.cs |
| 109 | MeshComponent.cs |
| 110 | MeshViewHeaders.cs |
| 111 | MinimalGithubRelease.cs |
| 112 | ModInfo.cs |
| 113 | ModInfoEntry.cs |
| 114 | ModsInfo.cs |
| 115 | NodifyInterfaces.cs |
| 116 | RedReference.cs |
| 117 | ReferenceSocket.cs |
| 118 | ObservableCollectionEx.cs |
| 119 | PanelVisibility.cs |
| 120 | Pos.cs |
| 121 | CP77Mod.cs |
| 122 | IRecentlyUsedItemsService.cs |
| 123 | Cp77Project.cs |
| 124 | Tw3Project.cs |
| 125 | RecentlyUsedItemModel.cs |
| 126 | RecentlyUsedItemsService.cs |
| 127 | Prop.cs |
| 128 | ResourcePathWrapper.cs |
| 129 | Rig.cs |
| 130 | RigBone.cs |
| 131 | Rot.cs |
| 132 | SaveGame.cs |
| 133 | Sector.cs |
| 134 | SectorGroup.cs |
| 135 | SeparateMatrix.cs |
| 136 | SimpleGeometryData.cs |
| 137 | SlotSet.cs |
| 138 | SmartElement3DCollection.cs |
| 139 | SubmeshComponent.cs |
| 140 | TimelineEvent.cs |
| 141 | TimelineTrack.cs |
| 142 | TweakXL.cs |
| 143 | Vec3S.cs |
| 144 | Vec7.cs |
| 145 | Vec7S.cs |
| 146 | WKBillboardTextModel3D.cs |
| 147 | WKPackage.cs |
| 148 | MySink.cs |
| 149 | AudioPlayback.cs |
| 150 | EndOfStreamEventArgs.cs |
| 151 | IVisualizationPlugin.cs |
| 152 | SampleAggregator.cs |
| 153 | VorbisSampleProvider.cs |
| 154 | VorbisWaveReader.cs |
| 155 | WolvenKitFileDefinitions.xml |
| 156 | launchprofiles.json |
| 157 | AppScriptFunctions.cs |
| 158 | ScriptDocumentWrapper.cs |
| 159 | ScriptFunctionWrapper.cs |
| 160 | ScriptSettingsDictionary.cs |
| 161 | UiScriptFunctions.cs |
| 162 | AppArchiveManager.cs |
| 163 | AppHookService.cs |
| 164 | AppIdleStateService.cs |
| 165 | AppScriptService.Hook.cs |
| 166 | AppScriptService.Ui.cs |
| 167 | AppScriptService.cs |
| 168 | ArchiveXlItemService.cs |
| 169 | ConverterCacheService.cs |
| 170 | GraphClipboardManager.cs |
| 171 | HashServiceExt.cs |
| 172 | IAppArchiveManager.cs |
| 173 | IModifierViewStateService.cs |
| 174 | INodeSelectionService.cs |
| 175 | IPluginService.cs |
| 176 | IProjectManager.cs |
| 177 | IRefreshableDetails.cs |
| 178 | IScriptableControl.cs |
| 179 | ISettingsDto.cs |
| 180 | ISettingsManager.cs |
| 181 | IUpdateService.cs |
| 182 | IWatcherService.cs |
| 183 | LocKeyServiceExt.cs |
| 184 | ModifierViewStateService.cs |
| 185 | NodePropertiesSelectionService.cs |
| 186 | NodePropertyUpdateService.cs |
| 187 | NodeSelectionService.cs |
| 188 | PluginService.cs |
| 189 | ProjectManager.cs |
| 190 | SettingsDto.cs |
| 191 | SettingsManager.cs |
| 192 | TimelineService.cs |
| 193 | UpdateService.cs |
| 194 | WatcherService.cs |
| 195 | AddArchiveXlFilesDialogViewModel.cs |
| 196 | AddInkatlasDialogViewModel.cs |
| 197 | AddItemsToStoreDialogViewModel.cs |
| 198 | AddPropFileDialogViewModel.cs |
| 199 | AddQuestDialogViewModel.cs |
| 200 | AddRadioExtFilesDialogViewModel.cs |
| 201 | ChangeComponentPropertiesDialogViewModel.cs |
| 202 | ChooseCollectionViewModel.cs |
| 203 | ConvertHairToCCXLMaterialsDialogViewModel.cs |
| 204 | CopyMeshAppearancesDialogViewModel.cs |
| 205 | CreateMaterialsDialogViewModel.cs |
| 206 | CreatePhotoModeAppViewModel.cs |
| 207 | DeleteOrDuplicateComponentDialogViewModel.cs |
| 208 | DeleteOrMoveFilesListDialogViewModel.cs |
| 209 | DialogViewModel.cs |
| 210 | ExportArgsDialogViewModel.cs |
| 211 | ExtractAmbigiousDialogViewModel.cs |
| 212 | ExtractEmbeddedFileDialogViewModel.cs |
| 213 | FirstSetupViewModel.cs |
| 214 | FolderPathInputDialogViewModel.cs |
| 215 | ImportArgsDialogViewModel.cs |
| 216 | InputDialogViewModel.cs |
| 217 | InstallerWizardViewModel.cs |
| 218 | LaunchProfileViewModel.cs |
| 219 | LaunchProfilesViewModel.cs |
| 220 | LocalizationStringViewModel.cs |
| 221 | MaterialsRepositoryDialogViewModel.cs |
| 222 | NewFileViewModel.cs |
| 223 | OpenFileViewModel.cs |
| 224 | PlayerHeadDialogViewModel.cs |
| 225 | ProjectSettingsDialogViewModel.cs |
| 226 | ProjectWizardViewModel.cs |
| 227 | RenameDialogViewModel.cs |
| 228 | SaveGameSelectionDialogModel.cs |
| 229 | SceneInputDialogViewModel.cs |
| 230 | ScriptManagerViewModel.cs |
| 231 | SearchAndReplaceDialogViewModel.cs |
| 232 | SelectAnimationPathViewModel.cs |
| 233 | SelectDropdownEntryDialogViewModel.cs |
| 234 | ShowChecklistDialogueViewModel.cs |
| 235 | ShowDictionaryForCopyDialogViewModel.cs |
| 236 | SoundModdingViewModel.cs |
| 237 | StringsGUIImporterIDDialogViewModel.cs |
| 238 | StringsGuiScriptsPrefixDialogViewModel.cs |
| 239 | TypeSelectorDialogViewModel.cs |
| 240 | UpdateDialogViewModel.cs |
| 241 | UserWizardViewModel.cs |
| 242 | BehaviorGraphViewModel.cs |
| 243 | ConnectionViewModel.cs |
| 244 | DocumentViewModel.cs |
| 245 | GraphDocumentSearchHelper.cs |
| 246 | IDocumentViewModel.cs |
| 247 | IDocumentViewModel_old.cs |
| 248 | NodeViewModel.cs |
| 249 | PendingConnectionViewModel.cs |
| 250 | PhaseNodeViewModel.cs |
| 251 | QuestPhaseGraphViewModel.cs |
| 252 | QuestPhaseTabDefinition.cs |
| 253 | RDTDataViewModel.cs |
| 254 | RDTGraphViewModel.cs |
| 255 | RDTGraphViewModel2.cs |
| 256 | RDTInkTextureAtlasViewModel.cs |
| 257 | RDTLayeredPreviewViewModel.cs |
| 258 | RDTMeshViewModel.cs |
| 259 | RDTTextViewModel.cs |
| 260 | RDTTextureViewModel.cs |
| 261 | RDTWidgetViewModel.cs |
| 262 | RedDocumentTabViewModel.cs |
| 263 | RedDocumentViewModel.cs |
| 264 | RedDocumentViewToolbarModel.cs |
| 265 | SceneGraphViewModel.cs |
| 266 | SocketViewModel.cs |
| 267 | TweakEntryViewModel.cs |
| 268 | TweakXLDocumentViewModel.cs |
| 269 | WScriptDocumentViewModel.cs |
| 270 | ValueChangedEventArgs.cs |
| 271 | AbstractImportExportViewModel.cs |
| 272 | CallbackArguments.cs |
| 273 | ExportViewModel.cs |
| 274 | FloatingPaneViewModel.cs |
| 275 | BaseConnectorViewModel.cs |
| 276 | ConnectionViewModel.cs |
| 277 | IDynamicInputNode.cs |
| 278 | IGraphProvider.cs |
| 279 | InputConnectorViewModel.cs |
| 280 | NodeViewModel.cs |
| 281 | BehaviorNodeViewModel.cs |
| 282 | GraphNodeStyling.cs |
| 283 | NodeProperties.cs |
| 284 | BaseQuestViewModel.cs |
| 285 | DynamicQuestViewModel.cs |
| 286 | QuestConditionHelper.cs |
| 287 | QuestConnectionViewModel.cs |
| 288 | QuestInputConnectorViewModel.cs |
| 289 | QuestOutputConnectorViewModel.cs |
| 290 | graphGraphNodeDefinitionWrapper.cs |
| 291 | questAICommandNodeBaseWrapper.cs |
| 292 | questAchievementManagerNodeDefinitionWrapper.cs |
| 293 | questAudioNodeDefinitionWrapper.cs |
| 294 | questCharacterManagerNodeDefinitionWrapper.cs |
| 295 | questCheckpointNodeDefinitionWrapper.cs |
| 296 | questClearForcedBehavioursNodeDefinitionWrapper.cs |
| 297 | questCombatNodeDefinitionWrapper.cs |
| 298 | questConditionNodeDefinitionWrapper.cs |
| 299 | questConfigurableAICommandNodeWrapper.cs |
| 300 | questCrowdManagerNodeDefinitionWrapper.cs |
| 301 | questCutControlNodeDefinitionWrapper.cs |
| 302 | questDeletionMarkerNodeDefinitionWrapper.cs |
| 303 | questDisableableNodeDefinitionWrapper.cs |
| 304 | questDynamicSpawnSystemNodeDefinitionWrapper.cs |
| 305 | questEmbeddedGraphNodeDefinitionWrapper.cs |
| 306 | questEndNodeDefinitionWrapper.cs |
| 307 | questEntityManagerNodeDefinitionWrapper.cs |
| 308 | questEnvironmentManagerNodeDefinitionWrapper.cs |
| 309 | questEquipItemNodeDefinitionWrapper.cs |
| 310 | questEventManagerNodeDefinitionWrapper.cs |
| 311 | questFXManagerNodeDefinitionWrapper.cs |
| 312 | questFactsDBManagerNodeDefinitionWrapper.cs |
| 313 | questFlowControlNodeDefinitionWrapper.cs |
| 314 | questForcedBehaviourNodeDefinitionWrapper.cs |
| 315 | questGameManagerNodeDefinitionWrapper.cs |
| 316 | questIONodeDefinitionWrapper.cs |
| 317 | questInputNodeDefinitionWrapper.cs |
| 318 | questInstancedCrowdControlNodeDefinitionWrapper.cs |
| 319 | questInteractiveObjectManagerNodeDefinitionWrapper.cs |
| 320 | questItemManagerNodeDefinitionWrapper.cs |
| 321 | questJournalNodeDefinitionWrapper.cs |
| 322 | questLogicalAndNodeDefinitionWrapper.cs |
| 323 | questLogicalBaseNodeDefinitionWrapper.cs |
| 324 | questLogicalHubNodeDefinitionWrapper.cs |
| 325 | questLogicalXorNodeDefinitionWrapper.cs |
| 326 | questMappinManagerNodeDefinitionWrapper.cs |
| 327 | questMiscAICommandNodeWrapper.cs |
| 328 | questMovePuppetNodeDefinitionWrapper.cs |
| 329 | questNodeDefinitionWrapper.cs |
| 330 | questOutputNodeDefinitionWrapper.cs |
| 331 | questPauseConditionNodeDefinitionWrapper.cs |
| 332 | questPhaseNodeDefinitionWrapper.cs |
| 333 | questPhoneManagerNodeDefinitionWrapper.cs |
| 334 | questPuppetAIManagerNodeDefinitionWrapper.cs |
| 335 | questRandomizerNodeDefinitionWrapper.cs |
| 336 | questRenderFxManagerNodeDefinitionWrapper.cs |
| 337 | questRewardManagerNodeDefinitionWrapper.cs |
| 338 | questSceneManagerNodeDefinitionWrapper.cs |
| 339 | questSceneNodeDefinitionWrapper.cs |
| 340 | questSendAICommandNodeDefinitionWrapper.cs |
| 341 | questSignalStoppingNodeDefinitionWrapper.cs |
| 342 | questSpawnManagerNodeDefinitionWrapper.cs |
| 343 | questStartEndNodeDefinitionWrapper.cs |
| 344 | questStartNodeDefinitionWrapper.cs |
| 345 | questSwitchNodeDefinitionWrapper.cs |
| 346 | questTeleportPuppetNodeDefinitionWrapper.cs |
| 347 | questTimeManagerNodeDefinitionWrapper.cs |
| 348 | questTransformAnimatorNodeDefinitionWrapper.cs |
| 349 | questTriggerManagerNodeDefinitionWrapper.cs |
| 350 | questTypedSignalStoppingNodeDefinitionWrapper.cs |
| 351 | questUIManagerNodeDefinitionWrapper.cs |
| 352 | questUseWorkspotNodeDefinitionWrapper.cs |
| 353 | questVehicleNodeCommandDefinitionWrapper.cs |
| 354 | questVehicleNodeDefinitionWrapper.cs |
| 355 | questVisionModesManagerNodeDefinitionWrapper.cs |
| 356 | questVoicesetManagerNodeDefinitionWrapper.cs |
| 357 | questWorldDataManagerNodeDefinitionWrapper.cs |
| 358 | tempshitMapPinManagerNodeDefinitionWrapper.cs |
| 359 | BaseSceneViewModel.cs |
| 360 | DynamicSceneViewModel.cs |
| 361 | SceneConnectionViewModel.cs |
| 362 | SceneInputConnectorViewModel.cs |
| 363 | SceneOutputConnectorViewModel.cs |
| 364 | scnAndNodeWrapper.cs |
| 365 | scnChoiceNodeWrapper.cs |
| 366 | scnCutControlNodeWrapper.cs |
| 367 | scnDeletionMarkerNodeWrapper.cs |
| 368 | scnEndNodeWrapper.cs |
| 369 | scnFlowControlNodeWrapper.cs |
| 370 | scnHubNodeWrapper.cs |
| 371 | scnInterruptManagerNodeWrapper.cs |
| 372 | scnQuestNodeWrapper.cs |
| 373 | scnRandomizerNodeWrapper.cs |
| 374 | scnRewindableSectionNodeWrapper.cs |
| 375 | scnSceneGraphNodeWrapper.cs |
| 376 | scnSectionNodeWrapper.cs |
| 377 | scnStartNodeWrapper.cs |
| 378 | scnXorNodeWrapper.cs |
| 379 | OutputConnectorViewModel.cs |
| 380 | PendingConnectionViewModel.cs |
| 381 | RedGraph.Behavior.cs |
| 382 | RedGraph.Quest.cs |
| 383 | RedGraph.Scene.cs |
| 384 | RedGraph.cs |
| 385 | HomePageViewModel.cs |
| 386 | PageViewModel.cs |
| 387 | ModInfoViewModel.cs |
| 388 | ModsViewModel.cs |
| 389 | PluginViewModel.cs |
| 390 | PluginsToolViewModel.cs |
| 391 | RecentlyUsedItemsViewModel.cs |
| 392 | WelcomePageViewModel.cs |
| 393 | ImportViewModel.cs |
| 394 | ScriptDirectoryViewModel.cs |
| 395 | ScriptFileViewModel.cs |
| 396 | ScriptViewModel.cs |
| 397 | AppViewModel.ComplexFiles.cs |
| 398 | AppViewModel.WScript.cs |
| 399 | AppViewModel.cs |
| 400 | ChunkPropertyViewModel.cs |
| 401 | ChunkViewModel.cs |
| 402 | GroupedChunkViewModel.cs |
| 403 | IAppViewModel.cs |
| 404 | MenuBarViewModel.cs |
| 405 | PaneViewModel.cs |
| 406 | RedBoolViewModel.cs |
| 407 | RedColorViewModel.cs |
| 408 | RedStringViewModel.cs |
| 409 | RibbonViewModel.cs |
| 410 | StatusBarViewModel.cs |
| 411 | SectionTimelineViewModel.cs |
| 412 | AssetBrowserViewModel.cs |
| 413 | AudioPlayerViewModel.cs |
| 414 | ChunkViewModel.ContextMenu.cs |
| 415 | ChunkViewModel.Descriptor.cs |
| 416 | ChunkViewModel.ExpansionStates.cs |
| 417 | ChunkViewModel.MeshFunctions.cs |
| 418 | ChunkViewModel.SearchAndReplace.cs |
| 419 | ChunkViewModel.UserInteractionStates.cs |
| 420 | ChunkViewModel.Value.cs |
| 421 | CollectionItemViewModel.cs |
| 422 | EditorDifficultyLevel.cs |
| 423 | EditorDifficultyLevelFieldFactory.cs |
| 424 | ExportableItemViewModel.cs |
| 425 | FileSystemViewModel.cs |
| 426 | HashToolViewModel.cs |
| 427 | ImportExportItemViewModel.cs |
| 428 | ImportableItemViewModel.cs |
| 429 | LocKeyBrowserViewModel.cs |
| 430 | LogViewModel.cs |
| 431 | ProjectExplorerViewModel.cs |
| 432 | PropertiesViewModel.cs |
| 433 | RedDirectoryViewModel.cs |
| 434 | RedFileViewModel.cs |
| 435 | ToolViewModel.cs |
| 436 | TweakBrowserViewModel.cs |
| 437 | WolvenKit.App.csproj |

## Architecture

The analyzed files contain approximately **2161 lines** of code across **30 files** (of 437 total).

### Notable Types

- class ActiveDocumentConverter
- class BoolToBrushConverter
- class ChunkViewmodelFactory
- class ColorToSolidColorBrushConverter
- class Constants
- class CornerRadiusExtensions
- class DialogViewModelFactory
- class DocumentTabViewmodelFactory
- class DocumentViewmodelFactory
- class EquipmentItemData
- class FlowToDirectionConverter
- class GameControllerFactory
- class GridLengthExtensions
- class ICommandExtensions
- class JsonArchiveConverter
- class JsonFileEntryConverter
- class ListToStringConverter
- class MockGameController
- class NodeViewModelExtensions
- class PhotomodeEntityAnimations
- class RED4Controller
- class RectExtensions
- class RichTextBoxExtensions
- class SharpDXExtensions
- class StringPathToItemStringConverter
- class ThicknessExtensions
- class Tw3Controller
- class WkitBrushes
- class WkitColors
- enum ArchiveXlHidingTags
- enum EAppStatus
- enum EDockedViews
- enum EManagerType
- enum EProjectType
- enum EquipmentExSlot
- enum EquipmentItemSlot
- enum EquipmentItemSubSlot
- enum EquipmentWeaponSlot
- enum EquipmentWeaponSubSlot
- enum GarmentSupportTags
- enum PhotomodeBodyGender
- enum ProjectFolder
- enum ScriptSource
- interface IChunkViewmodelFactory
- interface IDialogViewModelFactory
- interface IDocumentTabViewmodelFactory
- interface IFactory
- interface IGameController
- interface IGameControllerFactory

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using DynamicData
- using Newtonsoft.Json
- using ProtoBuf
- using ReactiveUI.Fody.Helpers
- using System
- using System.Collections.Generic
- using System.Diagnostics
- using System.IO
- using System.IO.Compression
- using System.Linq
- using System.Text
- using System.Text.Json
- using System.Text.Json.Serialization
- using System.Threading
- using System.Threading.Tasks
- using System.Windows
- using System.Windows.Data
- using System.Windows.Media
- using System.Xml.Linq

## Citations

[1] Source files under `WolvenKit.App/` in the WolvenKit repository
