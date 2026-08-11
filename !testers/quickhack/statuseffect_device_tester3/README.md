# Status Effect Device Tester 3 (SEDevT3)

Device-only QuestForce tester with **dual execution methods** and a **per-hotkey latch system**.

## Focus

- **Distract** — screens flash, vending machines spit out food, etc.
- **Overload** — turrets explode, light sources go blinding, etc.
- **Break chains** — boxes held by straps (uses destructive actions on specific entities)

Based on tester2 findings:
- QuestForce actions WORK (`QuestForceDetonate` confirmed on `ExplosiveDevice`)
- Direct StatusEffect on devices FAILS (dropped from this tester)

## Hotkeys

| Hotkey ID | Label | Action |
| --- | --- | --- |
| `SE_DEV3_TOGGLE_WINDOW` | Toggle Info Window | Show/hide status window |
| `SE_DEV3_FULL_CHAIN` | Apply via Full Chain | Execute quest action via full action chain (QA) |
| `SE_DEV3_DIRECT_PS` | Apply via Direct PS | Execute quest action via direct PS handler (QB) |

Bind in: **Settings > Key Bindings > SEDevT3**

Suggested: F8 = toggle, F9 = full chain, F10 = direct PS

## Two Execution Methods

Both methods operate on the **same QuestForce action class**, discovered dynamically via `GetQuestActions()` with `requestType=Quest`.

| Method | Hotkey | What it does |
| --- | --- | --- |
| **Full Chain** (QA) | F9 | `SetupAction -> IsPossible -> ResolveAction -> StartAction -> ProcessRPGAction` |
| **Direct PS** (QB) | F10 | Calls `ps:OnQuestForceXxx()` handler directly on the device PS |

## Per-Hotkey Latch System

Each hotkey has its **own latch** storing the last action it executed. When you press a hotkey, it checks the **other** hotkey's latch first:

1. If the other's latched action hasn't been tried via this hotkey's method yet -> **reuse it**
2. If it has already been tried via both methods -> **pick a new random action**

### Example flow

```
F9:  pick random action A, execute via Full Chain, store A in F9 latch
F10: check F9 latch (A), F10 hasn't tried A -> reuse A via Direct PS, store A in F10 latch
F10: check F9 latch (A), F10 HAS tried A -> pick random B, execute via Direct PS, store B in F10 latch
F9:  check F10 latch (B), F9 hasn't tried B -> reuse B via Full Chain, store B in F9 latch
F9:  check F10 latch (B), F9 HAS tried B -> pick random C, execute via Full Chain, store C in F9 latch
F10: check F9 latch (C), F10 hasn't tried C -> reuse C via Direct PS, store C in F10 latch
```

This lets you quickly A/B test the same action through both execution paths.

## Action -> Goal Mapping

Each discovered action is tagged with a goal category:

| Goal | Likely QuestForce actions |
| --- | --- |
| `distract` | QuestStartGlitch, QuestForceON, QuestForceActivate, QuestForcePower, QuestEnableInteraction |
| `overload` | QuestForceDetonate, QuestForceUnpower, QuestForceDestructible, QuestForceOFF, QuestForceDeactivate |
| `breakchains` | QuestForceDetonate, QuestForceDestructible (on strap-held box entities) |
| `security` | QuestForceSecuritySystemSafe/Alarmed/Armed |
| `?` | Unknown actions (still tested, just untagged) |

## Window

Fixed width of **150** (no `AlwaysAutoResize`, uses `PushTextWrapPos` for text wrapping). Won't cover half your screen.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester3/
```

## Log Analysis

After testing, check `log.txt` for:
- `[NEW DEVICE TYPE REPORT]` — first encounter of each device type with available actions
- `[NEW ACTION]` — newly discovered quest action classes
- `[LATCH]` — when a latch reuses an action from the other hotkey
- `=== APPLY [FullChain/DirectPS] ===` — each execution attempt with result
- `Final Statistics` — summary on shutdown
