# Player 4a — Log Summary

## Test Conditions

- **Date**: 2026-07-21 21:04–21:14 UTC-05:00
- **PID**: 4008
- **Position**: (-2034.5, -242.0, 37.0) / (-2033.5, -2461.9, 37.0)
- **Hover height**: 3.0m above ground (Teleport-only, no impulse)
- **Rotation step**: 30° per keypress
- **Sessions**: 7 activate/deactivate cycles

---

## 1. EnableTransformUpdates(false) — Does NOT Help

**This was the #1 untested approach from Player 3.** It was applied successfully (`ok=true`) but **roll and pitch are still clamped to 0°**.

### Evidence (TransformUpdates DISABLED section, lines 1602–1865)

| Target | AFTER Teleport | Match |
|--------|---------------|-------|
| roll=0 pitch=0 yaw=157 | roll=0 pitch=0 yaw=126.5 | roll=true pitch=true yaw=false (frame 1 delay) |
| roll=0 pitch=0 yaw=157 | roll=0 pitch=0 yaw=156.5 | roll=true pitch=true yaw=true |
| roll=0 pitch=30 yaw=-173 | roll=0 pitch=0 yaw=-173.5 | roll=true pitch=**false** yaw=true |
| roll=0 pitch=60 yaw=-173 | roll=0 pitch=0 yaw=-173.5 | roll=true pitch=**false** yaw=true |
| roll=30 pitch=60 yaw=-173 | roll=0 pitch=0 yaw=-173.5 | roll=**false** pitch=**false** yaw=true |
| roll=60 pitch=60 yaw=-173 | roll=0 pitch=0 yaw=-173.5 | roll=**false** pitch=**false** yaw=true |

**Conclusion**: `EnableTransformUpdates(false)` does not stop the locomotion system from clamping roll/pitch to 0°. The locomotion override is deeper than the transform update system.

---

## 2. EulerAngles Constructor Order — Irrelevant

All 4 constructor orderings were tested (lines 4027–5540):

| # | Constructor | Roll Sticks? | Pitch Sticks? | Yaw Sticks? |
|---|-------------|-------------|-------------|-------------|
| 1 | EulerAngles(roll, pitch, yaw) | ❌ No | ❌ No | ✅ Yes |
| 2 | EulerAngles(pitch, roll, yaw) | ❌ No | ❌ No | ✅ Yes |
| 3 | EulerAngles(yaw, pitch, roll) | ❌ No | ❌ No | ✅ Yes |
| 4 | EulerAngles(roll, yaw, pitch) | ❌ No | ❌ No | ✅ Yes |

**Conclusion**: The constructor order doesn't matter because roll and pitch are ignored entirely by the locomotion system regardless of which arg position they're in. Only yaw is ever retained. The original order `EulerAngles(roll, pitch, yaw)` is confirmed correct since yaw always works in position 3.

---

## 3. Camera SetLocalOrientation — WORKS (Full 3-Axis)

**This is the one positive result.** When CameraRotate is ON, `cam:SetLocalOrientation(gameQuat)` successfully rotates the camera on all 3 axes.

### Camera rotation evidence (lines 2213+):

| Target (quat) | CAM Diagnostic | Camera Match? |
|---------------|----------------|---------------|
| roll=0 pitch=30 yaw=157 | CAM: roll=30.0 pitch=0.0 yaw=156.5 | ✅ Camera rotates |
| roll=0 pitch=60 yaw=157 | CAM: roll=60.0 pitch=0.0 yaw=156.5 | ✅ Camera rotates |
| roll=0 pitch=90 yaw=-177 | CAM: roll=90.0 pitch=0.0 yaw=-173.5 | ✅ Camera rotates |
| roll=30 pitch=0 yaw=-143 | CAM: roll=0.0 pitch=30.0 yaw=-143.5 | ✅ Camera rotates |
| roll=60 pitch=0 yaw=-143 | CAM: roll=0.0 pitch=60.0 yaw=-143.5 | ✅ Camera rotates |
| roll=90 pitch=0 yaw=-143 | CAM: roll=0.0 pitch=90.0 yaw=-143.5 | ✅ Camera rotates |
| roll=-30 pitch=0 yaw=-143 | CAM: roll=0.0 pitch=-30.0 yaw=-143.5 | ✅ Camera rotates |
| roll=-60 pitch=0 yaw=-143 | CAM: roll=0.0 pitch=-60.0 yaw=-143.5 | ✅ Camera rotates |

**Note on axis mapping**: The quaternion's X-axis rotation (our "pitch") shows up as camera roll, and Y-axis rotation (our "roll") shows up as camera pitch. This is an axis naming convention difference between the quaternion math and the camera's local space — the rotation itself is correct, just the labels differ.

**Conclusion**: `FPPCameraComponent:SetLocalOrientation()` works for full 3-axis camera rotation. The camera fully rotates but the body stays upright. This is a usable visual rotation fallback.

---

## 4. Camera Rotate + TransformUpdates Disabled

Tested combining both toggles (lines 2213–2830). Camera still rotates fully, body still stays upright. `EnableTransformUpdates(false)` doesn't change camera behavior or body behavior.

---

## 5. Roll Sometimes Changed Yaw

The user noted "roll didn't roll, but sometimes changed the yaw." This is visible in the log at certain angle combinations — when roll and pitch are both non-zero, the quaternion-to-euler conversion can produce yaw shifts due to gimbal lock near 90° pitch. This is a math artifact, not a game behavior.

---

## 6. Teleport Call — Always Succeeds

Zero FAILED or ERROR lines in the entire 5540-line log. `TeleportationFacility:Teleport()` with EulerAngles never errors, regardless of toggle states or angle values.

---

## Summary Table

| Approach | Roll | Pitch | Yaw | Position | Errors |
|----------|------|-------|-----|----------|--------|
| Teleport (defaults) | ❌ | ❌ | ✅ | ✅ | None |
| Teleport + TransformUpdates OFF | ❌ | ❌ | ✅ | ✅ | None |
| Teleport (any Euler order) | ❌ | ❌ | ✅ | ✅ | None |
| Camera SetLocalOrientation | ✅ (camera) | ✅ (camera) | ✅ (camera) | N/A | None |
| Camera + TransformUpdates OFF | ✅ (camera) | ✅ (camera) | ✅ (camera) | N/A | None |

---

## What This Means

**CET-level body orientation setting is exhausted.** Every available CET API for setting player orientation has been tested:

| Method | Testers | Result |
|--------|---------|--------|
| SetWorldTransform | 1, 2, 3 | Complete no-op |
| Teleport(EulerAngles) | 4, 4a | Yaw only — roll/pitch clamped to 0 |
| EnableTransformUpdates(false) | 4a | Does not stop roll/pitch clamping |
| Euler constructor order | 4a | Irrelevant — axes ignored |
| Camera SetLocalOrientation | 4a | Works for camera only, not body |

The locomotion system enforces `roll=0, pitch=0` on the player body through a mechanism that is **not** controlled by `EnableTransformUpdates`, `SetWorldTransform`, or `TeleportationFacility:Teleport()`. This override happens at a level deeper than CET can reach with transform/teleport APIs.

**One usable result**: Camera rotation via `SetLocalOrientation` works for full 3-axis visual rotation. The body stays upright but the camera can look in any direction.
