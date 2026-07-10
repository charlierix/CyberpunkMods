---
type: "Class System"
title: "Prerequisites Base"
description: "Base prerequisite system: always-true, stat pool, consumable, district, fact, game time, item creation, on/off, perfect discharge, random/set chance, stat pool change, stat, status effect, temporal."
resource: "!core/gameplay/prereqs/alwaysTruePrereq.swift"
tags: ['core', 'gameplay', 'prereqs']
timestamp: 2026-07-01T13:00:55Z
---

# Prerequisites Base

Base prerequisite system: always-true, stat pool, consumable, district, fact, game time, item creation, on/off, perfect discharge, random/set chance, stat pool change, stat, status effect, temporal.

## Source Files

- `core/gameplay/prereqs/alwaysTruePrereq.swift`
- `core/gameplay/prereqs/constantStatPoolPrereq.swift`
- `core/gameplay/prereqs/consumableChargesPrereq.swift`
- `core/gameplay/prereqs/districtPrereq.swift`
- `core/gameplay/prereqs/factValuePrereq.swift`
- `core/gameplay/prereqs/gameTimePrereq.swift`
- `core/gameplay/prereqs/itemCreationPrereq.swift`
- `core/gameplay/prereqs/onOffPrereq.swift`
- `core/gameplay/prereqs/perfectDischargePrereq.swift`
- `core/gameplay/prereqs/randomChancePrereq.swift`
- `core/gameplay/prereqs/setChancePrereq.swift`
- `core/gameplay/prereqs/statPoolChangeOverTimePrereq.swift`
- `core/gameplay/prereqs/statPoolPrereq.swift`
- `core/gameplay/prereqs/statPoolSpentPrereq.swift`
- `core/gameplay/prereqs/statPrereq.swift`
- `core/gameplay/prereqs/statusEffectPrereq.swift`
- `core/gameplay/prereqs/statusEffectRemovedPrereq.swift`
- `core/gameplay/prereqs/temporalPrereq.swift`
- `core/gameplay/prereqs/ui/DialogueChoiceHubPrereq.swift`

## Member Types

**Total declarations: 74**

### Classs (42)

| Name | Bases | Source File |
|------|-------|-------------|
| AlwaysTruePrereq | IScriptablePrereq | core/gameplay/prereqs/alwaysTruePrereq.swift |
| ConstantStatPoolPrereqListener | BaseStatPoolPrereqListener | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| ConstantStatPoolPrereqState | StatPoolPrereqState | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| ConstantStatPoolPrereq | StatPoolPrereq | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| ConsumableChargesPrereqListener | ScriptStatPoolsListener | core/gameplay/prereqs/consumableChargesPrereq.swift |
| ConsumableChargesPrereqState | PrereqState | core/gameplay/prereqs/consumableChargesPrereq.swift |
| ConsumableChargesPrereq | StatPoolPrereq | core/gameplay/prereqs/consumableChargesPrereq.swift |
| DistrictPrereq | IScriptablePrereq | core/gameplay/prereqs/districtPrereq.swift |
| FactValuePrereqState | PrereqState | core/gameplay/prereqs/factValuePrereq.swift |
| FactValuePrereq | IScriptablePrereq | core/gameplay/prereqs/factValuePrereq.swift |
| GameTimePrereqState | PrereqState | core/gameplay/prereqs/gameTimePrereq.swift |
| GameTimePrereq | IScriptablePrereq | core/gameplay/prereqs/gameTimePrereq.swift |
| ItemCreationPrereq | IScriptablePrereq | core/gameplay/prereqs/itemCreationPrereq.swift |
| OnOffPrereq | IScriptablePrereq | core/gameplay/prereqs/onOffPrereq.swift |
| PerfectDischargePrereqListener | ScriptStatPoolsListener | core/gameplay/prereqs/perfectDischargePrereq.swift |
| PerfectDischargePrereqState | StatPoolPrereqState | core/gameplay/prereqs/perfectDischargePrereq.swift |
| PerfectDischargePrereq | StatPoolPrereq | core/gameplay/prereqs/perfectDischargePrereq.swift |
| RandomChancePrereq | IScriptablePrereq | core/gameplay/prereqs/randomChancePrereq.swift |
| SetChancePrereq | IScriptablePrereq | core/gameplay/prereqs/setChancePrereq.swift |
| StatPoolChangeOverTimePrereqListener | BaseStatPoolPrereqListener | core/gameplay/prereqs/statPoolChangeOverTimePrereq.swift |
| StatPoolChangeOverTimePrereqState | PrereqState | core/gameplay/prereqs/statPoolChangeOverTimePrereq.swift |
| StatPoolChangeOverTimePrereq | IScriptablePrereq | core/gameplay/prereqs/statPoolChangeOverTimePrereq.swift |
| BaseStatPoolPrereqListener | CustomValueStatPoolsListener | core/gameplay/prereqs/statPoolPrereq.swift |
| StatPoolPrereqListener | BaseStatPoolPrereqListener | core/gameplay/prereqs/statPoolPrereq.swift |
| StatPoolPrereqState | PrereqState | core/gameplay/prereqs/statPoolPrereq.swift |
| StatPoolPrereq | IScriptablePrereq | core/gameplay/prereqs/statPoolPrereq.swift |
| StatPoolSpentPrereqListener | BaseStatPoolPrereqListener | core/gameplay/prereqs/statPoolSpentPrereq.swift |
| StatPoolSpentPrereqState | PrereqState | core/gameplay/prereqs/statPoolSpentPrereq.swift |
| StatPoolSpentPrereq | IScriptablePrereq | core/gameplay/prereqs/statPoolSpentPrereq.swift |
| StatPrereqListener | ScriptStatsListener | core/gameplay/prereqs/statPrereq.swift |
| StatPrereqState | PrereqState | core/gameplay/prereqs/statPrereq.swift |
| StatPrereq | IScriptablePrereq | core/gameplay/prereqs/statPrereq.swift |
| StatusEffectPrereqListener | ScriptStatusEffectListener | core/gameplay/prereqs/statusEffectPrereq.swift |
| StatusEffectPrereqState | PrereqState | core/gameplay/prereqs/statusEffectPrereq.swift |
| StatusEffectPrereq | IScriptablePrereq | core/gameplay/prereqs/statusEffectPrereq.swift |
| StatusEffectRemovedPrereqState | StatusEffectPrereqState | core/gameplay/prereqs/statusEffectRemovedPrereq.swift |
| StatusEffectRemovedPrereq | StatusEffectPrereq | core/gameplay/prereqs/statusEffectRemovedPrereq.swift |
| TemporalPrereqDelayCallback | DelayCallback | core/gameplay/prereqs/temporalPrereq.swift |
| TemporalPrereqState | PrereqState | core/gameplay/prereqs/temporalPrereq.swift |
| TemporalPrereq | IScriptablePrereq | core/gameplay/prereqs/temporalPrereq.swift |
| PlayerVehicleStatePrereq | IScriptablePrereq | core/gameplay/prereqs/temporalPrereq.swift |
| DialogueChoiceHubPrereq | IScriptablePrereq | core/gameplay/prereqs/ui/DialogueChoiceHubPrereq.swift |

### Funcs (32)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| RegisterStatPoolListener |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| UnregisterStatPoolListener |  | core/gameplay/prereqs/consumableChargesPrereq.swift |
| UpdatePrereq |  | core/gameplay/prereqs/gameTimePrereq.swift |
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| StatPoolUpdate |  | core/gameplay/prereqs/perfectDischargePrereq.swift |
| RegisterStatPoolListener |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| UnregisterStatPoolListener |  | core/gameplay/prereqs/consumableChargesPrereq.swift |
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| StatPoolUpdate |  | core/gameplay/prereqs/perfectDischargePrereq.swift |
| RegisterStatPoolListener |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| UnregisterStatPoolListener |  | core/gameplay/prereqs/consumableChargesPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| StatPoolUpdate |  | core/gameplay/prereqs/perfectDischargePrereq.swift |
| RegisterStatPoolListener |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| UnregisterStatPoolListener |  | core/gameplay/prereqs/consumableChargesPrereq.swift |
| OnStatPoolValueChanged |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| RegisterState |  | core/gameplay/prereqs/constantStatPoolPrereq.swift |
| OnStatChanged |  | core/gameplay/prereqs/statPrereq.swift |
| StatUpdate |  | core/gameplay/prereqs/statPrereq.swift |
| OnStatusEffectApplied |  | core/gameplay/prereqs/statusEffectPrereq.swift |
| OnStatusEffectRemoved |  | core/gameplay/prereqs/statusEffectPrereq.swift |
| StatusEffectUpdate |  | core/gameplay/prereqs/statusEffectPrereq.swift |
| StatusEffectUpdate |  | core/gameplay/prereqs/statusEffectPrereq.swift |
| Call |  | core/gameplay/prereqs/temporalPrereq.swift |
| RegisterDealyCallback |  | core/gameplay/prereqs/temporalPrereq.swift |
| CallbackRecall |  | core/gameplay/prereqs/temporalPrereq.swift |

## Citations

- `core/gameplay/prereqs/alwaysTruePrereq.swift`
- `core/gameplay/prereqs/constantStatPoolPrereq.swift`
- `core/gameplay/prereqs/consumableChargesPrereq.swift`
- `core/gameplay/prereqs/districtPrereq.swift`
- `core/gameplay/prereqs/factValuePrereq.swift`
- `core/gameplay/prereqs/gameTimePrereq.swift`
- `core/gameplay/prereqs/itemCreationPrereq.swift`
- `core/gameplay/prereqs/onOffPrereq.swift`
- `core/gameplay/prereqs/perfectDischargePrereq.swift`
- `core/gameplay/prereqs/randomChancePrereq.swift`
- `core/gameplay/prereqs/setChancePrereq.swift`
- `core/gameplay/prereqs/statPoolChangeOverTimePrereq.swift`
- `core/gameplay/prereqs/statPoolPrereq.swift`
- `core/gameplay/prereqs/statPoolSpentPrereq.swift`
- `core/gameplay/prereqs/statPrereq.swift`
- `core/gameplay/prereqs/statusEffectPrereq.swift`
- `core/gameplay/prereqs/statusEffectRemovedPrereq.swift`
- `core/gameplay/prereqs/temporalPrereq.swift`
- `core/gameplay/prereqs/ui/DialogueChoiceHubPrereq.swift`
