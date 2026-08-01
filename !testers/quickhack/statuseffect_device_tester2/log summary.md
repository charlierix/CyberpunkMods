# Log Summary — Status Effect Device Tester 2 (SEDevT2)

**Source files:** `log.txt`, `TEST RESULTS.md`
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

| Time | Event |
| --- | --- |
| 18:58:07 | SEDevT2 initialized; two paths explained; hotkeys bound |
| 19:04:14 | Info window turned ON; newly discovered quest actions logged (EnableInteraction, DisableInteraction, Station changes) |
| 19:54:24–19:55:05 | **VendingMachine** targeted — no quest actions found; falls back to Direct StatusEffects (Suicide, Base EMP, Overload Device, Glitch Screen, etc.). All log as API success, but **no visible in-game effect**. User notes status window too wide |
| 19:58:32–19:58:42 | Testing resumes on devices — Distraction, EMP, Toggle ON applied. All log as API success |
| 20:03:06–20:03:17 | **Radio** targeted — both QuestForce (QuestNextStation, DisableInteraction) and StatusEffects (Glitch Screen, Ping Cyberpsycho) applied. All API success |
| 20:07:48–20:07:49 | **Explosive container** (6.53m) targeted — `QuestForceDetonate` applied. API success — **user visually confirms it blew up** ✅ |
| 20:08:18–20:08:31 | Info window turned OFF; final statistics compiled |

---

## 3. Final Statistics & Verdict

### API Statistics

| Path | Attempts | API Successes | Rate |
| --- | --- | --- | --- |
| QuestForce | 10 | 10 | 100% |
| StatusEffect | 35 | 35 | 100% |
| **Total** | **45** | **45** | **100%** |

### Verdict: **Mixed**

| Perspective | Result |
| --- | --- |
| API / Execution | ✅ **Complete success** — 100% API success across both paths |
| Practical / In-Game | ❌ **Mostly failure** — no visible effect from device hacks except the last test |

**The one confirmed visual success:** `QuestForceDetonate` on an explosive container — it blew up.

---

## 4. Errors & Functional Failures

No code exceptions or stack traces were logged. However, these functional failures and issues were noted:

| Type | Details |
| --- | --- |
| No visible effect | "I saw no visible effect for any of the device hacks that I tried, except one: the very last one I tried on an explosive container did successfully blow it up" |
| UI issue | "the status window got really wide like the first tester. so next tester needs to cap the width, because it covers half my screen" |
| Fallback message | "No quest actions for ToCName{ hash_lo = 0x2BAACE8B, hash_hi = 0x58875946 --[[ VendingMachine --]] } -- falling back to StatusEffect" (repeated multiple times) |

---

## 5. Effects & Actions Tested

### StatusEffects / Quickhacks

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
- **ForceDetonate** ✅ (only confirmed visual success)

---

## 6. Improvements / Next Steps

| Finding | Action for Next Tester |
| --- | --- |
| Status window too wide (same as tester1) | **Cap the width** to prevent covering half the screen |
| Most effects show no visible result despite API success | Investigate why API-confirmed effects don't manifest visually; focus on actions like `ForceDetonate` that do work |
| `ForceDetonate` confirmed working | Prioritize quest-force detonate-style actions for explosive/destructible devices |

---

## 7. Summary

SEDevT2 confirmed that both QuestForce and Direct StatusEffect APIs execute without error (100% API success), but almost none produce visible in-game results on devices. The sole exception is `QuestForceDetonate` on explosive containers, which worked. The recurring UI width issue needs fixing in the next iteration.
