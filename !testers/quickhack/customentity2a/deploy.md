# Deploy Instructions -- Custom Entity Tester 2a

## Prerequisites

| Component | Required | Purpose |
|---|---|---|
| Cyber Engine Tweaks (CET) | Yes | Lua runtime for init.lua |
| RED4ext | Yes | C++ plugin runtime (reused from CE2) |
| REDscript | Yes | Compiles OrbHackingBridge.reds (reused from CE2) |

**Important**: This tester reuses the REDscript and Red4ext plugin from customentity2. If you already deployed customentity2, the REDscript bridge and Red4ext DLL are already in place -- you only need to deploy the CET Lua file.

## Deployment

### Only File to Deploy

**Source:** `cet/init.lua`

**Destination:**
```
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2a/init.lua
```

### Already Deployed (from customentity2 -- verify these are present)

| File | Location |
|---|---|
| OrbHackingBridge.reds | `<game_root>/r6/scripts/OrbHackingBridge.reds` |
| OrbHackingBridge.dll | `<game_root>/red4ext/plugins/OrbHackingBridge/OrbHackingBridge.dll` |

If these are missing, deploy them from `customentity2/redscript/` and `customentity2/red4ext/` respectively.

## Verification

1. Launch the game
2. Check CET console for:
   - `[CE2a] CE2a initialized -- fixed bridge API + phased testing`
   - `[CE2a] API check: GetScriptableSystem = true/false`
   - `[CE2a] API check: GetScriptableSystemsContainer = true`
   - `[CE2a] Bridge loaded via GetScriptableSystemsContainer():Get("OrbHackingBridge")`
3. Bind hotkeys in Settings > Key Bindings:
   - `CE2a: Spawn/Despawn Drone`
   - `CE2a: Run Ping Quickhack Test`

## Testing Steps

### Phase 1: Player as Executor (no drone needed)

1. Look at a hackable device (camera, TV, turret, access point)
2. Press `CE2a: Run Ping Quickhack Test`
3. Check CET log for:
   - `Phase 1 result: SUCCESS` -- bridge works, visible effect expected
   - `Phase 1 result: NOT_POSSIBLE` -- player has no cyberdeck? Equip one.
   - `Phase 1 result: NO_ACTION` -- device has no PingDevice action. Try another device.
   - `Phase 1 result: NO_DEVICE_PS` -- target is not a device with ScriptableDeviceComponentPS
4. Verify visible ping effect in game (network pulse on connected devices)

### Phase 2: Drone as Executor

1. Press `CE2a: Spawn/Despawn Drone` -- drone should appear near player
2. Look at a hackable device again
3. Press `CE2a: Run Ping Quickhack Test` again
4. Check CET log for:
   - `Phase 2 result: SUCCESS` -- drone passes IsPossible naturally! No Red4ext hook needed.
   - `Phase 2 result: NOT_POSSIBLE` -- expected without real Red4ext hook. Confirms IsPossible gate.
   - `Phase 2 result: ERROR` -- different error, investigate

### Cleanup

1. Press `CE2a: Spawn/Despawn Drone` again to despawn the drone

## Log Files

| Log | Location |
|---|---|
| CET Lua | `Cyberpunk 2077/bin/plugins/cyber_engine_tweaks/scripting.log` |
| RED4ext | `Cyberpunk 2077/red4ext/red4ext.log` |

## Troubleshooting

| Issue | Fix |
|---|---|
| Bridge still not found | Ensure `OrbHackingBridge.reds` is in `r6/scripts/` and compiled without errors |
| `GetScriptableSystemsContainer` is nil | CET version too old; update to 1.39.1+ |
| Phase 1 NOT_POSSIBLE | Player needs a cyberdeck equipped in SystemReplacementCW slot |
| Phase 1 NO_ACTION | Target device has no PingDevice quickhack; try QuickHackDistraction instead or target a different device |
| Phase 1 NO_DEVICE_PS | Target is not a Device with ScriptableDeviceComponentPS; look at an interactive device |
| Drone does not spawn | Check entity paths exist; Phantom Liberty paths need DLC |
| Phase 2 not reached | Spawn a drone first; Phase 2 is skipped if no drone is active |
