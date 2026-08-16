# HoverRotTesterPlayer7A — Log Summary

## Overview

HoverRotTesterPlayer7A is a CET-only overlay on `hover_rot_tester_player7`, stripped to **strategy 3 only** (RED4ext Native Override). The RED4ext plugin and Redscript bridge are shared from player7 without modification.

The logs cover a single game session on **2026-08-13 from ~23:34 to ~23:39** (UTC-05:00).

## Log Files

### log - cet.txt

- **File info**: 25 visible lines; TweakDB error spam repeats for **~14 MB** (file was truncated for storage)
- **Date range**: 2026-08-13 23:34:23 to 23:38:49 (UTC-05:00)

#### Key Events

- **23:34:23** — CET loads `hover_rot_tester_player7a` from `D:\SteamLibrary\steamapps\common\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\hover_rot_tester_player7a`
- **23:34:37** — EntityScanner initialized, LuaVM initialization finished
- **23:38:49** — Massive spam of TweakDB::SetFlat errors begins (see below)

#### TweakDB SetFlat Failures (Critical Issue)

Every TweakDB write attempt by the CET mod fails with:
```
[TweakDB::SetFlat] Type for HoverRotPlayer7_roll is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_strategy is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_active is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_pitch is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_yaw is ambiguous, use third parameter to specify the type
```

These 5 messages repeat continuously for **~14 MB** of log content. This means:

1. The TweakDB flats (`HoverRotPlayer7_pitch`, `_yaw`, `_roll`, `_strategy`, `_active`) either don't exist or were created without explicit type information
2. CET's `TweakDB:SetFlat()` cannot write to them because the type is ambiguous — the third parameter (type specifier) is not being passed
3. The CET mod calls `WriteOrientationToTweakDB()` on every `onUpdate` tick, producing massive log spam
4. **Strategy 3 (RED4ext native override) cannot work** because the RED4ext plugin reads these TweakDB values, but they're never successfully written
5. The `pcall` wrapper in `WriteOrientationToTweakDB()` silently swallows the errors, so the mod continues running but no data reaches RED4ext

#### Other Mods Loaded

- entity scanner
- ghost_forward
- grappling_hook
- HeavyMG
- hover_rot_tester_player7a
- hundred_grand
- jetpack
- low_flying_v
- wall_hang

### log - red4ext.txt

**Not present** — player7a shares the RED4ext plugin from player7. See player7's `log summary.md` for RED4ext log analysis. Key finding: the RED4ext plugin loads but has **all hook registration code commented out** — it is a no-op placeholder.

### log - redscript.txt

**Not present** — player7a shares the Redscript bridge from player7.

## Lack of Real Logging

**There is no real logging in this tester.** The CET log contains only:
1. Mod load messages (automatic from CET)
2. TweakDB SetFlat error spam (automatic from the engine)

There are **no log entries for**:
- Hotkey presses (pitch up/down, yaw left/right, roll left/right, hover up/down, toggle, reset)
- Current rotation values at any point
- Player position or orientation
- Camera orientation before/after
- Whether the mode was activated or deactivated
- ImGui panel state
- RED4ext plugin detection result

All observations about behavior come from the user's manual notes in `TEST RESULTS.md`, not from logged data. Without real logging, there is nothing to summarize beyond the TweakDB errors and the user's loose observations.

## Key Findings

### 1. TweakDB Communication Channel Is Broken (Same as Player7)

The CET mod writes orientation data to TweakDB flats every tick, but **every write fails** with "Type is ambiguous." The RED4ext plugin receives no orientation data. This is identical to the player7 issue — the TweakDB flats were never properly created with explicit types.

### 2. RED4ext Plugin Is a Placeholder (Same as Player7)

The shared RED4ext plugin loads successfully but has all hook registration code commented out. No functions are hooked. The plugin does nothing at runtime beyond logging load/unload messages.

### 3. Only Camera Rotation Is Visible

Because both the TweakDB path and the RED4ext hook are broken, the only functional code in strategy 3 is `ApplyCameraRotation(player)`, which:
- Sets `cam.sensitivityMultX = 0` and `cam.sensitivityMultY = 0` (disables mouse look)
- Sets `cam:SetLocalOrientation(quat)` using a custom `EulerToQuat()` function

This rotates the **FPP camera**, not the player body. The player's body remains upright.

### 4. Axis Mapping Is Wrong (Same as Player7)

Per TEST RESULTS.md:
- Pitch button changes yaw
- Yaw button changes roll
- Roll button changes pitch

The `EulerToQuat()` function uses ZYX Euler order which doesn't match CP2077's internal convention. The quaternion rotation order or axis assignment needs correction.

### 5. Camera Starts Upside Down (Same as Player7)

The camera is upside down upon activation, likely caused by the incorrect Euler convention combined with an initial orientation offset.

### 6. Hover Velocity Accumulates

Hover up/down buttons set a fixed velocity that is applied every frame, causing unbounded acceleration. There is no damping or frame-rate normalization.

## What Actually Ran

| Component | Status | Evidence |
|-----------|--------|----------|
| TweakDB writes | **Broken** — all SetFlat calls fail | 14 MB of error spam in CET log |
| RED4ext hook | **Not registered** — placeholder plugin | Player7 RED4ext log shows no hook activity |
| Camera rotation | **Working** — rotates FPP camera only | `ApplyCameraRotation()` in `ApplyRed4extOverride()` |
| Body rotation | **Not working** — no mechanism is functional | No strategy actually overrides body orientation |
| Hover impulse | **Working** — but unbounded acceleration | PSMImpulse via QueueEvent |

## Recommendations

### For Logging

Add CET log calls (using `print()` or CET's logging API) at these points:
1. `ActivateMode()` / `DeactivateMode()` — log activation state, RED4ext detection result
2. Each hotkey handler — log which key was pressed and new rotation values
3. `onUpdate` tick — log rotation state, tick count, hover velocity (throttled to every N ticks)
4. `ApplyCameraRotation` — log before/after camera orientation quaternion
5. `WriteOrientationToTweakDB` — log success/failure (not just pcall swallow)
6. `ApplyHover` — log impulse vector being sent

### For Body Rotation

The core problem remains: **strategy 3's native override path is completely non-functional**. Either:
1. Fix TweakDB flat creation (add explicit type parameter or create flats via TweakXL)
2. Implement the RED4ext hook (uncomment and adapt hook registration code)
3. Or abandon strategy 3 and use a different approach (e.g., Redscript `SetWorldTransform` with Codeware, or vehicle mount hybrid)

### For Axis Mapping

Fix `EulerToQuat()` to match CP2077's convention, or use `EulerAngles.new(roll, pitch, yaw):ToQuat()` which is the native CET conversion that handles the correct axis order.
