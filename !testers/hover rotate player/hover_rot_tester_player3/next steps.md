# Player 3 — Next Steps

## Summary of What We Learned

1. **SetWorldTransform is a no-op** on the player entity — confirmed again
2. **No ragdoll** — `CanRagdoll()` returns false, no ragdoll component in 174 components
3. **TeleportationFacility.Teleport() exists** — a completely different path for setting position + orientation
4. **EnableTransformUpdates(false) exists** — could disable the locomotion system's transform override
5. **FPPCameraComponent has SetLocalOrientation** — camera can be independently rotated
6. **FindComponentByType(type: CName) exists** — correct method to find components by type
7. **174 components found** — including `gamestateMachineComponent`, `moveComponent`, `entColliderComponent`, `entAnimationControllerComponent`, `gameHumanoidBody`

---

## Ranked Next Steps

### Step 1: Try `EnableTransformUpdates(false)` + `SetWorldTransform`

**Why**: The reflection dump revealed `EnableTransformUpdates(enable: Bool)`. If we disable transform updates, the locomotion system may stop overriding our SetWorldTransform calls.

**Test plan**:
```lua
-- Disable transform updates
player:EnableTransformUpdates(false)

-- Now try SetWorldTransform with a modified orientation
local wt = WorldTransform.new()
wt:SetPosition(player:GetWorldPosition())
wt:SetOrientation(myQuaternion)
player:SetWorldTransform(wt)

-- Check if orientation stuck
local euler = player:GetWorldOrientation():ToEulerAngles()
print("After: roll=" .. euler.roll .. " pitch=" .. euler.pitch .. " yaw=" .. euler.yaw)

-- Re-enable when done
player:EnableTransformUpdates(true)
```

**Risk**: Disabling transform updates may freeze the player or break movement entirely. Test carefully.

---

### Step 2: Try `TeleportationFacility:Teleport()` with orientation

**Why**: Teleport is a completely different code path from SetWorldTransform. It may bypass the locomotion override. The entity examiner tool uses it: `tpFacility:Teleport(Game.GetPlayer(), rcEnt:GetWorldPosition(), EulerAngles.new(0,0,10))`.

**Test plan**:
```lua
local tpFac = Game.GetTeleportationFacility()
local pos = player:GetWorldPosition()
-- Teleport to same position but with modified orientation
tpFac:Teleport(player, pos, EulerAngles.new(roll, pitch, yaw))
```

**Key question**: Does Teleport's EulerAngles parameter actually set the body orientation, or just the camera? Player 2 showed camera yaw was locked but body yaw didn't change — Teleport might be different.

---

### Step 3: Access `gamestateMachineComponent` via `FindComponentByType`

**Why**: The PSM (Player State Machine) controls locomotion states. If we can access it, we might be able to:
- Put the player in a state that doesn't override orientation
- Read the current locomotion state to understand what's fighting us

**Test plan**:
```lua
local sm = player:FindComponentByType(CName.new("gamestateMachineComponent"))
-- or
local sm = player:FindComponentByType("gamestateMachineComponent")
if sm then
    -- Probe its methods
    -- Try to read current state
    -- Try to set state
end
```

---

### Step 4: Access `moveComponent` and `entColliderComponent`

**Why**: The move component controls movement, and the collider controls physics. Either could be the source of the orientation override.

**Test plan**:
```lua
local mc = player:FindComponentByType(CName.new("moveComponent"))
local col = player:FindComponentByType(CName.new("entColliderComponent"))
-- Probe their methods for orientation/transform setters
```

---

### Step 5: Try `entAnimationControllerComponent` for animation-driven rotation

**Why**: The animation controller drives the visual body. If we can feed it orientation data, the body might rotate even if the entity transform doesn't.

**Test plan**:
```lua
local animCtrl = player:FindComponentByType(CName.new("entAnimationControllerComponent"))
-- or use the getter from the Dump:
local animCtrl = player:GetAnimationControllerComponent()
-- Probe for orientation/pose methods
```

---

### Step 6: FPPCameraComponent `SetLocalOrientation` for camera rotation

**Why**: Even if the body can't rotate, we can rotate the camera independently. This would give a "looking around while hovering" effect.

**Test plan**:
```lua
local cam = player:GetFPPCameraComponent()
cam:SetLocalOrientation(myQuaternion)
```

**Limitation**: This only rotates the camera, not the body. But it's a guaranteed win for at least visual rotation.

---

### Step 7: `GetPlayerStateMachineBlackboard` for PSM state manipulation

**Why**: The PSM blackboard controls locomotion states. We might be able to write a state that allows free orientation.

**Test plan**:
```lua
local psmBB = player:GetPlayerStateMachineBlackboard()
-- Read current state
-- Try setting locomotion state to something that doesn't override orientation
```

---


### Step 8:

while playing the game, when the player is lying on a bed, the body is in a pose and the head rotates in the direction that the pose dictates

so maybe a chair or something (there is a lean anywhere mod).  if the point that the player attaches to can be mobile and rotated, that may work



## Recommended Test Order

| Priority | Step | Difficulty | Potential |
|----------|------|-----------|-----------|
| 1 | EnableTransformUpdates(false) + SetWorldTransform | Easy | 🔥 High |
| 2 | TeleportationFacility:Teleport() with orientation | Easy | 🔥 High |
| 3 | FindComponentByType("gamestateMachineComponent") | Medium | Medium |
| 4 | FindComponentByType("moveComponent") + ("entColliderComponent") | Medium | Medium |
| 5 | entAnimationControllerComponent probe | Medium | Medium |
| 6 | FPPCameraComponent SetLocalOrientation | Easy | Low (camera only) |
| 7 | PSM blackboard manipulation | Hard | Medium |

---

## What's Been Ruled Out

| Approach | Why |
|----------|-----|
| Ragdoll-based rotation | No ragdoll component exists, CanRagdoll()=false |
| SetWorldTransform alone | Confirmed no-op 3 times (Player 1, 2, 3) |
| Ragdoll events | Queue OK but no ragdoll component to receive them |
| GetComponent by string type | Method doesn't exist in CET |
| FindComponentByName with class names | Returns nil — expects component instance names, not class names |

---

## New Tester Mod Suggestion

Create `hover_rot_tester_player4` that tests Steps 1-2 (EnableTransformUpdates + Teleport) first, since they're the easiest and highest potential. Each on a separate hotkey:

- **Hotkey 1**: Disable transform updates → SetWorldTransform with 30° roll → log result → re-enable
- **Hotkey 2**: Teleport to current position with 30° roll → log result
- **Hotkey 3**: Teleport to current position with 30° pitch → log result
- **Hotkey 4**: FPPCameraComponent SetLocalOrientation with 30° roll → log result

This gives us 4 quick tests to determine which path works.
