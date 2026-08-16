# Tester 9.3 — Animation Override (Approach B)

> **Strategy:** VR-style full-body bone transform override via animation pose hook  
> **Goal:** Override all body bone transforms with custom quaternion after locomotion computes pose, before render  
> **Prerequisite:** Tester 9.1 logging results (bone hierarchy, bone access from CET)  
> **Created:** 2026-08-15

---

## 1. Objective

**Hook the pose-apply function on `entAnimationControllerComponent` (as the VR mod does) and override all body bone transforms with values computed from a custom 6DOF quaternion. Locomotion continues to run normally underneath — only the visual bone layer is overridden.**

This is the proven path: the Cyberpunk VR Port mod successfully controls player body parts at the bone level. Tester 11 extends this from hands-only to full-body.

---

## 2. Why This Approach

From `docs/c++ hooks/free player manipulation - analysis.md` and VR mod analysis:
- **Proven by VR mod** — bone-level pose hooks work for hands/head
- Locomotion runs normally — only visual layer overridden
- Collision capsule stays upright — no geometry issues
- Medium-High confidence, High complexity (need full-body bone override + IK)

---

## 3. What Tester 9.1 Logging Informs

| T9.1 Finding | How It Informs T9.3 |
|------------|-------------------|
| Bone hierarchy structure | Determines which bones to override and in what order |
| Whether CET can access bone transforms | If yes, may not need C++ for initial tests |
| Root bone vs pelvis bone identification | Determines primary rotation target |
| Camera bone relationship | Determines if camera needs separate bone override |
| Bone count and naming | Determines scope of full-body override |
| `entAnimationControllerComponent` methods/fields | Determines hook target and API surface |

---

## 4. Implementation Plan

### Phase 1: CET Bone Access Probe (if T9.1 shows it's possible)

Before committing to C++ hooks, test if CET can:
1. Enumerate bones via `entAnimationControllerComponent` or `gameHumanoidBody`
2. Read individual bone transforms (position + orientation)
3. Write individual bone transforms

If CET write works → implement override in Lua (simpler)
If CET read-only or no access → proceed to C++ hook (Phase 2)

### Phase 2: C++ Pose-Apply Hook

Follow VR mod pattern:
1. Hook `entAnimationControllerComponent` pose-apply function via MinHook
2. After normal animation pose computation, intercept before render
3. Read custom quaternion from mod state (TweakDB flat or shared memory)
4. Compute full-body bone transforms from custom quaternion:
   - Root/pelvis bone gets the full rotation
   - Child bones inherit via hierarchy (or explicit transforms if needed)
5. Write overridden bone transforms
6. Let render proceed with overridden transforms

### Phase 3: Full-Body IK Solver

The VR mod uses a Two-Bone IK solver for arms. For full-body rotation:
- Option A: **Simple hierarchy rotation** — rotate root bone, let child bones follow naturally (simplest)
- Option B: **Per-bone explicit transforms** — compute each bone's transform from the custom quaternion (more control, more complex)
- Option C: **Hybrid** — rotate root + pelvis, let IK solver handle limbs

Start with Option A (simplest) and increase complexity only if needed.

### Phase 4: CET Integration

1. CET hotkeys for rotation control and override toggle
2. CET computes quaternion and writes to TweakDB flats
3. CET hover PD controller (reuse from T9.1)
4. Animation feature suppression (if animations fight the override):
   - `AnimationControllerComponent.SetInputFloat(player, 'sprint', 0.0)` — kill sprint anims
   - Similar for other locomotion-driven animations (from VR mod NoAnims pattern)
5. ImGui status panel

---

## 5. Architecture

```
hover_rot_tester_player9.3/
├── cet/
│   └── init.lua              # CET: hotkeys, rotation, hover, animation suppression, ImGui
├── red4ext/
│   ├── src/Main.cpp          # C++: pose-apply hook, bone transform override
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_3.dll
├── redscript/
│   └── HoverRotPlayer9_3.reds # Bridge: native func declarations, animation control
└── goals - animation-override.md # This file
```

---

## 6. Key Technical Details

### VR Mod Pattern (reference)

| Aspect | VR Mod Does | T9.3 Extends To |
|--------|-------------|----------------|
| Hook target | `entAnimationControllerComponent` pose-apply | Same |
| Hook installation | `Game.InstallVRAnimPoseHook()` (native C++ MinHook) | RED4ext SDK hooking |
| Manipulation | Bone transforms (hands/head only) | All body bones |
| IK solver | Two-Bone IK for arms from hand tracking | Full-body from custom quaternion |
| Animation suppression | `SetInputFloat(player, 'sprint', 0.0)` | Same pattern, more features |
| Camera | `FPPCameraComponent:SetLocalOrientation(quat)` | May need same |

### Camera Handling

The VR mod handles camera via `FPPCameraComponent:SetLocalOrientation(quat)`. For T9.3:
- If camera bone is part of the skeleton hierarchy, rotating root bone may handle it
- If camera is independent, need separate `SetLocalOrientation` call
- T9.1 logging should clarify this relationship

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Full-body IK is complex | Start with simple root-bone rotation hierarchy |
| Animations fight the override | Suppress animation features (VR mod pattern) |
| Camera doesn't follow | Separate `SetLocalOrientation` call |
| Collision capsule stays upright (player can't tilt through gaps) | This is actually a feature, not a bug |
| Performance impact of per-bone override | Profile; may need to optimize bone update frequency |
| Bone access from CET insufficient | Fall back to C++ hook (expected) |

---

## 8. Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Override | Enable/disable bone transform override |
| Pitch Up/Down | Adjust pitch angle |
| Roll Left/Right | Adjust roll angle |
| Yaw Left/Right | Adjust yaw angle |
| Reset Rotation | Set roll/pitch/yaw to 0 |
| Toggle Anim Suppress | Enable/disable animation feature suppression |
| Hover Toggle | Enable/disable hover (from T9.1) |
| Hover Up/Down | Adjust hover height (from T9.1) |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 9. Testing Checklist

- [ ] CET bone access probed (if T9.1 shows promise)
- [ ] C++ pose-apply hook installs without crash
- [ ] Simple root-bone rotation produces visible body rotation
- [ ] Full-body bones rotate correctly (no detached limbs)
- [ ] Camera follows body rotation (or handled separately)
- [ ] Animation suppression works (no fighting animations)
- [ ] Collision capsule stays upright (no geometry issues)
- [ ] Hover works alongside rotation (no interference)
- [ ] No crashes during extended use
- [ ] Clean toggle on/off
- [ ] Crash safeguard: override resets on init
- [ ] All hotkeys appear in Settings > Key Bindings

---

## 10. References

| Source | Path | Key Insight |
|--------|------|-------------|
| goals - master.md | `goals - master.md` | Testing program overview |
| goals 1 - logging.md | `goals 1 - logging.md` | T9.1 logging results needed before starting |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Approach B details |
| VR Mod C++ Hooks | `docs/c++ hooks/cyberpunk vr port - c++ hooks.md` | Pose-apply detour pattern |
| VR Mod VRIK | `sources - extra/vr/.../CyberpunkVRPort_VRIK/init.lua` | Bone-level pose hook implementation |
| VR Mod NoAnims | `sources - extra/vr/.../CyberpunkVRPort_NoAnims/vrport_no_anims.reds` | Animation suppression pattern |
| OKF Animation API | `okf/api/animation/` | AnimationControllerComponent, anim features |
| OKF Components | `okf/api/components/` | ISkinableComponent, IPlacedComponent |
