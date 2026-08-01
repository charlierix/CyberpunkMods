# Status Effect Device Tester 2

Random device effect tester testing **two unexplored execution paths** for applying hacks to devices programmatically.

## Purpose

Tester1 proved that the QuickHack action chain (`GetQuickHackActions` + `ProcessRPGAction` + `OnQuickHack*` handlers) executes with 100% API success but produces **zero visible in-game effects** on devices. The action chain is a dead end.

Tester2 tests two completely different API surfaces that have **never been tried**:

| Path | API Surface | Why It Might Work |
|---|---|---|
| **1: QuestForce Actions** | `GetQuestActions()` with `requestType=Quest` + `OnQuestForce*` handlers | QuestForce actions are designed for quest scripts to force device states **without scanner/breach context** — exactly the companion orb use case |
| **2: Direct StatusEffect** | `StatusEffectHelper.ApplyStatusEffect(device, recordID)` | Proven on NPCs (npc_tester1 + Blackwall mod). Never tested on device entities. Simplest possible API. |

## What This Tester Does

When you press the APPLY hotkey:

1. **Randomly picks a path** (50% QuestForce, 50% StatusEffect)
2. **Within the chosen path, picks a random effect/action** (weighted toward untried types)
3. **If QuestForce: randomly picks an execution strategy** (action chain / PS handler / DeviceSystem — order shuffled per attempt)
4. **If StatusEffect: tries multiple API methods** (Helper 2-arg, Helper 3-arg, System, TweakDBID, gameEffect)
5. **Logs everything** with full detail for post-hoc analysis

The randomness ensures broad coverage across both paths, effect types, and execution methods. Log analysis after the fact will reveal which combinations (if any) produced visible results.

## Interface

| Hotkey | Label | Action |
|---|---|---|
| `SE_DEV2_TOGGLE_WINDOW` | Toggle Info Window | Show/hide ImGui window |
| `SE_DEV2_APPLY` | Apply Random Effect | Apply a random effect to the device under crosshair |

The ImGui window shows:
- Path stats (attempts + API-successes per path)
- Coverage bars for both paths
- Current target info
- Last result (path, effect, strategy, success/fail)
- Quest actions available on current device
- All status effect candidates with attempt counts

## QuestForce Actions Tested (Path 1)

Discovered dynamically via `GetQuestActions()` per device. Known quest action types from okf research:

- `QuestForceON` / `QuestForceOFF` — force device on/off
- `QuestStartGlitch` / `QuestStopGlitch` — glitch effects
- `QuestForceActivate` / `QuestForceDeactivate` — activate/deactivate
- `QuestForceEnabled` / `QuestForceDisabled` — enable/disable
- `QuestForcePower` / `QuestForceUnpower` — power on/off
- `QuestForceDestructible` — make destructible
- `QuestForceDetonate` (explosives) — force detonation
- `QuestForceSecuritySystemSafe/Alarmed/Armed` — security states
- `QuestForceCameraZoom` — camera zoom
- `QuestEnableFixing` / `QuestDisableFixing` — enable/disable fixing

Execution strategies (randomized order per attempt):
- **QA: FullChain** — `SetupAction` → `IsPossible` → `ResolveAction` → `StartAction` (with `ProcessRPGAction` / `CompleteAction` fallbacks)
- **QB: PSHandler** — Direct `ps:OnQuestForce*(action)` call (with no-arg and `QueuePSDeviceEvent` fallbacks)
- **QC: DeviceSystem** — `DeviceSystem:GetDeviceById()` → `device:ExecuteAction()` (with `ProcessAction` fallback)

## Status Effects Tested (Path 2)

15 candidate status effects applied directly to device entities:

| Effect | Goal |
|---|---|
| `QuickHackDistraction` | Distract |
| `QuickHackExplodeExplosive` | Destruct |
| `QuickHackBlind` | Distract |
| `QuickHackToggleOn` | Activate |
| `OverloadDevice` | Destruct |
| `HighPitchNoise` | Distract |
| `EMP` / `BaseEMP` | Destruct |
| `GlitchScreen` | Distract |
| `QuickHackOverload` | Destruct |
| `QuickHackMotive` | Distract |
| `QuickHackCommitSuicide` | Destruct |
| `QuickHackDisable` | Destruct |
| `QuickHackPing` | Detect |
| `Ping_Cyberpsycho` | Detect |

API methods tried (in order, first success wins):
- **S1:** `StatusEffectHelper.ApplyStatusEffect(target, recordID)`
- **S2:** `StatusEffectHelper.ApplyStatusEffect(target, recordID, player)`
- **S3:** `Game.GetStatusEffectSystem():ApplyStatusEffect(target, recordID, player)`
- **S4:** `StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new(recordID))`
- **S5:** `gameEffect` construction + execute

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester2/
```

Bind hotkeys in: **Settings > Key Bindings > SEDevT2**

## Usage

1. Toggle the info window on
2. Look at a device (vending machine, TV, light, explosive, access point, etc.)
3. Press APPLY for a random effect
4. **Observe the game** — does anything happen visually?
5. Write down what you observed in the log
6. Repeat on different device types
7. Check coverage bars — stop when both paths reach high coverage
8. On shutdown, final statistics are printed to CET console

## Logging

All output goes to the CET console (`[SEDevT2]` prefix):
- First encounter with each device type generates a report (quest actions available)
- Each apply logs: path, effect name, target, strategy used, result, coverage
- On shutdown: final statistics with per-effect attempt counts and device types
- **Important:** API success does NOT mean visible in-game effect. Cross-reference the log with your in-game observations.

## What This Tester is NOT Testing (Left for Tester3)

The research doc (`statuseffect_device_tester1/research_effect_execution_paths.md`) identified 5 unexplored paths. Tester2 covers paths 1 and 2. The following remain untested:

| Path | What It Is | Why It\'s Left |
|---|---|---|
| **3: Manual Effect (Stims + Damage)** | Trigger AI stims at device position for distraction, use `DamageSystem` for explosions | Uses proven CET APIs — good fallback if paths 1-2 fail. Needs separate tester because it\'s a different paradigm (no device interaction, just world-level effects). |
| **4: DeviceOperations Pipeline** | Device\'s own effect pipeline (`PlayEffectDeviceOperation`, `ApplyDamageDeviceOperation`, `StimDeviceOperation`) | API for accessing/triggering `DeviceOperationsComponent` from CET Lua is unclear. Needs more source-level research before it can be tested. |
| **5: EffectExecutor / Game Effects** | Native effect system (`EffectExecutor_VisualEffectAtTarget`, `EMP`, `EMPExplosion`) | Construction API for `gameEffect` objects with specific `EffectExecutor` is unclear. Needs more source-level research. |

If tester2 shows that QuestForce and/or Direct StatusEffect produce visible results, tester3 may not be needed. If both fail, tester3 should focus on Path 3 (manual stims/damage) as the most reliable fallback.

## Key Difference from Tester1

| Aspect | Tester1 | Tester2 |
|---|---|---|
| Action discovery | `GetQuickHackActions()` | `GetQuestActions()` (Path 1) + static effect list (Path 2) |
| Context type | `requestType = Remote` | `requestType = Quest` (Path 1) |
| Execution | 3-strategy chain on QuickHack actions | 3-strategy chain on Quest actions + 5-method status effect application |
| Target | QuickHack action objects | Quest action objects + device entity directly |
| Paths tested | 1 (QuickHack action chain) | 2 (QuestForce + Direct StatusEffect) |

## Based On

- Research: `statuseffect_device_tester1/research_effect_execution_paths.md`
- Tester1 patterns: `statuseffect_device_tester1/init.lua` (targeting, window, logging reused)
- okf device docs: `okf/adamsmasher/cyberpunk/devices/core.md`, `explosive.md`
- okf effect docs: `okf/api/effects/effect-executor-scripted/`
