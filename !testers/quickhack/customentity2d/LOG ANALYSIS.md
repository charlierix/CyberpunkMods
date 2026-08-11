# LOG ANALYSIS — Custom Entity Tester 2d (CE2d)

> **Date**: 2026-08-09
> **Tester**: `testers/quickhack/customentity2d/`
> **REDscript**: `redscript/OrbHackingBridge.reds` (2d — reverted clearance method)
> **CET Lua**: `cet/init.lua` (reused from CE2c — **NOT changed**)
> **Result**: **MAJOR BREAKTHROUGH** — bridge pipeline works, fallback hacks execute successfully, **drone passes IsPossible() naturally**

---

## Important Note: CET Script Was Still CE2c

The folder is named `customentity2d`, but the CET Lua script was **reused from CE2c without any changes**. The CET log shows `[CE2c]` prefixes throughout because 2d was **only a REDscript change** — reverting `Device.GetInteractionQuickHackClearance()` (which doesn't exist) back to `Device.GetInteractionClearance()` (which compiles). The CET Lua, hotkeys, and all CET-side logic are identical to CE2c.

---

## 1. Executive Summary

CE2d proved that the **entire bridge pipeline works end-to-end**:

- REDscript compiled successfully (no errors)
- CET onInit didn't crash (pcall fix worked)
- Bridge loaded via `GetScriptableSystemsContainer():Get("OrbHackingBridge")`
- `ListAvailableActions()` correctly dumped all quickhack actions per device
- `ExecuteFirstAvailableAction()` successfully executed hacks on all devices
- **Both player AND drone executors returned SUCCESS** — the drone passes `IsPossible()` naturally without a Red4ext hook
- User observed **visible in-game effects** (food spitting, hacking minigame, speaker audio, glitched TV screen)

The only remaining issue is that the CET Lua searches for `"PingDevice"` but the actual action name in the game is `"Ping"` — so the specific-action lookup returns `NO_ACTION` and the fallback kicks in every time.

---

## 2. Log Status Summary

| Log | Status | Key Evidence |
|---|---|---|
| REDscript | **Compiled successfully** | `Compilation complete` (line 48) — no errors |
| CET | **No onInit crash** | `API check: GetScriptableSystem = false` logged safely (line 14) |
| Red4ext | **Loaded as stub** | `OrbHackingBridge (version: 1.0.0) has been loaded` (line 14) — no hook output |

---

## 3. What Worked

| Component | Evidence | Log Line |
|---|---|---|
| REDscript compilation | `Compilation complete` | redscript.txt:48 |
| CET onInit (pcall fix) | `API check: GetScriptableSystem = false` — no crash | cet.txt:14 |
| Bridge access | `Bridge loaded via GetScriptableSystemsContainer():Get("OrbHackingBridge")` | cet.txt:15 |
| Drone spawn | `DRONE SPAWNED SUCCESSFULLY! Tick: 10` | cet.txt:22 |
| Action dump (player) | `Player actions: 6 actions: GlitchScreenSuicide, GlitchScreenBlind, ...` | cet.txt:30 |
| Action dump (drone) | `Drone actions: 6 actions: GlitchScreenSuicide, GlitchScreenBlind, ...` | cet.txt:32 |
| Fallback execution (player) | `Phase 1 fallback result: SUCCESS (action: GlitchScreenSuicide)` | cet.txt:42 |
| Fallback execution (drone) | `Phase 2 fallback result: SUCCESS (action: GlitchScreenSuicide)` | cet.txt:47 |
| Drone passes IsPossible() | Phase 2 returned SUCCESS (not NOT_POSSIBLE) | cet.txt:47 |
| Visible effects | User confirmed food, minigame, audio, glitched screen | TEST RESULTS.md |

---

## 4. What Didn't Work

| Component | Evidence | Root Cause |
|---|---|---|
| PingDevice lookup | `NO_ACTION (requested: PingDevice, available: ...)` on every device | The action name is `"Ping"`, not `"PingDevice"` — the CET Lua searches for the wrong name |

---

## 5. Device Test Results

### Test Session Timeline

| Time | Event | Device | Player Result | Drone Result |
|---|---|---|---|---|
| 19:11:03 | List Device Actions | VendingMachine | 6 actions | 6 actions |
| 19:11:32 | Ping Quickhack Test #1 | VendingMachine | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) |
| 19:12:15 | List Device Actions | VendingMachine (2nd) | 4 actions (Ping gone) | 4 actions (Ping gone) |
| 19:12:19 | Ping Quickhack Test #2 | VendingMachine (2nd) | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) |
| 19:12:43 | List Device Actions | ExplosiveDevice | 5 actions | 5 actions |
| 19:12:57 | Ping Quickhack Test #3 | ExplosiveDevice | NO_ACTION → fallback SUCCESS (RemoteBreach) | NO_ACTION → fallback SUCCESS (RemoteBreach) |
| 19:13:27 | List Device Actions | SurveillanceCamera | 13 actions | 13 actions |
| 19:13:29 | Ping Quickhack Test #4 | SurveillanceCamera | NO_ACTION → fallback SUCCESS (RemoteBreach) | NO_ACTION → fallback SUCCESS (RemoteBreach) |
| 19:14:14 | List Device Actions | Speaker | 3 actions | 3 actions |
| 19:14:15 | Ping Quickhack Test #5 | Speaker | NO_ACTION → fallback SUCCESS (MalfunctionClassHack) | NO_ACTION → fallback SUCCESS (MalfunctionClassHack) |
| 19:14:38 | List Device Actions | TV | 6 actions | 6 actions |
| 19:14:39 | Ping Quickhack Test #6 | TV | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) | NO_ACTION → fallback SUCCESS (GlitchScreenSuicide) |

### Action Names Found Per Device

| Device | Action Count | Action Names |
|---|---|---|
| VendingMachine (1st) | 6 | GlitchScreenSuicide, GlitchScreenBlind, GlitchScreenGrenade, MalfunctionClassHack, RemoteBreach, **Ping** |
| VendingMachine (2nd) | 4 | GlitchScreenSuicide, GlitchScreenBlind, GlitchScreenGrenade, MalfunctionClassHack (Ping gone after first hack) |
| ExplosiveDevice | 5 | RemoteBreach, **Ping**, OverloadClassHack, RemoteBreach, **Ping** (duplicates) |
| SurveillanceCamera | 13 | RemoteBreach, **Ping**, MalfunctionClassHack, RemoteBreach, **Ping**, TakeControlCameraClassHack, OverrideAttitudeClassHack (×4), ToggleStateClassHack, RemoteBreach, **Ping** |
| Speaker | 3 | MalfunctionClassHack, RemoteBreach, **Ping** |
| TV | 6 | GlitchScreenSuicide, GlitchScreenBlind, GlitchScreenGrenade, MalfunctionClassHack, RemoteBreach, **Ping** |

### User-Observed Effects (from TEST RESULTS.md)

| Device | Fallback Action | Visible Effect |
|---|---|---|
| VendingMachine | GlitchScreenSuicide | Spat out food (distract enemies effect) |
| ExplosiveDevice | RemoteBreach | Triggered hacking minigame |
| Speaker | MalfunctionClassHack | Played something |
| TV | GlitchScreenSuicide | Played glitched screen |

---

## 6. Critical Finding: Action Name Is "Ping" Not "PingDevice"

The game's `ObjectActionRecord.ActionName()` returns `"Ping"`, not `"PingDevice"`. The CET Lua searches for `"PingDevice"`:

```lua
bridge:ExecuteDeviceActionByName(target, "PingDevice", player)
```

But every device that has a ping action lists it as `"Ping"` in the action dump. This is why every test returned `NO_ACTION` — the name didn't match.

**Fix for next tester**: Change the CET Lua to search for `"Ping"` instead of `"PingDevice"`.

---

## 7. Critical Finding: Drone Passes IsPossible() Naturally

The most significant result: **Phase 2 (drone as executor) returned SUCCESS on every device** — not `NOT_POSSIBLE`.

This means the drone passes the `IsPossible()` validation gate **without a Red4ext hook**. The Red4ext `IsPossible()` bypass that was planned for v3 may not be needed.

The Red4ext plugin is still a stub (no hooks registered), yet the drone executor works. The bridge pipeline — `SetUp(ps)` → `SetExecutor(drone)` → `IsPossible(drone)` → `CompleteAction(game)` — completes successfully with a drone as executor.

---

## 8. Red4ext Log Analysis

The Red4ext log is unremarkable:

- `OrbHackingBridge (version: 1.0.0, author(s): CE2) has been loaded` — the stub DLL loads
- No `[OrbHackingBridge]` log lines from the plugin itself — the stub's `Main()` runs but doesn't hook anything
- Plugin unloads cleanly on shutdown

The Red4ext stub is **not needed for the current test** — the drone passes `IsPossible()` naturally. The stub was only needed if the drone failed `IsPossible()`, which it doesn't.

---

## 9. REDscript Log Analysis

```
[INFO] Compilation complete
[INFO] Output successfully saved to ...\final.redscripts.modded
```

No errors. No warnings. The revert from `Device.GetInteractionQuickHackClearance()` to `Device.GetInteractionClearance()` fixed the CE2c compilation failure.

---

## 10. CET Log Analysis

### onInit (lines 11-16)

```
[CE2c] CE2c initialized -- quickhack clearance fix + action dump
[CE2c] Fixes: GetInteractionQuickHackClearance + pcall diagnostic + action dump + fallback
[CE2c] API check: GetScriptableSystemsContainer = true
[CE2c] API check: GetScriptableSystem = false      ← pcall prevented crash here
[CE2c] Bridge loaded via GetScriptableSystemsContainer():Get("OrbHackingBridge")
```

- **pcall fix worked** — `GetScriptableSystem = false` logged safely (CE2b crashed here)
- **Bridge loaded** — `GetScriptableSystemsContainer():Get()` returned non-nil

### Test Pattern (repeated 6 times across 5 device types)

Each test followed the same pattern:
1. `List Device Actions` — action dump showed available actions (including `Ping`)
2. `Ping Quickhack Test` — `ExecuteDeviceActionByName("PingDevice")` returned `NO_ACTION`
3. Fallback — `ExecuteFirstAvailableAction()` returned `SUCCESS`
4. Both player and drone executors succeeded

---

## 11. Conclusions

| Question | Answer | Evidence |
|---|---|---|
| Does the REDscript bridge compile? | **Yes** | `Compilation complete` |
| Does the bridge load from CET? | **Yes** | `Bridge loaded via GetScriptableSystemsContainer():Get()` |
| Does GetQuickHackActions return actions? | **Yes** | 3-13 actions per device |
| Does the action dump work? | **Yes** | `ListAvailableActions` returned all action names |
| Does SetUp + CompleteAction produce visible effects? | **Yes** | User confirmed effects on 4+ devices |
| Does the drone pass IsPossible()? | **Yes** | Phase 2 returned SUCCESS (not NOT_POSSIBLE) |
| Is a Red4ext hook needed? | **No** | Drone executor works without it |
| Does "PingDevice" match the action name? | **No** — it's "Ping" | Action dump showed "Ping" not "PingDevice" on every device |

---

## 12. Next Steps

| Step | What | Why |
|---|---|---|
| **2e (or v3)** | Change CET Lua to search for `"Ping"` instead of `"PingDevice"` | This is the only remaining bug — the pipeline works, just the action name is wrong |
| **Verify** | Test with `"Ping"` as the action name on a camera or access point | Should return `SUCCESS` on the specific action (not just fallback) |
| **Optional** | Remove Red4ext stub since it's not needed | Drone passes IsPossible() naturally — no hook required |

---

## 13. References

- [TEST RESULTS.md](TEST%20RESULTS.md) — User's observations of in-game effects
- [log - cet.txt](log%20-%20cet.txt) — Full CET log (237 lines)
- [log - redscript.txt](log%20-%20redscript.txt) — REDscript compilation log (49 lines, no errors)
- [log - red4ext.txt](log%20-%20red4ext.txt) — Red4ext log (28 lines, stub loads/unloads cleanly)
- [../customentity2c/README.md](../customentity2c/README.md) — CE2c README (CET Lua source)
- [../customentity2b/log - cet.txt](../customentity2b/log%20-%20cet.txt) — CE2b log (showed NO_ACTION + onInit crash)
