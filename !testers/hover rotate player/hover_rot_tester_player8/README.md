# HoverRotTesterPlayer8 — Hybrid Player Body Rotation

Real implementation of player body rotation using CET + Redscript + RED4ext.

## What Changed from 7 Series

| Aspect | 7 Series | Tester 8 |
|--------|----------|----------|
| C++ plugin | Shell — no hooks, no functions | **Real** — 3 native functions registered via RTTI |
| Communication | TweakDB flats (CET writes, C++ reads) | **Direct function call** (CET → redscript → C++ native) |
| Quaternion computation | Custom EulerToQuat() in C++ (wrong axis mapping) | **Game native** `EulerAngles.new(roll, pitch, yaw):ToQuat()` in CET |
| Transform write | Not implemented | **Direct memory write** to `transformComponent->worldTransform.Orientation` |
| Camera manipulation | Strategy 1 rotated camera (caused issues) | **None** — camera is child of body, follows automatically |
| Logging | 7b added CET print() logging | **Both CET + C++ SDK logger** with throttled diagnostics |
| Crash safeguard | 7b noted the concern | **Implemented** — active flag reset to false in onInit |

## Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    CET Lua (init.lua)                          │
│  • Hotkeys: pitch/yaw/roll/hover/toggle/reset/dump             │
│  • Quaternion: EulerAngles.new(roll, pitch, yaw):ToQuat()      │
│  • Hover: PSMImpulse via QueueEvent                            │
│  • ImGui: status panel with live readback                      │
│  • Logging: comprehensive print() at every event               │
└──────────────────────────┬─────────────────────────────────────┘
                           │ bridge:ApplyRotation(quat)
                           ▼
┌────────────────────────────────────────────────────────────────┐
│              Redscript Bridge (HoverRotPlayer8.reds)           │
│  • ScriptableSystem: HoverRotPlayer8Bridge                     │
│  • Wraps native function calls for CET access                  │
│  • CheckNativeAvailable() — verifies plugin loaded             │
└──────────────────────────┬─────────────────────────────────────┘
                           │ HoverRotPlayer8_ApplyRotation(quat)
                           ▼
┌────────────────────────────────────────────────────────────────┐
│              RED4ext C++ Plugin (Main.cpp)                     │
│  • 3 native global functions registered via CGlobalFunction    │
│  • Gets player via ExecuteGlobalFunction("GetPlayer;")         │
│  • Casts to ent::Entity, accesses transformComponent at 0xB0   │
│  • Writes quaternion to worldTransform.Orientation at 0xF0     │
│  • Throttled SDK logger output for diagnostics                 │
└────────────────────────────────────────────────────────────────┘
```

## File Structure

```
hover_rot_tester_player8/
├── cet/
│   └── init.lua                        # CET entry point (411 lines)
├── red4ext/
│   ├── src/
│   │   └── Main.cpp                    # C++ plugin with native functions (358 lines)
│   ├── CMakeLists.txt                  # Build configuration (55 lines)
│   └── bin/                            # Output directory for built DLL
├── redscript/
│   └── HoverRotPlayer8.reds            # Redscript bridge (78 lines)
└── README.md                           # This file
```

## Native Functions (C++ → Redscript → CET)

| Function | Parameters | Returns | Purpose |
|----------|-----------|---------|---------|
| `HoverRotPlayer8_ApplyRotation` | `Quaternion quat` | `Bool` | Writes quaternion to player transform |
| `HoverRotPlayer8_GetStatus` | none | `String` | Diagnostic counters and last error |
| `HoverRotPlayer8_ReadPlayerOrientation` | none | `String` | Reads player's current orientation quaternion |

## SDK Memory Layout (Verified from SDK Headers)

```
ent::Entity (0x160 bytes)
  └── offset 0xB0: IPlacedComponent* transformComponent

IPlacedComponent (0x120 bytes)
  └── offset 0xE0: WorldTransform worldTransform

WorldTransform (0x20 bytes)
  └── offset 0x10: Quaternion Orientation  (i, j, k, r)

Total offset from IPlacedComponent base to Orientation: 0xF0
```

## Deployment

### CET Mod
```
copy cet/init.lua → bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player8/init.lua
```

### Redscript Bridge
```
copy redscript/HoverRotPlayer8.reds → r6/scripts/HoverRotPlayer8/HoverRotPlayer8.reds
```

### RED4ext Plugin

run **'x64 Native Tools Command Prompt'**

```bash
cd "testers/hover rotate player/hover_rot_tester_player8/red4ext"

rmdir /s /q build
mkdir build
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="D:\agent zero\!v2b\projects\cyberpunk\sdk\RED4ext.SDK\include"
cmake --build . --config Release
```

created file:
red4ext/bin/HoverRotTesterPlayer8.dll

copy to red4ext/plugins/HoverRotTesterPlayer8/HoverRotTesterPlayer8.dll


## Hotkeys

| Key Binding | Action |
|-------------|--------|
| Toggle | Activate/deactivate rotation mode |
| Pitch Up/Down | Adjust pitch by ±2° |
| Roll Left/Right | Adjust roll by ±2° |
| Yaw Left/Right | Adjust yaw by ±2° |
| Reset | Reset all rotation to 0° |
| Hover Up/Down/Stop | Vertical impulse control |
| Dump Status | Print full diagnostic dump to CET log |

## Logging

### CET Log (`[HoverRotPlayer8]` prefix)
- onInit: crash safeguard reset, native availability check
- Every hotkey: key name + new rotation value
- Every 60 ticks (~1s): rotation state, apply counts, C++ status, readback
- Activation/deactivation: full state dump
- Dump Status hotkey: complete diagnostic snapshot

### RED4ext Log (`[HoverRotTesterPlayer8]` prefix)
- Plugin load: architecture summary, SDK offsets, RTTI registration
- First ApplyRotation call: quaternion values, entity/transform pointers
- Every 300 calls (~5s): call count, success/fail counts, quaternion values
- Plugin unload: final statistics
- Error conditions: null player, null transform component (throttled)

## Key Design Decisions

### 1. Quaternion Computation in CET (Not C++)
Tester 7 had wrong axis mapping because its custom `EulerToQuat()` used ZYX Euler order. Tester 8 uses the game's native `EulerAngles.new(roll, pitch, yaw):ToQuat()` — the game's own conversion guarantees correct axis mapping.

### 2. Direct Memory Write (Not Hooks)
Instead of hooking `OnTick` or locomotion update (which requires reverse engineering function addresses), tester 8 registers native functions that CET calls every frame. The C++ function writes directly to `transformComponent->worldTransform.Orientation` using verified SDK struct offsets.

### 3. No TweakDB Communication
7b proved TweakDB plumbing works, but it's unnecessary overhead for tester 8. Direct function calls through the redscript bridge are simpler and faster. TweakDB may be revisited if cross-plugin state sharing is needed later.

### 4. No Camera Manipulation
The FPP camera is a child component of the player entity. When the body rotates, the camera follows automatically. Tester 7's camera manipulation caused axis mismatches and upside-down views — entirely avoided by not touching the camera.

## Testing Checklist

- [ ] RED4ext plugin loads without errors (check RED4ext log)
- [ ] CET detects native functions as available (ImGui shows "Native: LOADED")
- [ ] Toggle hotkey activates mode (CET log shows activation)
- [ ] Pitch/roll/yaw hotkeys adjust values (CET log confirms)
- [ ] ApplyRotation calls succeed (ImGui shows success count > 0)
- [ ] Player body visibly rotates (visual confirmation)
- [ ] Readback shows quaternion matching applied values
- [ ] No crashes during rotation
- [ ] Deactivation restores normal movement
- [ ] Crash safeguard: after crash+reload, mode starts inactive

## Known Limitations

1. **Locomotion override**: The game's locomotion system may fight the direct transform write by resetting orientation each frame. If the body snaps back, a hook-based approach (intercepting the locomotion update) will be needed.
2. **Entity cast safety**: The `reinterpret_cast<ent::Entity*>` assumes PlayerPuppet's memory layout matches ent::Entity at the base. This is true for single inheritance but should be verified if crashes occur.
3. **Thread safety**: The native function is called from the script thread (CET onUpdate). Direct memory writes to the transform should be safe since CET runs on the game thread.
