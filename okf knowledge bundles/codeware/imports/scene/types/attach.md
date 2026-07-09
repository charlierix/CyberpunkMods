---
type: "Import"
title: "Scene Types/Attach"
description: "Imported scene types/attach types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, attach]"
timestamp: 2026-07-01T18:09:30Z
---

# Overview

Imported scene types/attach types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scneventsAttachPropToNode | class | scnSceneEvent | propId, nodeRef, customOffsetPos, customOffsetRot |
| scneventsAttachPropToPerformer | class | scnSceneEvent | propId, performerId, slot, offsetMode, customOffsetPos |
| scneventsAttachPropToPerformerCachedFallbackBone | struct | — | boneName |
| scneventsAttachPropToWorld | class | scnSceneEvent | propId, offsetMode, customOffsetPos, customOffsetRot, referencePerformer |
| scneventsAttachPropToWorldCachedFallbackBone | struct | — | boneName |

# Citations

- `codeware/scripts/Base/Imports/scneventsAttachPropToNode.reds`
- `codeware/scripts/Base/Imports/scneventsAttachPropToPerformer.reds`
- `codeware/scripts/Base/Imports/scneventsAttachPropToPerformerCachedFallbackBone.reds`
- `codeware/scripts/Base/Imports/scneventsAttachPropToWorld.reds`
- `codeware/scripts/Base/Imports/scneventsAttachPropToWorldCachedFallbackBone.reds`
