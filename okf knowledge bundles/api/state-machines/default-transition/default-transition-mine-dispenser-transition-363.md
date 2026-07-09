---
type: StateMachine
title: "Defaulttransition / Minedispensertransition"
description: "5 types in DefaultTransition / MineDispenserTransition. Includes: MineDispenserTransition, MineDispenserEventsTransition, MineDispenserIdleDecisions."
tags: [default-transition, mine-dispenser-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Minedispensertransition

## Overview

This concept covers 5 types (5 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **MineDispenserTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| MineDispenserTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 0 | abstract | [89755.json](/api/cyberpunk-api/89755.json) |
| MineDispenserEventsTransition | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | abstract | [147998.json](/api/cyberpunk-api/147998.json) |
| MineDispenserIdleDecisions | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [148002.json](/api/cyberpunk-api/148002.json) |
| MineDispenserCycleItemDecisions | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [148014.json](/api/cyberpunk-api/148014.json) |
| MineDispenserPlaceDecisions | MineDispenserTransition, DefaultTransition, StateFunctor (+1) | 2 | 4 | - | [148022.json](/api/cyberpunk-api/148022.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 5 source files
