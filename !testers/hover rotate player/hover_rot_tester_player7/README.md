# HoverRot Tester Player7 — Hybrid CET + RED4ext + Redscript

## Goal

Freely rotate the player character's body (full 6DOF — pitch, yaw, roll) while airborne, using a combination of CET, RED4ext, and Redscript.

## Background

Previous testers (player1–player6b) exhausted CET-only approaches:

- `Teleport` sets yaw only (roll/pitch clamped to 0 by locomotion)
- `SetWorldTransform` is a complete no-op on players
- PSM blackboard manipulation doesn't bypass the native C++ clamp
- Camera rotation works for all 3 axes but body stays upright

The locomotion state machine enforces `roll=0, pitch=0` every frame in native C++ code that CET cannot reach. This tester attempts to bypass that clamp using a hybrid approach.

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                     Player (User)                        │
│           Hotkeys → Pitch/Yaw/Roll input                 │
└──────────────┬──────────────────────────┬────────────────┘
               │                          │
               ▼                          ▼
┌──────────────────────┐    ┌───────────────────────────────┐
│   CET (init.lua)     │    │   Redscript (.reds)           │
│                      │    │                               │
│ • Hotkeys (root lvl) │    │ • Vehicle mounting API        │
│ • Hover (PSMImpulse) │◄──►│ • Locomotion component access │
│ • Camera rotation    │    │ • Transform write (deeper)    │
│ • Strategy cycling   │    │ • FELL state forcing          │
│ • ImGui debug UI     │    │                               │
└────────┬─────────────┘    └───────────────────────────────┘
         │ TweakDB
         ▼
┌──────────────────────┐
│   RED4ext (Main.cpp) │
│                      │
│ • Hook player update │
│ • Read orientation   │
│   from TweakDB       │
│ • Write to player    │
│   transform natively │
│ • Bypass locomotion  │
│   clamp via post-hook│
└──────────────────────┘
```

## Rotation Strategies

| # | Strategy | Tech | Expected Result |
|---|----------|------|-----------------|
| 1 | Camera-only rotation | CET | Works (visual only, body upright) |
| 2 | Teleport with EulerAngles | CET | Yaw only (pitch/roll clamped) |
| 3 | RED4ext native transform override | RED4ext + CET | Key test — may bypass clamp |
| 4 | Vehicle mount hybrid | CET + Redscript | Player inherits vehicle rotation |

## Components

### 1. CET Mod (`cet/init.lua`)

- **Hotkeys** (registered at file root per CET rules):
  - Toggle Active
  - Pitch Up/Down, Roll Left/Right, Yaw Left/Right
  - Reset Rotation
  - Cycle Strategy (1→2→3→4→1)
  - Hover Up/Down/Stop

- **Hover**: Uses `PSMImpulse` to keep player airborne

- **Strategy 1 (Camera)**: `FPPCameraComponent:SetLocalOrientation(quaternion)` — known working

- **Strategy 2 (Teleport)**: `TeleportationFacility:Teleport(player, pos, EulerAngles)` — known yaw-only

- **Strategy 3 (RED4ext)**: Writes desired orientation to TweakDB; the RED4ext plugin reads it and writes to the player's native transform every frame via a post-hook on the player update function

- **Strategy 4 (Vehicle Mount)**: Spawns an invisible vehicle via `exEntitySpawner`, attempts to mount the player to it, then rotates the vehicle via Teleport (which works for vehicles because they're physics-driven)

### 2. RED4ext Plugin (`red4ext/src/Main.cpp`)

- **Plugin entry points**: `PluginLoad`, `PluginUnload`, `GetPluginDescriptor`

- **Hook registration**: Attempts to hook the player's per-frame update function by CName via the hook manager's reflection-based function lookup

- **Post-hook approach**: After the locomotion update runs (which clamps roll/pitch to 0), the hook overwrites the transform's orientation with the desired quaternion. This is the key test — does native `SetWorldTransform` bypass the clamp?

- **Alternative approach (documented in code)**: Writing directly to the component's orientation field via the reflection system (CClass/CProperty with offset), bypassing any setter logic

- **Build system**: `red4ext/CMakeLists.txt` — CMake configuration for building the DLL

### 3. Redscript Bridge (`redscript/HoverRotPlayer7.reds`)

- **ScriptableSystem** registered as `HoverRotPlayer7Bridge`
- Accessible from CET via `Game.GetScriptableSystemsContainer():Get('HoverRotPlayer7Bridge')`
- Provides:
  - `SetRotation(pitch, yaw, roll)` — set desired orientation
  - `SpawnVehicle()` / `DespawnVehicle()` — vehicle lifecycle for Strategy 4
  - `MountPlayerToVehicle()` — attempt vehicle mounting via native mounting system
  - `RotateVehicle(pitch, yaw, roll)` — rotate the spawned vehicle via Teleport
  - `GetLocomotionInfo()` — read locomotion state for debugging
  - `WriteOrientationDirect(pitch, yaw, roll)` — write orientation via Redscript's deeper API access
  - `ForceFellState()` — experimental: try to force FELL state (may relax orientation clamp)

## How to Build the RED4ext Plugin

### Prerequisites

- CMake 3.15+
- Visual Studio 2019+ (or MSVC build tools)
- RED4ext SDK (included in project at `sdk/RED4ext.SDK/`)
- Cyberpunk 2077 with RED4ext runtime installed

### Build Steps

run 'x64 Native Tools Command Prompt'

```bash
cd "testers/hover rotate player/hover_rot_tester_player7/red4ext"
rmdir /s /q build
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="D:\agent zero\!v2b\projects\cyberpunk\sdk\RED4ext.SDK\include"
cmake --build . --config Release
```

The built `HoverRotTesterPlayer7.dll` will be placed in the `red4ext\bin` directory.

### Install

Copy the following to your Cyberpunk 2077 game directory:

| Source | Destination |
|--------|------------|
| `cet/init.lua` | `<game>/bin/x64/plugins/cyberpunk_engine_tweaks/mods/HoverRotTesterPlayer7/init.lua` |
| `red4ext/bin/HoverRotTesterPlayer7.dll` | `<game>/bin/x64/plugins/red4ext/plugins/HoverRotTesterPlayer7/HoverRotTesterPlayer7.dll` |
| `redscript/HoverRotPlayer7.reds` | `<game>/r6/scripts/HoverRotPlayer7.reds` |

## Key Technical Findings

### Why CET Can't Rotate the Player Body

The player's locomotion state machine enforces `roll=0, pitch=0` every frame through native C++ code. CET APIs write to the scene component, not the physics rigid body, so the locomotion system overwrites the transform every frame.

Vehicles work because they're physics-driven — their rigid body drives the transform. Players are locomotion-driven — the state machine overwrites the transform.

### Why RED4ext Might Work

RED4ext operates at the native C++ level and can:

1. **Hook the locomotion update function** and either skip the clamping code or override the result
2. **Write directly to transform/physics fields** via the reflection system (CClass/CProperty with memory offset), bypassing setter logic
3. **Hook as a post-update** — let the locomotion clamp run, then override the orientation afterward

### Key Function Names to Hook (by CName)

The RED4ext hook manager can find functions by CName via the game's reflection system. Candidate function names:

| Function | Purpose |
|---------|--------|
| `UpdateTick` | Entity per-frame tick |
| `OnUpdate` | General entity update |
| `gamePlayerPuppet::OnUpdate` | Player-specific update |
| `ScriptablePuppet::OnUpdate` | Scripted puppet update |
| `gamePuppetBase::OnTick` | Base puppet tick |
| `gameLocomotionStateMachinePlayer::Update` | Locomotion SM update (most targeted) |

These need to be verified against the actual game's reflection system via reverse engineering.

### RED4ext SDK API (from `sources/RED4ext/src/RED4ext/Plugin.cpp`)

```cpp
// Hook Manager
struct HookManager {
    template<typename FuncType>
    void Add(FuncType* target, FuncType* hook);  // By function pointer
    
    template<typename FuncType>
    void Add(CName name, FuncType* hook);  // By CName (reflection lookup)
    
    void Remove(void* hook);
};

// Game Instance
struct GameInstance {
    template<typename T>
    T* FindEntityByID(uint64_t id);
    
    template<typename T>
    T* GetSystem();  // Get game system by type
    
    Entity* GetPlayer();  // Get local player entity
};

// Entity
struct Entity {
    template<typename T>
    T* GetComponent();  // Get component by type
    
    entIComponent* GetComponent(CName name);  // Get component by name
    
    Transform GetWorldTransform();
    void SetWorldTransform(const Transform& transform);
};

// Transform
struct Transform {
    Vector3 position;
    Quat orientation;
    Vector3 scale;
};
```

## What This Tester Proves

| Test | Expected | What It Means |
|------|----------|---------------|
| Strategy 1 (Camera) | Works | Camera rotation is independent of body |
| Strategy 2 (Teleport) | Yaw only | Confirms locomotion clamps pitch/roll |
| Strategy 3 (RED4ext) | TBD | Key test: does native SetWorldTransform bypass the clamp? |
| Strategy 4 (Vehicle Mount) | TBD | Does player inherit vehicle rotation while mounted? |

## Known Limitations

1. **RED4ext plugin is a skeleton**: The hook registration code is documented but commented out because the exact function name to hook needs to be verified against the game's reflection system. Uncomment and adapt once the correct function is identified.

2. **Vehicle mounting is uncertain**: CET doesn't expose direct vehicle mounting APIs. The Redscript bridge attempts to use the mounting system, but the exact API depends on the game version and may need adjustment.

3. **TweakDB communication is simplified**: The TweakDB read/write code in the RED4ext plugin is a placeholder. The actual implementation depends on the full RED4ext SDK's TweakDB API.

4. **Redscript is untested**: This project hasn't used Redscript before. The bridge syntax follows the standard pattern but may need adjustment.

## Next Steps

1. **Reverse engineer the locomotion update function**: Use tools like IDA Pro, Ghidra, or the game's RTTI system to identify the exact function that clamps the player's orientation. Update the hook registration in `Main.cpp`.

2. **Build and test the RED4ext plugin**: Compile the plugin, install it, and test Strategy 3 to see if native `SetWorldTransform` bypasses the locomotion clamp.

3. **Test vehicle mounting**: Install the Redscript bridge and test Strategy 4 to see if the player inherits vehicle rotation while mounted.

4. **If SetWorldTransform is overridden**: Switch to the reflection-based direct field write approach (documented in `Main.cpp`) to write directly to the component's orientation memory offset.

5. **If the locomotion clamp runs after the hook**: Hook the locomotion update function itself (not just any update) as a REPLACE hook to skip the clamping code entirely.

## File Index

| File | Description |
|------|-------------|
| `cet/init.lua` | CET mod with hotkeys, hover, 4 rotation strategies |
| `red4ext/src/Main.cpp` | RED4ext C++ plugin (hook player update, write orientation) |
| `red4ext/CMakeLists.txt` | CMake build system for RED4ext plugin |
| `redscript/HoverRotPlayer7.reds` | Redscript bridge (vehicle mounting, locomotion access) |
| `README.md` | This file |

## References

| Doc | Content |
|-----|---------|
| `../summary - cet.md` | CET testing summary (all prior testers) |
| `../../docs/c++ hooks/player-extension-analysis.md` | RED4ext feasibility analysis |
| `../../docs/c++ hooks/player-extension-analysis2.md` | Detailed implementation plan |
| `../../docs/c++ hooks/player-extension-analysis3.md` | Quick feasibility notes |
| `../../okf/mods_red4ext/player/red4ext-player-rotation-control.md` | LTBF rotation analysis |
| `../../okf/mods_red4ext/player/red4ext-player-locomotion-states-fell.md` | FELL state analysis |
| `../../sdk/RED4ext.SDK/` | RED4ext SDK headers and examples |
| `../../sources/RED4ext/src/RED4ext/Plugin.cpp` | RED4ext runtime source (hook manager, game instance) |
| `../../sources/mods_red4ext/Let-There-Be-Flight/src/code/Flight.lua` | LTBF vehicle flight mod (CET only) |
