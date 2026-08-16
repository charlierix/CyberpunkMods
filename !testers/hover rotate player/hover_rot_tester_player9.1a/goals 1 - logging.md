# Goals — Logging (Tester 9.1a)

## Original 9.1 Logging Goals

### Goal 1: Entity Transform Logging
**Status:** ✅ Met (in 9.1, carried forward in 9.1a)

Log player entity world position and orientation via CET APIs:
- `GetWorldPosition()` — ✅ working
- `GetWorldOrientation()` — ✅ working
- `GetWorldTransform():GetPosition()` / `:GetOrientation()` — ✅ working

### Goal 2: Camera Transform Logging
**Status:** ✅ Met (in 9.1, carried forward in 9.1a)

Log FPP camera transforms via multiple API paths:
- `GetFPPCameraComponent()` — ✅ found
- `GetLocalToWorld()` — ✅ working
- `GetWorldPosition()` / `GetWorldOrientation()` / `GetLocalOrientation()` — ✅ working
- `GetWorldTransform()` — ✅ working

### Goal 3: Component Enumeration
**Status:** ✅ Met (in 9.1, carried forward in 9.1a)

Enumerate all player components and log:
- Component class name — ✅ via `GetClassName()`
- Is placed component — ✅ via `IsA("IPlacedComponent")` or `GetWorldTransform()` nil check
- Placed component transforms — ✅ position + orientation

### Goal 4: Animation / Skeleton Access
**Status:** ❌ Not met in 9.1 → ✅ Met in 9.1a via C++

**9.1 result:** CET's `GetSkeleton()` returned nil on all attempted component types. `GetBoneCount()` also returned nil. This is a CET scripting layer limitation — the skeleton data is not exposed to Lua.

**9.1a solution:** RED4ext C++ plugin reads `anim::Rig` directly from `ent::AnimatedComponent::rig` (offset 0x138). The C++ `DumpSkeleton()` native function accesses:
- `boneNames` (DynArray<CName> at rig+0x50) — bone names via `CName::ToString()`
- `parentIndices` (int16_t* at rig+0x40) — bone hierarchy
- `aPoseMS` (DynArray<QsTransform> at rig+0xC8) — animated pose transforms (model space)
- `referencePoseMS` (DynArray<QsTransform> at rig+0x60) — reference pose transforms

Each bone is logged as: `boneIndex|boneName|parentIdx|tx|ty|tz|qi|qj|qk|qr`

### Goal 5: State Machine Probing
**Status:** ✅ Met (in 9.1, carried forward in 9.1a)

Probe player state machine:
- `gamestateMachineComponent` found — ✅
- `GetCurrentStateName()` — ✅ (when available)
- `IsTransformUpdateEnabled()` — ✅ (when available)
- `PlayerStateMachineBlackboard` — ✅ accessible
- Blackboard values (HighLevel, Vision) — ✅ readable
- `CanRagdoll()` — ✅
- `ragdollComponent` — ✅ found

### Goal 6: Snapshot System (A/B Comparison)
**Status:** ✅ Met (in 9.1, carried forward in 9.1a + C++ entity transform)

Capture and compare two snapshots:
- Entity position delta — ✅
- Entity orientation delta — ✅ (yaw/pitch/roll)
- Camera orientation delta — ✅
- Component orientation changes — ✅ (threshold 0.5°)
- **NEW in 9.1a:** C++ entity transform comparison — ✅ via `DumpEntityTransform()` native call

### Goal 7: Hover PD Controller
**Status:** ✅ Met (in 9.1, carried forward in 9.1a)

Maintain player at configurable height above ground:
- Ground raycast via `SyncRaycastByQueryPreset("Bullet logic")` — ✅
- PD controller: spring + damper + anti-gravity — ✅
- Impulse via `PSMImpulse.new()` + `QueueEvent()` — ✅
- Adjustable height via hotkeys — ✅

## Goals Met Summary

| # | Goal | 9.1 | 9.1a |
|---|---|---|---|
| 1 | Entity transform logging | ✅ | ✅ |
| 2 | Camera transform logging | ✅ | ✅ |
| 3 | Component enumeration | ✅ | ✅ + C++ enumeration |
| 4 | Animation / skeleton access | ❌ nil | ✅ via C++ anim::Rig |
| 5 | State machine probing | ✅ | ✅ |
| 6 | Snapshot A/B comparison | ✅ | ✅ + C++ entity transform |
| 7 | Hover PD controller | ✅ | ✅ |

## 9.1a Additional Capabilities (beyond 9.1 goals)

- **C++ component class name readback** — reads `CClass::name` at offset 0x18 for each component, bypassing CET reflection
- **C++ entity transform raw readback** — reads `IPlacedComponent::worldTransform` at offset 0xE0, providing a cross-validation path against CET's `GetWorldTransform()`
- **C++ plugin status** — call counts, error tracking, last bone/component count
- **Native plugin detection** — CET checks bridge availability on init and logs whether C++ plugin is loaded

## Note on Vehicle Workspot (from 9.1 goals met doc)

The 9.1 goals met doc mentioned "vehicle workspot" in the context of state machine probing. This refers to the observation that the player's state machine tracks vehicle/workspot states (HighLevel blackboard value), which affects which transform paths the game uses for rendering. The 9.1a snapshot system captures these states so the user can compare transform readouts across different locomotion states (on foot vs vehicle vs workspot). This is relevant to player rotation because the state machine may switch transform update paths when entering vehicles/workspots, which is one hypothesis for why CET-only rotation approaches fail.

## Logging Only — No Manipulations

Per the user's instruction, 9.1a is **logging only**. No transform overrides, no rotation manipulation, no TweakDB writes. The hover PD controller is included from 9.1 as a utility (it was already working), but the primary purpose of 9.1a is to provide the missing bone/skeleton and C++-level transform data that 9.1 could not access.
