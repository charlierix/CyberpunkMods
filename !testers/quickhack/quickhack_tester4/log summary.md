# Quickhack Tester 4 - Log Summary

## Overview

| Property | Value |
|---|---|
| **Log file** | `log.txt` |
| **Total lines** | 710 |
| **File size** | 94,887 bytes |
| **Session start** | 2026-07-26 17:14:22 UTC-05:00 |
| **Session end** | 2026-07-26 17:54:37 UTC-05:00 |
| **Duration** | ~40 minutes |
| **Mod version** | QHTester4 (v4: xpcall error capture, SetObjectActionID, PS handler bypass, DeviceSystem direct, Get Report) |

## Initialization (17:14:22)

- `QHTester4` initialized with `debug: true`, `maxDistance: 20.0`
- 5 hotkeys registered: Apply Quickhack, Cycle Hack, Clear Cache, Execute via PS, Get Report
- LuaVM initialization finished

## Targets Tested

| # | Device Type | Actions Found | Time Range | Strategies Used |
|---|---|---|---|---|
| 1 | **Reflector** | 8 | 17:17 - 17:21 | Strategy A, PS bypass |
| 2 | **Radio** | 4 | 17:22 - 17:24 | Strategy A, PS bypass |
| 3 | **Speaker** | 1 | 17:22 - 17:25 | Strategy A, PS bypass |
| 4 | **ExplosiveDevice** | 2 | 17:53 - 17:54 | Strategy A, PS bypass |

## Quickhack Types Discovered

| Label | Class | TweakDB Record | Hack Category |
|---|---|---|---|
| RemoteBreach | RemoteBreach | DeviceAction.RemoteBreach | DeviceHack (4) |
| Ping | PingDevice | DeviceAction.PingDevice | DeviceHack (4) |
| MalfunctionClassHack | QuickHackDistraction | DeviceAction.MalfunctionClassHack | DeviceHack (4) |
| OverloadClassHack | OverloadDevice | DeviceAction.OverloadClassHack | DeviceHack (4) |
| HighPitchNoiseQuickHack | QuickHackHighPitchNoise | DeviceAction.HighPitchNoiseQuickHack | DeviceHack (4) |
| OverloadClassHack | QuickHackExplodeExplosive | DeviceAction.OverloadClassHack | DeviceHack (4) |

## Per-Target Details

### 1. Reflector (8 actions)

Actions returned: RemoteBreach x3, Ping x3, MalfunctionClassHack x1, OverloadClassHack x1

- **Get Report** at 17:17:56 - listed all 8 actions with properties
  - All actions: IsPossible/CanInterrupt/IsVisible = `ERROR: error in error handling`
  - RemoteBreach: cost 0, activation 0
  - Ping: cost 0, activation 0
  - MalfunctionClassHack: cost 3, activation 0.5
  - OverloadClassHack: cost 0, activation 0

- **Apply Quickhack** attempts (Strategy A):
  - RemoteBreach at 17:19:53, 17:20:06, 17:20:59 - all same pattern
  - Ping at 17:20:45, 17:21:37 - same pattern

- **Execute via PS** at 17:21:16:
  - RemoteBreach: No PS handler mapped, GetDeviceById FAILED, PS execution failed

### 2. Radio (4 actions)

Actions returned: QuickHackDistraction, HighPitchNoiseQuickHack, RemoteBreach, Ping

- **Get Report** at 17:22:49
- **Apply Quickhack** (Strategy A):
  - QuickHackDistraction at 17:22:54
  - HighPitchNoiseQuickHack at 17:22:58
  - RemoteBreach at 17:22:59
- **Execute via PS** at 17:24:28:
  - QuickHackDistraction: No PS handler mapped, GetDeviceById FAILED, PS execution failed

### 3. Speaker (1 action)

Action returned: MalfunctionClassHack (QuickHackDistraction)

- **Get Report** at 17:22:14 and 17:24:55
- **Apply Quickhack** (Strategy A) at 17:24:59
- **Execute via PS** at 17:25:08 and 17:25:27:
  - Both attempts: No PS handler mapped, GetDeviceById FAILED, PS execution failed

### 4. ExplosiveDevice (2 actions)

Actions returned: MalfunctionClassHack (QuickHackDistraction), OverloadClassHack (QuickHackExplodeExplosive)

- **Get Report** at 17:53:59
  - MalfunctionClassHack: cost 3, activation 0.5
  - OverloadClassHack: cost 0, activation 0
- **Apply Quickhack** (Strategy A):
  - MalfunctionClassHack at 17:54:09
  - OverloadClassHack at 17:54:16
- **Execute via PS** at 17:54:31 and 17:54:37:
  - Both: No PS handler mapped, GetDeviceById FAILED, PS execution failed

## Execution Strategies

### Strategy A: Full Action Chain

Every Strategy A attempt followed the exact same pattern:

1. `SetRequesterID error: error in error handling` - **always fails**
2. `SetObjectActionID OK` - **always succeeds**
3. `IsPossible error: error in error handling` - **always fails**
4. `ResolveAction error: error in error handling` - **always fails**
5. `StartAction FAILED: error in error handling` - **always fails**
6. `ProcessRPGAction OK (may have used RAM)` - fallback **always returns OK**
7. `Quickhack applied: [hackname]` - logged as applied

### Execute via PS (PS Handler Bypass)

Every PS execution attempt followed the same pattern:

1. `SetRequesterID error: error in error handling` - **always fails**
2. `SetObjectActionID OK` - **always succeeds**
3. `No PS handler mapped for class: [classname]` - **always fails**
4. `Available mappings: QuickHackDistraction, QuickHackAuthorization, QuickHackToggleON, GlitchScreen*`
5. `--- PS failed, trying DeviceSystem ---`
6. `GetDeviceById FAILED: error in error handling` - **always fails**
7. `PS execution failed: [hackname]` - **always fails entirely**

## Error Analysis

### Universal Errors (every action, every device)

| Method | Status | Notes |
|---|---|---|
| `SetRequesterID` | FAIL | "error in error handling" on all attempts |
| `IsPossible` | FAIL | "error in error handling" on all attempts |
| `CanInterrupt` | FAIL | "error in error handling" (report mode) |
| `IsVisible` | FAIL | "error in error handling" (report mode) |
| `ResolveAction` | FAIL | "error in error handling" on all attempts |
| `StartAction` | FAIL | "error in error handling" on all attempts |
| `SetObjectActionID` | OK | Always succeeds |
| `ProcessRPGAction` | OK | Fallback always returns OK |
| `GetDeviceById` | FAIL | "error in error handling" on all PS attempts |

### PS Handler Mapping Issue

The PS handler has only 4 available mappings:
- `QuickHackDistraction`
- `QuickHackAuthorization`
- `QuickHackToggleON`
- `GlitchScreen*`

However, actual hack classes encountered do not match these mappings correctly:
- `RemoteBreach` class -> no mapping
- `PingDevice` class -> no mapping
- `QuickHackExplodeExplosive` class -> no mapping
- `QuickHackDistraction` class -> listed but still fails to execute

## Visible Results (from TEST RESULTS.md)

Only **RemoteBreach** produced any visible in-game effect: it pulled up the hack screen with an empty list and no real action on success. All other quickhack types produced no visible effect despite being logged as "applied" via ProcessRPGAction fallback.

## Conclusion

The QHTester4 mod successfully **discovered and enumerated** quickhack actions on 4 device types (15 total actions across 6 unique hack types). However, **actual execution failed universally**:

- **Strategy A** (full action chain): StartAction always fails, ProcessRPGAction fallback returns OK but produces no visible effect (except RemoteBreach pulling up an empty hack screen)
- **PS handler bypass**: Always fails - no handler mappings for most classes, and GetDeviceById fails for all

The core blocker is that `SetRequesterID`, `IsPossible`, `ResolveAction`, and `StartAction` all return "error in error handling" on every attempt, indicating a fundamental issue with how the action objects are being set up or how CET interacts with the game's action system.
