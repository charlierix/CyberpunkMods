# Player 5 — Log Summary

## Test Conditions

- **Date**: 2026-07-23 21:00:59–21:01:18 UTC-05:00
- **PID**: 28816
- **Position**: (-1994.1, -1944.6, 18.4 initial)
- **Target Z**: 68.4 (initialZ + 50 — reduced from +100 to avoid loading screen)
- **Re-teleport threshold**: z < 28.4 (initialZ + 10)
- **Rotation step**: 30° per keypress
- **Session**: 1 activate/deactivate cycle, ~19 seconds active
- **Approach**: `EnableTransformUpdates(false)` + `SetWorldTransform` every frame (Step 1 from player3 next steps)
- **Teleport**: Used only for initial lift and re-teleport when z < threshold (not every frame)

---

## 1. EnableTransformUpdates(false) — Succeeds but Changes Nothing

`EnableTransformUpdates(false)` was called successfully every time (`ok=true`):
- On activation (line 1)
- After every re-teleport (lines 10, 30, 50, 70, 147, 243, 339, 492, 538)

**Despite this, SetWorldTransform still does not set any orientation axis.** The locomotion system's override is deeper than the transform update system — confirming the same finding from Player 4a.

---

## 2. SetWorldTransform — Complete No-Op (Worse Than Player 1-3)

**SetWorldTransform returns SUCCESS every frame but changes absolutely nothing.** The BEFORE and AFTER orientations are always identical.

### Evidence — Representative Samples

| Line | Target (roll/pitch/yaw) | BEFORE | AFTER SetWorldTransform | Match |
|------|------------------------|--------|-------------------------|-------|
| 89-95 | 0/30/54.7 | 0/0/54.7 | 0/0/54.7 | roll=true pitch=**false** yaw=true |
| 108-114 | 0/60/54.7 | 0/0/54.7 | 0/0/54.7 | roll=true pitch=**false** yaw=true |
| 128-133 | 90/90/135 | 0/0/54.7 | 0/0/54.7 | roll=**false** pitch=**false** yaw=**false** |
| 166-172 | 90/60/144.7 | 0/0/135 | 0/0/135 | roll=**false** pitch=**false** yaw=**false** |
| 262-268 | 120/30/144.7 | 0/0/144.7 | 0/0/144.7 | roll=**false** pitch=**false** yaw=true |
| 319-325 | 129.8/12.5/171 | 0/0/144.7 | 0/0/144.7 | roll=**false** pitch=**false** yaw=**false** |
| 377-383 | 168.7/20.9/-158.9 | 0/0/171 | 0/0/171 | roll=**false** pitch=**false** yaw=**false** |
| 499-505 | -170.6/-30.1/176.3 | 0/0/-179 | 0/0/-179 | roll=**false** pitch=**false** yaw=**false** |

**Critical observation**: The AFTER value always equals the BEFORE value. SetWorldTransform does not modify even yaw — unlike Teleport, which at least sets yaw. This is a stricter no-op than previously observed in testers 1-3.

---

## 3. Yaw Changes Only Come From Teleport

The only time yaw changes in the log is when a Teleport occurs (initial lift or re-teleport when z drops below threshold). SetWorldTransform itself never changes yaw.

### Yaw change pattern

| Event | Before Teleport | After Teleport | Source |
|-------|---------------|----------------|--------|
| Initial teleport (line 2-3) | yaw=54.7 (from activate) | yaw=54.7 | Teleport set yaw from initial orientation |
| Re-teleport (line 9-10) | yaw=54.7 | yaw=54.7 | Teleport set yaw from quat (was 54.7) |
| Re-teleport (line 146-149) | yaw=54.7 | yaw=135.0 | Teleport set yaw=135 from quat (after rotations) |
| Re-teleport (line 242-247) | yaw=135.0 | yaw=144.7 | Teleport set yaw=144.7 from quat |
| Re-teleport (line 338-343) | yaw=144.7 | yaw=171.0 | Teleport set yaw=171.0 from quat |
| Re-teleport (line 491-496) | yaw=171.0 | yaw=-179.0 | Teleport set yaw=-179.0 from quat |
| Re-teleport (line 537-542) | yaw=-179.0 | yaw=176.3 | Teleport set yaw=176.3 from quat |

**Between teleports, SetWorldTransform is called every frame but never changes the yaw.** The yaw only updates when a Teleport fires.

---

## 4. Roll and Pitch — Never Set by Any Mechanism

Roll and pitch are always 0.0 in the AFTER readings, regardless of:
- Target values (30°, 60°, 90°, 120°, 150°, -161°, -175°, etc.)
- Whether SetWorldTransform or Teleport was the source
- Whether EnableTransformUpdates is disabled

This confirms the same finding from Player 4 and 4a: the locomotion system clamps roll=0 and pitch=0 at a level deeper than any CET API can reach.

---

## 5. Airborne Teleport Cycle

The player falls from z=68.4 to z~28.4 approximately every 3 seconds, triggering a re-teleport:

| Cycle | Time | Fall Duration | Notes |
|-------|------|-------------|-------|
| 1 | 21:00:59 | — | Initial teleport |
| 2 | 21:01:01 | ~2s | Re-teleport at z=28.3 |
| 3 | 21:01:04 | ~3s | Re-teleport at z=28.4 |
| 4 | 21:01:06 | ~2s | Re-teleport at z=28.4 |
| 5 | 21:01:08 | ~2s | Re-teleport at z=28.0 |
| 6 | 21:01:10 | ~2s | Re-teleport at z=28.1 |
| 7 | 21:01:13 | ~3s | Re-teleport at z=28.1 |
| 8 | 21:01:15 | ~2s | Re-teleport at z=28.3 |
| 9 | 21:01:17 | ~2s | Re-teleport at z=28.1 |

Position x,y stays locked at (-1994.1, -1944.6) throughout — the player falls straight down with no horizontal drift. This is expected since `EnableTransformUpdates(false)` freezes the locomotion-driven movement.

---

## 6. Deactivation — Clean

Line 557-559: Clean deactivation sequence.
- `EnableTransformUpdates(true)` — locomotion re-enabled successfully
- Camera settings restored (implicit — no errors logged)
- No final teleport to safe height was called (the deactivate function was updated by the user to include this, but the log was captured before that fix)

---

## Summary Table

| Axis | SetWorldTransform | Teleport | EnableTransformUpdates(false) |
|------|------------------|----------|-------------------------------|
| Roll | ❌ No-op | ❌ Clamped to 0 | Does not help |
| Pitch | ❌ No-op | ❌ Clamped to 0 | Does not help |
| Yaw | ❌ No-op | ✅ Sets yaw | Does not help |
| Position | ✅ Holds x,y | ✅ Sets position | Freezes locomotion movement |

---

## What This Means

**`EnableTransformUpdates(false)` + `SetWorldTransform` is a failure.** This was the #1 untested approach from Player 3's next steps, and it confirms that:

1. `SetWorldTransform` is an even stricter no-op than previously thought — it doesn't even set yaw (unlike Teleport, which at least gets yaw through)
2. `EnableTransformUpdates(false)` does not unlock SetWorldTransform for orientation — the locomotion override is in a different system
3. Being airborne doesn't help — the locomotion system clamps roll/pitch even when the player is high above the ground with no ground contact

### Comparison Across All Testers

| Method | Testers | Roll | Pitch | Yaw |
|--------|---------|------|-------|-----|
| SetWorldTransform | 1, 2, 3 | ❌ | ❌ | ❌ |
| SetWorldTransform + TransformUpdates OFF | 5 | ❌ | ❌ | ❌ |
| Teleport(EulerAngles) | 4, 4a | ❌ | ❌ | ✅ |
| Teleport + TransformUpdates OFF | 4a | ❌ | ❌ | ✅ |
| Camera SetLocalOrientation | 4a | ✅ (camera) | ✅ (camera) | ✅ (camera) |

### CET-level body orientation is now exhausted

Every available CET API for setting player body orientation has been tested. The locomotion system enforces `roll=0, pitch=0` (and for SetWorldTransform, even yaw=unchanged) through a mechanism that cannot be bypassed by:
- `SetWorldTransform`
- `EnableTransformUpdates(false)`
- `TeleportationFacility:Teleport()`
- Being airborne (no ground contact)
- Any EulerAngles constructor order

The only remaining untested approaches from Player 3's next steps are:
- Step 3: `gamestateMachineComponent` access via `FindComponentByType`
- Step 4: `moveComponent` / `entColliderComponent` access
- Step 7: PSM blackboard manipulation
- Step 8: Workspot/pose-based rotation (lean anywhere, chair, bed)
