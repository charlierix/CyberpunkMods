---
type: StateMachine
title: "Defaulttransition / Upperbodytransition"
description: "9 types in DefaultTransition / UpperBodyTransition. Includes: UpperBodyTransition, ForceEmptyHandsDecisions, ForceSafeDecisions."
tags: [upper-body-transition, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Upperbodytransition

## Overview

This concept covers 9 types (9 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **UpperBodyTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| UpperBodyTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 15 | abstract | [90180.json](/api/cyberpunk-api/90180.json) |
| ForceEmptyHandsDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 1 | 4 | - | [148904.json](/api/cyberpunk-api/148904.json) |
| ForceSafeDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [148932.json](/api/cyberpunk-api/148932.json) |
| EmptyHandsDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 1 | 3 | - | [148952.json](/api/cyberpunk-api/148952.json) |
| SingleWieldDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [148975.json](/api/cyberpunk-api/148975.json) |
| AimingStateDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 25 | 26 | - | [149006.json](/api/cyberpunk-api/149006.json) |
| TemporaryUnequipDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 5 | - | [149206.json](/api/cyberpunk-api/149206.json) |
| WaitForEquipDecisions | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149243.json](/api/cyberpunk-api/149243.json) |
| UpperBodyEventsTransition | UpperBodyTransition, DefaultTransition, StateFunctor (+1) | 6 | 6 | abstract | [90245.json](/api/cyberpunk-api/90245.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 9 source files
