---
type: Override
title: Photo Mode Overrides
description: Overrides for photo mode menu controller and player entity component to support outfit switching in photo mode.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/gameuiPhotoModeMenuController.reds"
tags: ['equipment-ex', 'redscript', 'overrides']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Overrides for photo mode menu controller and player entity component to support outfit switching in photo mode.

This concept covers 10 member declarations from 2 source file(s): Overrides/gameuiPhotoModeMenuController.reds, Overrides/PhotoModePlayerEntityComponent.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Enum | `PhotoModeUI` | values: `CharacterPage`, `VisibilityAttribute`, `ExpressionAttribute`, `OutfitAttribute`, `NoOutfitOption`, `CurrentOutfitOption` |
| Function | `OnInitialize()` -> `Bool` | — |
| Function | `OnAddMenuItem(label: String, attribute: Uint32, page: Uint32)` -> `Bool` | — |
| Function | `OnShow(reversedUI: Bool)` -> `Bool` | — |
| Function | `OnSetAttributeOptionEnabled(attribute: Uint32, enabled: Bool)` -> `Bool` | — |
| Function | `OnAttributeOptionSelected(attribute: Uint32, option: PhotoModeOptionSelectorData)` | — |
| Function | `StartArrowClickedEffect(widget: inkWidgetRef)` | — |
| Function | `OnGameAttach()` | — |
| Function | `SetupInventory(isCurrentPlayerObjectCustomizable: Bool)` | — |
| Function | `OnItemAddedToSlot(evt: ref<ItemAddedToSlot>)` -> `Bool` | — |

# Enum Values

## PhotoModeUI

- `CharacterPage`
- `VisibilityAttribute`
- `ExpressionAttribute`
- `OutfitAttribute`
- `NoOutfitOption`
- `CurrentOutfitOption`

# Related Concepts

- "Uses [EquipmentEx facade](/systems/facade.md) for photo mode outfit switching"

# Citations

- [Overrides/gameuiPhotoModeMenuController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/gameuiPhotoModeMenuController.reds)
- [Overrides/PhotoModePlayerEntityComponent.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/PhotoModePlayerEntityComponent.reds)
