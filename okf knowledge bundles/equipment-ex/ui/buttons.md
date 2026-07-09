---
type: UI
title: Button Controls
description: Custom button controllers with click events for collapse and settings interactions.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/CollapseButton.reds"
tags: ['equipment-ex', 'redscript', 'ui']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Custom button controllers with click events for collapse and settings interactions.

This concept covers 24 member declarations from 2 source file(s): UI/CollapseButton.reds, UI/SettingsButton.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Event | `CollapseButtonClick` extends Event | 0 methods |
| Class | `CollapseButton` extends inkCustomController | 12 methods |
| Method |  `OnCreate()` | — |
| Method |  `OnInitialize()` | — |
| Method |  `OnClick(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `ApplyCollapseState()` | — |
| Method |  `ApplyFlippedState()` | — |
| Method |  `TriggerClickEvent(action: ref<inkActionName>)` | — |
| Method |  `SetCollapse(isCollapse: Bool)` | — |
| Method |  `SetFlipped(isFlipped: Bool)` | — |
| Method |  `Create()` -> `ref<CollapseButton>` | — |
| Method |  `OnReparent(parent: ref<inkCompoundWidget>)` | — |
| Event | `SettingsButtonClick` extends Event | 0 methods |
| Class | `SettingsButton` extends inkCustomController | 8 methods |
| Method |  `OnCreate()` | — |
| Method |  `OnInitialize()` | — |
| Method |  `OnClick(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `TriggerClickEvent(action: ref<inkActionName>)` | — |
| Method |  `Create()` -> `ref<SettingsButton>` | — |
| Method |  `OnReparent(parent: ref<inkCompoundWidget>)` | — |

# Notable Methods

## CollapseButton

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnCreate` | `` | `` |
| `OnInitialize` | `` | `` |
| `OnClick` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `ApplyCollapseState` | `` | `` |
| `ApplyFlippedState` | `` | `` |
| `TriggerClickEvent` | `action: ref<inkActionName>` | `` |
| `SetCollapse` | `isCollapse: Bool` | `` |
| `SetFlipped` | `isFlipped: Bool` | `` |
| `Create` | `` | `ref<CollapseButton>` |
| `OnReparent` | `parent: ref<inkCompoundWidget>` | `` |

## SettingsButton

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnCreate` | `` | `` |
| `OnInitialize` | `` | `` |
| `OnClick` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `TriggerClickEvent` | `action: ref<inkActionName>` | `` |
| `Create` | `` | `ref<SettingsButton>` |
| `OnReparent` | `parent: ref<inkCompoundWidget>` | `` |

# Citations

- [UI/CollapseButton.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/CollapseButton.reds)
- [UI/SettingsButton.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/SettingsButton.reds)
