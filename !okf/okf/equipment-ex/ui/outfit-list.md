---
type: UI
title: Outfit List UI
description: Outfit list entry controller and data model for displaying saved outfits in a scrollable list.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitListEntry.reds"
tags: ['equipment-ex', 'redscript', 'ui', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Outfit list entry controller and data model for displaying saved outfits in a scrollable list.

This concept covers 24 member declarations from 2 source file(s): UI/OutfitListEntry.reds, UI/OutfitListData.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Event | `OutfitListRefresh` extends Event | 0 methods |
| Event | `OutfitListEntryClick` extends Event | 0 methods |
| Event | `OutfitListEntryHoverOver` extends Event | 0 methods |
| Event | `OutfitListEntryHoverOut` extends Event | 0 methods |
| Class | `OutfitListEntryController` extends inkVirtualCompoundItemController | 12 methods |
| Method |  `OnInitialize()` | — |
| Method |  `OnDataChanged(value: Variant)` | — |
| Method |  `OnRefresh(evt: ref<OutfitListRefresh>)` | — |
| Method |  `OnRelease(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `UpdateView()` | — |
| Method |  `UpdateState()` | — |
| Method |  `TriggerClickEvent(action: ref<inkActionName>)` | — |
| Method |  `TriggerHoverOverEvent()` | — |
| Method |  `TriggerHoverOutEvent()` | — |
| Method |  `PlayIntroAnimation(delay: Float)` | — |
| Class | `OutfitListEntryData` | 0 methods |
| Class | `OutfitListDataView` extends ScriptableDataView | 2 methods |
| Method |  `UpdateView()` | — |
| Method |  `SortItem(left: ref<IScriptable>, right: ref<IScriptable>)` -> `Bool` | — |
| Class | `OutfitListTemplateClassifier` extends inkVirtualItemTemplateClassifier | 1 methods |
| Method |  `ClassifyItem(data: Variant)` -> `Uint32` | — |
| Enum | `OutfitListAction` | values: `Equip`, `Unequip`, `Save` |

# Notable Methods

## OutfitListEntryController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `` |
| `OnDataChanged` | `value: Variant` | `` |
| `OnRefresh` | `evt: ref<OutfitListRefresh>` | `` |
| `OnRelease` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `UpdateView` | `` | `` |
| `UpdateState` | `` | `` |
| `TriggerClickEvent` | `action: ref<inkActionName>` | `` |
| `TriggerHoverOverEvent` | `` | `` |
| `TriggerHoverOutEvent` | `` | `` |
| `PlayIntroAnimation` | `delay: Float` | `` |

# Enum Values

## OutfitListAction

- `Equip`
- `Unequip`
- `Save`

# Related Concepts

- "Loads from [outfit configuration](/systems/outfit-config.md)"

# Citations

- [UI/OutfitListEntry.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitListEntry.reds)
- [UI/OutfitListData.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitListData.reds)
