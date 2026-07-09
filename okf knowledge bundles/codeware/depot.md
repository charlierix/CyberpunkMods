---
type: "API"
title: "Resource Depot"
description: "Resource management system with tokens, references, and depot access."
resource: "codeware/scripts/"
tags: "[depot]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Resource management system with tokens, references, and depot access.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CResource | class | ISerializable | — |
| ResourceDepot | class | — | ArchiveExists, ResourceExists, LoadResource, RemoveResourceFromCache |
| ResourceRef | struct | — | — |
| ResourceToken | class | — | GetResource, GetPath, GetHash, IsFinished, IsLoaded |
| SoundBankEntry | struct | — | name, resourcePath, soundBanks |

# Citations

- `codeware/scripts/Depot/CResource.reds`
- `codeware/scripts/Depot/ResourceDepot.reds`
- `codeware/scripts/Depot/ResourceReference.reds`
- `codeware/scripts/Depot/ResourceToken.reds`
- `codeware/scripts/Depot/SoundBanksJson.reds`
