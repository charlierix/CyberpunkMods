---
type: System
title: View Manager
description: View management system handling UI view states, transitions, and events for the wardrobe/inventory interface.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/ViewManager.reds"
tags: ['equipment-ex', 'redscript', 'systems', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

View management system handling UI view states, transitions, and events for the wardrobe/inventory interface.

This concept covers 21 member declarations from 3 source file(s): ViewManager.reds, ViewState.reds, ViewEvents.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `ViewManager` extends ScriptableSystem | 10 methods |
| Method |  `OnAttach()` | — |
| Method |  `GetItemSource()` -> `WardrobeItemSource` | — |
| Method |  `SetItemSource(source: WardrobeItemSource)` | — |
| Method |  `IsCollapsed(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `SetCollapsed(slotID: TweakDBID, state: Bool)` | — |
| Method |  `SetCollapsed(state: Bool)` | — |
| Method |  `ToggleCollapsed(slotID: TweakDBID)` | — |
| Method |  `ToggleCollapsed()` | — |
| Method |  `TriggerItemSourceEvent()` | — |
| Method |  `GetInstance(game: GameInstance)` -> `ref<ViewManager>` | — |
| Class | `ViewState` | 7 methods |
| Method |  `GetItemSource()` -> `WardrobeItemSource` | — |
| Method |  `SetItemSource(source: WardrobeItemSource)` | — |
| Method |  `GetCollapsed()` -> `array<TweakDBID>` | — |
| Method |  `IsCollapsed(slotID: TweakDBID)` -> `Bool` | — |
| Method |  `SetCollapsed(slotID: TweakDBID, state: Bool)` | — |
| Method |  `ToggleCollapsed(slotID: TweakDBID)` | — |
| Method |  `SetCollapsed(slots: array<TweakDBID>)` | — |
| Enum | `WardrobeItemSource` | values: `WardrobeStore`, `InventoryAndStash`, `InventoryOnly` |
| Event | `ItemSourceUpdated` extends Event | 0 methods |

# Notable Methods

## ViewManager

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnAttach` | `` | `` |
| `GetItemSource` | `` | `WardrobeItemSource` |
| `SetItemSource` | `source: WardrobeItemSource` | `` |
| `IsCollapsed` | `slotID: TweakDBID` | `Bool` |
| `SetCollapsed` | `slotID: TweakDBID, state: Bool` | `` |
| `SetCollapsed` | `state: Bool` | `` |
| `ToggleCollapsed` | `slotID: TweakDBID` | `` |
| `ToggleCollapsed` | `` | `` |
| `TriggerItemSourceEvent` | `` | `` |
| `GetInstance` | `game: GameInstance` | `ref<ViewManager>` |

## ViewState

| Method | Parameters | Returns |
|--------|------------|---------|
| `GetItemSource` | `` | `WardrobeItemSource` |
| `SetItemSource` | `source: WardrobeItemSource` | `` |
| `GetCollapsed` | `` | `array<TweakDBID>` |
| `IsCollapsed` | `slotID: TweakDBID` | `Bool` |
| `SetCollapsed` | `slotID: TweakDBID, state: Bool` | `` |
| `ToggleCollapsed` | `slotID: TweakDBID` | `` |
| `SetCollapsed` | `slots: array<TweakDBID>` | `` |

# Enum Values

## WardrobeItemSource

- `WardrobeStore`
- `InventoryAndStash`
- `InventoryOnly`

# Related Concepts

- "Drives the [wardrobe screen](/ui/wardrobe-screen.md) view states"
- "Coordinates with [outfit manager UI](/ui/outfit-manager.md)"

# Citations

- [ViewManager.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/ViewManager.reds)
- [ViewState.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/ViewState.reds)
- [ViewEvents.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/ViewEvents.reds)
