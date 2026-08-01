# Status Effect Device Tester 1

Random quickhack action tester for **devices** with live info window.

## Purpose

Tests device quickhacks using **dynamic action discovery** instead of a static effect list. Each device type exposes different quickhack actions — this tester queries the device at runtime via `DevicePS:GetQuickHackActions()` and executes them through the full action chain.

Based on research from `statuseffect_tester3/research_device_hacks.md` and execution logic from `quickhack_tester4`.

## Key Differences from Tester3

| Tester3 | Device Tester1 |
|---------|----------------|
| Static list of 5 `BaseStatusEffect.*` (wrong record type) | Dynamic `GetQuickHackActions()` per device |
| Same effects for all device types | Each device queried for its own available hacks |
| `StatusEffectHelper.ApplyStatusEffect` only | Full chain: StartAction → PS handler → DeviceSystem |
| No coverage tracking | Global action type registry with coverage % |

## Interface

Same simplicity as tester3 / npc_tester1 — only **2 hotkeys**:

| Hotkey | Label | Action |
|--------|-------|--------|
| `SE_DEV1_TOGGLE_WINDOW` | Toggle Info Window | Show/hide ImGui window |
| `SE_DEV1_APPLY` | Apply Random Hack | Apply a random weighted quickhack to the device under crosshair |

### Weighted Random Selection

- Untried action types get higher selection weight
- Coverage tracked globally across all device types encountered
- Action types keyed by class name (e.g., `QuickHackDistraction`, `GlitchScreen`)

### Coverage Indicator

The ImGui window shows a progress bar and percentage:
```
Coverage: 3/7 tried (43%) -- 4 untried
[############------------------------------]
```

- `*` marks action types tried at least once
- Walk around hitting APPLY on different device types to fill coverage

## Execution Chain

When APPLY is pressed, the selected action goes through three strategies in order:

1. **Strategy A: Full Action Chain** — `SetupAction` → `IsPossible` → `ResolveAction` → `StartAction` (with `ProcessRPGAction` and `CompleteAction` fallbacks)
2. **Strategy B: Direct PS Handler** — Calls `ps:OnQuickHack*(action)` directly (bypasses action object)
3. **Strategy C: DeviceSystem Direct** — `DeviceSystem:GetDeviceById` → `device:ExecuteAction`

The window shows which strategy succeeded.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester1/
```

Bind hotkeys in: **Settings > Key Bindings > SEDevT1**

## Usage

1. Toggle the info window on
2. Look at a device (vending machine, flood light, access point, explosive, etc.)
3. Press APPLY for a random weighted quickhack
4. Observe what happens, write down observations
5. Move to next device type and repeat
6. Check coverage % — stop when all known action types have been tried

## Logging

All output goes to the CET console (`[SEDevT1]` prefix):
- First encounter with each device type generates a report (actions available, record IDs)
- Each apply logs: action name, class, target, result, strategy used, coverage
- On shutdown: final statistics with per-action attempt counts and device types encountered

Log analysis is done later to determine if another tester is needed.
