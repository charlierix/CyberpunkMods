## What Changed from V1

V1 showed `SetWorldTransform` succeeds but is a complete no-op — position stayed at ground (52.5 not 55.5), orientation never changed from roll=0 pitch=0.

V2 takes a different approach:

| Aspect | V1 | V2 |
|--------|----|----|
| **Hover method** | SetWorldTransform with fixed position | PSMImpulse (spring-damper + anti-gravity, like jetpack) |
| **Position in SetWorldTransform** | Fixed hover point | Player's **current** position |
| **What it tests** | Can SetWorldTransform move+rotate the player? | Can SetOrientation work when not fighting SetPosition? |

## How the Impulse Hover Works

Each frame in `onUpdate`:

1. **Read** player position and velocity
2. **Apply hover impulse** — spring-damper to maintain altitude + horizontal drift damping:
   ```lua
   local errZ = state.hoverZ - pos.z
   local accelZ = SPRING_K * errZ - DAMPING_K * vel.z + GRAVITY
   local dvZ = clamp(accelZ * delta, MAX_DV)
   addImpulse(player, dvX, dvY, dvZ)
   ```
3. **Apply rotation** — SetWorldTransform with current position + quaternion:
   ```lua
   local wt = WorldTransform.new()
   wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1))  -- current pos
   wt:SetOrientation(gameQuat)
   player:SetWorldTransform(wt)
   ```

## Hover Tuning Parameters

- `GRAVITY` = 16.0 m/s² (from jetpack source)
- `SPRING_K` = 8.0 (height correction strength)
- `DAMPING_K` = 2.0 (vertical velocity damping)
- `HORIZ_DAMP_K` = 3.0 (horizontal drift damping)
- `MAX_DV` = 5.0 m/s per axis per frame

## What to Look For

Diagnostics print for 3 frames after each rotation change:

- **`DIAG impulse`** — the delta-v being applied (should show hover working)
- **`DIAG BEFORE`** — player orientation + position + velocity before SetWorldTransform
- **`SetWorldTransform SUCCESS/FAILED`** — whether the call succeeds
- **`DIAG AFTER`** — player orientation after the call (compare to target)
- **`DIAG pos after`** — whether position holds near hoverZ

### Success looks like:
- Player visibly hovers above ground (impulse working)
- `DIAG AFTER` matches `DIAG target` (orientation sticks)
- Body visually tilts when pressing pitch/roll hotkeys

### Failure looks like:
- Player hovers (impulse works) but `DIAG AFTER` still shows roll=0 pitch=0 — locomotion system overrides orientation
- This would confirm SetWorldTransform is a no-op on the player entity regardless of position handling