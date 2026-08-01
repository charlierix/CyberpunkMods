# Log Summary — Tester Player 6 (Attempt 1)

## Overview

Tested all 9 PSM state modes with both Teleport and SetWorldTransform rotation methods. The initial teleport-to-height bug (teleporting to original z instead of target z) was present during this run, keeping the player at ground level with continuous re-teleporting.

## Sessions

### Session 1 — Teleport Method (12:05–12:07)

All 9 state modes cycled. Rotation hotkeys pressed in SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER, and NONE.

### Session 2 — SetWorldTransform Method (12:07–12:10)

Re-activated, all 9 state modes cycled again with SetWorldTransform method.

## Critical Finding: Missing Diagnostics

**The DIAG BEFORE/AFTER/MATCH lines never printed.** The re-teleport bug caused an early `return` in `onUpdate` before reaching the diagnostic section. This means:

- The `Rot ->` lines in the log show **target quaternion values** (accumulated from hotkey presses), NOT the player's actual orientation
- We never confirmed whether rotations actually stuck on the player entity
- The user's visual observation ("pitch/roll never happened, only yaw") is the only evidence, but it was without diagnostic confirmation and with the player stuck at ground level

## Per-Mode Analysis (Target Quaternion Values)

| Mode | Teleport: roll/pitch non-zero? | SWT: roll/pitch non-zero? | Notes |
|------|-------------------------------|--------------------------|-------|
| NONE | ❌ (roll=0, pitch=0 only) | ✅ (roll/pitch accumulate) | Teleport NONE = same as tester 4 (yaw only). SWT NONE shows accumulation but unknown if it sticks |
| DEAD | (not tested w/ rotations, Teleport) | ✅ | Roll values 20–86°, pitch -11 to 32° in target |
| SWIMMING | (not tested w/ rotations, Teleport) | ✅ | Roll 40–107°, pitch 12–56° in target |
| SCENE | ✅ (partial: 0→30→60→0) | ✅ | Roll 69–129°, pitch -3 to 27° in target. Pitch seems to partially work then reset |
| FELLED | ✅ (roll -60→0, pitch 60 stays) | ✅ | Roll 8–173°, pitch -65 to 56° in target. Most diverse rotation values |
| KNOCKDOWN | ✅ (roll 0→180→-180, pitch 0→90) | ✅ | Roll -99 to 115°, pitch -58 to 82° in target. Roll reaches ±180° |
| WORKSPOT | ✅ (roll 30–164°, pitch -61 to 14°) | ✅ | Roll -155 to 71°, pitch -31 to 73° in target |
| MOUNTED | ✅ (roll -13 to -147°, pitch -75 to -14°) | ✅ | Roll -131 to 174°, pitch -11 to 79° in target |
| AIR_HOVER | ✅ (roll -42 to -137°, pitch -75 to -27°) | ✅ | Roll -173 to 148°, pitch -75 to 20° in target |

**Note:** These are target values only. Without DIAG output, we cannot confirm actual player orientation matched the target.

## What Worked

| Aspect | Result |
|--------|--------|
| PSM blackboard access | ✅ `GetPlayerStateMachineBlackboard()` succeeded every time |
| PSM blackboard definitions | ✅ `GetAllBlackboardDefs().PlayerStateMachine` succeeded |
| PSM value save/restore | ✅ Values saved and restored on deactivate |
| `gamestateMachineComponent` access | ✅ `FindComponentByType` succeeded, `GetSnapshotContainer()` returned valid userdata |
| Quaternion accumulation | ✅ All 3 axes accumulate correctly in target quaternion |
| Teleport (yaw only) | ✅ Consistent with tester 4 — yaw works, roll/pitch clamped |

## What Didn't Work

| Aspect | Result |
|--------|--------|
| `IsStateMachinePresent()` | ❌ Returns `false` for all named state machines (Locomotion, UpperBody, HighLevel, Combat, Vehicle). The StateMachineIdentifier may need different construction. |
| Diagnostic output (DIAG lines) | ❌ Never printed due to re-teleport bug causing early return |
| Initial teleport to height | ❌ Player stayed at z=46.5 instead of z=96.5 (bug: teleported to `pos` instead of `state.targetZ`) |
| Visual rotation confirmation | ❌ User observed only yaw visually, but without DIAG data or airborne state, this is inconclusive |

## Combinations Tested

| # | Method | Modes Tested | Rotation Axes Pressed |
|---|--------|-------------|---------------------|
| 1 | Teleport | NONE, SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER | Yaw, Pitch, Roll |
| 2 | SetWorldTransform | ALL 9 modes | Yaw, Pitch, Roll |
| 3 | Teleport (session 2) | DEAD, SWIMMING, SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER, NONE | Yaw, Pitch, Roll |

## Combinations Missed

1. **Airborne + fixed code** — The initial teleport bug meant the player was never airborne. All tests happened at ground level with continuous re-teleporting. The fixed code (teleport to `state.targetZ`) should be re-tested.
2. **Diagnostic output** — DIAG BEFORE/AFTER/MATCH lines never printed. With the re-teleport bug fixed, these will show whether rotations actually stick, frame by frame.
3. **NONE mode + SetWorldTransform** was tested in session 2 but with the player at ground level (not airborne).
4. **DEAD + SWIMMING** modes were cycled in session 1 but rotations weren't pressed (user just cycled through quickly).

## What Else Could Be Tried

### Still Untested CET Approaches (from player3 next steps)

| Step | Approach | Status |
|------|----------|--------|
| Step 4 | `moveComponent` / `entColliderComponent` access — probe for orientation setters | ❌ Never tested |
| Step 5 | `entAnimationControllerComponent` probe — animation-driven rotation | ❌ Never tested |
| Step 8 | Workspot/pose-based rotation — attach to mobile, rotatable point | ❌ Never tested (the PSM WORKSPOT mode only writes blackboard vars, doesn't use actual workspot system) |

### Additional PSM Combinations

- **Multiple states simultaneously** — e.g., Dead + Felled + Knockdown at the same time
- **Additional PSM variables** — `PlayerStateMachineDef` has 80+ writable variables; only ~8 were tested
- **PSMAddOnDemandStateMachine** — used by `vehicleComponent.swift` to add on-demand state machines; could potentially add a custom state machine that doesn't enforce orientation

### Non-PSM Approaches (from analysis doc)

| Approach | Description | CET-Viable? |
|----------|-------------|-------------|
| **D: Vehicle Mount Hybrid** | Spawn invisible vehicle, mount player via `gamePuppetMountableComponent`, rotate vehicle (vehicles support full rotation) | Likely yes — uses existing working APIs |
| **E: Custom Workspot** | Enter actual workspot (not just PSM blackboard), update anchor transform dynamically | Unknown — workspots expect animations |

### C++ Level (Next Step Per Analysis Doc)

All CET-level transform/teleport APIs have now been exhausted. The locomotion system's `roll=0, pitch=0` enforcement happens at a level deeper than CET can reach. The analysis doc recommends:

- **Approach A: Locomotion Hook** — Hook the native function that clamps roll/pitch in `gamestateMachineComponent::OnUpdate()`
- **Approach B: Animation Override** — Follow VR mod pattern, override bone transforms at pose-apply level
- **Approach C: Physics Body Injection** — Add rigid body component to player entity

## Conclusion

The PSM blackboard manipulation approach was a worthy experiment — it confirmed that the blackboard is accessible and writable, and that the state machine component can be found. However, writing PSM state variables alone is insufficient to bypass the locomotion orientation clamp. The clamp likely happens in native C++ code within the locomotion state machine's update function, not in the blackboard read/write layer.

The most promising remaining CET-level approach is **Approach D (Vehicle Mount Hybrid)** — spawn an invisible vehicle, mount the player to it, and rotate the vehicle (which supports full 3-axis rotation via existing APIs). This was identified in the analysis doc as "low complexity, low risk" and has not been tested yet.
