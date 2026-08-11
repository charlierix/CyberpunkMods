# Deploy Instructions -- Custom Entity Tester 1

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
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity1/init.lua
```

### 2. REDscript Bridge

**Source:** `redscript/OrbHackingBridge.reds`

**Destination:**
```
<game_root>/r6/scripts/OrbHackingBridge.reds
```

### 3. RED4ext

No RED4ext plugin needed for v1. The `red4ext/` folder contains only documentation.

## Verification

1. Launch the game
2. Check CET console for `[CE1]` log messages
3. Look for `Bridge loaded: OrbHackingBridge` in the log
4. If bridge not loaded, verify REDscript is installed and the .reds file is in `r6/scripts/`
5. Bind hotkeys in Settings > Key Bindings:
   - `CE1: Spawn/Despawn Shell Entity`
   - `CE1: Run Ping Quickhack Test`
   - `CE1: Toggle ImGui Window`
   - `CE1: Reset State`

## Log File

The log file is written to:
```
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity1/log.txt
```

Check this file for detailed diagnostics after running tests.
