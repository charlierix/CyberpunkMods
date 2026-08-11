# Log Summary — Custom Entity Tester 1b (CE1b)

## Overview

| Field | Value |
|---|---|
| **Tester** | customentity1b (CE1b) |
| **Session Date** | 2026-08-07 |
| **Session Times** | 20:25:38 – 20:56:42 (UTC-05:00) |
| **Mod Name** | customentity1b |
| **Target** | Cyberpunk 2077 v2.2+, CET 1.39.1+, RED4ext + REDscript |
| **Purpose** | Spawn drone + REDscript bridge quickhack test |
| **Overall Result** | **Partial Success** — drone spawn/despawn works; bridge not accessible from CET |

## Initialization

| Time | Event | Detail |
|---|---|---|
| 20:25:38 | REDscript compilation | OrbHackingBridge.reds compiled successfully (no errors) |
| 20:25:39 | CET mod load | customentity1b loaded along with 8 other mods |
| 20:25:51 | CE1b onInit | Tester initialized; 3 entity paths, 4 TweakDB records configured |
| 20:25:51 | Hotkey registration | 2 hotkeys registered: Spawn/Despawn Drone, Run Ping Quickhack Test |
| 20:25:51 | **Bridge lookup** | **FAILED** — `OrbHackingBridge not found. Is REDscript mod installed?` |
| 20:25:51 | EntityScanner | Initialized separately; LuaVM finished |

### Bridge Load Failure (Critical)

The REDscript log confirms `OrbHackingBridge.reds` was compiled at **20:25:38** with zero errors and output saved to `final.redscripts.modded`. However, when CE1b's `onInit` fired at **20:25:51** (13 seconds later), `Game.GetScriptableSystem("OrbHackingBridge")` returned nil.

This is **not** a compilation issue — the class compiled fine. The problem is that CET cannot access the ScriptableSystem at runtime.

### Unfixed Bridge Bug (Discrepancy)

The README documents a fix for `OrbHackingBridge.reds`: changing `Device.GetInteractionClearance()` (broken static call) to `deviceObj.GetInteractionClearance()` (correct instance call). However, **the actual deployed .reds file still contains the unfixed static call at line 57**:

```reds
// Line 57 of OrbHackingBridge.reds (UNFIXED):
Device.GetInteractionClearance(),  // still static — README says this should be deviceObj.GetInteractionClearance()
```

The file compiled without errors, which means `Device.GetInteractionClearance()` is valid syntax — but it may produce incorrect runtime behavior or prevent the ScriptableSystem from registering properly.

## Test Results

### Drone Spawning — SUCCESS ✅

Two complete spawn/despawn cycles, both using **Method A** (`exEntitySpawner.Spawn`) with the first candidate path:

| Cycle | Time | Action | Entity Path | Entity ID | Position | Ticks | Method |
|---|---|---|---|---|---|---|---|
| 1 | 20:32:54 | Spawn | `base\vehicles\special\av_zetatech_bombus__basic.ent` | `0x026f0a23d208` | (-618.58, -997.68, 7.37) | 10 | exEntitySpawner |
| 1 | 20:33:06 | Despawn | — | `0x026f0a23d208` | — | — | exEntitySpawner.Despawn |
| 2 | 20:56:19 | Spawn | `base\vehicles\special\av_zetatech_bombus__basic.ent` | `0x026d8aa1d318` | (-1968.96, -1686.55, 3.68) | 5 | exEntitySpawner |
| 2 | 20:56:42 | Despawn | — | `0x026d8aa1d318` | — | — | exEntitySpawner.Despawn |

**Key observations:**
- Method A (exEntitySpawner) worked on the first candidate path every time — Method B (DynamicEntitySpec) was never needed
- Spawn is asynchronous: entity appeared after 5–10 ticks of polling `Game.FindEntityByID()`
- Despawn completed successfully both times
- Position varies because it's relative to the player's current location

### Quickhack Test — NOT EXECUTED ❌

Two attempts were made, both blocked by the bridge being unavailable:

| Time | Attempt | Result |
|---|---|---|
| 20:56:22 | 1st | `WARNING: OrbHackingBridge not loaded -- cannot run ping test` |
| 20:56:38 | 2nd | `WARNING: OrbHackingBridge not loaded -- cannot run ping test` |

The ping quickhack test was never able to execute because the REDscript bridge was not accessible from CET Lua.

### User Test Notes (from TEST RESULTS.md)

- Drone spawned/despawned properly ✅
- Hacking cyberware installed with Ping attached ✅
- Facing a device that could be successfully pinged via standard quickhack ✅
- Ping hotkey for the drone produced an error (bridge not loaded) ❌

## Bridge Access Code

```lua
-- init.lua lines 96-108: Bridge lookup via GetScriptableSystem
local function GetBridge()
    if state.bridge then return state.bridge end
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystem(BRIDGE_NAME)  -- returns nil
    end)
    if ok and bridge then
        state.bridge = bridge
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded: %s', BRIDGE_NAME))
        return bridge
    end
    return nil  -- falls through here — bridge never found
end
```

## Error Summary

| # | Time | Error | Category | Resolved? |
|---|---|---|---|---|
| 1 | 20:25:51 | `OrbHackingBridge not found. Is REDscript mod installed?` | Bridge access | No |
| 2 | 20:25:51 | `Drone spawning will work but quickhack tests will fail.` | Consequence of #1 | No |
| 3 | 20:56:22 | `OrbHackingBridge not loaded -- cannot run ping test` | Bridge access | No |
| 4 | 20:56:38 | `OrbHackingBridge not loaded -- cannot run ping test` | Bridge access | No |

## Root Cause Analysis

### Primary Issue: ScriptableSystem Not Accessible from CET

The `OrbHackingBridge` class compiles as a `ScriptableSystem` subclass, but `Game.GetScriptableSystem("OrbHackingBridge")` returns nil from CET Lua. Possible causes:

1. **Unfixed static call** — `Device.GetInteractionClearance()` at line 57 may compile but produce a broken class that doesn't register as a functional ScriptableSystem at runtime. The README documents the fix (`deviceObj.GetInteractionClearance()`) but it was never applied to the deployed file.
2. **ScriptableSystem registration** — Custom ScriptableSystems may require additional registration beyond just extending the class. Some mods use `@wrapMethod` or `@addMethod` patterns instead.
3. **Timing/lifecycle** — The ScriptableSystem may not be available during CET's `onInit`. CE1b only calls `GetBridge()` once during init and never retries.
4. **GetScriptableSystem limitation** — This API may not resolve user-created ScriptableSystems by string name in all game versions.

### Secondary Issue: No Retry Logic

The bridge is only looked up once during `onInit`. If the ScriptableSystem becomes available later in the game lifecycle, CE1b never discovers it. A retry-on-demand pattern (calling `GetBridge()` each time the ping hotkey is pressed) would be more robust.

## Next Steps

1. **Apply the documented fix** — Change `Device.GetInteractionClearance()` to `deviceObj.GetInteractionClearance()` in `OrbHackingBridge.reds` line 57 (the fix described in README but never applied)
2. **Add retry logic** — Call `GetBridge()` at hotkey-press time, not just during `onInit`, so the bridge can be discovered if it becomes available later
3. **Verify ScriptableSystem registration** — Search reference mods (CustomHackingSystem, Much Better Netrunning) for how they expose their bridge classes to CET — they may use a different pattern than `extends ScriptableSystem`
4. **Consider alternative bridge access** — If `GetScriptableSystem` doesn't work for custom classes, investigate `@wrapMethod`/`@addMethod` hooks or a different interop mechanism
5. **Re-test** after applying the fix: spawn drone, face hackable device, press ping hotkey, check for `Bridge result: SUCCESS`

## Full CET Log (Chronological)

```
20:25:39  CET loads customentity1b (+ 8 other mods)
20:25:51  CE1b initialized — 3 entity paths, 4 TweakDB records
20:25:51  Hotkeys: Spawn/Despawn Drone, Run Ping Quickhack Test
20:25:51  WARNING: OrbHackingBridge not found
20:25:51  WARNING: Quickhack tests will fail
20:25:51  EntityScanner initialized; LuaVM finished
20:32:54  SPAWN DRONE — Method A [1/3] av_zetatech_bombus__basic.ent → SUCCESS
20:32:54  Entity ID: 0x026f0a23d208, Pos: (-618.58, -997.68, 7.37), 10 ticks
20:33:06  DESPAWN DRONE — 0x026f0a23d208 despawned
20:56:19  SPAWN DRONE — Method A [1/3] av_zetatech_bombus__basic.ent → SUCCESS
20:56:19  Entity ID: 0x026d8aa1d318, Pos: (-1968.96, -1686.55, 3.68), 5 ticks
20:56:22  PING QUICKHACK TEST — WARNING: bridge not loaded
20:56:38  PING QUICKHACK TEST — WARNING: bridge not loaded (2nd attempt)
20:56:42  DESPAWN DRONE — 0x026d8aa1d318 despawned
```

## Lineage Comparison

| Aspect | customentity1 | customentity1a | customentity1b |
|---|---|---|---|
| Drone spawn | Failed (invalid paths) | Success | **Success** |
| Bridge | Broken (compilation error) | N/A | Compiled but **not accessible** |
| Quickhack test | Not reached | N/A | **Not executed** (bridge unavailable) |
| Entity paths | `base\_ieee\...` (invalid) | `base\vehicles\special\av_zetatech_bombus__basic.ent` | Same as 1a ✅ |
| Bridge fix applied | N/A | N/A | **No** — README documents fix but .reds file still has static call |
