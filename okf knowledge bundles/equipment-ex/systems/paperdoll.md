---
type: System
title: Paperdoll Helper
description: ScriptableSystem assisting with paperdoll entity rendering and appearance management.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/PaperdollHelper.reds"
tags: ['equipment-ex', 'redscript', 'systems']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

ScriptableSystem assisting with paperdoll entity rendering and appearance management.

This concept covers 6 member declarations from 1 source file(s): PaperdollHelper.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `PaperdollHelper` extends ScriptableSystem | 5 methods |
| Method |  `AddPreview(preview: ref<inkInventoryPuppetPreviewGameController>)` | — |
| Method |  `GetPreview()` -> `wref<inkInventoryPuppetPreviewGameController>` | — |
| Method |  `AddPuppet(puppet: ref<gamePuppet>)` | — |
| Method |  `GetPuppet()` -> `wref<gamePuppet>` | — |
| Method |  `GetInstance(game: GameInstance)` -> `ref<PaperdollHelper>` | — |

# Notable Methods

## PaperdollHelper

| Method | Parameters | Returns |
|--------|------------|---------|
| `AddPreview` | `preview: ref<inkInventoryPuppetPreviewGameController>` | `` |
| `GetPreview` | `` | `wref<inkInventoryPuppetPreviewGameController>` |
| `AddPuppet` | `puppet: ref<gamePuppet>` | `` |
| `GetPuppet` | `` | `wref<gamePuppet>` |
| `GetInstance` | `game: GameInstance` | `ref<PaperdollHelper>` |

# Related Concepts

- "Supports [wardrobe UI overrides](/overrides/wardrobe-ui.md) puppet rendering"

# Citations

- [PaperdollHelper.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/PaperdollHelper.reds)
