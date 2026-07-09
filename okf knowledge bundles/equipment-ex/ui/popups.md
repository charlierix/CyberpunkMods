---
type: UI
title: Popup Components
description: InMenuPopup subclasses for view settings, outfit mapping, archive, conflicts, and requirements dialogs.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ViewSettingsPopup.reds"
tags: ['equipment-ex', 'redscript', 'ui']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

InMenuPopup subclasses for view settings, outfit mapping, archive, conflicts, and requirements dialogs.

This concept covers 26 member declarations from 5 source file(s): UI/ViewSettingsPopup.reds, UI/OutfitMappingPopup.reds, UI/ArchivePopup.reds, UI/ConflictsPopup.reds, UI/RequirementsPopup.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `ViewSettingsPopup` extends InMenuPopup | 9 methods |
| Method |  `OnCreate()` | — |
| Method |  `SpawnOption(parent: ref<inkCompoundWidget>)` -> `ref<ItemSourceOptionController>` | — |
| Method |  `OnArrangeChildrenComplete()` | — |
| Method |  `OnChange(evt: ref<ItemSourceOptionChange>)` | — |
| Method |  `OnConfirm()` | — |
| Method |  `Show(requester: ref<inkGameController>)` | — |
| Method |  `OnCancel()` | — |
| Method |  `OnShown()` | — |
| Method |  `OnReparent(parent: ref<inkCompoundWidget>)` | — |
| Class | `OutfitMappingPopup` extends InMenuPopup | 9 methods |
| Method |  `OnCreate()` | — |
| Method |  `SpawnOption(parent: ref<inkCompoundWidget>)` -> `ref<OutfitSlotOptionController>` | — |
| Method |  `OnArrangeChildrenComplete()` | — |
| Method |  `OnChange(evt: ref<OutfitSlotOptionChange>)` | — |
| Method |  `OnConfirm()` | — |
| Method |  `Show(requester: ref<inkGameController>, itemID: ItemID, system: ref<OutfitSystem>)` | — |
| Method |  `OnCancel()` | — |
| Method |  `OnShown()` | — |
| Method |  `OnReparent(parent: ref<inkCompoundWidget>)` | — |
| Class | `ArchivePopup` | 1 methods |
| Method |  `Show(controller: ref<worlduiIGameController>)` -> `ref<inkGameNotificationToken>` | — |
| Class | `ConflictsPopup` | 1 methods |
| Method |  `Show(controller: ref<inkGameController>)` -> `ref<inkGameNotificationToken>` | — |
| Class | `RequirementsPopup` | 1 methods |
| Method |  `Show(controller: ref<worlduiIGameController>)` -> `ref<inkGameNotificationToken>` | — |

# Notable Methods

## ViewSettingsPopup

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnCreate` | `` | `` |
| `SpawnOption` | `parent: ref<inkCompoundWidget>` | `ref<ItemSourceOptionController>` |
| `OnArrangeChildrenComplete` | `` | `` |
| `OnChange` | `evt: ref<ItemSourceOptionChange>` | `` |
| `OnConfirm` | `` | `` |
| `Show` | `requester: ref<inkGameController>` | `` |
| `OnCancel` | `` | `` |
| `OnShown` | `` | `` |
| `OnReparent` | `parent: ref<inkCompoundWidget>` | `` |

## OutfitMappingPopup

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnCreate` | `` | `` |
| `SpawnOption` | `parent: ref<inkCompoundWidget>` | `ref<OutfitSlotOptionController>` |
| `OnArrangeChildrenComplete` | `` | `` |
| `OnChange` | `evt: ref<OutfitSlotOptionChange>` | `` |
| `OnConfirm` | `` | `` |
| `Show` | `requester: ref<inkGameController>, itemID: ItemID, system: ref<OutfitSystem>` | `` |
| `OnCancel` | `` | `` |
| `OnShown` | `` | `` |
| `OnReparent` | `parent: ref<inkCompoundWidget>` | `` |

# Related Concepts

- "Popups interact with [EquipmentEx facade](/systems/facade.md) for data"

# Citations

- [UI/ViewSettingsPopup.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ViewSettingsPopup.reds)
- [UI/OutfitMappingPopup.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitMappingPopup.reds)
- [UI/ArchivePopup.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ArchivePopup.reds)
- [UI/ConflictsPopup.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ConflictsPopup.reds)
- [UI/RequirementsPopup.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/RequirementsPopup.reds)
