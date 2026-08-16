# HoverRotTesterPlayer9 — Goals & Implementation Plan

> **Status:** Draft for review — not yet committed to implementation  
> **Created:** 2026-08-14  
> **Predecessor:** Tester 8 (plumbing proven, no visual rotation)

---

## 1. Background — Where We Are

Tester 8 proved the full CET → Redscript → RED4ext pipeline works:

| Proven | Not Solved |
|--------|-----------|
| 4,510 ApplyRotation calls, 0 failures | No visible body rotation |
| Quaternion persists in memory (readback confirmed) | Game doesn't render from entity-level worldTransform |
| Native function registration via RTTI | Locomotion system overrides visual orientation |
| Game-native `EulerAngles:ToQuat()` math is correct | Don't know which transform the renderer actually reads |

**The problem is no longer in the communication or write path.** It's in *which transform the game uses for rendering*.

---

## 2. Research Findings

### 2.1 Why Entity-Level worldTransform Doesn't Work

From `docs/c++ hooks/free player manipulation - analysis.md`:

- The player is **locomotion-driven** (like Unity's `CharacterController`), not physics-driven (like a `Rigidbody`)
- `gamestateMachineComponent` processes input → velocity → position and **enforces roll=0, pitch=0 every frame**
- `SetWorldTransform` on the player is a **complete no-op** — locomotion overwrites it immediately
- `EnableTransformUpdates(false)` doesn't help — the orientation clamp is in a different code path
- `Teleport()` only preserves yaw; roll/pitch are clamped to 0
- The player has **no `physicsData` struct** (unlike vehicles) — no force/torque/angularVelocity fields
- `CanRagdoll()` returns **false** for the player — no ragdoll component, no physics ragdoll pathway

### 2.2 VR Mod Approach (CyberpunkVRPort)

The VR mod successfully controls player body parts — but at the **animation/bone level**, not the entity transform level:

| Aspect | What VR Mod Does |
|--------|-----------------|
| **Hook target** | C++ pose-apply function on `entAnimationControllerComponent` |
| **Hook installation** | `Game.InstallVRAnimPoseHook()` (native C++ MinHook detour) |
| **Manipulation level** | Bone transforms — after locomotion computes pose, before render |
| **Locomotion** | Still runs normally — only visual layer is overridden |
| **Body orientation** | Computed from VR tracking → applied to bones |
| **Camera** | `FPPCameraComponent:SetLocalOrientation(quat)` — "the exact path mouse input takes" |
| **Animation control** | `AnimationControllerComponent.SetInputFloat(player, 'sprint', 0.0)` to kill animations |

**Key insight:** The VR mod hooks *downstream* of locomotion — at the animation output stage. Locomotion still runs and thinks the player is upright, but the bone transforms are overridden after the fact. This is the proven path.

**Limitation for our use case:** The VR mod only overrides hands/head. For full 6DOF body rotation, we'd need to override **all body bones** and compute their transforms from a custom quaternion.

### 2.3 Proposed Approaches (from research docs)

The `free player manipulation` doc proposes 5 approaches:

| Approach | Description | Confidence | Complexity |
|----------|-------------|------------|------------|
| **A: Locomotion Hook** | Hook the orientation clamp in `gamestateMachineComponent::OnUpdate()` — skip roll/pitch clamp when flight mode active | High | Medium — need to find exact native function hash |
| **B: Animation Override** | Hook `entAnimationControllerComponent` pose-apply — override all bone transforms with custom quaternion (VR-style but full body) | Medium-High | High — need full-body IK solver |
| **C: Physics Body Injection** | Add a rigid body to the player entity | Low | Very High — engine structural change |
| **D: Workspot** | Custom workspot resource with no animation constraints | Low | Unknown — untested |
| **E: Hybrid** | Combine multiple approaches | — | — |

### 2.4 Ragdoll Investigation

**Finding: Ragdoll is likely a dead end for the player.**

- `ScriptedPuppet.CanRagdoll()` returns **false** for the player
- The player has no ragdoll component (confirmed via component dump — 174 components, none are ragdoll)
- NPCs *can* ragdoll on death, but the player cannot
- The jetpack mod applies impulses to NPCs — it does **not** use ragdoll for the player
- PSMImpulse is **translational only** — no angular/torque field exists

**However:** The question of whether we could *force* a ragdoll state on the player via C++ (bypassing `CanRagdoll()`) remains open. This would be a C++ hook investigation, not a CET one.

### 2.5 Vehicle Hover Height Logic (from `hover_vehicle_tester2`)

The vehicle testers solved unbounded acceleration with a **PD controller**:

```lua
HOVER_HEIGHT  = 6.0    -- meters above ground
SPRING_K      = 0.5    -- Kp: delta-v per meter of position error
DAMPING_K     = 1.5    -- Kd: delta-v per m/s of velocity
MAX_DV        = 5.0    -- clamp per axis per frame
```

- Ground detection: `SyncRaycastByQueryPreset` with "Bullet logic" preset
- Impulse: `PhysicalImpulseEvent` at vehicle center, large radius (5.0)
- Velocity estimation: compare position delta frame-to-frame
- Result: smooth hover at target height without oscillation or flyaway

**This should replace the player testers' crude up/down velocity impulses** that send the player flying uncontrollably.

---

## 3. Goals for Tester 9

### Primary Goal
**Determine which transform/bone/component the game's renderer actually reads for player body orientation, and whether overriding it produces visible rotation.**

### Secondary Goals
1. Implement proper hover height control (PD controller) replacing the crude velocity impulses
2. Add toggleable modes so we can test logging and override independently
3. Investigate bone-level transform access via CET (before committing to C++ hooks)
4. Document the full transform chain from locomotion → animation → bones → render

### What Tester 9 Is NOT
- Not a final implementation — it's a **diagnostic/exploration tester**
- Not committed to any single approach — it should test multiple targets
- Not expected to produce perfect rotation — it should **identify the right target**

---

## 3.1 Developer Thoughts

manipulating ik seems like it's too late

if the player can't ragdoll, but npcs can, then some npc rotation tester may be worthwhile (outside the scope of this player tester series).  the idea is if an npc clone of the player can be created, the player turned invisible and the camera slaved to the clone's head position, then maybe we could rotate the ragdolled clone? -- seems pretty complex, but maybe as a last resort?

if the game's ik solver is allowed to run, is it smart enough to know that the player is in open air?  is it as simple as letting the ik solver calculate all bones, then we apply a translate/rotate of each bone around center of body's position according to the current desired rotation quat?

vr mod modified camera, because it would need to be tied to the user's vr helmet.  but this rotation tester needs to let it be where it normally wants to be.  only manipulate its position/rotation if it is somehow independent of the player's transform.  but I'm hoping that the camera is a child of a parent transform and will just go along for the ride

---

## 4. Architecture — Two-Mode Design

### Mode 1: Logging Only (Default)

Dumps the full transform chain every N ticks so we can see what changes when the player turns normally (mouse look) vs when we apply rotation.

**What to log:**

| Target | What to Read | How |
|--------|-------------|-----|
| Entity worldTransform | position + orientation quaternion | `player:GetWorldPosition()` + `player:GetWorldOrientation()` |
| Entity worldTransform (component-level) | IPlacedComponent worldTransform | `FindComponentByType('entTransformComponent')` or similar |
| FPPCameraComponent | local + world orientation, pitch/yaw limits | `player:GetFPPCameraComponent():GetLocalToWorld()` |
| Animation controller | bone count, bone names, root bone transform | `FindComponentByType('entAnimationControllerComponent')` |
| Skeleton component | bone transforms, root bone, pelvis bone | `FindComponentByType('gameHumanoidBody')` or similar |
| gamestateMachineComponent | current state, EnableTransformUpdates flag | `FindComponentByType('gamestateMachineComponent')` |
| All IPlacedComponent descendants | list all placed components + their worldTransforms | iterate `GetComponents()` |

**Key experiment:** While logging is active, the user does a **mouse-look turn** (yaw). We observe which transforms change. That tells us what the renderer reads.

### Mode 2: Transform Override

Attempts to write rotation to multiple targets simultaneously and logs which ones produce visible rotation.

**Override targets to test (in priority order):**

| Priority | Target | Method | Rationale |
|----------|--------|--------|----------|
| 1 | FPPCameraComponent local orientation | `cam:SetLocalOrientation(quat)` | Known to work for camera — but does it rotate the body? |
| 2 | Entity teleport with full Euler | `TeleportationFacility:Teleport(player, pos, EulerAngles(roll, pitch, yaw))` | Known: yaw sticks, roll/pitch clamped — but log what happens |
| 3 | Skeleton root bone transform | Via animation controller / skeleton component | VR mod hint — bones are what the renderer draws |
| 4 | Animation controller bone override | Direct bone transform write if accessible | VR mod proves this path works |
| 5 | Entity worldTransform (tester 8 method) | C++ native function direct memory write | Known: persists in memory but no visual effect — keep as control |

**Toggle design:**
- Hotkey: **Toggle Logging** — enable/disable periodic dump
- Hotkey: **Toggle Override** — enable/disable transform write attempts
- Hotkey: **Cycle Override Target** — cycle through the 5 targets above
- Both can be active simultaneously (log while overriding)

---

## 5. Hover Height Control — PD Controller

Replace the crude `HoverUp/HoverDown/HoverStop` velocity impulses with a proper height-targeting PD controller, adapted from `hover_vehicle_tester2`:

### Design

```lua
-- Target height mode
HOVER_HEIGHT   = 3.0    -- meters above ground (lower than vehicles — player is smaller)
SPRING_K       = 0.8    -- Kp: stronger spring for lighter entity
DAMPING_K      = 2.0    -- Kd: heavier damping to prevent oscillation
MAX_DV         = 3.0    -- max delta-v per axis per frame (lower for player safety)
GROUND_RAY_DIST = 50.0  -- max raycast distance
```

### Implementation

1. **Ground detection:** `SyncRaycastByQueryPreset` downward raycast from player position
2. **Position error:** `error = targetZ - currentZ` where `targetZ = groundZ + HOVER_HEIGHT`
3. **Velocity estimate:** `(currentZ - prevZ) / dt` — frame-to-frame delta
4. **PD output:** `dvZ = SPRING_K * error - DAMPING_K * velocityZ`
5. **Clamp:** `dvZ = clamp(dvZ, -MAX_DV, MAX_DV)`
6. **Apply:** `PSMImpulse` with `impulse = Vector4(0, 0, dvZ, 0)` via `QueueEvent`

### Hotkeys

| Key | Action |
|-----|--------|
| Hover Toggle | Enable/disable hover height lock |
| Hover Up | Increase target height by 1m |
| Hover Down | Decrease target height by 1m |
| Hover Stop | Disable hover (same as toggle off) |

**Note:** PSMImpulse is translational only (no torque). This means hover won't interfere with rotation testing — the two systems are independent.

---

## 6. Key Questions to Resolve

### Q1: Which transform does the renderer read?

This is **the** question. Tester 9's logging mode is designed to answer it.

**Hypothesis:** The renderer reads bone transforms from the skeleton/animation system, not the entity-level worldTransform. Evidence:
- VR mod overrides bones and it works
- Tester 8 wrote entity worldTransform and it didn't
- The player's visual appearance is driven by the skinned mesh (`AnimatedComponent`), which reads from bones

**Experiment to confirm:** While logging all transforms, have the user do a mouse-look turn. Observe which transform's orientation quaternion changes. That's the render-source transform.

### Q2: Can we access bone transforms from CET?

The VR mod does it from C++. The question is whether CET can:
- Enumerate bones on the player skeleton
- Read individual bone transforms (position + orientation)
- Write individual bone transforms

**Candidates to probe:**
- `gameHumanoidBody` component — may expose skeleton/bone access
- `entAnimationControllerComponent` — may expose bone transform array
- `AnimatedComponent` (ISkinableComponent) — may expose skinned mesh bones
- `AnimationControllerComponent` (CET static class) — has `SetInputFloat`, may have bone methods

### Q3: Is the root bone or pelvis the right target?

If bone-level access works, which bone do we rotate?

- **Root bone** — typically the top of the skeleton hierarchy; rotating it should rotate everything below
- **Pelvis bone** — often the first animated bone; may be the actual driver of body orientation
- **Multiple bones** — may need to rotate root + adjust camera separately

The logging mode should dump the bone hierarchy so we can see the structure.

### Q4: Should we hook locomotion (Approach A) or override bones (Approach B)?

| Factor | Locomotion Hook (A) | Bone Override (B) |
|--------|---------------------|-------------------|
| Proven? | No (theoretical) | Yes (VR mod does it for hands) |
| Complexity | Medium — find + detour one function | High — need full-body bone override |
| Collision | Would rotate collision capsule | Capsule stays upright |
| Animation | Would need to suppress fighting animations | Locomotion runs normally, only visual override |
| Camera | Camera is child of body — should follow | Camera may need separate handling |

**Recommendation:** Start with **bone override (B)** because it's proven by the VR mod. If bone access from CET is insufficient, move to C++ hooks.

### Q5: Is ragdoll worth investigating?

**Probably not** for the player. `CanRagdoll()=false`, no ragdoll component, and the jetpack mod doesn't use ragdoll for the player. However, if we want to confirm this definitively, the logging mode can dump whether any ragdoll-related components exist.

**For NPCs:** Ragdoll may be viable — NPCs can ragdoll on death, and the jetpack mod sends them flying. But our goal is player rotation, not NPC.

---

## 7. Implementation Plan

### Phase 1: CET-Only Diagnostic (No C++)

Build the logging + override tester entirely in CET Lua, reusing the RED4ext C++ plugin from Tester 8 only for the entity worldTransform write (as a control baseline).

**Files:**
```
hover_rot_tester_player9/
├── cet/
│   └── init.lua              # All CET logic: logging, override, hover PD controller
├── red4ext/                  # Reuse Tester 8's plugin (copy as-is)
│   ├── src/Main.cpp
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9.dll
├── redscript/
│   └── HoverRotPlayer9.reds  # Bridge (same as Tester 8, renamed)
└── GOALS.md                  # This file
```

### Phase 2: Component & Bone Discovery

The logging mode will:

1. **Dump all components** on the player entity:
   ```lua
   for _, comp in ipairs(player:GetComponents()) do
       print(comp:GetClassName(), comp:IsA('IPlacedComponent'))
   end
   ```

2. **For each IPlacedComponent**, dump its worldTransform (position + orientation)

3. **Attempt bone access** on skeleton/animation components:
   - Try `FindComponentByType('gameHumanoidBody')` → dump methods/fields
   - Try `FindComponentByType('entAnimationControllerComponent')` → dump methods/fields
   - Try `AnimationControllerComponent` static methods → look for bone-related APIs

4. **Snapshot before/after mouse-look turn** to identify which transform changes

### Phase 3: Override Experiments

Based on Phase 2 findings, attempt rotation writes to the most promising targets.

### Phase 4: C++ Hook (If Needed)

If CET can't access bone transforms, extend the RED4ext C++ plugin to:
- Enumerate bones on the player skeleton
- Read/write individual bone transforms
- Or hook the locomotion orientation clamp (Approach A)

---

## 8. What to Reuse from Tester 8

| Component | Reuse? | Changes |
|-----------|--------|--------|
| RED4ext C++ plugin (Main.cpp) | Yes (copy) | Rename to Player9, keep ApplyRotation/GetStatus/ReadPlayerOrientation |
| Redscript bridge | Yes (copy) | Rename to HoverRotPlayer9 |
| CET quaternion math | Yes | Keep `EulerAngles.new(roll, pitch, yaw):ToQuat()` |
| CET hotkey registration | Yes | Add new hotkeys for logging/override toggles |
| CET ImGui status panel | Yes | Extend with bone/component dump display |
| CET tick logging | Yes | Extend with component transform dump |
| Hover impulse (PSMImpulse) | **Replace** | Swap crude velocity for PD controller |

---

## 9. Testing Checklist

### Logging Mode
- [ ] Dumps all player components with class names
- [ ] Identifies which components are IPlacedComponent descendants
- [ ] Dumps worldTransform (pos + quat) for each placed component
- [ ] Attempts skeleton/bone component discovery
- [ ] Logs before/after mouse-look turn to identify render-source transform
- [ ] Logs at configurable interval (default: every 60 ticks)

### Override Mode
- [ ] Can cycle through 5 override targets
- [ ] Logs which target is active and whether write succeeded
- [ ] FPPCameraComponent override produces camera rotation (control test)
- [ ] Entity worldTransform override persists but no visual effect (control test — confirms Tester 8)
- [ ] Bone/skeleton override attempted and result logged

### Hover PD Controller
- [ ] Hover toggle activates height lock at current height + 3m
- [ ] Hover Up/Down adjusts target height in 1m increments
- [ ] No unbounded acceleration — PD controller settles
- [ ] Ground raycast works (logs ground Z and target Z)
- [ ] Hover Stop disables cleanly

### General
- [ ] No crashes during any mode
- [ ] Crash safeguard: mode starts inactive on reload
- [ ] All hotkeys appear in Settings > Key Bindings
- [ ] RED4ext plugin loads cleanly (check RED4ext log)

---

## 10. Open Questions for Discussion

1. **Should we skip C++ entirely for Phase 1?** The logging and most override experiments can be done in CET. C++ is only needed if bone access isn't available from Lua.

2. **Should we include a "bone dump" hotkey** that prints the full skeleton hierarchy? This would be very verbose but invaluable for understanding the bone structure.

3. **Should we test on NPCs first?** NPCs have ragdoll, may have different bone access, and could be easier test subjects. But the goal is player rotation, so NPC testing might be a detour.

4. **Do we need the RED4ext plugin at all for Phase 1?** If we're only doing CET-level logging and override experiments, the plugin from Tester 8 is only needed for the entity worldTransform control test. We could skip it initially and add it later.

5. **Should the hover PD controller use PSMImpulse or teleport?** PSMImpulse is physics-based and smooth but translational only. Teleport is instant and can set full orientation but may fight with locomotion. For hover alone (no rotation), PSMImpulse is probably better.

6. **Camera handling:** If we successfully rotate the body via bones, does the FPP camera follow automatically (as Tester 8's README assumed), or do we need to rotate the camera separately? The VR mod handles camera via `SetLocalOrientation` — we may need the same.

---

## 11. References

| Source | Path | Key Insight |
|--------|------|-------------|
| Tester 8 Log Summary | `testers/hover rotate player/hover_rot_tester_player8/log summary.md` | Entity worldTransform write succeeds but no visual effect |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | 5 proposed approaches; root cause = locomotion clamp |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` | 174 components; no ragdoll; no physicsData; component architecture |
| Rotation Research Report | `docs/rotations/rotation_orientation_research_report.md` | EulerAngles.new(roll, pitch, yaw) confirmed; Quaternion.new(x,y,z,w) |
| VR Mod VRIK | `sources - extra/vr/.../CyberpunkVRPort_VRIK/init.lua` | Bone-level pose hooks work; camera via SetLocalOrientation |
| VR Mod NoAnims | `sources - extra/vr/.../CyberpunkVRPort_NoAnims/vrport_no_anims.reds` | Animation feature overrides; sprint kill; camera bob kill |
| Vehicle Hover Tester 2 | `testers/hover rotate vehicle/hover_vehicle_tester2/init.lua` | PD controller for height; raycast ground detection; impulse clamping |
| LTBF C++ Hooks | `docs/c++ hooks/let there be flight - c++ hooks.md` | Vehicle physics hook pattern (RTTI + MinHook + physicsData) |
| VR Mod C++ Hooks | `docs/c++ hooks/cyberpunk vr port - c++ hooks.md` | Pose-apply detour; bone transform write via entAnimationControllerComponent |
