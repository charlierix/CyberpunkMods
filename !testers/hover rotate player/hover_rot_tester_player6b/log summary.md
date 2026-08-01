# Log Summary — hover_rot_tester_player6b

**Source:** `log.txt` (5,199 lines, 552,402 chars)  
**Date:** 2026-07-25, 19:55:25 – 20:01:32 (run 1: 19:55–19:57, run 2: 19:59–20:01)  
**Tester:** 6b — 6a base + safety re-teleport from 6, height=50

---

## Executive Summary

**No PSM state or rotation method allowed pitch/roll rotation of the player.** Out of 581 diagnostic samples across 10 modes × 2 methods, **zero** resulted in non-zero roll or pitch after the rotation call. Only yaw was ever successfully applied.

The safety teleport system worked correctly: it caught the player 45 times and reset them to z=86.6, preventing fall damage.  (at least while active - once deactivated, the player fell to their death - but that's not logged, just an irritation)

---

## Test Setup

| Parameter | Value |
|---|---|
| Initial z | 36.6 |
| Target z (height) | 86.6 (initial + 50) |
| Re-teleport threshold | 46.6 (initial + 10) |
| Rotation methods tested | Teleport, SetWorldTransform (SWT) |
| PSM modes tested | 10 (NONE, DEAD, SWIMMING, SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER, +NONE repeat) |
| Total DIAG samples | 581 |
| Unique (mode, method, target) combos | 175 |

---

## Critical Finding: Roll and Pitch Never Applied

| Metric | Count |
|---|---|
| Total DIAG AFTER lines | 581 |
| Lines with \|roll\| > 0.5° | **0** |
| Lines with \|pitch\| > 0.5° | **0** |

Every single DIAG AFTER reading shows `roll=0.0 pitch=0.0` regardless of:
- Mode (NONE, DEAD, SWIMMING, SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER)
- Method (Teleport or SetWorldTransform)
- Target roll/pitch values (tested up to ±180°)

Yaw was successfully applied in most cases (when the target yaw wasn't overridden by a subsequent mode switch).

---

## Results by Mode and Method

### Summary Table

| Mode | Method | Samples | Roll Works | Pitch Works | Yaw Works | PSM LocDet |
|---|---|---|---|---|---|---|
| NONE | Teleport | 46 | ❌ | ❌ | ✅ | 1, 14 |
| NONE | SWT | 32 | ❌ | ❌ | ~partial | 1 |
| DEAD | Teleport | 26 | ❌ | ❌ | ✅ | 1, 6 |
| DEAD | SWT | 28 | ❌ | ❌ | ~partial | 1 |
| SWIMMING | Teleport | 30 | ❌ | ❌ | ✅ | 1, 6 |
| SWIMMING | SWT | 28 | ❌ | ❌ | ~partial | 1 |
| SCENE | Teleport | 22 | ❌ | ❌ | ✅ | 1, 31 |
| SCENE | SWT | 18 | ❌ | ❌ | ~partial | 1, 31 |
| FELLED | Teleport | 162 | ❌ | ❌ | ✅ | 29, 31 |
| FELLED | SWT | 19 | ❌ | ❌ | ~partial | 29, 31 |
| KNOCKDOWN | Teleport | 28 | ❌ | ❌ | ✅ | 1, 29 |
| KNOCKDOWN | SWT | 28 | ❌ | ❌ | ~partial | 1, 29 |
| WORKSPOT | Teleport | 16 | ❌ | ❌ | ✅ | 1 |
| WORKSPOT | SWT | 22 | ❌ | ❌ | ~partial | 1 |
| MOUNTED | Teleport | 18 | ❌ | ❌ | ✅ | 1, 16 |
| MOUNTED | SWT | 20 | ❌ | ❌ | ~partial | 1, 16 |
| AIR_HOVER | Teleport | 20 | ❌ | ❌ | ✅ | 1, 16 |
| AIR_HOVER | SWT | 18 | ❌ | ❌ | ~partial | 1, 16 |

**Notes:**
- "~partial" for SWT yaw means yaw sometimes sticks but often resets to a stale value from before the current target — SWT appears to not reliably update orientation.
- FELLED had the most Teleport samples (162) because the user spent extra time testing it (likely because the player appeared to be laying down, suggesting partial rotation was visible in-game).

### PSM State Changes Observed

PSM mode manipulation **did change** the LocDetailed blackboard value, confirming the blackboard writes are working:

| Mode | LocDetailed Values Seen | Felled |
|---|---|---|
| NONE | 1, 14 | false |
| DEAD | 1, 6 | false |
| SWIMMING | 1, 6 | false |
| SCENE | 1, 31 | false, true |
| FELLED | 29, 31 | false, true |
| KNOCKDOWN | 1, 29 | false |
| WORKSPOT | 1 | false |
| MOUNTED | 1, 16 | false |
| AIR_HOVER | 1, 16 | false |

However, **none of these PSM state changes unlocked pitch/roll rotation**.

---

## Safety Teleport System

| Metric | Value |
|---|---|
| Safety teleports triggered | 45 |
| Fall z range | 36.6 – 46.6 |
| Reset target | z=86.6 (always via Teleport API) |
| Fall damage | None reported (safety worked) |

### Behavior in SWT Mode

In SetWorldTransform mode, the player slowly descends from z=86.6 because SWT doesn't reposition the player. The safety teleport catches them at ~z=46.6 (after ~2-3 seconds of falling) and resets to z=86.6 via Teleport API. This creates a repeating cycle:

```
z=86.6 → fall ~2-3s → z≈46.5 → safety teleport → z=86.6 → fall again...
```

This cycle repeats every 2-3 seconds in SWT mode, making SWT testing very difficult (user has a narrow window to adjust roll/pitch/yaw before being teleported back up).

### Behavior in Teleport Mode

In Teleport mode, the player stays at z=86.6 because the rotation teleport itself repositions them to targetZ every frame. Safety teleport rarely triggers.

---

## Run 1: Teleport Method (19:55:25 – 19:57:33)

- All 10 modes tested with Teleport method
- Player stayed at z=86.6 throughout (Teleport repositions every frame)
- Yaw rotation worked in all modes
- Roll/pitch never applied in any mode
- Deactivated cleanly, PSM restored

## Run 2: SetWorldTransform Method (19:59:24 – 20:01:32)

- Started in Teleport mode, switched to SWT at 19:59:30
- Player fell repeatedly in SWT mode (safety teleport caught 45 times)
- All modes tested with SWT method
- SWT also failed to apply roll/pitch in any mode
- SWT also unreliable for yaw (often retained stale yaw from before target change)
- Brief switch back to Teleport at 20:00:31 for FELLED mode testing, then back to SWT at 20:00:54
- Deactivated cleanly, PSM restored

---

## StateMachine Component Probe

The stateMachineComponent probe ran on activation:
- `FindComponentByType('gamestateMachineComponent')` — SUCCESS
- `GetSnapshotContainer()` — SUCCESS (returned userdata)
- `IsStateMachinePresent()` — returned **false** for all tested state machines: Locomotion, UpperBody, HighLevel, Combat, Vehicle
- `Dump()` — no output captured

The SM component exists but none of the expected state machines (Locomotion, UpperBody, etc.) were found by name. This suggests the player's state machine structure may use different names or a different access pattern.

---

## Conclusions

1. **Teleport API can only set yaw** — it forcibly resets roll=0 and pitch=0 regardless of the quaternion passed. This is a hard engine constraint.

2. **SetWorldTransform also cannot set roll/pitch** — it also resets roll=0 and pitch=0. Additionally, SWT doesn't reposition the player (z falls), making it impractical without constant safety teleports.

3. **PSM blackboard manipulation is working** — LocDetailed values change per mode (1→16 for AIR_HOVER/MOUNTED, 1→29/31 for FELLED/KNOCKDOWN/SCENE, etc.), but none of these states unlock pitch/roll rotation.

4. **Safety teleport system works correctly** — 45 catches, no fall damage, always resets to targetZ via Teleport API.

5. **SWT is not viable** — it fails to reposition the player (constant falling) and also fails to apply roll/pitch.

---

## Next Steps to Consider

- The locomotion system likely enforces roll=0/pitch=0 at the animation/physics layer, not just via PSM blackboard values. A different approach may be needed:
  - C++ hook to intercept the orientation constraint
  - Direct physics body manipulation
  - Animation pose override
  - Different entity/component to rotate (e.g., camera component, mesh component)
- The StateMachineComponent probe found no named state machines — the player SM may need to be accessed differently (e.g., via `GetStateMachineBehaviorComponent` or by iterating sub-components)
- FELLED mode showed `Felled=true` in PSM, and the player appeared to lay down in-game — this visually changed the player pose, but Teleport still reset roll/pitch to 0. The pose change is animation-level, not transform-level.
