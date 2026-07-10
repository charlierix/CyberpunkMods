---
type: "Import"
title: "State-Machines Types"
description: "Imported game engine types in the state-machines domain (52 types)."
resource: "codeware/scripts/"
tags: "[imports, state-machines]"
timestamp: 2026-07-01T18:09:32Z
---

# Overview

Imported game engine types in the state-machines domain (52 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gamestateMachineIStateActionDefinition | class | ISerializable | — |
| gamestateMachineIStateMachineBody | class | ISerializable | — |
| gamestateMachineState | class | graphGraphNodeDefinition | — |
| gamestateMachineStateActionDefinition | class | gamestateMachineIStateActionDefinition | — |
| gamestateMachineStateContext | struct | — | snapshot |
| gamestateMachineStateContextConsumableParameters | struct | — | boolParameters, floatParameters, vectorParameters, IScriptableParameters, tweakDBIDParameters |
| gamestateMachineStateContextParameters | struct | — | boolParameters, floatParameters, vectorParameters, IScriptableParameters |
| gamestateMachineStateDefinition | class | graphGraphNodeDefinition | — |
| gamestateMachineStateDefinitionSocketDefinition | class | graphGraphSocketDefinition | — |
| gamestateMachineStateMachine | class | graphGraphDefinition | — |
| gamestateMachineStateMachineBody | class | gamestateMachineIStateMachineBody | — |
| gamestateMachineStateMachineBodyLocomotionTier1 | class | gamestateMachineStateMachineBody | — |
| gamestateMachineStateMachineDefinition | class | graphGraphDefinition | — |
| gamestateMachineStateMachineListDefinition | class | IScriptable | stateMachinesStorage |
| gamestateMachineStateMachineResource | class | graphGraphResource | — |
| gamestateMachineStateSocketDefinition | class | graphGraphSocketDefinition | — |
| gamestateMachineTransition | class | graphGraphConnectionDefinition | transitionCondition |
| gamestateMachineTransitionDefinition | class | graphGraphConnectionDefinition | priority |
| gamestateMachineparameterTypeInteractionDescription | class | IScriptable | interactionEntity, interactionType |
| gamestateMachineplayeractionsActionCharge | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionChargeMax | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionChargeReady | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionCycleTriggerMode | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionDischarge | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionProjectileAttach | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsActionProjectileDetach | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsActionProjectileShowPreview | class | gamestateMachineplayeractionsActionCharge | — |
| gamestateMachineplayeractionsActionReady | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionReload | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionShoot | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsActionWindup | class | gamestateMachineplayeractionsWeaponActionBase | — |
| gamestateMachineplayeractionsClimb | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsEquipItem | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsHighLevelAiControlled | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsLocomotionAir | class | gamestateMachineplayeractionsLocomotionSimple | — |
| gamestateMachineplayeractionsLocomotionBase | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsLocomotionBraindance | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionForceFreeze | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionForceIdle | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionLadder | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionSimple | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionStart | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsLocomotionSwimmingDiving | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionSwimmingStart | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsLocomotionSwimmingSurface | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsLocomotionWallRun | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsUpperBodyBase | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsVault | class | gamestateMachineplayeractionsLocomotionBase | — |
| gamestateMachineplayeractionsVehicleDrive | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsVehicleExiting | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsWeaponActionBase | class | gamestateMachineStateActionDefinition | — |
| gamestateMachineplayeractionsWeaponStart | class | gamestateMachineplayeractionsWeaponActionBase | — |

# Citations

- `codeware/scripts/Base/Imports/gamestateMachineIStateActionDefinition.reds`
- `codeware/scripts/Base/Imports/gamestateMachineIStateMachineBody.reds`
- `codeware/scripts/Base/Imports/gamestateMachineState.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateActionDefinition.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateContext.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateContextConsumableParameters.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateContextParameters.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateDefinition.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateDefinitionSocketDefinition.reds`
- `codeware/scripts/Base/Imports/gamestateMachineStateMachine.reds`
- ... and 42 more source files
