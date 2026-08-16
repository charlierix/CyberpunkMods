# Tester 9.5 — Workspot Vehicle Hybrid (Approach D)

> **Strategy:** Spawn invisible vehicle, mount player to it, manipulate vehicle transform  
> **Goal:** Player follows invisible vehicle's 6DOF rotation via existing proven vehicle APIs  
> **Prerequisite:** Tester 9.1 logging results (camera behavior); may be tried if Tester 9.2 fails  
> **Created:** 2026-08-15

---

## 1. Objective

**Spawn an invisible vehicle entity and mount the player to it via `gamePuppetMountableComponent`. Since vehicle transforms can be manipulated using existing working APIs (Teleport, SetWorldTransform, physicsData), the player simply follows the invisible vehicle's 6DOF rotation and translation.**

This is the recommended fallback if Approach A (locomotion hook) fails. It uses proven vehicle APIs rather than fighting the locomotion system.

---

## 2. Why This Approach

From `docs/c++ hooks/free player manipulation - analysis.md`:
- **Low complexity, low risk** — uses existing proven vehicle APIs
- Vehicle rotation/translation is solved (LTBF mod, vehicle testers)
- Player mounting is an engine-supported feature
- Feels hacky but is pragmatic

---

## 3. What Tester 9.1 Logging Informs

| T9.1 Finding | How It Informs T13 |
|------------|-------------------|
| Camera relationship to player transform | Determines if camera follows mount or needs adjustment |
| FPPCameraComponent behavior during mounted state | May need override if camera locks to vehicle |
| Player component list (mountable component?) | Confirms mounting capability |
| Animation state during forced mount | Determines if animations need suppression |

---

## 4. Implementation Plan

### Phase 1: Vehicle Selection & Spawning

1. Choose a vehicle with suitable properties:
   - Small collision footprint (player-sized or smaller)
   - Simple physics model
   - Can be made invisible (material swap or alpha=0)
2. Spawn vehicle at player position via `exEntitySpawner` or `DynamicEntitySpec`
3. Make vehicle invisible (visual only — collision can remain)
4. Disable vehicle AI/drivers

### Phase 2: Player Mounting

1. Mount player to vehicle via `gamePuppetMountableComponent`
2. Verify player follows vehicle transform
3. Test camera behavior in mounted state:
   - Does FPP camera follow vehicle orientation?
   - Does camera need separate handling?
4. Document what player actions are available while mounted

### Phase 3: Vehicle Transform Manipulation

1. Apply 6DOF rotation to vehicle:
   - Option A: `Teleport(vehicle, pos, EulerAngles(roll, pitch, yaw))` — may work for vehicles
   - Option B: Vehicle `physicsData` hook (LTBF pattern) — forces/torques
   - Option C: `SetWorldTransform` — may work for vehicles (unlike player)
2. Apply hover height control to vehicle (PD controller from T9.1, adapted)
3. Test incremental rotation ranges

### Phase 4: CET Integration

1. CET hotkeys for mount/unmount, rotation control, hover
2. CET controls vehicle transform (via TweakDB flats to C++ or direct API)
3. ImGui status panel showing vehicle + player state
4. Camera handling if needed

---

## 5. Architecture

```
hover_rot_tester_player9.5/
├── cet/
│   └── init.lua              # CET: hotkeys, spawn/mount, rotation, hover, ImGui
├── red4ext/   ├── src/Main.cpp          # C++: vehicle physics hook (if using physicsData approach)
│   ├── CMakeLists.txt
│   └── bin/HoverRotTesterPlayer9_5.dll
├── redscript/
│   └── HoverRotPlayer9_5.reds # Bridge: mounting, vehicle spawn, transform control
└── goals - workspot-vehicle.md # This file
```

---

## 6. Key Technical Details

### Vehicle Spawning

```lua
-- Spawn invisible vehicle at player position
local playerPos = player:GetWorldPosition()
local transform = Transform.new(playerPos, EulerAngles.new(0, 0, 0):ToQuat())
exEntitySpawner.Spawn('base\\vehicles\\...__basic.ent', transform, '')
```

### Player Mounting

```lua
-- Mount player to vehicle
local mountable = vehicle:FindComponentByType('gamePuppetMountableComponent')
-- or use engine mounting API
```

### Vehicle Transform Control

Vehicles support `SetWorldTransform` and `Teleport` with full Euler angles (unlike the player). The vehicle testers and LTBF mod prove this path works.

---

## 7. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Player can't perform normal actions while mounted | Accept limitation or find workspot with free action set |
| Camera locks to vehicle orientation | Override camera with `SetLocalOrientation` |
| Vehicle collision is wrong shape | Choose vehicle with small footprint; or disable vehicle collision |
| Vehicle is visible despite invisibility attempt | Test multiple invisibility methods (material, alpha, scale=0) |
| Mounting/unmounting is janky | Smooth transition; teleport player to safe position on unmount |
| Other NPCs react to vehicle presence | Disable vehicle AI; set non-hostile |

---

## 8. Hotkeys

| Hotkey | Action |
|--------|--------|
| Spawn & Mount | Spawn invisible vehicle, mount player |
| Unmount & Despawn | Unmount player, despawn vehicle |
| Toggle Flight Mode | Enable/disable 6DOF vehicle rotation |
| Pitch Up/Down | Adjust vehicle pitch |
| Roll Left/Right | Adjust vehicle roll |
| Yaw Left/Right | Adjust vehicle yaw |
| Reset Rotation | Set vehicle rotation to 0 |
| Hover Toggle | Enable/disable hover (from T9.1) |
| Hover Up/Down | Adjust hover height (from T9.1) |

> **Note:** `registerHotkey()` calls must be at file root level, not inside `onInit`. See `cet-hotkeys.promptinclude.md`.

---

## 9. Testing Checklist

- [ ] Invisible vehicle spawns at player position
- [ ] Player mounts to vehicle successfully
- [ ] Vehicle transform manipulation works (rotation visible)
- [ ] Player body follows vehicle rotation
- [ ] Camera behavior documented (follows or needs override)
- [ ] Hover works for vehicle + mounted player
- [ ] Unmount returns player to normal state
- [ ] No crashes during mount/unmount cycle
- [ ] Clean despawn of vehicle
- [ ] Crash safeguard: unmount on init if mounted
- [ ] All hotkeys appear in Settings > Key Bindings

---

## 10. Limitations

- Player is in a "mounted" state — may restrict actions (shooting, interacting, etc.)
- Collision is vehicle-shaped, not player capsule-shaped
- Feels like a workaround, not a clean solution
- Other systems may treat the player as "in a vehicle" (UI, fast travel, etc.)

---

## 11. References

| Source | Path | Key Insight |
|--------|------|-------------|
| goals - master.md | `goals - master.md` | Testing program overview |
| goals 1 - logging.md | `goals 1 - logging.md` | T9.1 logging results needed before starting |
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | Approach D details |
| LTBF C++ Hooks | `docs/c++ hooks/let there be flight - c++ hooks.md` | Vehicle physics hook pattern |
| Let There Be Flight | `docs/vehicle flight/let there be flight.md` | Vehicle flight implementation |
| Vehicle Hover Tester 2 | `testers/hover rotate vehicle/hover_vehicle_tester2/init.lua` | PD controller, vehicle transform control |
| OKF Vehicle | `okf/mods_red4ext/vehicle/` | Vehicle-related native functions |
| OKF Mountable | `okf/api/components/mountable-component-851.md` | Mountable component API |
