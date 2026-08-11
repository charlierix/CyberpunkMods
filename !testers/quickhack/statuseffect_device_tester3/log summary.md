# Log Summary — Status Effect Device Tester 3 (SEDevT3)

**Source file:** `log.txt`
**Tester folder:** `testers/quickhack/statuseffect_device_tester3/`

---

## 1. Goal / Intent

SEDevT3 tested **device-only QuestForce actions** using **two execution methods** to determine which approach actually produces visible in-game effects:

| Method | Hotkey | Execution Chain |
| --- | --- | --- |
| **Full Chain (QA)** | F9 | `SetupAction -> IsPossible -> ResolveAction -> StartAction -> ProcessRPGAction` |
| **Direct PS (QB)** | F10 | Calls `ps:OnQuestForceXxx()` handler directly on the device PS |

Based on tester2 findings:
- QuestForce actions WORK (`QuestForceDetonate` confirmed on `ExplosiveDevice` in tester2)
- Direct StatusEffect on devices FAILS (dropped from this tester entirely)
- This tester isolates the two QuestForce execution methods against each other

A **per-hotkey latch system** allowed quick A/B testing of the same action through both paths: pressing one hotkey would reuse the other's last action if it hadn't been tried via this method yet.

---

## 2. Key Events (Chronological)

### Reload Phase (08:40:42 – 09:27:02)

The mod was initialized/reloaded **6 times** before productive testing began. The user noted they "weren't in a good spot to test" with "quite a few reloads."

| Time | Event |
| --- | --- |
| 08:40:42 | SEDevT3 initialized — dual execution methods explained, per-hotkey latch system described, hotkeys bound |
| 09:09:34 | Mod reloaded; info window toggled ON; `VendingMachine` encountered — **0 available quest actions** |
| 09:11:44 | Mod reloaded again |
| 09:12:29 | Mod reloaded again |
| 09:13:02 | Mod reloaded; another `VendingMachine` targeted — still 0 quest actions |
| 09:25:56 | Mod reloaded; info window turned ON |
| 09:27:02 | Mod reloaded; info window ON |

### Testing Phase (09:26:02 – 09:29:02)

| Time | Device | Event |
| --- | --- | --- |
| 09:26:02 | **TV** | `NEW DEVICE TYPE REPORT` — 9 available quest actions discovered (EnableInteraction, DisableInteraction, QuestMuteSounds, QuestNextStation, QuestPreviousStation, QuestDefaultStation, QuestEnableInteractivity, QuestDisableInteractivity) |
| 09:26:02 – 09:27:28 | TV | Actions executed via both methods. **QA Full Chain** repeatedly returned `SUCCESS: ProcessRPGAction OK`. **QB Direct PS** repeatedly returned `FAIL: no PS handler` |
| 09:28:37 | **ExplosiveDevice** | `NEW DEVICE TYPE REPORT` — 1 available quest action: `ForceDetonate` (`QuestForceDetonate`) |
| 09:28:37 – 09:29:02 | ExplosiveDevice | `ForceDetonate` applied via Full Chain → `SUCCESS: ProcessRPGAction OK`. Direct PS → `FAIL: no PS handler`. Log notes `API success != visible effect -- check game` |

---

## 3. Final Statistics & Verdict

### API Statistics

| Method | Attempts | API Successes | API Failures | Rate |
| --- | --- | --- | --- | --- |
| **QA Full Chain** | 7 | 7 | 0 | 100% |
| **QB Direct PS** | 7 | 0 | 7 | 0% |
| **Total** | **14** | **7** | **7** | **50%** |

Finding	Result
Direct PS method (QB)	❌ Dead end — 0% success, every action returned FAIL: no PS handler
Full Chain method (QA)	✅ 100% API success, but almost no visible in-game effects
QuestForceDetonate on ExplosiveDevice	✅ Triple-confirmed — exploding fuel canisters observed (matches tester2)
VendingMachine	0 quest actions — untestable via QuestForce
TV (9 actions)	All API-successful, zero visible effects
UI width fix	✅ Worked — fixed 150px width resolved the screen-covering issue

### Verdict: **Mixed → Direct PS Path Eliminated; Full Chain Inconclusive Except ForceDetonate**

| Perspective | Result |
| --- | --- |
| Direct PS Handler (QB) | ❌ **Complete failure** — 0% success, universally "no PS handler" errors |
| Full Chain (QA) — API level | ✅ **Complete success** — 100% API success across all actions |
| Full Chain (QA) — visible in-game | ❌ **Mostly no visible effect** — user confirms only exploding fuel canisters produced a visible result |
| `QuestForceDetonate` on ExplosiveDevice | ✅ **CONFIRMED** — user observed exploding fuel canisters (re-confirms tester2 finding) |

---

## 4. Errors & Functional Failures

No code exceptions or stack traces were logged. All failures were functional:

| Type | Details |
| --- | --- |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestToggleInteractivity ... }` |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestForceDetonate ... }` |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestPreviousStation ... }` |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestMuteSounds ... }` |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestDisableInteraction ... }` |
| Direct PS — no handler | `FAIL: no PS handler for ToCName{ ... QuestEnableInteraction ... }` |
| API success != visible effect | `=== API success != visible effect -- check game ===` — mod's own warning that API-level success doesn't guarantee in-game results |
| No quest actions on VendingMachine | `No quest actions for this device` — VendingMachine had 0 available QuestForce actions |

---

## 5. Actions Tested

### QuestForce Actions

| Action | Device | QA Full Chain | QB Direct PS | Visible Effect |
| --- | --- | --- | --- | --- |
| `EnableInteraction` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| `DisableInteraction` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| `QuestMuteSounds` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| `QuestNextStation` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| `QuestPreviousStation` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| `QuestDefaultStation` | TV | ✅ SUCCESS | ❌ FAIL (no PS handler) | None observed |
| **`ForceDetonate`** | ExplosiveDevice | ✅ SUCCESS | ❌ FAIL (no PS handler) | ✅ **Exploding fuel canisters** |

### Devices Encountered

| Device | Quest Actions Available | Notes |
| --- | --- | --- |
| VendingMachine | 0 | No QuestForce actions — could not test |
| TV | 9 | Full suite of interaction/station/mute actions — all API-successful, no visible effect |
| ExplosiveDevice | 1 (`ForceDetonate`) | Only action available — produced confirmed visible explosion |

---

## 5a. Confirmed Effect — Exploding Fuel Canisters

### ✅ CONFIRMED: `QuestForceDetonate` via Full Chain (QA)

**`QuestForceDetonate`** — a QuestForce action executed through the **Full Action Chain** (`SetupAction -> IsPossible -> ResolveAction -> StartAction -> ProcessRPGAction`) — is the action that causes fuel canisters (ExplosiveDevice) to explode.

| Attribute | Value |
| --- | --- |
| **Method** | QA Full Chain (F9) |
| **Action class** | `QuestForceDetonate` |
| **Action record** | `ForceDetonate` |
| **Device class** | `ExplosiveDevice` (fuel canister) |
| **API result** | `SUCCESS: ProcessRPGAction OK [QA:FullChain]` |
| **Visible result** | ✅ Exploding fuel canisters (user-confirmed) |

This **re-confirms the tester2 finding**: `QuestForceDetonate` via `QA:FullChain` causes ExplosiveDevice to explode. Tester2 first discovered this in a random test and confirmed it with a controlled single-action test. Tester3 confirms it again through the isolated Full Chain execution path.

---

## 6. Key Findings

| Finding | Significance |
| --- | --- |
| **Direct PS method is a dead end** | `ps:OnQuestForceXxx()` handlers do not exist on device PS objects. The Direct PS path universally fails with "no PS handler" — this execution method should be abandoned for devices |
| **Full Chain is the only viable QuestForce execution path** | 100% API success through the full action chain. This is the method that produced the confirmed explosion in both tester2 and tester3 |
| **API success ≠ visible effect (except ForceDetonate)** | TV interaction/station/mute actions all returned `ProcessRPGAction OK` but produced no visible in-game change. The mod's own warning `API success != visible effect -- check game` was accurate |
| **QuestForceDetonate is the standout action** | The only QuestForce action that consistently produces a visible in-game effect on devices. Confirmed across tester2 (two tests) and tester3 (this test) |
| **VendingMachine has no QuestForce actions** | `GetQuestActions()` with `requestType=Quest` returns 0 actions for VendingMachine — this device type cannot be targeted via QuestForce |
| **UI width fix worked** | Fixed width of 150 with `PushTextWrapPos` resolved the screen-covering issue from testers 1 and 2 |

---

## 7. Improvements / Next Steps

| Finding | Action for Next Tester |
| --- | --- |
| Direct PS method universally fails on devices | **Drop Direct PS entirely** — focus exclusively on Full Chain execution |
| Most QuestForce actions (TV interactions) show no visible effect despite API success | Test on a wider variety of device types to find actions that produce visible results beyond explosions |
| `QuestForceDetonate` confirmed working again | This is now the **only reliably working QuestForce action** — prioritize finding others that produce visible effects |
| VendingMachine has 0 quest actions | Don't target VendingMachine via QuestForce — it has no available actions |
| Only 3 device types tested | Test on turrets, light sources, security systems, strap-held boxes (break chains goal) to find more visible-effect actions |
| Testing was limited due to reloads and positioning | More controlled testing with better positioning and fewer reloads needed |

---

## 8. Summary

SEDevT3 set out to A/B test two QuestForce execution methods — **Full Action Chain (QA)** vs **Direct PS Handler (QB)** — on devices. The result was decisive:

- **Direct PS is a dead end.** Every single action across every device returned `FAIL: no PS handler`. Device PS objects simply don't implement `OnQuestForceXxx()` handlers. This path should be abandoned.

- **Full Chain succeeds at the API level but rarely produces visible effects.** All 7 QA attempts returned `SUCCESS: ProcessRPGAction OK`, but the user observed only one visible in-game effect: **exploding fuel canisters** when `QuestForceDetonate` was applied to an `ExplosiveDevice`.

- **`QuestForceDetonate` is now triple-confirmed** as the working action for exploding devices — confirmed once in tester2's random test, once in tester2's controlled confirmation test, and now again in tester3 via the isolated Full Chain path.

The tester also validated the UI width fix (fixed 150px width) that was flagged as an issue in testers 1 and 2. The remaining challenge is finding QuestForce actions beyond `ForceDetonate` that produce visible in-game effects on devices.
