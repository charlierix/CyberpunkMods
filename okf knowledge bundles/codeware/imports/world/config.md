---
type: "Import"
title: "World Config"
description: "Imported world config types (4 types)."
resource: "codeware/scripts/"
tags: "[imports, config]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world config types (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| WorldLightingConfig | struct | — | lightAttenuationClamp |
| WorldShadowConfig | struct | — | contactShadows, distantShadowsBaseLevelRadius |
| worldMinimapConfigAreaNode | class | worldAreaShapeNode | streamingRadius |
| worldNavigationConfigAreaNode | class | worldAreaShapeNode | generateVariantsNavmesh, detailSamplingDensity, smoothWalkableAreas, generateCrouchableAreas |

# Citations

- `codeware/scripts/Base/Imports/WorldLightingConfig.reds`
- `codeware/scripts/Base/Imports/WorldShadowConfig.reds`
- `codeware/scripts/Base/Imports/worldMinimapConfigAreaNode.reds`
- `codeware/scripts/Base/Imports/worldNavigationConfigAreaNode.reds`
