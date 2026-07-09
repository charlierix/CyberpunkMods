---
type: StateMachine
title: "Defaulttransition / Consumabletransitions"
description: "7 types in DefaultTransition / ConsumableTransitions. Includes: ConsumableTransitions, ConsumableStartupDecisions, ConsumableStartupEvents."
tags: [default-transition, consumable-transitions, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Consumabletransitions

## Overview

This concept covers 7 types (7 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **ConsumableTransitions** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| ConsumableTransitions | DefaultTransition, StateFunctor, IScriptable | 0 | 9 | abstract | [143567.json](/api/cyberpunk-api/143567.json) |
| ConsumableStartupDecisions | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [143598.json](/api/cyberpunk-api/143598.json) |
| ConsumableStartupEvents | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [143602.json](/api/cyberpunk-api/143602.json) |
| ConsumableUseDecisions | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [143608.json](/api/cyberpunk-api/143608.json) |
| ConsumableUseEvents | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 3 | 2 | - | [143613.json](/api/cyberpunk-api/143613.json) |
| ConsumableCleanupDecisions | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143625.json](/api/cyberpunk-api/143625.json) |
| ConsumableCleanupEvents | ConsumableTransitions, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [143626.json](/api/cyberpunk-api/143626.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 7 source files
