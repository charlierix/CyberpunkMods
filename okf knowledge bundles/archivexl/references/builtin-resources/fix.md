---
type: Reference
title: Fix Operation
description: Built-in .xl files demonstrating the fix operation for correcting appearance name and path mappings.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources
tags: [xl, fix, builtin, appearance-mapping]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The `fix` operation corrects appearance name and path mappings in game resources. It supports three sub-operations: `paths` (remap appearance paths), `names` (rename material submesh names), and `context` (set material context values). ArchiveXL ships with 5 built-in fix `.xl` files.

Demonstrates the fix operation from the [Resource Format](/references/resource-format.md). Fixes are often paired with [Scope Operation](/references/builtin-resources/scope.md).

# Member Files

| # | File | Description |
|---|------|-------------|
| 1 | PlayerCustomizationBeardFix.xl | Fixes beard mesh material names with `@beard` suffix and character customization appearance paths |
| 2 | PlayerCustomizationBrowsFix.xl | Fixes eyebrow appearance paths in character customization UI (13 brow variants × male/female) |
| 3 | PlayerCustomizationEyesFix.xl | Fixes eye appearance paths in character customization UI with YAML anchor reuse for male/female |
| 4 | PlayerCustomizationHairFix.xl | Fixes hair mesh material names with `@cap` and `@dread` suffixes (largest file, ~19K lines) |
| 5 | PlayerCustomizationLashesFix.xl | Fixes eyelash mesh material names with `@lashes` suffix and context material references |

# Fix Sub-Operations

## paths

Remaps old appearance paths to new ones within a target resource:

```yaml
resource:
  fix:
    base\gameplay\gui\female_cco.inkcharcustomization:
      paths:
        base\old.app: archive_xl\new.app
```

## names

Renames material submesh names with a suffix. Uses YAML anchors for reuse across resources:

```yaml
resource:
  fix:
    base\head.mesh:
      names: &MaterialFix
        red_merlot: red_merlot@eyes
        black_carbon: black_carbon@eyes
```

## context

Sets material context values for a target resource:

```yaml
resource:
  fix:
    base\head.mesh:
      context:
        LashesBaseMaterial: archive_xl\eyes\hel_pwa.mi
        AppearanceExpansionSource: eyelashes__blonde_platinum
```

# YAML Anchor Reuse

Fix files use YAML anchors (`&AppearanceFixF`, `&AppearanceFixM`, `&MaterialFix`) and aliases (`*AppearanceFixF`, `*MaterialFix`) to avoid repeating large configuration blocks for male/female variants.

# Material Name Suffixes

| Fix file | Suffix used | Purpose |
|----------|------------|---------|
| BeardFix | `@beard` | Beard material submesh names |
| EyesFix | `@eyes` | Eye material submesh names |
| LashesFix | `@lashes` | Eyelash material submesh names |
| HairFix | `@cap`, `@dread` | Hair cap and dreadlock material submesh names |

# Citations

[1] [ArchiveXL resources directory](https://github.com/psiberx/cp2077-archive-xl/tree/main/bundle/source/resources)
