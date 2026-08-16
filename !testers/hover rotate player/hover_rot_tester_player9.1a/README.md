# HoverRotTesterPlayer9.1a

## Overview

Full 3-language diagnostic logging tester (CET + Redscript + RED4ext) that fills the 2 unmet goals from tester 9.1:

1. **Bone/skeleton access** — CET's `GetSkeleton()` returned nil. This tester uses RED4ext C++ to read `anim::Rig` bone data directly from memory via `ent::AnimatedComponent::rig` (offset 0x138).
2. **Render-source identification** — C++ reads bone transforms (`aPoseMS`) and entity `worldTransform` for comparison during mouse-look experiments.

**Strategy:** Pure observation / logging only — no transform overrides or manipulations.

## Architecture

```
CET Lua (init.lua)
  ├── Hotkeys, ImGui, hover PD controller, CET-level probes
  ├── Calls Redscript bridge methods via ScriptableSystemsContainer
  └── Logs all results to CET console

Redscript (HoverRotPlayer9_1a.reds)
  ├── Declares 4 native global functions (implemented in C++)
  └── ScriptableSystem bridge class for CET access

RED4ext C++ (Main.cpp)
  ├── 4 native global functions registered via RTTI
  ├── Reads player entity via ExecuteGlobalFunction("GetPlayer;GameInstance")
  ├── Accesses bone data via raw memory offsets (verified from SDK headers)
  └── Logs to RED4ext plugin logger
```

## Native C++ Functions

| Function | Returns | Description |
|---|---|---|
| `HoverRotPlayer9_1a_DumpComponents()` | String | All component class names (one per line: `index\|className`) |
| `HoverRotPlayer9_1a_DumpSkeleton()` | String | Bone hierarchy + transforms (`boneIndex\|boneName\|parentIdx\|tx\|ty\|tz\|qi\|qj\|qk\|qr`) |
| `HoverRotPlayer9_1a_DumpEntityTransform()` | String | Entity worldTransform (`posRaw(x,y,z)\|orient(i,j,k,r)`) |
| `HoverRotPlayer9_1a_GetStatus()` | String | Plugin diagnostics |

## SDK Offsets Used (verified from RED4ext.SDK headers)

| Structure | Field | Offset | Type |
|---|---|---|---|
| `ent::Entity` | components | 0xA0 | `DynArray<Handle<IComponent>>` |
| `ent::Entity` | transformComponent | 0xB0 | `IPlacedComponent*` |
| `IPlacedComponent` | worldTransform | 0xE0 | `WorldTransform` |
| `IScriptable` | nativeType | 0x30 | `CClass*` |
| `CClass` | name | 0x18 | `CName` |
| `ent::AnimatedComponent` | rig | 0x138 | `Ref<anim::Rig>` (first 8 bytes = pointer) |
| `anim::Rig` | parentIndices | 0x40 | `int16_t*` |
| `anim::Rig` | boneNames | 0x50 | `DynArray<CName>` |
| `anim::Rig` | referencePoseMS | 0x60 | `DynArray<QsTransform>` |
| `anim::Rig` | aPoseLS | 0xB8 | `DynArray<QsTransform>` |
| `anim::Rig` | aPoseMS | 0xC8 | `DynArray<QsTransform>` |
| `QsTransform` | Translation | 0x00 | `Vector4` (16 bytes) |
| `QsTransform` | Rotation | 0x10 | `Quaternion` (16 bytes) |
| `QsTransform` | Scale | 0x20 | `Vector4` (16 bytes) |
| `QsTransform` | total size | — | 0x30 bytes |

## Files

| File | Description |
|---|---|
| `red4ext/src/Main.cpp` | C++ plugin with 4 native logging functions |
| `red4ext/CMakeLists.txt` | CMake build configuration |
| `redscript/HoverRotPlayer9_1a.reds` | Redscript bridge declaring native functions + ScriptableSystem |
| `cet/init.lua` | CET mod: hotkeys, logging, hover, ImGui, bridge calls |
| `goals 1 - logging.md` | Goals met/unmet documentation |

## Hotkeys

| Hotkey | Action |
|---|---|
| Toggle Logging | Start/stop periodic transform dumps |
| Dump All | Full diagnostics in one key: CET transforms, camera, components, state machine, CET bone attempt, C++ bones, C++ components, C++ entity transform, C++ status |
| Snapshot A (Before) | Capture all transforms to state A |
| Snapshot B (After + Compare) | Capture state B and auto-compare against A |
| Hover Toggle | Activate/deactivate hover PD controller |
| Hover Up / Down | Adjust hover height ±1m |
| Hover Stop | Emergency hover stop |

## Deployment

### RED4ext Plugin

run **'x64 Native Tools Command Prompt'**

```bash
cd "testers\hover rotate player\hover_rot_tester_player9.1a\red4ext"

rmdir /s /q build
mkdir build
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release -DRED4EXT_SDK_PATH="D:\agent zero\!v2b\projects\cyberpunk\sdk\RED4ext.SDK\include"
cmake --build . --config Release
```

created file:
red4ext/bin/HoverRotTesterPlayer9_1a.dll

copy to red4ext/plugins/HoverRotTesterPlayer9_1a/HoverRotTesterPlayer9_1a.dll



### Redscript
1. Copy `redscript/HoverRotPlayer9_1a.reds` to `r6/scripts/HoverRotPlayer9_1a/`

### CET
1. Copy `cet/init.lua` to `bin/x64/plugins/cyber_engine_tweaks/mods/HoverRotTesterPlayer9_1a/init.lua`

## What 9.1a Adds Over 9.1

- **RED4ext C++ plugin** — 4 native functions that bypass CET limitations
- **Redscript bridge** — ScriptableSystem wrapping native calls for CET access
- **C++ skeleton access** — reads `anim::Rig` bone names, parent indices, and animated pose transforms
- **C++ entity transform** — reads `worldTransform` raw memory for cross-validation with CET
- **C++ component enumeration** — reads component class names via `CClass::name` offset
- **Snapshot comparison** now includes C++ entity transform delta

## References

- Tester 7/7b: TweakDB communication pattern (CET ↔ RED4ext)
- Tester 8: CET → Redscript → RED4ext bridge pattern (proven)
- Tester 9.1: Logging goals and CET-level probes
- `cet-hotkeys.promptinclude.md`: registerHotkey must be at file root level
