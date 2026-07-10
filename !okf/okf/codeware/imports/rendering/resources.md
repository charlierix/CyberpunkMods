---
type: "Import"
title: "Rendering Resources"
description: "Imported rendering resources types (4 types)."
resource: "codeware/scripts/"
tags: "[imports, resources]"
timestamp: 2026-07-01T18:09:29Z
---

# Overview

Imported rendering resources types (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| rendRenderMultilayerMaskResource | struct | — | renderResourceBlobPC |
| rendRenderTextureResource | struct | — | renderResourceBlobPC |
| visIOccluderResource | class | ISerializable | resourceHash |
| visOccluderMeshResource | class | visIOccluderResource | resourceVersion, boundingBox, twoSided |

# Citations

- `codeware/scripts/Base/Imports/rendRenderMultilayerMaskResource.reds`
- `codeware/scripts/Base/Imports/rendRenderTextureResource.reds`
- `codeware/scripts/Base/Imports/visIOccluderResource.reds`
- `codeware/scripts/Base/Imports/visOccluderMeshResource.reds`
