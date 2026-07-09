---
type: Reference
title: "Iscriptable /  Merged 0"
description: "50 types in IScriptable / _merged-0. Includes: SmartHousePreset, MorningPreset, EveningPreset."
tags: [iscriptable, references, merged-0]
timestamp: 2026-07-01T01:17:09.596774
---

# Iscriptable /  Merged 0

## Overview

This concept covers 50 types (24 named, 26 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **_merged-0** subgroup under **IScriptable**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| unnamed_138083 | IScriptable | 1 | 9 | abstract | [138083.json](/api/cyberpunk-api/138083.json) |
| unnamed_138222 | SmartHousePreset, IScriptable | 0 | 7 | - | [138222.json](/api/cyberpunk-api/138222.json) |
| unnamed_138348 | SmartHousePreset, IScriptable | 0 | 6 | - | [138348.json](/api/cyberpunk-api/138348.json) |
| unnamed_138360 | SmartHousePreset, IScriptable | 0 | 7 | - | [138360.json](/api/cyberpunk-api/138360.json) |
| SmartHousePreset | IScriptable | 1 | 9 | abstract | [139996.json](/api/cyberpunk-api/139996.json) |
| MorningPreset | SmartHousePreset, IScriptable | 0 | 7 | - | [140131.json](/api/cyberpunk-api/140131.json) |
| EveningPreset | SmartHousePreset, IScriptable | 0 | 6 | - | [140144.json](/api/cyberpunk-api/140144.json) |
| NightPreset | SmartHousePreset, IScriptable | 0 | 7 | - | [140156.json](/api/cyberpunk-api/140156.json) |
| IPrereq | IScriptable | 0 | 3 | abstract, native | [15052.json](/api/cyberpunk-api/15052.json) |
| IComparisonPrereq | IPrereq, IScriptable | 0 | 0 | abstract, native | [100789.json](/api/cyberpunk-api/100789.json) |
| WasScannedPrereq | IPrereq, IScriptable | 0 | 0 | native | [100790.json](/api/cyberpunk-api/100790.json) |
| IScriptablePrereq | IPrereq, IScriptable | 0 | 5 | native | [27339.json](/api/cyberpunk-api/27339.json) |
| unnamed_15548 | IScriptable | 2 | 0 | abstract, native | [15548.json](/api/cyberpunk-api/15548.json) |
| unnamed_15556 | gameStatModifierData, IScriptable | 1 | 0 | native | [15556.json](/api/cyberpunk-api/15556.json) |
| unnamed_47692 | gameStatModifierData, IScriptable | 3 | 0 | native | [47692.json](/api/cyberpunk-api/47692.json) |
| unnamed_60878 | gameStatModifierData, IScriptable | 4 | 0 | native | [60878.json](/api/cyberpunk-api/60878.json) |
| gameStatModifierData | IScriptable | 2 | 0 | abstract, native | [16381.json](/api/cyberpunk-api/16381.json) |
| gameConstantStatModifierData | gameStatModifierData, IScriptable | 1 | 0 | native | [17399.json](/api/cyberpunk-api/17399.json) |
| gameCurveStatModifierData | gameStatModifierData, IScriptable | 3 | 0 | native | [22566.json](/api/cyberpunk-api/22566.json) |
| gameCombinedStatModifierData | gameStatModifierData, IScriptable | 4 | 0 | native | [68381.json](/api/cyberpunk-api/68381.json) |
| unnamed_16615 | IScriptable | 13 | 28 | native | [16615.json](/api/cyberpunk-api/16615.json) |
| unnamed_101384 | HUDActor, IScriptable | 0 | 0 | - | [101384.json](/api/cyberpunk-api/101384.json) |
| unnamed_101385 | HUDActor, IScriptable | 0 | 0 | - | [101385.json](/api/cyberpunk-api/101385.json) |
| unnamed_101386 | HUDActor, IScriptable | 0 | 0 | - | [101386.json](/api/cyberpunk-api/101386.json) |
| MappinScriptData | IScriptable | 1 | 0 | native | [20912.json](/api/cyberpunk-api/20912.json) |
| GrenadeMappinData | MappinScriptData, IScriptable | 2 | 0 | - | [45354.json](/api/cyberpunk-api/45354.json) |
| GameplayRoleMappinData | MappinScriptData, IScriptable | 18 | 0 | - | [59956.json](/api/cyberpunk-api/59956.json) |
| TestMappinScriptData | MappinScriptData, IScriptable | 1 | 0 | - | [96081.json](/api/cyberpunk-api/96081.json) |
| unnamed_22658 | IScriptable | 0 | 7 | native | [22658.json](/api/cyberpunk-api/22658.json) |
| unnamed_128146 | AIRole, IScriptable | 5 | 8 | native | [128146.json](/api/cyberpunk-api/128146.json) |
| unnamed_29212 | AIRole, IScriptable | 11 | 18 | - | [29212.json](/api/cyberpunk-api/29212.json) |
| unnamed_90355 | AIRole, IScriptable | 0 | 0 | - | [90355.json](/api/cyberpunk-api/90355.json) |
| unnamed_23195 | IScriptable | 10 | 16 | abstract | [23195.json](/api/cyberpunk-api/23195.json) |
| unnamed_23343 | SkillCheckBase, IScriptable | 0 | 0 | - | [23343.json](/api/cyberpunk-api/23343.json) |
| unnamed_23344 | SkillCheckBase, IScriptable | 0 | 0 | - | [23344.json](/api/cyberpunk-api/23344.json) |
| unnamed_23356 | SkillCheckBase, IScriptable | 0 | 0 | - | [23356.json](/api/cyberpunk-api/23356.json) |
| AIRole | IScriptable | 0 | 7 | native | [24391.json](/api/cyberpunk-api/24391.json) |
| AIPatrolRole | AIRole, IScriptable | 5 | 8 | native | [129755.json](/api/cyberpunk-api/129755.json) |
| AIFollowerRole | AIRole, IScriptable | 11 | 18 | - | [40991.json](/api/cyberpunk-api/40991.json) |
| AINoRole | AIRole, IScriptable | 0 | 0 | - | [94251.json](/api/cyberpunk-api/94251.json) |
| SkillCheckBase | IScriptable | 10 | 16 | abstract | [24783.json](/api/cyberpunk-api/24783.json) |
| DemolitionSkillCheck | SkillCheckBase, IScriptable | 0 | 0 | - | [24925.json](/api/cyberpunk-api/24925.json) |
| EngineeringSkillCheck | SkillCheckBase, IScriptable | 0 | 0 | - | [24926.json](/api/cyberpunk-api/24926.json) |
| HackingSkillCheck | SkillCheckBase, IScriptable | 0 | 0 | - | [24938.json](/api/cyberpunk-api/24938.json) |
| unnamed_26778 | IScriptable | 13 | 0 | native | [26778.json](/api/cyberpunk-api/26778.json) |
| unnamed_101724 | StimuliData, IScriptable | 0 | 0 | final, native | [101724.json](/api/cyberpunk-api/101724.json) |
| unnamed_86536 | StimuliData, IScriptable | 0 | 4 | native | [86536.json](/api/cyberpunk-api/86536.json) |
| unnamed_94696 | StimuliData, IScriptable | 0 | 0 | - | [94696.json](/api/cyberpunk-api/94696.json) |
| unnamed_30926 | IScriptable | 0 | 1 | native | [30926.json](/api/cyberpunk-api/30926.json) |
| unnamed_119657 | DelayCallback, IScriptable | 1 | 1 | - | [119657.json](/api/cyberpunk-api/119657.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 50 source files
