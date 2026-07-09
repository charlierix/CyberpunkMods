---
type: "Class System"
title: "Damage Prerequisites"
description: "Hit-based prerequisite conditions for damage types, body parts, attack subtypes, distance, flags, rarity, ricochet, stat pools, status effects, targets, weapons, and more."
resource: "!core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift"
tags: ['core', 'gameplay', 'prereqs', 'damage']
timestamp: 2026-07-01T13:00:55Z
---

# Damage Prerequisites

Hit-based prerequisite conditions for damage types, body parts, attack subtypes, distance, flags, rarity, ricochet, stat pools, status effects, targets, weapons, and more.

## Source Files

- `core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/agentMovingHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/ammoStateHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackSubtypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackTagHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/baseHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/bodyPartHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/consecutiveHitsPrereqCondition.swift`
- `core/gameplay/prereqs/damage/damageOverTimeTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/damageTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/dismembermentTriggeredHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/dismembermentTriggeredPrereq.swift`
- `core/gameplay/prereqs/damage/distanceCoveredHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/effectNameHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/genericHitPrereq.swift`
- `core/gameplay/prereqs/damage/hitAttackSubtypePrereq.swift`
- `core/gameplay/prereqs/damage/hitDamageTypePrereq.swift`
- `core/gameplay/prereqs/damage/hitDistanceCoveredPrereq.swift`
- `core/gameplay/prereqs/damage/hitDoTTypePrereq.swift`
- `core/gameplay/prereqs/damage/hitFlagHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/hitFlagPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartHeadPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartLimbPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartTorsoPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsHumanPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsInstigatorPlayerPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsMovingPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsQuickhackPresentInQueuePrereqCondition.swift`
- `core/gameplay/prereqs/damage/hitIsRarityPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsRicochetPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsSourceGrenadePrereq.swift`
- `core/gameplay/prereqs/damage/hitIsTheSameTarget.swift`
- `core/gameplay/prereqs/damage/hitOrMissTriggeredPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatPoolComparisonPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatPoolPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatusEffectPresentPrereq.swift`
- `core/gameplay/prereqs/damage/instigatorTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/sameTargetHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/selfHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/sourceTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statPoolComparisonHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statPoolHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statusEffectPresentHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetKilledHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetKilledPrereq.swift`
- `core/gameplay/prereqs/damage/targetNPCIsCrowdHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetNPCRarityHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetNPCTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/triggerModeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponEvolutionHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponItemTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/woundedTriggeredPrereq.swift`

## Member Types

**Total declarations: 164**

### Classs (78)

| Name | Bases | Source File |
|------|-------|-------------|
| ReactionPresetHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| AgentMovingHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/agentMovingHitPrereqCondition.swift |
| AmmoStateHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/ammoStateHitPrereqCondition.swift |
| AttackSubtypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/attackSubtypeHitPrereqCondition.swift |
| AttackTagHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/attackTagHitPrereqCondition.swift |
| AttackTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/attackTypeHitPrereqCondition.swift |
| BaseHitPrereqCondition | IScriptable | core/gameplay/prereqs/damage/baseHitPrereqCondition.swift |
| BodyPartHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/bodyPartHitPrereqCondition.swift |
| ConsecutiveHitsPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/consecutiveHitsPrereqCondition.swift |
| DamageOverTimeTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/damageOverTimeTypeHitPrereqCondition.swift |
| DamageTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/damageTypeHitPrereqCondition.swift |
| DismembermentTriggeredHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/dismembermentTriggeredHitPrereqCondition.swift |
| DismembermentTriggeredPrereqState | PrereqState | core/gameplay/prereqs/damage/dismembermentTriggeredPrereq.swift |
| DismembermentTriggeredPrereq | IScriptablePrereq | core/gameplay/prereqs/damage/dismembermentTriggeredPrereq.swift |
| DistanceCoveredHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/distanceCoveredHitPrereqCondition.swift |
| EffectNamePresentHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/effectNameHitPrereqCondition.swift |
| GenericHitPrereqState | PrereqState | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| GenericHitPrereq | IScriptablePrereq | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| HitCallback | ScriptedDamageSystemListener | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| HitTriggeredCallback | HitCallback | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| HitReceivedCallback | HitCallback | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| PipelineProcessedCallback | HitCallback | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| HitAttackSubtypePrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitAttackSubtypePrereq.swift |
| HitAttackSubtypePrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitAttackSubtypePrereq.swift |
| DamageTypePrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitDamageTypePrereq.swift |
| DamageTypePrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitDamageTypePrereq.swift |
| HitDistanceCoveredPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitDistanceCoveredPrereq.swift |
| HitDistanceCoveredPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitDistanceCoveredPrereq.swift |
| HitDamageOverTimePrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitDoTTypePrereq.swift |
| HitDamageOverTimePrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitDoTTypePrereq.swift |
| HitFlagHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/hitFlagHitPrereqCondition.swift |
| HitFlagPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitFlagPrereq.swift |
| HitFlagPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitFlagPrereq.swift |
| HitIsBodyPartHeadPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsBodyPartHeadPrereq.swift |
| HitIsBodyPartLimbPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsBodyPartLimbPrereq.swift |
| HitIsBodyPartTorsoPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsBodyPartTorsoPrereq.swift |
| HitIsHumanPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsHumanPrereq.swift |
| HitIsHumanPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitIsHumanPrereq.swift |
| HitIsInstigatorPlayerPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsInstigatorPlayerPrereq.swift |
| HitIsMovingPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsMovingPrereq.swift |
| HitIsMovingPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitIsMovingPrereq.swift |
| HitIsQuickhackPresentInQueuePrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/hitIsQuickhackPresentInQueuePrereqCondition.swift |
| HitIsRarityPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsRarityPrereq.swift |
| HitIsRarityPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitIsRarityPrereq.swift |
| HitIsRicochetPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsRicochetPrereq.swift |
| HitIsSourceGrenadePrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsSourceGrenadePrereq.swift |
| HitIsTheSameTargetPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitIsTheSameTarget.swift |
| HitIsTheSameTargetPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitIsTheSameTarget.swift |
| HitOrMissTriggeredPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitOrMissTriggeredPrereq.swift |
| HitStatPoolComparisonPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitStatPoolComparisonPrereq.swift |
| HitStatPoolComparisonPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitStatPoolComparisonPrereq.swift |
| HitStatPoolPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitStatPoolPrereq.swift |
| HitStatPoolPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitStatPoolPrereq.swift |
| HitStatusEffectPresentPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/hitStatusEffectPresentPrereq.swift |
| HitStatusEffectPresentPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/hitStatusEffectPresentPrereq.swift |
| InstigatorTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/instigatorTypeHitPrereqCondition.swift |
| SameTargetHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/sameTargetHitPrereqCondition.swift |
| SelfHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/selfHitPrereqCondition.swift |
| SourceTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/sourceTypeHitPrereqCondition.swift |
| StatHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/statHitPrereqCondition.swift |
| StatPoolComparisonHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/statPoolComparisonHitPrereqCondition.swift |
| StatPoolHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/statPoolHitPrereqCondition.swift |
| StatusEffectPresentHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/statusEffectPresentHitPrereqCondition.swift |
| TargetKilledHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetKilledHitPrereqCondition.swift |
| TargetCanGetKilledByDamagePrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetKilledHitPrereqCondition.swift |
| TargetBreachCanGetKilledByDamagePrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetKilledHitPrereqCondition.swift |
| TargetKilledPrereqState | GenericHitPrereqState | core/gameplay/prereqs/damage/targetKilledPrereq.swift |
| TargetKilledPrereq | GenericHitPrereq | core/gameplay/prereqs/damage/targetKilledPrereq.swift |
| TargetNPCIsCrowdHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetNPCIsCrowdHitPrereqCondition.swift |
| TargetNPCRarityHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetNPCRarityHitPrereqCondition.swift |
| TargetNPCTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetNPCTypeHitPrereqCondition.swift |
| TargetTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/targetTypeHitPrereqCondition.swift |
| TriggerModeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/triggerModeHitPrereqCondition.swift |
| WeaponEvolutionHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/weaponEvolutionHitPrereqCondition.swift |
| WeaponItemTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/weaponItemTypeHitPrereqCondition.swift |
| WeaponTypeHitPrereqCondition | BaseHitPrereqCondition | core/gameplay/prereqs/damage/weaponTypeHitPrereqCondition.swift |
| WoundedTriggeredPrereqState | PrereqState | core/gameplay/prereqs/damage/woundedTriggeredPrereq.swift |
| WoundedTriggeredPrereq | IScriptablePrereq | core/gameplay/prereqs/damage/woundedTriggeredPrereq.swift |

### Funcs (86)

| Name | Bases | Source File |
|------|-------|-------------|
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| OnMissTriggered |  | core/gameplay/prereqs/damage/baseHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| OnMissTriggered |  | core/gameplay/prereqs/damage/baseHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| OnMissTriggered |  | core/gameplay/prereqs/damage/baseHitPrereqCondition.swift |
| RegisterState |  | core/gameplay/prereqs/damage/genericHitPrereq.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| OnMissTriggered |  | core/gameplay/prereqs/damage/baseHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| SetData |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |
| Evaluate |  | core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift |

## Citations

- `core/gameplay/prereqs/damage/ReactionPresetHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/agentMovingHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/ammoStateHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackSubtypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackTagHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/attackTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/baseHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/bodyPartHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/consecutiveHitsPrereqCondition.swift`
- `core/gameplay/prereqs/damage/damageOverTimeTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/damageTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/dismembermentTriggeredHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/dismembermentTriggeredPrereq.swift`
- `core/gameplay/prereqs/damage/distanceCoveredHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/effectNameHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/genericHitPrereq.swift`
- `core/gameplay/prereqs/damage/hitAttackSubtypePrereq.swift`
- `core/gameplay/prereqs/damage/hitDamageTypePrereq.swift`
- `core/gameplay/prereqs/damage/hitDistanceCoveredPrereq.swift`
- `core/gameplay/prereqs/damage/hitDoTTypePrereq.swift`
- `core/gameplay/prereqs/damage/hitFlagHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/hitFlagPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartHeadPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartLimbPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsBodyPartTorsoPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsHumanPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsInstigatorPlayerPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsMovingPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsQuickhackPresentInQueuePrereqCondition.swift`
- `core/gameplay/prereqs/damage/hitIsRarityPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsRicochetPrereq.swift`
- `core/gameplay/prereqs/damage/hitIsSourceGrenadePrereq.swift`
- `core/gameplay/prereqs/damage/hitIsTheSameTarget.swift`
- `core/gameplay/prereqs/damage/hitOrMissTriggeredPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatPoolComparisonPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatPoolPrereq.swift`
- `core/gameplay/prereqs/damage/hitStatusEffectPresentPrereq.swift`
- `core/gameplay/prereqs/damage/instigatorTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/sameTargetHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/selfHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/sourceTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statPoolComparisonHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statPoolHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/statusEffectPresentHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetKilledHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetKilledPrereq.swift`
- `core/gameplay/prereqs/damage/targetNPCIsCrowdHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetNPCRarityHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetNPCTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/targetTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/triggerModeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponEvolutionHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponItemTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/weaponTypeHitPrereqCondition.swift`
- `core/gameplay/prereqs/damage/woundedTriggeredPrereq.swift`
