# Log Summary — Status Effect Device Tester 4 (SEDevT4)

**Source file:** `log.txt`
**Tester folder:** `testers/quickhack/statuseffect_device_tester4/`

---

## 1. Goal / Intent

SEDevT4 investigated the **DeviceOperations pipeline** — a deeper access path into device internals than previous testers. Instead of applying status effects or quest-force actions (as in SEDevT2), this tester attempted to:

- Access **DeviceOperationsContainers** and **DeviceOperationsComponents**
- Enumerate individual operations on a device
- Execute strategies such as `ToggleOperation`, `Execute`, `ToggleOperationEvent` dispatch, `SetDelayIdOnOperation`, and `OperationExecutionData`

The intent was to find a lower-level API path to manipulate device behavior directly through their operation lists, rather than relying on quest actions or status effects.

---

## 2. Key Events (Chronological)

| Time | Event |
| --- | --- |
| 16:25:59 | SEDevT4 initialized; LuaVM initialization finished |
| 17:59:52 | Info window turned ON |
| 18:00:11 | Info window turned OFF |
| 18:06:32 | Info window turned ON again; **immediate strategy failures** begin — "All PS strategies failed", "All entity strategies failed", "No container — cannot enumerate operations" |
| 18:06:42–18:07:00 | Repeated failures — "No operations found for this device", "No operations to cycle" |
| 18:06:47 | Attempted to execute selected operation — **failed** (no operations available) |
| 18:06:59 | Attempted to cycle operations — **failed** ("No operations to cycle") |
| 18:07:00 | Further operation execution attempt — **failed** |
| 19:16:29–19:16:51 | Second burst of repeated failures — same pattern |
| 19:16:48 | Entity at **2.34 m** targeted; enumeration attempted but found no container or component; completed with **0 operations** |
| 19:16:32 | Operation execution attempt — **failed** |
| 20:00:28 | Final statistics compiled; tester shut down |

---

## 3. Final Statistics & Verdict

### API Statistics

| Method | Attempts | Successes | Failures |
| --- | --- | --- | --- |
| A1: `GetDeviceOperations()` | 3823 | 0 | 3823 |
| A2: `GetOperations()` | 3823 | 0 | 3823 |
| A3: `ps.operationsContainer` | 3823 | 0 | 3823 |
| A4: `ps.deviceOperations` | 3823 | 0 | 3823 |
| A5: `ps:GetComponentByName` | 3823 | 0 | 3823 |
| B1: `FindComponentByName` | 3823 | 0 | 3823 |
| B2: `FindComponentByClassName` | 3823 | 0 | 3823 |
| B3: `GetComponent` | 3823 | 0 | 3823 |
| B4: `DeviceComp:GetDeviceOperations` | 3823 | 0 | 3823 |
| B5: `FindComponentByClassName(CName)` | 3823 | 0 | 3823 |
| **Total** | **38230** | **0** | **38230** |

### Device Types Encountered

| Type | Count |
| --- | --- |
| Any device type | **0** |

### Verdict: **Complete Failure**

| Perspective | Result |
| --- | --- |
| API / Execution | ❌ **Complete failure** — 0 successes across 3823 attempts per method |
| Practical / In-Game | ❌ **No interaction** — no device operations were ever found or executed |
| Device discovery | ❌ **0 device types encountered** — the tester never successfully resolved a device to a container or component |

---

## 4. Errors & Functional Failures

No code exceptions or stack traces were logged. However, these functional failures were repeated throughout:

| Type | Verbatim Message |
| --- | --- |
| PS strategy failure | `[CONTAINER] All PS strategies failed` |
| Entity strategy failure | `[COMPONENT] All entity strategies failed` |
| No container | `[OPS] No container — cannot enumerate operations` |
| No operations | `No operations found for this device` |
| No operations to cycle | `No operations to cycle` |
| PS strategy failure (alt) | `FAIL all PS strategies` |
| Entity strategy failure (alt) | `FAIL all entity strategies` |

---

## 5. Actions Tested

No actions were successfully executed. The tester attempted operation execution and cycling but never got past the enumeration stage.

| Attempted Action | Timestamp | Result |
| --- | --- | --- |
| Execute selected operation | 18:06:47 | ❌ Failed — no operations available |
| Cycle operations | 18:06:59 | ❌ Failed — "No operations to cycle" |
| Execute selected operation | 18:07:00 | ❌ Failed |
| Execute selected operation | 19:16:32 | ❌ Failed |

### Strategies Attempted (none reached execution)

- `ToggleOperation`
- `Execute`
- `ToggleOperationEvent` dispatch
- `SetDelayIdOnOperation`
- `OperationExecutionData`

---

## 6. Key Findings

| Finding | Significance |
| --- | --- |
| All 10 API methods returned 0 results across 3823 attempts | The DeviceOperations pipeline is not accessible through any of the tested API paths in CET |
| Both PS (property-based) and entity (component-based) strategies failed | Neither the device's `DeviceOperationsComponent` nor its container could be resolved from the entity |
| 0 device types encountered | The tester never successfully identified a device as having operations, even when targeting entities at close range (2.34 m) |
| No visible in-game effects | Since no operations were found or executed, no in-game testing occurred |
| No reloads or restarts | The tester ran a single continuous session |

---

## 7. Improvements / Next Steps

| Finding | Action for Next Tester |
| --- | --- |
| DeviceOperations pipeline completely inaccessible via CET API | The `DeviceOperationsComponent` / `operationsContainer` path may not be exposed to Lua scripting; consider alternative approaches (e.g., Red4ext native hooks, or the quest-force path confirmed in SEDevT2) |
| All PS and entity strategies fail uniformly | Investigate whether `DeviceOperations` requires a different access pattern (e.g., casting, interface query, or `GameInstance`-level access) not covered by the 10 tested methods |
| Tester ran 3823 attempts with 0 results | Add early-exit logic: if no container/component found after N attempts on the same entity, skip to a different strategy rather than retrying the same failing path |
| No device types ever encountered | Verify the targeting/entity-resolution logic — the tester may not be correctly identifying devices as `Device` entities before attempting operation enumeration |
| Log notes: "API success != visible effect -- check game" | While accurate as a general principle, this tester never reached API success, so the check-game step is moot for SEDevT4 |

---

## 8. Summary

SEDevT4 was a **complete failure**. The tester attempted to access the DeviceOperations pipeline — a lower-level API path targeting `DeviceOperationsContainers`, `DeviceOperationsComponents`, and individual device operations — but all 10 tested API methods returned zero results across 3823 attempts each. Neither property-based (PS) nor entity/component-based strategies could resolve a device to an operations container or component. The tester never successfully identified any device type, never enumerated any operations, and never executed any actions. The log suggests that the DeviceOperations pipeline may not be accessible through the CET Lua API using the methods tested, and future testers should either explore alternative access patterns or return to the confirmed `QuestForceDetonate` path from SEDevT2 for device interaction.
