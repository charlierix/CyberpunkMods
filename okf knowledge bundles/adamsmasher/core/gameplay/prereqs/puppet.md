---
type: "Class System"
title: "Puppet Prerequisites"
description: "Puppet-based prerequisites for NPC states, attitudes, combat, locomotion, rarity, reactions, tracking, player movement, elevation, and visual tags."
resource: "!core/gameplay/prereqs/puppet/ActionTargetInDistancePrereq.swift"
tags: ['core', 'gameplay', 'prereqs', 'puppet']
timestamp: 2026-07-01T13:00:55Z
---

# Puppet Prerequisites

Puppet-based prerequisites for NPC states, attitudes, combat, locomotion, rarity, reactions, tracking, player movement, elevation, and visual tags.

## Source Files

- `core/gameplay/prereqs/puppet/ActionTargetInDistancePrereq.swift`
- `core/gameplay/prereqs/puppet/ActionTargetPrereq.swift`
- `core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift`
- `core/gameplay/prereqs/puppet/GameplayTagsPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCAttitudeTowardsPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCHasVisualTag.swift`
- `core/gameplay/prereqs/puppet/NPCHitReactionTypePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCHitSourcePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCIsAggressive.swift`
- `core/gameplay/prereqs/puppet/NPCIsFollower.swift`
- `core/gameplay/prereqs/puppet/NPCLocomotionTypePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCNoticedPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCRarityPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCReactionPresetPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCScenePrereqs.swift`
- `core/gameplay/prereqs/puppet/NPCTrackingPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCTypePrereq.swift`
- `core/gameplay/prereqs/puppet/PlayerElevationPrereq.swift`
- `core/gameplay/prereqs/puppet/PlayerInCombatTime.swift`
- `core/gameplay/prereqs/puppet/VisualTagsPrereq.swift`
- `core/gameplay/prereqs/puppet/baseNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/characterDataPrereq.swift`
- `core/gameplay/prereqs/puppet/highLevelNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/ignoreBarbedWirePrereq.swift`
- `core/gameplay/prereqs/puppet/isHumanPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerControlsDevicePrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerMovingPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerOnGroundPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerReachablePrereq.swift`
- `core/gameplay/prereqs/puppet/isPuppetActivePrereq.swift`
- `core/gameplay/prereqs/puppet/isPuppetBreached.swift`
- `core/gameplay/prereqs/puppet/stanceNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/upperBodyNPCSMPrereq.swift`

## Member Types

**Total declarations: 57**

### Classs (55)

| Name | Bases | Source File |
|------|-------|-------------|
| ActionTargetInDistancePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/ActionTargetInDistancePrereq.swift |
| ActionTargetPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/ActionTargetPrereq.swift |
| ChargedItemsPrereqListener | BaseStatPoolPrereqListener | core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift |
| ChargedItemsPrereqState | PrereqState | core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift |
| ChargedItemsPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift |
| GameplayTagsPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/GameplayTagsPrereq.swift |
| NPCAttitudeTowardsPlayerPrereqState | PrereqState | core/gameplay/prereqs/puppet/NPCAttitudeTowardsPlayerPrereq.swift |
| NPCAttitudeTowardsPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCAttitudeTowardsPlayerPrereq.swift |
| NPCRecordHasVisualTag | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCHasVisualTag.swift |
| EntityHasVisualTag | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCHasVisualTag.swift |
| NPCHitReactionTypePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCHitReactionTypePrereq.swift |
| NPCHitSourcePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCHitSourcePrereq.swift |
| NPCIsAggressivePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCIsAggressive.swift |
| NPCIsFollowerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCIsFollower.swift |
| NPCLocomotionTypePrereqState | PrereqState | core/gameplay/prereqs/puppet/NPCLocomotionTypePrereq.swift |
| NPCLocomotionTypePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCLocomotionTypePrereq.swift |
| EntityNoticedPlayerPrereqState | PrereqState | core/gameplay/prereqs/puppet/NPCNoticedPlayerPrereq.swift |
| EntityNoticedPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCNoticedPlayerPrereq.swift |
| NPCRarityPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCRarityPrereq.swift |
| NPCReactionPresetPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCReactionPresetPrereq.swift |
| NPCInScenePrereqState | PrereqState | core/gameplay/prereqs/puppet/NPCScenePrereqs.swift |
| NPCInScenePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCScenePrereqs.swift |
| NPCTrackingPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCTrackingPlayerPrereq.swift |
| NPCDetectingPlayerPrereqState | PrereqState | core/gameplay/prereqs/puppet/NPCTrackingPlayerPrereq.swift |
| NPCDetectingPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCTrackingPlayerPrereq.swift |
| NPCTypePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCTypePrereq.swift |
| NPCIsChildPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCTypePrereq.swift |
| NPCIsCrowdPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/NPCTypePrereq.swift |
| PlayerElevationPrereqState | PrereqState | core/gameplay/prereqs/puppet/PlayerElevationPrereq.swift |
| PlayerElevationPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/PlayerElevationPrereq.swift |
| PlayerCombatStateTimePrereqState | PrereqState | core/gameplay/prereqs/puppet/PlayerInCombatTime.swift |
| PlayerCombatStateTimePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/PlayerInCombatTime.swift |
| VisualTagsPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/VisualTagsPrereq.swift |
| NPCStatePrereqState | PrereqState | core/gameplay/prereqs/puppet/baseNPCSMPrereq.swift |
| NPCStatePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/baseNPCSMPrereq.swift |
| CharacterDataPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/characterDataPrereq.swift |
| HighLevelNPCStatePrereq | NPCStatePrereq | core/gameplay/prereqs/puppet/highLevelNPCSMPrereq.swift |
| CurrentHighLevelNPCStatePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/highLevelNPCSMPrereq.swift |
| IgnoreBarbedWirePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/ignoreBarbedWirePrereq.swift |
| IsHumanPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isHumanPrereq.swift |
| IsPlayerControlsDevicePrereqState | PrereqState | core/gameplay/prereqs/puppet/isPlayerControlsDevicePrereq.swift |
| IsPlayerControlsDevicePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPlayerControlsDevicePrereq.swift |
| IsPlayerMovingPrereqState | PrereqState | core/gameplay/prereqs/puppet/isPlayerMovingPrereq.swift |
| IsPlayerMovingPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/puppet/isPlayerMovingPrereq.swift |
| IsPlayerOnGroundPrereqState | PrereqState | core/gameplay/prereqs/puppet/isPlayerOnGroundPrereq.swift |
| IsPlayerOnGroundPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPlayerOnGroundPrereq.swift |
| IsPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPlayerPrereq.swift |
| IsPlayerReachablePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPlayerReachablePrereq.swift |
| IsPuppetActivePrereqState | PrereqState | core/gameplay/prereqs/puppet/isPuppetActivePrereq.swift |
| IsPuppetActivePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPuppetActivePrereq.swift |
| IsPuppetBreachedPrereqState | PrereqState | core/gameplay/prereqs/puppet/isPuppetBreached.swift |
| IsPuppetBreachedPrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/isPuppetBreached.swift |
| StanceNPCStatePrereq | NPCStatePrereq | core/gameplay/prereqs/puppet/stanceNPCSMPrereq.swift |
| CurrentStanceNPCStatePrereq | IScriptablePrereq | core/gameplay/prereqs/puppet/stanceNPCSMPrereq.swift |
| UpperBodyNPCStatePrereq | NPCStatePrereq | core/gameplay/prereqs/puppet/upperBodyNPCSMPrereq.swift |

### Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatPoolValueChanged |  | core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift |

## Citations

- `core/gameplay/prereqs/puppet/ActionTargetInDistancePrereq.swift`
- `core/gameplay/prereqs/puppet/ActionTargetPrereq.swift`
- `core/gameplay/prereqs/puppet/ChargedItemsPrereq.swift`
- `core/gameplay/prereqs/puppet/GameplayTagsPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCAttitudeTowardsPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCHasVisualTag.swift`
- `core/gameplay/prereqs/puppet/NPCHitReactionTypePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCHitSourcePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCIsAggressive.swift`
- `core/gameplay/prereqs/puppet/NPCIsFollower.swift`
- `core/gameplay/prereqs/puppet/NPCLocomotionTypePrereq.swift`
- `core/gameplay/prereqs/puppet/NPCNoticedPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCRarityPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCReactionPresetPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCScenePrereqs.swift`
- `core/gameplay/prereqs/puppet/NPCTrackingPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/NPCTypePrereq.swift`
- `core/gameplay/prereqs/puppet/PlayerElevationPrereq.swift`
- `core/gameplay/prereqs/puppet/PlayerInCombatTime.swift`
- `core/gameplay/prereqs/puppet/VisualTagsPrereq.swift`
- `core/gameplay/prereqs/puppet/baseNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/characterDataPrereq.swift`
- `core/gameplay/prereqs/puppet/highLevelNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/ignoreBarbedWirePrereq.swift`
- `core/gameplay/prereqs/puppet/isHumanPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerControlsDevicePrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerMovingPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerOnGroundPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerPrereq.swift`
- `core/gameplay/prereqs/puppet/isPlayerReachablePrereq.swift`
- `core/gameplay/prereqs/puppet/isPuppetActivePrereq.swift`
- `core/gameplay/prereqs/puppet/isPuppetBreached.swift`
- `core/gameplay/prereqs/puppet/stanceNPCSMPrereq.swift`
- `core/gameplay/prereqs/puppet/upperBodyNPCSMPrereq.swift`
