# HoverRotTesterPlayer7 — Log Summary

## Overview

HoverRotTesterPlayer7 is a hybrid CET + RED4ext + Redscript mod designed to test full 6DOF player body rotation (pitch, yaw, roll) while airborne. It combines three modding layers:

- **CET (init.lua)**: Hotkeys, hover via PSMImpulse, camera rotation, strategy cycling, ImGui debug UI, TweakDB communication
- **RED4ext (Main.cpp)**: Native C++ plugin intended to hook player update and override orientation post-locomotion-clamp
- **Redscript (HoverRotPlayer7.reds)**: ScriptableSystem bridge for vehicle mounting, locomotion access, and transform writes

The logs cover a single game session on 2026-08-13 from ~09:17 to ~09:27 (UTC-05:00).

## Log Files

### log - cet.txt

- **File info**: 30 lines (visible), 3,537 bytes on disk (note: log mentions content "repeats for 1.3mb" — the file may have been truncated or the log was much larger in-game)
- **Date range**: 2026-08-13 09:17:32 to 09:25:58 (UTC-05:00)

#### Key Events

- **09:17:32** — CET loads multiple mods including `hover_rot_tester_player7` from `D:\SteamLibrary\steamapps\common\Cyberpunk 2077\bin\plugins\cyber_engine_tweaks\mods\hover_rot_tester_player7`
- **09:17:46** — EntityScanner initialized, LuaVM initialization finished
- **09:25:58** — Massive spam of TweakDB::SetFlat errors (see below)

#### Notable Patterns

**TweakDB SetFlat failures (critical issue)**:

Every TweakDB write attempt by the CET mod fails with:
```
[TweakDB::SetFlat] Type for HoverRotPlayer7_pitch is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_yaw is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_roll is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_strategy is ambiguous, use third parameter to specify the type
[TweakDB::SetFlat] Type for HoverRotPlayer7_active is ambiguous, use third parameter to specify the type
```

These 5 messages repeat continuously (the log notes "repeats for 1.3mb" of content). This means:

1. The TweakDB flats (`HoverRotPlayer7_pitch`, `_yaw`, `_roll`, `_strategy`, `_active`) either don't exist in TweakDB or were created without explicit type information
2. CET's `TweakDB:SetFlat()` cannot write to them because the type is ambiguous — the third parameter (type specifier) is not being passed
3. The CET mod calls `WriteOrientationToTweakDB()` on every tick (likely in `onUpdate`), producing massive log spam
4. **Strategy 3 (RED4ext native override) cannot work** because the RED4ext plugin reads these TweakDB values, but they're never successfully written

#### Errors Encountered

- **All TweakDB SetFlat calls fail** — the core communication channel between CET and RED4ext is broken
- The `pcall` wrapper in `WriteOrientationToTweakDB()` silently swallows the errors, so the mod continues running but no data reaches RED4ext

#### Other Mods Loaded

- entity scanner
- ghost_forward
- grappling_hook
- HeavyMG
- hover_rot_tester_player7
- hundred_grand
- jetpack
- low_flying_v
- wall_hang

---

### log - red4ext.txt

- **File info**: 28 lines, 3,186 bytes
- **Date range**: 2026-08-13 09:17:25.409 to 09:27:22.195 (UTC-05:00)

#### Key Events

- **09:17:25.409** — RED4ext v1.30.0 initializing (Product version: 2.31, File version: 3.0.80.51928)
- **09:17:26.244** — 921,876 game addresses loaded from `cyberpunk2077_addresses.json`
- **09:17:26.258** — RED4ext successfully initialized
- **09:17:26.285** — Loading plugins:
  - **ArchiveXL** v1.26.8 (psiberx) — loaded at 09:17:26.532
  - **Codeware** v1.20.3 (psiberx) — loaded at 09:17:27.215
  - **HoverRotTesterPlayer7** v1.0.0 (Cyberpunk Modding Project) — loaded at 09:17:27.216
  - **TweakXL** v1.11.3 (psiberx) — loaded at 09:17:27.319
- **09:17:27.319** — 4 plugins loaded, RED4ext started
- **09:17:32.204** — Script compiler (scc) invoked: 25,874 source refs registered, scripts blob saved to `final.redscripts.modded`
- **09:27:20.163** — RED4ext shutting down
- **09:27:22.195** — RED4ext fully shut down, all 4 plugins unloaded

#### TweakDB Values Observed

- No TweakDB values are logged by the RED4ext plugin. The plugin's `LogInfo` calls only fire on load/unload:
  - `[HoverRotTesterPlayer7] Plugin loaded -- player orientation hook`
  - `[HoverRotTesterPlayer7] Hook registration placeholder ready`
  - `[HoverRotTesterPlayer7] Plugin unloading`
- **No hook activity is logged** — the hook registration code is commented out (placeholder only)

#### Hook Activity

- **None** — The plugin loads and sets `g_IsReady = true`, but the actual hook registration (`aSdk->hooking->Add(...)`) is commented out. The plugin is effectively a no-op: it loads, logs, and does nothing.
- This confirms the TEST RESULTS.md note: "the imgui panel was saying red4ext wasn't loaded" — while the DLL technically loads, it doesn't register any hooks or perform any actual work, so functionally it's inactive.

---

### log - redscript.txt

- **File info**: 49 lines, 3,010 bytes
- **Date range**: 2026-08-13 09:17:31 to 09:17:32 (UTC-05:00)

> **Note**: This file is **NOT identical to log - red4ext.txt** (contrary to the task description). It is the Redscript compilation log, which is a separate log source from the RED4ext runtime log.

#### Key Events

- **09:17:31** — Redscript compiler starts compiling files in `r6/scripts/`
- **09:17:31** — Compilation includes `HoverRotPlayer7.reds` among many other mod scripts (BrowserExtension, CyberwareEx, VirtualCarDealer, ArchiveXL, Codeware, TweakXL, etc.)
- **09:17:31** — Compilation complete
- **09:17:32** — Output saved to `final.redscripts.modded`

#### Why It's Different from red4ext.txt

The Redscript log is produced by the Redscript compiler (scc), which compiles `.reds` files into the modded scripts blob. The RED4ext log is produced by the RED4ext runtime, which loads native DLL plugins. They are separate systems with separate log outputs, though both are triggered during game startup. The user may have confused them because both appear during the same load sequence.

## Key Findings

### 1. TweakDB Communication Channel Is Broken

The CET mod attempts to write orientation data to TweakDB flats (`HoverRotPlayer7_pitch`, `_yaw`, `_roll`, `_strategy`, `_active`) every tick, but **every single write fails** with "Type is ambiguous." This means:

- The RED4ext plugin (Strategy 3) receives no orientation data from CET
- The TweakDB flats were likely never properly created/registered (no TweakXL file or `TweakDB:CreateRecord` calls are evident)
- The `TweakDB:SetFlat()` calls need a third type parameter, e.g. `TweakDB:SetFlat(prefix .. "_pitch", value, "Float")`

### 2. RED4ext Plugin Is a Placeholder

The plugin compiles and loads successfully (v1.0.0), but:

- All hook registration code is commented out
- No functions are actually hooked
- The `PostUpdateHook` and `WriteOrientationViaReflection` functions exist only as documentation/comments
- The plugin does nothing at runtime beyond logging load/unload messages

### 3. Axis Mapping Is Wrong

Per TEST RESULTS.md:
- pitch is yaw
- roll is pitch
- yaw is roll

This suggests the Euler angle convention in `EulerToQuat()` (ZYX order) doesn't match Cyberpunk 2077's internal convention. The quaternion rotation order or axis assignment needs to be corrected.

### 4. Default Orientation Is Upside Down

The player appears upside down by default, which may be due to:
- Incorrect quaternion construction
- The camera being in a corrupted state
- An initial orientation offset not being accounted for

### 5. Redscript Bridge Compiles but Has Stubs

`HoverRotPlayer7.reds` compiles successfully, but key methods are stubs:
- `MountPlayerToVehicle()` returns `"MOUNT_NOT_IMPLEMENTED"`
- `ForceFellState()` returns `"LOCOMOTION_FIELD_NOT_AVAILABLE"`
- `WriteOrientationDirect()` uses `TeleportationFacility.Teleport()` which is the same yaw-only approach already known to not work

### Strategy Testing Observations

| Strategy | Status | Evidence |
|----------|--------|----------|
| 1. Camera Only | Works (visual only) | Known from prior testers, not explicitly tested in this log |
| 2. Teleport (yaw only) | Works but yaw-only | Known from prior testers |
| 3. RED4ext Native Override | **Broken** — TweakDB writes fail, hooks not registered | CET log shows SetFlat errors; RED4ext log shows no hook activity |
| 4. Vehicle Mount Hybrid | **Incomplete** — mount not implemented | Redscript stub returns MOUNT_NOT_IMPLEMENTED |

## Cross-Reference with TEST RESULTS.md

The test results note:

1. **"pitch is yaw, roll is pitch, yaw is roll"** — Confirmed by code analysis: `EulerToQuat()` uses ZYX Euler order which doesn't match CP2077's convention. The quaternion components or Euler order need swapping.

2. **"default is upside down"** — Likely caused by the incorrect Euler convention combined with an initial orientation that assumes a different coordinate system. Could also be a camera corruption issue from Strategy 1.

3. **"imgui panel was saying red4ext wasn't loaded"** — The RED4ext DLL loads (confirmed in red4ext log), but the CET mod's `CheckRed4extStatus()` reads `TweakDB:GetFlat(TWEAKDB_PREFIX .. "_red4ext_loaded")` which likely fails because that flat was never created. The plugin never writes a "loaded" flag to TweakDB, so CET can't detect it.

4. **"next tester needs just the red4ext version"** — This aligns with the finding that the RED4ext plugin is the critical missing piece. The next tester (7a) should focus on getting the RED4ext hook actually working.

## Recommendations

### Critical Issues to Address

1. **Fix TweakDB flat creation**: The TweakDB flats must be properly created with explicit types before CET can write to them. Options:
   - Create a TweakXL YAML file defining the flats with types
   - Use `TweakDB:CreateRecord()` or equivalent in CET's `onInit`
   - Pass the type as the third parameter to `SetFlat()`: `TweakDB:SetFlat(prefix .. "_pitch", value, "Float")`

2. **Implement RED4ext hooks**: Uncomment and adapt the hook registration code. Key steps:
   - Verify the correct function CName to hook (likely `gamePuppetBase::OnTick` or `gameLocomotionStateMachinePlayer::Update`)
   - Implement the post-hook to override orientation after locomotion clamp
   - Have the plugin write a `_red4ext_loaded` flat to TweakDB so CET can detect it

3. **Fix Euler angle convention**: The ZYX order in `EulerToQuat()` produces wrong axis mapping. Need to either:
   - Change the quaternion multiplication order to match CP2077's convention
   - Swap the pitch/yaw/roll assignments before conversion
   - Test with known angles to determine the correct mapping

4. **Fix default upside-down orientation**: After fixing the Euler convention, verify the initial orientation is upright. May need to account for the player's base orientation offset.

### For the 7a Tester Variant

Based on TEST RESULTS.md guidance ("next tester needs just the red4ext version"):

1. **Focus on RED4ext only** — strip CET strategies 1, 2, and 4
2. **Fix TweakDB communication** — ensure flats are created with proper types
3. **Implement actual hooks** — not placeholders
4. **Add a `_red4ext_loaded` flag** — so any remaining CET code can detect the plugin
5. **Fix the Euler convention** — swap axes to match observed behavior (pitch↔yaw, roll↔pitch, yaw↔roll)
6. **Test the post-hook approach** — let locomotion clamp, then override orientation
7. **Consider the reflection approach** — writing directly to component orientation fields via CClass/CProperty memory offset
