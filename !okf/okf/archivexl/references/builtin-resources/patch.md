---
type: Reference
title: Patch & Copy Operations
description: Built-in .xl files demonstrating patch and copy operations for mesh property overrides and resource duplication.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources
tags: [xl, patch, copy, builtin, mesh-override]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The `patch` operation overrides specific properties of a source resource onto target resources. The `copy` operation duplicates a resource to a new path. ArchiveXL ships with 4 built-in files that use these operations.

Demonstrates patch/copy operations from the [Resource Format](/references/resource-format.md).

# Member Files

| # | File | Operations used | Description |
|---|------|-----------------|-------------|
| 1 | PlayerCustomizationBrowsPatch.xl | copy + patch | Copies eyebrow morphtarget and mesh resources, then patches brow mesh/morphtarget properties onto player base brow resources |
| 2 | PlayerCustomizationEyesPatch.xl | copy + patch | Copies eye morph resources with normal fixes, patches eye mesh appearances onto player base eye meshes, patches null morphtarget base textures |
| 3 | PlayerCustomizationHairPatch.xl | patch | Patches hair mesh appearances onto player male/female hair meshes |
| 4 | PlayerCustomizationLashesPatch.xl | patch | Patches eyelash mesh appearances onto player base lash meshes and hair mesh |

# Patch Operation

Overrides specific properties of a source resource onto target resources:

```yaml
resource:
  patch:
    <source-resource>:
      props: [ <property-name>, ... ]
      targets: [ <target-resource>, ... ]
```

## Properties used in built-in patches

| Property | Used in | Description |
|----------|---------|-------------|
| `appearances` | EyesPatch, HairPatch, LashesPatch | Override appearance data on target meshes |
| `blob, boundingBox, targets` | BrowsPatch | Override morphtarget blob and bounding data |
| `renderResourceBlob` | BrowsPatch | Override render resource blob on meshes |
| `baseTexture, baseTextureParamName` | EyesPatch | Override base texture on null morphtarget |

# Copy Operation

Duplicates a resource to a new path:

```yaml
resource:
  copy:
    <source-resource>:
      - <destination-resource-1>
      - <destination-resource-2>
```

## Copy patterns in built-in files

| Source | Destination | File |
|--------|-------------|------|
| `he_000_pwa__morphs.morphtarget` | `he_000_pwa__morphs_normal_fix.morphtarget` | EyesPatch |
| `he_000_pma__morphs.morphtarget` | `he_000_pma__morphs_normal_fix.morphtarget` | EyesPatch |
| `heb_000_pwa__morphs.morphtarget` | `heb_000_pwa__morphs.morphtarget` (self-copy) | BrowsPatch |
| `heb_000_pwa_c__basehead.mesh` | `heb_000_pwa_c__basehead.mesh` (self-copy) | BrowsPatch |

# Citations

[1] [ArchiveXL resources directory](https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources)
