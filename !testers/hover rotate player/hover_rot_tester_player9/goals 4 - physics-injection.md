# Tester 9.4 — Physics Body Injection (Approach C)

> **Strategy:** Add a dynamic rigid body component to the player entity, bypass locomotion  
> **Goal:** Drive player transform via physics forces/torques like vehicles in Let There Be Flight  
> **Prerequisite:** Tester 9.1 logging results (component architecture); Testers 9.2–9.3 results (may make this unnecessary)  
> **Created:** 2026-08-15

---

## 1. Objective

**Add a new `entRigidBodyComponent` (dynamic rigid body) to the player entity and disable or bypass the `gamestateMachineComponent`. The rigid body is driven by forces and torques via the engine's physics simulation, providing full 6DOF rotation and translation.**

This is the most "correct" approach from a game engine perspective but also the most invasive.

---

## 2. Why This Approach

From `docs/c++ hooks/free player manipulation - analysis.md`:
- **Most architecturally correct** — clean physics simulation, natural collision response
- Full 6DOF via standard physics APIs
- **Very High complexity, High risk** — unprecedented in modding
- Likely to break many core systems that assume a kinematic player capsule

This is a **last resort** approach if Testers 9.2–9.3 fail.

---

## 3. What Tester 9.1 Logging Informs

| T9.1 Finding | How It Informs T12 |
|------------|-------------------|
| Full component list (174 components) | Determines what to disable/bypass |
| `gamestateMachineComponent` structure | How to disable it safely |
| Whether any physics-related components exist | Starting point for rigid body addition |
| Player has no `physicsData` (confirmed in T8) | Must create from scratch |
| `CanRagdoll()` returns false | Confirms no existing physics body pathway |

---

## 4. Implementation Plan

### Phase 1: Component Analysis

1. From T9's component dump, identify all physics-related components
2. Identify how `gamestateMachineComponent` drives the transform
3. Study vehicle `physicsData` structure from LTBF mod for reference
4. Determine if `entRigidBodyComponent` can be dynamically added to an existing entity

### Phase 2: Rigid Body Creation

1. Create a `entRigidBodyComponent` with appropriate collision shape (capsule matching player)
2. Set up physics properties: mass, inertia tensor, damping
3. Attach to player entity (may require C++ entity component manipulation)
4. Register with physics system

### Phase 3: Locomotion Bypass

1. Disable or bypass `gamestateMachineComponent` transform updates
2. Option A: `EnableTransformUpdates(false)` — may not fully work (T8 showed it doesn't)
2. Option B: C++ hook to skip locomotion transform write entirely
3. Option C: Remove/replace the component (very risky)

### Phase 4: Physics Driving

1. Apply forces for translation (hover, movement)
2. Apply torques for rotation (pitch, roll, yaw)
3. Use PD controller for hover height (adapt from T9.1, add angular PD controller)
4. Read back transform from rigid body (not entity) for rendering

### Phase 5: CET Integration

1. CET hotkeys for physics mode toggle and rotation/translation control
2. CET writes desired rotation/translation to TweakDB flats
3. C++ reads flats, applies forces/torques to rigid body
4. ImGui status panel showing physics state (velocity, angular velocity, forces)

---

## 5. Architecture

```
hover_rot_tester_player9.4/
├── cet/
│   └── init.lua              # CET: hotkeys, rotation/translation control, hover, ImGui
├── red4ext/
│   ├── src/Main.cpp          # C++: rigid body creation, locomotion bypass, physics driving
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_4.dll
├── redscript/
│   └── HoverRotPlayer9_4.reds # Bridge: native func declarations
└── goals - physics-injection.md # This file
```

---

## 6. Key Technical Details

### Vehicle Physics Reference (from LTBF)

Vehicles have `physicsData` struct with:
- Force/torque application points
- Angular velocity fields
- Mass and inertia properties
- Collision shape definitions

The player has **none** of these. We must create an equivalent from scratch.

### Rigid Body Setup

```cpp
// Pseudocode
auto rigidBody = new RED4ext::ent::RigidBodyComponent();
rigidBody->SetShape(capsuleShape);  // Match player capsule dimensions
rigidBody->SetMass(80.0f);          // Player mass
rigidBody->SetInertiaTensor(...);   // Computed from capsule
rigidBody->SetLinearDamping(0.5f);
rigidBody->SetAngularDamping(2.0f); // Heavy damping for stability
entity->AddComponent(rigidBody);
```

### Force/Torque Application

```cpp
// Translation (hover)
float dvZ = SPRING_K * heightError - DAMPING_K * velocityZ;
rigidBody->AddImpulse(Vector4(0, 0, clamp(dvZ, -MAX_DV, MAX_DV), 0));

// Rotation
torque = angularSpringK * angleError - angularDampingK * angularVelocity;
rigidBody->AddTorque(torque);
```

---

## 7. Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| Adding component to live entity crashes game | Critical | Test on NPC first; backup save |
| Disabling locomotion breaks movement entirely | High | gradual transition; keep locomotion for input processing |
| Physics simulation conflicts with other systems | High | extensive logging; disable non-essential systems |
| Player falls through ground | Medium | Set up collision filters properly; test with raycast ground |
| Other systems read entity transform (not rigid body) | High | May need to sync entity transform from rigid body each frame |
| Animation system breaks | High | May need to disable animation component or override poses |
| Camera doesn't follow rigid body | Medium | Sync camera to rigid body transform |

---

## 8. Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Physics Mode | Enable/disable rigid body driving |
| Pitch Up/Down | Apply pitch torque |
| Roll Left/Right | Apply roll torque |
| Yaw Left/Right | Apply yaw torque |
| Reset Rotation | Zero angular velocity + reset orientation |
| Hover Toggle | Enable/disable hover (from T9.1) |
| Hover Up/Down | Adjust hover height (from T9.1) |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 9. Testing Checklist

- [ ] Rigid body component creates without crash
- [ ] Rigid body attaches to player entity
- [ ] Locomotion bypass works (no transform fighting)
- [ ] Translation forces work (hover)
- [ ] Rotation torques work (visible body rotation)
- [ ] Collision works (player doesn't fall through ground)
- [ ] Camera follows rigid body
- [ ] Animations don't break catastrophically
- [ ] Other game systems still function (menus, inventory, etc.)
- [ ] No crashes during extended use
- [ ] Clean toggle on/off (return to normal locomotion)
- [ ] Crash safeguard: physics mode resets on init

---

## 10. References

| Source | Path | Key Insight |
|--------|------|-------------|
| goals - master.md | `goals - master.md` | Testing program overview |
| goals 1 - logging.md | `goals 1 - logging.md` | T9.1 logging results needed before starting |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Approach C details |
| LTBF C++ Hooks | `docs/c++ hooks/let there be flight - c++ hooks.md` | Vehicle physicsData hook pattern |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` | Component architecture, no physicsData |
| Let There Be Flight | `docs/vehicle flight/let there be flight.md` | Vehicle flight implementation |
| OKF Physics | `okf/codeware/physics.md` | Physics system API |
| RED4ext SDK | `sdk/RED4ext.SDK/` | Entity component manipulation |
