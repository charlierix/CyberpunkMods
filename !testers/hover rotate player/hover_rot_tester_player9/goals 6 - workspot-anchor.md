# Tester 9.6 — Custom Workspot with Dynamic Anchor (Approach E)

> **Strategy:** Create a custom workspot resource with no animation constraints, update anchor transform every frame  
> **Goal:** Player enters workspot, workspot repositions player to match dynamically-updated anchor transform  
> **Prerequisite:** Tester 9.1 logging results; may be tried if Testers 9.2–9.5 fail or show partial success  
> **Created:** 2026-08-15

---

## 1. Objective

**Create a custom workspot resource with no animation constraints. The player enters this workspot, and every frame the workspot's anchor world transform (position + full quaternion rotation) is dynamically updated. The workspot repositions the player to match the new anchor transform.**

Workspots are designed to take over player control, which makes them lower-risk than fighting the locomotion system directly. However, they typically expect pre-recorded animations and static anchor points — dynamic 6DOF transforms are untested.

---

## 2. Why This Approach

From `docs/c++ hooks/free player manipulation - analysis.md`:
- Uses existing engine systems (workspot framework)
- Medium complexity and risk
- Partial 6DOF potential
- Dynamic transforms may fail due to workspot system's reliance on fixed poses
- Untested — no known mod does this

---

## 3. What Tester 9.1 Logging Informs

| T9.1 Finding | How It Informs T14 |
|------------|-------------------|
| Camera behavior during workspot entry | Determines if camera follows workspot or needs override |
| Player transform relationship during workspot | May reveal if workspot directly sets player transform |
| Animation state transitions | Shows what animations play during workspot entry/exit |
| Component behavior during forced states | May reveal if locomotion is fully bypassed in workspot |

---

## 4. Implementation Plan

### Phase 1: Workspot Research

1. Study existing workspot resources in game files (decompile with WolvenKit)
2. Understand workspot `.workspot` file format
3. Identify how to create a custom workspot with:
   - No animation constraints (or minimal)
   - Dynamic anchor support (if possible)
   - Player entry/exit handling
4. Study workspot examples in `sources - extra/workspots/`

### Phase 2: Custom Workspot Creation

1. Create `.workspot` resource with WolvenKit
2. Set up workspot with:
   - Empty or minimal animation
   - Anchor point at origin
   - Player entry node
3. Package as mod (archive file)
4. Load via CET or Redscript

### Phase 3: Dynamic Anchor Update

1. Enter workspot (CET or Redscript trigger)
2. Every frame, update workspot anchor transform:
   - Position: player position (or hover-controlled position)
   - Orientation: custom quaternion (roll, pitch, yaw)
3. Verify player follows anchor transform
4. Test camera behavior — does FPP camera follow anchor orientation?

### Phase 4: CET Integration

1. CET hotkeys for workspot enter/exit and rotation control
2. CET writes desired rotation/position to TweakDB flats or direct API
3. Redscript or C++ updates workspot anchor each frame
4. Hover PD controller (reuse from T9.1)
5. ImGui status panel

---

## 5. Architecture

```
hover_rot_tester_player9.6/
├── cet/
│   └── init.lua              # CET: hotkeys, rotation, hover, workspot control, ImGui
├── red4ext/   ├── src/Main.cpp          # C++: workspot anchor update (if needed at native level)
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_6.dll
├── redscript/
│   └── HoverRotPlayer9_6.reds # Bridge: workspot entry/exit, anchor update
├── archive/
│   └── base\\workspots\\...    # Custom .workspot resource file
└── goals - workspot-anchor.md # This file
```

---

## 6. Key Technical Details

### Workspot File Format

Workspots are JSON-like resources (`.workspot` files) that define:
- Animation nodes and transitions
- Anchor points (world transforms)
- Entry/exit conditions
- Player control overrides

### Dynamic Anchor Challenge

The main unknown is whether the workspot system supports **dynamic** anchor updates:
- Workspots typically use static anchor points defined in the resource
- We need to update the anchor's world transform every frame
- This may require C++ hook on the workspot update function
- Or it may be possible via Redscript if the workspot API exposes anchor manipulation

### Workspot Entry

```lua
-- Enter workspot (conceptual)
local workspotResource = LoadResource('base\\workspots\\hover_rot_tester.workspot')
Game.GetWorkspotSystem():StartWorkspot(workspotResource, player)
```

### Anchor Update (conceptual)

```lua
-- Every frame, update anchor
local anchor = workspot:GetAnchor()
anchor:SetWorldPosition(playerPos)
anchor:SetWorldOrientation(customQuat)
```

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Dynamic anchor updates not supported | May need C++ hook on workspot update; or this approach fails |
| Camera doesn't follow anchor orientation | Override camera with `SetLocalOrientation` |
| Player actions restricted in workspot | Accept limitation; or find workspot with free action set |
| Workspot entry/exit is janky | Smooth transition; test with safe positions |
| Custom workspot file format incorrect | Study existing workspots carefully; validate with WolvenKit |
| Animations override our transform | Create workspot with no/minimal animation nodes |

---

## 8. Hotkeys

| Hotkey | Action |
|--------|--------|
| Enter Workspot | Start custom workspot |
| Exit Workspot | End workspot, return player to normal |
| Toggle Flight Mode | Enable/disable dynamic anchor rotation |
| Pitch Up/Down | Adjust pitch angle |
| Roll Left/Right | Adjust roll angle |
| Yaw Left/Right | Adjust yaw angle |
| Reset Rotation | Set roll/pitch/yaw to 0 |
| Hover Toggle | Enable/disable hover (from T9.1) |
| Hover Up/Down | Adjust hover height (from T9.1) |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 9. Testing Checklist

- [ ] Custom workspot resource created and validated
- [ ] Workspot loads in game without errors
- [ ] Player enters workspot successfully
- [ ] Dynamic anchor update mechanism works (Redscript or C++)
- [ ] Player follows anchor transform (position + rotation)
- [ ] Camera behavior documented (follows or needs override)
- [ ] Hover works alongside workspot
- [ ] Player exits workspot cleanly
- [ ] No crashes during enter/exit cycle
- [ ] Crash safeguard: exit workspot on init if active
- [ ] All hotkeys appear in Settings > Key Bindings

---

## 10. Limitations

- Player is in a workspot state — actions may be restricted
- Dynamic anchor support is untested — may not work at all
- Partial 6DOF (may get position + yaw but not roll/pitch)
- Requires custom resource file creation (WolvenKit workflow)
- No known mod does this — entirely unexplored territory

---

## 11. References

| Source | Path | Key Insight |
|--------|------|-------------|
| goals - master.md | `goals - master.md` | Testing program overview |
| goals 1 - logging.md | `goals 1 - logging.md` | T9.1 logging results needed before starting |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Approach E details |
| Workspot sources | `sources - extra/workspots/` | Workspot examples |
| OKF Player | `okf/mods_red4ext/player/` | Player lifecycle hooks |
| OKF WolvenKit | `okf/wolvenkit/` | Resource file creation |
| OKF State Machines | `okf/api/state-machines/` | Workspot state machine types |
