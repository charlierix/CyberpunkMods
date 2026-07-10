---
type: StateMachine
title: "Defaulttransition / Weapontransition"
description: "19 types in DefaultTransition / WeaponTransition. Includes: WeaponTransition, SafeDecisions, PublicSafeToReadyDecisions."
tags: [weapon-transition, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Weapontransition

## Overview

This concept covers 19 types (19 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **WeaponTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| WeaponTransition | DefaultTransition, StateFunctor, IScriptable | 3 | 43 | abstract | [90348.json](/api/cyberpunk-api/90348.json) |
| SafeDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149731.json](/api/cyberpunk-api/149731.json) |
| PublicSafeToReadyDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [149821.json](/api/cyberpunk-api/149821.json) |
| QuickMeleeDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 9 | - | [149832.json](/api/cyberpunk-api/149832.json) |
| NoAmmoDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 1 | 8 | - | [149950.json](/api/cyberpunk-api/149950.json) |
| ReloadDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 8 | - | [149994.json](/api/cyberpunk-api/149994.json) |
| ShootDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 1 | 1 | - | [150083.json](/api/cyberpunk-api/150083.json) |
| CycleRoundDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [150104.json](/api/cyberpunk-api/150104.json) |
| CycleTriggerModeDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [150131.json](/api/cyberpunk-api/150131.json) |
| SemiAutoDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 1 | 7 | - | [150160.json](/api/cyberpunk-api/150160.json) |
| FullAutoDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 1 | 8 | - | [150194.json](/api/cyberpunk-api/150194.json) |
| BurstDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [150252.json](/api/cyberpunk-api/150252.json) |
| ChargeDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 3 | 10 | - | [150290.json](/api/cyberpunk-api/150290.json) |
| ChargeReadyDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [150360.json](/api/cyberpunk-api/150360.json) |
| ChargeMaxDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [150384.json](/api/cyberpunk-api/150384.json) |
| DischargeDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [150399.json](/api/cyberpunk-api/150399.json) |
| OverheatDecisions | WeaponTransition, DefaultTransition, StateFunctor (+1) | 1 | 5 | - | [150432.json](/api/cyberpunk-api/150432.json) |
| WeaponReadyListenerTransition | WeaponTransition, DefaultTransition, StateFunctor (+1) | 21 | 16 | - | [90530.json](/api/cyberpunk-api/90530.json) |
| WeaponEventsTransition | WeaponTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | abstract | [90606.json](/api/cyberpunk-api/90606.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 19 source files
