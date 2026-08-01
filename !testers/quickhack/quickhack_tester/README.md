# Quickhack Tester — CET Mod

Applies quickhacks to the **device you're looking at** — **no RAM cost, no XP gain**.

Pure CET (Lua) — no redscript, no archives, no TweakXL.

## Install

1. Copy the `quickhack_tester/` folder to:
   ```
   bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester/
   ```
2. Launch the game.
3. Go to **Settings → Key Bindings → QHTester** and bind:
   - **Apply Quickhack** — applies the selected hack to the device under crosshair
   - **Cycle Hack Type** — switches between Distraction / Toggle On / Toggle Open / Call Elevator / Self-Destruct / Distract (Explosives) / Authorization
   - **List Available Hacks** — prints all quickhacks available on the current target to the CET console (debug)

## Configuration

Edit `init.lua` → `Config` table (top of file):

| Setting | Default | Description |
|---|---|---|
| `debug` | `true` | Print info to CET console |
| `currentHack` | `1` | Starting index into HackList |
| `maxDistance` | `20.0` | Max targeting distance in meters |
| `useFirstAvailable` | `false` | If true, always use first available hack (ignore selection) |

## How It Works

1. **Targeting** → `Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)` with `TSF_Quickhackable` filter
2. **Device access** → `entity:GetDevicePS()` for the device persistent state
3. **Action discovery** → `ps:GetQuickHackActions(context)` with `ignoresRPG = true` and `ignoresAuthorization = true`
4. **Execution (no RAM, no XP)** →
   - Skips `ProcessRPGAction` entirely (no `PayCost` = no RAM used)
   - Calls `StartAction(game)` for start effects (visuals, cooldowns)
   - Calls the PS handler directly (e.g. `OnQuickHackDistraction(action)`) to trigger the device effect — this path does **not** award XP
   - Falls back to `CompleteAction(game)` if the PS handler isn't directly callable (may give small XP)

## Hack Types

| # | Action Class | PS Handler | Label |
|---|---|---|---|
| 1 | `QuickHackDistraction` | `OnQuickHackDistraction` | Distraction |
| 2 | `QuickHackToggleON` | `OnQuickHackToggleOn` | Toggle On/Off |
| 3 | `QuickHackToggleOpen` | `OnQuickHackToggleOpen` | Toggle Open (Doors) |
| 4 | `QuickHackCallElevator` | `OnQuickHackCallElevator` | Call Elevator |
| 5 | `QuickHackExplodeExplosive` | `OnQuickHackExplodeExplosive` | Self-Destruct (Explosives) |
| 6 | `QuickHackDistractExplosive` | `OnQuickHackDistractExplosive` | Distract (Explosives) |
| 7 | `QuickHackAuthorization` | `OnQuickHackAuthorization` | Authorization |

## Notes

- If the selected hack isn't available on the current device (e.g. Self-Destruct on a TV), the mod **falls back to the first available hack**.
- The `List Available Hacks` hotkey is useful for discovering which hack classes a device supports.
- The `TSF_Quickhackable` filter targets both devices and hackable NPCs. The mod checks for `GetDevicePS()` to ensure it's a device.
