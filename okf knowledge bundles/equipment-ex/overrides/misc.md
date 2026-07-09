---
type: Override
title: Miscellaneous Overrides
description: Small overrides for backpack, crafting preview, in-game menu, quest tracker, stash, and popups manager.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/BackpackMainGameController.reds"
tags: ['equipment-ex', 'redscript', 'overrides']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Small overrides for backpack, crafting preview, in-game menu, quest tracker, stash, and popups manager.

This concept covers 9 member declarations from 6 source file(s): Overrides/BackpackMainGameController.reds, Overrides/CraftingGarmentItemPreviewGameController.reds, Overrides/gameuiInGameMenuGameController.reds, Overrides/QuestTrackerGameController.reds, Overrides/Stash.reds, Overrides/PopupsManager.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Function | `OnInitialize()` -> `Bool` | — |
| Function | `OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>)` -> `Bool` | — |
| Function | `NewShowItemHints(itemData: wref<UIInventoryItem>)` | — |
| Function | `OnCrafrtingPreview(evt: ref<CraftingItemPreviewEvent>)` -> `Bool` | — |
| Function | `OnPuppetReady(sceneName: CName, puppet: ref<gamePuppet>)` -> `Bool` | — |
| Function | `OnEquipmentChanged(value: Variant)` -> `Bool` | — |
| Function | `OnWardrobePopupClose(data: ref<inkGameNotificationData>)` | — |
| Function | `OnGameAttached()` -> `Bool` | — |
| Function | `ShowTutorial()` | — |

# Citations

- [Overrides/BackpackMainGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/BackpackMainGameController.reds)
- [Overrides/CraftingGarmentItemPreviewGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/CraftingGarmentItemPreviewGameController.reds)
- [Overrides/gameuiInGameMenuGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/gameuiInGameMenuGameController.reds)
- [Overrides/QuestTrackerGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/QuestTrackerGameController.reds)
- [Overrides/Stash.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/Stash.reds)
- [Overrides/PopupsManager.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/PopupsManager.reds)
