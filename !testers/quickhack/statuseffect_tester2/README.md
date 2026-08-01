# Status Effect Tester 2

## What This Tests

Applies quickhack-style status effects directly to the target under crosshair, bypassing the quickhack action pipeline entirely.

## Root Cause Analysis of Tester 1 Failure

Tester 1 had **two critical bugs** that caused silent no-ops:

### Bug 1: Target Detection Broken
- `target:IsA("ScriptedPuppet")` failed silently inside `pcall` → NPC=false for ALL targets
- Device fallback (checking if `GetDevicePS` method exists) was too broad → Device=true for everything
- **Fix**: Use `target.IsNPC(target)` (Blackwall mod pattern) + `ScriptedPuppet.IsActive(target)`

### Bug 2: Effect IDs Don't Exist
- `BaseStatusEffect.QH_Overheat_Lvl1` etc. **do not exist in TweakDB**
- Extensive grep across all okf sources, codeware imports, and mod YAMLs returned empty
- The API silently no-ops on non-existent record IDs, returning SUCCESS but applying nothing
- **Fix**: Use real base game effect IDs (no QH_ prefix, no _Lvl1 suffix)

## Confirmed Real Effect IDs (from source mods)

| Effect ID | Source |
|-----------|--------|
| `BaseStatusEffect.Overheat` | Zeusico REDscript |
| `BaseStatusEffect.Blind` | Neuralware REDscript |
| `BaseStatusEffect.Stun` | Black Chrome YAML |
| `BaseStatusEffect.Ping` | Charm YAML |
| `BaseStatusEffect.Pain` | GameEntityExaminerTool |
| `BaseStatusEffect.NPCForceStagger` | GameEntityExaminerTool |
| `BaseStatusEffect.CyberwareMalfunctionBlackwall` | GameEntityExaminerTool |
| `BaseStatusEffect.Burning` | Source mod grep |
| `BaseStatusEffect.LocomotionMalfunction` | Source mod grep |
| `BaseStatusEffect.LocomotionMalfunctionLevel2` | Source mod grep |
| `BaseStatusEffect.SoMi_Q306_BlackwallHackUpload` | Blackwall mod (quest effect) |

## API Signatures Tried

1. `StatusEffectHelper.ApplyStatusEffect(target, effectID, player)` — 3-arg with instigator (GameEntityExaminerTool)
2. `StatusEffectHelper.ApplyStatusEffect(target, effectID)` — 2-arg (Neuralware)
3. `StatusEffectHelper.ApplyStatusEffect(target, effectID, duration)` — with duration (Blackwall)
4. `Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, effectID)` — entity ID based (Immersive Meditations)
5. `StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new(effectID), player)` — TweakDBID wrapper

## Hotkeys (Settings > Key Bindings > SETester2)

| Hotkey | Action |
|--------|--------|
| SE2_APPLY | Apply selected effect (10s duration) |
| SE2_APPLY_PERM | Apply selected effect (permanent) |
| SE2_CYCLE | Cycle to next effect |
| SE2_CYCLE_BACK | Cycle to previous effect |
| SE2_REMOVE | Remove selected effect from target |
| SE2_LIST | List all effects with TweakDB validation |
| SE2_CHECK | Check which effects are active on target |
| SE2_REMOVE_ALL | Remove all tracked effects from target |
| SE2_DUMP | Dump ALL BaseStatusEffect TweakDB records |
| SE2_DUMP_QH | Dump quickhack-related BaseStatusEffect records |
| SE2_TARGET_INFO | Show detailed target debug info |

## Recommended Testing Order

1. **SE2_TARGET_INFO** — Look at an NPC, press this to verify target detection is fixed
2. **SE2_DUMP_QH** — Dump all quickhack-related status effect IDs to find the real ones
3. **SE2_LIST** — Check which catalog IDs are VALID vs MISSING in TweakDB
4. **SE2_APPLY** — Try applying confirmed effects (Overheat, Blind, Stun, BlackwallHackUpload)
5. **SE2_CHECK** — Verify the effect is actually active on the target

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester2/
```
