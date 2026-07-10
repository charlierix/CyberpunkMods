---
type: "Class System"
title: "PSM Prerequisites"
description: "Player state machine prerequisites for body carrying, combat, fall, focus mode, locomotion, melee, ranged, swimming, takedown, time dilation, upper body, cover, vehicle, and zones."
resource: "!core/gameplay/prereqs/psm/basePSMPrereq.swift"
tags: ['core', 'gameplay', 'prereqs', 'psm']
timestamp: 2026-07-01T13:00:55Z
---

# PSM Prerequisites

Player state machine prerequisites for body carrying, combat, fall, focus mode, locomotion, melee, ranged, swimming, takedown, time dilation, upper body, cover, vehicle, and zones.

## Source Files

- `core/gameplay/prereqs/psm/basePSMPrereq.swift`
- `core/gameplay/prereqs/psm/bodyCarryingPSMPrereq.swift`
- `core/gameplay/prereqs/psm/bodyDisposalPSMPrereq.swift`
- `core/gameplay/prereqs/psm/combatPSMPrereq.swift`
- `core/gameplay/prereqs/psm/detailedLocomotionPSMPrereq.swift`
- `core/gameplay/prereqs/psm/fallPSMPrereq.swift`
- `core/gameplay/prereqs/psm/highLevelPSMPrereq.swift`
- `core/gameplay/prereqs/psm/isInFocusModePSMPrereq.swift`
- `core/gameplay/prereqs/psm/isInWorkspotPSMPrereq.swift`
- `core/gameplay/prereqs/psm/locomotionPSMPrereq.swift`
- `core/gameplay/prereqs/psm/meleePSMPrereq.swift`
- `core/gameplay/prereqs/psm/meleeWeaponPSMPrereq.swift`
- `core/gameplay/prereqs/psm/rangedWeaponPSMPrereq.swift`
- `core/gameplay/prereqs/psm/swimmingPSMPrereq.swift`
- `core/gameplay/prereqs/psm/takedownPSMPrereq.swift`
- `core/gameplay/prereqs/psm/timeDilationPSMPrereq.swift`
- `core/gameplay/prereqs/psm/upperBodyPSMPrereq.swift`
- `core/gameplay/prereqs/psm/usingCoverPSMPrereq.swift`
- `core/gameplay/prereqs/psm/vehiclePSMPrereq.swift`
- `core/gameplay/prereqs/psm/zonesPSMPrereq.swift`

## Member Types

**Total declarations: 23**

### Classs (23)

| Name | Bases | Source File |
|------|-------|-------------|
| PlayerStateMachinePrereqState | PrereqState | core/gameplay/prereqs/psm/basePSMPrereq.swift |
| PlayerStateMachinePrereq | IScriptablePrereq | core/gameplay/prereqs/psm/basePSMPrereq.swift |
| BodyCarryingPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/bodyCarryingPSMPrereq.swift |
| BodyDisposalPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/bodyDisposalPSMPrereq.swift |
| CombatPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/combatPSMPrereq.swift |
| DetailedLocomotionPSMPrereqState | PlayerStateMachinePrereqState | core/gameplay/prereqs/psm/detailedLocomotionPSMPrereq.swift |
| DetailedLocomotionPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/detailedLocomotionPSMPrereq.swift |
| FallPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/fallPSMPrereq.swift |
| HighLevelPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/highLevelPSMPrereq.swift |
| IsInFocusModePSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/isInFocusModePSMPrereq.swift |
| IsInWorkspotPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/isInWorkspotPSMPrereq.swift |
| LocomotionPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/locomotionPSMPrereq.swift |
| MeleePSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/meleePSMPrereq.swift |
| MeleeWeaponPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/meleeWeaponPSMPrereq.swift |
| RangedWeaponPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/rangedWeaponPSMPrereq.swift |
| SwimmingPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/swimmingPSMPrereq.swift |
| TakedownPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/takedownPSMPrereq.swift |
| TimeDilationPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/timeDilationPSMPrereq.swift |
| UpperBodyPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/upperBodyPSMPrereq.swift |
| UsingCoverPSMPrereqState | PlayerStateMachinePrereqState | core/gameplay/prereqs/psm/usingCoverPSMPrereq.swift |
| UsingCoverPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/usingCoverPSMPrereq.swift |
| VehiclePSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/vehiclePSMPrereq.swift |
| ZonesPSMPrereq | PlayerStateMachinePrereq | core/gameplay/prereqs/psm/zonesPSMPrereq.swift |

## Citations

- `core/gameplay/prereqs/psm/basePSMPrereq.swift`
- `core/gameplay/prereqs/psm/bodyCarryingPSMPrereq.swift`
- `core/gameplay/prereqs/psm/bodyDisposalPSMPrereq.swift`
- `core/gameplay/prereqs/psm/combatPSMPrereq.swift`
- `core/gameplay/prereqs/psm/detailedLocomotionPSMPrereq.swift`
- `core/gameplay/prereqs/psm/fallPSMPrereq.swift`
- `core/gameplay/prereqs/psm/highLevelPSMPrereq.swift`
- `core/gameplay/prereqs/psm/isInFocusModePSMPrereq.swift`
- `core/gameplay/prereqs/psm/isInWorkspotPSMPrereq.swift`
- `core/gameplay/prereqs/psm/locomotionPSMPrereq.swift`
- `core/gameplay/prereqs/psm/meleePSMPrereq.swift`
- `core/gameplay/prereqs/psm/meleeWeaponPSMPrereq.swift`
- `core/gameplay/prereqs/psm/rangedWeaponPSMPrereq.swift`
- `core/gameplay/prereqs/psm/swimmingPSMPrereq.swift`
- `core/gameplay/prereqs/psm/takedownPSMPrereq.swift`
- `core/gameplay/prereqs/psm/timeDilationPSMPrereq.swift`
- `core/gameplay/prereqs/psm/upperBodyPSMPrereq.swift`
- `core/gameplay/prereqs/psm/usingCoverPSMPrereq.swift`
- `core/gameplay/prereqs/psm/vehiclePSMPrereq.swift`
- `core/gameplay/prereqs/psm/zonesPSMPrereq.swift`
