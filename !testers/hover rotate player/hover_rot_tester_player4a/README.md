# Player 4a — Teleport + EnableTransformUpdates + Euler Alternates

## What it does

Same hover+rotation concept as Player 4, but with key changes based on log analysis:

1. **No PSMImpulse** — Teleport handles both position AND orientation. No spring-damper, no gravity compensation, no velocity impulses.
2. **EnableTransformUpdates toggle** — The #1 untested approach from Player 3's findings. When disabled, the locomotion system may stop overriding roll/pitch back to 0°.
3. **EulerAngles order toggle** — Cycles through 4 constructor orderings to test whether `EulerAngles.new(a, b, c)` maps to (roll, pitch, yaw) or a different order for PlayerPuppet.
4. **Camera SetLocalOrientation toggle** — If body rotation still fails, this rotates the FPP camera independently as a fallback.
5. **Comprehensive logging** — All toggle states printed on activation, on each toggle, and in diagnostics so you always know what's active.

## What was wrong with Player 4

Player 4 proved Teleport gets yaw through but roll/pitch are clamped to 0 by the locomotion system. However, it **never tested `EnableTransformUpdates(false)`** — which was Player 3's #1 ranked next step. Player 4 also ran a PSMImpulse spring-damper every frame alongside Teleport, which may have contributed to the locomotion system fighting back.

## Toggle timing

**Toggles work both BEFORE and AFTER activation.** You don't need to restart hover to change options:

- **Before activate**: Toggles are stored and applied when hover starts
- **After activate**: Toggles are applied immediately (EnableTransformUpdates is called on the live player)

Each toggle prints its new state. Use the **Print Status** hotkey to see all current options at any time.

## 11 hotkeys

| Hotkey | Action |
|-------|--------|
| Toggle Hover | Start/stop hover + camera lock |
| Yaw ±30 | Rotate around Z |
| Pitch ±30 | Rotate around X |
| Roll ±30 | Rotate around Y |
| Toggle TransformUpdates | EnableTransformUpdates(false) on/off |
| Cycle Euler Order | Cycle through 4 EulerAngles constructor orderings |
| Toggle Camera Rotate | Also call cam:SetLocalOrientation(gameQuat) each frame |
| Print Status | Print all current toggle states |

## EulerAngles order variants

| # | Constructor | Description |
|---|-------------|-------------|
| 1 | `EulerAngles(roll, pitch, yaw)` | Original — confirmed for vehicles |
| 2 | `EulerAngles(pitch, roll, yaw)` | Swap roll/pitch |
| 3 | `EulerAngles(yaw, pitch, roll)` | Reversed |
| 4 | `EulerAngles(roll, yaw, pitch)` | Swap pitch/yaw |

## Diagnostic output (3 frames after each change)

- **target euler (raw)**: roll/pitch/yaw from quaternion math
- **euler order**: which constructor order is active
- **options**: transformUpdates + camRotate state
- **BEFORE Teleport**: current player orientation
- **Teleport(EulerAngles) SUCCESS/FAILED**: whether the call errored
- **AFTER Teleport**: what the player orientation actually is
- **MATCH: roll=X pitch=X yaw=X**: whether each axis stuck (within 1°)
- **CAM**: camera local orientation + sensitivity state

## What to look for in the log

1. **If `MATCH: roll=true pitch=true yaw=true` with TransformUpdates DISABLED** → EnableTransformUpdates(false) + Teleport works! We have our rotation method.
2. **If only yaw=true with TransformUpdates DISABLED** → Even with transform updates disabled, locomotion still overrides. Need a different approach.
3. **If roll or pitch stick with a different Euler order** → The constructor order was wrong for PlayerPuppet. Swap to the working order.
4. **If CAM shows rotation but body doesn't** → Camera rotate works as a fallback for visual rotation.
5. **If Teleport fails entirely with TransformUpdates DISABLED** → EnableTransformUpdates(false) blocks Teleport from setting orientation too.

## Install

Copy to `bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player4a`, bind hotkeys in Settings > Key Bindings, then:

1. (Optional) Toggle TransformUpdates OFF and/or cycle Euler order BEFORE activating
2. Press Toggle Hover to start
3. Press a rotation key and check the CET console
4. Toggle options mid-hover to compare
5. Press Print Status to verify what's active

## Key differences from Player 4

| Aspect | Player 4 | Player 4a |
|--------|----------|-----------|
| Position method | PSMImpulse spring-damper | Teleport only |
| EnableTransformUpdates | Not tested | Toggle hotkey |
| Euler order | Fixed (roll, pitch, yaw) | 4 cycling variants |
| Camera rotation | Not attempted | Toggle hotkey (SetLocalOrientation) |
| Option logging | Minimal | Full state on activate, toggle, and diagnostics |
