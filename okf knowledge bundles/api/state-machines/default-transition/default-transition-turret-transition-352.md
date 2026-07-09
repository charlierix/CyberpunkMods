---
type: StateMachine
title: "Defaulttransition / Turrettransition"
description: "7 types in DefaultTransition / TurretTransition. Includes: TurretTransition, TurretBeginEvents, TurretBeginDecisions."
tags: [turret-transition, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Turrettransition

## Overview

This concept covers 7 types (7 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **TurretTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| TurretTransition | DefaultTransition, StateFunctor, IScriptable | 0 | 2 | abstract | [148865.json](/api/cyberpunk-api/148865.json) |
| TurretBeginEvents | TurretTransition, DefaultTransition, StateFunctor (+1) | 1 | 1 | - | [148879.json](/api/cyberpunk-api/148879.json) |
| TurretBeginDecisions | TurretTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [148886.json](/api/cyberpunk-api/148886.json) |
| TurretRipOffEvents | TurretTransition, DefaultTransition, StateFunctor (+1) | 1 | 1 | - | [148890.json](/api/cyberpunk-api/148890.json) |
| TurretRipOffDecisions | TurretTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [148896.json](/api/cyberpunk-api/148896.json) |
| TurretEndEvents | TurretTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [148897.json](/api/cyberpunk-api/148897.json) |
| TurretEndDecisions | TurretTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [148903.json](/api/cyberpunk-api/148903.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 7 source files
