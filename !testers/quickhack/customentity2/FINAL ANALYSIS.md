# FINAL ANALYSIS — Custom Entity Tester 2 (CE2)

> **Date**: 2026-08-09  
> **Tester**: `testers/quickhack/customentity2/`  
> **Goal**: Spawn a drone, use it as executor for a device quickhack via Red4ext-backed REDscript bridge  
> **Result**: Drone spawned, target acquired, **bridge access FAILED** — root cause identified

---

## 1. Executive Summary

CE2 attempted to prove that a spawned drone can serve as executor for device quickhack actions through a three-layer stack:

```
CET Lua -> REDscript Bridge (ScriptableSystem) -> Device Action Pipeline
                                                     ^
                                          Red4ext hooks IsPossible()
```

**The drone spawned successfully and the targeting system found a device.** However, the test stopped at the bridge access step because of two independent failures:

1. **CET Lua used the wrong API to access the ScriptableSystem** -- `Game.GetScriptableSystem()` instead of `Game.GetScriptableSystemsContainer():Get()`
2. **The Red4ext C++ plugin is a stub** -- the IsPossible hook was never actually registered (commented-out pseudo-code)

Neither of these is a fundamental architecture problem. The REDscript bridge compiled correctly, the ScriptableSystem class is properly defined, and the native pipeline call sequence (GenerateContext -> GetQuickHackActions -> SetUp -> CompleteAction) is sound. The fixes are concrete and well-understood.

---

## 2. Test Results: What Worked and What Didn't

### What Worked

| Component | Evidence | Log Source |
|---|---|---|
| CET mod loaded | `Mod customentity2 loaded!` | CET log |
| Red4ext initialized | `RED4ext (v1.30.0) is initializing...` + 921,876 addresses loaded | Red4ext log |
| Red4ext DLL loaded | `OrbHackingBridge (version: 1.0.0, author(s): CE2) has been loaded` | Red4ext log |
| Redscript compiled | `OrbHackingBridge.reds` in compilation list, `Compilation complete` | Redscript log |
| Hotkeys registered | CE2 init log shows `CE2 initialized` | CET log |
| Drone spawned | `DRONE SPAWNED SUCCESSFULLY! Tick: 12, Method: exEntitySpawner` | CET log |
| Spawn method | Method A (exEntitySpawner) with `base\vehicles\special\av_zetatech_bombus__basic.ent` | CET log |
| Target acquisition | `Target found with args (true, false)` -- TV at 5.4m | CET log |
| Drone despawn | `Drone despawned` on shutdown | CET log |

### What Failed

| Component | Evidence | Root Cause |
|---|---|---|
| Bridge access | `WARNING: OrbHackingBridge not found` | Wrong CET API -- see section 3.1 |
| IsPossible hook | No `[OrbHackingBridge] IsPossible: bypassing` in logs | Hook never registered -- see section 3.2 |
| CE2_DRONE tag | Tag only set in Method B (DynamicEntitySpec), but Method A was used | See section 3.3 |
| Ping quickhack execution | Never reached -- bridge was nil | Blocked by bridge access failure |

### Test Session Timeline

| Time | Event | Result |
|---|---|---|
| 15:54:01 | Red4ext initializes | OK |
| 15:54:03 | OrbHackingBridge.dll loads | OK (but stub) |
| 15:54:07 | Redscript compiles OrbHackingBridge.reds | OK |
| 15:54:20 | CE2 mod initializes | OK |
| 15:55:21 | First drone spawn | OK Method A, tick 12 |
| 15:55:36 | First ping test | FAIL NO_TARGET (not looking at device) |
| 16:17:28 | Second ping test | FAIL Target found (TV, 5.4m) but bridge nil |
| 16:20:41 | Session end, drone despawned | OK |

---

## 3. Root Cause Analysis

### 3.1 -- Wrong API: `Game.GetScriptableSystem()` vs `Game.GetScriptableSystemsContainer():Get()`

**This is the primary blocker.**

The CET Lua code in `init.lua` uses:
```lua
local function GetBridge()
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystem(BRIDGE_NAME)  -- WRONG
    end)
    ...
end
```

**Evidence from working mods:** Every mod in the project's source collection that accesses a ScriptableSystem from CET Lua uses `GetScriptableSystemsContainer():Get()`, not `GetScriptableSystem()`:

| Mod | Code |
|---|---|
| Equipment-EX Unlocker | `Game.GetScriptableSystemsContainer():Get("EquipmentEx.OutfitSystem")` |
| Arrest | `Game.GetScriptableSystemsContainer():Get(CName.new('EquipmentSystem'))` |
| Cyberscript Core | `GetScriptableSystemsContainer:Get('FastTravelSystem')` |
| Adaptive Traffic Headlights | `Game.GetScriptableSystemsContainer():Get("CityLightSystem")` |
| Immersive Meditations | `Game.GetScriptableSystemsContainer():Get("DarkFuture.Needs.DFNerveSystem")` |
| Immersive V Dialogue | `Game.GetScriptableSystemsContainer():Get('DataTrackingSystem')` |

**From REDscript side** (Equipment-EX source), the pattern for custom ScriptableSystems is:
```reds
public class OutfitSystem extends ScriptableSystem {
    public static func GetInstance(game: GameInstance) -> ref<OutfitSystem> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.OutfitSystem") as OutfitSystem;
    }
}
```

**Conclusion**: `Game.GetScriptableSystem()` either doesn't exist in CET's API surface, or doesn't work for custom (mod-created) ScriptableSystems. The correct access pattern is:
```lua
local bridge = Game.GetScriptableSystemsContainer():Get("OrbHackingBridge")
```

**Severity**: Critical -- this alone prevents the entire test from proceeding.

### 3.2 -- Red4ext C++ Plugin is a Stub (IsPossible Hook Never Registered)

**This is the secondary blocker (would matter after 3.1 is fixed).**

The `Main.cpp` file contains the hook registration as commented-out pseudo-code:

```cpp
// Pattern (pseudo-code, needs actual function address):
//   auto rtti = RED4ext::CRTTISystem::Get();
//   auto cls = rtti->GetClass(RED4ext::CName("BaseScriptableAction"));
//   auto func = cls->GetMethod(RED4ext::CName("IsPossible"));
//   g_HookTarget = func->GetAddress();
//   aSdk->hooking->Attach(aHandle, g_HookTarget,
//                         &IsPossible_Hook, &g_OriginalIsPossible);

LogInfo("[OrbHackingBridge] IsPossible hook registered (placeholder)");
```

The log confirms only the placeholder message appeared -- no actual hook was attached. The `HasCE2DroneTag()` function also always returns `true` (hardcoded stub).

The correct hooking pattern from the RED4ext SDK (`Hooking.hpp`) is:
```cpp
aSdk->hooking->Attach(aHandle, targetAddress, &IsPossible_Hook,
                       reinterpret_cast<void**>(&g_OriginalIsPossible));
```

Where `targetAddress` must be resolved via either:
- **RTTI lookup**: `CRTTISystem::Get()->GetClass()->GetMethod()->GetAddress()`
- **Offset-based**: `RED4EXT_OFFSET_TO_ADDR(offset - RED4ext::Addresses::ImageBase)`

Neither was implemented. The plugin loads and unloads cleanly but does nothing.

**Severity**: High -- without a real hook, IsPossible will return false for a drone executor, and the bridge will return `"NOT_POSSIBLE"`.

**However**: This may not be needed for Phase 1 (player as executor). See section 6.

### 3.3 -- CE2_DRONE Tag Not Set on Spawned Drone

The CET Lua code defines tag-setting only for Method B (DynamicEntitySpec):
```lua
spec.tags = { "CE2_DRONE" }  -- Method B only
```

But Method A (exEntitySpawner.Spawn) was the successful spawn method, and it has no tag-setting mechanism. Since the Red4ext hook's `HasCE2DroneTag()` is a stub returning `true`, this is currently a non-issue -- but once real tag checking is implemented, the drone needs to be identifiable.

**Mitigation options for 2a**:
- Store the drone's EntityID in Lua state and pass it to the bridge for comparison
- Use `Game.FindEntityByID()` to verify the executor is our drone
- Set tag post-spawn via REDscript or entity component access

**Severity**: Low for Phase 1, Medium for Phase 2 (drone executor).

---

## 4. Evidence Log

### 4.1 -- CET Log Key Lines

```
[CE2] CE2 initialized -- requires Red4ext + Redscript + CET
[CE2] Red4ext plugin: bin/x64/plugins/red4ext/plugins/OrbHackingBridge/OrbHackingBridge.dll
[CE2] Redscript: r6/scripts/OrbHackingBridge.reds

[CE2] DRONE SPAWNED SUCCESSFULLY! Tick: 12, Method: exEntitySpawner, Path: base\vehicles\special\av_zetatech_bombus__basic.ent

[CE2] PING QUICKHACK TEST
[CE2] Target found with args (true, false)
[CE2] Target: ToCName{ hash_lo = 0xB5C76B6F, hash_hi = 0x09352207 --[[ TV --]] }
[CE2] Target distance: 5.4 m
[CE2] WARNING: OrbHackingBridge not found -- check Redscript + Red4ext installation
```

Note: `GetBridge()` was called during `onUpdate` (on spawn) AND during `RunPingTest`. Both returned nil. No `Bridge loaded: OrbHackingBridge` line ever appeared in the log.

### 4.2 -- Red4ext Log Key Lines

```
[RED4ext] Loading plugin from '...red4ext\plugins\OrbHackingBridge\OrbHackingBridge.dll'...
[RED4ext] OrbHackingBridge (version: 1.0.0, author(s): CE2) has been loaded
[RED4ext] 4 plugin(s) loaded
```

No `[OrbHackingBridge] Plugin loaded` or `IsPossible: bypassing` lines appear -- the plugin's `Main()` function runs but the hook is never attached.

### 4.3 -- Redscript Log Key Lines

```
OrbHackingBridge.reds
[INFO] Compilation complete
[INFO] Output successfully saved to ...r6\cache\final.redscripts.modded
```

The REDscript compiled without errors, confirming the `OrbHackingBridge` class definition is syntactically valid.

### 4.4 -- Source Code Evidence: Wrong API

`init.lua` line ~107:
```lua
local function GetBridge()
    if state.bridge then return state.bridge end
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystem(BRIDGE_NAME)  -- WRONG API
    end)
    ...
end
```

Working mod comparison (Equipment-EX Unlocker, `init.lua:222`):
```lua
EQXUnlocker.outfitSystem = Game.GetScriptableSystemsContainer():Get("EquipmentEx.OutfitSystem")
```

### 4.5 -- Source Code Evidence: Stub Hook

`Main.cpp` lines ~100-115:
```cpp
// Register the IsPossible hook using RED4ext's hooking system.
//
// Pattern (pseudo-code, needs actual function address):
//   auto rtti = RED4ext::CRTTISystem::Get();
//   ...

LogInfo("[OrbHackingBridge] IsPossible hook registered (placeholder)");
g_IsReady = true;
```

`OrbHackingBridge.cpp` lines ~14-18:
```cpp
bool OrbHackingBridge::HasCE2DroneTag(void* entity) {
    // TODO: Implement with RED4ext RTTI
    // Placeholder: always return true
    return true;
}
```

---

## 5. Architecture Review: What CE2 Built

### 5.1 -- The Three-Layer Stack

```
+-------------------------------------------------------+
|  CET Lua (init.lua)                                    |
|  - Spawns drone via exEntitySpawner                    |
|  - Acquires target via GetLookAtObject                 |
|  - Calls bridge:ExecuteDeviceActionByName()            |
|  - WRONG: Uses Game.GetScriptableSystem()              |
+-------------------+-----------------------------------+
                    | (broken -- nil return)
+-------------------v-----------------------------------+
|  REDscript Bridge (OrbHackingBridge.reds)              |
|  - extends ScriptableSystem                            |
|  - ExecuteDeviceAction():                              |
|    1. device as Device -> GetDevicePS()                |
|    2. GenerateContext(Remote, clearance, executor)     |
|    3. GetQuickHackActions(actions, context)            |
|    4. Find action by name                               |
|    5. action.SetUp(ps) <- THE CRITICAL STEP            |
|    6. action.SetExecutor(executor)                     |
|    7. action.IsPossible(executor) <- needs Red4ext     |
|    8. action.CompleteAction(game)                      |
|  - Compiles correctly                                  |
+-------------------+-----------------------------------+
                    |
+-------------------v-----------------------------------+
|  Red4ext Plugin (Main.cpp)                             |
|  - Hooks BaseScriptableAction::IsPossible              |
|  - Returns true for CE2_DRONE-tagged drones            |
|  - STUB: Hook never actually attached                  |
|  - STUB: HasCE2DroneTag always returns true            |
+-------------------------------------------------------+
```

### 5.2 -- What's Correct in CE2

- **REDscript bridge class**: Properly extends `ScriptableSystem`, compiles cleanly
- **Action lookup pattern**: GenerateContext -> GetQuickHackActions -> name match is the verified working pattern
- **SetUp(ps) call**: This is the critical missing step from CET-only approaches -- REDscript can call it
- **CompleteAction(game)**: Correct terminal call (no need for StartAction/ResolveAction separately)
- **Spawn method**: exEntitySpawner with proven entity path works reliably
- **Targeting fallback**: Trying multiple GetLookAtObject arg combos is smart
- **Hotkey registration**: At file root level, wrapped in SafeCall/pcall -- correct
- **Async spawn polling**: onUpdate polling for entity readiness is correct

### 5.3 -- What's Broken in CE2

- **Bridge access API**: `Game.GetScriptableSystem()` -> should be `GetScriptableSystemsContainer():Get()`
- **Red4ext hook**: Entire C++ plugin is placeholder code
- **Tag setting**: Only in Method B, but Method A is what works
- **No fallback for bridge nil**: If bridge fails, test stops with a warning -- no alternative path

---

## 6. Blueprint for 2a Tester

### 6.1 -- Strategy: Phase 1 First (Player as Executor)

The shell entity proposal (`docs/device hacks/proposal - shell entity for device hacking.md`) recommends a phased approach. CE2 jumped to Phase 2 (drone executor + Red4ext hook) without proving Phase 1 (bridge works with player as executor).

**2a should prove Phase 1 first**: Fix the bridge access, use the player as executor, and confirm that `SetUp(ps)` + native pipeline execution produces a visible device hack effect. Only then add the drone executor complexity.

### 6.2 -- Required Fixes for 2a

#### Fix 1: Bridge Access API (Critical)

**In CET Lua `init.lua`:**

```lua
-- BEFORE (broken):
local bridge = Game.GetScriptableSystem("OrbHackingBridge")

-- AFTER (correct):
local bridge = Game.GetScriptableSystemsContainer():Get("OrbHackingBridge")
```

Add a fallback with CName:
```lua
local function GetBridge()
    if state.bridge then return state.bridge end
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystemsContainer():Get("OrbHackingBridge")
    end)
    if not ok or not bridge then
        -- Fallback: try with CName
        ok, bridge = pcall(function()
            return Game.GetScriptableSystemsContainer():Get(CName.new("OrbHackingBridge"))
        end)
    end
    if ok and bridge then
        state.bridge = bridge
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded: %s', BRIDGE_NAME))
        return bridge
    end
    return nil
end
```

#### Fix 2: Test Player as Executor First (Phase 1)

**In CET Lua `RunPingTest()`:**

```lua
-- Phase 1: Use player as executor to prove the bridge works
local bridge = GetBridge()
if not bridge then
    Log('ERROR: Bridge still not found after API fix')
    return
end

-- Test with PLAYER as executor (no drone needed, no IsPossible hook needed)
Log('Phase 1: Player as executor')
local ok, result = pcall(function()
    return bridge:ExecuteDeviceActionByName(target, "PingDevice", player)
end)
if ok then
    Log(string.format('Bridge result (player): %s', tostring(result)))
else
    Log(string.format('Bridge error (player): %s', tostring(result)))
end
```

**Why player first?**
- Player has a cyberdeck -> IsPossible returns true naturally
- No Red4ext hook needed -> eliminates one failure layer
- Proves the REDscript bridge (SetUp + native pipeline) actually works
- If this produces a visible ping effect, the bridge is proven

#### Fix 3: Keep Drone Spawn + Test Drone Executor (Phase 2)

Only after Phase 1 succeeds:

```lua
-- Phase 2: Drone as executor (needs IsPossible bypass)
if state.entity then
    Log('Phase 2: Drone as executor')
    local ok2, result2 = pcall(function()
        return bridge:ExecuteDeviceActionByName(target, "PingDevice", state.entity)
    end)
    if ok2 then
        Log(string.format('Bridge result (drone): %s', tostring(result2)))
    else
        Log(string.format('Bridge error (drone): %s', tostring(result2)))
    end
end
```

**Expected Phase 2 result without Red4ext hook**: `"NOT_POSSIBLE"` -- the bridge reaches IsPossible but it returns false for the drone. This is expected and proves the bridge works but the executor validation blocks the drone.

#### Fix 4: Red4ext Hook -- Defer or Implement

**Option A: Defer Red4ext entirely for 2a**

If Phase 1 (player executor) succeeds, the bridge is proven. The drone executor will return `NOT_POSSIBLE` without the hook, which is expected behavior. This is a valid 2a result -- it proves the bridge and identifies IsPossible as the remaining gate.

**Option B: Implement real hook for 2a**

If we want to go all the way in 2a, the Red4ext plugin needs:

```cpp
// In Main.cpp, Load case:
auto rtti = RED4ext::CRTTISystem::Get();
rtti->AddRegisterCallback(RegisterTypes);

// In a PostRegisterTypes or OnReady callback:
auto rtti = RED4ext::CRTTISystem::Get();
auto cls = rtti->GetClass(RED4ext::CName("BaseScriptableAction"));
if (cls) {
    auto func = cls->GetMethod(RED4ext::CName("IsPossible"));
    if (func) {
        auto addr = func->GetAddress();
        if (addr) {
            aSdk->hooking->Attach(aHandle, addr,
                &IsPossible_Hook,
                reinterpret_cast<void**>(&g_OriginalIsPossible));
        }
    }
}
```

**Tag checking**: Replace the stub with actual entity ID comparison. Store the drone's EntityID from CET and pass it via a registered function to the Red4ext plugin.

**Recommendation**: Start with Option A (defer Red4ext). Prove the bridge. Then implement the hook in 2b if needed.

### 6.3 -- 2a Tester File Structure

```
testers/quickhack/customentity2a/
|-- cet/
|   `-- init.lua              # Fixed bridge access + Phase 1/2 tests
|-- redscript/
|   `-- OrbHackingBridge.reds  # Same as CE2 (already compiles correctly)
|-- FINAL ANALYSIS.md         # This file (reference)
|-- README.md                 # Updated with Phase 1/2 testing steps
`-- deploy.md                 # Updated deployment (no Red4ext needed for Phase 1)
```

**Key difference from CE2**: No `red4ext/` directory needed for Phase 1. The 2a tester deploys only 2 files:
1. `cet/init.lua` -> CET mods folder
2. `redscript/OrbHackingBridge.reds` -> r6/scripts/

### 6.4 -- 2a Testing Protocol

| Step | Action | Expected Result |
|---|---|---|
| 1 | Deploy init.lua + OrbHackingBridge.reds | Both load without errors |
| 2 | Check CET log for `Bridge loaded: OrbHackingBridge` | Bridge accessible |
| 3 | Look at a hackable device (camera, TV, turret) | Target acquired |
| 4 | Press ping test hotkey (Phase 1: player executor) | `Bridge result (player): SUCCESS` |
| 5 | Verify visible ping effect in game | Device shows ping/hack visualization |
| 6 | Spawn drone, look at device, press ping test (Phase 2) | `Bridge result (drone): NOT_POSSIBLE` |
| 7 | Analyze: Phase 1 success = bridge proven; Phase 2 failure = IsPossible gate confirmed |

### 6.5 -- Expected Outcomes and Their Meanings

| Phase 1 Result | Phase 2 Result | Meaning |
|---|---|---|
| SUCCESS | NOT_POSSIBLE | Bridge works! IsPossible is the only gate for drone. Build Red4ext hook for 2b. |
| SUCCESS | SUCCESS | Bridge works AND drone passes IsPossible naturally! No Red4ext needed. |
| SUCCESS | ERROR | Bridge works but drone executor causes a different error. Investigate. |
| NO_ACTION | -- | Device has no PingDevice quickhack. Try a different device or action. |
| NOT_POSSIBLE | -- | Even player fails IsPossible. Check if player has cyberdeck equipped. |
| ERROR | -- | Bridge call itself errors. Check REDscript method signatures. |
| Bridge still nil | -- | API fix didn't work. Try CName variant, check Redscript compilation. |

---

## 7. Open Questions

### 7.1 -- Does `Game.GetScriptableSystem()` Exist at All?

No working mod in the sources collection uses it. It may be:
- A CET function that only works for engine-registered systems (not mod-created ones)
- A function that exists but has different semantics
- Not actually present in CET's API (the pcall succeeds but returns nil)

**Resolution**: The 2a tester should try both APIs and log which one works:
```lua
Log(string.format('GetScriptableSystem exists: %s', tostring(Game.GetScriptableSystem ~= nil)))
Log(string.format('GetScriptableSystemsContainer exists: %s', tostring(Game.GetScriptableSystemsContainer ~= nil)))
```

### 7.2 -- Does the REDscript Bridge Actually Produce Visible Effects?

This is the core unproven hypothesis. The bridge calls:
1. `GenerateContext(Remote, ...)` -- uses Remote request type
2. `GetQuickHackActions(actions, context)` -- gets action descriptors
3. `action.SetUp(ps)` -- initializes action (THE critical step)
4. `action.SetExecutor(executor)` -- sets executor
5. `action.IsPossible(executor)` -- validation gate
6. `action.CompleteAction(game)` -- executes

The proposal document says `CompleteAction` should be sufficient (no need for `StartAction`/`ResolveAction`). But this has never been tested with a working bridge. Phase 1 of 2a will prove or disprove this.

**Risk**: If `CompleteAction` alone doesn't trigger the device PS handler, we may need to add `StartAction` or `ResolveAction` to the chain.

### 7.3 -- Is Red4ext Hooking Even Necessary?

If the drone passes IsPossible naturally (because it's a valid ScriptedPuppet/GameObject), then the entire Red4ext layer is unnecessary. The 2a Phase 2 test will answer this.

**Possible scenario**: IsPossible checks `IsDefined(executor)` and `executor.IsA(ScriptedPuppet)` -- drones ARE ScriptedPuppets, so this might pass. The Red4ext hook was designed speculatively based on the assumption that IsPossible checks for player-specific clearance. It might not.

### 7.4 -- Does PingDevice Produce a Visible Effect?

PingDevice reveals other devices on the network. The visible effect is a visual pulse/scan effect on connected devices. If the target device has no network connections, the ping may succeed (return SUCCESS) but produce no visible effect. For testing, use a device in a device network (cameras near access points, or devices in a cluster).

**Alternative**: Use `QuickHackDistraction` instead of `PingDevice` -- distraction has a more obvious visible effect (device turns on/off, makes noise).

---

## Appendix: File Inventory

| File | Status | Notes |
|---|---|---|
| `cet/init.lua` | Works (spawn + targeting) | Bridge access API needs fix |
| `redscript/OrbHackingBridge.reds` | Compiles correctly | No changes needed for 2a |
| `red4ext/src/Main.cpp` | Stub | Defer for 2a; implement in 2b if needed |
| `red4ext/src/OrbHackingBridge.cpp` | Stub | Same as above |
| `red4ext/src/OrbHackingBridge.hpp` | Stub | Same as above |
| `red4ext/CMakeLists.txt` | Valid | Not needed for 2a Phase 1 |
| `red4ext/red4ext.manifest.json` | Unnecessary | v1 plugins use Query() export, not manifest |

---

*Analysis based on CET log, Red4ext log, Redscript log, source code review, 20+ working mod source comparisons, RED4ext SDK Hooking.hpp, and project documentation. Generated 2026-08-09.*
