---
type: Mechanic Pattern
title: Dark Future Framework Integration
description: Modifying DarkFuture-prefixed TweakDB records for integration with the Dark Future mod framework.
tags: [systems dark-future framework tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# Dark Future Framework Integration

Modifying DarkFuture-prefixed TweakDB records for integration with the Dark Future mod framework.

## Approach

Mods modify `DarkFutureStatusEffect.*` and `DarkFutureProps.*` TweakDB records to integrate with the Dark Future framework. This framework provides extended survival and immersion mechanics, and mods modify its TweakDB records to add custom effects or props compatible with the framework.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/tweaks/Consumable Animations/ConsumableAnimations.ConsumableAnimData.yaml` | DarkFuture framework records |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/tweaks/Dark Future/DarkFuture.BaseGameUpdate_AlcoholData.yaml` | DarkFuture framework records |
| Perkware 2.0 29611 2.1.3 2026-07-15T23-18Z UQrhQStni | `r6/tweaks/PerkwarePatches/Dark Future/zzzDarkFuturePatch.yaml` | DarkFuture framework records |

## Related Concepts

- [TweakDB Status Effect Records](/systems/tweakdb-status-effects.md) — Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.
- [Healing System Tweaks](/player/healing-system-tweaks.md) — Modifying ImmersiveHealing.* TweakDB records to alter healing item behavior.
