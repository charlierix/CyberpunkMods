---
type: "Import"
title: "Advertisements Types"
description: "Imported game engine types in the advertisements domain (4 types)."
resource: "codeware/scripts/"
tags: "[imports, advertisements]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Imported game engine types in the advertisements domain (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AdvertisementFormat | enum | — | Format_0_7x1, Format_1x1, Format_1x0_7, Format_1x1_5, Format_1x2 |
| AdvertisementLoadMode | enum | — | TweakDB, Override |
| AdvertisementWidgetComponent | class | IWorldWidgetComponent | format, adGroupTDBID, enableOverride, adOverrideTDBID, adVersion |
| PalladiaAdvertisementWidgetComponent | class | AdvertisementWidgetComponent | — |

# Citations

- `codeware/scripts/Base/Imports/AdvertisementFormat.reds`
- `codeware/scripts/Base/Imports/AdvertisementLoadMode.reds`
- `codeware/scripts/Base/Imports/AdvertisementWidgetComponent.reds`
- `codeware/scripts/Base/Imports/PalladiaAdvertisementWidgetComponent.reds`
