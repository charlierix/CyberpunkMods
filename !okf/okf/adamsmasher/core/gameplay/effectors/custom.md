---
type: "Class System"
title: "Custom Effectors"
description: "Custom gameplay effectors for damage conversion, detection meters, overshields, cyberware, perks, and special weapon effects."
resource: "!core/gameplay/effectors/custom/applyAccumulatedDoTEffector.swift"
tags: ['core', 'gameplay', 'effectors', 'custom']
timestamp: 2026-07-01T13:00:55Z
---

# Custom Effectors

Custom gameplay effectors for damage conversion, detection meters, overshields, cyberware, perks, and special weapon effects.

## Source Files

- `core/gameplay/effectors/custom/applyAccumulatedDoTEffector.swift`
- `core/gameplay/effectors/custom/chaosWeaponCustomEffector.swift`
- `core/gameplay/effectors/custom/clearQuickhackQueueEffector.swift`
- `core/gameplay/effectors/custom/convertDamageToDoTEffector.swift`
- `core/gameplay/effectors/custom/convertDamageToStatPoolEffector.swift`
- `core/gameplay/effectors/custom/detectionMeterEffector.swift`
- `core/gameplay/effectors/custom/disassembleOwnedJunkEffector.swift`
- `core/gameplay/effectors/custom/grenadeLvl4HackEffector.swift`
- `core/gameplay/effectors/custom/hardToKillDamageModiicationEffector.swift`
- `core/gameplay/effectors/custom/highlightEffector.swift`
- `core/gameplay/effectors/custom/iceCounterHackEffector.swift`
- `core/gameplay/effectors/custom/initiateCyberwareExplosionEffector.swift`
- `core/gameplay/effectors/custom/juggernautEffector.swift`
- `core/gameplay/effectors/custom/kiroshiHighlightEffector.swift`
- `core/gameplay/effectors/custom/limfaticNanoChargeSystemEffector.swift`
- `core/gameplay/effectors/custom/modifyStatPoolValueQuickhackCostEffector.swift`
- `core/gameplay/effectors/custom/nanoTechPlatesEffector.swift`
- `core/gameplay/effectors/custom/overshieldEffectorBase.swift`
- `core/gameplay/effectors/custom/playVFXOnHitPositionEffector.swift`
- `core/gameplay/effectors/custom/powerUpCyberwareEffector.swift`
- `core/gameplay/effectors/custom/reflexesMasterPerk1Effector.swift`
- `core/gameplay/effectors/custom/sadismEffector.swift`
- `core/gameplay/effectors/custom/scaleOvershieldDecayOverTimeEffector.swift`
- `core/gameplay/effectors/custom/setFactBasedOnClearAreaEffector.swift`
- `core/gameplay/effectors/custom/smartStorageEffector.swift`
- `core/gameplay/effectors/custom/statBonusFromFactEffector.swift`
- `core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift`
- `core/gameplay/effectors/custom/stuckInEffector.swift`
- `core/gameplay/effectors/custom/systemCollapseModifyRevealBarEffector.swift`
- `core/gameplay/effectors/custom/timeBankEffector.swift`
- `core/gameplay/effectors/custom/togglePlayerFlashlightEffector.swift`
- `core/gameplay/effectors/custom/unstoppableEffector.swift`
- `core/gameplay/effectors/custom/weirdTankyPlatingEffector.swift`

## Member Types

**Total declarations: 55**

### Classs (46)

| Name | Bases | Source File |
|------|-------|-------------|
| ApplyAccumulatedDoTEffector | TriggerContinuousAttackEffector | core/gameplay/effectors/custom/applyAccumulatedDoTEffector.swift |
| ChaosWeaponCustomEffector | Effector | core/gameplay/effectors/custom/chaosWeaponCustomEffector.swift |
| ChaosWeaponDamageTypeEffector | ChaosWeaponCustomEffector | core/gameplay/effectors/custom/chaosWeaponCustomEffector.swift |
| ClearQuickhackQueueEffector | Effector | core/gameplay/effectors/custom/clearQuickhackQueueEffector.swift |
| ConvertDamageToDoTEffector | ModifyAttackEffector | core/gameplay/effectors/custom/convertDamageToDoTEffector.swift |
| ConvertDamageToStatPoolEffector | HitEventEffector | core/gameplay/effectors/custom/convertDamageToStatPoolEffector.swift |
| DetectionMeterEffector | Effector | core/gameplay/effectors/custom/detectionMeterEffector.swift |
| DisassembleOwnedJunkEffector | Effector | core/gameplay/effectors/custom/disassembleOwnedJunkEffector.swift |
| GrenadeChangedCallback | AttachmentSlotsScriptCallback | core/gameplay/effectors/custom/grenadeLvl4HackEffector.swift |
| GrenadeLvl4HackEffector | Effector | core/gameplay/effectors/custom/grenadeLvl4HackEffector.swift |
| HardToKillDamageModificationEffector | ModifyAttackEffector | core/gameplay/effectors/custom/hardToKillDamageModiicationEffector.swift |
| HighlightEffector | ContinuousEffector | core/gameplay/effectors/custom/highlightEffector.swift |
| ICECounterHackEffector | Effector | core/gameplay/effectors/custom/iceCounterHackEffector.swift |
| InitiateCyberwareExplosionEffector | Effector | core/gameplay/effectors/custom/initiateCyberwareExplosionEffector.swift |
| JuggernautEffector | ContinuousEffector | core/gameplay/effectors/custom/juggernautEffector.swift |
| KiroshiHighlightEffectorCallback | AttachmentSlotsScriptCallback | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| KiroshiEffectorIsAimingStatListener | ScriptStatsListener | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| KiroshiEffectorTechPreviewStatListener | ScriptStatsListener | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| KiroshiHighlightEffector | HighlightEffector | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| LimfaticNanoChargeSystemEffector | ContinuousEffector | core/gameplay/effectors/custom/limfaticNanoChargeSystemEffector.swift |
| ModifyStatPoolValueQuickhackCostEffector | HitEventEffector | core/gameplay/effectors/custom/modifyStatPoolValueQuickhackCostEffector.swift |
| NanoTechPlatesEffector | ModifyAttackEffector | core/gameplay/effectors/custom/nanoTechPlatesEffector.swift |
| OvershieldEffectorBase | ContinuousEffector | core/gameplay/effectors/custom/overshieldEffectorBase.swift |
| PlayVFXOnHitPositionEffector | Effector | core/gameplay/effectors/custom/playVFXOnHitPositionEffector.swift |
| PowerUpCyberwareEffector | Effector | core/gameplay/effectors/custom/powerUpCyberwareEffector.swift |
| ReflexesMasterPerk1EffectorListener | ScriptedDamageSystemListener | core/gameplay/effectors/custom/reflexesMasterPerk1Effector.swift |
| ReflexesMasterPerk1Effector | ModifyAttackEffector | core/gameplay/effectors/custom/reflexesMasterPerk1Effector.swift |
| SadismEffector | Effector | core/gameplay/effectors/custom/sadismEffector.swift |
| OvershieldMinValueListener | ScriptStatPoolsListener | core/gameplay/effectors/custom/scaleOvershieldDecayOverTimeEffector.swift |
| ScaleOvershieldDecayOverTimeEffector | ContinuousEffector | core/gameplay/effectors/custom/scaleOvershieldDecayOverTimeEffector.swift |
| SetFactBasedOnClearAreaEffector | Effector | core/gameplay/effectors/custom/setFactBasedOnClearAreaEffector.swift |
| SmartStorageEffector | ModifyAttackEffector | core/gameplay/effectors/custom/smartStorageEffector.swift |
| StatBonusFromFactEffector | Effector | core/gameplay/effectors/custom/statBonusFromFactEffector.swift |
| StatPoolBasedStatusEffectEffectorListener | ScriptStatPoolsListener | core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift |
| StatPoolBasedStatusEffectEffector | Effector | core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift |
| StuckInEffector | ContinuousEffector | core/gameplay/effectors/custom/stuckInEffector.swift |
| SystemCollapseLifetimeEffector | Effector | core/gameplay/effectors/custom/systemCollapseModifyRevealBarEffector.swift |
| SystemCollapseModifyRevealBarEffector | Effector | core/gameplay/effectors/custom/systemCollapseModifyRevealBarEffector.swift |
| TimeBankOnStatusEffectAppliedListener | ScriptStatusEffectListener | core/gameplay/effectors/custom/timeBankEffector.swift |
| StatusEffectBasedTimeBankEffector | Effector | core/gameplay/effectors/custom/timeBankEffector.swift |
| TimeBankValueListener | ScriptStatPoolsListener | core/gameplay/effectors/custom/timeBankEffector.swift |
| StatPoolValueListener | ScriptStatPoolsListener | core/gameplay/effectors/custom/timeBankEffector.swift |
| StatPoolBasedTimeBankEffector | ContinuousEffector | core/gameplay/effectors/custom/timeBankEffector.swift |
| TogglePlayerFlashlightEffector | Effector | core/gameplay/effectors/custom/togglePlayerFlashlightEffector.swift |
| UnstoppableEffector | OvershieldEffectorBase | core/gameplay/effectors/custom/unstoppableEffector.swift |
| WeirdTankyPlatingEffector | ModifyAttackEffector | core/gameplay/effectors/custom/weirdTankyPlatingEffector.swift |

### Funcs (9)

| Name | Bases | Source File |
|------|-------|-------------|
| OnItemEquippedVisual |  | core/gameplay/effectors/custom/grenadeLvl4HackEffector.swift |
| OnItemEquipped |  | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| OnItemUnequipped |  | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| OnStatChanged |  | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| OnStatChanged |  | core/gameplay/effectors/custom/kiroshiHighlightEffector.swift |
| OnStatPoolValueChanged |  | core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift |
| OnStatusEffectApplied |  | core/gameplay/effectors/custom/timeBankEffector.swift |
| OnStatPoolValueChanged |  | core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift |
| OnStatPoolValueChanged |  | core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift |

## Citations

- `core/gameplay/effectors/custom/applyAccumulatedDoTEffector.swift`
- `core/gameplay/effectors/custom/chaosWeaponCustomEffector.swift`
- `core/gameplay/effectors/custom/clearQuickhackQueueEffector.swift`
- `core/gameplay/effectors/custom/convertDamageToDoTEffector.swift`
- `core/gameplay/effectors/custom/convertDamageToStatPoolEffector.swift`
- `core/gameplay/effectors/custom/detectionMeterEffector.swift`
- `core/gameplay/effectors/custom/disassembleOwnedJunkEffector.swift`
- `core/gameplay/effectors/custom/grenadeLvl4HackEffector.swift`
- `core/gameplay/effectors/custom/hardToKillDamageModiicationEffector.swift`
- `core/gameplay/effectors/custom/highlightEffector.swift`
- `core/gameplay/effectors/custom/iceCounterHackEffector.swift`
- `core/gameplay/effectors/custom/initiateCyberwareExplosionEffector.swift`
- `core/gameplay/effectors/custom/juggernautEffector.swift`
- `core/gameplay/effectors/custom/kiroshiHighlightEffector.swift`
- `core/gameplay/effectors/custom/limfaticNanoChargeSystemEffector.swift`
- `core/gameplay/effectors/custom/modifyStatPoolValueQuickhackCostEffector.swift`
- `core/gameplay/effectors/custom/nanoTechPlatesEffector.swift`
- `core/gameplay/effectors/custom/overshieldEffectorBase.swift`
- `core/gameplay/effectors/custom/playVFXOnHitPositionEffector.swift`
- `core/gameplay/effectors/custom/powerUpCyberwareEffector.swift`
- `core/gameplay/effectors/custom/reflexesMasterPerk1Effector.swift`
- `core/gameplay/effectors/custom/sadismEffector.swift`
- `core/gameplay/effectors/custom/scaleOvershieldDecayOverTimeEffector.swift`
- `core/gameplay/effectors/custom/setFactBasedOnClearAreaEffector.swift`
- `core/gameplay/effectors/custom/smartStorageEffector.swift`
- `core/gameplay/effectors/custom/statBonusFromFactEffector.swift`
- `core/gameplay/effectors/custom/statPoolBasedStatusEffectEffector.swift`
- `core/gameplay/effectors/custom/stuckInEffector.swift`
- `core/gameplay/effectors/custom/systemCollapseModifyRevealBarEffector.swift`
- `core/gameplay/effectors/custom/timeBankEffector.swift`
- `core/gameplay/effectors/custom/togglePlayerFlashlightEffector.swift`
- `core/gameplay/effectors/custom/unstoppableEffector.swift`
- `core/gameplay/effectors/custom/weirdTankyPlatingEffector.swift`
