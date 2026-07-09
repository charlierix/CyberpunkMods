---
type: "Addon"
title: "Physics Addons"
description: "Field additions to physics types via @addField (4 types)."
resource: "codeware/scripts/"
tags: "[addons, physics]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Field additions to physics types via @addField (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| PhysicalDestructionComponent | addon | — | mesh, meshAppearance, forceAutoHideDistance, destructionParams, destructionLevelData |
| PhysicalMeshComponent | addon | — | visibilityAnimationParam, simulationType, useResourceSimulationType, startInactive, filterDataSource |
| RagdollActivationRequestData | addon | — | activationNoGroundThreshold, activateOnCollision, calculateEarlyPositionGroundHeight |
| RagdollImpactPointData | addon | — | otherProxyActorIndex |

# Citations

- `codeware/scripts/Base/Addons/PhysicalDestructionComponent.reds`
- `codeware/scripts/Base/Addons/PhysicalMeshComponent.reds`
- `codeware/scripts/Base/Addons/RagdollActivationRequestData.reds`
- `codeware/scripts/Base/Addons/RagdollImpactPointData.reds`
