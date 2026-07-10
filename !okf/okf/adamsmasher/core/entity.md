---
type: "Class System"
title: "Entity System"
description: "Entity, GameObject, and EntityID core type definitions and operations."
resource: "!core/entity/entity.swift"
tags: ['core', 'entity']
timestamp: 2026-07-01T13:00:55Z
---

# Entity System

Entity, GameObject, and EntityID core type definitions and operations.

## Source Files

- `core/entity/entity.swift`
- `core/entity/entityID.swift`
- `core/entity/gameObject.swift`

## Member Types

**Total declarations: 18**

### Classs (5)

| Name | Bases | Source File |
|------|-------|-------------|
| Entity | IScriptable | core/entity/entity.swift |
| SetGlitchOnUIEvent | Event | core/entity/gameObject.swift |
| OutlineRequest | IScriptable | core/entity/gameObject.swift |
| GameObjectListener | IScriptable | core/entity/gameObject.swift |
| GameObject | GameEntity | core/entity/gameObject.swift |

### Static Funcs (3)

| Name | Bases | Source File |
|------|-------|-------------|
| EMPTY_ENTITY_ID |  | core/entity/entityID.swift |
| OperatorAdd |  | core/entity/gameObject.swift |
| OperatorAdd |  | core/entity/gameObject.swift |

### Funcs (10)

| Name | Bases | Source File |
|------|-------|-------------|
| OnInspectorDebugDraw |  | core/entity/entity.swift |
| ReactToHitProcess |  | core/entity/gameObject.swift |
| DisplayHitUI |  | core/entity/gameObject.swift |
| DisplayKillUI |  | core/entity/gameObject.swift |
| Record1DamageInHistory |  | core/entity/gameObject.swift |
| UpdateAdditionalScanningData |  | core/entity/gameObject.swift |
| SetCurrentlyUploadingAction |  | core/entity/gameObject.swift |
| GetCurrentlyUploadingAction |  | core/entity/gameObject.swift |
| EvaluateMappinsVisualState |  | core/entity/gameObject.swift |
| GetScannableObjects |  | core/entity/gameObject.swift |

## Citations

- `core/entity/entity.swift`
- `core/entity/entityID.swift`
- `core/entity/gameObject.swift`
