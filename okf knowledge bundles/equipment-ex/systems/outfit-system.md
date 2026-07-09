---
type: System
title: Outfit System
description: Core outfit management system extending ScriptableSystem. Handles outfit assembly, slot management, equipment operations, and transaction logic. Largest module with 121 declared types.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitSystem.reds"
tags: ['equipment-ex', 'redscript', 'systems', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Core outfit management system extending ScriptableSystem. Handles outfit assembly, slot management, equipment operations, and transaction logic. Largest module with 121 declared types.

This concept covers 117 member declarations from 1 source file(s): OutfitSystem.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `OutfitSystem` extends ScriptableSystem | 102 methods |
| Method |  `OnAttach()` | — |
| Method |  `OnDetach()` | — |
| Method |  `OnRestored(saveVersion: Int32, gameVersion: Int32)` | — |
| Method |  `OnPlayerAttach(request: ref<PlayerAttachRequest>)` | — |
| Method |  `InitializeState()` | — |
| Method |  `InitializeSlotsInfo()` | — |
| Method |  `InitializeBlackboards()` | — |
| Method |  `InitializePlayerAndSystems()` | — |
| Method |  `UninitializeSystems()` | — |
| Method |  `ConvertClothingSets()` | — |
| Method |  `GetTimestamp()` -> `Float` | — |
| Method |  `AddItemToState(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `RemoveItemFromState(itemID: ItemID)` | — |
| Method |  `RemoveSlotFromState(slotID: TweakDBID)` | — |
| Method |  `RemoveAllItemsFromState()` | — |
| Method |  `CleanUpPreviewItems()` | — |
| Method |  `MigrateState()` | — |
| Method |  `AttachVisualToSlot(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `DetachVisualFromSlot(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `AttachAllVisualsToSlots(opt refresh: Bool)` | — |
| Method |  `DetachAllVisualsFromSlots(opt refresh: Bool)` | — |
| Method |  `ReattachVisualInSlot(slotID: TweakDBID)` | — |
| Method |  `ReattachVisualForItem(itemID: ItemID)` | — |
| Method |  `RefreshSlotAttachment(slotID: TweakDBID)` | — |
| Method |  `UpdateCameraDependentVisuals()` | — |
| Method |  `EnableGarmentOffsets()` | — |
| Method |  `DisableGarmentOffsets()` | — |
| Method |  `HideEquipment()` | — |
| Method |  `ShowEquipment()` | — |
| Method |  `CloneEquipment(opt ignoreItemID: ItemID, opt ignoreSlotID: TweakDBID)` | — |
| Method |  `GetEquipmentParts()` -> `array<ref<OutfitPart>>` | — |
| Method |  `ResetEquipmentHash()` | — |
| Method |  `UpdateEquipmentHash()` | — |
| Method |  `UpdateBlackboard(slotID: TweakDBID)` | — |
| Method |  `UpdateBlackboard(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `TriggerActivationEvent(opt outfitName: CName)` | — |
| Method |  `TriggerDeactivationEvent()` | — |
| Method |  `TriggerAttachmentEvent(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `TriggerDetachmentEvent(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `TriggerOutfitListEvent()` | — |
| Method |  `TriggerMappingEvent()` | — |
| Method |  `IsBlocked()` -> `Bool` | — |
| Method |  `IsDisabled()` -> `Bool` | — |
| Method |  `Enable()` | — |
| Method |  `Disable()` | — |
| Method |  `IsActive()` -> `Bool` | — |
| Method |  `Activate()` | — |
| Method |  `ActivateWithoutClone()` | — |
| Method |  `ActivateWithoutSlot(slotID: TweakDBID)` | — |
| Method |  `ActivateWithoutItem(itemID: ItemID)` | — |
| Method |  `Reactivate()` | — |
| Method |  `Deactivate()` | — |
| Method |  `GetItemSlot(recordID: TweakDBID)` -> `TweakDBID` | — |
| Method |  `GetItemSlot(itemID: ItemID)` -> `TweakDBID` | — |
| Method |  `GetItemSlots(recordID: TweakDBID)` -> `array<TweakDBID>` | — |
| Method |  `GetItemSlots(itemID: ItemID)` -> `array<TweakDBID>` | — |
| Method |  `IsOccupied(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `IsEquipped(itemID: ItemID)` -> `Bool` | — |
| Method |  `IsEquippable(recordID: TweakDBID)` -> `Bool` | — |
| Method |  `IsEquippable(itemID: ItemID)` -> `Bool` | — |
| Method |  `IsEquippable(recordID: TweakDBID, slotID: TweakDBID)` -> `Bool` | — |
| Method |  `IsEquippable(itemID: ItemID, slotID: TweakDBID)` -> `Bool` | — |
| Method |  `EquipItem(recordID: TweakDBID, opt slotID: TweakDBID)` -> `Bool` | — |
| Method |  `EquipItem(itemID: ItemID, opt slotID: TweakDBID)` -> `Bool` | — |
| Method |  `UnequipItem(recordID: TweakDBID)` -> `Bool` | — |
| Method |  `UnequipItem(itemID: ItemID)` -> `Bool` | — |
| Method |  `UnequipSlot(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `UnequipAll()` | — |
| Method |  `AssignItem(itemID: ItemID, slotID: TweakDBID)` -> `Bool` | — |
| Method |  `ApplyMapping(itemID: ItemID, slotID: TweakDBID)` | — |
| Method |  `ResetMapping(itemID: ItemID)` | — |
| Method |  `ApplyMappings()` | — |
| Method |  `ResetMappings()` | — |
| Method |  `IsEquipped(name: CName)` -> `Bool` | — |
| Method |  `HasOutfit(name: CName)` -> `Bool` | — |
| Method |  `LoadOutfit(name: CName)` -> `Bool` | — |
| Method |  `AddOutfit(name: CName, parts: array<ref<OutfitPart>>, opt overwrite: Bool)` -> `Bool` | — |
| Method |  `SaveOutfit(name: CName, opt overwrite: Bool)` -> `Bool` | — |
| Method |  `CopyOutfit(name: CName, from: CName)` -> `Bool` | — |
| Method |  `DeleteOutfit(name: CName)` -> `Bool` | — |
| Method |  `DeleteAllOutfits()` -> `Bool` | — |
| Method |  `GetOutfits()` -> `array<CName>` | — |
| Method |  `GetOutfitParts(name: CName)` -> `array<ref<OutfitPart>>` | — |
| Method |  `GiveItem(recordID: TweakDBID)` -> `ItemID` | — |
| Method |  `GiveItem(itemID: ItemID)` -> `ItemID` | — |
| Method |  `EquipPuppetItem(puppet: ref<gamePuppet>, itemID: ItemID)` | — |
| Method |  `UnequipPuppetItem(puppet: ref<gamePuppet>, itemID: ItemID)` | — |
| Method |  `EquipPuppetOutfit(puppet: ref<gamePuppet>, opt items: script_ref<array<ItemID>>)` | — |
| Method |  `EquipPuppetOutfit(puppet: ref<gamePuppet>, useOutfit: Bool, opt items: script_ref<array<ItemID>>)` | — |
| Method |  `EquipPuppetOutfit(puppet: ref<gamePuppet>, outfitName: CName, opt items: script_ref<array<ItemID>>)` | — |
| Method |  `EquipPuppetParts(puppet: ref<gamePuppet>, parts: array<ref<OutfitPart>>, opt items: script_ref<array<ItemID>>)` | — |
| Method |  `UpdatePuppetFromBlackboard(puppet: ref<gamePuppet>)` -> `Bool` | — |
| Method |  `IsBaseSlot(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `IsOutfitSlot(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `IsManagedSlot(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `IsManagedArea(area: gamedataEquipmentArea)` -> `Bool` | — |
| Method |  `IsCameraDependentSlot(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `GetOutfitSlots()` -> `array<TweakDBID>` | — |
| Method |  `GetUsedSlots()` -> `array<TweakDBID>` | — |
| Method |  `GetSlotName(slotID: TweakDBID)` -> `String` | — |
| Method |  `GetItemName(itemID: ItemID)` -> `String` | — |
| Method |  `GetInstance(game: GameInstance)` -> `ref<OutfitSystem>` | — |
| Class | `PlayerSlotsCallback` extends AttachmentSlotsScriptCallback | 4 methods |
| Method |  `OnItemEquipped(slotID: TweakDBID, itemID: ItemID)` -> `Void` | — |
| Method |  `OnItemEquippedVisual(slotID: TweakDBID, itemID: ItemID)` -> `Void` | — |
| Method |  `OnItemUnequippedComplete(slotID: TweakDBID, itemID: ItemID)` -> `Void` | — |
| Method |  `Create(system: ref<OutfitSystem>)` -> `ref<PlayerSlotsCallback>` | — |
| Class | `DelayedRestoreCallback` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(system: ref<OutfitSystem>)` -> `ref<DelayedRestoreCallback>` | — |
| Class | `DelayedEquipCallback` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(system: ref<OutfitSystem>, itemID: ItemID)` -> `ref<DelayedEquipCallback>` | — |
| Class | `DelayedAttachCallback` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(transactionSystem: wref<TransactionSystem>, player: wref<GameObject>, slotID: TweakDBID, itemID: ItemID)` -> `ref<DelayedAttachCallback>` | — |

# Notable Methods

## OutfitSystem

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnAttach` | `` | `` |
| `OnDetach` | `` | `` |
| `OnRestored` | `saveVersion: Int32, gameVersion: Int32` | `` |
| `OnPlayerAttach` | `request: ref<PlayerAttachRequest>` | `` |
| `InitializeState` | `` | `` |
| `InitializeSlotsInfo` | `` | `` |
| `InitializeBlackboards` | `` | `` |
| `InitializePlayerAndSystems` | `` | `` |
| `UninitializeSystems` | `` | `` |
| `ConvertClothingSets` | `` | `` |
| `GetTimestamp` | `` | `Float` |
| `AddItemToState` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `RemoveItemFromState` | `itemID: ItemID` | `` |
| `RemoveSlotFromState` | `slotID: TweakDBID` | `` |
| `RemoveAllItemsFromState` | `` | `` |
| `CleanUpPreviewItems` | `` | `` |
| `MigrateState` | `` | `` |
| `AttachVisualToSlot` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `DetachVisualFromSlot` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `AttachAllVisualsToSlots` | `opt refresh: Bool` | `` |
| `DetachAllVisualsFromSlots` | `opt refresh: Bool` | `` |
| `ReattachVisualInSlot` | `slotID: TweakDBID` | `` |
| `ReattachVisualForItem` | `itemID: ItemID` | `` |
| `RefreshSlotAttachment` | `slotID: TweakDBID` | `` |
| `UpdateCameraDependentVisuals` | `` | `` |
| `EnableGarmentOffsets` | `` | `` |
| `DisableGarmentOffsets` | `` | `` |
| `HideEquipment` | `` | `` |
| `ShowEquipment` | `` | `` |
| `CloneEquipment` | `opt ignoreItemID: ItemID, opt ignoreSlotID: TweakDBID` | `` |
| `GetEquipmentParts` | `` | `array<ref<OutfitPart>>` |
| `ResetEquipmentHash` | `` | `` |
| `UpdateEquipmentHash` | `` | `` |
| `UpdateBlackboard` | `slotID: TweakDBID` | `` |
| `UpdateBlackboard` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `TriggerActivationEvent` | `opt outfitName: CName` | `` |
| `TriggerDeactivationEvent` | `` | `` |
| `TriggerAttachmentEvent` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `TriggerDetachmentEvent` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `TriggerOutfitListEvent` | `` | `` |
| `TriggerMappingEvent` | `` | `` |
| `IsBlocked` | `` | `Bool` |
| `IsDisabled` | `` | `Bool` |
| `Enable` | `` | `` |
| `Disable` | `` | `` |
| `IsActive` | `` | `Bool` |
| `Activate` | `` | `` |
| `ActivateWithoutClone` | `` | `` |
| `ActivateWithoutSlot` | `slotID: TweakDBID` | `` |
| `ActivateWithoutItem` | `itemID: ItemID` | `` |
| `Reactivate` | `` | `` |
| `Deactivate` | `` | `` |
| `GetItemSlot` | `recordID: TweakDBID` | `TweakDBID` |
| `GetItemSlot` | `itemID: ItemID` | `TweakDBID` |
| `GetItemSlots` | `recordID: TweakDBID` | `array<TweakDBID>` |
| `GetItemSlots` | `itemID: ItemID` | `array<TweakDBID>` |
| `IsOccupied` | `slotID: TweakDBID` | `Bool` |
| `IsEquipped` | `itemID: ItemID` | `Bool` |
| `IsEquippable` | `recordID: TweakDBID` | `Bool` |
| `IsEquippable` | `itemID: ItemID` | `Bool` |
| `IsEquippable` | `recordID: TweakDBID, slotID: TweakDBID` | `Bool` |
| `IsEquippable` | `itemID: ItemID, slotID: TweakDBID` | `Bool` |
| `EquipItem` | `recordID: TweakDBID, opt slotID: TweakDBID` | `Bool` |
| `EquipItem` | `itemID: ItemID, opt slotID: TweakDBID` | `Bool` |
| `UnequipItem` | `recordID: TweakDBID` | `Bool` |
| `UnequipItem` | `itemID: ItemID` | `Bool` |
| `UnequipSlot` | `slotID: TweakDBID` | `Bool` |
| `UnequipAll` | `` | `` |
| `AssignItem` | `itemID: ItemID, slotID: TweakDBID` | `Bool` |
| `ApplyMapping` | `itemID: ItemID, slotID: TweakDBID` | `` |
| `ResetMapping` | `itemID: ItemID` | `` |
| `ApplyMappings` | `` | `` |
| `ResetMappings` | `` | `` |
| `IsEquipped` | `name: CName` | `Bool` |
| `HasOutfit` | `name: CName` | `Bool` |
| `LoadOutfit` | `name: CName` | `Bool` |
| `AddOutfit` | `name: CName, parts: array<ref<OutfitPart>>, opt overwrite: Bool` | `Bool` |
| `SaveOutfit` | `name: CName, opt overwrite: Bool` | `Bool` |
| `CopyOutfit` | `name: CName, from: CName` | `Bool` |
| `DeleteOutfit` | `name: CName` | `Bool` |
| `DeleteAllOutfits` | `` | `Bool` |
| `GetOutfits` | `` | `array<CName>` |
| `GetOutfitParts` | `name: CName` | `array<ref<OutfitPart>>` |
| `GiveItem` | `recordID: TweakDBID` | `ItemID` |
| `GiveItem` | `itemID: ItemID` | `ItemID` |
| `EquipPuppetItem` | `puppet: ref<gamePuppet>, itemID: ItemID` | `` |
| `UnequipPuppetItem` | `puppet: ref<gamePuppet>, itemID: ItemID` | `` |
| `EquipPuppetOutfit` | `puppet: ref<gamePuppet>, opt items: script_ref<array<ItemID>>` | `` |
| `EquipPuppetOutfit` | `puppet: ref<gamePuppet>, useOutfit: Bool, opt items: script_ref<array<ItemID>>` | `` |
| `EquipPuppetOutfit` | `puppet: ref<gamePuppet>, outfitName: CName, opt items: script_ref<array<ItemID>>` | `` |
| `EquipPuppetParts` | `puppet: ref<gamePuppet>, parts: array<ref<OutfitPart>>, opt items: script_ref<array<ItemID>>` | `` |
| `UpdatePuppetFromBlackboard` | `puppet: ref<gamePuppet>` | `Bool` |
| `IsBaseSlot` | `slotID: TweakDBID` | `Bool` |
| `IsOutfitSlot` | `slotID: TweakDBID` | `Bool` |
| `IsManagedSlot` | `slotID: TweakDBID` | `Bool` |
| `IsManagedArea` | `area: gamedataEquipmentArea` | `Bool` |
| `IsCameraDependentSlot` | `slotID: TweakDBID` | `Bool` |
| `GetOutfitSlots` | `` | `array<TweakDBID>` |
| `GetUsedSlots` | `` | `array<TweakDBID>` |
| `GetSlotName` | `slotID: TweakDBID` | `String` |
| `GetItemName` | `itemID: ItemID` | `String` |
| `GetInstance` | `game: GameInstance` | `ref<OutfitSystem>` |

## PlayerSlotsCallback

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnItemEquipped` | `slotID: TweakDBID, itemID: ItemID` | `Void` |
| `OnItemEquippedVisual` | `slotID: TweakDBID, itemID: ItemID` | `Void` |
| `OnItemUnequippedComplete` | `slotID: TweakDBID, itemID: ItemID` | `Void` |
| `Create` | `system: ref<OutfitSystem>` | `ref<PlayerSlotsCallback>` |

# Related Concepts

- "Manages [outfit state](/systems/outfit-state.md) including equipped parts and visibility"
- "Exposes operations through the [EquipmentEx facade](/systems/facade.md)"
- "Integrated via [EquipmentSystem override](/overrides/equipment-system.md)"
- "Uses [slot matcher](/tweaks/slot-matcher.md) for TweakDB record mapping"

# Citations

- [OutfitSystem.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitSystem.reds)
