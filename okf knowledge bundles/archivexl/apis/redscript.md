---
type: API
title: Redscript API
description: Native ArchiveXL class and dynamic appearance functions callable from Redscript.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/scripts
tags: [redscript, api, dynamic-appearance, native]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The Redscript API provides the primary interface for modders working with ArchiveXL from Redscript code. It consists of a native `ArchiveXL` class with static methods and a set of helper functions for manipulating dynamic appearance strings.

Dynamic appearances use .xl resources — see [Resource Format](/references/resource-format.md) for the .xl file specification.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| ArchiveXL | Native class | Static native class providing version checks, garment offset control, and body type queries |
| DynamicAppearance | Module | Helper functions for manipulating dynamic appearance condition strings |
| ArchiveXL (module) | Module declaration | Module declaration establishing the `ArchiveXL` namespace |

# ArchiveXL Native Class

Declared in `Facade.reds`:

| Method | Signature | Description |
|--------|-----------|-------------|
| GetBodyType | `static native func GetBodyType(puppet: wref<GameObject>) -> CName` | Returns the body type CName for the given puppet |
| EnableGarmentOffsets | `static native func EnableGarmentOffsets()` | Enables garment offset adjustments |
| DisableGarmentOffsets | `static native func DisableGarmentOffsets()` | Disables garment offset adjustments |
| Require | `static native func Require(version: String) -> Bool` | Checks if the installed ArchiveXL version meets the requirement |
| Version | `static native func Version() -> String` | Returns the installed ArchiveXL version string |

# DynamicAppearance Module

Declared in `DynamicAppearance.reds` under `module ArchiveXL.DynamicAppearance`:

| Function | Signature | Description |
|----------|-----------|-------------|
| OverrideDynamicAppearanceCondition | `func OverrideDynamicAppearanceCondition(app: String, attr: String, value: String) -> String` | Overrides or appends a condition attribute in a dynamic appearance string |
| ConvertAppearanceNameToTPP | `func ConvertAppearanceNameToTPP(app: String) -> String` | Converts an appearance name to third-person perspective |
| ConvertAppearanceNameToFPP | `func ConvertAppearanceNameToFPP(app: String) -> String` | Converts an appearance name to first-person perspective |
| ConvertAppearanceNameToPartialSleeves | `func ConvertAppearanceNameToPartialSleeves(app: String) -> String` | Converts an appearance name to partial sleeves variant |
| ConvertAppearanceNameToFullSleeves | `func ConvertAppearanceNameToFullSleeves(app: String) -> String` | Converts an appearance name to full sleeves variant |

## Dynamic Appearance String Format

Dynamic appearance strings use the format: `base!condition1=value1+condition2=value2%hash`

- `base` — the base appearance name
- `!` — separator between base and dynamic conditions
- `+` — separator between multiple conditions
- `%` — separator before the optional hash suffix

The `OverrideDynamicAppearanceCondition` function parses this format, replaces the matching attribute if found, or appends it if not.

# Module Declaration

`Module.reds` declares `module ArchiveXL`, establishing the root namespace for all ArchiveXL Redscript code.

# Citations

[1] [Facade.reds](https://github.com/psiberx/cp2077-archive-xl/blob/main/scripts/Facade.reds)
[2] [DynamicAppearance.reds](https://github.com/psiberx/cp2077-archive-xl/blob/main/scripts/DynamicAppearance.reds)
[3] [Module.reds](https://github.com/psiberx/cp2077-archive-xl/blob/main/scripts/Module.reds)
