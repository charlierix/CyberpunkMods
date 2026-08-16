# Tester 9.2 — Locomotion Hook (Approach A)

> **Strategy:** Hook the locomotion state machine's orientation clamp in C++  
> **Goal:** Skip roll/pitch enforcement when flight mode active, write custom 6DOF quaternion to transform  
> **Prerequisite:** Tester 9.1 logging results (need to know hook target function)  
> **Created:** 2026-08-15

---

## 1. Objective

**Hook `gamestateMachineComponent::OnUpdate()` (or its orientation clamp sub-function) via RED4ext C++ detour. When a global "flight mode" flag is active, skip the engine's roll/pitch clamp and write a custom quaternion directly to the `entTransformComponent`. When flight mode is inactive, the original locomotion clamp runs normally.**

This directly addresses the root cause: the locomotion system's per-frame orientation enforcement.

---

## 2. Why This Approach

From `docs/c++ hooks/free player manipulation - analysis.md`:
- **Primary recommendation** — most architecturally clean solution
- Directly addresses root cause (orientation clamp)
- Full 6DOF rotation while retaining original collision geometry
- Medium complexity: need to find exact native function hash via RTTI scan

---

## 3. What Tester 9.1 Logging Informs

| T9.1 Finding | How It Informs T9.2 |
|------------|-------------------|
| Which `gamestateMachineComponent` methods/fields are accessible | Determines hook target |
| Whether entity transform is the render-source | If yes, writing to it after clamp-skip should work |
| Current state machine states | May need to hook per-state or globally |
| `EnableTransformUpdates` flag behavior | May be useful as a secondary control |
| Component dump showing state machine internals | RTTI type info for hook targeting |

---

## 4. Implementation Plan

### Phase 1: RTTI Scan & Hook Target Identification

1. Use RED4ext RTTI scanner to find `gamestateMachineComponent::OnUpdate()` function hash
2. Alternatively, scan for orientation clamp sub-function (may be a separate function)
3. Identify parameter signatures and calling convention
4. Log the function's normal behavior (what orientation values it writes)

### Phase 2: MinHook Detour Installation

1. Install detour on the identified function via RED4ext v1 SDK hooking API:
   ```cpp
   aSdk->hooking->Add<FunctionType>(CName("gamestateMachineComponent::OnUpdate"), &Hook_OnUpdate);
   ```
2. Global flight mode flag (TweakDB flat or shared memory): `HoverRotPlayer9_2_flightMode` (Int32)
3. When `flightMode == 1`:
   - Skip the original orientation clamp call
   - Write custom quaternion to `entTransformComponent->worldTransform.Orientation`
4. When `flightMode == 0`:
   - Call original function normally (pass-through)

### Phase 3: CET Integration

1. CET hotkeys for flight mode toggle and rotation control
2. CET computes quaternion: `EulerAngles.new(roll, pitch, yaw):ToQuat()`
3. CET writes rotation values to TweakDB flats (reuse T7b pattern with explicit types)
4. CET hover PD controller (reuse from T9.1)
5. ImGui status panel showing hook status, flight mode, current rotation

### Phase 4: Incremental Testing

1. Start with small rotation ranges (±5° roll/pitch) to verify the hook works
2. Gradually increase to full 6DOF
3. Test collision behavior — does the capsule rotate with the body?
4. Test camera following — does FPP camera rotate with body or need separate handling?
5. Test animation fighting — do animations try to correct the body?

---

## 5. Architecture

```
hover_rot_tester_player9.2/
├── cet/
│   └── init.lua              # CET: hotkeys, rotation control, hover, ImGui, logging
├── red4ext/
│   ├── src/Main.cpp          # C++: RTTI scan, MinHook detour, flight mode logic
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_2.dll
├── redscript/
│   └── HoverRotPlayer9_2.reds # Bridge: native func declarations, system registration
└── goals - locomotion-hook.md # This file
```

---

## 6. Key Technical Details

### Hook Target
- `gamestateMachineComponent::OnUpdate()` — the per-frame update that enforces roll=0, pitch=0
- May need to hook a sub-function if the clamp is in a separate method
- RTTI scan via `CRTTISystem::Get()->GetFunction(CName(...))`

### Transform Write
```cpp
// After skipping clamp, write custom quaternion
auto entity = reinterpret_cast<RED4ext::ent::Entity*>(playerHandle.instance);
// Offset 0xB0: IPlacedComponent* transformComponent (verified in T8)
// Offset 0xE0: WorldTransform worldTransform
// Offset 0x10: Quaternion Orientation (i, j, k, r)
entity->transformComponent->worldTransform.Orientation = customQuat;
```

### Flight Mode Toggle
- CET writes `HoverRotPlayer9_2_flightMode` to TweakDB (Int32, explicit type)
- C++ hook reads this flat each frame
- `flightMode == 0` → original behavior (pass-through)
- `flightMode == 1` → skip clamp, write custom rotation

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Wrong function hooked → crash | RTTI scan + extensive logging before detour |
| Collision capsule rotates → player stuck in geometry | Test with small angles first; may need to keep capsule upright |
| Animations fight the rotation | May need to suppress animation feature overrides (like VR mod does) |
| Camera doesn't follow body | Test if camera is child of body transform; handle separately if needed |
| Game crash when flight mode toggles mid-action | Disable on vehicle entry, workspots, scenes; reset on init |

---

## 8. Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Flight Mode | Enable/disable 6DOF rotation override |
| Pitch Up/Down | Adjust pitch angle |
| Roll Left/Right | Adjust roll angle |
| Yaw Left/Right | Adjust yaw angle (separate from mouse-look) |
| Reset Rotation | Set roll/pitch/yaw to 0 |
| Hover Toggle | Enable/disable hover (from T9.1) |
| Hover Up/Down | Adjust hover height (from T9.1) |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 9. Testing Checklist

- [ ] RTTI scan finds `gamestateMachineComponent::OnUpdate()` or equivalent
- [ ] Hook installs without crash
- [ ] Flight mode pass-through works (flightMode=0 → normal gameplay)
- [ ] Small rotation (±5°) produces visible body rotation
- [ ] Full 6DOF rotation works
- [ ] Collision behavior documented (capsule rotates or stays upright)
- [ ] Camera behavior documented (follows body or needs separate handling)
- [ ] Animations behavior documented (fight rotation or comply)
- [ ] No crashes during extended use
- [ ] Clean toggle on/off (no residual state)
- [ ] Crash safeguard: flight mode resets to 0 on init
- [ ] All hotkeys appear in Settings > Key Bindings

---

## 10. References

| Source | Path | Key Insight |
|--------|------|-------------|
| goals - master.md | `goals - master.md` | Testing program overview |
| goals 1 - logging.md | `goals 1 - logging.md` | T9.1 logging results needed before starting |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Approach A details |
| LTBF C++ Hooks | `docs/c++ hooks/let there be flight - c++ hooks.md` | RTTI + MinHook pattern |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` | State machine component details |
| RED4ext SDK | `sdk/RED4ext.SDK/` | Hooking API, RTTI system |
| OKF Player | `okf/mods_red4ext/player/` | Player-related native functions |
| OKF State Machines | `okf/api/state-machines/` | State machine types and events |
