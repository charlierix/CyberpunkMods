---
type: StateMachine
title: "Defaulttransition"
description: "60 types in DefaultTransition. Includes: BaseCrosshairState, BaseCrosshairStateEvents, SafeCrosshairStateDecisions."
tags: [default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition

## Overview

This concept covers 60 types (23 named, 37 unnamed) from the Cyberpunk 2077 API. 
These types descend from **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| unnamed_141450 | DefaultTransition, StateFunctor, IScriptable | 0 | 0 | abstract | [141450.json](/api/cyberpunk-api/141450.json) |
| unnamed_141451 | ComDeviceTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [141451.json](/api/cyberpunk-api/141451.json) |
| unnamed_141455 | ComDeviceTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [141455.json](/api/cyberpunk-api/141455.json) |
| unnamed_141462 | ComDeviceTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [141462.json](/api/cyberpunk-api/141462.json) |
| unnamed_141825 | DefaultTransition, StateFunctor, IScriptable | 0 | 1 | - | [141825.json](/api/cyberpunk-api/141825.json) |
| unnamed_141828 | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [141828.json](/api/cyberpunk-api/141828.json) |
| unnamed_141832 | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [141832.json](/api/cyberpunk-api/141832.json) |
| unnamed_141885 | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [141885.json](/api/cyberpunk-api/141885.json) |
| BaseCrosshairState | DefaultTransition, StateFunctor, IScriptable | 0 | 1 | - | [143831.json](/api/cyberpunk-api/143831.json) |
| BaseCrosshairStateEvents | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [143834.json](/api/cyberpunk-api/143834.json) |
| SafeCrosshairStateDecisions | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [143838.json](/api/cyberpunk-api/143838.json) |
| QuickHackCrosshairStateDecisions | BaseCrosshairState, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [143846.json](/api/cyberpunk-api/143846.json) |
| unnamed_144857 | DefaultTransition, StateFunctor, IScriptable | 0 | 14 | - | [144857.json](/api/cyberpunk-api/144857.json) |
| unnamed_144938 | TimeDilationTransitions, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [144938.json](/api/cyberpunk-api/144938.json) |
| unnamed_144961 | TimeDilationTransitions, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [144961.json](/api/cyberpunk-api/144961.json) |
| unnamed_145005 | TimeDilationTransitions, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [145005.json](/api/cyberpunk-api/145005.json) |
| unnamed_141473 | DefaultTransition, StateFunctor, IScriptable | 0 | 3 | - | [141473.json](/api/cyberpunk-api/141473.json) |
| unnamed_141484 | CombatTransitions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [141484.json](/api/cyberpunk-api/141484.json) |
| unnamed_141499 | CombatTransitions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [141499.json](/api/cyberpunk-api/141499.json) |
| unnamed_141998 | DefaultTransition, StateFunctor, IScriptable | 0 | 42 | abstract | [141998.json](/api/cyberpunk-api/141998.json) |
| unnamed_142825 | EquipmentBaseTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [142825.json](/api/cyberpunk-api/142825.json) |
| unnamed_142826 | EquipmentBaseTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [142826.json](/api/cyberpunk-api/142826.json) |
| EquipmentBaseTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 44 | abstract | [143873.json](/api/cyberpunk-api/143873.json) |
| EquipmentBaseDecisions | EquipmentBaseTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [144083.json](/api/cyberpunk-api/144083.json) |
| EquipmentBaseEvents | EquipmentBaseTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [144084.json](/api/cyberpunk-api/144084.json) |
| unnamed_144504 | DefaultTransition, StateFunctor, IScriptable | 0 | 2 | abstract | [144504.json](/api/cyberpunk-api/144504.json) |
| unnamed_144512 | ReactionTransition, DefaultTransition, StateFunctor (+1) | 1 | 2 | - | [144512.json](/api/cyberpunk-api/144512.json) |
| unnamed_144520 | ReactionTransition, DefaultTransition, StateFunctor (+1) | 1 | 3 | - | [144520.json](/api/cyberpunk-api/144520.json) |
| unnamed_144636 | DefaultTransition, StateFunctor, IScriptable | 1 | 7 | abstract | [144636.json](/api/cyberpunk-api/144636.json) |
| unnamed_144678 | StaminaTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [144678.json](/api/cyberpunk-api/144678.json) |
| unnamed_144684 | StaminaTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [144684.json](/api/cyberpunk-api/144684.json) |
| ReactionTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 2 | abstract | [148300.json](/api/cyberpunk-api/148300.json) |
| StaggerDecisions | ReactionTransition, DefaultTransition, StateFunctor (+1) | 1 | 2 | - | [148308.json](/api/cyberpunk-api/148308.json) |
| Stagger | ReactionTransition, DefaultTransition, StateFunctor (+1) | 1 | 3 | - | [148316.json](/api/cyberpunk-api/148316.json) |
| StaminaTransition | DefaultTransition, StateFunctor, IScriptable | 1 | 3 | abstract | [148439.json](/api/cyberpunk-api/148439.json) |
| StaminaEventsTransition | StaminaTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [148458.json](/api/cyberpunk-api/148458.json) |
| ExhaustedDecisions | StaminaTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [148463.json](/api/cyberpunk-api/148463.json) |
| unnamed_87019 | DefaultTransition, StateFunctor, IScriptable | 0 | 2 | abstract | [87019.json](/api/cyberpunk-api/87019.json) |
| unnamed_141079 | OldUpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [141079.json](/api/cyberpunk-api/141079.json) |
| unnamed_87030 | OldUpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | abstract | [87030.json](/api/cyberpunk-api/87030.json) |
| unnamed_87762 | DefaultTransition, StateFunctor, IScriptable | 0 | 0 | abstract | [87762.json](/api/cyberpunk-api/87762.json) |
| unnamed_144202 | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | abstract | [144202.json](/api/cyberpunk-api/144202.json) |
| unnamed_144226 | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 2 | 4 | - | [144226.json](/api/cyberpunk-api/144226.json) |
| unnamed_87765 | DefaultTransition, StateFunctor, IScriptable | 0 | 13 | abstract | [87765.json](/api/cyberpunk-api/87765.json) |
| unnamed_88153 | QuickSlotsTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [88153.json](/api/cyberpunk-api/88153.json) |
| unnamed_88155 | QuickSlotsTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [88155.json](/api/cyberpunk-api/88155.json) |
| OldUpperBodyTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 2 | abstract | [88365.json](/api/cyberpunk-api/88365.json) |
| CarriedObject | OldUpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [143080.json](/api/cyberpunk-api/143080.json) |
| OldUpperBodyEventsTransition | OldUpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | abstract | [88376.json](/api/cyberpunk-api/88376.json) |
| unnamed_88685 | DefaultTransition, StateFunctor, IScriptable | 0 | 26 | abstract | [88685.json](/api/cyberpunk-api/88685.json) |
| unnamed_146441 | ZoomTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [146441.json](/api/cyberpunk-api/146441.json) |
| unnamed_146455 | ZoomTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [146455.json](/api/cyberpunk-api/146455.json) |
| QuickSlotsTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 13 | abstract | [89758.json](/api/cyberpunk-api/89758.json) |
| QuickSlotsDecisions | QuickSlotsTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [90142.json](/api/cyberpunk-api/90142.json) |
| QuickSlotsEvents | QuickSlotsTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | abstract | [90160.json](/api/cyberpunk-api/90160.json) |
| ZoomTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 26 | abstract | [90633.json](/api/cyberpunk-api/90633.json) |
| ZoomDecisionsTransition | ZoomTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [150459.json](/api/cyberpunk-api/150459.json) |
| ZoomEventsTransition | ZoomTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [150473.json](/api/cyberpunk-api/150473.json) |
| MiddleFive | DefaultTransition, StateFunctor, IScriptable | 0 | 3 | - | [148541.json](/api/cyberpunk-api/148541.json) |
| unnamed_149116 | KnockdownDecisions, StatusEffectDecisions, LocomotionGroundDecisions (+4) | 0 | 3 | - | [149116.json](/api/cyberpunk-api/149116.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 60 source files
