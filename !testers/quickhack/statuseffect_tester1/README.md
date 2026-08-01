# Status Effect Tester 1

## Overview

Applies quickhack-style **status effects** directly to the target under your crosshair — bypassing the entire quickhack action pipeline.

This tester was created after `QUICKHACK_PREREQUISITES_ANALYSIS.md` showed that the quickhack action objects returned by `GetQuickHackActions()` are read-only descriptors that cannot be executed programmatically via CET. Instead, this tester uses `StatusEffectHelper.ApplyStatusEffect()` — the same approach used by the **Blackwall mod** to apply quickhack-like effects without going through the full pipeline.

**What this means:** You get the visual and gameplay effect of a quickhack (burning, EMP, blindness, etc.) without:
- RAM cost
- XP gain
- Quickhack UI / scan menu
- Trace/threat detection
- Breach protocol

## Installation

Copy the `statuseffect_tester1` folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester1/
```

Bind hotkeys in: **Settings > Key Bindings > SETester1**

## Hotkeys

| Hotkey | Label | Action |
|---|---|---|
| `SE1_APPLY` | Apply Selected Status Effect | Applies the currently selected effect (default 10s) |
| `SE1_APPLY_PERM` | Apply Selected Effect (Permanent) | Applies with duration=0 |
| `SE1_CYCLE` | Cycle Status Effect | Next effect |
| `SE1_CYCLE_BACK` | Cycle Status Effect (Back) | Previous effect |
| `SE1_REMOVE` | Remove Selected Status Effect | Removes current effect from target |
| `SE1_REMOVE_ALL` | Remove All Tracked Effects | Removes all tracked effects |
| `SE1_LIST` | List All Status Effects | Prints catalog to CET console |
| `SE1_CHECK` | Check Target Status Effects | Shows active effects on target |

## Available Effects (all Lvl1-3)

**NPC:** Overheat, Short Circuit, Cyberware Malfunction, Contagion, Ping, Reboot Optics, Madness

**Device:** Distraction

## How It Works

1. `StatusEffectHelper.ApplyStatusEffect(target, effectID, duration)` — primary (Blackwall mod pattern)
2. `Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, effectID, duration)` — fallback

Removal: `StatusEffectHelper.RemoveStatusEffect(target, effectID)`
Checking: `StatusEffectSystem.ObjectHasStatusEffect(target, effectID)`
