---
type: UI
title: Outfit Manager UI
description: inkLogicController for the outfit manager panel, handling outfit list display, selection, and configuration.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitManager.reds"
tags: ['equipment-ex', 'redscript', 'ui', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

inkLogicController for the outfit manager panel, handling outfit list display, selection, and configuration.

This concept covers 26 member declarations from 1 source file(s): UI/OutfitManager.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `OutfitManagerController` extends inkLogicController | 25 methods |
| Method |  `OnInitialize()` -> `Bool` | — |
| Method |  `Setup(outfitSystem: wref<OutfitSystem>, wardrobeScreen: wref<WardrobeScreenController>, buttonHints: wref<ButtonHints>)` | — |
| Method |  `SetEnabled(enabled: Bool)` | — |
| Method |  `InitializeLayout()` | — |
| Method |  `InitializeList()` | — |
| Method |  `PopulateList()` | — |
| Method |  `AppendToList(outfitName: CName, opt updateView: Bool)` | — |
| Method |  `RemoveFromList(outfitName: CName, opt updateView: Bool)` | — |
| Method |  `RefreshList(opt updateState: Bool)` | — |
| Method |  `OnOutfitListEntryClick(evt: ref<OutfitListEntryClick>)` | — |
| Method |  `OnOutfitListEntryItemHoverOver(evt: ref<OutfitListEntryHoverOver>)` | — |
| Method |  `OnOutfitListEntryItemHoverOut(evt: ref<OutfitListEntryHoverOut>)` | — |
| Method |  `ShowSaveOutfitPopup()` | — |
| Method |  `OnSaveOutfitPopupClosed(data: ref<inkGameNotificationData>)` | — |
| Method |  `ShowReplaceOutfitPopup(outfitName: CName)` | — |
| Method |  `OnReplaceOutfitPopupClosed(data: ref<inkGameNotificationData>)` | — |
| Method |  `ShowDeleteOutfitPopup(outfitName: CName)` | — |
| Method |  `OnDeleteOutfitPopupClosed(data: ref<inkGameNotificationData>)` | — |
| Method |  `ResetPopupState()` | — |
| Method |  `ShowButtonHints(entry: wref<OutfitListEntryData>)` | — |
| Method |  `OnOutfitUpdated(evt: ref<OutfitUpdated>)` | — |
| Method |  `OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>)` | — |
| Method |  `OnOutfitListUpdated(evt: ref<OutfitListUpdated>)` | — |
| Method |  `OnScrollChanged(value: Vector2)` | — |
| Method |  `AccessOutfitSystem()` -> `Bool` | — |

# Notable Methods

## OutfitManagerController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `Bool` |
| `Setup` | `outfitSystem: wref<OutfitSystem>, wardrobeScreen: wref<WardrobeScreenController>, buttonHints: wref<ButtonHints>` | `` |
| `SetEnabled` | `enabled: Bool` | `` |
| `InitializeLayout` | `` | `` |
| `InitializeList` | `` | `` |
| `PopulateList` | `` | `` |
| `AppendToList` | `outfitName: CName, opt updateView: Bool` | `` |
| `RemoveFromList` | `outfitName: CName, opt updateView: Bool` | `` |
| `RefreshList` | `opt updateState: Bool` | `` |
| `OnOutfitListEntryClick` | `evt: ref<OutfitListEntryClick>` | `` |
| `OnOutfitListEntryItemHoverOver` | `evt: ref<OutfitListEntryHoverOver>` | `` |
| `OnOutfitListEntryItemHoverOut` | `evt: ref<OutfitListEntryHoverOut>` | `` |
| `ShowSaveOutfitPopup` | `` | `` |
| `OnSaveOutfitPopupClosed` | `data: ref<inkGameNotificationData>` | `` |
| `ShowReplaceOutfitPopup` | `outfitName: CName` | `` |
| `OnReplaceOutfitPopupClosed` | `data: ref<inkGameNotificationData>` | `` |
| `ShowDeleteOutfitPopup` | `outfitName: CName` | `` |
| `OnDeleteOutfitPopupClosed` | `data: ref<inkGameNotificationData>` | `` |
| `ResetPopupState` | `` | `` |
| `ShowButtonHints` | `entry: wref<OutfitListEntryData>` | `` |
| `OnOutfitUpdated` | `evt: ref<OutfitUpdated>` | `` |
| `OnOutfitPartUpdated` | `evt: ref<OutfitPartUpdated>` | `` |
| `OnOutfitListUpdated` | `evt: ref<OutfitListUpdated>` | `` |
| `OnScrollChanged` | `value: Vector2` | `` |
| `AccessOutfitSystem` | `` | `Bool` |

# Related Concepts

- "Displays the [outfit list](/ui/outfit-list.md) for saved outfits"
- "Uses [option controls](/ui/options.md) for slot and source selection"
- "Includes [button controls](/ui/buttons.md) for collapse and settings"

# Citations

- [UI/OutfitManager.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitManager.reds)
