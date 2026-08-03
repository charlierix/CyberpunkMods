---
type: Mechanic Pattern
title: Phone UI Overrides
description: Wrapping phone-related UI controllers to modify phone interface behavior.
tags: [ui phone hud]
timestamp: 2026-08-03T00:00:00Z
---

# Phone UI Overrides

Wrapping phone-related UI controllers to modify phone interface behavior.

## Approach

Mods wrap `PhoneDialerLogicController` (18 wraps) and `NewHudPhoneGameController` (21 wraps) to modify phone UI behavior. This includes custom phone interface, modified call display, or additional phone features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Wraps `NewHudPhoneGameController.OnContactsActive` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/UI/DFHUDSystem.reds` | Wraps `NewHudPhoneGameController.OnPhoneCall` |
| Drug Dealer 27800 6.5.6 2026-06-26T12-36Z 5em9eoSzt | `r6/scripts/DrugDealer/Phone/Shanice.reds` | Wraps `NewHudPhoneGameController.OnInitialize` |
| Gen Texting-28275-V6-1774838745 | `r6/scripts/CustomContactsPhone/CustomContactsPhone.reds` | Wraps `NewHudPhoneGameController.OnInitialize` |
| Generative Texting Neural Edition-28512-1-0-1774731647 | `r6/scripts/GenerativeTexting/GenerativeTextingHooks.reds` | Wraps `PhoneDialerLogicController.OnAllElementsSpawned` |

*8 more mods use this pattern.*

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Fact System Manipulation](/systems/fact-system-manipulation.md) — Using GetFact and SetFact to read and modify game quest facts that control game state.
