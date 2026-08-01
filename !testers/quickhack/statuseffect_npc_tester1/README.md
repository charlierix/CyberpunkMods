Status Effect NPC Tester 1 - CET (Lua)
====================================

Multi-method NPC damage testing with live info window.

Based on findings from `statuseffect_tester3/research_npc_damage_system.md`: base status effects
(`BaseStatusEffect.*`) only trigger visual/audio/behavioral modules -- they do NOT deal damage.
Damage requires either quickhack attack records (`Attacks.QuickHack.*`) which contain
`DealDamageModule`, direct `HitEvent` via `DamageSystem`, or `StatPoolsSystem` health manipulation.

This tester separates from the device-hacking path (now covered by `quickhack_tester4`) and
focuses exclusively on NPCs, testing all 5 damage methods identified in the research doc.

## Damage Methods Tested

| # | Method | TweakDB/API | Expected |
|---|--------|-------------|----------|
| 1 | Quickhack attack records | `Attacks.QuickHack.*` | DOT or instant damage via DealDamageModule |
| 2 | Base status effects | `BaseStatusEffect.*` | Visual only (control group -- should NOT damage) |
| 3 | Blackwall quest effects | `BaseStatusEffect.SoMi_Q306_*` / `CyberwareMalfunctionBlackwall` | Instant kill (known reference) |
| 4 | Direct HitEvent | `HitEvent.new()` + `ProcessHitEvent()` | Direct damage via damage pipeline |
| 5 | StatPool kill | `RequestSettingMinValue("Health", 0)` + `SetCurrentState(Collapse)` | Instant kill |

## Effect Catalog (28 effects)

- **QH Attacks (5):** Overheat, Contagion, ShortCircuit, Suicide, CyberPsychosis
- **Base SE (11):** Overheat, Burning, ContagionPoison, EMP, Stun, Blind, Madness, Ping, LocomotionMalfunction, CyberwareMalfunction, NPCForceStagger
- **Blackwall (2):** SoMi_Q306_BlackwallHackUpload, CyberwareMalfunctionBlackwall
- **HitEvent (6):** Physical 100, Thermal 100, Chemical 100, EMP 100, Mixed 50each, Physical 500
- **StatPool (1):** Health 0 + Collapse

## Interface

Two hotkeys only -- same simplicity as tester3:

- **SE_NPC1_TOGGLE_WINDOW** -- Toggle Info Window
- **SE_NPC1_APPLY** -- Apply Random Effect

Bind in: Settings > Key Bindings > SENpcT1

## ImGui Window

- **Coverage indicator:** tried/untried count and percentage with text bar -- tells you when you have tested everything
- **Target info:** name, class, distance, record ID
- **Last result:** effect name, method, success/fail
- **Effect list:** all 28 effects with `*` mark for tried and attempt count in brackets

## Random Weighted Selection

Effects with fewer attempts get higher selection probability. Untested effects (0 attempts)
always have the highest weight. Formula: `maxAttempts + 1 - attempts`, clamped to minimum 1.

## Usage

1. Look at an NPC.
2. Press APPLY for a random weighted effect.
3. Observe the NPC -- write down what happens (visual? damage? death? nothing?).
4. Toggle window to check coverage stats -- keep going until all effects are tried.
5. Log analysis is done later -- the CET console log (`log.txt`) captures all apply events with
   effect name, method, target, and result.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_npc_tester1/
```

## HitEvent damageValues Array

The `damageValues` array maps to damage types in fixed order (1-indexed in Lua):

| Index | Damage Type | Examples |
|-------|-------------|----------|
| 1 | Physical | Bullets, melee |
| 2 | NonPhysical | ? |
| 3 | Thermal | Overheat, burning |
| 4 | Chemical | Contagion, poison |
| 5 | EMP | Short Circuit |

## Key APIs

- `StatusEffectHelper.ApplyStatusEffect(target, id, player)` -- apply status effect / quickhack attack
- `HitEvent.new()` + `Game.GetDamageSystem():ProcessHitEvent(hitEvent)` -- direct damage
- `Game.GetQuestSystem():GetQuestLogSystem():GetStatPoolsSystem():RequestSettingMinValue(id, "Health", 0.0)` -- instant kill
- `target:SetCurrentState(gamedataNPCEncounterState.Collapse)` -- NPC death state
- `Game.GetTargetingSystem():GetLookAtObject(player, false, false)` -- crosshair target acquisition
