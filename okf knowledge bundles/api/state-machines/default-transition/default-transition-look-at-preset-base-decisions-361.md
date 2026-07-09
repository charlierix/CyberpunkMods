---
type: StateMachine
title: "Defaulttransition / Lookatpresetbasedecisions"
description: "5 types in DefaultTransition / LookAtPresetBaseDecisions. Includes: LookAtPresetBaseDecisions, lookAtPresetGunBaseDecisions, LookAtPresetMeleeBaseDecisions."
tags: [look-at-preset-base-decisions, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Lookatpresetbasedecisions

## Overview

This concept covers 5 types (5 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **LookAtPresetBaseDecisions** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| LookAtPresetBaseDecisions | DefaultTransition, StateFunctor, IScriptable | 0 | 3 | abstract | [143696.json](/api/cyberpunk-api/143696.json) |
| lookAtPresetGunBaseDecisions | LookAtPresetBaseDecisions, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143754.json](/api/cyberpunk-api/143754.json) |
| LookAtPresetMeleeBaseDecisions | LookAtPresetBaseDecisions, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143780.json](/api/cyberpunk-api/143780.json) |
| lookAtPresetItemBaseDecisions | LookAtPresetBaseDecisions, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143782.json](/api/cyberpunk-api/143782.json) |
| UnarmedLookAtDecisions | LookAtPresetBaseDecisions, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [143784.json](/api/cyberpunk-api/143784.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 5 source files
