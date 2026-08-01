# Quickhack Tester — Log Summary

Comprehensive analysis of all three tester versions based on their CET console logs.

## At-a-Glance Results

| Feature | Tester1 | Tester2 | Tester3 |
|---|---|---|---|
| Action discovery | ✅ Worked | ❌ Always empty | ✅ Worked |
| List Available | ✅ 4 hacks found | ❌ 0 hacks | ✅ 4 hacks found |
| Cycle Hack | ⚠️ Hardcoded list | ❌ Never tested | ✅ Device's actual hacks |
| StartAction | ❌ Failed | ❌ Never tested | ❌ Always fails |
| CompleteAction | ❌ Failed | ❌ Never tested | ❌ Never reached (ProcessRPGAction hits first) |
| ProcessRPGAction | Not tried | Not tried | ⚠️ Reports OK but **no visual effect** |
| Visual effect on device | ❌ None | ❌ None | ❌ None |
| CName display | Verbose hash format | Verbose hash format | Verbose hash format (CNameToString not working) |

## Tester1 (v1) — Log Summary

**Source:** `testers/quickhack/quickhack_tester/log.txt` (29 lines)

### What Worked
- Targeting found the vending machine
- `ps:GetQuickHackActions(context)` returned **4 actions** via return-value convention
- List Available correctly showed all 4 quickhacks with labels and class names

### What Failed
- `StartAction(game)` failed on GlitchScreenSuicide
- `CompleteAction(game)` also failed
- No visual effect on the device

### Available Hacks Found (VendingMachine)

| # | Label (ActionName) | Class (GetClassName) |
|---|---|---|
| 1 | GlitchScreenSuicide | GlitchScreen |
| 2 | GlitchScreenBlind | GlitchScreen |
| 3 | GlitchScreenGrenade | GlitchScreen |
| 4 | MalfunctionClassHack | QuickHackDistraction |

### Cycle Behavior
- Cycled through a **hardcoded 7-item list** (Distraction, Toggle On/Off, Toggle Open, Call Elevator, Self-Destruct, Distract Explosives, Authorization)
- This list did **not** match the device's actual 4 available hacks
- Selected hack (Distraction) was not in the device's available list, so it fell back to first available (GlitchScreenSuicide)

### Key Log Lines
```
[QHTester] Available quickhacks (4):
  [1] GlitchScreenSuicide (class: GlitchScreen)
  [2] GlitchScreenBlind (class: GlitchScreen)
  [3] GlitchScreenGrenade (class: GlitchScreen)
  [4] MalfunctionClassHack (class: QuickHackDistraction)
[QHTester]   StartAction failed (continuing anyway)
[QHTester]   Falling back to CompleteAction (may give small XP)
[QHTester]   CompleteAction failed — hack may not have applied
```

---

## Tester2 (v2) — Log Summary

**Source:** `testers/quickhack/quickhack_tester2/log.txt` (50 lines)

### What Worked
- Targeting found devices (vending machine, TV)
- Mod initialized correctly

### What Failed
- **Action discovery always returned empty** — every single attempt on every device
- Both `GetQuickHackActions(outArray, context)` and `GetActions(outArray, context)` returned nothing
- No hacks could be listed, cycled, or applied

### Root Cause
v2 only used the **out-array calling convention**:
```lua
ps:GetQuickHackActions(actions, context)  -- actions stays empty in CET
```
CET's Lua bindings return arrays as **return values**, not via out-parameters. v1's working convention was:
```lua
local actions = ps:GetQuickHackActions(context)  -- returns the array
```
v2 removed this working convention, keeping only the broken one.

### Key Log Lines
```
[QHTester2] Target: VendingMachine
[QHTester2]   Could not retrieve quickhack actions from device PS
[QHTester2] No quickhack actions available
```
(Every attempt — vending machine, TV — produced the same result)

### Devices Tested
- VendingMachine (multiple attempts) — always empty
- TV — always empty

---

## Tester3 (v3) — Log Summary

**Source:** `testers/quickhack/quickhack_tester3/log.txt` (200 lines)

### What Worked
- Action discovery ✅ — `GetQuickHackActions(ctx)` return-value convention found 4 actions every time
- Cycle Hack ✅ — correctly cycled through 4/4 device hacks (GlitchScreenSuicide → GlitchScreenBlind → GlitchScreenGrenade → MalfunctionClassHack → back to 1)
- Clear Cache ✅ — cache clearing worked
- Caching ✅ — actions cached per target, no re-query needed for cycle
- Debug output showed which convention succeeded: `GetQuickHackActions(ctx) returned 4 actions (return-value convention)`
- TweakDB record IDs successfully extracted (e.g., `DeviceAction.GlitchScreenSuicide`)

### What Failed
- **`StartAction(game)` ALWAYS fails** — every hack, every attempt
- **`ProcessRPGAction(game)` reports OK but produces NO visual effect** on the device
- **`CNameToString()` not working** — logs still show full `ToCName{ hash_lo = 0x..., hash_hi = 0x... --[[ Name --]] }` format instead of clean names
- **No quickhack produced any visible effect** on the vending machine

### Execution Pattern (Every Apply Attempt)
```
[QHTester3] Selected: [N] <hack name> (class: <class>)
[QHTester3]   StartAction failed — trying fallbacks
[QHTester3]   ProcessRPGAction OK (may have used RAM)
[QHTester3] Quickhack applied: <hack name>
```
This pattern repeated for all 4 hacks across multiple test cycles. ProcessRPGAction always reports success but the device shows no effect.

### All 4 Hacks Tested

| # | Action Name | Class | TweakDB Record |
|---|---|---|---|
| 1 | GlitchScreenSuicide | GlitchScreen | DeviceAction.GlitchScreenSuicide |
| 2 | GlitchScreenBlind | GlitchScreen | DeviceAction.GlitchScreenBlind |
| 3 | GlitchScreenGrenade | GlitchScreen | DeviceAction.GlitchScreenGrenade |
| 4 | MalfunctionClassHack | QuickHackDistraction | DeviceAction.MalfunctionClassHack |

### CNameToString Bug
The `CNameToString()` function was supposed to extract clean names from CName tostring output. The regex pattern `%-%-%[%[(.-)%]%]%-%-` should match `--[[ Name --]]` but the logs show it's not working — full `ToCName{...}` strings appear in all output. Likely cause: `tostring(cname)` may return a userdata/object rather than a plain string, so Lua's `string.match` doesn't work on it.

### Test Sequence
1. **List Available** — 4 hacks found ✅
2. **Apply hack 1** (GlitchScreenSuicide) — StartAction failed, ProcessRPGAction OK, no effect
3. **Cycle to hack 2** — GlitchScreenBlind (2/4) ✅
4. **Apply hack 2** — StartAction failed, ProcessRPGAction OK, no effect
5. **Cycle to hack 3** — GlitchScreenGrenade (3/4) ✅
6. **Apply hack 3** — StartAction failed, ProcessRPGAction OK, no effect
7. **Cycle to hack 4** — MalfunctionClassHack (4/4) ✅
8. **Apply hack 4** — StartAction failed, ProcessRPGAction OK, no effect
9. **Cycle back to 1** — GlitchScreenSuicide (1/4) ✅
10. **Apply hack 1 again** — same failure pattern
11. **Clear Cache** — worked ✅
12. **List Available after clear** — re-queried, 4 hacks found ✅
13. **Second full cycle** — all 4 hacks applied again, same StartAction failure pattern
14. **Third round** — same results

---

## Root Cause Analysis: Why Quickhacks Have No Effect

### The Core Problem
`StartAction(game)` fails every time. This is the method that should:
1. Apply start effects (visuals, cooldowns)
2. Auto-call `CompleteAction` (for quickhacks with `canSkipPayCost = true`)
3. `CompleteAction` calls `QueuePSDeviceEvent(this)` which triggers the actual device effect

Since `StartAction` fails, the chain never executes. The fallback `ProcessRPGAction` reports OK but apparently doesn't trigger the device PS event properly — it goes through the RPG cost/action pipeline but may not actually queue the device event that causes the visual/effect change.

### Likely Reasons StartAction Fails

1. **Missing ObjectActionID** — The action may need a valid `ObjectActionID` set (TweakDB record reference) before StartAction can execute. The actions have record IDs (e.g., `DeviceAction.GlitchScreenSuicide`) but the action object may not have the ID properly linked.

2. **Missing completion/failure callbacks** — StartAction may require completion/failure callback objects to be set on the action before it can execute.

3. **Action not properly instantiated** — The actions returned by `GetQuickHackActions` may be read-only descriptors, not executable action instances. They may need to be cloned or re-created with proper setup.

4. **Game state requirements** — StartAction may check game state (breach mode, scanning mode, distance, line of sight) that isn't satisfied when calling from a hotkey outside the normal quickhack UI flow.

5. **Missing SetExecutor/SetRequesterID** — While the code calls `SetExecutor` and `SetRequesterID`, these may not be taking effect because of pcall wrapping or wrong method signatures.

### Why ProcessRPGAction Reports OK But Does Nothing
`ProcessRPGAction` handles the RPG cost pipeline (RAM cost, cooldowns, XP) but may short-circuit if the action isn't properly configured. It returns success from the pcall (meaning no Lua error was thrown) but the internal RED4 logic may have silently rejected the action. The user confirmed no RAM was consumed and no visual effect occurred — suggesting the action never reached the device PS.

---

## What's Confirmed Working

- ✅ Targeting: `Game.GetTargetingSystem():GetObjectClosestToCrosshair` with `TSF_Quickhackable` filter
- ✅ Device PS access: `target:GetDevicePS()`
- ✅ Action discovery: `ps:GetQuickHackActions(context)` (return-value convention)
- ✅ Action metadata: `GetActionName()`, `GetClassName()`, `GetObjectActionRecord():GetID()`
- ✅ Caching and cycling through device's actual available hacks
- ✅ Clear Cache hotkey
- ✅ Hotkey registration at file root level

## What's Not Working

- ❌ `StartAction(game)` — always fails
- ❌ `CompleteAction(game)` — failed in v1 (untested in v3 because ProcessRPGAction hits first)
- ❌ `ProcessRPGAction(game)` — reports OK but no effect
- ❌ `CNameToString()` — regex doesn't extract names
- ❌ No quickhack produces any visible device effect

---

## Recommendations for Next Steps

1. **Investigate StartAction failure cause** — wrap StartAction in a non-pcall try and capture the actual error message to see why it fails
2. **Try calling the device controller directly** — instead of going through the action object, try `Game.GetDeviceSystem():GetDeviceById(game, entityID)` and call device methods directly
3. **Try QueuePSDeviceEvent manually** — if CompleteAction calls `QueuePSDeviceEvent(this)`, try calling it directly on the PS
4. **Check if actions need activation** — the actions from `GetQuickHackActions` may need `Activate()` or similar before they can be started
5. **Research how the base game executes quickhacks** — the normal flow goes through `QuickhackSystem` / `HUDQuickhackMenuController` — examine how those classes trigger actions
6. **Fix CNameToString** — use `string.match(tostring(cname), "%-%-%[%[(.-)%]%]%-%-")` explicitly or try `CName({hash})` lookup
