# Tester 9.1 — Diagnostic Logging

> **Strategy:** Pure observation — no transform overrides
> **Goal:** Identify which transform/bone/component the renderer reads for player body orientation
> **Type:** CET-only (no RED4ext or Redscript needed)

---

## Architecture

```
hover_rot_tester_player9.1/
├── cet/
│   └── init.lua          # All CET logic: logging, snapshots, hover PD, ImGui
├── goals 1 - logging.md  # This tester's goals (copied from tester 9)
├── goals - master.md     # Master overview of testing program
└── README.md            # This file
```

CET-only. No `red4ext/` or `redscript/` subfolders — the goals doc specifies RED4ext is optional for 9.1, and CET-level logging is sufficient for the initial investigation.

## Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Logging | Enable/disable periodic transform dump (default every 60 ticks) |
| Dump Now | One-shot full log dump + animation/state machine probe |
| Bone Dump | One-shot full skeleton hierarchy print |
| Snapshot A | Capture current transform state as "before" |
| Snapshot B | Capture current transform state as "after" |
| Compare Snapshots | Log diffs between A and B |
| Hover Toggle | Enable/disable hover height lock |
| Hover Up | Increase target height +1m |
| Hover Down | Decrease target height -1m |
| Hover Stop | Disable hover |

> All `registerHotkey()` calls are at file root level (not inside `onInit`), per CET hotkey registration rules.

## What It Logs

### Entity-Level
- `GetWorldPosition()` + `GetWorldOrientation()` → position + Euler angles
- `GetWorldTransform()` → position + quaternion

### Camera (FPPCameraComponent)
- `GetLocalToWorld()` → world position via Matrix:GetTranslation
- `GetWorldPosition()` / `GetWorldOrientation()` / `GetLocalOrientation()`
- `GetWorldTransform()` → position + orientation

### All Components
- Iterates `player:GetComponents()`, filters `IsA("IPlacedComponent")`
- Logs class name + world transform (pos + Euler) for each placed component
- Counts total vs placed components

### Animation / Skeleton
- Probes for `entAnimationControllerComponent`, `AnimatedComponent`, `gameHumanoidBody`, etc.
- Attempts bone count, bone names, bone transforms via `GetSkeleton()`, `GetBoneCount()`, `GetBoneName()`, `GetBoneTransform()`
- Falls back to static class exploration

### State Machine
- Probes for `gamestateMachineComponent`
- Attempts `GetCurrentStateName()`, `IsTransformUpdateEnabled()`
- Accesses `PlayerStateMachineBlackboard` for `HighLevel`, `Vision`
- Checks `CanRagdoll()` and ragdoll component existence

## Hover PD Controller

Adapted from `hover_vehicle_tester2`. Uses `PSMImpulse` via `QueueEvent` (player, not vehicle).

| Parameter | Value |
|-----------|-------|
| HOVER_HEIGHT | 3.0 m |
| SPRING_K (Kp) | 0.8 |
| DAMPING_K (Kd) | 2.0 |
| MAX_DV | 3.0 m/s |
| GROUND_RAY_DIST | 50.0 m |
| Raycast preset | "Bullet logic" |

## Log Prefixes

| Prefix | Purpose |
|--------|---------|
| `[HoverRotPlayer9_1]` | General logging |
| `[HoverRotPlayer9_1-BoneDump]` | Skeleton hierarchy dump |
| `[HoverRotPlayer9_1-Snap]` | Snapshot capture and comparison |

## ImGui Panel

Always visible. Shows:
- Logging active/inactive + interval slider (10–300 ticks)
- Snapshot A/B status
- Hover status (active, target/current/ground Z)
- Component count (total, placed, bones)
- Player position/orientation
- Last error
- Hotkey reference

## Crash Safeguard

All modes (logging, hover) reset to inactive in `onInit`. No persistent state across reloads.

## Key Experiment (from goals doc)

1. Enable logging (hotkey)
2. Stand still, face forward — take Snapshot A
3. Turn ~90° via mouse-look — take Snapshot B
4. Compare Snapshots — which transform orientations changed?
5. Secondary: move forward/backward (no turning) — observe which transforms change position but not orientation

## Questions This Tester Answers

1. Which transform changes on mouse-look turn? → identifies render-source transform
2. Can CET enumerate bones on the player skeleton? → determines if bone-level approach is viable
3. Can CET read individual bone transforms? → determines if C++ hooks are needed
4. What is the bone hierarchy structure? → identifies root/pelvis/camera bones
5. Is the FPP camera a child of body transform or independent?
6. Does `gamestateMachineComponent` expose useful state/flags?
7. Are there ragdoll-related components?

## References

| Source | Path |
|--------|------|
| Goals | `goals 1 - logging.md` |
| Master | `goals - master.md` |
| Free Player Analysis | `docs/c++ hooks/free player manipulation - analysis.md` |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` |
| Vehicle Hover T2 | `testers/hover rotate vehicle/hover_vehicle_tester2/init.lua` |
| Tester 7b | `testers/hover rotate player/hover_rot_tester_player7b/cet/init.lua` |
| Tester 8 | `testers/hover rotate player/hover_rot_tester_player8/cet/init.lua` |
| VR VRIK | `sources - extra/vr/.../CyberpunkVRPort_VRIK/init.lua` |
| OKF Components | `okf/api/components/` |
| OKF Animation | `okf/api/animation/` |
