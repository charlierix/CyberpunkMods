---
type: "Class System"
title: "Strike System"
description: "Strike system: executors (aim snap, apply effector, bullet impact, give player reward, heal, kill, look at, melee hit, melee pre-attack, modify stat, quick melee hit, status effect, stim on hit, time dilate on hit, melee game effects, ricochet) and filters (NPC, NPC dodge, stim targets, distance from root, rotation, investigation reaction)."
resource: "!cyberpunk/strike/executors/executorAimSnap.swift"
tags: ['cyberpunk', 'strike']
timestamp: 2026-07-01T13:00:55Z
---

# Strike System

Strike system: executors (aim snap, apply effector, bullet impact, give player reward, heal, kill, look at, melee hit, melee pre-attack, modify stat, quick melee hit, status effect, stim on hit, time dilate on hit, melee game effects, ricochet) and filters (NPC, NPC dodge, stim targets, distance from root, rotation, investigation reaction).

## Source Files

- `cyberpunk/strike/executors/executorAimSnap.swift`
- `cyberpunk/strike/executors/executorApplyEffector.swift`
- `cyberpunk/strike/executors/executorBulletImpact.swift`
- `cyberpunk/strike/executors/executorGivePlayerReward.swift`
- `cyberpunk/strike/executors/executorHeal.swift`
- `cyberpunk/strike/executors/executorKill.swift`
- `cyberpunk/strike/executors/executorLookAt.swift`
- `cyberpunk/strike/executors/executorMeleeHit.swift`
- `cyberpunk/strike/executors/executorMeleePreAttack.swift`
- `cyberpunk/strike/executors/executorModifyStat.swift`
- `cyberpunk/strike/executors/executorQuickMeleeHit.swift`
- `cyberpunk/strike/executors/executorStatusEffect.swift`
- `cyberpunk/strike/executors/executorStimOnHit.swift`
- `cyberpunk/strike/executors/executorTimeDilateOnHit.swift`
- `cyberpunk/strike/executors/meleeGameEffects.swift`
- `cyberpunk/strike/executors/ricochet.swift`
- `cyberpunk/strike/filters/filterNPC.swift`
- `cyberpunk/strike/filters/filterNPCDodgeOpportunity.swift`
- `cyberpunk/strike/filters/filterStimTargets.swift`
- `cyberpunk/strike/filters/filterTargetsByDistanceFromRoot.swift`
- `cyberpunk/strike/filters/filterTargetsByRotation.swift`
- `cyberpunk/strike/filters/investigationReactionFilter.swift`

## Member Types

**Total declarations: 24**

### Classs (24)

| Name | Bases | Source File |
|------|-------|-------------|
| SnapToTargetExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorAimSnap.swift |
| EffectExecutor_ApplyEffector | EffectExecutor_Scripted | cyberpunk/strike/executors/executorApplyEffector.swift |
| gameEffectExecutor_BulletImpact | EffectExecutor | cyberpunk/strike/executors/executorBulletImpact.swift |
| EffectExecutor_GivePlayerReward | EffectExecutor_Scripted | cyberpunk/strike/executors/executorGivePlayerReward.swift |
| StrikeExecutor_Heal | EffectExecutor_Scripted | cyberpunk/strike/executors/executorHeal.swift |
| StrikeExecutor_Kill | EffectExecutor_Scripted | cyberpunk/strike/executors/executorKill.swift |
| LookAtTargetExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorLookAt.swift |
| MeleeHitAnimEventExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorMeleeHit.swift |
| MeleeHitTerminateGameEffectExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorMeleeHit.swift |
| MeleePreAttackExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorMeleePreAttack.swift |
| StrikeExecutor_ModifyStat | EffectExecutor_Scripted | cyberpunk/strike/executors/executorModifyStat.swift |
| QuickMeleeHitExecutor | EffectExecutor_Scripted | cyberpunk/strike/executors/executorQuickMeleeHit.swift |
| StrikeExecutor_ApplyStatusEffect | EffectExecutor_Scripted | cyberpunk/strike/executors/executorStatusEffect.swift |
| GameEffectExecutor_StimOnHit | EffectExecutor_Scripted | cyberpunk/strike/executors/executorStimOnHit.swift |
| SetTemporaryIndividualTimeDilation | EffectExecutor_Scripted | cyberpunk/strike/executors/executorTimeDilateOnHit.swift |
| EffectExecutor_SlashEffect | EffectExecutor_Scripted | cyberpunk/strike/executors/meleeGameEffects.swift |
| gameEffectExecutor_Ricochet | EffectExecutor | cyberpunk/strike/executors/ricochet.swift |
| StrikeFilterSingle_NPC | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/filterNPC.swift |
| FilterNPCsByType | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/filterNPC.swift |
| FilterNPCDodgeOpportunity | EffectObjectGroupFilter_Scripted | cyberpunk/strike/filters/filterNPCDodgeOpportunity.swift |
| FilterStimTargets | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/filterStimTargets.swift |
| FilterTargetsByDistanceFromRoot | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/filterTargetsByDistanceFromRoot.swift |
| IsFacingTowardsSource | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/filterTargetsByRotation.swift |
| InvestigationReactionFilter | EffectObjectSingleFilter_Scripted | cyberpunk/strike/filters/investigationReactionFilter.swift |

## Citations

- `cyberpunk/strike/executors/executorAimSnap.swift`
- `cyberpunk/strike/executors/executorApplyEffector.swift`
- `cyberpunk/strike/executors/executorBulletImpact.swift`
- `cyberpunk/strike/executors/executorGivePlayerReward.swift`
- `cyberpunk/strike/executors/executorHeal.swift`
- `cyberpunk/strike/executors/executorKill.swift`
- `cyberpunk/strike/executors/executorLookAt.swift`
- `cyberpunk/strike/executors/executorMeleeHit.swift`
- `cyberpunk/strike/executors/executorMeleePreAttack.swift`
- `cyberpunk/strike/executors/executorModifyStat.swift`
- `cyberpunk/strike/executors/executorQuickMeleeHit.swift`
- `cyberpunk/strike/executors/executorStatusEffect.swift`
- `cyberpunk/strike/executors/executorStimOnHit.swift`
- `cyberpunk/strike/executors/executorTimeDilateOnHit.swift`
- `cyberpunk/strike/executors/meleeGameEffects.swift`
- `cyberpunk/strike/executors/ricochet.swift`
- `cyberpunk/strike/filters/filterNPC.swift`
- `cyberpunk/strike/filters/filterNPCDodgeOpportunity.swift`
- `cyberpunk/strike/filters/filterStimTargets.swift`
- `cyberpunk/strike/filters/filterTargetsByDistanceFromRoot.swift`
- `cyberpunk/strike/filters/filterTargetsByRotation.swift`
- `cyberpunk/strike/filters/investigationReactionFilter.swift`
