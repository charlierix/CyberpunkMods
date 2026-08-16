# HoverRotTesterPlayer7A — RED4ext-Only Overlay

## Overview

This is an **overlay** on `hover_rot_tester_player7`. Only the CET component changes. The RED4ext plugin and Redscript bridge are **shared from player7** — they are not duplicated here.

## What Changed

| Aspect | Player7 | Player7A |
|---|---|---|
| Strategies | 4 (Camera, Teleport, RED4ext, Vehicle Mount) | 1 (RED4ext Native Override only) |
| Strategy cycling | Yes (CycleStrategy hotkey) | No (hardcoded strategy 3) |
| Vehicle spawn/despawn | Yes | Removed |
| Camera rotation (strategy 1) | Yes | Removed as standalone strategy |
| Teleport rotation (strategy 2) | Yes | Removed |
| TweakDB prefix | `HoverRotPlayer7` | `HoverRotPlayer7` (shared) |
| Hotkey prefix | `HoverRotPlayer7_` | `HoverRotPlayer7A_` |

## Files

| File | Description |
|---|---|
| `cet/init.lua` | Stripped-down CET script with only strategy 3 |

## Shared from Player7 (not duplicated)

| Component | Path in Player7 |
|---|---|
| RED4ext plugin | `red4ext/bin/HoverRotTesterPlayer7.dll` |
| RED4ext source | `red4ext/src/Main.cpp` |
| RED4ext build | `red4ext/CMakeLists.txt` |
| Redscript bridge | `redscript/HoverRotPlayer7.reds` |

## Hotkeys

| Hotkey | Label |
|---|---|
| Toggle | Toggle Active |
| PitchUp / PitchDown | Pitch Up / Down |
| RollLeft / RollRight | Roll Left / Right |
| YawLeft / YawRight | Yaw Left / Right |
| Reset | Reset Rotation |
| HoverUp / HoverDown / HoverStop | Hover Up / Down / Stop |

## TweakDB Communication

The CET script writes orientation data to TweakDB using prefix `HoverRotPlayer7` (same as player7 — the shared RED4ext plugin reads these flats without modification):
- `HoverRotPlayer7_active` — 0/1
- `HoverRotPlayer7_pitch` — float degrees
- `HoverRotPlayer7_yaw` — float degrees
- `HoverRotPlayer7_roll` — float degrees
- `HoverRotPlayer7_strategy` — always 3

Since 7a is a CET-only overlay, the RED4ext plugin and Redscript from player7 are reused as-is — no changes needed to Main.cpp or .reds files.

## Deployment

1. Deploy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/HoverRotTesterPlayer7A/init.lua`
2. Deploy RED4ext DLL and Redscript from player7 as usual
3. Bind hotkeys in Settings > Key Bindings
