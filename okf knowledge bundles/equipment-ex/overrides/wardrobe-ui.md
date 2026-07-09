---
type: Override
title: Wardrobe UI Overrides
description: Overrides for wardrobe game controller, set preview controller, and puppet preview controller.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/WardrobeUIGameController.reds"
tags: ['equipment-ex', 'redscript', 'overrides']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Overrides for wardrobe game controller, set preview controller, and puppet preview controller.

This concept covers 6 member declarations from 3 source file(s): Overrides/WardrobeUIGameController.reds, Overrides/WardrobeSetPreviewGameController.reds, Overrides/inkInventoryPuppetPreviewGameController.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Function | `OnInitialize()` -> `Bool` | — |
| Function | `OnBack(userData: ref<IScriptable>)` -> `Bool` | — |
| Function | `CloseWardrobe()` -> `Void` | — |
| Function | `OnWardrobePopupClose(data: ref<inkGameNotificationData>)` | — |
| Function | `OnPreviewInitialized()` -> `Bool` | — |
| Function | `RestorePuppetEquipment()` | — |

# Related Concepts

- "Backs the [wardrobe screen](/ui/wardrobe-screen.md) controller"

# Citations

- [Overrides/WardrobeUIGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/WardrobeUIGameController.reds)
- [Overrides/WardrobeSetPreviewGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/WardrobeSetPreviewGameController.reds)
- [Overrides/inkInventoryPuppetPreviewGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/inkInventoryPuppetPreviewGameController.reds)
