---
type: StateMachine
title: "Defaulttransition / Vehicletransition"
description: "18 types in DefaultTransition / VehicleTransition. Includes: VehicleTransition, IdleDecisions, EnteringDecisions."
tags: [vehicle-transition, default-transition, state-machines]
timestamp: 2026-07-01T01:17:09.596774
---

# Defaulttransition / Vehicletransition

## Overview

This concept covers 18 types (18 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **VehicleTransition** subgroup under **DefaultTransition**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| VehicleTransition | DefaultTransition, StateFunctor, IScriptable | 1 | 65 | abstract | [89805.json](/api/cyberpunk-api/89805.json) |
| IdleDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [149279.json](/api/cyberpunk-api/149279.json) |
| EnteringDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [149289.json](/api/cyberpunk-api/149289.json) |
| PassengerDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [149313.json](/api/cyberpunk-api/149313.json) |
| GunnerDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149337.json](/api/cyberpunk-api/149337.json) |
| DriveDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [149357.json](/api/cyberpunk-api/149357.json) |
| SwitchSeatsDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [149383.json](/api/cyberpunk-api/149383.json) |
| EnteringCombatDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149424.json](/api/cyberpunk-api/149424.json) |
| ExitingCombatDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [149445.json](/api/cyberpunk-api/149445.json) |
| SceneExitingCombatDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [149457.json](/api/cyberpunk-api/149457.json) |
| CombatDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149472.json](/api/cyberpunk-api/149472.json) |
| DriverCombatDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 1 | - | [149492.json](/api/cyberpunk-api/149492.json) |
| ExitingDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149511.json](/api/cyberpunk-api/149511.json) |
| WaitingForSceneDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 3 | - | [149618.json](/api/cyberpunk-api/149618.json) |
| WaitingForSceneEvents | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 0 | - | [149628.json](/api/cyberpunk-api/149628.json) |
| SceneDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 6 | - | [149629.json](/api/cyberpunk-api/149629.json) |
| SceneExitingDecisions | VehicleTransition, DefaultTransition, StateFunctor (+1) | 0 | 2 | - | [149671.json](/api/cyberpunk-api/149671.json) |
| VehicleEventsTransition | VehicleTransition, DefaultTransition, StateFunctor (+1) | 2 | 5 | abstract | [90283.json](/api/cyberpunk-api/90283.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 18 source files
