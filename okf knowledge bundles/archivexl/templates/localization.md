---
type: Template
title: Localization Template
description: Template for custom localization JSON files for on-screen text overrides.
resource: https://github.com/psiberx/cp2077-archive-xl/blob/main/support/templates/localization.json
tags: [template, localization, json, onscreens]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The localization template provides the structure for custom localization JSON files. These files add or override on-screen text entries that can be used in scripts, resources, and TweakDB. The template is distributed as a WolvenKit JSON export of a CR2W `JsonResource`.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| localization.json | JSON/CR2W | WolvenKit JSON export of a localization persistence resource |

# Schema

Each localization entry uses these fields:

| Field | Type | Description |
|-------|------|-------------|
| secondaryKey | String | The localization key (e.g. `MyMod-Item-Name`) |
| femaleVariant | String | The localized text value (used for all variants unless male-specific) |

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
      "$type": "JsonResource",
      "cookingPlatform": "PLATFORM_PC",
      "root": {
        "HandleId": "0",
        "Data": {
          "$type": "localizationPersistenceOnScreenEntries",
          "entries": [
            {
              "$type": "localizationPersistenceOnScreenEntry",
              "secondaryKey": "MyMod-Item-Name",
              "femaleVariant": "Samurai Mask & Aviators"
            }
          ]
        }
      }
    },
    "EmbeddedFiles": []
  }
}
```

# Usage

1. Copy the template and rename to `<locale>.json` (e.g. `en-us.json`)
2. Add entries in the `entries` array for each localization key
3. Reference the file in your `mod.archive.xl` under `localization.onscreens.<locale>`

See [ArchiveXL Resource Format](/references/resource-format.md) for how to reference localization files.

# Citations

[1] [localization.json](https://github.com/psiberx/cp2077-archive-xl/blob/main/support/templates/localization.json)
