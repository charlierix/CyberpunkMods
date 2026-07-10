---
type: Template
title: Factory CSV Template
description: Template for custom entity factory CSV files used to register new items with ArchiveXL.
resource: https://github.com/psiberx/cp2077-archive-xl/blob/main/support/templates/factory.csv.json
tags: [template, factory, csv, entity, items]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The factory CSV template provides the structure for custom entity factory files. These files register new entities (items, clothing, weapons) with the game via ArchiveXL. The template is distributed as a WolvenKit JSON export of a CR2W `C2dArray` resource.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| factory.csv.json | JSON/CR2W | WolvenKit JSON export of a C2dArray (CSV) resource |

# Schema

The factory CSV uses three columns:

| Column | Type | Description |
|--------|------|-------------|
| name | String | Factory entry name (e.g. `mymod_item`) |
| path | String | Entity file path (e.g. `mymod\items\clothing\item.ent`) |
| preload | String (boolean) | Whether to preload the entity (`true` or `false`) |

# Template Content

```json
{
  "Header": {
    "WKitJsonVersion": "0.0.3",
    "GameVersion": 1600,
    "DataType": "CR2W"
  },
  "Data": {
    "Version": 195,
    "BuildVersion": 0,
    "RootChunk": {
      "$type": "C2dArray",
      "compiledData": [
        [
          "mymod_item",
          "mymod\\items\\clothing\\item.ent",
          "true"
        ]
      ],
      "compiledHeaders": [
        "name",
        "path",
        "preload"
      ],
      "cookingPlatform": "PLATFORM_PC"
    },
    "EmbeddedFiles": []
  }
}
```

# Usage

1. Copy the template and rename to `<your-mod>.csv.json`
2. Add rows in `compiledData` for each entity you want to register
3. Reference the factory file in your `mod.archive.xl` under the `factories:` key

See [ArchiveXL Resource Format](/references/resource-format.md) for how to reference factory files.

# Citations

[1] [factory.csv.json](https://github.com/psiberx/cp2077-archive-xl/blob/main/support/templates/factory.csv.json)
