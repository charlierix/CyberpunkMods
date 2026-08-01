# Quickhack Tester 2 — CET Mod

Applies quickhacks to the **device you're looking at** — **no RAM cost, no XP gain**.

Improved version of Quickhack Tester v1.

## What Changed from v1

| Issue in v1 | Fix in v2 |
|---|---|
| **Cycle Hack** rotated through a hardcoded list of 7 hack types that didn't match the device's actual available hacks | Cycle Hack now rotates through the **device's actual available quickhack actions** (cached per target) |
| **StartAction/CompleteAction failed** — actions weren't properly configured for no-RAM execution | Uses `SetCanSkipPayCost(true)` before `StartAction` — for quickhacks, StartAction auto-calls CompleteAction when canSkipPayCost is true |
| **PS handler direct call** tried `ps["OnQuickHackDistraction"]` which expects a specific event type, not an action object | Removed entirely — the correct path is StartAction → CompleteAction → `QueuePSDeviceEvent(this)` |
| **Fallback to first available** when selected hack didn't match any HackList entry | Selection is now by index into the device's actual available actions list |
| No caching — every action query re-targeted the device | Actions are cached per target entity so Cycle Hack works without re-querying |

## Install

1. Copy the `quickhack_tester2/` folder to:
   ```
   bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester2/
   ```
2. Launch the game.
3. Go to **Settings → Key Bindings → QHTester2** and bind:
   - **Apply Quickhack** — applies the selected hack to the device under crosshair
   - **Cycle Hack** — switches between the device's available quickhacks
   - **List Available Hacks** — prints all quickhacks available on the current target to the CET console (debug)

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
3. **Action discovery** → `ps:GetQuickHackActions(outArray, context)` with `ignoresRPG = true` and `ignoresAuthorization = true`
4. **Caching** → Actions are cached per target entity so Cycle Hack doesn't re-query each time
5. **Execution (no RAM, no XP)** →
   - `action:SetCanSkipPayCost(true)` — skips PayCost (no RAM used)
   - `action:StartAction(game)` — for quickhacks with canSkipPayCost, this auto-calls CompleteAction
   - `CompleteAction` calls `QueuePSDeviceEvent(this)` which sends the action to the device PS, triggering the actual device effect
   - No `ProcessRPGAction` is called, so no XP is awarded
   - Fallback: if StartAction fails, tries `ProcessRPGAction` (may cost RAM)

## Notes

- Cycle Hack rotates through the device's **actual available quickhacks**, not a predefined list.
- List Available Hacks forces a cache refresh to show the latest state.
- The `TSF_Quickhackable` filter targets both devices and hackable NPCs. The mod checks for `GetDevicePS()` to ensure it's a device.
- Based on game source analysis: `StartAction` for quickhacks with `m_canSkipPayCost = true` automatically calls `CompleteAction`, which calls `QueuePSDeviceEvent(this)` to trigger the device effect.
