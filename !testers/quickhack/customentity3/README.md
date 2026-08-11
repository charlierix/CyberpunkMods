# Custom Entity Tester 3 (CE3)

## Purpose

**Answer the question: Is Red4ext needed?**

CE2e proved the bridge pipeline works end-to-end with CET + REDscript, but a Red4ext stub DLL was still deployed. CE3 is a direct copy of CE2e with **no Red4ext at all** -- no DLL, no red4ext folder, no red4ext references in requirements.

If CE3 works identically to CE2e (ping succeeds, player RAM not depleted), then Red4ext is confirmed unnecessary for premade drone executors.

## What Changed from CE2e

| Change | Detail |
|---|---|
| **No Red4ext** | No red4ext/ folder, no DLL deployment, removed from requirements |
| **Rebranded** | CE2e to CE3, customentity2e to customentity3 in all identifiers and logs |
| **CET Lua** | Otherwise identical to CE2e (same spawn, target, bridge, phased test logic) |
| **REDscript** | Identical to CE2e (OrbHackingBridge.reds unchanged) |

## Files

| File | Lines | Path |
|---|---|---|
| CET Lua | 561 | `cet/init.lua` |
| REDscript | 266 | `redscript/OrbHackingBridge.reds` |
| README | -- | `README.md` |

## Deploy

1. Copy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity3/init.lua`
2. Copy `redscript/OrbHackingBridge.reds` to `<game>/r6/scripts/OrbHackingBridge.reds`
3. **Remove or disable CE2e** -- delete or rename its CET mod folder to avoid hotkey conflicts
4. **Do NOT deploy any Red4ext DLL** -- CE3 tests without it

## Hotkeys (bind in Settings > Key Bindings)

| Hotkey | Action |
|---|---|
| `CE3: Spawn/Despawn Drone` | Spawns/despawns the Zetatech Bombus drone |
| `CE3: Run Ping Quickhack Test` | Runs phased test (player + drone) with `"Ping"` action |
| `CE3: List Device Actions` | Dumps all available quickhack actions on targeted device |

## Testing

1. **Spawn a drone** (CE3: Spawn/Despawn Drone)
2. **Look at a device** that has Ping (camera, access point, TV, speaker, explosive, vending machine)
3. **List Device Actions** first -- confirm `Ping` appears in the action list
4. **Run Ping Quickhack Test** -- both phases should return `SUCCESS`

### Expected Results

| Phase | Expected | Why |
|---|---|---|
| Phase 1 (player) | `Phase 1 result (Ping): SUCCESS` | Same code as CE2e which worked |
| Phase 2 (drone) | `Phase 2 result (Ping): SUCCESS` | Drone passes IsPossible() naturally (proven in CE2d) |

If both phases return SUCCESS without Red4ext, the answer is clear: **Red4ext is not needed for premade drone executors.**

## Background

- **customentity1b** concluded Red4ext was needed (trying to inherit from native `Drone` class in REDscript, which fails)
- **customentity2e** proved it wasn't needed (the bridge works via `ScriptableSystem`, not `Drone` inheritance; drone passes `IsPossible()` naturally)
- **customentity3** confirms by removing Red4ext entirely

## References

- [../customentity2e/FINAL ANALYSIS.md](../customentity2e/FINAL%20ANALYSIS.md) -- CE2e full analysis and working code patterns
- [../customentity1b/ANALYSIS.md](../customentity1b/ANALYSIS.md) -- CE1b analysis (said Red4ext needed for Drone inheritance)
- [../../cet-hotkeys.promptinclude.md](../../cet-hotkeys.promptinclude.md) -- CET hotkey registration rule
