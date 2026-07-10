---
type: Reference
title: Scope Operation
description: Built-in .xl files demonstrating the scope operation for restricting resource visibility to specific entities.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources
tags: [xl, scope, builtin, resource-visibility]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The `scope` operation restricts which resources are visible to specific entities. It maps a resource path to a list of entity/resource paths that should be able to see it. ArchiveXL ships with 9 built-in scope `.xl` files that demonstrate this operation.

Demonstrates the scope operation from the [Resource Format](/references/resource-format.md). Dynamic appearances may reference scoped resources via [Redscript API](/apis/redscript.md).

# Member Files

| # | File | Description |
|---|------|-------------|
| 1 | PhotoModeScope.xl | Scopes photo mode entity resources for all photo mode characters (male, female, big, cat, iguana) |
| 2 | PlayerBaseScope.xl | Scopes player base entities (player.ent → player_ma.ent, player_wa.ent) with FPP/TPP/cutscene variants |
| 3 | PlayerCustomizationScope.xl | Empty placeholder for player customization scoping |
| 4 | PlayerCustomizationBeardScope.xl | Scopes beard appearance and mesh resources for male player customization |
| 5 | PlayerCustomizationBrowsScope.xl | Scopes eyebrow appearance, morphtarget, and mesh resources for both body types |
| 6 | PlayerCustomizationEyesScope.xl | Scopes eye appearance, morphtarget, and mesh resources for both body types |
| 7 | PlayerCustomizationHairScope.xl | Scopes hair appearance and mesh resources for both body types with multiple hair styles |
| 8 | PlayerCustomizationLashesScope.xl | Scopes eyelash appearance, morphtarget, and mesh resources for both body types |
| 9 | QuestBaseScope.xl | Scopes quest resources (cyberpunk2077.quest → main and ep1 quest files) |

# Scope Pattern

All scope files follow this structure:

```yaml
resource:
  scope:
    <resource-path>:
      - <visible-to-path-1>
      - <visible-to-path-2>
```

## Key scope targets

| Scope key | Typical targets |
|-----------|----------------|
| `player_customization.app` | Body-type-specific appearance files (e.g. `player_ma_eyes.app`, `player_wa_hair.app`) |
| `player.ent` | `player_ma.ent`, `player_wa.ent` (male/female player entities) |
| `photomode_wa.ent` / `photomode_ma.ent` / `photomode_mb.ent` / `photomode_mm.ent` | Character-specific photo mode entities |
| `cyberpunk2077.quest` | `cyberpunk2077_main.quest`, `cyberpunk2077_ep1.quest` |

# Notes

- Scope files use a cascading pattern: a top-level resource maps to intermediate resources, which in turn map to specific game resources.
- The `PlayerCustomizationScope.xl` file is empty (0 bytes) — it exists as a placeholder.
- `PhotoModeScope.xl` covers the most entities (50+ photo mode characters across base game and Phantom Liberty).

# Citations

[1] [ArchiveXL resources directory](https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources)
