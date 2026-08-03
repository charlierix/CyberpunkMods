---
type: Mechanic Pattern
title: TweakDB Status Effect Records
description: Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.
tags: [systems tweakdb status-effects]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Status Effect Records

Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.

## Approach

Mods modify `BaseStatusEffect.*` and `StatusEffects.*` TweakDB records to add or alter status effects. This includes custom buff/debuff effects, modified duration, altered stat modifiers applied by effects, or new status effect types. Some mods use custom prefixes like `DarkFutureStatusEffect.*` for framework-specific effects.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 03. EX-1 Cybercriminal-28768-1-0-1775734058 | `r6/tweaks/EX1/EX1_Cybercriminal.yaml` | Modifies status effect TweakDB records |
| ActualCantoBlackwall 25849 1.0.0.1 2026-07-27T14-38Z VquAqYzfW | `r6/tweaks/ActualCantoBlackwall/ActualCantoBlackwall.yaml` | Modifies status effect TweakDB records |
| BFC900_Blackwall-11506-1-0-1702144119 | `r6/tweaks/BFC9000_Blackwall.yaml` | Modifies status effect TweakDB records |
| Better Living Buffs-23297-1-3-1755182944 | `r6/tweaks/BetterLiving/BaseStatusEffect.Blackmarket_CarryCapacityBooster_inline1.yaml` | Modifies status effect TweakDB records |
| Cyphire Sniper Cyberware-14345-1-0-1713879194 | `r6/tweaks/CyphireEyesCyberware/CyphireSniperEyesCyberwareTEMPLATES.yaml` | Modifies status effect TweakDB records |

*35 more mods use this pattern.*

## Related Concepts

- [Status Effect Interception](/player/status-effect-interception.md) — Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.
- [TweakDB Effector Modifications](/systems/tweakdb-effectors.md) — Modifying Effectors.* TweakDB records to alter game effectors that apply stat modifications.
- [Healing System Tweaks](/player/healing-system-tweaks.md) — Modifying ImmersiveHealing.* TweakDB records to alter healing item behavior.
