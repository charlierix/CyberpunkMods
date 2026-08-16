# Tester 9.1 — Diagnostic Logging

> **Strategy:** Pure observation — no transform overrides  
> **Goal:** Identify which transform/bone/component the renderer reads for player body orientation  
> **Doc:** This is the logging-only scope extracted from the original `goals1.md`  
> **Created:** 2026-08-15

---

## 1. Objective

**Determine which transform the game's renderer actually reads for player body orientation, and document the full transform chain from locomotion → animation → bones → render.**

Tester 9.1 does **not** attempt any rotation overrides. It logs everything, observes what changes during normal gameplay (mouse-look turns, movement), and builds a complete picture of the transform pipeline.

---

## 2. What to Log

### 2.1 Entity-Level Transforms

| Target | What to Read | How |
|--------|-------------|-----|
| Entity worldTransform | position + orientation quaternion | `player:GetWorldPosition()` + `player:GetWorldOrientation()` |
| Entity worldTransform (component-level) | IPlacedComponent worldTransform | `FindComponentByType('entTransformComponent')` or similar |

### 2.2 Camera

| Target | What to Read | How |
|--------|-------------|-----|
| FPPCameraComponent | local + world orientation, pitch/yaw limits | `player:GetFPPCameraComponent():GetLocalToWorld()` |
| Camera local orientation | quaternion | `cam:GetLocalOrientation()` if available |

### 2.3 Animation & Skeleton

| Target | What to Read | How |
|--------|-------------|-----|
| Animation controller | bone count, bone names, root bone transform | `FindComponentByType('entAnimationControllerComponent')` |
| Skeleton component | bone transforms, root bone, pelvis bone | `FindComponentByType('gameHumanoidBody')` or similar |
| AnimatedComponent (ISkinableComponent) | skinned mesh bone access | `FindComponentByType('AnimatedComponent')` |
| AnimationControllerComponent (static) | SetInputFloat and bone-related APIs | CET static class exploration |

### 2.4 State Machine

| Target | What to Read | How |
|--------|-------------|-----|
| gamestateMachineComponent | current state, EnableTransformUpdates flag | `FindComponentByType('gamestateMachineComponent')` |

### 2.5 All Placed Components

| Target | What to Read | How |
|--------|-------------|-----|
| All IPlacedComponent descendants | class name + worldTransform (pos + quat) | iterate `player:GetComponents()`, filter `IsA('IPlacedComponent')` |

---

## 3. Key Experiment

While logging is active, the user does a **mouse-look turn** (yaw only, no movement). We observe which transforms change. That tells us what the renderer reads.

**Procedure:**
1. Enable logging (hotkey)
2. Stand still, face forward — take snapshot A
3. Turn ~90° via mouse-look — take snapshot B
4. Compare A vs B — which transform orientations changed?
5. Log results with `[HoverRotPlayer9_1]` prefix

**Secondary experiment:** Move forward/backward (no turning) — observe which transforms change position but not orientation.

---

## 4. Bone Hierarchy Dump

A one-shot hotkey that prints the full skeleton hierarchy:
- Bone names and parent-child relationships
- Each bone's local + world transform (position + orientation)
- This will be verbose but invaluable for understanding structure
- Log to CET console with `[HoverRotPlayer9_1-BoneDump]` prefix

**Candidates to probe for bone access:**
- `gameHumanoidBody` component
- `entAnimationControllerComponent`
- `AnimatedComponent` (ISkinableComponent)
- `AnimationControllerComponent` static class

---

## 5. Hover PD Controller

Tester 9.1 includes the hover height PD controller from the original plan. This is infrastructure that all subsequent testers will reuse, so it makes sense to build it here.

```lua
HOVER_HEIGHT    = 3.0    -- meters above ground
SPRING_K        = 0.8    -- Kp: stronger spring for lighter entity
DAMPING_K       = 2.0    -- Kd: heavier damping to prevent oscillation
MAX_DV          = 3.0    -- max delta-v per axis per frame
GROUND_RAY_DIST = 50.0   -- max raycast distance
```

- Ground detection: `SyncRaycastByQueryPreset` with "Bullet logic" preset
- Impulse: `PSMImpulse` (translational only — won't interfere with rotation testing)
- Adapted from `hover_vehicle_tester2`

### Hover Hotkeys

| Key | Action |
|-----|--------|
| Hover Toggle | Enable/disable hover height lock |
| Hover Up | Increase target height by 1m |
| Hover Down | Decrease target height by 1m |
| Hover Stop | Disable hover |

---

## 6. Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Logging | Enable/disable periodic transform dump |
| Bone Dump | One-shot full skeleton hierarchy print |
| Snapshot A | Capture current transform state as "before" |
| Snapshot B | Capture current transform state as "after" |
| Compare Snapshots | Log diffs between A and B |
| Hover Toggle | Enable/disable hover height lock |
| Hover Up | Increase target height +1m |
| Hover Down | Decrease target height -1m |
| Hover Stop | Disable hover |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 7. Logging Configuration

- Default log interval: every 60 ticks (~1 second)
- Log prefix: `[HoverRotPlayer9_1]`
- Bone dump prefix: `[HoverRotPlayer9_1-BoneDump]`
- Snapshot prefix: `[HoverRotPlayer9_1-Snap]`
- All logs go to CET console (visible in game overlay or CET console)
- Configurable interval via ImGui panel (slider 10–300 ticks)

---

## 8. ImGui Status Panel

Display:
- Logging active/inactive
- Current log interval
- Snapshot A/B status (taken or not)
- Hover status (active, target height, current height, ground Z)
- Component count (total, placed components count)
- Bone count (if accessible)
- Current player position/orientation
- TweakDB communication stats (if RED4ext plugin loaded)

---

## 9. Architecture

```
hover_rot_tester_player9.1/
├── cet/
│   └── init.lua              # All CET logic: logging, snapshots, hover PD controller, ImGui
├── red4ext/                  # Optional — reuse Tester 8's plugin for entity transform readback
│   ├── src/Main.cpp          # (copy from T8, rename to Player9_1)
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_1.dll
├── redscript/
│   └── HoverRotPlayer9_1.reds  # Bridge (same as Tester 8, renamed)
├── goals1.md                 # Original detailed plan (historical reference)
├── goals - master.md         # Master overview of testing program
├── goals 1 - logging.md        # This file
└── goals N - *.md              # Sub-goal docs for testers 9.2–9.6
```

**Note:** RED4ext plugin is optional for Tester 9.1. If we only do CET-level logging, we can skip it initially and add it later for entity transform readback comparison.

---

## 10. Testing Checklist

### Logging
- [ ] Dumps all player components with class names
- [ ] Identifies which components are IPlacedComponent descendants
- [ ] Dumps worldTransform (pos + quat) for each placed component
- [ ] Attempts skeleton/bone component discovery
- [ ] Logs before/after mouse-look turn to identify render-source transform
- [ ] Logs at configurable interval (default: every 60 ticks)
- [ ] Bone dump hotkey prints full skeleton hierarchy
- [ ] Snapshot A/B capture and compare works

### Hover PD Controller
- [ ] Hover toggle activates height lock at current height + 3m
- [ ] Hover Up/Down adjusts target height in 1m increments
- [ ] No unbounded acceleration — PD controller settles
- [ ] Ground raycast works (logs ground Z and target Z)
- [ ] Hover Stop disables cleanly

### General
- [ ] No crashes during any mode
- [ ] Crash safeguard: modes start inactive on reload
- [ ] All hotkeys appear in Settings > Key Bindings
- [ ] RED4ext plugin loads cleanly (if included)

---

## 11. Questions This Tester Must Answer

1. **Which transform changes on mouse-look turn?** → identifies render-source transform
2. **Can CET enumerate bones on the player skeleton?** → determines if Approach B is viable from Lua
3. **Can CET read/write individual bone transforms?** → determines if C++ hooks are needed for B
4. **What is the bone hierarchy structure?** → identifies root bone, pelvis bone, camera bone
5. **Is the FPP camera a child of the body transform or independent?** → determines camera handling needs
6. **Does `gamestateMachineComponent` expose any useful state/flags?** → informs Approach A hook targeting
7. **Are there any ragdoll-related components?** → confirms/definitively rules out ragdoll path

---

## 12. What This Tester Does NOT Do

- No rotation overrides (that's testers 9.2+)
- No C++ hooks (unless needed for entity transform readback)
- No bone transform writes
- No camera manipulation
- Not expected to produce visible rotation

---

## 13. References

| Source | Path | Relevance |
|--------|------|-----------|
| goals1.md | `testers/hover rotate player/hover_rot_tester_player9.1/goals1.md` | Original detailed plan (historical) |
| goals - master.md | `testers/hover rotate player/hover_rot_tester_player9.1/goals - master.md` | Master testing program overview |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Root cause analysis, 5 approaches |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` | Component architecture |
| VR Mod VRIK | `sources - extra/vr/.../CyberpunkVRPort_VRIK/init.lua` | Bone-level access example |
| Vehicle Hover Tester 2 | `testers/hover rotate vehicle/hover_vehicle_tester2/init.lua` | PD controller reference |
| OKF Component API | `okf/api/components/` | IPlacedComponent, ISkinableComponent, etc. |
| OKF Animation API | `okf/api/animation/` | AnimationControllerComponent, anim features |
