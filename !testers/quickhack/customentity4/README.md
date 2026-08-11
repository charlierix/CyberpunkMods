# Custom Entity Tester 4 (CE4)

## Purpose

**Test ALL available quickhacks on any device** using a spawned drone as executor.

CE3 proved the drone+bridge pipeline works with Ping only. CE4 extends this to test every quickhack the targeted device exposes -- Overload, Contagion, Short Circuit, etc. -- with live ImGui feedback and per-device attempt tracking.

## What Changed from CE3

| Change | Detail |
|---|---|
| **ImGui window** | Brought back from CE1 -- shows device info, hack list, attempt counts, results |
| **All quickhacks** | New bridge methods `GetActionNames` + `ExecuteActionByIndex` instead of hardcoded "Ping" |
| **Attempt tracking** | Per-device, per-action count table (from SEDevT1 pattern) |
| **Weighted random** | Untried hacks weighted higher so all get tested |
| **Auto-scan** | onUpdate auto-detects target and refreshes hack list when drone is spawned |
| **3 hotkeys** | Spawn/Despawn (+window), List Quickhacks, Apply Random Quickhack |

## Files

| File | Lines | Path |
|---|---|---|
| CET Lua | 795 | `cet/init.lua` |
| REDscript | 411 | `redscript/OrbHackingBridge.reds` |
| README | -- | `README.md` |

## Deploy

1. Copy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity4/init.lua`
2. Copy `redscript/OrbHackingBridge.reds` to `<game>/r6/scripts/OrbHackingBridge.reds` (overwrites CE3 version)
3. **Remove or disable CE3** -- delete or rename its CET mod folder to avoid hotkey conflicts
4. No Red4ext required

## Hotkeys (bind in Settings > Key Bindings)

| Hotkey | Action |
|---|---|
| `CE4: Spawn/Despawn Drone` | Spawns/despawns drone + shows/hides ImGui window |
| `CE4: List Available Quickhacks` | Lists all quickhacks for device being looked at |
| `CE4: Apply Random Quickhack` | Executes a weighted-random quickhack from current list |

## Usage

1. **Spawn drone** (hotkey) -- ImGui window appears
2. **Look at a hackable device** (camera, access point, explosive, TV, etc.)
3. The window auto-updates with device name/type and available hacks
4. **Apply Random Quickhack** (hotkey) -- executes one hack, result appears in window
5. **Repeat** -- untried hacks are weighted higher, so keep pressing until all have `*` marks
6. **Despawn drone** (same spawn hotkey) -- window hides

## ImGui Window Sections

| Section | Content |
|---|---|
| Bridge | OrbHackingBridge load status |
| Drone | Spawn status, method, entity path |
| Target Device | Name, type, distance of looked-at device |
| Available Hacks | Table: `[index] action_name  tried_count` with `*` for tried |
| Last Result | Action name + result string + timestamp, color-coded |
| Messages | Rolling log of last 12 operations (green=OK, red=FAIL, orange=warning) |

## Bridge API (OrbHackingBridge.reds CE4)

| Method | Returns | Purpose |
|---|---|---|
| `GetActionNames(device, executor)` | `"Ping\|Overload\|Contagion"` | Pipe-delimited action names |
| `ExecuteActionByIndex(device, executor, index)` | `"SUCCESS (action: Name)"` | Execute Nth action (0-based) |
| `ExecuteDeviceActionByName(device, name, executor)` | `"SUCCESS"` / error | CE3 method, kept for compat |
| `ListAvailableActions(device, executor)` | `"N actions: a, b, c"` | CE3 method, kept for compat |
| `ExecuteFirstAvailableAction(device, executor)` | `"SUCCESS (action: Name)"` | CE3 method, kept for compat |

## Background

- **CE3** proved drone+bridge works without Red4ext (Ping only)
- **CE1** had an ImGui window pattern
- **SEDevT1** had per-action attempt tracking + weighted random selection
- **CE4** combines all three into a complete all-quickhack tester

## References

- [../customentity3/README.md](../customentity3/README.md) -- CE3 (proven drone+bridge, no Red4ext)
- [../customentity1/cet/init.lua](../customentity1/cet/init.lua) -- CE1 (ImGui window pattern)
- [../statuseffect_device_tester1/init.lua](../statuseffect_device_tester1/init.lua) -- SEDevT1 (attempt tracking)
- [../../cet-hotkeys.promptinclude.md](../../cet-hotkeys.promptinclude.md) -- CET hotkey registration rule
