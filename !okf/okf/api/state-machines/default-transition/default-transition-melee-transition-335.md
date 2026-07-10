---
type: StateMachine
title: "Defaulttransition / Meleetransition"
description: "16 types in DefaultTransition / MeleeTransition. Includes: MeleeTransition, MeleeNotReadyDecisions, MeleeParriedDecisions."
tags: [melee-transition, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Meleetransition

## Overview

This concept covers 16 types (16 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **MeleeTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| MeleeTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 83 | abstract | [89345.json](/api/cyberpunk-api/89345.json) |
| MeleeNotReadyDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147374.json](/api/cyberpunk-api/147374.json) |
| MeleeParriedDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [147388.json](/api/cyberpunk-api/147388.json) |
| MeleeRecoveryDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147405.json](/api/cyberpunk-api/147405.json) |
| MeleeIdleDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147421.json](/api/cyberpunk-api/147421.json) |
| MeleePublicSafeDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147434.json](/api/cyberpunk-api/147434.json) |
| MeleeSafeDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147450.json](/api/cyberpunk-api/147450.json) |
| MeleeHoldDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [147461.json](/api/cyberpunk-api/147461.json) |
| MeleeChargedHoldDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [147482.json](/api/cyberpunk-api/147482.json) |
| MeleeAttackGenericDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | abstract | [147509.json](/api/cyberpunk-api/147509.json) |
| MeleeDeflectDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 7 | - | [147688.json](/api/cyberpunk-api/147688.json) |
| MeleeBlockDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147742.json](/api/cyberpunk-api/147742.json) |
| MeleeTargetingDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [147759.json](/api/cyberpunk-api/147759.json) |
| MeleeLeapDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [147823.json](/api/cyberpunk-api/147823.json) |
| MeleeDashDecisions | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 4 | - | [147884.json](/api/cyberpunk-api/147884.json) |
| MeleeEventsTransition | MeleeTransition, DefaultTransition, StateFunctor (+1) | 0 | 5 | abstract | [89734.json](/api/cyberpunk-api/89734.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 16 source files
