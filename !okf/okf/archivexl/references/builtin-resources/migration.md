---
type: Reference
title: Link Operation (Migration)
description: Built-in .xl file demonstrating the link operation for migrating resources between paths.
resource: https://github.com/psiberx/cp2077-archive-xl/blob/main/bundle/source/resources/Migration.xl
tags: [xl, link, migration, builtin]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The `link` operation creates links between resource paths, allowing one resource path to resolve to another. This is used for migration and backward compatibility — when a resource is renamed or moved, a link ensures old paths still resolve correctly.

Demonstrates the link operation from the [Resource Format](/references/resource-format.md).

# Member Files

| # | File | Description |
|---|------|-------------|
| 1 | Migration.xl | Links old ArchiveXL resource paths to new paths for hair, lashes, and eyebrow appearance files |

# Link Pattern

```yaml
resource:
  link:
    <old-path>:
      - <new-path-1>
      - <new-path-2>
```

# Migration Entries

The `Migration.xl` file contains link entries for the following resource categories:

| Category | Old path pattern | New path pattern | Count |
|----------|-----------------|------------------|-------|
| Hair mesh | `h1_base_color_patch.mesh` | `base_color_patch.mesh` | 1 |
| Lashes (male) | `hel_000_pma__basehead.app` | `hel_pma_lashes.app` | 1 |
| Lashes (female) | `hel_000_pwa__basehead.app` | `hel_pwa_lashes.app` | 1 |
| Brows (male) | `heb_000_pma__basehead_01-13.app` | `heb_pma_brows__01-13.app` | 13 |
| Brows (female) | `heb_000_pwa__basehead_01-13.app` | `heb_pwa_brows__01-13.app` | 13 |

**Total: 29 link entries**

# Notes

- The migration file ensures that resources renamed in newer versions of ArchiveXL remain accessible at their old paths.
- Brow appearance files are migrated for both male (`pma`) and female (`pwa`) body types, covering 13 brow variants each.
- The hair mesh link is a single entry for the base color patch mesh.

# Citations

[1] [Migration.xl](https://github.com/psiberx/cp2077-archive-xl/blob/main/bundle/source/resources/Migration.xl)
