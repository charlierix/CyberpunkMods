# Player 4 — Log Summary

## Test Conditions

Three test sessions across two log files:

| Session | Log File | Date (UTC-5) | PID | Start Pos | Start Yaw |
|---------|----------|-------------|-----|-----------|----------|
| 1 | `log - untoggled.txt` | 2026-07-20 23:29 | 26132 | (-2063.7, -2706.4, 40.5) | -66.4° |
| 2 | `log - toggled untoggled.txt` (first) | 2026-07-21 10:59 | 13804 | (-2034.5, -2462.0, 37.0) | 126.1° |
| 3 | `log - toggled untoggled.txt` (second) | 2026-07-21 11:01 | 13804 | (-2034.5, -2462.0, 37.0) | 143.0° |

- **Hover height**: 3.0m above ground
- **Rotation step**: 30° per keypress
- **Quat-Direct mode**: OFF in session 1, ON in sessions 2 & 3
- **Camera**: FPPCameraComponent locked (sensitivity=0, pitch/yaw limits expanded to ±180°/360°)

---

## 1. Teleport(EulerAngles) — Call Result

**Always SUCCESS.** The `TeleportationFacility:Teleport(player, pos, EulerAngles)` call never errored across any session or rotation combination. Every single call returned without error.

---

## 2. Yaw — Works (with 1-frame diagnostic delay)

**Yaw sticks, but the first diagnostic frame after a rotation change always shows the OLD yaw.**

This is a **timing artifact** in the diagnostics, not a real failure. The code reads `GetWorldOrientation()` in the same `onUpdate` frame as the `Teleport()` call. The teleport hasn't applied yet when the AFTER read happens. By the next frame, yaw has updated.

### Pattern (example from session 1, yaw -66 → -36):

| Frame | Target | BEFORE | AFTER | MATCH |
|-------|--------|--------|-------|-------|
| 1 | -36.4 | -66.4 | -66.4 | yaw=**false** |
| 2 | -36.4 | -36.4 | -36.4 | yaw=**true** |
| 3 | -36.4 | -36.4 | -36.4 | yaw=**true** |

This pattern repeats consistently across all sessions for every yaw change.

**Conclusion**: Teleport successfully sets yaw on the player entity. The `yaw=false` on frame 1 is a read-before-apply timing issue.

---

## 3. Pitch — Never Sticks

**Pitch is always rejected.** Regardless of target value (30°, 60°, -0°, 0°), the AFTER orientation always shows `pitch=0.0`.

### All pitch tests across sessions:

| Session | Target Pitch | AFTER Pitch | Match |
|---------|-------------|-------------|-------|
| 1 | 30.0 | 0.0 | false |
| 1 | 60.0 | 0.0 | false |
| 1 | 30.0 | 0.0 | false |
| 1 | -0.0 | 0.0 | true (trivially) |
| 2 | 30.0 | 0.0 | false |
| 2 | 60.0 | 0.0 | false |
| 2 | 30.0 | 0.0 | false |
| 2 | 60.0 | 0.0 | false |
| 3 | 30.0 | 0.0 | false |
| 3 | 60.0 | 0.0 | false |

The locomotion system overrides pitch back to 0° every frame, even though Teleport accepts the EulerAngles without error.

---

## 4. Roll — Never Sticks

**Roll is always rejected.** Same pattern as pitch — regardless of target (30°, 60°, -0°, 0°), AFTER always shows `roll=0.0`.

### All roll tests across sessions:

| Session | Target Roll | AFTER Roll | Match |
|---------|------------|------------|-------|
| 1 | 30.0 | 0.0 | false |
| 1 | 60.0 | 0.0 | false |
| 1 | 30.0 | 0.0 | false |
| 1 | -0.0 | 0.0 | true (trivially) |
| 2 | 30.0 | 0.0 | false |
| 2 | 60.0 | 0.0 | false |
| 2 | 30.0 | 0.0 | false |
| 2 | -0.0 | 0.0 | true (trivially) |
| 3 | 30.0 | 0.0 | false |
| 3 | 60.0 | 0.0 | false |

---

## 5. Combined Roll + Pitch — Still Rejected

Tested `roll=30 pitch=60`, `roll=60 pitch=60`, `roll=30 pitch=60` — both axes always rejected:

| Target | AFTER | Match |
|--------|-------|-------|
| roll=30 pitch=60 | roll=0 pitch=0 | roll=false pitch=false |
| roll=60 pitch=60 | roll=0 pitch=0 | roll=false pitch=false |
| roll=30 pitch=60 | roll=0 pitch=0 | roll=false pitch=false |
| roll=-0 pitch=60 | roll=0 pitch=0 | roll=true pitch=false |

---

## 6. Teleport(Quaternion) — No Overload Exists

**Always FAILS** with: `Function 'Teleport' parameter 3 must be EulerAngles.`

Tested in sessions 2 & 3 (Quat-Direct mode ON). Every single attempt failed — there is **no undocumented Quaternion overload** for `TeleportationFacility:Teleport()`.

---

## 7. Position — Sticks (with same 1-frame delay)

Position holds at the hover target after the first frame, same timing pattern as yaw:

| Frame | Target Z | Actual Z | Match |
|-------|----------|----------|-------|
| 1 (activation) | 37.0 | 34.0 (ground) | No |
| 2+ | 37.0 | 37.0 | Yes |

Horizontal position (X, Y) sticks immediately.

---

## 8. Camera — Never Changes

FPPCameraComponent local orientation stays at `roll=0.0 pitch=0.0 yaw=0.0` throughout all sessions, with `sensX=0.0 sensY=0.0` and `heading=false`. The camera lock holds but the camera itself doesn't reflect any rotation changes.

---

## 9. Quat-Direct Toggle — No Effect on EulerAngles Behavior

Toggling Quat-Direct mode ON/OFF had no observable effect on the EulerAngles Teleport behavior. The only difference is that when ON, the additional Quaternion Teleport call fires (and fails) each frame.

---

## Summary Table

| Axis | Teleport Call | Sticks? | Notes |
|------|--------------|---------|-------|
| Yaw | SUCCESS | ✅ Yes | 1-frame diagnostic delay (timing artifact) |
| Pitch | SUCCESS | ❌ No | Always overridden to 0.0 by locomotion |
| Roll | SUCCESS | ❌ No | Always overridden to 0.0 by locomotion |
| Position | SUCCESS | ✅ Yes | 1-frame delay on Z (same as yaw) |
| Quaternion arg | N/A | ❌ No overload | Always errors: param 3 must be EulerAngles |

---

## What This Means

`TeleportationFacility:Teleport()` **does set yaw and position** on the player entity — this is a real improvement over `SetWorldTransform` (which was a complete no-op). However, **roll and pitch are still clamped to 0° by the locomotion system**, which runs after Teleport and overrides those axes. Teleport succeeds at the API level but the locomotion system's per-frame transform update fights it back.

This matches the pattern seen in Player 2 with `SetWorldTransform` — the locomotion system enforces `roll=0, pitch=0` regardless of the method used to set orientation. The difference is that Teleport at least gets yaw through, while SetWorldTransform got nothing through.
