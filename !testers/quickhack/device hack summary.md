# Device Hack Summary

> Comprehensive synthesis of all device hacking research and testing in the Cyberpunk 2077 CET modding project.
> Goal: activate device hack effects **independent of the player and the player's cyberware** — for companion drones/orbs that can quickhack.

---

## Table of Contents

1. [Project Goal & Context](#1-project-goal--context)
2. [Testers Used to Build This Doc](#2-testers-used-to-build-this-doc)
3. [What Has Been Tested](#3-what-has-been-tested)
4. [What Works](#4-what-works)
5. [What Does Not Work](#5-what-does-not-work)
6. [The Core Difficulty: Why Most Things Fail](#6-the-core-difficulty-why-most-things-fail)
7. [The Game Engine Validation Question](#7-the-game-engine-validation-question)
8. [The TweakDB Entry Question](#8-the-tweakdb-entry-question)
9. [What Is Missing / Still Needs Testing](#9-what-is-missing--still-needs-testing)
10. [Recommended Next Steps](#10-recommended-next-steps)
11. [Key APIs & TweakDB Records Reference](#11-key-apis--tweakdb-records-reference)

---

## 1. Project Goal & Context

The intended mod features **companion drones (follower orbs)** that can perform quickhack-like effects on devices and NPCs in the world. Key constraints:

- **No player cyberware dependency** — hacks should not require the player to have a cyberdeck equipped
- **No RAM cost** — orbs have their own resource pool, not the player's Memory stat
- **No XP gain** — these are utility effects, not player progression
- **No quickhack UI / scan mode** — triggered programmatically, not through the scanner menu
- **No trace/threat detection** — stealthy utility effects

The fundamental challenge: **hacks work when done from the player through the normal game pipeline, but almost nothing works when triggered programmatically from CET Lua outside that pipeline.** This document traces every approach tried, what failed, what succeeded, and what remains unexplored.

---

## 2. Testers Used to Build This Doc

The testers are organized in two phases. **Phase 1** (quickhack_tester series) tried the QuickHack action pipeline. **Phase 2** (statuseffect series) pivoted to direct status effect application, then split into NPC-specific and device-specific sub-series.

### Phase 1: QuickHack Action Chain

| Tester | Folder | Focus | Key Result |
|---|---|---|---|
| quickhack_tester (v1) | `quickhack_tester/` | First attempt at device quickhacks via action objects | StartAction/CompleteAction failed; hardcoded hack list didn't match device's actual hacks |
| quickhack_tester2 (v2) | `quickhack_tester2/` | Fixed cycling to use device's actual hacks; SetCanSkipPayCost | Action discovery broken (out-array convention returns empty in CET); never got to test execution |
| quickhack_tester3 (v3) | `quickhack_tester3/` | Fixed discovery (return-value convention); 4-convention fallback | StartAction always fails; ProcessRPGAction reports OK but zero visible effect on devices |
| quickhack_tester4 (v4) | `quickhack_tester4/` | xpcall error capture; PS handler bypass; DeviceSystem direct; SetObjectActionID | "error in error handling" on SetRequesterID, IsPossible, ResolveAction, StartAction; only RemoteBreach pulls up empty hack screen |

### Phase 2: Status Effect Direct Application

| Tester | Folder | Focus | Key Result |
|---|---|---|---|
| statuseffect_tester1 | `statuseffect_tester1/` | First attempt at StatusEffectHelper.ApplyStatusEffect bypass | Broken target detection + fake effect IDs (QH_ prefix); no visible effect |
| statuseffect_tester2 | `statuseffect_tester2/` | Fixed target detection + real effect IDs; TweakDB dump (1172 all / 223 quickhack) | All 5 API methods return SUCCESS; ObjectHasStatusEffect always false; 6 effects tested on NPCs |
| statuseffect_tester3 | `statuseffect_tester3/` | Random weighted; 41 NPC + 5 device effects; full coverage | NPC: visual/audio only, no damage (except Blackwall = instant kill); Device: nothing visible |

### Phase 2a: NPC Split

| Tester | Folder | Focus | Key Result |
|---|---|---|---|
| statuseffect_npc_tester1 | `statuseffect_npc_tester1/` | 5 damage methods (qh_attack, base_se, blackwall, hit_event, statpool) | base_se no damage; ping worked; blackwall instant kill; HitEvent/StatPool had CET API issues |

### Phase 2b: Device Split

| Tester | Folder | Focus | Key Result |
|---|---|---|---|
| statuseffect_device_tester1 | `statuseffect_device_tester1/` | Dynamic GetQuickHackActions per device; 3-strategy chain | 100% API success, zero visible effect — confirmed QuickHack action chain is a dead end for devices |
| statuseffect_device_tester2 | `statuseffect_device_tester2/` | Two new paths: QuestForce actions + Direct StatusEffect | QuestForceDetonate on ExplosiveDevice = **CONFIRMED WORKING** (explosion); everything else no visible effect |
| statuseffect_device_tester3 | `statuseffect_device_tester3/` | Isolated QuestForce execution methods (Full Chain vs Direct PS) | Direct PS = 0% success (dead end); Full Chain = 100% API success but only ForceDetonate visible; triple-confirmed |

### Top-Level Reference Docs

| Doc | Path | Content |
|---|---|---|
| TESTER INTENT.md | `testers/quickhack/TESTER INTENT.md` | Original goal: companion drones doing quickhacks, no XP/trace/RAM |
| THOUGHTS.md | `testers/quickhack/THOUGHTS.md` | Future ideas: custom quickhacks for orbs, AI modifier hacks, point-based effects |
| QUICKHACK_PREREQUISITES_ANALYSIS.md | `testers/quickhack/QUICKHACK_PREREQUISITES_ANALYSIS.md` | Deep analysis of why action objects fail; normal pipeline requirements; community mod approaches |

### Source Mods Referenced

| Mod | Path | Key Pattern |
|---|---|---|
| Blackwall | `sources - extra/cyberware - quickhack/blackwall-*/` | StatusEffectHelper.ApplyStatusEffect + StatPoolsSystem direct kill |
| Charm | `sources - extra/cyberware - quickhack/charm */` | TweakDB action registration + Observe for effects; REDscript shows SetUp() pipeline |
| Black Chrome | `sources - extra/cyberware - quickhack/Black Chrome-*/` | Cyberdeck equipment checks, aux cyberdeck |
| Zeusico Quickhacks | `sources - extra/cyberware - quickhack/Zeusico Quickhacks */` | Pure TweakDB quickhack definitions (no Lua) |
| Neuralware | `sources - extra/cyberware - quickhack/Neuralware-*/` | Status effect application patterns |
| Teleport | `sources - extra/cyberware - quickhack/Teleport */` | 0-Engine pure Lua quickhack registration |

### okf Knowledge Base Referenced

| Doc | Path | Content |
|---|---|---|
| Device Core Framework | `okf/adamsmasher/cyberpunk/devices/core.md` | 524 declarations: all QuestForce action classes, DeviceOperations, EffectExecutor classes, PS handlers |
| Explosive Device | `okf/adamsmasher/cyberpunk/devices/explosive.md` | Explosive device specific classes and handlers |

---

## 3. What Has Been Tested

### 3.1 QuickHack Action Chain (Phase 1 — All Failed)

Tested across quickhack_tester through quickhack_tester4. This is the approach of getting action objects from the device's PS and trying to execute them.

**Discovery (works):**
- `ps:GetQuickHackActions(context)` with return-value convention successfully discovers device-specific quickhack actions
- Actions found on various devices: RemoteBreach, Ping, MalfunctionClassHack, OverloadClassHack, HighPitchNoiseQuickHack, GlitchScreenSuicide/Blind/Grenade, QuickHackExplodeExplosive, QuickHackDistraction, QuickHackToggleON
- Action metadata extraction works: GetActionName(), GetClassName(), GetObjectActionRecord():GetID(), HackCategory():Type()

**Execution (all failed):**

| Method | Result | Details |
|---|---|---|
| `action:StartAction(game)` | Always fails | "error in error handling" (v4 xpcall) |
| `action:ProcessRPGAction(game)` | API OK, no effect | Returns success but device doesn't respond |
| `action:CompleteAction(game)` | Fails | Never reached in v3 (ProcessRPGAction hits first) |
| `action:IsPossible(game)` | Fails | "error in error handling" |
| `action:CanInterrupt()` | Fails | "error in error handling" |
| `action:IsVisible()` | Fails | "error in error handling" |
| `action:ResolveAction(game)` | Fails | "error in error handling" |
| `action:SetRequesterID(id)` | Fails | "error in error handling" |
| `action:SetObjectActionID(recID)` | Succeeds | But doesn't fix execution |
| `action:SetCanSkipPayCost(true)` | Succeeds | But StartAction still fails |
| `action:SetExecutor(player)` | Succeeds | But StartAction still fails |

**Direct PS handler bypass (failed):**
- `ps:OnQuickHackDistraction(action)` — fails
- `ps:QueuePSDeviceEvent(action)` — fails
- Handler mapping incomplete: only QuickHackDistraction, QuickHackAuthorization, QuickHackToggleON, GlitchScreen* mapped; RemoteBreach, PingDevice, QuickHackExplodeExplosive have no mapping

**DeviceSystem direct (failed):**
- `Game.GetDeviceSystem():GetDeviceById(game, entityID)` — "error in error handling"
- `device:ExecuteAction(action)` — never reached (GetDeviceById fails)
- `device:ProcessAction(action)` — never reached

**Devices tested with QuickHack chain:** VendingMachine, TV, Radio, Speaker, ExplosiveDevice, Reflector

### 3.2 Direct Status Effect on Devices (Phase 2 — Failed)

Tested across statuseffect_tester1-3 and statuseffect_device_tester2.

**Approach:** Apply `BaseStatusEffect.*` or `Attacks.QuickHack.*` records directly to device entities via `StatusEffectHelper.ApplyStatusEffect()`.

**Device status effects tested (5 static list from tester3):**

| Effect ID | API Result | Visible Effect |
|---|---|---|
| `BaseStatusEffect.DistractionDuration` | SUCCESS | None |
| `BaseStatusEffect.EMP` | SUCCESS | None |
| `BaseStatusEffect.BaseEMP` | SUCCESS | None |
| `BaseStatusEffect.OverloadEMP` | SUCCESS | None |
| `BaseStatusEffect.BaseOverload` | SUCCESS | None |

**Additional status effects tested on devices (tester2, 15 candidates):**
QuickHackDistraction, QuickHackExplodeExplosive, QuickHackBlind, QuickHackToggleOn, OverloadDevice, HighPitchNoise, EMP, BaseEMP, GlitchScreen, QuickHackOverload, QuickHackMotive, QuickHackCommitSuicide, QuickHackDisable, QuickHackPing, Ping_Cyberpsycho — **all API SUCCESS, zero visible effect**.

**API methods tried (5):**
1. `StatusEffectHelper.ApplyStatusEffect(target, recordID)` — SUCCESS, no effect
2. `StatusEffectHelper.ApplyStatusEffect(target, recordID, player)` — SUCCESS, no effect
3. `Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, recordID, player)` — SUCCESS, no effect
4. `StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new(recordID))` — SUCCESS, no effect
5. `gameEffect` construction + execute — not fully tested

**Devices tested with status effects:** VendingMachine, TV, CleaningMachine, Forklift, ActivatedDeviceTrapDestruction, ExplosiveDevice, Reflector, AccessPoint, BasicDistractionDevice, Radio, Speaker

### 3.3 QuestForce Actions (Phase 2b — Partially Working)

Tested across statuseffect_device_tester1-3. This is the breakthrough path.

**Approach:** Use `GetQuestActions()` with `requestType=Quest` (not Remote) to discover quest-level actions, then execute via the Full Action Chain.

**QuestForce actions discovered and tested:**

| Action Class | Device | API Result | Visible Effect |
|---|---|---|---|
| **QuestForceDetonate** | ExplosiveDevice | SUCCESS | **YES — immediate explosion** (triple-confirmed) |
| QuestEnableInteraction | TV | SUCCESS | None observed |
| QuestDisableInteraction | TV | SUCCESS | None observed |
| QuestMuteSounds | TV | SUCCESS | None observed |
| QuestNextStation | TV | SUCCESS | None observed |
| QuestPreviousStation | TV | SUCCESS | None observed |
| QuestDefaultStation | TV | SUCCESS | None observed |
| QuestEnableInteractivity | TV | SUCCESS | None observed |
| QuestDisableInteractivity | TV | SUCCESS | None observed |

**QuestForce execution methods compared:**

| Method | Success Rate | Visible Effect |
|---|---|---|
| Full Chain (SetupAction -> IsPossible -> ResolveAction -> StartAction -> ProcessRPGAction) | 100% API | Only ForceDetonate visible |
| Direct PS (ps:OnQuestForceXxx()) | 0% — "no PS handler" | None |

**Key insight:** QuestForce actions bypass the scanner/breach prerequisite that blocks QuickHack actions. They are designed for quest scripts to force device states programmatically — exactly the companion orb use case. But most still produce no visible effect despite API success.

### 3.4 NPC Status Effects (Phase 2a — For Comparison)

While this doc focuses on devices, NPC findings provide important context.

**What works on NPCs:**
- `BaseStatusEffect.SoMi_Q306_BlackwallHackUpload` — instant kill (quest effect with built-in DealDamageModule)
- `BaseStatusEffect.CyberwareMalfunctionBlackwall` — instant kill
- `BaseStatusEffect.Madness` — NPC attacks allies (behavioral, works)
- `BaseStatusEffect.Ping` — reveal effect (behavioral, works)
- `BaseStatusEffect.LocomotionMalfunction` — halts NPC (behavioral, works)
- `BaseStatusEffect.Stun` / `Blind` — behavioral effects work

**What doesn't work on NPCs (visual only, no damage):**
- `BaseStatusEffect.Overheat`, `Burning`, `ContagionPoison`, `EMP` — visual/audio only, no damage (base effects lack DealDamageModule)
- `Attacks.QuickHack.*` — some records missing from TweakDB

**Key NPC insight:** Base status effects contain only visual/audio/behavioral modules. Damage requires `DealDamageModule`, which only exists in quickhack-specific variants or quest effects (Blackwall). Behavioral effects (Stun, Blind, Madness) work because they use StatModifierModule, not DealDamageModule.

---

## 4. What Works

### Confirmed Working (Device Hacking)

| What | Method | Evidence | Limitations |
|---|---|---|---|
| **Explode ExplosiveDevices** (fuel bottles/canisters) | QuestForceDetonate via Full Chain | Triple-confirmed across device_tester2 (random + controlled) and device_tester3 (isolated path) | Only works on ExplosiveDevice class; not tested on other destructible devices |
| **RemoteBreach screen** (pulls up hack minigame UI) | QuickHack action chain ProcessRPGAction | Tester4, device_tester1 | Empty list, no objectives/rewards; not useful for companion drones — should be blacklisted |
| **Action discovery** | `ps:GetQuickHackActions(context)` return-value convention | All testers from v1 onward | Returns descriptors, not executable instances |
| **Quest action discovery** | `ps:GetQuestActions(context)` with requestType=Quest | device_tester2-3 | Returns quest-level actions that bypass scanner/breach |

### Confirmed Working (NPC Hacking — for reference)

| What | Method | Notes |
|---|---|---|
| Instant kill | `StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload", player)` | Quest effect with DealDamageModule |
| Madness (attack allies) | `StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.Madness", player)` | Behavioral, no damage module needed |
| Ping (reveal) | `StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.Ping", player)` | Behavioral |
| Locomotion halt | `StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.LocomotionMalfunction", player)` | Behavioral |
| Stun / Blind | `StatusEffectHelper.ApplyStatusEffect(target, effectID, player)` | Behavioral |

---

## 5. What Does Not Work

### Completely Failed (API errors)

| Approach | Error | Testers |
|---|---|---|
| QuickHack `StartAction(game)` | "error in error handling" | v3, v4 |
| QuickHack `SetRequesterID(id)` | "error in error handling" | v4 |
| QuickHack `IsPossible(game)` | "error in error handling" | v4 |
| QuickHack `ResolveAction(game)` | "error in error handling" | v4 |
| QuickHack `CanInterrupt()` / `IsVisible()` | "error in error handling" | v4 |
| `DeviceSystem:GetDeviceById(game, entityID)` | "error in error handling" | v4, device_tester1 |
| Direct PS handler `ps:OnQuestForceXxx()` | "no PS handler" | device_tester3 |
| Direct PS handler `ps:OnQuickHackXxx()` | Fails | v1, v4, device_tester1 |

### API Success But No Visible Effect (Silent Failure)

| Approach | Testers | Devices Tested |
|---|---|---|
| QuickHack `ProcessRPGAction(game)` | v3, v4, device_tester1 | VendingMachine, TV, Radio, Speaker, ExplosiveDevice, Reflector |
| Direct StatusEffect on devices (all 20+ effect IDs) | tester3, device_tester2 | VendingMachine, TV, CleaningMachine, Forklift, Trap, ExplosiveDevice, Reflector, AccessPoint, Radio, Speaker |
| QuestForce TV actions (EnableInteraction, DisableInteraction, MuteSounds, NextStation, etc.) | device_tester2-3 | TV only |

### Known Broken Approaches

| Issue | Root Cause |
|---|---|
| Out-array calling convention | CET Lua returns arrays as return values, not via out-parameters (v2 bug) |
| Fake effect IDs (QH_ prefix) | `BaseStatusEffect.QH_Overheat_Lvl1` etc. don't exist in TweakDB (tester1 bug) |
| `BaseStatusEffect.Contagion` / `ShortCircuit` / `RebootOptics` / `Distraction` | Don't exist in TweakDB; correct IDs are ContagionPoison, EMP/BaseEMP, QuickHackBlind, DistractionDuration |
| Static device effect list | Wrong approach — each device type has different available hacks; must query dynamically |
| BaseStatusEffect for device interaction | Wrong record type — devices need device action records, not NPC status effects |

---

## 6. The Core Difficulty: Why Most Things Fail

This is the central question: **why do hacks work from the player but fail when triggered programmatically?**

### Root Cause 1: Action Objects Are Read-Only Descriptors

The action objects returned by `ps:GetQuickHackActions(context)` are **descriptors/templates**, not fully instantiated executable action instances. The "error in error handling" message from CET means the methods exist on the class but the internal state needed for them to function is missing.

The normal game pipeline creates actions differently — via `puppetAction = this.GetAction(record)` followed by `puppetAction.SetUp(this)`. This `SetUp()` call initializes the action's internal state, connects it to the PS, and prepares it for execution. The CET testers never call `SetUp()` because:
1. It may not be exposed to CET's Lua bindings
2. It may require a `ScriptableDeviceComponentPS` reference that CET can't properly provide
3. The action objects from `GetQuickHackActions` may be a different class than what `GetAction` returns

Evidence: v4's log shows `GetActivationTime: 0` and `GetCost: 0` for some actions that should have non-zero values (MalfunctionClassHack should have cost 3, activation 0.5), while the same action's `GetBaseCost: 3` is correct. This inconsistency indicates the objects return TweakDB metadata but lack runtime state.

### Root Cause 2: Device Internal State Machine Requires Full Pipeline Context

The device's game-logic state machine expects actions to come through the full native pipeline:

```
Player in Scan Mode
  -> Targeting system selects device
  -> HUDQuickhackMenuController opens
  -> QuickhackSystem validates prerequisites
  -> Action properly instantiated with SetUp()
  -> Upload pipeline (activation time, progress bar)
  -> PayCost deducts RAM
  -> Device event applied
  -> XP awarded, cooldown started
```

When CET calls `ProcessRPGAction` directly, the action reaches the device's PS but the device's internal logic **silently rejects or ignores it** because the full pipeline context is missing. The API returns SUCCESS (no Lua error thrown) but the RED4 internal logic short-circuits.

This explains why `ProcessRPGAction` always returns OK but nothing happens — the RPG cost pipeline runs but the device event that causes the actual visual/effect change never fires.

### Root Cause 3: Status Effects Are the Wrong Mechanism for Devices

`BaseStatusEffect.*` records are designed for **puppets (NPCs and the player)**, not devices. They contain:
- VisualEffectModule — burning animation, glitch effects
- AudioEffectModule — sound cues
- StatModifierModule — stat changes
- DealDamageModule (only in quickhack variants)

Devices don't have health pools, cyberware, or AI behavioral systems in the same way NPCs do. Applying an NPC status effect to a device entity is like applying a skin cream to a rock — the API accepts it (the entity is a valid target) but there's nothing for the effect modules to act on.

Device hacks work through a **completely different mechanism**: device action records trigger device operations (toggle, glitch, detonate, etc.) through the device's PS handlers, not through the status effect system.

### Root Cause 4: QuestForce Partially Bypasses the Pipeline

QuestForce actions are designed for **quest scripts** to force device states without scanner/breach context. This is why `QuestForceDetonate` works — it goes through a different code path that doesn't require the full quickhack pipeline.

However, most QuestForce actions (TV interactions, station changes, mute) still produce no visible effect despite API success. This suggests that either:
- These actions require additional device state that isn't set up (e.g., the TV must already be powered on for station changes to matter)
- The visible effect is subtle and wasn't noticed during testing
- These actions modify internal device state but don't trigger visual feedback on their own
- The device's state machine has secondary validations even on the quest path

### Root Cause 5: CET Lua Binding Limitations

Some methods fail with "error in error handling" — a CET-level error indicating the method call causes an internal crash. This is likely because:
- The method expects native C++ types that CET's Lua bindings can't properly marshal
- The action object isn't in a valid state for the method (missing SetUp initialization)
- The method requires callback objects or game state that CET can't provide

Methods that consistently fail: `SetRequesterID`, `IsPossible`, `CanInterrupt`, `IsVisible`, `ResolveAction`, `StartAction`, `GetDeviceById`

Methods that work: `SetObjectActionID`, `SetCanSkipPayCost`, `SetExecutor`, `GetActionName`, `GetClassName`, `GetCost`, `GetBaseCost`, `GetActivationTime`, `ProcessRPGAction`

---

## 7. The Game Engine Validation Question

**Yes, the game engine is doing validations.** The quickhack system is a multi-layered pipeline with prerequisites at each stage.

### Player-Side Validations (for normal quickhacks)

| Validation | Where Checked | Bypassed by CET? |
|---|---|---|
| Cyberdeck equipped (SystemReplacementCW slot) | `Device:IsCyberdeckEquippedOnPlayer()`, `EquipmentSystem:IsCyberdeckEquipped()` | Yes — CET doesn't go through this path |
| Quickhack programs installed | `RPGManager.GetPlayerQuickHackListWithQuality()` | Yes — CET doesn't check installed programs |
| RAM available | `PayCost()` / Memory stat pool | Yes — `SetCanSkipPayCost(true)` bypasses |
| Scan mode active | `HUDQuickhackMenuController` | Yes — CET triggers outside scan mode |
| Perks | Quickhack perk tree | Yes — not checked by CET |

### Target-Side Validations

| Validation | Where Checked | Bypassed by CET? |
|---|---|---|
| Target quickhackable (TSF_Quickhackable filter) | Targeting system | N/A — CET uses its own targeting |
| Device has quickhack actions | `ps:GetQuickHackActions()` | Yes — CET queries directly |
| Device not already hacked/destroyed | Device state check | Partially — CET doesn't check |
| `IsQuickHacksExposed` returns true | Device PS | Unknown — may be checked internally |

### Device-Side Validations (the real blocker)

The device's **internal state machine** has its own validations that are NOT bypassed by CET:
- The device expects actions to come through the proper pipeline with full context
- `StartAction` on an uninitialized action object causes internal errors
- The device's PS handler (`OnQuickHackXxx`) may check action state that isn't set up
- Even `ProcessRPGAction` (which returns OK) may be silently rejected by the device's internal logic

**This is the key finding: the game engine's device-level validation is the primary blocker, not the player-level validation.** Bypassing cyberdeck/RAM/scan checks is easy; bypassing the device's internal state machine requirements is the unsolved problem.

---

## 8. The TweakDB Entry Question

**Yes, wrong TweakDB entries were used in early testers, but even with correct entries, the execution problem remains.**

### Record Type Mismatch (Early Testers)

| Tester | Wrong Record Type | Correct Record Type |
|---|---|---|
| statuseffect_tester1 | `BaseStatusEffect.QH_Overheat_Lvl1` (fake) | `BaseStatusEffect.Overheat` (real) |
| statuseffect_tester3 (devices) | `BaseStatusEffect.DistractionDuration` (NPC effect) | Device action records via `GetQuickHackActions` |
| statuseffect_tester3 (devices) | `BaseStatusEffect.EMP` (NPC effect) | Device-specific action records |

### The Real Issue: Correct Records Still Don't Execute

even when correct TweakDB records are used:
- `ps:GetQuickHackActions()` returns the **correct device-specific actions** (MalfunctionClassHack, OverloadClassHack, etc.) — but `StartAction` fails on them
- `StatusEffectHelper.ApplyStatusEffect` with **real, validated TweakDB records** (confirmed to exist) — returns SUCCESS but no visible effect on devices
- The problem is not the TweakDB entry; it's the **execution mechanism**

### TweakDB Record Types in the Device System

From okf `devices/core.md`, the device system has these action record types:

| Action Category | Record Types | Purpose |
|---|---|---|
| QuickHack actions | QuickHackDistraction, QuickHackToggleON, QuickHackToggleOpen, QuickHackCallElevator, QuickHackExplodeExplosive, QuickHackDistractExplosive, QuickHackAuthorization, GlitchScreen, etc. | Player-initiated hacks through scanner UI |
| QuestForce actions | QuestForceON, QuestForceOFF, QuestForcePower, QuestForceUnpower, QuestForceDetonate, QuestForceActivate, QuestForceDeactivate, QuestForceEnabled, QuestForceDisabled, QuestStartGlitch, QuestStopGlitch, QuestForceSecuritySystem*, etc. | Quest script-initiated state changes |
| Device operations | PlayEffectDeviceOperation, ApplyDamageDeviceOperation, StimDeviceOperation, ApplyStatusEffectDeviceOperation, etc. | Device's native effect pipeline |
| Effect executors | EffectExecutor_VisualEffectAtTarget, EMP, EMPExplosion, EffectExecutor_SetDeviceON/OFF, EffectExecutor_ToggleDevice, etc. | Native effect system for point-based effects |

**The testers primarily used QuickHack actions (wrong for programmatic use) and BaseStatusEffect records (wrong for devices). QuestForce actions are the correct category for programmatic device control, and DeviceOperations/EffectExecutors are unexplored alternatives.**

---

## 9. What Is Missing / Still Needs Testing

### High Priority — Most Likely to Produce Results

| # | What | Why | How |
|---|---|---|---|
| 1 | **QuestForce actions on more device types** | Only 3 device types tested (TV, ExplosiveDevice, VendingMachine=0 actions). Turrets, lights, doors, cameras, security systems, access points, strap-held boxes may have useful QuestForce actions | Target each device type, query GetQuestActions(), execute via Full Chain, observe |
| 2 | **DeviceOperations pipeline** | Device's native effect pipeline — PlayEffectDeviceOperation, ApplyDamageDeviceOperation, StimDeviceOperation. These are the device's own effect execution system, triggered internally by various triggers. Never tested from CET. | Research API access to DeviceOperationsComponent from CET; try triggering operations directly |
| 3 | **EffectExecutor_Scripted classes** | EffectExecutor_VisualEffectAtTarget, EMP, EMPExplosion — native effect system for point-based effects at arbitrary positions. Perfect for companion orb point-based effects (healing bubbles, explosions, sparks). Never tested from CET. | Research gameEffect construction API with specific EffectExecutor; construct and execute |
| 4 | **QuickhackSystem API** | `Game.GetQuickhackSystem():GetAvailableQuickhacksForTarget(target)` and `ExecuteQuickhack(target)` — may trigger the full native pipeline correctly. Never tested. | Call QuickhackSystem methods directly; may require player context |
| 5 | **QuestForce action visibility investigation** | TV QuestForce actions (station changes, mute, interaction toggle) returned API success but no visible effect. Need to determine if effects are subtle, require device preconditions, or need additional state changes | Test with TV already powered on; check device state before/after; observe more carefully |

### Medium Priority — Alternative Approaches

| # | What | Why | How |
|---|---|---|---|
| 6 | **REDscript SetUp() approach** | The missing initialization step. Charm mod's REDscript shows `puppetAction.SetUp(this)` before execution. CET can't call this, but REDscript can. | Write a REDscript mod that properly instantiates and executes device actions |
| 7 | **QuestForce on strap-held boxes** | User specifically wants "break chains" effect on crate stacks. QuestForceDestructible or QuestForceDetonate may work on these | Target strap-held box entities, query quest actions, execute |
| 8 | **QuestForce on turrets and lights** | User wants overload effects (turret explosion, light blinding). QuestForceUnpower/QuestForceDestructible may produce visible effects | Target turrets and light sources, query quest actions, execute |
| 9 | **Manual AI stims at device position** | Trigger AI stims at device position for distraction effect — proven CET API, different paradigm (world-level effect, not device interaction) | Use stim system to create distraction at device coordinates |
| 10 | **DamageSystem ProcessHitEvent on devices** | Direct damage to devices — may trigger destruction effects. HitEvent had issues in CET for NPCs but devices may behave differently | Construct HitEvent targeting device, process via DamageSystem |

### Low Priority — Unlikely but Worth Noting

| # | What | Why | How |
|---|---|---|---|
| 11 | **Scanner UI hijack** | Add TweakDB QuickhackData records so custom hack appears in scanner list; player triggers normally; mod observes result. Full integration but requires player interaction. | TweakDB modification + Observe pattern (Charm mod approach) |
| 12 | **0-Engine pure Lua quickhack registration** | Teleport mod uses 0-Engine framework for pure Lua quickhacks. May provide alternative execution path. | Research 0-Engine API; register custom quickhack |
| 13 | **QuestForceSecuritySystem actions** | Force security system states (Safe/Alarmed/Armed) — may produce visible alarm effects | Target security system devices, execute QuestForceSecuritySystem* actions |
| 14 | **QuestForceCameraZoom** | Force camera zoom — may produce visible effect on camera devices | Target cameras, execute QuestForceCameraZoom |

### Things That Are Confirmed Dead Ends (Don't Retry)

| Approach | Why It's a Dead End |
|---|---|
| QuickHack action `StartAction(game)` | Always "error in error handling" — action objects lack internal state |
| QuickHack action `SetRequesterID` | Always "error in error handling" |
| QuickHack action `IsPossible/CanInterrupt/IsVisible` | Always "error in error handling" |
| `DeviceSystem:GetDeviceById()` | Always "error in error handling" |
| Direct PS handler calls (`ps:OnQuestForceXxx()`) | 0% success — "no PS handler" universally |
| Direct PS handler calls (`ps:OnQuickHackXxx()`) | Fails — wrong invocation context |
| `BaseStatusEffect.*` applied to device entities | API success, zero visible effect — wrong mechanism for devices |
| Out-array calling convention (`ps:GetQuickHackActions(arr, ctx)`) | CET Lua returns arrays as return values, not out-params |
| RemoteBreach action | Pulls up empty hack screen — not useful for companion drones |

---

## 10. Recommended Next Steps

### Immediate Actions (Next Tester)

1. **Create device_tester4 focused on QuestForce actions across many device types**
   - Target: turrets, flood lights, doors, cameras, security systems, access points, strap-held boxes, elevators, intercoms, arcade machines
   - For each: query `GetQuestActions()`, execute each via Full Chain, carefully observe and document visible effects
   - Blacklist RemoteBreach (pulls up empty hack screen, not useful)
   - Key QuestForce actions to prioritize: QuestForceDestructible, QuestForceUnpower, QuestForceON/OFF, QuestForceActivate/Deactivate, QuestStartGlitch, QuestForceSecuritySystem*

2. **Investigate DeviceOperations pipeline access from CET**
   - Research `DeviceOperationsComponent` API in okf
   - Try accessing device operations container and triggering operations directly
   - Key operations: PlayEffectDeviceOperation, ApplyDamageDeviceOperation, StimDeviceOperation

3. **Test EffectExecutor_Scripted classes**
   - Research `gameEffect` construction API
   - Try EffectExecutor_VisualEffectAtTarget for point-based visual effects
   - Try EMP/EMPExplosion for area effects at arbitrary positions

### Medium-Term Actions

4. **Consider REDscript for the core execution layer**
   - CET Lua can't call `SetUp()` on action objects — this is the missing initialization step
   - A small REDscript mod could expose a function that properly instantiates and executes device actions
   - CET Lua would call the REDscript-exposed function, which does: `GetAction(record)` -> `SetUp(ps)` -> `StartAction(game)`

5. **Test QuickhackSystem API**
   - `Game.GetQuickhackSystem():GetAvailableQuickhacksForTarget(target)` — may return correct hack list
   - `Game.GetQuickhackSystem():ExecuteQuickhack(target)` — may trigger full pipeline
   - May require player context (cyberdeck), but worth testing

### Design Considerations for Companion Orb Mod

Based on THOUGHTS.md, the user envisions:
- Stumble player, healing bubbles, time distortion, spark explosions at arbitrary points
- AI modifiers: body shield, bump hostiles, vehicle collision, ladder jumps
- These are **not traditional device hacks** — they're world-level effects at arbitrary positions

For these, the most promising paths are:
- **EffectExecutor_VisualEffectAtTarget** — visual effects at arbitrary points
- **ApplyDamageDeviceOperation** — damage at points
- **StimDeviceOperation** — AI stims at points
- **Direct StatusEffectHelper on NPCs** — already proven for behavioral effects
- **StatPoolsSystem** — direct health manipulations for healing/damage
- **Custom TweakDB records** — define new status effects with custom stat modifier packages

---

## 11. Key APIs & TweakDB Records Reference

### CET APIs That Work

| API | Purpose | Notes |
|---|---|---|
| `Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)` | Target devices/NPCs | Use TSF_Quickhackable filter |
| `entity:GetDevicePS()` | Get device persistent state | Works on all devices |
| `ps:GetQuickHackActions(context)` | Discover quickhack actions | **Return-value convention only** (not out-array) |
| `ps:GetQuestActions(context)` | Discover quest actions | Use requestType=Quest; bypasses scanner/breach |
| `action:GetActionName()` / `GetClassName()` | Action metadata | Works on descriptor objects |
| `action:GetObjectActionRecord():GetID()` | TweakDB record ID | Works on descriptor objects |
| `action:SetObjectActionID(recID)` | Set TweakDB reference | Works but doesn't fix execution |
| `action:SetCanSkipPayCost(true)` | Skip RAM cost | Works but StartAction still fails |
| `action:SetExecutor(player)` | Set instigator | Works but StartAction still fails |
| `action:ProcessRPGAction(game)` | RPG pipeline execution | Returns OK but no visible effect on devices |
| `StatusEffectHelper.ApplyStatusEffect(target, id, player)` | Apply status effect | Works on NPCs; **fails on devices** |
| `Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, id, player)` | Alternative status effect API | Same results as helper |
| `TweakDB:GetRecord(id)` | Validate TweakDB record exists | Use to check effect IDs before applying |

### CET APIs That Fail

| API | Error |
|---|---|
| `action:StartAction(game)` | "error in error handling" |
| `action:SetRequesterID(id)` | "error in error handling" |
| `action:IsPossible(game)` | "error in error handling" |
| `action:ResolveAction(game)` | "error in error handling" |
| `Game.GetDeviceSystem():GetDeviceById(game, entityID)` | "error in error handling" |
| `ps:OnQuickHackXxx(action)` | Fails — wrong invocation context |
| `ps:OnQuestForceXxx(action)` | "no PS handler" |

### Context Setup for Action Discovery

```lua
local context = NewObject('gameGetActionsContext')
context.requestorID = player:GetEntityID()
context.requestType = gamedataRequestType.Remote  -- for QuickHack actions
-- context.requestType = gamedataRequestType.Quest   -- for QuestForce actions
context.ignoresRPG = true
context.ignoresAuthorization = true
context.processInitiatorObject = player
```

### QuestForce Action Classes (from okf core.md)

| Action Class | Base Class | Likely Effect |
|---|---|---|
| QuestForceDetonate | ActionBool | **CONFIRMED: explodes ExplosiveDevice** |
| QuestForceDestructible | ActionBool | Make device destructible |
| QuestForceIndestructible | ActionBool | Make device indestructible |
| QuestForceInvulnerable | ActionBool | Make device invulnerable |
| QuestForceEnabled | ActionBool | Enable device |
| QuestForceDisabled | ActionBool | Disable device |
| QuestForcePower | ActionBool | Power on device |
| QuestForceUnpower | ActionBool | Power off device |
| QuestForceON | ActionBool | Force device on |
| QuestForceOFF | ActionBool | Force device off |
| QuestForceActivate | ActionBool | Activate device |
| QuestForceDeactivate | ActionBool | Deactivate device |
| QuestForceAuthorizationEnabled | ActionBool | Enable authorization |
| QuestForceAuthorizationDisabled | ActionBool | Disable authorization |
| QuestForceSecuritySystemSafe | ActionBool | Set security to safe |
| QuestForceSecuritySystemAlarmed | ActionBool | Trigger alarm |
| QuestForceSecuritySystemArmed | ActionBool | Arm security |
| QuestStartGlitch | ActionBool | Start glitch effect |
| QuestStopGlitch | ActionBool | Stop glitch effect |
| QuestEnableInteraction | ActionBool | Enable interaction |
| QuestDisableInteraction | ActionBool | Disable interaction |
| QuestForceCameraZoom | ActionBool | Camera zoom |
| QuestForceTintGlass | ActionBool | Tint glass |
| QuestForceClearGlass | ActionBool | Clear glass |
| QuestForceRoadBlockadeActivate | ActionBool | Activate road blockade |
| QuestForceRoadBlockadeDeactivate | ActionBool | Deactivate road blockade |
| QuestEnableFixing | ActionBool | Enable fixing |
| QuestDisableFixing | ActionBool | Disable fixing |
| QuestForceJuryrigTrapArmed | ActionBool | Arm juryrig trap |
| QuestForceJuryrigTrapDeactivated | ActionBool | Deactivate juryrig trap |
| QuestForceDisconnectPersonalLink | ActionBool | Disconnect personal link |
| QuestResetDeviceToInitialState | ActionBool | Reset device to initial state |

### DeviceOperations Classes (from okf core.md — untested)

| Operation Class | Purpose |
|---|---|
| PlayEffectDeviceOperation | Play visual effect on device |
| ApplyDamageDeviceOperation | Apply damage via device operation |
| StimDeviceOperation | Trigger AI stim via device |
| ApplyStatusEffectDeviceOperation | Apply status effect via device |
| PlaySoundDeviceOperation | Play sound via device |
| ItemsDeviceOperation | Spawn items via device |
| TeleportDeviceOperation | Teleport via device |
| MeshAppearanceDeviceOperation | Change mesh appearance |
| PlayTransformAnimationDeviceOperation | Play transform animation |
| FactsDeviceOperation | Set quest facts |
| ToggleComponentsDeviceOperation | Toggle components |
| PlayBinkDeviceOperation | Play bink video |

### EffectExecutor_Scripted Classes (from okf core.md — untested)

| Executor Class | Purpose |
|---|---|
| EffectExecutor_VisualEffectAtTarget | Visual effect at arbitrary position |
| EMP | EMP effect |
| EMPExplosion | EMP explosion effect |
| EffectExecutor_SetDeviceON | Turn device on |
| EffectExecutor_SetDeviceOFF | Turn device off |
| EffectExecutor_ToggleDevice | Toggle device state |
| EffectExecutor_PingNetwork | Ping network effect |
| EffectExecutor_MuteBubble | Mute bubble effect |
| EffectExecutor_SendActionSignal | Send action signal |
| EffectExecutor_TrackTargets | Track targets |
| EffectExecutor_GrenadeTargetTracker | Grenade target tracking |
| RemotelyConnectToAccessPoint | Connect to access point remotely |
| ApplyJammer / ApplyJammerFromCw | Apply jammer effect |
| EffectExecutor_PuppetForceVisionAppearance | Force vision appearance |

### Corrected Status Effect IDs (from TweakDB dump)

| Original (MISSING) | Corrected ID (VALID) |
|---|---|
| `BaseStatusEffect.Contagion` | `BaseStatusEffect.ContagionPoison` |
| `BaseStatusEffect.ShortCircuit` | `BaseStatusEffect.EMP` / `BaseStatusEffect.BaseEMP` |
| `BaseStatusEffect.RebootOptics` | `BaseStatusEffect.QuickHackBlind` |
| `BaseStatusEffect.Distraction` | `BaseStatusEffect.DistractionDuration` |

### Full Execution Chain for QuestForce (Confirmed Working Pattern)

```lua
-- 1. Get device PS
local ps = target:GetDevicePS()

-- 2. Create quest context
local context = NewObject('gameGetActionsContext')
context.requestorID = player:GetEntityID()
context.requestType = gamedataRequestType.Quest
context.ignoresRPG = true
context.processInitiatorObject = player

-- 3. Discover quest actions
local actions = ps:GetQuestActions(context)  -- return-value convention

-- 4. Find desired action (e.g., QuestForceDetonate)
for _, action in ipairs(actions) do
    if action:GetClassName() == 'QuestForceDetonate' then
        -- 5. Execute via Full Chain
        action:SetExecutor(player)
        action:SetObjectActionID(action:GetObjectActionRecord():GetID())
        local ok1 = action:SetupAction()  -- may not exist in CET; may be automatic
        local ok2 = action:IsPossible()    -- may fail in CET
        local ok3 = action:ResolveAction()
        local ok4 = action:StartAction(game)
        -- Fallback: ProcessRPGAction (this is what actually returns SUCCESS)
        local ok5 = pcall(function() action:ProcessRPGAction(game) end)
        break
    end
end
```

> **Note:** The exact method chain that produces results may vary. In device_tester2-3, the Full Chain was executed with fallbacks, and `ProcessRPGAction` was the method that returned SUCCESS. The critical difference from the QuickHack path is using `requestType=Quest` instead of `Remote`.

---

*Document generated from analysis of 11 testers, 3 top-level docs, 6 source mods, and okf device core documentation. Last updated: 2026-08-02.*
