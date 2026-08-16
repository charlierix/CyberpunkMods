# HoverRotTesterPlayer7B — TweakDB Plumbing Fix + Logging

## Overview

This is a **CET-only overlay** on `hover_rot_tester_player7`, focused on fixing the TweakDB communication channel and adding comprehensive logging. The RED4ext plugin remains a shell (no hooks) — the goal is to verify the TweakDB plumbing works before implementing hooks in a future tester.

## What Changed from 7a

| Aspect | Player7a | Player7b |
|---|---|---|
| TweakDB SetFlat | No type parameter (fails with "type ambiguous") | **Explicit type as 3rd param** ("Float", "Int32") |
| Logging | None (pcall swallows errors silently) | **print() at every hotkey, activation, tick interval, and error** |
| pcall error handling | Silently swallowed | **Errors logged with flat name, value, type, and error message** |
| Camera rotation | `ApplyCameraRotation()` runs every tick | **Removed entirely** — camera is child of body, body rotation is enough |
| EulerToQuat | Custom ZYX quaternion (wrong axes) | **Removed** — TweakDB stores raw float degrees, RED4ext plugin does quaternion math |
| TweakDB flat creation | Only on activation, no verification | **Created in onInit** + readback verification on creation and every 60 ticks |
| TweakDB readback | None | **Periodic readback** every 60 ticks + on-demand via DumpTweakDB hotkey |
| Error tracking | `lastError` field only | **Write count, fail count, last-write-OK flag, periodic readback** |
| Hotkeys | 10 | 11 (added DumpTweakDB) |

## Key Fixes

### 1. TweakDB SetFlat Type Parameter

The core fix. In 7a, every SetFlat call failed with:
```
[TweakDB::SetFlat] Type for HoverRotPlayer7_pitch is ambiguous, use third parameter to specify the type
```

7b passes the type explicitly:
```lua
TweakDB:SetFlat("HoverRotPlayer7_pitch", value, "Float")
TweakDB:SetFlat("HoverRotPlayer7_active", value, "Int32")
```

### 2. Camera Rotation Removed

7a (and 7) called `ApplyCameraRotation()` inside `ApplyRed4extOverride()`, which rotated the FPP camera via `cam:SetLocalOrientation(quat)`. This was the only visible effect since the RED4ext path was broken.

7b removes all camera manipulation. Rationale: the FPP camera is a child component of the player entity. When the body rotates, the camera follows. Modifying the camera separately is an extra complication that can cause issues (upside-down camera, axis mismatches).

### 3. Comprehensive Logging

All key events are logged via `print()` with `[HoverRotPlayer7B]` prefix:
- **onInit**: flat creation, readback, RED4ext status check
- **Activation**: player found, flat creation results, RED4ext status, initial orientation
- **Deactivation**: final TweakDB write, totals
- **Every hotkey**: which key, new rotation values
- **Every 60 ticks**: rotation state, hover velocity, TweakDB write/fail counts, readback values
- **Every SetFlat failure**: flat name, value, type, error message
- **Every GetFlat failure**: flat name, error message

### 4. Silent Failure Detection

TweakDB:SetFlat may fail silently — the engine logs an error to the CET console but doesn't throw a Lua exception. The pcall wrapper only catches Lua exceptions. To detect silent failures, 7b performs **periodic readback verification**: every 60 ticks, it reads all flats back and logs the values. If a readback returns nil or a stale value, the write silently failed.

## Files

| File | Description |
|---|---|
| `cet/init.lua` | CET script with TweakDB fix, logging, no camera rotation |

## Shared from Player7 (not duplicated)

| Component | Path in Player7 |
|---|---|
| RED4ext plugin | `red4ext/bin/HoverRotTesterPlayer7.dll` |
| RED4ext source | `red4ext/src/Main.cpp` |
| RED4ext build | `red4ext/CMakeLists.txt` |
| Redscript bridge | `redscript/HoverRotPlayer7.reds` |

## Hotkeys

| Hotkey | Label |
|---|---|
| Toggle | Toggle Active |
| PitchUp / PitchDown | Pitch Up / Down |
| RollLeft / RollRight | Roll Left / Right |
| YawLeft / YawRight | Yaw Left / Right |
| Reset | Reset Rotation |
| HoverUp / HoverDown / HoverStop | Hover Up / Down / Stop |
| DumpTweakDB | Dump TweakDB State (reads all flats and logs them) |

## TweakDB Communication

CET writes to TweakDB using prefix `HoverRotPlayer7` (shared with player7):

| Flat | Type | Purpose |
|---|---|---|
| `HoverRotPlayer7_active` | Int32 | 0/1 — mode active flag |
| `HoverRotPlayer7_pitch` | Float | Pitch in degrees |
| `HoverRotPlayer7_yaw` | Float | Yaw in degrees |
| `HoverRotPlayer7_roll` | Float | Roll in degrees |
| `HoverRotPlayer7_strategy` | Int32 | Always 3 (RED4ext Native Override) |
| `HoverRotPlayer7_red4ext_loaded` | Int32 | 0/1 — set by RED4ext plugin on load |

Flats are created in `onInit` (before activation) so they exist for the RED4ext plugin to read from the start.

## Known Issues

1. **RED4ext plugin is a shell** — loads successfully but has all hook registration commented out. No body rotation occurs. This is intentional for 7b — verify TweakDB plumbing first.
2. **Hover velocity accumulates** — hover up/down sets a fixed velocity applied every frame, causing unbounded acceleration. Not fixed in 7b (focus is TweakDB + logging).
3. **No body rotation** — since RED4ext hooks aren't implemented, nothing actually rotates the player body. The TweakDB values are written but nothing reads them yet.
4. **Axis mapping untested** — with camera rotation removed, the axis swap issue (pitch→yaw, yaw→roll, roll→pitch) can't be observed. Will be verified when body rotation is implemented.

## What to Verify in Testing

1. **CET log shows `[HoverRotPlayer7B]` messages** — onInit, hotkey presses, periodic tick logs
2. **No TweakDB SetFlat errors** — the "type ambiguous" errors should be gone
3. **Readback values match written values** — periodic readback shows correct pitch/yaw/roll/active
4. **TweakDB write/fail counts** — ImGui panel shows writes incrementing, fails staying at 0
5. **DumpTweakDB hotkey works** — press it, check CET log for all flat values
6. **RED4ext shows NOT LOADED** — expected, since the plugin doesn't write the flag yet

## Future Testers

| Tester | Focus |
|---|---|
| **7b** (this) | TweakDB plumbing fix + logging |
| **8** | RED4ext hook implementation (uncomment and adapt hook registration in Main.cpp) |
| **9+** | Codeware approach (Redscript SetWorldTransform with Quaternion, requires Codeware dependency) |

## Deployment

1. Deploy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/HoverRotTesterPlayer7B/init.lua`
2. Deploy RED4ext DLL and Redscript from player7 as usual
3. Bind hotkeys in Settings > Key Bindings
4. Check CET console/log for `[HoverRotPlayer7B]` messages
