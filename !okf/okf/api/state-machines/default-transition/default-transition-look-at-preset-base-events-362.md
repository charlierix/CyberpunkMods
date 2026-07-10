---
type: StateMachine
title: "Defaulttransition / Lookatpresetbaseevents"
description: "5 types in DefaultTransition / LookAtPresetBaseEvents. Includes: LookAtPresetBaseEvents, lookAtPresetGunBaseEvents, LookAtPresetMeleeBaseEvents."
tags: [look-at-preset-base-events, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Lookatpresetbaseevents

## Overview

This concept covers 5 types (5 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **LookAtPresetBaseEvents** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| LookAtPresetBaseEvents | DefaultTransition, StateFunctor, IScriptable | 3 | 8 | abstract | [143709.json](/api/cyberpunk-api/143709.json) |
| lookAtPresetGunBaseEvents | LookAtPresetBaseEvents, DefaultTransition, StateFunctor (+1) | 4 | 7 | - | [143755.json](/api/cyberpunk-api/143755.json) |
| LookAtPresetMeleeBaseEvents | LookAtPresetBaseEvents, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143781.json](/api/cyberpunk-api/143781.json) |
| lookAtPresetItemBaseEvents | LookAtPresetBaseEvents, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143783.json](/api/cyberpunk-api/143783.json) |
| UnarmedLookAtEvents | LookAtPresetBaseEvents, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [143788.json](/api/cyberpunk-api/143788.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 5 source files
