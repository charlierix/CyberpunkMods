# C++ Hooks Repository — Folder Structure Guide

> **Purpose**: Describes the folder layout and languages needed for a new repository implementing C++ hooks for Cyberpunk 2077 modding, based on the architecture patterns documented across the VR Port and Let There Be Flight (LTBF) mods.

---

## Overview

A Cyberpunk 2077 C++ hooks mod can involve up to **three distinct technology layers**, each in a different language and serving a different role:

| Layer | Technology | Language | Role |
|-------|-----------|----------|------|
| **RED4ext Plugin** | RED4ext SDK + MinHook + RTTI | C++ | Game-logic hooks, physics manipulation, native method injection, custom game systems |
| **DXGI Proxy** (optional, VR/render mods only) | DXGI/D3D12 + OpenXR | C++ | Render pipeline interception, stereo output, headset pose tracking |
| **CET Lua Bridge** | Cyber Engine Tweaks | Lua | Per-frame pump, game-state logic, hotkey registration, stat modifiers, UI manipulation |
| **Shared Headers** | — | C++ headers | Single source of truth for shared memory slot maps, common constants, cross-layer contracts |

---

## Recommended Folder Structure

```
my-cpp-hooks-mod/
├── red4ext_plugin/          # C++ — RED4ext plugin (core game hooks)
├── dxgi/                    # C++ — DXGI/D3D12 proxy (only if doing render/VR mods)
├── cet/                     # Lua — CET bridge mods (per-frame pump, game logic)
├── common/                 # C++ headers — shared definitions across layers
├── libs/                    # vendored dependencies (RED4ext SDK, MinHook, OpenXR, etc.)
├── cmake/                   # CMake build scripts and toolchain files
├── scripts/                 # build, package, and release automation
├── docs/                    # architecture docs, hook maps, RTTI reference
└── README.md
```

---

## Folder Details

### `red4ext_plugin/` — C++

**Language**: C++ (compiled to a `.dll` loaded by RED4ext)

The core of any C++ hooks mod. Contains all game-engine-level hooks, custom RTTI type registration, native method injection, and plugin entry point.

#### Subfolders

| Subfolder | Purpose | Source Pattern |
|-----------|---------|----------------|
| `red4ext_plugin/` (root) | Plugin entry point (`main.cpp`), RTTI registration, native function exposure to CET, global state | VR Port `main.cpp`; LTBF `FlightSystem.hpp`, `FlightController.hpp` |
| `red4ext_plugin/Engine/` | RTTI type registration templates, class registrar infrastructure | LTBF `Engine/RTTIClass.hpp`, `Engine/RTTIRegistrar.cpp` |
| `red4ext_plugin/Hooks/` | Function detour hooks — physics, locomotion, animation, camera | LTBF `Physics/VehiclePhysicsUpdate.cpp`; VR Port `vrik_hook.h`, `weapon_aim_hook.h` |
| `red4ext_plugin/Systems/` | Custom game system classes registered via `game::IGameSystem` | LTBF `FlightSystem` lifecycle (OnWorldAttached, OnGameSave, OnGameLoad) |
| `red4ext_plugin/Components/` | Custom entity components registered via RTTI | LTBF `FlightComponent` (per-vehicle flight controller) |
| `red4ext_plugin/Extensions/` | Native method injection onto existing game classes (`@addMethod` equivalent in C++) | LTBF `Extensions/VehicleObject.cpp` (GetCenterOfMass, EnableGravity, etc.) |
| `red4ext_plugin/Utils/` | Hook framework macros, factory singleton, hash resolution utilities | LTBF `Utils/FlightModule.hpp` (REGISTER_FLIGHT_HOOK_HASH macros) |
| `red4ext_plugin/Config/` | Scriptable settings bridge — exposes properties to Lua/REDscript | LTBF `FlightSettings.hpp` (GetFloat, SetFloat, GetVector3, GetBool) |

#### Key Files

| File | Purpose |
|------|---------|
| `main.cpp` | Plugin `Load()` / `Unload()` entry, RTTI type registration, hook installation, native function exposure |
| `*.hpp` / `*.cpp` | Class implementations for systems, components, hooks, extensions |

---

### `dxgi/` — C++ (Render/VR Mods Only)

**Language**: C++ (compiled to `dxgi.dll` placed next to the game executable)

Only needed for mods that intercept the rendering pipeline (VR, custom rendering, stereo output). **Skip this folder entirely for pure gameplay/physics hook mods.**

#### Subfolders

| Subfolder | Purpose |
|-----------|---------|
| `dxgi/core/` | DXGI factory wrapper, D3D12 device/command queue proxy |
| `dxgi/openxr/` | OpenXR session lifecycle, pose tracking, frame loop, present |
| `dxgi/render/` | Stereo reprojection, color blit, depth resolve, motion vector warp, optical flow, warp/sharpen passes |
| `dxgi/aer_v2/` | Async reprojection pipeline (NVIDIA Optical Flow / CUDA interop) |
| `dxgi/camera/` | Camera update interception for HMD-driven camera |
| `dxgi/overlay/` | ImGui in-headset settings overlay |
| `dxgi/hooks/` | DLSS/NGX hooks, AOB pattern scanner for address resolution |

---

### `cet/` — Lua

**Language**: Lua (loaded by Cyber Engine Tweaks)

CET Lua mods serve as the per-frame pump and game-logic bridge. They call native functions exposed by the RED4ext plugin and handle game-state-dependent logic that's easier in Lua than C++.

#### Subfolders (one per CET mod)

Each CET mod is a subfolder containing an `init.lua`. Typical structure:

| Subfolder | Purpose | Example from VR Port |
|-----------|---------|---------------------|
| `cet/<ModName>_Pump/` | Per-frame IK/physics input pump | `VRIK_Pump` — calls `SetVRTransforms()`, `SetVRPlayerYaw()` every frame |
| `cet/<ModName>_Weapon/` | Weapon-related game logic | `Weapon_Aim` — muzzle publishing, melee, scope zoom |
| `cet/<ModName>_Crosshair/` | UI manipulation | `Crosshair_Hide` — hides crosshair when custom aim active |
| `cet/<ModName>_UI/` | Menu/map state management | `WorldMap_Lock` — notifies plugin to stop camera drive in menus |
| `cet/<ModName>_Holster/` | Weapon holster logic | `Holster_Lua` |
| `cet/<ModName>_HUD/` | HUD manipulation | `HUD_Lua` |

#### Key Files per CET Mod

| File | Purpose |
|------|---------|
| `init.lua` | Main mod entry — `registerForEvent("onInit", ...)`, `registerForEvent("onUpdate", ...)`, `registerHotkey(...)` |

> **Important**: `registerHotkey()` calls **must** be at the root level of `init.lua`, never inside `onInit`. See the project's `cet-hotkeys.promptinclude.md` rule.

---

### `common/` — C++ Headers

**Language**: C++ headers only (no `.cpp` files)

Single source of truth for definitions shared across the RED4ext plugin, DXGI layer, and any other C++ components.

#### Key Files

| File | Purpose | Example from VR Port |
|------|---------|---------------------|
| `shared_slots.h` | Shared memory slot assignments (indices, ranges, seqlock protocol) | VR Port `common/shared_slots.h` — 128-float slot map |
| `common_types.h` | Shared structs, enums, constants used across layers | PhysicsData layout, hook state enums |
| `version.h` | Mod version, compatibility flags | Build version, supported game patch versions |

---

### `libs/` — Vendored Dependencies

**Language**: C++ headers/libraries

Vendored third-party dependencies to ensure reproducible builds.

| Subfolder | Purpose |
|-----------|---------|
| `libs/RED4ext/` | RED4ext SDK headers and import library |
| `libs/MinHook/` | MinHook function hooking library |
| `libs/OpenXR/` | OpenXR headers (only if `dxgi/` layer is used) |
| `libs/DirectXMath/` | DirectX math helpers (vectors, matrices, quaternions) |
| `libs/imgui/` | Dear ImGui (only if overlay UI is needed) |

---

### `cmake/` — Build Configuration

**Language**: CMake

| File | Purpose |
|------|---------|
| `CMakeLists.txt` (root) | Top-level build — defines targets for each layer (plugin, dxgi, common) |
| `cmake/FindRED4ext.cmake` | CMake find module for RED4ext SDK |
| `cmake/FindMinHook.cmake` | CMake find module for MinHook |
| `cmake/toolchain-msvc.cmake` | MSVC toolchain config (RED4ext plugins require MSVC) |

---

### `scripts/` — Automation

**Language**: Shell / Python

| File | Purpose |
|------|---------|
| `scripts/build.sh` | Build all targets and copy outputs to staging |
| `scripts/package.sh` | Zip mod into distributable format |
| `scripts/install.sh` | Copy built artifacts to Cyberpunk 2077 `plugins/` and `bin/` directories |

---

### `docs/` — Architecture Documentation

**Language**: Markdown + Mermaid diagrams

| File | Purpose |
|------|---------|
| `docs/architecture.md` | High-level architecture overview with mermaid diagrams |
| `docs/hook-map.md` | Table of every hooked function, its hash, purpose, and active-check pattern |
| `docs/rtti-types.md` | List of all custom RTTI types registered, their properties and methods |
| `docs/shared-memory.md` | Shared memory slot map and seqlock protocol reference |
| `docs/build-setup.md` | Build environment setup instructions |

---

## Language Summary

| Folder | Primary Language | Secondary | Compiled? |
|--------|----------------|-----------|-----------|
| `red4ext_plugin/` | C++ | — | Yes → `.dll` |
| `dxgi/` | C++ | — | Yes → `dxgi.dll` |
| `cet/` | Lua | — | No (interpreted by CET) |
| `common/` | C++ headers | — | No (included by other targets) |
| `libs/` | C++ headers/libs | — | No (prebuilt or header-only) |
| `cmake/` | CMake | — | No (build scripts) |
| `scripts/` | Bash / Python | — | No (automation) |
| `docs/` | Markdown | Mermaid | No (documentation) |

---

## Minimal Layout (Physics/Gameplay Hooks Only)

If you're **not** doing VR or render pipeline interception, the minimal layout is:

```
my-cpp-hooks-mod/
├── red4ext_plugin/
│   ├── main.cpp
│   ├── Engine/
│   ├── Hooks/
│   ├── Systems/
│   ├── Components/
│   ├── Extensions/
│   ├── Utils/
│   └── Config/
├── cet/
│   └── <ModName>_init/
│       └── init.lua
├── common/
│   └── common_types.h
├── libs/
│   ├── RED4ext/
│   └── MinHook/
├── cmake/
├── scripts/
├── docs/
└── README.md
```

No `dxgi/` folder is needed unless intercepting the render pipeline.

---

## Full Layout (Including VR/Render Layer)

```
my-cpp-hooks-mod/
├── red4ext_plugin/
│   ├── main.cpp
│   ├── Engine/
│   ├── Hooks/
│   ├── Systems/
│   ├── Components/
│   ├── Extensions/
│   ├── Utils/
│   └── Config/
├── dxgi/
│   ├── core/
│   ├── openxr/
│   ├── render/
│   ├── aer_v2/
│   ├── camera/
│   ├── overlay/
│   └── hooks/
├── cet/
│   ├── <ModName>_Pump/
│   ├── <ModName>_Weapon/
│   ├── <ModName>_Crosshair/
│   ├── <ModName>_UI/
│   └── ...
├── common/
│   ├── shared_slots.h
│   ├── common_types.h
│   └── version.h
├── libs/
│   ├── RED4ext/
│   ├── MinHook/
│   ├── OpenXR/
│   ├── DirectXMath/
│   └── imgui/
├── cmake/
├── scripts/
├── docs/
└── README.md
```

---

## Key Architectural Patterns to Follow

### 1. RTTI Type Registration (C++)

Register custom C++ classes as native game types so they're accessible from REDscript/Lua:

- Use a template-based RTTI system (like LTBF's `Engine::RTTIClass<Derived, Base>`)
- Each class provides `OnRegister()` (set flags) and `OnDescribe()` (register methods/properties)
- Use offset assertions (`RED4EXT_ASSERT_OFFSET`) to enforce struct layout correctness

### 2. Hash-Based Hooking (C++)

Use hash-based function resolution for patch resistance:

- `REGISTER_HOOK_HASH` macros that resolve addresses via `RED4ext::UniversalRelocBase::Resolve(hash)`
- A factory singleton collects all hooks at static init, then `Load()` / `Unload()` attaches/detaches them
- Every hook follows the active-check pattern: check if mod is active → modify behavior or return early → otherwise pass through to original

### 3. Shared Memory Bridge (C++ headers + C++ implementation)

For inter-layer communication (e.g., DXGI → RED4ext plugin):

- Define slot assignments in a single header (`common/shared_slots.h`)
- Use a seqlock protocol for lock-free single-writer, multi-reader consistency
- One layer writes, another reads via atomic fences

### 4. CET Native Function Bridge (C++ → Lua)

Expose native functions from the RED4ext plugin that CET Lua can call:

- Register functions via RTTI in `main.cpp`
- CET Lua calls them as global functions (e.g., `SetVRTransforms(...)`, `GetVRWeaponAim()`)
- Use this for per-frame data publishing (poses, settings, state toggles)

### 5. CET as Per-Frame Pump (Lua)

Use CET Lua for game-state-dependent logic that's easier in Lua than C++:

- `onUpdate(dt)` in Lua calls native functions published by the C++ plugin
- `registerHotkey()` at root level for user-configurable keybinds
- Stat modifiers, UI hiding, crosshair state, menu detection — all simpler in Lua

---

## Source References

This guide synthesizes patterns from:

| Mod | Source Path | Docs Path |
|-----|-----------|-----------|
| CyberpunkVRPort | `sources - extra/vr/repo/src/` | `docs/c++ hooks/cyberpunk vr port - c++ hooks.md` |
| Let There Be Flight | `sources - extra/flying vehicles/let_there_be_flight - repo/src/red4ext/` | `docs/c++ hooks/let there be flight - c++ hooks.md` |
| Free Player Manipulation (analysis) | — | `docs/c++ hooks/free player manipulation - analysis.md` |
| Player Class Hierarchy (reference) | — | `docs/c++ hooks/player class hierarchy - physics perspective.md` |

---

*Generated from analysis of four C++ hooks architecture documents in the Cyberpunk 2077 modding project.*
