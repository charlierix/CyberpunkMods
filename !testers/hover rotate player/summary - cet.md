# CET Player Rotation Testing — Summary

**Goal:** Physically rotate the player character's body (full 6DOF — pitch, yaw, roll) while airborne, not just the camera.

**Conclusion:** CET-only player body rotation is **exhausted**. Only yaw can be set (via Teleport). Roll and pitch are clamped to 0° by the locomotion system at a level deeper than any CET API can reach. Camera rotation works independently for visual 3-axis rotation, but the body stays upright. Next step: C++ engine hooks.

---

## Testers Overview

| Tester | Approach | Key Result |
|--------|----------|------------|
| `hover_rot_tester_playercamera` | Camera-only rotation via Teleport | Yaw rotates around world Z; body stays upright; camera rotation insufficient |
| `hover_rot_tester_player` (v1) | `SetWorldTransform` on player | **Complete no-op** — position and orientation never change |
| `hover_rot_tester_player2` | PSMImpulse hover + `SetWorldTransform` orientation | Hover works; orientation never changes (always roll=0, pitch=0) |
| `hover_rot_tester_player3` | Entity interrogation (no rotation) | 174 components found; no ragdoll; `EnableTransformUpdates(false)` discovered; camera has `SetLocalOrientation` |
| `hover_rot_tester_player4` | `TeleportationFacility:Teleport()` with EulerAngles | **Yaw sticks**; roll and pitch always clamped to 0; no Quaternion overload exists |
| `hover_rot_tester_player4a` | Teleport + `EnableTransformUpdates(false)` + Euler order variants + camera rotation | TransformUpdates OFF doesn't help; Euler order irrelevant; **camera `SetLocalOrientation` works for full 3-axis** (camera only, body upright) |
| `hover_rot_tester_player5` | `EnableTransformUpdates(false)` + `SetWorldTransform` every frame (airborne) | SetWorldTransform is even stricter no-op — doesn't even set yaw; only Teleport sets yaw |

---

## Key Findings

### What Works

| Method | Roll | Pitch | Yaw | Scope |
|--------|------|-------|-----|-------|
| `TeleportationFacility:Teleport()` | ❌ | ❌ | ✅ | Body yaw + position |
| `FPPCameraComponent:SetLocalOrientation()` | ✅ | ✅ | ✅ | Camera only (body stays upright) |

### What Doesn't Work

| Method | Testers | Result |
|--------|---------|--------|
| `SetWorldTransform` | 1, 2, 3, 5 | Complete no-op — doesn't set any axis, not even yaw |
| `SetWorldTransform` + `EnableTransformUpdates(false)` | 5 | Still no-op |
| `Teleport` + `EnableTransformUpdates(false)` | 4a | Roll/pitch still clamped to 0 |
| `Teleport` with different Euler constructor orders | 4a | Irrelevant — only yaw is ever retained |
| `Teleport` with Quaternion arg | 4 | No overload exists — errors: "param 3 must be EulerAngles" |
| Ragdoll-based rotation | 3 | `CanRagdoll()` returns false; no ragdoll component in 174 components |
| PSMImpulse for rotation | (research) | Translational only — no angular/torque field |

### Root Cause: Locomotion System Override

The player's locomotion state machine enforces `roll=0, pitch=0` every frame through a mechanism that **cannot be bypassed** by:

- `SetWorldTransform` (sets the visual/scene component, not a physics rigid body — locomotion overwrites it)
- `EnableTransformUpdates(false)` (doesn't stop the clamping — the override is in a different system)
- `TeleportationFacility:Teleport()` (succeeds at API level, but locomotion overrides roll/pitch after)
- Being airborne with no ground contact
- Any `EulerAngles` constructor order

**Why vehicles work but players don't:** Vehicles are physics-driven — their rigid body drives the transform component, so `SetWorldTransform` actually moves them. Players are locomotion-driven — the state machine overwrites the transform component every frame.

---

## Entity Interrogation Results (Player 3)

| Property | Value |
|----------|-------|
| Class | `PlayerPuppet` (subclass of `ScriptedPuppet` → `gamePuppet` → `gamePuppetBase`) |
| NOT a | `GameObject`, `GameEntity`, `Entity` (directly) |
| Components | 174 total (via `GetComponents()`) |
| Ragdoll | `CanRagdoll()` = **false**; no ragdoll component exists |
| Key components | `gamestateMachineComponent`, `moveComponent`, `entColliderComponent`, `gameHumanoidBody`, `entAnimationControllerComponent` |
| `EnableTransformUpdates(bool)` | Exists (from `Dump()` reflection) — but doesn't unlock rotation |
| `FindComponentByType(CName)` | Exists — correct component lookup method |
| `GetPlayerStateMachineBlackboard()` | Exists — PSM blackboard access |

### Methods NOT available on player

`SetWorldPosition`, `SetWorldOrientation`, `SetLocalPosition`, `SetLocalOrientation`, `GetAllComponents`, `HasComponent`, `GetMovementComponent`, `GetLocomotionComponent`, `GetPhysicsComponent`, `ApplyImpulse`, `AddImpulse`, `ApplyForce`

---

## Camera Rotation (the one usable result)

`FPPCameraComponent:SetLocalOrientation(quaternion)` works for full 3-axis camera rotation:

```lua
local cam = player:GetFPPCameraComponent()
cam.sensitivityMultX = 0  -- disable mouse override
cam.sensitivityMultY = 0
cam:SetLocalOrientation(gameQuat)  -- full 3-axis rotation
```

The camera fully rotates but the body stays upright. Axis labels differ between quaternion math and camera local space (X-rotation shows as camera roll, Y-rotation shows as camera pitch) — the rotation itself is correct, just the labels differ.

---

## Approaches Considered but Not CET-Viable

| Approach | Why |
|----------|-----|
| Ragdoll + impulses | Player cannot ragdoll (`CanRagdoll()` = false, no ragdoll component) |
| PhysicalImpulseEvent with torque arm | Player may not have physics rigid body; locomotion snaps back |
| PSMImpulse | Translational only — no torque/angular field |
| Animation/workspot | Fixed angles only, no dynamic 6DOF control |
| Workspot/pose-based (chair, bed, lean) | Untested but limited to fixed poses, not free rotation |

---

## Player 6 — PSM Blackboard Manipulation (TESTED — FAILED)

**Tester**: `hover_rot_tester_player6/` — Steps 3 & 7 from player3's next steps

### What was tested

- **PSM blackboard access** — `GetPlayerStateMachineBlackboard()` + `GetAllBlackboardDefs().PlayerStateMachine` → ✅ SUCCESS
- **`gamestateMachineComponent` access** — `FindComponentByType()` + `GetSnapshotContainer()` → ✅ SUCCESS
- **9 PSM state modes** written every frame: NONE, DEAD, SWIMMING, SCENE, FELLED, KNOCKDOWN, WORKSPOT, MOUNTED, AIR_HOVER
- **Both rotation methods**: Teleport and SetWorldTransform
- PSM values saved/restored on activate/deactivate

### Result

| Aspect | Result |
|--------|--------|
| PSM blackboard write | ✅ Works — values written successfully |
| PSM blackboard readback | Values written but locomotion overwrites them every frame |
| `IsStateMachinePresent()` | ❌ Returns false for all named SMs (identifier construction may be wrong) |
| Rotation after PSM manipulation | ❌ No mode enabled roll/pitch — only yaw sticks (same as tester 4) |
| Visual confirmation | User observed: pitch/roll never happened, only yaw |

### Conclusion

Writing PSM state variables alone is **insufficient** to bypass the locomotion orientation clamp. The clamp happens in native C++ code within the locomotion state machine's update function, not in the blackboard read/write layer. The blackboard is a *read-only mirror* of state — writing to it doesn't change the actual state machine behavior.

## Remaining Untested CET Approaches

From Player 3's next steps, these were identified but not yet tested:

1. ~~**`gamestateMachineComponent` access** via `FindComponentByType`~~ — ✅ TESTED (player6): component found, GetSnapshotContainer works, but IsStateMachinePresent returns false for named SMs
2. **`moveComponent` / `entColliderComponent` access** — probe for orientation setters
3. ~~**PSM blackboard manipulation** — write a locomotion state that allows free orientation~~ — ❌ TESTED (player6): writing PSM vars doesn't bypass clamp
4. **Workspot/pose-based rotation** — attach player to a mobile, rotatable point (lean anywhere, chair)
5. **Vehicle Mount Hybrid** (Approach D from analysis doc) — spawn invisible vehicle, mount player, rotate vehicle

These are lower-confidence long shots. The locomotion override is likely enforced at the engine level.

---

## Next Step: C++ Engine Hooks

All CET-level transform/teleport APIs have been exhausted. The locomotion system's `roll=0, pitch=0` enforcement happens at a level deeper than CET can reach. A RED4ext C++ plugin (like Let There Be Flight does for vehicles) is the next approach — directly hooking into the locomotion update or writing to the player's physics/transform struct fields at the native level.

---

## File Index

| File | Content |
|------|---------|
| `hover_rot_tester_player/APPROACHES.md` | Full approach matrix with 7 strategies analyzed |
| `hover_rot_tester_player/TEST RESULTS.md` | V1 SetWorldTransform log + analysis |
| `hover_rot_tester_playercamera/TEST RESULTS.md` | Camera-only rotation findings |
| `hover_rot_tester_player2/README.md` | V2 design (impulse hover + SetWorldTransform) |
| `hover_rot_tester_player2/TEST RESULTS.md` | V2 log showing hover works, rotation doesn't |
| `hover_rot_tester_player2/POST TEST ANALYSIS.md` | Codeware source analysis — why SetWorldTransform is no-op |
| `hover_rot_tester_player3/README.md` | Entity interrogation tester design |
| `hover_rot_tester_player3/log summary.md` | Full interrogation results (174 components, methods, ragdoll) |
| `hover_rot_tester_player3/next steps.md` | Ranked next steps after interrogation |
| `hover_rot_tester_player4/README.md` | Teleport with EulerAngles tester design |
| `hover_rot_tester_player4/TEST RESULTS.md` | Teleport results — yaw works, roll/pitch don't |
| `hover_rot_tester_player4/log summary.md` | Detailed log analysis across 3 sessions |
| `hover_rot_tester_player4a/README.md` | TransformUpdates + Euler order + camera rotation tester |
| `hover_rot_tester_player4a/TEST RESULTS.md` | All toggles tested — only camera rotation works |
| `hover_rot_tester_player4a/log summary.md` | Detailed analysis of 5540-line log |
| `hover_rot_tester_player5/README.md` | Airborne SetWorldTransform + TransformUpdates OFF |
| `hover_rot_tester_player5/TEST RESULTS.md` | No rotations at all — strictest no-op confirmed |
| `hover_rot_tester_player5/log summary.md` | Full analysis showing SetWorldTransform never sets any axis |

## Reference Docs

| Doc | Content |
|-----|---------|
| `docs/rotations/rotations-reference.md` | Quick reference for all rotation APIs by entity type |
| `docs/rotations/rotation_orientation_research_report.md` | Comprehensive research from 50+ mods with source citations |