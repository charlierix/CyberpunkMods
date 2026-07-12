---
type: "Config"
title: "RED4 Save Constants"
description: "Save system constants — 1 files."
resource: "WolvenKit.RED4/Save/CSAV/CyberpunkSaveFile.cs"
tags: [systems, save, constants, config]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Save system constants — 1 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **78 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| CyberpunkSaveFile.cs | 13 | class CyberpunkSaveFile |
| CyberpunkSaveFileInfo.cs | 7 | class CyberpunkSaveFileInfo |
| CyberpunkSaveHeaderStruct.cs | 32 | struct CyberpunkSaveHeaderStruct |
| NodeEntry.cs | 60 | class NodeEntry |
| NodeInfo.cs | 14 | class NodeInfo |
| IItemInfoProvider.cs | 6 | interface IItemInfoProvider |
| ItemAdditionalInfo.cs | 47 | class ItemAdditionalInfo |
| ItemData.cs | 31 | class ItemData, enum ItemFlag |
| ItemInfo.cs | 75 | class ItemInfo, enum ItemStructure |
| ItemSlotPart.cs | 13 | class ItemSlotPart |
| SubInventory.cs | 7 | class SubInventory |
| Constants.cs | 108 | class Constants, class Magic, class Parsing, class NodeNames |
| Compression.cs | 291 | class Compression, delegate DataChunkInfo |
| Exceptions.cs | 7 | class InvalidFormatException |
| Extensions.cs | 58 | class Extensions |
| Interfaces.cs | 14 | interface INodeData, interface INodeParser |
| InventoryHelper.cs | 159 | class InventoryHelper |
| ParserHelper.cs | 81 | class ParserHelper |
| SaveHashHelper.cs | 103 | class SaveHashHelper |
| CyberpunkSaveReader.cs | 296 | class CyberpunkSaveReader |

## Member Types

All **78** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | CyberpunkSaveFile.cs |
| 2 | CyberpunkSaveFileInfo.cs |
| 3 | CyberpunkSaveHeaderStruct.cs |
| 4 | NodeEntry.cs |
| 5 | NodeInfo.cs |
| 6 | IItemInfoProvider.cs |
| 7 | ItemAdditionalInfo.cs |
| 8 | ItemData.cs |
| 9 | ItemInfo.cs |
| 10 | ItemSlotPart.cs |
| 11 | SubInventory.cs |
| 12 | Constants.cs |
| 13 | Compression.cs |
| 14 | Exceptions.cs |
| 15 | Extensions.cs |
| 16 | Interfaces.cs |
| 17 | InventoryHelper.cs |
| 18 | ParserHelper.cs |
| 19 | SaveHashHelper.cs |
| 20 | CyberpunkSaveReader.cs |
| 21 | CyberpunkSaveWriter.cs |
| 22 | Enums.cs |
| 23 | NodeWriter.cs |
| 24 | ArcadeSystemParser.cs |
| 25 | CAttitudeManagerParser.cs |
| 26 | CCoverManagerParser.cs |
| 27 | CharacterCustomizationAppearancesParser.cs |
| 28 | ChoicesParser.cs |
| 29 | CommunitySystemParser.cs |
| 30 | ContainerManagerInjectedLootParser.cs |
| 31 | ContainerManagerLootSlotAvailabilityParser.cs |
| 32 | ContainerManagerNPCLootBagsVer2Parser.cs |
| 33 | ContainerManagerNPCLootBagsVer3LootedIDsParser.cs |
| 34 | ContainerManagerParser.cs |
| 35 | CustomArrayParser.cs |
| 36 | DSDynamicConnectionsParser.cs |
| 37 | DefaultParser.cs |
| 38 | DelaySystemCoreParser.cs |
| 39 | DelaySystemDelayedStructsParser.cs |
| 40 | DelaySystemParser.cs |
| 41 | DeviceSystemParser.cs |
| 42 | DirectorSystemParser.cs |
| 43 | DynamicEntityIDSystemParser.cs |
| 44 | EventManagerParser.cs |
| 45 | FactsDBParser.cs |
| 46 | FactsTableParser.cs |
| 47 | GameAudioParser.cs |
| 48 | GameSessionConfigParser.cs |
| 49 | GameSessionDescParser.cs |
| 50 | GodModeSystemParser.cs |
| 51 | InventoryParser.cs |
| 52 | ItemDataParser.cs |
| 53 | ItemDropStorageManagerParser.cs |
| 54 | ItemDropStorageParser.cs |
| 55 | JournalManagerParser.cs |
| 56 | MovingPlatformSystemParser.cs |
| 57 | MusicSystemParser.cs |
| 58 | PackageParser.cs |
| 59 | PersistencySystem2Parser.cs |
| 60 | PlayerSystemParser.cs |
| 61 | QuestDebugLogManagerParser.cs |
| 62 | QuestMusicHistoryParser.cs |
| 63 | QuestSystemParser.cs |
| 64 | RadioSystemParser.cs |
| 65 | ReactionSystemParser.cs |
| 66 | ReactionSystemV2Parser.cs |
| 67 | RenderGameplayEffectsManagerSystemParser.cs |
| 68 | ScanningControllerParser.cs |
| 69 | ScriptableSystemsContainerParser.cs |
| 70 | StatPoolSystemParser.cs |
| 71 | StatsSystemParser.cs |
| 72 | TierSystemParser.cs |
| 73 | TimeSystemCoreParser.cs |
| 74 | UniqueItemCounterParser.cs |
| 75 | WardrobeSystemClothingSetsParser.cs |
| 76 | WardrobeSystemParser.cs |
| 77 | WorkspotInstancesSavedataParser.cs |
| 78 | zParserTemplate.cs |

## Architecture

The analyzed files contain approximately **2275 lines** of code across **30 files** (of 78 total).

### Notable Types

- class ArcadeSystem
- class ArcadeSystemParser
- class CAttitudeManager
- class CAttitudeManagerEntry
- class CAttitudeManagerParser
- class CCoverManager
- class CCoverManagerEntry
- class CCoverManagerParser
- class CharacterCustomizationAppearancesParser
- class Choices
- class ChoicesParser
- class CommunitySystem
- class CommunitySystemParser
- class Compression
- class Constants
- class ContainerManagerInjectedLoot
- class ContainerManagerInjectedLootParser
- class CyberpunkSaveFile
- class CyberpunkSaveFileInfo
- class CyberpunkSaveReader
- class CyberpunkSaveWriter
- class Entry
- class Entry1
- class Entry2
- class Extensions
- class InvalidFormatException
- class InventoryHelper
- class ItemAdditionalInfo
- class ItemData
- class ItemInfo
- class ItemSlotPart
- class Magic
- class NodeEntry
- class NodeInfo
- class NodeMeta
- class NodeNames
- class NodeWriter
- class ParserHelper
- class Parsing
- class SaveHashHelper
- class SubEntry
- class SubInventory
- class gameuiCharacterCustomizationPresetWrapper
- delegate DataChunkInfo
- enum EFileReadErrorCodes
- enum ItemFlag
- enum ItemStructure
- interface IItemInfoProvider
- interface INodeData
- interface INodeParser

## Dependencies

- using System.Diagnostics
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Save.Classes
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/Save/CSAV/` in the WolvenKit repository
