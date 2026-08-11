# Log Summary — Status Effect Device Tester 2 (SEDevT2)

**Source files:** `log.txt`, `log2.txt`, `TEST RESULTS.md`
**Tester folder:** `testers/quickhack/statuseffect_device_tester2/`

---

## 1. Goal / Intent

SEDevT2 explored **two unexplored paths** for interacting with devices:

| Path | Method | Description |
| --- | --- | --- |
| **Path 1** | QuestForce Actions | Uses `GetQuestActions` with `requestType=Quest` to force quest-level actions on devices |
| **Path 2** | Direct StatusEffect | Uses `StatusEffectHelper` to apply status effects directly to device entities |

**Workflow:** When the player looks at a device and presses the **APPLY** hotkey, the tester:
1. Randomly picks a path (QuestForce or Direct StatusEffect)
2. Randomly picks an effect or action within that path
3. Randomly picks an execution method

The intent was to discover what actually affects devices in-game.

---

## 2. Key Events (Chronological)

### First Test Session (`log.txt`)

| Time | Event |
| --- | --- |
| 18:58:07 | SEDevT2 initialized; two paths explained; hotkeys bound |
| 19:04:14 | Info window turned ON; newly discovered quest actions logged (EnableInteraction, DisableInteraction, Station changes) |
| 19:54:24–19:55:05 | **VendingMachine** targeted — no quest actions found; falls back to Direct StatusEffects (Suicide, Base EMP, Overload Device, Glitch Screen, etc.). All log as API success, but **no visible in-game effect**. User notes status window too wide |
| 19:58:32–19:58:42 | Testing resumes on devices — Distraction, EMP, Toggle ON applied. All log as API success |
| 20:03:06–20:03:17 | **Radio** targeted — both QuestForce (QuestNextStation, DisableInteraction) and StatusEffects (Glitch Screen, Ping Cyberpsycho) applied. All API success |
| 20:07:48–20:07:49 | **Explosive container** (6.53m) targeted — `QuestForceDetonate` applied. API success — **user visually confirms it blew up** ✅. Attribution uncertain due to random tester and multiple actions in flight |
| 20:08:18–20:08:31 | Info window turned OFF; final statistics compiled |

### Confirmation Test (`log2.txt`)

| Time | Event |
| --- | --- |
| 06:38:43 | SEDevT2 re-initialized |
| 06:40:17 | Info window ON; discovers `ForceDetonate` quest action (class: `QuestForceDetonate`) for new device |
| 06:40:21 | **ExplosiveDevice** (5.01m) detected — only **1 quest action available**: `ForceDetonate` (`QuestForceDetonate`) |
| 06:40:21 | APPLY pressed — Path 1 (QuestForce) selected — **only action fired**: `QuestForceDetonate` via QA:FullChain → `SUCCESS: ProcessRPGAction OK` |
| 06:40:21 | **User confirms: fuel bottle immediately exploded** ✅ |
| 06:40:55 | Info window OFF |
| 07:07:43 | Final Statistics: QuestForce 1 attempt, 1 success; StatusEffect 0 attempts |

---

## 3. Final Statistics & Verdict

### API Statistics (First Session — `log.txt`)

| Path | Attempts | API Successes | Rate |
| --- | --- | --- | --- |
| QuestForce | 10 | 10 | 100% |
| StatusEffect | 35 | 35 | 100% |
| **Total** | **45** | **45** | **100%** |

### API Statistics (Confirmation Session — `log2.txt`)

| Path | Attempts | API Successes | Rate |
| --- | --- | --- | --- |
| QuestForce | 1 | 1 | 100% |
| StatusEffect | 0 | 0 | — |

### Verdict: **Mixed → Partially Confirmed**

| Perspective | Result |
| --- | --- |
| API / Execution | ✅ **Complete success** — 100% API success across all sessions |
| Practical / In-Game | ❌ **Mostly failure** — no visible effect from device hacks except `QuestForceDetonate` |
| `QuestForceDetonate` on ExplosiveDevice | ✅ **CONFIRMED** — two independent tests, second was controlled (single action, immediate explosion) |

---

## 4. Errors & Functional Failures

No code exceptions or stack traces were logged. However, these functional failures and issues were noted:

| Type | Details |
| --- | --- |
| No visible effect (first session) | "I saw no visible effect for any of the device hacks that I tried, except one: the very last one I tried on an explosive container did successfully blow it up" |
| UI issue | "the status window got really wide like the first tester. so next tester needs to cap the width, because it covers half my screen" |
| Fallback message | "No quest actions for ToCName{ hash_lo = 0x2BAACE8B, hash_hi = 0x58875946 --[[ VendingMachine --]] } -- falling back to StatusEffect" (repeated multiple times) |

---

## 5. Effects & Actions Tested

### StatusEffects / Quickhacks (first session only)

- QuickHack Overload
- QuickHack Suicide
- QuickHack Blind
- QuickHack Motive
- Base EMP / EMP
- QuickHack Distraction
- Overload Device
- QuickHack Ping
- Glitch Screen
- QuickHack Explode Explosive
- QuickHack Disable
- High Pitch Noise
- QuickHack Toggle ON
- Ping Cyberpsycho

### QuestForce Actions

- EnableInteraction / DisableInteraction
- QuestNextStation / QuestPreviousStation / QuestDefaultStation
- QuestMuteSounds / QuestUnMuteSounds
- QuestEnableInteractivity / QuestDisableInteractivity
- **ForceDetonate** ✅ (CONFIRMED — causes fuel bottle / ExplosiveDevice explosion)

---

## 5a. Exact Action That Caused the Fuel Bottle Explosion

### ✅ CONFIRMED: `QuestForceDetonate`

**`QuestForceDetonate`** — a **QuestForce action** (Path 1) — is the action that causes fuel bottles (ExplosiveDevice) to explode.

This was confirmed across **two independent tests**:

1. **First test** (`log.txt`, 20:07:48–49): `QuestForceDetonate` applied to an explosive container at 6.53m. API returned `SUCCESS`. User observed explosion. Attribution was initially uncertain due to the random tester having multiple actions in flight.
2. **Confirmation test** (`log2.txt`, 06:40:21): Controlled single-action test on an ExplosiveDevice at 5.01m. Only one quest action available (`ForceDetonate`). Only one action fired — no ambiguity. User confirmed **immediate explosion**. API returned `SUCCESS: ProcessRPGAction OK [QA:FullChain]`.

### First Test — Log Chain (`log.txt` lines 315–322)

| Log Line | Timestamp | Detail |
| --- | --- | --- |
| 315 | 20:07:48 | `[APPLY]` hotkey pressed. Target: `ToCName{ hash_lo = 0x7A7E9E9F, hash_hi = 0x5728B988 }` |
| 316 | 20:07:48 | Selected **Path 1 (QuestForce)** |
| 317 | 20:07:48 | Strategy: **QA FullChain** |
| 318 | 20:07:48 | Selected action: **`QuestForceDetonate`** |
| 319 | 20:07:48 | `SetupAction OK` |
| 320 | 20:07:48 | `IsPossible: true` |
| 321 | 20:07:48 | `ResolveAction OK` → `StartAction OK` → **API success** |
| 322 | 20:07:49 | `[RESULT] Result of QuestForceDetonate action: 1 = SUCCESS` |

### Confirmation Test — Log Chain (`log2.txt` lines 14–28)

| Log Line | Timestamp | Detail |
| --- | --- | --- |
| 14 | 06:40:17 | `[NEW QUEST ACTION]` discovered: `ForceDetonate` (class: `QuestForceDetonate`) |
| 18 | 06:40:21 | Device class: **`ExplosiveDevice`** |
| 21 | 06:40:21 | Distance: **5.01 m** |
| 22–23 | 06:40:21 | Available quest actions: **1** — only `ForceDetonate` (`QuestForceDetonate`) |
| 26 | 06:40:21 | `=== APPLY QUEST [1/1]: ForceDetonate -> QuestForceDetonate ===` |
| 27 | 06:40:21 | `Result: SUCCESS: ProcessRPGAction OK [QA:FullChain]` |
| 28 | 06:40:21 | QuestForce coverage: 1/1 tried (100%) |

### Execution Path & Strategy (Confirmed)

| Attribute | Value |
| --- | --- |
| **Path** | Path 1 — QuestForce |
| **Action class** | `QuestForceDetonate` |
| **Action record** | `ForceDetonate` |
| **Strategy** | QA:FullChain (SetupAction → IsPossible → ResolveAction → StartAction) |
| **Device class** | `ExplosiveDevice` (fuel bottle) |
| **API result** | `SUCCESS: ProcessRPGAction OK` |
| **Visible result** | ✅ Immediate explosion (user-confirmed, controlled test) |

### Resolution of Prior Uncertainty

The first test left attribution uncertain because the random tester had multiple actions in flight and there was a slight delay. The confirmation test (`log2.txt`) **eliminated all ambiguity**: only one action was available and fired, and the user confirmed an immediate explosion. `QuestForceDetonate` is definitively the cause.

---

## 6. Improvements / Next Steps

| Finding | Action for Next Tester |
| --- | --- |
| Status window too wide (same as tester1) | **Cap the width** to prevent covering half the screen |
| Most StatusEffects show no visible result despite API success | Investigate why API-confirmed effects don't manifest visually; focus on QuestForce actions like `ForceDetonate` that do work |
| `QuestForceDetonate` confirmed working on ExplosiveDevice | Prioritize quest-force detonate-style actions for explosive/destructible devices |
| `QuickHack.ExplodeExplosive` never produced visible results | May not work on devices via StatusEffectHelper; `QuestForceDetonate` is the correct approach |

---

## 7. Summary

SEDevT2 confirmed that both QuestForce and Direct StatusEffect APIs execute without error (100% API success), but almost none produce visible in-game results on devices — with one critical exception: **`QuestForceDetonate`** on **ExplosiveDevice** (fuel bottles). This was confirmed across two independent tests: the first (random, multiple actions in flight) showed an explosion with uncertain attribution, and a follow-up controlled test (single action, single available quest action) confirmed that `QuestForceDetonate` via the `QA:FullChain` strategy causes an **immediate explosion**. The recurring UI width issue needs fixing in the next iteration.
