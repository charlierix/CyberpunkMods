# Deploy Instructions -- Custom Entity Tester 1b

## Prerequisites

| Component | Required | Purpose |
|---|---|---|
| Cyber Engine Tweaks (CET) | Yes | Lua runtime for init.lua |
| RED4ext | Yes | REDscript runtime support |
| REDscript | Yes | Compiles OrbHackingBridge.reds |

## File Deployment

### 1. CET Lua Mod

**Source:** `cet/init.lua`

**Destination:**
```
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity1b/init.lua
```

### 2. REDscript Bridge

**Source:** `redscript/OrbHackingBridge.reds`

**Destination:**
```
<game_root>/r6/scripts/OrbHackingBridge.reds
```

> **Important:** If you still have `OrbHackingBridge.reds` from `customentity1` installed, remove it first to avoid conflicts. The 1b version fixes the `Device.GetInteractionClearance()` compilation issue.

## Verification

1. Launch the game
2. Check CET console for `[CE1b]` log messages
3. Look for `Bridge loaded: OrbHackingBridge` in the log
4. If bridge not loaded, verify REDscript is installed and the .reds file is in `r6/scripts/`
5. Bind hotkeys in Settings > Key Bindings:
   - `CE1b: Spawn/Despawn Drone`
   - `CE1b: Run Ping Quickhack Test`

## Testing Steps

1. **Spawn the drone**: Press `CE1b: Spawn/Despawn Drone` — drone should appear near player
2. **Look at a hackable device**: Face a camera, turret, or other hackable device
3. **Run the ping test**: Press `CE1b: Run Ping Quickhack Test`
4. **Check the log**: Look for `Bridge result: SUCCESS` entries
5. **Despawn the drone**: Press `CE1b: Spawn/Despawn Drone` again

## Log File

The log file is written to:
```
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity1b/log.txt
```

Check this file for detailed diagnostics after running tests.

## Troubleshooting

| Issue | Fix |
|---|---|
| Bridge not loaded | Ensure `OrbHackingBridge.reds` is in `r6/scripts/` and REDscript is installed; remove any old version from customentity1 |
| Drone doesn't spawn | Check that entity paths exist in your game version; Phantom Liberty paths need DLC |
| `NO_TARGET` | Look directly at a hackable device (camera, turret, access point) |
| `NOT_POSSIBLE` | Device may not support PingDevice action, or drone executor is rejected by device validation |
| `NO_ACTION` | Device doesn't have a PingDevice quickhack action available |
| `NO_DEVICE_PS` | Target is not a device with a ScriptableDeviceComponentPS |
