---
type: Reference
title: ArchiveXL Resource Format
description: The .xl file format specification for modders defining factories, localization, and resource operations.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/support/templates
tags: [xl, resource-format, yaml, modding]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The ArchiveXL resource format (`.xl` files) is a YAML-based format that allows modders to extend game resources without modifying original files. Each `.xl` file is placed alongside a mod's archive and declares resource operations under a top-level `resource:` key.

# Template

The template file `mod.archive.xl` shows the minimal structure:

```yaml
factories:
  - mymod\factories\clothing.csv
  - mymod\factories\weapons.csv
localization:
  onscreens:
    en-us: mymod\localization\en-us.json
    de-de: mymod\localization\de-de.json
```

# Top-Level Keys

| Key | Description |
|-----|-------------|
| `factories` | List of factory CSV file paths to register custom entity factories |
| `localization` | Localization file mappings with sub-keys for locale categories |
| `localization.onscreens` | On-screen localization entries keyed by locale code |
| `resource` | Container for resource operations (scope, fix, patch, copy, link) |

# Resource Operations

All resource operations live under the `resource:` key:

## scope

Restricts which resources are visible to specific entities. Maps a resource path to a list of entity paths that can see it.

```yaml
resource:
  scope:
    player.ent:
      - player_ma.ent
      - player_wa.ent
```

See [Scope Operation](/references/builtin-resources/scope.md) for built-in examples.

## fix

Corrects appearance name and path mappings. Supports `paths` (remap old→new appearance paths), `names` (rename material submesh names), and `context` (set material context values). Uses YAML anchors for reuse.

```yaml
resource:
  fix:
    base\gameplay\gui\main_menu\female_cco.inkcharcustomization:
      paths:
        base\appearances\old.app: archive_xl\appearances\new.app
```

See [Fix Operation](/references/builtin-resources/fix.md) for built-in examples.

## patch

Overrides specific properties of a resource onto target resources. Each entry specifies `props` (list of property names to copy) and `targets` (list of resource paths to patch).

```yaml
resource:
  patch:
    archive_xl\patch_mesh.mesh:
      props: [ appearances ]
      targets: [ player_ma_hair.mesh, player_wa_hair.mesh ]
```

See [Patch & Copy Operations](/references/builtin-resources/patch.md) for built-in examples.

## copy

Duplicates a resource to a new path. Maps a source resource path to a list of destination paths.

```yaml
resource:
  copy:
    base\morphs.morphtarget:
      - archive_xl\morphs_copy.morphtarget
```

See [Patch & Copy Operations](/references/builtin-resources/patch.md) for built-in examples.

## link

Creates links between resources, allowing one resource path to resolve to another. Used for migration and backward compatibility.

```yaml
resource:
  link:
    archive_xl\old_path.mesh:
      - archive_xl\new_path.mesh
```

See [Link Operation (Migration)](/references/builtin-resources/migration.md) for built-in examples.

# Related Templates

- [Factory CSV Template](/templates/factory.md) — Template for custom entity factory files
- [Localization Template](/templates/localization.md) — Template for localization JSON files

# Citations

[1] [mod.archive.xl template](https://github.com/psiberx/cp2077-archive-xl/blob/main/support/templates/mod.archive.xl)
