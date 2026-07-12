---
type: "System"
title: "RED4 Save Parsers"
description: "Save game node parsers for game systems (inventory, quests, stats, radio, wardrobe, devices, etc.) — 55 files."
resource: "WolvenKit.RED4/Save/Parser/ArcadeSystemParser.cs"
tags: [systems, save, parsers, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Save game node parsers for game systems (inventory, quests, stats, radio, wardrobe, devices, etc.) — 55 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **55 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ArcadeSystemParser.cs | 38 | class ArcadeSystem, class ArcadeSystemParser |
| CAttitudeManagerParser.cs | 56 | class CAttitudeManager, class CAttitudeManagerEntry, class CAttitudeManagerParser |
| CCoverManagerParser.cs | 56 | class CCoverManager, class CCoverManagerEntry, class CCoverManagerParser |
| CharacterCustomizationAppearancesParser.cs | 205 | class gameuiCharacterCustomizationPresetWrapper, class CharacterCustomizationAppearancesParser |
| ChoicesParser.cs | 87 | class Choices, class Entry1, class Entry2, class ChoicesParser |
| CommunitySystemParser.cs | 47 | class CommunitySystem, class CommunitySystemParser |
| ContainerManagerInjectedLootParser.cs | 130 | class ContainerManagerInjectedLoot, class Entry, class SubEntry, class ContainerManagerInjectedLootParser |
| ContainerManagerLootSlotAvailabilityParser.cs | 63 | class ContainerManagerLootSlotAvailability, class Entry, class ContainerManagerLootSlotAvailabilityParser |
| ContainerManagerNPCLootBagsVer2Parser.cs | 100 | class ContainerManagerNPCLootBagsVer2, class Entry, class Item, class ContainerManagerNPCLootBagsVer2Parser |
| ContainerManagerNPCLootBagsVer3LootedIDsParser.cs | 44 | class ContainerManagerNPCLootBagsVer3LootedIDs, class ContainerManagerNPCLootBagsVer3LootedIDsParser |
| ContainerManagerParser.cs | 59 | class ContainerManager, class Entry, class ContainerManagerParser |
| CustomArrayParser.cs | 42 | class CustomArray, class CustomArrayParser |
| DSDynamicConnectionsParser.cs | 103 | class DSDynamicConnections, class Entry, class DSDynamicConnectionsParser |
| DefaultParser.cs | 39 | class DefaultRepresentation, class DefaultParser |
| DelaySystemCoreParser.cs | 27 | class DelaySystemCore, class DelaySystemCoreParser |
| DelaySystemDelayedStructsParser.cs | 27 | class DelaySystemDelayedStructs, class DelaySystemDelayedStructsParser |
| DelaySystemParser.cs | 26 | class DelaySystemParser |
| DeviceSystemParser.cs | 21 | class DeviceSystemParser |
| DirectorSystemParser.cs | 56 | class DirectorSystem, class DirectorSystemClass1, class DirectorSystemParser |
| DynamicEntityIDSystemParser.cs | 68 | class DynamicEntityIDSystem, class DynamicEntityIDSystemParser |

## Member Types

All **55** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ArcadeSystemParser.cs |
| 2 | CAttitudeManagerParser.cs |
| 3 | CCoverManagerParser.cs |
| 4 | CharacterCustomizationAppearancesParser.cs |
| 5 | ChoicesParser.cs |
| 6 | CommunitySystemParser.cs |
| 7 | ContainerManagerInjectedLootParser.cs |
| 8 | ContainerManagerLootSlotAvailabilityParser.cs |
| 9 | ContainerManagerNPCLootBagsVer2Parser.cs |
| 10 | ContainerManagerNPCLootBagsVer3LootedIDsParser.cs |
| 11 | ContainerManagerParser.cs |
| 12 | CustomArrayParser.cs |
| 13 | DSDynamicConnectionsParser.cs |
| 14 | DefaultParser.cs |
| 15 | DelaySystemCoreParser.cs |
| 16 | DelaySystemDelayedStructsParser.cs |
| 17 | DelaySystemParser.cs |
| 18 | DeviceSystemParser.cs |
| 19 | DirectorSystemParser.cs |
| 20 | DynamicEntityIDSystemParser.cs |
| 21 | EventManagerParser.cs |
| 22 | FactsDBParser.cs |
| 23 | FactsTableParser.cs |
| 24 | GameAudioParser.cs |
| 25 | GameSessionConfigParser.cs |
| 26 | GameSessionDescParser.cs |
| 27 | GodModeSystemParser.cs |
| 28 | InventoryParser.cs |
| 29 | ItemDataParser.cs |
| 30 | ItemDropStorageManagerParser.cs |
| 31 | ItemDropStorageParser.cs |
| 32 | JournalManagerParser.cs |
| 33 | MovingPlatformSystemParser.cs |
| 34 | MusicSystemParser.cs |
| 35 | PackageParser.cs |
| 36 | PersistencySystem2Parser.cs |
| 37 | PlayerSystemParser.cs |
| 38 | QuestDebugLogManagerParser.cs |
| 39 | QuestMusicHistoryParser.cs |
| 40 | QuestSystemParser.cs |
| 41 | RadioSystemParser.cs |
| 42 | ReactionSystemParser.cs |
| 43 | ReactionSystemV2Parser.cs |
| 44 | RenderGameplayEffectsManagerSystemParser.cs |
| 45 | ScanningControllerParser.cs |
| 46 | ScriptableSystemsContainerParser.cs |
| 47 | StatPoolSystemParser.cs |
| 48 | StatsSystemParser.cs |
| 49 | TierSystemParser.cs |
| 50 | TimeSystemCoreParser.cs |
| 51 | UniqueItemCounterParser.cs |
| 52 | WardrobeSystemClothingSetsParser.cs |
| 53 | WardrobeSystemParser.cs |
| 54 | WorkspotInstancesSavedataParser.cs |
| 55 | zParserTemplate.cs |

## Architecture

The analyzed files contain approximately **1856 lines** of code across **30 files** (of 55 total).

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
- class ContainerManager
- class ContainerManagerInjectedLoot
- class ContainerManagerInjectedLootParser
- class ContainerManagerLootSlotAvailability
- class ContainerManagerLootSlotAvailabilityParser
- class ContainerManagerNPCLootBagsVer2
- class ContainerManagerNPCLootBagsVer2Parser
- class ContainerManagerNPCLootBagsVer3LootedIDs
- class ContainerManagerNPCLootBagsVer3LootedIDsParser
- class ContainerManagerParser
- class CustomArray
- class CustomArrayParser
- class DSDynamicConnections
- class DSDynamicConnectionsParser
- class DefaultParser
- class DefaultRepresentation
- class DelaySystemCore
- class DelaySystemCoreParser
- class DelaySystemDelayedStructs
- class DelaySystemDelayedStructsParser
- class DelaySystemParser
- class DeviceSystemParser
- class DirectorSystem
- class DirectorSystemClass1
- class DirectorSystemParser
- class DynamicEntityIDSystem
- class DynamicEntityIDSystemParser
- class Entry
- class Entry1
- class Entry2
- class EventManager
- class EventManagerParser
- class Fact
- class FactEntry
- class FactResolver
- class FactsDB
- class FactsDBParser

## Dependencies

- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.Save.IO
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.RED4/Save/Parser/` in the WolvenKit repository
