# Log Summary 2 — hover_rot_tester_player9.1a

**Date:** 2026-08-16
**Analyst:** Agent Zero (fresh re-analysis; previous `log_summary1.md` was largely fabricated due to tool call failures)

---

## Correction Note

The previous `log_summary1.md` claimed the logs were "heavily corrupted" and that crash report files were "0 bytes." **This is false.** All logs are perfectly readable, all crash report files have real content, and there is no evidence of memory corruption anywhere. The previous summary also listed incorrect versions (RED4ext v2.0.0, game v2.22) and wrong file sizes. This summary is based on direct verified reads of every file.

---

## Verified Environment

| Component | Version | Source |
|---|---|---|
| Cyberpunk 2077 | Patch 2.31, build 3.0.5294808 (P4CL 9778208, Aug 27 2025) | crash dump txt, RED4ext log |
| RED4ext | v1.30.0 (file version 3.0.80.51928) | RED4ext log |
| ArchiveXL | 1.26.8 | RED4ext log |
| Codeware | 1.20.3 | RED4ext log |
| TweakXL | 1.11.3 | RED4ext log |
| HoverRotTesterPlayer9_1a DLL | 1.0.0 (88,064 bytes on disk) | RED4ext log, file listing |
| CET | Present (cyber_engine_tweaks.asi in module list) | crash report.txt |
| OS | Windows 11 Home (10.0.26200) | sysinfo.json, crash dump |
| CPU | AMD Ryzen 9 9900X 12-Core | sysinfo.json |
| GPU | NVIDIA GeForce RTX 5070 Ti (driver v61088) | sysinfo.json, crash dump |
| RAM | 32 GB | sysinfo.json |

---

## Symptom Summary (User Report)

- After installing 9.1a (RED4ext DLL + Redscript + CET), CET **stopped working entirely**
- No CET scripting log (console dump) is produced
- CET console overlay doesn't appear
- Other CET mods do nothing
- **Removing 9.1a from deployment did NOT restore CET** — it stays broken
- Game now **crashes on quit**

---

## Log Analysis (All Verified by Direct Read)

### 1. RED4ext Plugin Log (`hoverrottesterplayer9_1a-2026-08-16-09-55-13.log`)

| Aspect | Finding |
|---|---|
| Size | 790 bytes |
| Timestamp | 2026-08-16 09:55:13 |
| Content | Plugin's OWN diagnostic log (not CET's log). Shows: plugin loaded, 4 native functions registered, bone access offset chain documented, RTTI callbacks registered |
| Status | Clean — 5 log lines, no errors |
| Interpretation | This is from a **later session** (09:55) than the crash (09:44). The plugin loaded successfully in this session |

> NOTE: I saved off logs from one run, removed 9.1a, still broken.  put 9.1a back, and noticed this log wasn't cet (like I originally thought), but mod generated, so copied it directly.  the contents are the same as the first run, even though this particular log was from a later run

### 2. RED4ext Log (`log - red4ext.txt`)

| Aspect | Finding |
|---|---|
| Size | 2,599 bytes |
| Timestamp | 2026-08-16 09:31:21–09:31:31 |
| Content | **Fully readable, NOT corrupted.** RED4ext v1.30.0 initializes, loads 921,876 game addresses, then loads all 4 plugins successfully |
| Plugin load order | ArchiveXL (1.26.8) → Codeware (1.20.3) → HoverRotTesterPlayer9_1a (1.0.0) → TweakXL (1.11.3) |
| Script compilation | scc invoked successfully, 25,868 source refs registered, blob path updated to `final.redscripts.modded` |
| Errors | **None** — all plugins loaded, no warnings or failures |
| Interpretation | This is from **Session 1** (09:31). Everything in the RED4ext + redscript pipeline succeeded in this session |

### 3. Redscript Log (`log - redscript.txt`)

| Aspect | Finding |
|---|---|
| Size | 3,013 bytes |
| Timestamp | 2026-08-16 09:31:31 |
| Content | **Fully readable, NOT corrupted.** Lists all compiled script files including `HoverRotPlayer9_1a.reds` |
| Other mods compiled | BrowserExtension, cornmilf_cars, CyberwareEx, oranje3 vehicles, SDH0_PorscheSinger, VehicleManufacturerFix, VirtualCarDealer, plus ArchiveXL/Codeware/TweakXL scripts |
| Result | "Compilation complete" → "Output successfully saved to final.redscripts.modded" |
| Errors | **None** |
| Interpretation | Redscript compilation succeeded in Session 1. The 9.1a native function declarations were compiled into the cached blob |

### 4. Crash Report (`crash report/`)

All files present with real content (integrity.json confirms checksums for all 9 files):

| File | Size | Content Summary |
|---|---|---|
| `report.txt` | 6,301 bytes | REDEngineErrorReport, unhandled exception, 177 loaded modules listed |
| `stacktrace.txt` | 141 bytes | Exception 0xE06D7363, `<Unknown>` file/line |
| `sysinfo.json` | 4,029 bytes | Full hardware/system info (CPU, RAM, GPU, drives) |
| `integrity.json` | 705 bytes | Checksums for all crash report files — all present |
| `Cyberpunk2077.dmp` | 28,552,275 bytes | Binary crash dump (not analyzed — needs WinDbg) |
| `attch/metadata.9.json` | 4,260 bytes | **Save metadata** (AutoSave-13, level 41, VeryHard, isModded=true) |
| `attch/sav.dat` | 4,022,813 bytes | Save file attached to crash report |
| `attch/screenshot.png` | 86,003 bytes | Crash screenshot |
| `attch/Cyberpunk2077.exe-*.txt` | 8,189 bytes | **Crash dump with engine state** — the key file |

### 5. Crash Dump Engine State (`attch/Cyberpunk2077.exe-20260816-094407-29076-17996.txt`)

This is the most critical file. Key findings:

| Field | Value | Significance |
|---|---|---|
| `!!!CRASHED!!!` | — | Game crashed |
| `exceptionCode` | `0xE06D7363` | **MSVC C++ exception** (not access violation, not memory corruption). This is a thrown/managed exception |
| `uptimeSeconds` | 149 | Game ran ~2.5 minutes before crash |
| `Engine/RequestExit` | `true` | Engine was shutting down — **crash during quit** |
| `Engine/Scripts/ShouldCompileScripts` | `true` | Engine attempted script compilation |
| `Engine/Scripts/CompileScriptsSuccess` | **`false`** | **Script compilation FAILED** |
| `Engine/Scripts/Loaded` | `true` | Script blob was loaded despite compilation failure |
| `Engine/Scripts/BlobPathUsed` | `Loaded` | Used the cached blob |
| `Game/SessionDesc/IsLoadingSavedSession` | `true` | Game was loading a save when crash occurred |
| `Game/LoadingStage` | `Finished` | Loading had completed before crash |
| `GlobalMode/IsClosing` | `false` | Not in explicit closing state yet |
| `Engine/SafeInit` | `Finished` | Engine init completed |

**The smoking gun: `CompileScriptsSuccess=false`.**

### 6. Crash Module List (`report.txt`)

The loaded module list contains 177 entries. Key modules present:

| Module # | Name | Present |
|---|---|---|
| 68 | RED4ext.dll | ✅ |
| 70 | cyber_engine_tweaks.asi | ✅ |
| 78 | ArchiveXL.dll | ✅ |
| 79 | Codeware.dll | ✅ |
| 81 | TweakXL.dll | ✅ |
| — | **HoverRotTesterPlayer9_1a.dll** | **❌ ABSENT** |

**The 9.1a DLL is NOT in the crash session's loaded modules.** This confirms the crash happened **after the user removed the 9.1a DLL** from deployment.

### 7. Save Metadata (`attch/metadata.9.json`)

This is **save game metadata** (not crash metadata as log_summary1.md claimed):

| Field | Value |
|---|---|
| Save name | AutoSave-13 |
| Timestamp | 09:45:41, 16.08.2026 |
| Level | 41 |
| Difficulty | VeryHard |
| isModded | true |
| Save version | 269 |
| Game version | 2310 |
| Play time | ~38.9 hours |
| Life path | Corporate |
| Gender | Female |
| Active quests | q301 active (Phantom Liberty) |

---

## Reconstructed Timeline

| Time | Session | Event |
|---|---|---|
| ~09:31 | **Session 1** (9.1a installed) | Game launches. RED4ext v1.30.0 loads all 4 plugins successfully. Redscript compiles all scripts including `HoverRotPlayer9_1a.reds` — native function declarations baked into `final.redscripts.modded`. No errors in RED4ext or redscript logs. **But user reports CET doesn't work** — no console, no scripting log, other CET mods dead |
| — | User action | User removes 9.1a from deployment (RED4ext DLL, redscript file, CET mod) — but likely does NOT clear `r6/cache/final.redscripts.modded` |
| ~09:41 | **Session 2** (9.1a removed) | Game launches without 9.1a DLL. Cached `final.redscripts.modded` still contains native function declarations (`HoverRotPlayer9_1a_DumpComponents`, etc.) that no longer have C++ implementations. Engine attempts script validation → **fails** (`CompileScriptsSuccess=false`). Script VM is broken. CET depends on script VM → CET still dead. After ~149 seconds, during quit, engine throws unhandled C++ exception (0xE06D7363) → **crash on quit** |
| ~09:55 | **Session 3** (9.1a reinstalled?) | Plugin log shows 9.1a DLL loaded and RTTI callbacks registered. This may be the user reinstalling the DLL to try to fix things, or a separate test attempt |

---

## What 9.1a Contains

| Component | File | Details |
|---|---|---|
| CET mod | `cet/init.lua` (32,312 bytes) | Diagnostic logging tester — hotkeys, hover PD controller, ImGui panel, CET-level probes, bridge calls to C++ native functions. Hotkeys at file root level (per CET hotkey rule). Calls `CheckNativeAvailable()` in onInit via redscript bridge |
| RED4ext plugin | `red4ext/bin/HoverRotTesterPlayer9_1a.dll` (88,064 bytes) | 4 native C++ functions using raw memory offsets to read entity transforms, components, skeleton/bone data |
| Redscript bridge | `redscript/HoverRotPlayer9_1a.reds` (3,614 bytes) | Declares 4 `native func` declarations + `HoverRotPlayer9_1aBridge` ScriptableSystem class |
| Source code | `red4ext/src/Main.cpp` (23,232 bytes) | Full C++ source with raw memory access at hardcoded offsets |

### Native Functions Declared in Redscript

```redscript
public static native func HoverRotPlayer9_1a_DumpComponents() -> String
public static native func HoverRotPlayer9_1a_DumpSkeleton() -> String
public static native func HoverRotPlayer9_1a_DumpEntityTransform() -> String
public static native func HoverRotPlayer9_1a_GetStatus() -> String
```

These `native func` declarations tell the redscript compiler that the implementations exist in a RED4ext C++ plugin. When compiled, they become entries in the cached `final.redscripts.modded` blob that the engine validates against registered native functions at runtime.

---

## Hypotheses: What Broke the Game

### Hypothesis 1: Stale Redscript Cache with Orphaned Native Declarations (Most Likely for Post-Removal State)

**Evidence:**
- `CompileScriptsSuccess=false` in crash dump
- 9.1a DLL absent from crash session loaded modules (user removed it)
- `HoverRotPlayer9_1a.reds` declares 4 `native func` that require C++ implementations
- Session 1 compiled these declarations into `final.redscripts.modded`
- User removed the DLL but likely didn't clear `r6/cache/final.redscripts.modded`
- `Engine/Scripts/Loaded=true` with `BlobPathUsed=Loaded` — engine loaded the stale cached blob
- `Engine/Scripts/ShouldCompileScripts=true` — engine tried to recompile but failed

**Theory:**
When the 9.1a DLL is removed but the cached script blob (or the redscript source file) remains, the engine tries to validate/load scripts that reference native functions with no implementation. Script validation fails (`CompileScriptsSuccess=false`), which breaks the entire script VM. CET depends on the script VM to interface with game systems — without it, CET's Lua runtime can't bind to game objects, so no CET mods execute, no console appears, and no scripting log is produced.

This perfectly explains why removing 9.1a files didn't restore CET: the cached blob was still poisoned with orphaned native declarations.

**Fix:**
1. Delete `r6/cache/final.redscripts.modded` (force recompilation from clean sources)
2. Remove `r6/scripts/HoverRotPlayer9_1a/` if still present
3. Launch game — redscript will recompile without 9.1a's native declarations
4. Verify CET works again

### Hypothesis 2: CET Disabled by Native Function Registration Conflict (Explains Session 1)

**Evidence:**
- In Session 1, RED4ext and redscript both succeeded, yet CET was already dead
- The 9.1a DLL registers 4 native global functions via RTTI (`PostRegisterTypes` in Main.cpp)
- CET's `onInit` calls `CheckNativeAvailable()` which calls `HoverRotPlayer9_1a_GetStatus()` via the redscript bridge
- The crash dump from Session 2 shows `CompileScriptsSuccess=false` even before the DLL was removed

**Theory:**
Even with the DLL present, the native function registration may conflict with CET's script binding system. CET runs as `cyber_engine_tweaks.asi` and binds Lua functions to game script types. If the 9.1a plugin's RTTI registration of global native functions happens at a point in the initialization sequence that interferes with CET's binding pass, CET could fail to initialize its Lua runtime. Alternatively, if calling `HoverRotPlayer9_1a_GetStatus()` from CET's `onInit` (via the redscript bridge) triggers an unhandled exception in the C++ code (e.g., `GetPlayerEntity()` returns null during early init and the error handling path has a bug), it could crash the CET Lua state — and since CET runs all mods in a shared Lua state, one crash kills all CET mods.

**Note:** CET's `onInit` wraps the bridge call in `pcall`, which should catch Lua-level errors. But a C++ exception thrown through Lua's C API can bypass `pcall` and corrupt the Lua state.

### Hypothesis 3: Raw Memory Offset Mismatch in C++ Plugin

**Evidence:**
- Main.cpp uses hardcoded memory offsets: Entity+0xA0 (components), +0xB0 (transformComponent), AnimatedComponent+0x138 (rig), IPlacedComponent+0xE0 (worldTransform), IScriptable+0x30 (nativeType), CClass+0x18 (name)
- These offsets are documented as "verified from SDK headers" but the game build is 3.0.5294808 (patch 2.31, Aug 2025)
- The RED4ext SDK version used to build the DLL may not match patch 2.31's memory layout
- The plugin's `Query()` function declares `RED4EXT_V1_RUNTIME_VERSION_LATEST` and `RED4EXT_V1_SDK_VERSION_CURRENT` — if these resolve to a different version than what RED4ext v1.30.0 expects, there could be an ABI mismatch

**Theory:**
If the hardcoded memory offsets are wrong for patch 2.31, calling any of the 4 native functions would read/write invalid memory. However, these functions are only called on-demand via hotkeys or CET bridge calls, not during plugin initialization. The plugin log shows successful load with no errors. The crash happened during save loading / quit, not during a hotkey press. So this hypothesis is less likely to explain the crash, but could explain CET dying if `CheckNativeAvailable()` → `GetStatus()` → `GetPlayerEntity()` hits a bad pointer during early init.

### Hypothesis 4: C++ Exception During Script VM Shutdown

**Evidence:**
- Crash exception code is `0xE06D7363` — this is the Microsoft C++ exception code (thrown by `RaiseException`), not an access violation (0xC0000005)
- `Engine/RequestExit=true` — engine was shutting down
- `CompileScriptsSuccess=false` — script VM is in a broken state
- The crash is an "Unhandled exception" with `<Unknown>` file/line — the engine threw a C++ exception that nobody caught

**Theory:**
With the script VM broken (`CompileScriptsSuccess=false`), when the engine tries to shut down, it calls shutdown handlers that depend on the script VM. These handlers encounter the broken script state and throw a C++ exception. Since the script VM is broken, the exception handler itself may fail, leading to an unhandled exception → crash. This is a secondary effect of Hypothesis 1 — the crash on quit is a consequence of the broken script VM, not an independent issue.

---

## Why log_summary1.md Was Wrong

| Claim in log_summary1.md | Reality |
|---|---|
| "RED4ext v2.0.0" | RED4ext v1.30.0 |
| "Game v2.22" | Patch 2.31 |
| "Logs heavily corrupted" | All logs perfectly readable |
| "Redscript log cross-contaminated with RED4ext messages" | Redscript log contains only redscript content |
| "Crash report files are 0 bytes" | All files have real content (6,301 / 141 / 4,029 / 705 bytes etc.) |
| "metadata.9.json is corrupted on disk" | It's valid save metadata (4,260 bytes, valid JSON) |
| "DLL is 35,840 bytes" | DLL is 88,064 bytes |
| "Memory corruption in RED4ext host process" | No evidence of memory corruption; crash is 0xE06D7363 (C++ exception) |
| "Progressive degradation in log buffer" | Logs are clean and sequential |
| Missing entirely | `CompileScriptsSuccess=false` — the actual smoking gun |
| Missing entirely | 9.1a DLL absent from crash session module list |
| Missing entirely | `Engine/RequestExit=true` (crash during quit) |

---

## Recommendations

### Immediate Fix (to restore CET)

1. **Delete the stale script cache:** Remove `<game>/r6/cache/final.redscripts.modded` — this forces redscript to recompile from source on next launch
2. **Remove 9.1a redscript source** if still present: Delete `<game>/r6/scripts/HoverRotPlayer9_1a/`
3. **Remove 9.1a CET mod** if still present: Delete `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/HoverRotTesterPlayer9_1a/`
4. **Remove 9.1a RED4ext plugin** if still present: Delete `<game>/red4ext/plugins/HoverRotTesterPlayer9_1a/`
5. **Launch game** — redscript will recompile without 9.1a's native declarations, script VM should be clean, CET should work

### If CET Was Already Broken Before Removal (Session 1)

If the user confirms CET was dead even with 9.1a fully installed, the problem is deeper than stale cache:

6. **Test with DLL only (no redscript, no CET mod):** Deploy only the RED4ext DLL, remove the redscript and CET files. If CET works, the redscript native declarations or the CET bridge calls are the problem.
7. **Test with redscript only (no DLL, no CET mod):** Deploy only the redscript file. If CET breaks, the `native func` declarations themselves cause script validation failure even when the DLL is present.
8. **Review `GetPlayerEntity()` in Main.cpp:** During CET's `onInit`, `CheckNativeAvailable()` calls `GetStatus()` which calls `GetPlayerEntity()`. If the player entity doesn't exist yet during CET init, `ExecuteGlobalFunction("GetPlayer;GameInstance")` may return a null handle. The code checks for this and returns an error string, but the `RED4ext::Handle<IScriptable>` destructor or the `ScriptGameInstance` constructor might throw a C++ exception that propagates through the Lua C API.
9. **Check RED4ext SDK version compatibility:** Verify that `RED4EXT_V1_RUNTIME_VERSION_LATEST` and `RED4EXT_V1_SDK_VERSION_CURRENT` in the built DLL match what RED4ext v1.30.0 expects. A mismatch could cause silent ABI issues.

### For Further Investigation

10. **Analyze `Cyberpunk2077.dmp`** with WinDbg or Visual Studio to get the actual call stack at crash time — this will pinpoint which function threw the 0xE06D7363 exception
11. **Get RED4ext + redscript logs from the crash session** — the logs we have are from Session 1 (09:31), but the crash was Session 2 (~09:41). The crash session's logs would show if script compilation failed there too
12. **Check if `final.redscripts.modded` still exists** in the game's `r6/cache/` directory — if it does, deleting it is the fix
13. **Binary diff 9.1 vs 9.1a DLLs** — compare the 88,064-byte 9.1a DLL against the 9.1 DLL to identify what changed
