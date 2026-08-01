# Quickhack Tester 3 — CET Mod

Applies quickhacks to the **device you're looking at** — **no RAM cost, no XP gain**.

Combines the best of v1 and v2, fixing v2's broken action discovery.

## What Changed from v2

| Issue in v2 | Fix in v3 |
|---|---|
| **Available hacks always empty** — v2 only used out-array convention `ps:GetQuickHackActions(arr, ctx)` which fails silently in CET Lua bindings | v3 restores v1's working return-value convention `ps:GetQuickHackActions(ctx)` as the primary discovery method |
| Only 2 discovery conventions tried | v3 tries **4 conventions**: return-value and out-array for both `GetQuickHackActions` and `GetActions` |
| `GetActions` fallback also used out-array (also fails) | v3 adds return-value `GetActions(ctx)` with quickhack filtering by HackCategory and class name |
| CNames printed as verbose `ToCName{ hash_lo = 0x..., hash_hi = 0x... --[[ Name --]] }` | v3 extracts just the readable name with `CNameToString()` |
| No way to force-clear stale cache without List Available | v3 adds **Clear Cache** hotkey |
| Only debug output for failures | v3 logs which discovery convention succeeded and shows TweakDB record IDs |

## What's Kept from v2

- Cycles through device's **actual available quickhacks**, not a hardcoded list
- `SetCanSkipPayCost(true)` + `StartAction` for no-RAM execution
- `StartAction` auto-calls `CompleteAction` → `QueuePSDeviceEvent` for device effects
- Action caching per target entity so Cycle Hack works without re-querying
- `ProcessRPGAction` fallback (costs RAM but should always work)

## What's Kept from v1

- **Return-value convention** `ps:GetQuickHackActions(context)` — the only convention proven to work in CET
- Multi-convention fallback strategy for action discovery

## Install

1. Copy the `quickhack_tester3/` folder to:
   ```
   bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester3/
   ```
2. Launch the game.
3. Go to **Settings → Key Bindings → QHTester3** and bind:
   - **Apply Quickhack** — applies the selected hack to the device under crosshair
   - **Cycle Hack** — switches between the device's available quickhacks
   - **List Available Hacks** — prints all quickhacks available on the current target to the CET console
   - **Clear Cache** — force-clears the action cache and resets selection index

## Configuration

Edit `init.lua` → `Config` table (top of file):

| Setting | Default | Description |
|---|---|---|
| `debug` | `true` | Print info to CET console |
| `maxDistance` | `20.0` | Max targeting distance in meters |
| `selectedIndex` | `1` | Starting index for hack selection (cycled by hotkey) |

## How It Works

1. **Targeting** → `Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)` with `TSF_Quickhackable` filter
2. **Device access** → `entity:GetDevicePS()` for the device persistent state
3. **Action discovery** → tries 4 conventions in order:
   - `ps:GetQuickHackActions(context)` — return value (**works in CET**)
   - `ps:GetQuickHackActions(outArray, context)` — out array (v2's approach, fails in CET)
   - `ps:GetActions(context)` — return value, filtered to quickhacks by HackCategory + class name
   - `ps:GetActions(outArray, context)` — out array with filtering (fallback)
4. **Caching** → Actions are cached per target entity so Cycle Hack doesn't re-query each time
5. **Execution (no RAM, no XP)** →
   - `action:SetCanSkipPayCost(true)` — skips PayCost (no RAM used)
   - `action:StartAction(game)` — for quickhacks with canSkipPayCost, this auto-calls CompleteAction
   - `CompleteAction` calls `QueuePSDeviceEvent(this)` which sends the action to the device PS, triggering the actual device effect
   - No `ProcessRPGAction` is called, so no XP is awarded
   - Fallback: if StartAction fails, tries `ProcessRPGAction` (may cost RAM), then `CompleteAction` alone

## Root Cause of v2's Empty List Bug

CET's Lua bindings for RED4 methods return arrays as **return values**, not via out-parameters.

- ✅ `local actions = ps:GetQuickHackActions(context)` — returns the array
- ❌ `ps:GetQuickHackActions(actions, context)` — `actions` stays empty in CET Lua

Tester1 used both conventions and the return-value one worked (log shows 4 actions found on a vending machine).
Tester2 removed the return-value convention, keeping only the out-array one, so it always got empty results.

## Debug Output

v3's debug output shows which discovery convention succeeded:
```
[QHTester3] Querying VendingMachine for quickhack actions...
[QHTester3]   GetQuickHackActions(ctx) returned 4 actions (return-value convention)
[QHTester3] Cached 4 quickhack actions for VendingMachine
```

And the List Available output shows clean names instead of raw CName hashes:
```
[QHTester3] Target: VendingMachine
[QHTester3] Available quickhacks (4):
  [1] GlitchScreenSuicide (class: GlitchScreen, record: GlitchScreenSuicide)
  [2] GlitchScreenBlind (class: GlitchScreen, record: GlitchScreenBlind)
  [3] GlitchScreenGrenade (class: GlitchScreen, record: GlitchScreenGrenade)
  [4] MalfunctionClassHack (class: QuickHackDistraction, record: MalfunctionClassHack) <-
```

## Notes

- Cycle Hack rotates through the device's **actual available quickhacks**.
- List Available Hacks forces a cache refresh to show the latest state.
- Clear Cache is useful if the game state changes and cached actions become stale.
- The `TSF_Quickhackable` filter targets both devices and hackable NPCs. The mod checks for `GetDevicePS()` to ensure it's a device.
- Hotkeys are registered at file root level per CET's hotkey discovery requirements.
