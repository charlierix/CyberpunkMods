---
type: Reference
title: Project Overview
description: ArchiveXL modding tool for loading custom resources without touching original game files.
resource: https://github.com/psiberx/cp2077-archive-xl
tags: [archive, modding, cyberpunk, overview]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

ArchiveXL is a Cyberpunk 2077 modding tool that allows you to load custom resources without touching original game files, thus allowing multiple mods to expand the same resources without conflicts.

## Capabilities

- Load custom entity factories (necessary for item additions)
- Add localization texts usable in scripts, resources, and TweakDB
- Edit existing localization texts without overwriting original resources
- Override submesh visibility of entity parts
- Add visual tags to clothing items
- Spawn widgets from any library without registering dependencies

## Compatibility

| Requirement | Version |
|-------------|--------|
| Cyberpunk 2077 | 2.31 |
| redscript | 0.5.31+ |
| RED4ext | 1.29.0+ |

## Installation

1. Install [RED4ext](https://docs.red4ext.com/getting-started/installing-red4ext) 1.29.0+
2. Extract the release archive `ArchiveXL-x.x.x.zip` into the Cyberpunk 2077 directory

## Key APIs

- [Redscript API](/apis/redscript.md) — Native class and dynamic appearance functions for Redscript modders
- [RED4ext C++ API](/apis/red4ext.md) — C++ header for plugin integration
- [ArchiveXL Resource Format](/references/resource-format.md) — The .xl file format specification

## Documentation Links

- [Dynamic appearances](https://github.com/psiberx/cp2077-archive-xl/wiki#dynamic-appearances)
- [Body types](https://github.com/psiberx/cp2077-archive-xl/wiki#body-types)
- [Appearance suffixes](https://github.com/psiberx/cp2077-archive-xl/wiki#appearance-suffixes)
- [Components overrides](https://github.com/psiberx/cp2077-archive-xl/wiki#components-overrides)
- [Visual tags](https://github.com/psiberx/cp2077-archive-xl/wiki#visual-tags)
- [Extending resources](https://github.com/psiberx/cp2077-archive-xl/wiki#extending-resources)

# Citations

[1] [ArchiveXL README](https://github.com/psiberx/cp2077-archive-xl/blob/main/README.md)
