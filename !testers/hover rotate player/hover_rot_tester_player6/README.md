# Hover Rot Tester Player 6 — PSM State Machine Manipulation

## Goal

Test whether manipulating the Player State Machine (PSM) blackboard can put the player into a state that **doesn't enforce roll=0, pitch=0** — allowing `TeleportationFacility:Teleport()` to set full 3-axis rotation.

This is **Steps 3 & 7** from `hover_rot_tester_player3/next steps.md`, which were never tested by testers 1–5:
- Step 3: Access `gamestateMachineComponent` via `FindComponentByType`
- Step 7: `GetPlayerStateMachineBlackboard` for PSM state manipulation

## Hypothesis

Testers 1–5 proved that the locomotion state machine clamps roll/pitch to 0 every frame, overriding both `SetWorldTransform` and `Teleport` orientation. However, **different PSM states may have different orientation enforcement rules**:

- **Dead** bodies lie down (no upright enforcement)
- **Swimming** has different physics (buoyancy, not gravity-locked)
- **Scene** states (cutscenes) may use scripted transforms
- **Felled/Knockdown** states involve falling/ragdoll-like behavior
- **Workspot** states take over the player's transform entirely
- **Mounted** states use vehicle orientation (which supports full rotation)
- **AirHover** is a built-in hover state that may not enforce upright

## PSM Blackboard API

Discovered from adamsmasher decompiled sources:

```lua
-- Get PSM blackboard
local psmBB = player:GetPlayerStateMachineBlackboard()
-- or fallback:
local psmBB = GameInstance.GetBlackboardSystem(player:GetGame())
    :GetLocalInstanced(player:GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine)

-- Get blackboard definition (variable IDs)
local psmDef = GetAllBlackboardDefs().PlayerStateMachine

-- Read state
psmBB:GetInt(psmDef.Locomotion)          -- gamePSMLocomotionStates enum
psmBB:GetInt(psmDef.LocomotionDetailed)  -- gamePSMDetailedLocomotionStates enum
psmBB:GetInt(psmDef.HighLevel)           -- gamePSMHighLevel enum
psmBB:GetInt(psmDef.Vitals)              -- gamePSMVitals enum
psmBB:GetBool(psmDef.Felled)             -- boolean
psmBB:GetBool(psmDef.MountedToVehicle)   -- boolean

-- Write state
psmBB:SetInt(psmDef.Vitals, 1)           -- set to Dead
psmBB:SetBool(psmDef.Felled, true)       -- set Felled flag
```

## State Modes (cycle with hotkey)

| # | Mode | Variables Written | Rationale |
|---|------|-------------------|----------|
| 1 | NONE | (none) | Control — same as tester 4 |
| 2 | DEAD | `Vitals=1` | Dead bodies don't enforce upright |
| 3 | SWIMMING | `HighLevel=6`, `Swimming=1` | Swimming has different physics |
| 4 | SCENE | `HighLevel=1`, `SceneTier=1` | Cutscene/scene state |
| 5 | FELLED | `Felled=true`, `LocomotionDetailed=31` | Felled = knocked down |
| 6 | KNOCKDOWN | `LocomotionDetailed=29` | Knockdown state |
| 7 | WORKSPOT | `Locomotion=8`, `IsInWorkspot=1` | Workspot takes over transform |
| 8 | MOUNTED | `MountedToVehicle=true`, `Vehicle=1` | Mounted = vehicle orientation |
| 9 | AIR_HOVER | `LocomotionDetailed=16`, `Locomotion=4` | Built-in hover state |

## Rotation Methods

Toggle between:
- **Teleport** — `TeleportationFacility:Teleport(player, pos, EulerAngles)` (known to set yaw)
- **SetWorldTransform** — `player:SetWorldTransform(WorldTransform)` (known no-op, but may work with PSM changes)

## Testing Procedure

1. Install to `bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player6`
2. Bind hotkeys in Settings > Key Bindings > HoverRotTesterPlayer6
3. Press **Toggle Hover** to activate (teleports player airborne, locks camera, probes SM component)
4. Press **Dump PSM State** to see all PSM blackboard values at startup
5. Press **Probe SM Component** to see gamestateMachineComponent info
6. Start in **NONE** mode, press **Pitch +30** — confirm roll/pitch clamped (control)
7. Press **Cycle State Mode** to switch to **DEAD**
8. Press **Pitch +30** again — check if pitch sticks this time
9. Repeat for each state mode
10. Also try toggling rotation method (Teleport vs SetWorldTransform) per mode
11. Press **Toggle Hover** to deactivate (restores PSM values + camera)

## What to Look For in Logs

Key diagnostic lines:
```
[HoverRotTesterPlayer6] DIAG MATCH: roll=TRUE pitch=TRUE yaw=TRUE
```
If **roll=TRUE pitch=TRUE** appears in any mode, that mode bypasses the locomotion clamp!

Also check:
```
[HoverRotTesterPlayer6] DIAG PSM: LocDetailed=31 HighLevel=0 Vitals=1 Felled=true
```
This shows whether our PSM writes actually stuck or got overwritten by the state machine.

## Hotkeys

| Hotkey | Label | Action |
|--------|-------|--------|
| 1 | Toggle Hover (Player6) | Enable/disable tester |
| 2 | Cycle State Mode (Player6) | Cycle through 9 PSM state modes |
| 3 | Toggle Rotation Method (P6) | Switch Teleport ↔ SetWorldTransform |
| 4 | Dump PSM State (Player6) | Print all PSM blackboard values |
| 5 | Probe SM Component (Player6) | Dump gamestateMachineComponent info |
| 6–7 | Yaw ±30 (Player6) | Rotate yaw |
| 8–9 | Pitch ±30 (Player6) | Rotate pitch |
| 10–11 | Roll ±30 (Player6) | Rotate roll |

## Key Research Sources

- `PlayerStateMachineDef` — 80+ writable blackboard variables (from `blackboardDefinitions.swift`)
- `gamePSMLocomotionStates` enum — 13 states (Default through CrouchDodge)
- `gamePSMDetailedLocomotionStates` enum — 32 states (includes AirHover, Knockdown, Felled)
- `gamePSMHighLevel` enum — 7 states (Default, SceneTier1-5, Swimming)
- `gamePSMVitals` enum — 3 states (Alive, Dead, Resurrecting)
- `gamestateMachineComponent` — 12 native methods (AddStateMachine, GetSnapshotContainer, etc.)
- PSM write pattern from `vehicleComponent.swift`: `psmBB:SetBool(psmDef.MountedToVehicle, true)`
