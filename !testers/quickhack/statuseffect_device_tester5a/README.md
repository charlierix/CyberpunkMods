# Status Effect Device Tester 5a -- EffectExecutor_Scripted Investigation (Full Logging)

## Purpose

Identical strategy matrix to tester5, but with **comprehensive print() logging at every step** so the CET log captures full diagnostic output for analysis.

All prints are unconditional (not gated behind a debug flag). Every SafeCall, scan field read, strategy attempt, TweakDB lookup, verification check, and phase summary is logged with `[SEDevT5a]` prefix.

## Why 5a Exists

Tester5 reported results only in the ImGui debug window, leaving the CET log nearly empty. When issues occurred, there was nothing in the log to analyze. Tester5a fixes this by printing everything.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester5a/
```

## Hotkeys

Bind in **Settings > Key Bindings > SEDevT5a**:

| Hotkey | Name | Action |
|---|---|---|
| F8 | `SE_DEV5A_SCAN` | Scan target device (look at device + press) |
| F9 | `SE_DEV5A_CONSTRUCT` | Run all construction strategies (A1-A9) |
| F10 | `SE_DEV5A_EXECUTE` | Run all execution strategies (B1-B5) on scanned target |
| F11 | `SE_DEV5A_TWEAKDB` | Run all TweakDB linkage strategies (C1-C3) |
| F12 | `SE_DEV5A_TOGGLE_WINDOW` | Toggle ImGui info window |

## What Gets Logged

### Scan (F8)
- Player detection, search query creation, filter creation
- Target detection result (found/nil/not defined)
- Each field read: GetWorldPosition, GetDisplayName, GetClassName, GetEntityID
- Device PS access (GetDevicePS → GetPS fallback)
- Computed distance, full scan summary

### Construction (F9, A1-A9)
- Before each strategy: what API call is being attempted
- SafeCall entry and result (success/failure + return value)
- For A9: each TweakDB record lookup with found/not-found status
- After each strategy: SUCCESS/FAILED with result string
- Phase summary table: all attempts, successes, and last results

### Execution (F10, B1-B5)
- Before each strategy: full API call signature being attempted
- Player and target object references
- ApplyStatusEffect return value (success + result)
- Verification: ObjectHasStatusEffect for EMP (all strategies) + specific effect (B3-B5)
- Each verification result logged separately
- Phase summary table

### TweakDB (F11, C1-C3)
- C1: Each effect ID lookup, GetPackages() call, each package element [0..19]
- C2: Each Attacks.QuickHack.* record lookup
- C3: Each search term lookup with found/not-found
- Phase summary table

## Strategy Matrix

### Phase A: Construction (A1-A9)

| Key | Strategy | Expected |
|---|---|---|
| A1 | `NewObject("gameEffectData")` | Likely fails |
| A2 | `NewObject("EffectExecutor_VisualEffectAtTarget")` | Unknown |
| A3 | `NewObject("EMP")` | Unknown |
| A4 | `NewObject("EMPExplosion")` | Unknown |
| A5 | `gameEffectData.new()` | Fails |
| A6 | `EffectExecutor_VisualEffectAtTarget.new()` | Unknown |
| A7 | `Game.GetEffectSystem()` | Fails |
| A8 | `GetScriptableSystem("EffectSystem")` | Unknown |
| A9 | TweakDB: Get StatusEffect records | Should work |

### Phase B: Execution (B1-B5)

| Key | Effect | Target |
|---|---|---|
| B1 | `BaseStatusEffect.EMP` | Device |
| B2 | `BaseStatusEffect.EMP` | Player (point-based) |
| B3 | `BaseStatusEffect.OverloadEMP` | Device |
| B4 | `BaseStatusEffect.BaseOverload` | Device |
| B5 | `BaseStatusEffect.BaseEMP` | Device |

### Phase C: TweakDB Linkage (C1-C3)

| Key | Strategy |
|---|---|
| C1 | Dump StatusEffect packages for EMP/visual records |
| C2 | Dump Attack_GameEffect records (Attacks.QuickHack.*) |
| C3 | Search TweakDB for StatusEffectExecutor records |

## Log Output Format

All log lines are prefixed with `[SEDevT5a]` and include phase tags:
- `[SEDevT5a] [SCAN] ...` -- scan operations
- `[SEDevT5a] [CONSTRUCT] ...` -- construction phase
- `[SEDevT5a] [EXECUTE] ...` -- execution phase
- `[SEDevT5a] [TWEAKDB] ...` -- TweakDB phase
- `[SEDevT5a] ERR: ...` -- errors
- `[SEDevT5a] ======== HOTKEY: ... ========` -- hotkey boundaries

## Key Differences from Tester5

| Aspect | Tester5 | Tester5a |
|---|---|---|
| Mod name | SEDevT5 | SEDevT5a |
| Hotkey prefix | SE_DEV5_ | SE_DEV5A_ |
| Print gating | `if Config.debug then print()` | Always prints (unconditional) |
| SafeCall logging | Only errors | Entry + success/failure + return value |
| Scan logging | Minimal | Every field read logged |
| Strategy logging | Result only | Before attempt + after result + verification |
| Phase summaries | None | Full summary table printed |
| Hotkey boundaries | None | `======== HOTKEY: ... ========` markers |
| Verification logging | Result only | Each ObjectHasStatusEffect check logged |
| TweakDB C1 logging | None | Each record, GetPackages, each package element |
