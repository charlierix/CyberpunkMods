# Deploy Instructions -- Custom Entity Tester 2

## Prerequisites

| Component | Required | Purpose |
|---|---|---|
| Cyber Engine Tweaks (CET) | Yes | Lua runtime for init.lua |
| RED4ext | Yes | C++ plugin runtime (IsPossible hook) |
| REDscript | Yes | Compiles OrbHackingBridge.reds |
| CMake 3.15+ | Build only | Build the Red4ext DLL |
| C++20 compiler (MSVC) | Build only | Compile the Red4ext DLL |

## File Deployment

### 1. Red4ext Plugin (build first)

**Build:**

run 'x64 Native Tools Command Prompt'

```bash
cd D:\agent zero\!v2b\projects\cyberpunk\testers\quickhack\customentity2\red4ext
rmdir /s /q build
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="D:\agent zero\!v2b\projects\cyberpunk\sdk\RED4ext.SDK\include"
cmake --build . --config Release
```

DLL output: `build\Release\OrbHackingBridge.dll`


The plugin hooks `BaseScriptableAction::IsPossible` to bypass executor validation for CE2_DRONE-tagged drones.

**Deploy the built DLL to:**
```
<game_root>/red4ext/plugins/OrbHackingBridge/
    OrbHackingBridge.dll
```

### 2. REDscript Bridge

**Source:** `redscript/OrbHackingBridge.reds`

**Destination:**
```
<game_root>/r6/scripts/OrbHackingBridge.reds
```

> **Important:** Remove any previous `OrbHackingBridge.reds` from customentity1 or customentity1b to avoid conflicts.

### 3. CET Lua Mod

**Source:** `cet/init.lua`

**Destination:**
```
<game_root>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2/init.lua
```

## Verification

1. Launch the game
2. Check CET console for `[CE2]` log messages
3. Check RED4ext log for `[OrbHackingBridge] Plugin loaded -- executor validation hook`
4. Look for `Bridge loaded: OrbHackingBridge` in the CET log
5. Bind hotkeys in Settings > Key Bindings:
   - `CE2: Spawn/Despawn Drone`
   - `CE2: Run Ping Quickhack Test`

## Testing Steps

1. **Spawn the drone**: Press `CE2: Spawn/Despawn Drone` -- drone should appear near player
2. **Look at a hackable device**: Face a camera, turret, or other hackable device
3. **Run the ping test**: Press `CE2: Run Ping Quickhack Test`
4. **Check the logs**:
   - CET log: Look for `Bridge result (drone): SUCCESS`
   - RED4ext log: Look for `IsPossible: bypassing validation for CE2_DRONE executor`
5. **Despawn the drone**: Press `CE2: Spawn/Despawn Drone` again

## Log Files

| Log | Location |
|---|---|
| CET Lua | `Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\scripting.log` |
| RED4ext | `Cyberpunk 2077\red4ext\red4ext.log` (or similar) |

## Troubleshooting

| Issue | Fix |
|---|---|
| Red4ext plugin not loaded | Ensure DLL is in `red4ext/plugins/OrbHackingBridge/` |
| Bridge not loaded | Ensure `OrbHackingBridge.reds` is in `r6/scripts/` and REDscript is installed |
| `NOT_POSSIBLE` from drone test | Red4ext hook not active -- check RED4ext log for hook registration |
| Drone doesn't spawn | Check that entity paths exist in your game version; Phantom Liberty paths need DLC |
| `NO_TARGET` | Look directly at a hackable device (camera, turret, access point) |
| `NO_ACTION` | Device doesn't have a PingDevice quickhack action available |
| `NO_DEVICE_PS` | Target is not a device with a ScriptableDeviceComponentPS |
