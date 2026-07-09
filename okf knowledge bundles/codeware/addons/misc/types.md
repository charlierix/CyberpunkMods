---
type: "Addon"
title: "Misc Types Addons"
description: "Field additions to misc types types (23 types)."
resource: "codeware/scripts/"
tags: "[addons, types]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Field additions to misc types types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AdjustTransform | addon | — | position, rotation |
| Damage | addon | — | damageType, value |
| DeviceRef | addon | — | componentName |
| GridCell | addon | — | isActive |
| IComparisonPrereq | addon | — | comparisonType |
| IMovingPlatformMovement | addon | — | initData, endNode |
| ISenseShape | addon | — | id |
| InteractionChoice | addon | — | lookAtDescriptor |
| LatestSaveMetadataInfo | addon | — | gameVersion, additionalContentIds |
| MountingRelationship | addon | — | otherObject |
| PatrolSplineProgress | addon | — | currentControlPoints, entrySplineParam, controlPointIndex |
| PersistentID | addon | — | entityHash, componentName |
| QueryFilter | addon | — | mask1, mask2 |
| SimulationFilter | addon | — | mask1, mask2 |
| SoundPlayVo | addon | — | ignoreGlobalVoLimitCheck, overridingVoiceoverContext, overridingVoiceoverExpression, overrideVoiceoverExpression, overridingVisualStyleValue |
| StatPoolModifier | addon | — | usingPointValues |
| StateSnapshot | addon | — | logicalOwnerIsAWeapon |
| StateSnapshotsContainer | addon | — | snapshot |
| StatusEffect | addon | — | durationID, duration, remainingDuration, maxStacks, sourcesData |
| StatusEffectBase | addon | — | statusEffectRecordID |
| TelemetryDamage | addon | — | hitCount |
| TutorialArea | addon | — | bracketID |
| VisibleObject | addon | — | visibleObjectType |

# Citations

- `codeware/scripts/Base/Addons/AdjustTransform.reds`
- `codeware/scripts/Base/Addons/Damage.reds`
- `codeware/scripts/Base/Addons/DeviceRef.reds`
- `codeware/scripts/Base/Addons/GridCell.reds`
- `codeware/scripts/Base/Addons/IComparisonPrereq.reds`
- `codeware/scripts/Base/Addons/IMovingPlatformMovement.reds`
- `codeware/scripts/Base/Addons/ISenseShape.reds`
- `codeware/scripts/Base/Addons/InteractionChoice.reds`
- `codeware/scripts/Base/Addons/LatestSaveMetadataInfo.reds`
- `codeware/scripts/Base/Addons/MountingRelationship.reds`
- ... and 13 more source files
