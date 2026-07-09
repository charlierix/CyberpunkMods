---
type: "Addon"
title: "Entity Addons"
description: "Field additions to entity types via @addField (5 types)."
resource: "codeware/scripts/"
tags: "[addons, entity]"
timestamp: 2026-07-01T18:09:40Z
---

# Overview

Field additions to entity types via @addField (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| Entity | addon | — | customCameraTarget, renderSceneLayerMask |
| EntityID | addon | — | hash |
| EntityReference | addon | — | type, names, slotName, sceneActorContextName, dynamicEntityUniqueName |
| entCameraComponent | addon | — | fov, zoom, nearPlaneOverride, farPlaneOverride, motionBlurScale |
| entSpawnEffectEvent | addon | — | idForRandomizedEffect, e3hackDeferCount |

# Citations

- `codeware/scripts/Base/Addons/Entity.reds`
- `codeware/scripts/Base/Addons/EntityID.reds`
- `codeware/scripts/Base/Addons/EntityReference.reds`
- `codeware/scripts/Base/Addons/entCameraComponent.reds`
- `codeware/scripts/Base/Addons/entSpawnEffectEvent.reds`
