# Status Effect Device Tester 5 -- EffectExecutor_Scripted Investigation

## Purpose

Test `EffectExecutor_Scripted` classes and the `gameEffect` construction API in CET Lua, targeting point-based visual effects and EMP/area effects at arbitrary positions.

Based on `device hack summary.md` suggestion #3:
- Test EffectExecutor_Scripted classes
- Research gameEffect construction API
- Try EffectExecutor_VisualEffectAtTarget for point-based visual effects
- Try EMP/EMPExplosion for area effects at arbitrary positions

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester5/
```

## Hotkeys

Bind in **Settings > Key Bindings > SEDevT5**:

| Hotkey | Name | Action |
|---|---|---|
| F8 | `SE_DEV5_SCAN` | Scan target device (look at device + press) |
| F9 | `SE_DEV5_CONSTRUCT` | Run all construction strategies (A1-A9) |
| F10 | `SE_DEV5_EXECUTE` | Run all execution strategies (B1-B5) on scanned target |
| F11 | `SE_DEV5_TWEAKDB` | Run all TweakDB linkage strategies (C1-C3) |
| F12 | `SE_DEV5_TOGGLE_WINDOW` | Toggle ImGui info window |

## Strategy Matrix

### Phase A: Construction (A1-A9)

Tests whether CET Lua can construct `EffectExecutor_Scripted` or `gameEffectData` objects.

| Key | Strategy | Expected (from fx_tester) |
|---|---|---|
| A1 | `NewObject("gameEffectData")` | Likely fails -- NewObject doesn't support effect types |
| A2 | `NewObject("EffectExecutor_VisualEffectAtTarget")` | Unknown -- first test |
| A3 | `NewObject("EMP")` | Unknown -- first test |
| A4 | `NewObject("EMPExplosion")` | Unknown -- first test |
| A5 | `gameEffectData.new()` | Fails -- not a valid CET Lua type (fx_tester confirmed) |
| A6 | `EffectExecutor_VisualEffectAtTarget.new()` | Unknown -- first test |
| A7 | `Game.GetEffectSystem()` | Fails -- not exposed in CET Lua (fx_tester confirmed) |
| A8 | `GetScriptableSystem("EffectSystem")` | Unknown -- first test |
| A9 | TweakDB: Get StatusEffect records with executor refs | Should work -- TweakDB access is functional |

### Phase B: Execution (B1-B5)

Applies EMP/Overload status effects to devices and at player position.

| Key | Effect | Target |
|---|---|---|
| B1 | `BaseStatusEffect.EMP` | Device |
| B2 | `BaseStatusEffect.EMP` | Player (point-based at position) |
| B3 | `BaseStatusEffect.OverloadEMP` | Device |
| B4 | `BaseStatusEffect.BaseOverload` | Device |
| B5 | `BaseStatusEffect.BaseEMP` | Device |

Note: Previous testers (tester2, tester3) confirmed these return API SUCCESS but produce zero visible effect on devices. This tester re-tests systematically with `ObjectHasStatusEffect` verification.

### Phase C: TweakDB Linkage (C1-C3)

Investigates TweakDB records that embed EffectExecutor classes.

| Key | Strategy |
|---|---|
| C1 | Dump StatusEffect packages (GetPackages) for EMP/visual records |
| C2 | Dump Attack_GameEffect records (Attacks.QuickHack.*) |
| C3 | Search TweakDB for StatusEffectExecutor records referencing EMP/VisualEffectAtTarget |

## EffectExecutor_Scripted Class Catalog

| # | Class | Fields | Methods | Source |
|---|---|---|---|---|
| 1 | EMP | 0 | 2 | 137687.json |
| 2 | EMPExplosion | 0 | 1 | 137697.json |
| 3 | EffectExecutor_VisualEffectAtTarget | 2 | 2 | 137914.json |
| 4 | EffectExecutor_SetDeviceON | 0 | 1 | 137833.json |
| 5 | EffectExecutor_SetDeviceOFF | 0 | 1 | 137751.json |
| 6 | EffectExecutor_ToggleDevice | 0 | 1 | 137840.json |
| 7 | ApplyJammer | 0 | 1 | 137673.json |
| 8 | ApplyJammerFromCw | 0 | 1 | 137679.json |
| 9 | EffectExecutor_PingNetwork | 1 | 6 | 137703.json |
| 10 | EffectExecutor_MuteBubble | 0 | 4 | 137731.json |
| 11 | StrikeExecutor_Heal | 1 | 1 | 151346.json |
| 12 | StrikeExecutor_Kill | 0 | 1 | 151353.json |
| 13 | EffectExecutor_ApplyEffector | 1 | 1 | 151332.json |
| 14 | EffectExecutor_GameObjectOutline | 1 | 1 | 95427.json |
| 15 | EffectExecutor_SlashEffect | 1 | 1 | 151457.json |
| 16 | EffectExecutor_Spread | 4 | 2 | 100193.json |

## Context from Previous Testers

- **fx_tester** confirmed: `gameEffectData.new()`, `NewObject("gameEffectData")`, `Game.GetEffectSystem()`, `gameAttack_GameEffect.new()` all fail in CET Lua
- **statuseffect_device_tester2/3** confirmed: StatusEffectHelper.ApplyStatusEffect with EMP/BaseEMP/OverloadEMP returns SUCCESS but produces zero visible effect on devices
- This tester systematically re-tests construction with additional NewObject variants and verifies execution with ObjectHasStatusEffect

## Key APIs Used

- `NewObject(typeName)` -- CET Lua object constructor
- `StatusEffectHelper.ApplyStatusEffect(target, recordID, instigator)` -- status effect application
- `StatusEffectHelper.ObjectHasStatusEffect(target, recordID)` -- verification
- `TweakDB:GetRecord(recordID)` -- TweakDB record lookup
- `TweakDB:GetFlat(flatID)` -- TweakDB flat lookup
- `Game.GetTargetingSystem():GetTarget(player, query)` -- target detection
- `gameTargetSearchQuery.new()` -- target search query construction
