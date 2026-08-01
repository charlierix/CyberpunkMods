# Status Effect Tester 3

## What This Tests

Applies random quickhack-style status effects to whatever the player is looking at, with a live info window and weighted random selection that favors untested effects.

## What's New from Tester 2

| Feature | Tester 2 | Tester 3 |
|---------|----------|----------|
| Hack selection | Manual cycle hotkey | Random weighted (untested favored) |
| Info display | None (log only) | Live ImGui window with toggle |
| Hotkeys | 10 | **2** (toggle window, apply hack) |
| Entity reports | Manual CHECK hotkey | Auto on first encounter (no repeats) |
| Target type awareness | User had to match manually | Auto-selects NPC or device effect list |
| Effect IDs | Some MISSING in TweakDB | Corrected using dump data |
| Coverage tracking | None | Per-effect attempt counts + shutdown stats |

## Hotkeys (Settings > Key Bindings > SETester3)

| Hotkey | Action |
|--------|--------|
| SE3_TOGGLE_WINDOW | Toggle the info overlay window |
| SE3_APPLY | Apply a random weighted hack to crosshair target |

## Info Window

The ImGui window (toggled on/off) shows:

- **Target** — name, type (NPC/Device), class, distance, record ID
- **Last Hack** — effect name, success/fail result
- **Available Hacks** — list of applicable hacks with per-effect attempt counts
  - If more than 15 hacks exist, shows first 15 + "... +N more not shown"
- **Session total** — cumulative hack attempts this session

The window only scans when visible (performance saving when off).

## Random Weighted Selection

When the apply hotkey is pressed:

1. Detects target type (NPC or Device)
2. Picks the appropriate effect list
3. Weights each effect inversely by attempt count — untested effects (0 attempts) get highest weight
4. Applies the selected effect via `StatusEffectHelper.ApplyStatusEffect(target, effectID, player)`
5. Increments that effect's attempt counter (future picks favor others)

This means running around pressing apply repeatedly will naturally cover all effects without manual cycling.

## Auto-Report

On the first hack press against a new entity, a detailed report is logged:
- Entity name, class, record ID, entity hash
- NPC/Device classification
- Distance
- Full list of applicable hacks with TweakDB VALID/MISSING status

Reports are deduplicated by record ID (with entity hash as composite key). The same entity type won't generate repeat reports on subsequent hack presses.

> **Note on entity IDs**: The user observed entityID changes every frame in the entity scanner. This mod uses `recordID` as the primary uniqueness key (stable per entity type) with `entityID.hash` as a secondary composite key. The `recordID`-only fallback ensures deduplication works even if the hash is unstable.

## Corrected Effect IDs

Tester 2 discovered several IDs were MISSING from TweakDB. Tester 3 replaces them:

| Tester 2 (broken) | Tester 3 (corrected) |
|-------------------|---------------------|
| `BaseStatusEffect.Contagion` | `BaseStatusEffect.ContagionPoison` |
| `BaseStatusEffect.ShortCircuit` | `BaseStatusEffect.EMP` / `BaseStatusEffect.BaseEMP` |
| `BaseStatusEffect.RebootOptics` | `BaseStatusEffect.QuickHackBlind` |
| `BaseStatusEffect.Distraction` | `BaseStatusEffect.DistractionDuration` |

## Effect Catalogs

### NPC Effects (37 total)

Core: Overheat, Burning, Blind, Stun, Ping, Pain, NPCForceStagger, LocomotionMalfunction, CyberwareMalfunction, CW Malfunction Blackwall, Madness, BlackwallHackUpload

Corrected: Contagion Poison, Base Contagion Poison, EMP, Base EMP, QuickHack Blind, Base QuickHack Blind, Poisoned, Base BrainMelt, Base CommsNoise, Base Overheat

Leveled variants: Locomotion Lvl2-4, CW Malfunction Lvl1-4, Overheat Lvl1-4, Ping Lvl2-4

Blind variants: Moderate, Major, Minor, Legendary, Major QH Blind

### Device Effects (5 total)

Distraction Duration, EMP, Base EMP, Overload EMP, Base Overload

## Shutdown Statistics

On mod unload, final attempt counts are logged for all effects — useful for post-session coverage analysis.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester3/
```

Then bind the two hotkeys in in Settings > Key Bindings > SETester3.
