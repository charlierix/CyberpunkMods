# CET Vehicle Rotation Testing — Summary

**Goal:** Hover and rotate a vehicle with full 6DOF (pitch, yaw, roll) while the player is inside, with camera following correctly.

**Conclusion:** Vehicle rotation via `Teleport` works reliably for all 3 axes (no gimbal lock observed). However, impulse-based hover control is insufficient for fluid movement, and first-person camera alignment issues remain when the vehicle is rotated. Next step: C++ engine hooks for direct rigid body force/torque access (like Let There Be Flight).

---

## Testers Overview

| Tester | Approach | Key Result |
|--------|----------|------------|
| `hover_vehicle_tester` | `PhysicalImpulseEvent` hover (split front/rear points) | Partially works — bounces vehicle but can't get fully airborne; impulse induces pitch torque; strength varies with rotation |
| `hover_vehicle_tester2` | `PhysicalImpulseEvent` at center of mass (single point, large radius) | Same problems — slow update rate, induced torques; concluded direct rigid body access is needed |
| `hover_rot_tester_vehicle` | NanoDrone entity + `TakeOverControl` camera binding | Camera system overrides programmatic rotation; wrong camera type (surveillance, not FPP); screen warping |
| `hover_rot_tester_vehicle2` | Real vehicle + FPPCameraComponent lock + `SetWorldTransform`/`Teleport` | **Vehicle rotation works** via Teleport (full 6DOF); camera alignment issues in FPP; 3rd person works fine |

---

## Key Findings

### What Works

| Method | Scope | Notes |
|--------|-------|-------|
| `TeleportationFacility:Teleport(vehicle, pos, EulerAngles)` | Full 6DOF rotation + position | Reliably rotates all 3 axes; no gimbal lock observed |
| `SetWorldTransform` with raw Quaternion | Full 6DOF (requires Codeware) | Bypasses gimbal lock entirely |
| 3rd person camera | Visual observation | Sits back and watches vehicle rotate in place — works fine |
| FPPCameraComponent locking | Mouse override prevention | `sensitivityMultX/Y = 0`, `headingLocked = true`, expanded pitch/yaw ranges |

### What Doesn't Work

| Method | Tester | Result |
|--------|---------|--------|
| `PhysicalImpulseEvent` for hover | 1, 2 | Slow update rate, induces torques, rotation-dependent strength; insufficient for fluid control |
| NanoDrone entity for camera | 1 (rot) | Has `SurveillanceCameraController`, not `FPPCameraComponent` — no sensitivity/heading controls |
| `SetWorldOrientation(quat)` on vehicle | 2 (rot) | Method doesn't exist natively (nil) — use `SetWorldTransform` instead |
| FPP camera alignment when vehicle rotated | 2 (rot) | Camera snaps backward on activation; mouse doesn't work during constant teleports |

---

## Impulse Hover Limitations (Testers 1 & 2)

### Tester 1 — Split impulse points

- Impulse applied at two points (±1.5m along forward vector) with `radius=1.0`
- **Problem:** Spherical impulse only affects collision shapes overlapping the sphere. When vehicle rotates, the small spheres at offset points partially miss the collision body, reducing effective force
- Upright = maximum overlap = strongest; upside down = less overlap = weakest
- Offset points create torque arm → induces pitch torque

### Tester 2 — Center of mass, single point

- Impulse at vehicle center with `radius=5.0` (always encompasses body)
- Eliminates rotation-dependent strength and torque arm
- **Still insufficient:** Update rate is too slow for responsive control; impulses are discrete, not continuous forces
- Mass is properly compensated (same behavior at 500kg and 2690kg)

### Why impulses aren't enough

Let There Be Flight (LTBF) bypassed impulse events entirely and directly writes to the vehicle's `physicsData->force` and `physicsData->torque` struct fields via a RED4ext C++ DLL. This is likely the only way to get fluid, continuous control of a vehicle rigid body.

---

## Camera System Issues (Tester 1 rot — NanoDrone)

### Wrong camera type

The NanoDrone entity (`base\nano_drone\drone.ent`) uses a **surveillance camera system**:
- `SurveillanceCameraController` — device-based camera controller
- `entVirtualCameraComponent` — virtual camera for rendering
- `gameDeviceCameraControlComponent` — device camera control marker

It does **NOT** have `FPPCameraComponent` (which has `sensitivityMultX/Y`, `headingLocked`, `pitchMin/Max`).

This caused:
- `camFound=false` — no FPP camera to lock
- Screen warping — `SetWorldOrientation` fights the surveillance controller's own update
- Different mouse behavior — surveillance camera has different input handling

### TakeOverControlSystem

- `isInputLockedFromQuest = true` partially works (changes which mouse axis is active) but doesn't fully prevent camera updates
- Screen warps because our `SetWorldOrientation` and the camera system's update fight each frame

### NanoDrone reference pattern

NanoDrone **never** sets orientation programmatically — it only teleports for position and lets the TakeOverControl camera system handle rotation entirely via mouse. No programmatic rotation at all.

---

## Vehicle Rotation Results (Tester 2 rot — Real Vehicle)

### Vehicle rotation — SOLVED

Teleport reliably rotates the vehicle on all 3 axes. Could not trigger gimbal lock despite testing extreme angles. The `EulerAngles(roll, pitch, yaw)` constructor order is confirmed correct.

### Camera issues — PARTIALLY SOLVED

| Issue | Details |
|-------|--------|
| FPP camera snaps backward on activation | Same direction every time (possibly identity quaternion direction) |
| Mouse doesn't work in FPP | Likely because constant teleports reset camera state |
| 3rd person camera | Works fine — watches vehicle rotate in place |
| 3rd/1st person trick | While in 3rd person, look along vehicle (rear→front), then switch to 1st person → view is forward. As vehicle rotates, FPP view stays in line. Something resists change (probably to avoid jolting on bumps), strongest when looking along horizon. |

### Key API patterns that work

```lua
-- Lock FPP camera (vehicles DO use FPPCameraComponent)
local cam = player:GetFPPCameraComponent()
cam.sensitivityMultX = 0
cam.sensitivityMultY = 0
cam.headingLocked = true
cam.pitchMin = -180
cam.pitchMax = 180
cam.yawMaxLeft = 360
cam.yawMaxRight = 360

-- Also set TweakDB for vehicle camera params
TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMax", 180)
TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMin", -180)

-- Rotate vehicle via Teleport (works for all 3 axes)
local euler = Quat.toEuler(state.quat)  -- pure Lua quat→euler
Game.GetTeleportationFacility():Teleport(vehicle, hoverPos, euler)

-- OR via SetWorldTransform (Codeware, no gimbal lock)
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientation(gameQuat)  -- raw Quaternion
vehicle:SetWorldTransform(wt)
```

---

## Physics Questions Answered (Tester 2)

| Question | Answer |
|----------|--------|
| Is impulse in world or model coords? | **World coordinates** — `worldImpulse` is a `Vector3` in world space |
| Can impulse be applied above center of mass? | Yes, but it creates a **torque arm** → produces rotation (opposite of what we want for stable hover) |
| Is there a translation-only impulse? | **No** — `PhysicalImpulseEvent` always applies both force and torque. Pure translation requires applying at center of mass (zero torque arm) |
| Why did impulse strength change with rotation? | Tester 1's split impulse points with small radius partially missed the collision body when rotated |

---

## Testing Plan (Tester 2 rot)

A detailed 14-test matrix was created (`TESTING_PLAN.md`) covering:
- Baseline isolation tests (Teleport-only, SetWorldOrientation-only, both)
- Order tests (O→T vs T→O)
- Velocity zeroing tests
- Camera forcing tests (SetLocalOrientation, pitchMin/Max, roll only)
- Alternative hover approaches (initial teleport + impulses)

Key findings from the testing plan execution:
- Teleport with current orientation preserves it (NanoDrone pattern)
- Teleport with our quaternion euler applies rotation reliably
- `SetWorldOrientation` is nil on vehicles — use `SetWorldTransform` instead

---

## Comparison: Player vs Vehicle

| Aspect | Player | Vehicle |
|--------|--------|---------|
| `SetWorldTransform` | Complete no-op (locomotion overrides) | Works (physics-driven, locomotion doesn't fight) |
| `Teleport` yaw | ✅ Works | ✅ Works |
| `Teleport` roll/pitch | ❌ Clamped to 0 by locomotion | ✅ Works (all axes) |
| `SetWorldOrientation` | Doesn't exist | Doesn't exist (nil) |
| Ragdoll | `CanRagdoll()` = false | N/A |
| Camera `SetLocalOrientation` | ✅ Works (camera only) | ✅ Works (camera follows vehicle in 3rd person) |
| Impulse hover | PSMImpulse (translational only) | PhysicalImpulseEvent (works but too slow/janky) |
| Physics rigid body | Locomotion-driven (no direct physics) | Physics-driven (rigid body exists) |

---

## Next Step: C++ Engine Hooks

Both player and vehicle testing have reached the limits of CET-only APIs:

- **Vehicle hover control** needs direct rigid body force/torque access (like LTBF's `physicsData->force`/`physicsData->torque`)
- **Vehicle camera alignment** in FPP needs hooking the camera update to inject correct orientation after mouse processing
- **Player body rotation** needs hooking or suppressing the locomotion system's per-frame orientation override

A RED4ext C++ plugin is the next approach for both entity types.

---

## File Index

| File | Content |
|------|---------|
| `hover_vehicle_tester/TEST RESULTS.md` | Impulse hover v1 — bouncing, torque, rotation-dependent strength |
| `hover_vehicle_tester2/TEST RESULTS.md` | Impulse hover v2 — same problems, concluded direct rigid body needed |
| `hover_vehicle_tester2/math questions.md` | Physics Q&A — world coords, torque arms, no translation-only impulse |
| `hover_rot_tester_vehicle/RESEARCH_NOTES.md` | NanoDrone camera research — wrong camera type, TakeOverControl system analysis |
| `hover_rot_tester_vehicle2/README.md` | Real vehicle tester design — FPPCameraComponent locking + SetWorldTransform |
| `hover_rot_tester_vehicle2/RESEARCH_NOTES.md` | Results — vehicle rotation works, camera alignment issues |
| `hover_rot_tester_vehicle2/TESTING_PLAN.md` | 14-test matrix for isolating rotation and camera variables |

## Reference Docs

| Doc | Content |
|-----|---------|
| `docs/rotations/rotations-reference.md` | Quick reference for all rotation APIs by entity type |
| `docs/rotations/rotation_orientation_research_report.md` | Comprehensive research from 50+ mods with source citations |
| `docs/vehicle flight/let there be flight.md` | LTBF analysis — C++ direct rigid body access pattern |