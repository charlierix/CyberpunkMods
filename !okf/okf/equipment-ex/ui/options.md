---
type: UI
title: Option Controls
description: Option selector controllers for item source and outfit slot selection with change events.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ItemSourceOption.reds"
tags: ['equipment-ex', 'redscript', 'ui']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Option selector controllers for item source and outfit slot selection with change events.

This concept covers 26 member declarations from 2 source file(s): UI/ItemSourceOption.reds, UI/OutfitSlotOption.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Event | `ItemSourceOptionChange` extends Event | 0 methods |
| Class | `ItemSourceOptionController` extends inkButtonController | 11 methods |
| Method |  `OnInitialize()` | — |
| Method |  `OnRelease(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnOptionChange(evt: ref<ItemSourceOptionChange>)` | — |
| Method |  `UpdateView()` | — |
| Method |  `UpdateState()` | — |
| Method |  `TriggerChangeEvent()` | — |
| Method |  `SetData(value: WardrobeItemSource, selected: Bool)` | — |
| Method |  `GetValue()` -> `WardrobeItemSource` | — |
| Method |  `IsSelected()` -> `Bool` | — |
| Event | `OutfitSlotOptionChange` extends Event | 0 methods |
| Class | `OutfitSlotOptionController` extends inkButtonController | 11 methods |
| Method |  `OnInitialize()` | — |
| Method |  `OnRelease(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnOptionChange(evt: ref<OutfitSlotOptionChange>)` | — |
| Method |  `UpdateView()` | — |
| Method |  `UpdateState()` | — |
| Method |  `TriggerChangeEvent()` | — |
| Method |  `SetData(data: ExtraSlotConfig, selected: Bool)` | — |
| Method |  `GetSlotID()` -> `TweakDBID` | — |
| Method |  `IsSelected()` -> `Bool` | — |

# Notable Methods

## ItemSourceOptionController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `` |
| `OnRelease` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `OnOptionChange` | `evt: ref<ItemSourceOptionChange>` | `` |
| `UpdateView` | `` | `` |
| `UpdateState` | `` | `` |
| `TriggerChangeEvent` | `` | `` |
| `SetData` | `value: WardrobeItemSource, selected: Bool` | `` |
| `GetValue` | `` | `WardrobeItemSource` |
| `IsSelected` | `` | `Bool` |

## OutfitSlotOptionController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `` |
| `OnRelease` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `OnOptionChange` | `evt: ref<OutfitSlotOptionChange>` | `` |
| `UpdateView` | `` | `` |
| `UpdateState` | `` | `` |
| `TriggerChangeEvent` | `` | `` |
| `SetData` | `data: ExtraSlotConfig, selected: Bool` | `` |
| `GetSlotID` | `` | `TweakDBID` |
| `IsSelected` | `` | `Bool` |

# Citations

- [UI/ItemSourceOption.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/ItemSourceOption.reds)
- [UI/OutfitSlotOption.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/OutfitSlotOption.reds)
