# Player Body Rotation — Possible Approaches

**Goal:** Physically rotate the player character's body (full 6DOF — pitch, yaw, roll) while airborne, **not** just the camera.

**Problem:** The player's body is locked upright by the game's locomotion system. Camera-only rotation doesn't affect the body, and mouse look is tied to the body heading.

---

## Background: What We Already Know

### Camera rotation (tested, doesn't work for body)

See `testers/hover_rot_tester_playercamera/`. Summary of `TEST RESULTS.md`:

- Yaw always rotates around world Z, regardless of current pitch/roll
- Teleport locks out mouse X, but mouse Y still pitches along world right
- Since this only rotates the camera, the body is still upright — pitching down shows the body in an unrotated state

**Conclusion:** Camera rotation is insufficient. The body must be rotated.

### Teleport with EulerAngles (tested for yaw, limited)

`TeleportationFacility:Teleport(player, pos, EulerAngles.new(roll, pitch, yaw))` — from `docs/rotations/rotations-reference.md`:

- Only reliable way to set player body orientation without Codeware
- **Gimbal lock at pitch ±90°** — roll and yaw become ambiguous
- Only yaw is reliable for full rotation; pitch/roll may snap back due to locomotion system
- Player snaps to upright when locomotion state changes

### Vehicle rotation (solved, but different entity type)

Vehicles have full 6DOF rotation via `SetWorldTransform(WorldTransform)` with raw Quaternion — see `testers/hover_rot_tester_vehicle2/`.

Player does **not** have `SetWorldOrientation()` — confirmed nil method.

---

## Approach 1: SetWorldTransform on Player (UNTESTED — highest priority)

**Idea:** Use `player:SetWorldTransform(WorldTransform)` with a raw Quaternion orientation every frame, same pattern that works for vehicles.

```lua
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientation(gameQuat)  -- raw Quaternion, no gimbal lock
player:SetWorldTransform(wt)
```

**Why it might work:**
- `SetWorldTransform` exists on the `Entity` base class, and player inherits from it
- On vehicles, this bypasses the locomotion system and directly sets the rigid body transform
- If the player entity has a physics rigid body, this should override locomotion's upright lock

**Why it might not work:**
- Player may not have a standard physics rigid body (the player puppet is locomotion-driven, not physics-driven)
- The locomotion state machine may overwrite the transform immediately after we set it
- May require Codeware (like vehicles do)

**Test plan:**
1. Hover the player via continuous teleport (pattern from `hover_rot_tester_playercamera/init.lua`)
2. Replace teleport with `SetWorldTransform` using a quaternion built from accumulated roll/pitch/yaw
3. Observe whether the body tilts or snaps back upright
4. If it snaps back, try calling it in `onUpdate` every frame to fight the locomotion system

**Confidence:** Medium. This is the most promising untested approach.

---

## Approach 2: PhysicalImpulseEvent with Torque Arm (UNTESTED)

**Idea:** Apply `PhysicalImpulseEvent` at a position offset from the player's center of mass, creating torque via the lever arm.

```lua
local impulse = PhysicalImpulseEvent.new()
impulse.radius = 1.0
impulse.worldPosition = Vector4.new(pos.x + offset.x, pos.y + offset.y, pos.z + offset.z, 1)
impulse.worldImpulse = Vector3.new(forceX, forceY, forceZ)
player:QueueEvent(impulse)
```

**Why it might work:**
- This is how vehicle tester creates torque indirectly (impulse at offset = angular acceleration)
- The player entity processes queued events

**Why it might not work:**
- LTBF abandoned `PhysicalImpulseEvent` even for vehicles (commented out in source) — it's limited for continuous control
- The player may not have a physics rigid body that responds to torque — locomotion-driven puppets may ignore angular impulses
- Even if the body rotates, the locomotion system may snap it back upright the next frame
- No way to read/set angular velocity from CET (no `GetAngularVelocity()` equivalent for player)

**Test plan:**
1. While airborne, apply a strong horizontal impulse at a point 1m above the player's center
2. Observe whether the body tilts/rotates or stays upright
3. Try varying offset distances and impulse magnitudes

**Confidence:** Low-Medium. LTBF's abandonment of this approach is a bad sign, but the player may behave differently than vehicles.

---

## Approach 3: Ragdoll + Directional Impulses (hacky, UNTESTED)

**Idea:** Enable the player's ragdoll, apply directional impulses at offset points to create rotation, then disable ragdoll and teleport back to controlled state.

**API evidence:**
- `RagdollActivationRequestEvent` and `RagdollApplyImpulseEvent` exist in the game API (see `okf/api/events/event-misc-17-18.md`)
- Jetpack mod uses these on NPCs: `CreateForceRagdollEvent()` + `CreateRagdollApplyImpulseEvent(npc_pos, direction, radius)` (see `sources/mods/lua/jetpack/processing/ragdoll.lua`)
- `ScriptedPuppet.CanRagdoll(entity)` and `entity:CanEnableRagdollComponent()` are used to check ragdoll capability

**Pattern from jetpack ragdoll.lua:**
```lua
npc:QueueEvent(CreateForceRagdollEvent("Launch Up"))
-- Must wait a frame for ragdoll to activate
DelayEventNextFrame(npc, CreateRagdollApplyImpulseEvent(npc_pos, direction, 5))
```

**Why it might work:**
- A ragdolled body is a true physics rigid body — it responds to torque and angular velocity
- Apply impulses at offset points to create rotation, then snap back to controlled state

**Why it probably shouldn't be the primary approach:**
- Player loses all control during ragdoll — no movement, no camera control, no weapon use
- Transitioning in/out of ragdoll is jarring and may cause animation glitches
- The player may not support `CanRagdoll()` / `CanEnableRagdollComponent()` the same way NPCs do
- Recovering the upright orientation after ragdoll requires a teleport snap, which may not align with desired rotation
- This is a visual trick, not true rotation control

**Test plan:**
1. Try `ScriptedPuppet.CanRagdoll(Game.GetPlayer())` — does the player even support ragdoll?
2. If yes, enable ragdoll and apply impulse at offset to see if the body tumbles
3. Measure whether the body holds a non-upright orientation while ragdolled

**Confidence:** Low for practical use. High for proving the body *can* be rotated by physics (ragdoll is proof of concept).

---

## Approach 4: PSMImpulse (does NOT support torque)

**Idea:** Use `PSMImpulse` with an angular component.

**Reality:** `PSMImpulse` only has a translational `impulse` field (Vector4). There is no torque or angular velocity field. This is confirmed by all existing mods:

```lua
-- From Alternative Midair Movement, player.lua
function Player:AddImpulse(v)
    local impulseEvent = PSMImpulse.new()
    impulseEvent.id = "impulse"
    impulseEvent.impulse = v  -- translational only
    self.object:QueueEvent(impulseEvent)
end
```

**Conclusion:** PSMImpulse cannot rotate the player. It is purely translational. All midair movement mods (Alternative Midair Movement, Jetpack, Grappling Hook, Wall Hang) use this for position only.

---

## Approach 5: Animation / Workspot-Based Rotation

**Idea:** Play an animation or enter a workspot that rotates the player body, then exit at the desired orientation.

**Why it's limited:**
- Animations are predefined — you can't dynamically control roll/pitch/yaw
- The game's slide animation does tilt the body, but only at fixed angles
- Workspots lock the player into a scripted sequence — no free control
- You'd need a custom animation for every desired rotation angle, or a set of animations to approximate it

**Possible hack:**
- Find or create an animation that holds the player at a tilted angle (e.g., a prone or dive animation)
- Enter the animation state, then teleport to set position, and maintain the animation's rotation
- Exit the animation when the player wants to return to normal

**Confidence:** Low for 6DOF control. Could work for specific fixed angles (like a "lying down" or "diving" pose), but not for dynamic rotation.

---

## Approach 6: RED4ext C++ Plugin (LTBF-style, not CET)

**Idea:** Write a native DLL that directly writes to the player's `physicsData->force` and `physicsData->torque` struct fields, like Let There Be Flight does for vehicles.

**Why it's out of scope for now:**
- Requires C++ development with RED4ext
- Requires reverse-engineering the player's physics struct layout (different from vehicle)
- Cannot be done from CET Lua
- LTBF confirms `physicsData->torque` is a raw field on the rigid body struct that the physics engine reads directly — but only for vehicles
- The player puppet may not even have a `physicsData` struct in the same form

**Confidence:** N/A for CET-only approach. This is the fallback if all CET approaches fail.

---

## Approach 7: Teleport + Quaternion-to-Euler (gimbal-limited)

**Idea:** Keep orientation as a quaternion internally, convert to Euler only when calling Teleport, accept the gimbal lock limitation.

```lua
-- Store as quaternion
state.quat = { w=1, x=0, y=0, z=0 }  -- identity

-- Apply incremental rotations in quaternion space
local rot = Quat.fromAxisAngle(axis, radians)
state.quat = Quat.mul(state.quat, rot)

-- Convert to Euler for Teleport (unavoidable gimbal lock)
local euler = GetSingleton('Quaternion'):ToEulerAngles(
    Quaternion.new(state.quat.x, state.quat.y, state.quat.z, state.quat.w)
)
Game.GetTeleportationFacility():Teleport(player, pos, euler)
```

**Why it's limited:**
- Gimbal lock at pitch ±90° — can't look straight up/down without roll/yaw ambiguity
- Teleport may snap the body back upright regardless of the Euler angles passed (locomotion override)
- This is what `hover_rot_tester_playercamera` already does for yaw — the body yaw changes, but pitch/roll on the body don't hold

**Test plan:**
1. Already partially tested — yaw works, pitch/roll on the body don't hold
2. Test whether passing non-zero roll/pitch to Teleport while airborne changes the body orientation at all
3. If the body tilts momentarily but snaps back, the locomotion system is overriding it — try calling Teleport every frame to fight it

**Confidence:** Low for full 6DOF. Medium for yaw-only rotation (already works).

---

## Summary Matrix

| # | Approach | CET-only? | Full 6DOF? | Tested? | Confidence |
|---|----------|-----------|-----------|---------|------------|
| 1 | SetWorldTransform on player | Yes (needs Codeware?) | Yes (if it works) | No | **Medium** |
| 2 | PhysicalImpulseEvent with torque arm | Yes | Maybe | No | Low-Medium |
| 3 | Ragdoll + directional impulses | Yes | Yes (while ragdolled) | No | Low (hacky) |
| 4 | PSMImpulse | Yes | **No** (translational only) | Yes | None |
| 5 | Animation / Workspot | Yes | No (fixed angles only) | No | Low |
| 6 | RED4ext C++ plugin | No (C++ required) | Yes | N/A | N/A (fallback) |
| 7 | Teleport + Quat→Euler | Yes | No (gimbal lock) | Partially | Low-Medium |

---

## Recommended Testing Order

1. **SetWorldTransform on player** (Approach 1) — most promising, directly analogous to the vehicle solution that works. If the player entity has a physics rigid body, this should work.

2. **PhysicalImpulseEvent with offset** (Approach 2) — if SetWorldTransform fails, try applying torque via lever arm. Quick to test.

3. **Teleport with non-zero roll/pitch** (Approach 7) — confirm whether the body holds any tilt at all when Teleport is called every frame with roll/pitch. If it tilts and snaps back, the locomotion system is the enemy — we need to find a way to suppress it.

4. **Ragdoll capability check** (Approach 3) — test `ScriptedPuppet.CanRagdoll(Game.GetPlayer())`. Even if we don't use ragdoll for control, it confirms whether the player body *can* be rotated by physics at all.

---

## Key Unknowns to Probe

- Does `player:SetWorldTransform(wt)` exist and work, or is it nil like `SetWorldOrientation`?
- Does the player have a physics rigid body, or is it purely locomotion-driven?
- Does the locomotion state machine overwrite transforms every frame, and can we suppress it?
- Can `PhysicalImpulseEvent` be queued on the player (it's used on vehicles, but is the player a valid target)?
- Does the player support ragdoll at all (`CanRagdoll`, `CanEnableRagdollComponent`)?
