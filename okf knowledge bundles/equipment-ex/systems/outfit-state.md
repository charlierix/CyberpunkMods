---
type: System
title: Outfit State
description: Outfit part and state tracking system. Manages equipped parts, visibility, garment state transitions, and slot assignment data.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitState.reds"
tags: ['equipment-ex', 'redscript', 'systems', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Outfit part and state tracking system. Manages equipped parts, visibility, garment state transitions, and slot assignment data.

This concept covers 47 member declarations from 1 source file(s): OutfitState.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `OutfitPart` | 7 methods |
| Method |  `GetItemID()` -> `ItemID` | — |
| Method |  `GetItemHash()` -> `Uint64` | — |
| Method |  `SetItemID(itemID: ItemID)` | — |
| Method |  `GetSlotID()` -> `TweakDBID` | — |
| Method |  `SetSlotID(slotID: TweakDBID)` | — |
| Method |  `Create(itemID: ItemID, slotID: TweakDBID)` -> `ref<OutfitPart>` | — |
| Method |  `Clone(source: ref<OutfitPart>)` -> `ref<OutfitPart>` | — |
| Class | `OutfitSet` | 9 methods |
| Method |  `GetName()` -> `CName` | — |
| Method |  `SetName(name: CName)` | — |
| Method |  `GetParts()` -> `array<ref<OutfitPart>>` | — |
| Method |  `SetParts(parts: array<ref<OutfitPart>>)` | — |
| Method |  `GetHash()` -> `Uint64` | — |
| Method |  `UpdateHash()` | — |
| Method |  `Create(name: CName, timestamp: Float, parts: array<ref<OutfitPart>>)` -> `ref<OutfitSet>` | — |
| Method |  `Clone(name: CName, timestamp: Float, source: ref<OutfitSet>)` -> `ref<OutfitSet>` | — |
| Method |  `MakeHash(parts: array<ref<OutfitPart>>)` -> `Uint64` | — |
| Class | `OutfitState` | 28 methods |
| Method |  `IsDisabled()` -> `Bool` | — |
| Method |  `SetDisabled(state: Bool)` | — |
| Method |  `IsActive()` -> `Bool` | — |
| Method |  `SetActive(state: Bool)` | — |
| Method |  `GetParts()` -> `array<ref<OutfitPart>>` | — |
| Method |  `HasPart(itemID: ItemID)` -> `Bool` | — |
| Method |  `HasPart(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `GetPart(itemID: ItemID)` -> `ref<OutfitPart>` | — |
| Method |  `GetPart(slotID: TweakDBID)` -> `ref<OutfitPart>` | — |
| Method |  `UpdatePart(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `RemovePart(itemID: ItemID)` -> `Bool` | — |
| Method |  `RemovePart(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `ClearParts()` | — |
| Method |  `GetOutfits()` -> `array<ref<OutfitSet>>` | — |
| Method |  `GetOutfit(name: CName)` -> `ref<OutfitSet>` | — |
| Method |  `GetOutfitParts(name: CName)` -> `array<ref<OutfitPart>>` | — |
| Method |  `SaveOutfit(name: CName, overwrite: Bool, timestamp: Float)` -> `Bool` | — |
| Method |  `SaveOutfit(name: CName, parts: array<ref<OutfitPart>>, overwrite: Bool, timestamp: Float)` -> `Bool` | — |
| Method |  `CopyOutfit(name: CName, from: CName, timestamp: Float)` -> `Bool` | — |
| Method |  `DeleteOutfit(name: CName)` -> `Bool` | — |
| Method |  `DeleteAllOutfits()` -> `Bool` | — |
| Method |  `IsOutfit(name: CName)` -> `Bool` | — |
| Method |  `IsOutfit(hash: Uint64)` -> `Bool` | — |
| Method |  `GetMappings()` -> `array<ref<OutfitPart>>` | — |
| Method |  `UpdateMapping(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `UpdateHash()` | — |
| Method |  `Restore()` | — |
| Method |  `Create()` -> `ref<OutfitState>` | — |

# Notable Methods

## OutfitPart

| Method | Parameters | Returns |
|--------|------------|---------|
| `GetItemID` | `` | `ItemID` |
| `GetItemHash` | `` | `Uint64` |
| `SetItemID` | `itemID: ItemID` | `` |
| `GetSlotID` | `` | `TweakDBID` |
| `SetSlotID` | `slotID: TweakDBID` | `` |
| `Create` | `itemID: ItemID, slotID: TweakDBID` | `ref<OutfitPart>` |
| `Clone` | `source: ref<OutfitPart>` | `ref<OutfitPart>` |

## OutfitSet

| Method | Parameters | Returns |
|--------|------------|---------|
| `GetName` | `` | `CName` |
| `SetName` | `name: CName` | `` |
| `GetParts` | `` | `array<ref<OutfitPart>>` |
| `SetParts` | `parts: array<ref<OutfitPart>>` | `` |
| `GetHash` | `` | `Uint64` |
| `UpdateHash` | `` | `` |
| `Create` | `name: CName, timestamp: Float, parts: array<ref<OutfitPart>>` | `ref<OutfitSet>` |
| `Clone` | `name: CName, timestamp: Float, source: ref<OutfitSet>` | `ref<OutfitSet>` |
| `MakeHash` | `parts: array<ref<OutfitPart>>` | `Uint64` |

## OutfitState

| Method | Parameters | Returns |
|--------|------------|---------|
| `IsDisabled` | `` | `Bool` |
| `SetDisabled` | `state: Bool` | `` |
| `IsActive` | `` | `Bool` |
| `SetActive` | `state: Bool` | `` |
| `GetParts` | `` | `array<ref<OutfitPart>>` |
| `HasPart` | `itemID: ItemID` | `Bool` |
| `HasPart` | `slotID: TweakDBID` | `Bool` |
| `GetPart` | `itemID: ItemID` | `ref<OutfitPart>` |
| `GetPart` | `slotID: TweakDBID` | `ref<OutfitPart>` |
| `UpdatePart` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `RemovePart` | `itemID: ItemID` | `Bool` |
| `RemovePart` | `slotID: TweakDBID` | `Bool` |
| `ClearParts` | `` | `` |
| `GetOutfits` | `` | `array<ref<OutfitSet>>` |
| `GetOutfit` | `name: CName` | `ref<OutfitSet>` |
| `GetOutfitParts` | `name: CName` | `array<ref<OutfitPart>>` |
| `SaveOutfit` | `name: CName, overwrite: Bool, timestamp: Float` | `Bool` |
| `SaveOutfit` | `name: CName, parts: array<ref<OutfitPart>>, overwrite: Bool, timestamp: Float` | `Bool` |
| `CopyOutfit` | `name: CName, from: CName, timestamp: Float` | `Bool` |
| `DeleteOutfit` | `name: CName` | `Bool` |
| `DeleteAllOutfits` | `` | `Bool` |
| `IsOutfit` | `name: CName` | `Bool` |
| `IsOutfit` | `hash: Uint64` | `Bool` |
| `GetMappings` | `` | `array<ref<OutfitPart>>` |
| `UpdateMapping` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `UpdateHash` | `` | `` |
| `Restore` | `` | `` |
| `Create` | `` | `ref<OutfitState>` |

# Citations

- [OutfitState.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitState.reds)
