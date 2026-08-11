# Custom Entity Tester 2e (CE2e)

## What Changed from CE2d

**One fix:** Changed the action name from `"PingDevice"` to `"Ping"` in the CET Lua.

CE2d's LOG ANALYSIS revealed that every device lists its ping action as `"Ping"`, not `"PingDevice"`. The CET Lua was searching for the wrong name, so every specific-action lookup returned `NO_ACTION` and the fallback kicked in. With this fix, the `ExecuteDeviceActionByName("Ping", ...)` call should match the actual action name and return `SUCCESS` directly — no fallback needed.

### Full Change List

| Fix | Layer | What |
|---|---|---|
| **Action name fix** | CET Lua | `"PingDevice"` → `"Ping"` (7 occurrences: function calls, log messages, comments) |
| Naming update | CET Lua | All `CE2c` prefixes → `CE2e`, `customentity2c` → `customentity2e` |
| Header comment fix | CET Lua | `GetInteractionQuickHackClearance` → `GetInteractionClearance` (2d proved the former doesn't exist) |
| REDscript | — | Unchanged from CE2d (working version with `Device.GetInteractionClearance()`) |

## Files

| File | Lines | Path |
|---|---|---|
| CET Lua | 561 | `cet/init.lua` |
| REDscript | 266 | `redscript/OrbHackingBridge.reds` |
| README | — | `README.md` |

## What CE2d Proved (carried forward)

CE2d was a **major breakthrough** — the entire bridge pipeline works:

- REDscript compiles clean (`GetInteractionClearance()` is valid)
- CET onInit doesn't crash (pcall fix)
- Bridge loads via `GetScriptableSystemsContainer():Get("OrbHackingBridge")`
- `GetQuickHackActions()` returns 3-13 actions per device
- `ExecuteFirstAvailableAction()` successfully executes hacks on all devices
- **Drone passes `IsPossible()` naturally** — no Red4ext hook needed for premade drones
- User observed visible effects: food spitting, hacking minigame, speaker audio, glitched TV

The only bug was the action name mismatch. CE2e fixes that.

## Deploy

1. Copy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2e/init.lua`
2. Copy `redscript/OrbHackingBridge.reds` to `<game>/r6/scripts/OrbHackingBridge.reds` (same as 2d)
3. **Remove or disable CE2c/CE2d** — delete or rename their CET mod folders to avoid conflicts
4. Red4ext DLL from customentity2 stays in place (stub, no changes)

## Hotkeys (bind in Settings > Key Bindings)

| Hotkey | Action |
|---|---|
| `CE2e: Spawn/Despawn Drone` | Spawns/despawns the Zetatech Bombus drone |
| `CE2e: Run Ping Quickhack Test` | Runs phased test (player + drone) with `"Ping"` action |
| `CE2e: List Device Actions` | Dumps all available quickhack actions on targeted device |

## Testing

1. **Spawn a drone** (CE2e: Spawn/Despawn Drone)
2. **Look at a device** that has Ping (camera, access point, TV, speaker, explosive, vending machine)
3. **List Device Actions** first — confirm `Ping` appears in the action list
4. **Run Ping Quickhack Test** — both phases should now return `SUCCESS (action: Ping)` directly, without fallback

### Expected Results

| Phase | Expected | Why |
|---|---|---|
| Phase 1 (player) | `Phase 1 result (Ping): SUCCESS` | Action name now matches |
| Phase 2 (drone) | `Phase 2 result (Ping): SUCCESS` | Drone passes IsPossible() naturally (proven in 2d) |

If both phases return SUCCESS, the bridge pipeline is fully working with the correct action name.

## Note on Red4ext

Red4ext is still a stub (no hooks). CE2d proved the drone passes `IsPossible()` naturally, so no hook is needed for **premade drone** executors.

However, Red4ext will be needed for the **final goal**: a completely custom entity. Premade drones have all the right components and clearance by default; a custom entity may not, and Red4ext hooks (e.g., `IsPossible` bypass, component injection) may be required to make a custom entity work as a quickhack executor.

## References

- [../customentity2d/LOG ANALYSIS.md](../customentity2d/LOG%20ANALYSIS.md) — Full log analysis from CE2d
- [../customentity2d/TEST RESULTS.md](../customentity2d/TEST%20RESULTS.md) — User's in-game observations
- [../customentity2c/README.md](../customentity2c/README.md) — CE2c README (CET Lua origin)
