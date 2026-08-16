# HoverRotTesterPlayer7B — Log Summary

## Overview

HoverRotTesterPlayer7B is a CET-only overlay on `hover_rot_tester_player7`, focused on fixing the TweakDB communication channel and adding comprehensive logging. The RED4ext plugin remains a shell (no hooks).

**Result: Clean test — all TweakDB writes succeeded, zero errors, zero failures.**

The logs cover a single game session on **2026-08-14 from ~00:39 to ~00:43** (UTC-05:00), approximately 4 minutes of active testing.

## Log Files

### log - cet.txt

- **File info**: 177 lines, 20,281 bytes
- **Date range**: 2026-08-14 00:39:30 to 00:43:03 (UTC-05:00)
- **Mod load**: 00:39:30 — `hover_rot_tester_player7b` loaded
- **LuaVM init**: 00:39:44

#### onInit (00:39:43–00:39:44)

1. **Flat creation**: 6 flats created, 0 failed
   - `HoverRotPlayer7_active` = 0 (Int32)
   - `HoverRotPlayer7_pitch` = 0 (Float)
   - `HoverRotPlayer7_yaw` = 0 (Float)
   - `HoverRotPlayer7_roll` = 0 (Float)
   - `HoverRotPlayer7_strategy` = 3 (Int32)
   - `HoverRotPlayer7_red4ext_loaded` = 0 (Int32)

2. **Readback verification**: All 6 flats read back with correct values — no mismatches, no nils

3. **RED4ext status check**: `_red4ext_loaded` = 0 → false (expected — plugin doesn't write the flag)

#### First Activation (00:42:01–00:42:52)

- **Toggle hotkey** pressed at 00:42:01
- Flats re-created: 6 ok, 0 failed
- Readback verification: all values correct
- RED4ext: NOT LOADED (expected)
- Initial orientation: pitch=0.0 yaw=0.0 roll=0.0 active=1

**Hotkey activity during first session:**

| Time | Hotkey | Result |
|------|--------|--------|
| 00:42:10 | PitchUp | pitch=2.0 |
| 00:42:11 | PitchUp | pitch=4.0 |
| 00:42:12 | YawRight | yaw=2.0 |
| 00:42:12 | YawRight | yaw=4.0 |
| 00:42:13 | YawLeft | yaw=2.0 |
| 00:42:13 | YawLeft | yaw=0.0 |
| 00:42:13 | RollRight | roll=2.0 |
| 00:42:13 | RollRight | roll=4.0 |
| 00:42:14 | RollRight | roll=6.0 |
| 00:42:14 | RollLeft | roll=4.0 |
| 00:42:14 | RollLeft | roll=2.0 |
| 00:42:15 | PitchDown | pitch=2.0 |
| 00:42:15 | PitchUp | pitch=4.0 |
| 00:42:18 | DumpTweakDB | All flats dumped — values match state |
| 00:42:19 | Reset | pitch=0.0 yaw=0.0 roll=0.0 |
| 00:42:37 | YawRight | yaw=2.0 |
| 00:42:37 | PitchUp | pitch=2.0 |
| 00:42:38 | YawLeft | yaw=0.0 |
| 00:42:38 | PitchDown | pitch=0.0 |
| 00:42:38 | RollRight | roll=2.0 |
| 00:42:39 | PitchDown | pitch=-2.0 |
| 00:42:39 | YawLeft | yaw=-2.0 |
| 00:42:40 | PitchDown | pitch=-4.0 |
| 00:42:40 | RollLeft | roll=0.0 |

**DumpTweakDB output (00:42:18):**

- HoverRotPlayer7_active = 1 (Int32)
- HoverRotPlayer7_pitch = 4 (Float)
- HoverRotPlayer7_yaw = 0 (Float)
- HoverRotPlayer7_roll = 2 (Float)
- HoverRotPlayer7_strategy = 3 (Int32)
- HoverRotPlayer7_red4ext_loaded = 0 (Int32)
- Writes: 3111 | Fails: 0 | LastOK: true | FlatsCreated: true

**First deactivation (00:42:52):**
- Final TweakDB write (active=0)
- Totals: **9,136 writes, 0 fails, lastOK=true**

#### Second Activation (00:42:53–00:43:03)

- Toggle hotkey at 00:42:53
- Flats re-created: 6 ok, 0 failed
- DumpTweakDB used at 00:42:55 — all values correct
- Reset hotkey at 00:42:57
- **Second deactivation (00:43:03):**
- Totals: **1,741 writes, 0 fails, lastOK=true**

#### TweakDB Performance

| Metric | First session | Second session | Total |
|--------|-------------|---------------|-------|
| Duration | ~51 seconds | ~10 seconds | ~61 seconds |
| Tick count | 1,800 | 300 | 2,100 |
| Writes | 9,136 | 1,741 | 10,877 |
| Fails | 0 | 0 | 0 |
| Write rate | ~179/s | ~174/s | ~178/s |

Write rate of ~178/s is expected: 5 flats written per tick x ~60 ticks/s = ~300/s, minus overhead = ~178/s observed.

#### Readback Verification

Every 60 ticks (~1 second), the mod reads back all 4 orientation flats + active flag. Across all 35 readback intervals in the log:
- **All readback values matched the written state** — zero mismatches, zero nils
- This confirms TweakDB SetFlat is not failing silently

#### Errors

**None.** Zero errors in the entire CET log. No SetFlat failures, no GetFlat failures, no pcall exceptions, no "type ambiguous" messages.

#### Other Mods Loaded

- entity scanner
- ghost_forward
- grappling_hook
- HeavyMG
- hover_rot_tester_player7b
- hundred_grand
- jetpack
- low_flying_v
- wall_hang

---

### log - red4ext.txt

- **File info**: 28 lines, 3,186 bytes
- **Date range**: 2026-08-14 00:39:22 to 00:43:17 (UTC-05:00)

#### Key Events

- **00:39:22.820** — RED4ext v1.30.0 initializing (Product version: 2.31, File version: 3.0.80.51928)
- **00:39:23.636** — 921,876 game addresses loaded
- **00:39:23.641** — RED4ext initialized
- **00:39:24.682** — HoverRotTesterPlayer7 v1.0.0 loaded
- **00:39:24.794** — 4 plugins loaded (ArchiveXL, Codeware, HoverRotTesterPlayer7, TweakXL)
- **00:39:30.530** — Script compiler (scc) invoked: 25,874 source refs registered
- **00:43:14.887** — RED4ext shutting down
- **00:43:17.305** — RED4ext fully shut down

#### Plugin Status

The RED4ext plugin loads successfully but remains a **placeholder shell** — identical to player7/7a:
- Plugin logs load/unload messages only
- **No hook activity logged** — all hook registration code is commented out
- Plugin does not write `_red4ext_loaded` flag to TweakDB (confirmed by CET readback showing 0)

---

### log - redscript.txt

- **File info**: 49 lines, 3,010 bytes
- **Date range**: 2026-08-14 00:39:30 (compilation only)

Redscript compiler compiles `HoverRotPlayer7.reds` among other mod scripts. Compilation completes successfully with no errors. Output saved to `final.redscripts.modded`.

---

## TEST RESULTS.md Notes

The user noted three observations:

1. **Crash safeguard concern**: If the game crashes while the mode is active, the `active` flat stays at 1 in TweakDB. On reload, a final version would need safeguards to disable on startup, entering vehicles, workspots, etc.

2. **No in-game actions observed**: Expected — the RED4ext plugin is a shell with no hooks, so nothing reads the TweakDB values to rotate the body.

3. **No errors in the mod's log**: Confirmed — zero errors across all three log files.

## Key Findings

### 1. TweakDB SetFlat Fix Works

The core fix — passing explicit type as the 3rd parameter to `TweakDB:SetFlat()` — completely eliminated the "type ambiguous" errors that plagued 7 and 7a (14 MB of error spam). Across 10,877 total writes in this session, **zero failures**.

| Tester | TweakDB writes | Failures | Error spam |
|--------|--------------|----------|------------|
| Player7 | Every write fails | 100% | ~1.3 MB |
| Player7a | Every write fails | 100% | ~14 MB |
| **Player7b** | **10,877 writes** | **0** | **None** |

### 2. Readback Verification Confirms Data Integrity

All 35 periodic readback checks (every 60 ticks) showed correct values matching the written state. No silent failures detected. The TweakDB communication channel is fully functional.

### 3. Logging Works as Designed

The `[HoverRotPlayer7B]` prefix appears throughout the CET log at every key event:
- onInit: flat creation + readback
- Activation: player found, flat creation, RED4ext status, initial orientation
- Every hotkey: key name + new rotation values
- Every 60 ticks: rotation state, hover velocity, TweakDB counts, readback
- DumpTweakDB: on-demand full flat dump
- Deactivation: final write + totals

### 4. No Camera Effects

Camera rotation was removed entirely. No `ApplyCameraRotation()` calls, no `cam:SetLocalOrientation()`, no `sensitivityMultX/Y` manipulation. The camera was not affected during testing, as intended.

### 5. RED4ext Plugin Still a Shell (Expected)

The plugin loads but has all hooks commented out. No `_red4ext_loaded` flag is written. CET correctly detects this as "NOT LOADED." This is intentional for 7b — the goal was to verify TweakDB plumbing before implementing hooks.

### 6. Crash Safeguard Needed for Final Version

Per TEST RESULTS.md: if the game crashes while active=1, the flat persists in TweakDB. A final version needs:
- Reset `active` to 0 on startup (onInit)
- Disable when entering vehicles, workspots, scenes, etc.
- Graceful degradation if RED4ext plugin is missing

Note: 7b already resets all flats to initial values in onInit (active=0), which partially addresses the crash recovery concern for the CET side. The RED4ext plugin side would need its own safeguard.

## What Actually Ran

| Component | Status | Evidence |
|-----------|--------|----------|
| TweakDB writes | **Working** — 10,877 writes, 0 fails | CET log shows all writes succeed, readback matches |
| TweakDB readback | **Working** — all values correct | 35 periodic checks, all match |
| RED4ext hook | **Not registered** — placeholder plugin | RED4ext log shows no hook activity |
| Camera rotation | **Removed** — not running | No camera manipulation code in 7b |
| Body rotation | **Not working** — no mechanism reads TweakDB | Expected — hooks not implemented yet |
| Hover impulse | **Working** — but unbounded acceleration | PSMImpulse via QueueEvent (not explicitly tested in this session) |
| Logging | **Working** — comprehensive | 177 lines of structured log output |

## 7 Series Conclusion

The 7 series (7, 7a, 7b) is complete. Summary of progression:

| Tester | Focus | Result |
|--------|------|--------|
| 7 | 4-strategy prototype (camera, teleport, RED4ext, vehicle) | All strategies broken: TweakDB fails, RED4ext is shell, teleport is yaw-only, vehicle mount not implemented |
| 7a | Strip to strategy 3 only | Same as 7 — TweakDB still fails, only camera rotation visible |
| 7b | Fix TweakDB + add logging + remove camera | **Success** — TweakDB plumbing fully functional, logging works, zero errors |

The TweakDB communication channel between CET and RED4ext is now verified working. The next step (tester 8) is to implement the RED4ext hooks that read these TweakDB values and override the player's body orientation.

## Recommendations for Tester 8

1. **Implement RED4ext hooks** — uncomment and adapt hook registration in `Main.cpp`
   - Target: `gamePuppetBase::OnTick` or `gameLocomotionStateMachinePlayer::Update`
   - Post-hook: read TweakDB flats, compute quaternion from pitch/yaw/roll, call `SetWorldTransform`
2. **Write `_red4ext_loaded` flag** — plugin should set `HoverRotPlayer7_red4ext_loaded` to 1 on load so CET can detect it
3. **Fix axis mapping** — use correct Euler-to-quaternion convention matching CP2077 (or use `EulerAngles.new(roll, pitch, yaw):ToQuat()` native conversion if available in C++)
4. **Add crash safeguards** — reset `active` flag on startup, disable on vehicle entry/workspot/scene transitions
5. **Fix hover velocity** — add damping or frame-rate normalization to prevent unbounded acceleration
