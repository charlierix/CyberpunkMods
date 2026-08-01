# Cyberpunk 2077 CET Rotation & Orientation Reference

Quick reference for setting rotation on every entity type. Based on analysis of 50+ mods.

See `rotation_orientation_research_report.md` for detailed evidence and source citations.

---

## Math Type Constructors

| Type | Constructor | Arg Order | Notes |
|------|-----------|----------|-------|
| `EulerAngles` | `EulerAngles.new(roll, pitch, yaw)` | **roll, pitch, yaw** | Degrees. The okf doc saying (pitch, roll, yaw) is **wrong**. |
| `Quaternion` | `Quaternion.new(x, y, z, w)` | **x, y, z, w** | x/y/z = imaginary (i,j,k), w = real (r). Identity = (0,0,0,1). |
| `Vector4` | `Vector4.new(x, y, z, w)` | **x, y, z, w** | w=1 for positions, w=0 for directions. |
| `WorldTransform` | `WorldTransform.new()` | No args | Then call `SetPosition()` + `SetOrientation()`. |

### Quaternion internal fields

Quaternion objects expose `.i` (x), `.j` (y), `.k` (z), `.r` (w) — NOT `.x`, `.y`, `.z`, `.w`.

### Quaternion singleton methods

```lua
local quat = GetSingleton('Quaternion'):SetAxisAngle(axis_unit, radians)
local rotated = GetSingleton('Quaternion'):Transform(quat, vector)
local blended = GetSingleton('Quaternion'):Slerp(q1, q2, 0.5)
local euler = GetSingleton('Quaternion'):ToEulerAngles(quat)
```

### EulerAngles ↔ Quaternion conversion

```lua
-- Euler → Quat
local quat = EulerAngles.new(roll, pitch, yaw):ToQuat()
local quat = GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(roll, pitch, yaw))

-- Quat → Euler
local euler = entity:GetWorldOrientation():ToEulerAngles()
local euler = GetSingleton('Quaternion'):ToEulerAngles(quat)
```

---

## Can Quaternion → EulerAngles reliably represent any rotation?

**No.** Euler angles suffer from **gimbal lock** at pitch ±90°.

When pitch approaches ±90°, the roll and yaw axes become colinear. The Euler representation loses a degree of freedom — roll and yaw become ambiguous and interchangeable. Converting a quaternion to Euler at that point produces arbitrary roll/yaw values.

### Implications

- **Teleport** only accepts EulerAngles — it **cannot** reliably set orientations near ±90° pitch.
- **SetWorldTransform** + **SetLocalOrientation** accept raw Quaternions — they avoid gimbal lock entirely.
- For full 6DOF (pitch past ±90°), you **must** use Quaternion-based methods, not Euler.

### Best practice

Keep your orientation as a quaternion internally. Only convert to Euler when calling Teleport (unavoidable). Use `SetWorldTransform` or `SetLocalOrientation` with raw quaternions for everything else.

```lua
-- Store as quaternion {w, x, y, z}
state.quat = { w=1, x=0, y=0, z=0 }  -- identity

-- Apply incremental rotations in quaternion space (no gimbal lock)
local rot = Quat.fromAxisAngle(0, 1, 0, 30)  -- pitch +30°
state.quat = Quat.mul(state.quat, rot)

-- Convert to CET Quaternion (no Euler round-trip)
local gameQuat = Quaternion.new(state.quat.x, state.quat.y, state.quat.z, state.quat.w)
```

---

## Orientation Methods by Entity Type

### Player (GameObject)

| Method | Arg Type | Works? | Requires Codeware |
|--------|---------|--------|------------------|
| `TeleportationFacility:Teleport(player, pos, EulerAngles)` | EulerAngles | Yes | No |
| `player:GetWorldOrientation()` | Returns Quaternion | Yes (read) | No |
| `player:GetFPPCameraComponent():SetLocalOrientation(Quat)` | Quaternion | Yes (camera only) | No |
| `player:SetWorldOrientation(Quat)` | — | **Does not exist** | — |
| `player:SetWorldTransform(WorldTransform)` | WorldTransform | Yes | Yes |

**Only reliable way to set player body orientation**: `Teleport` with EulerAngles. No native quaternion method exists.

```lua
Game.GetTeleportationFacility():Teleport(
    Game.GetPlayer(),
    Vector4.new(x, y, z, 1),
    EulerAngles.new(roll, pitch, yaw)
)
```

### Vehicle (gameVehicle / mounted vehicle)

| Method | Arg Type | Works? | Requires Codeware |
|--------|---------|--------|------------------|
| `TeleportationFacility:Teleport(vehicle, pos, EulerAngles)` | EulerAngles | ⚠️ Yaw only | No |
| `vehicle:SetWorldTransform(WorldTransform)` | WorldTransform | Yes (full 6DOF) | Yes |
| `vehicle:SetWorldOrientation(Quat)` | Quaternion | **Does not exist** | — |
| `vehicle:GetWorldOrientation()` | Returns Quaternion | Yes (read) | No |

**SetWorldOrientation is nil on vehicles** — confirmed by runtime error: `attempt to call method 'SetWorldOrientation' (a nil value)`.

**Best approach** (requires Codeware):
```lua
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientation(gameQuat)  -- raw Quaternion, no gimbal lock
vehicle:SetWorldTransform(wt)
```

**Fallback** (no Codeware, Euler only):
```lua
Game.GetTeleportationFacility():Teleport(
    vehicle,
    Vector4.new(x, y, z, 1),
    euler  -- EulerAngles.new(roll, pitch, yaw) — gimbal lock risk
)
```

### Camera (FPPCameraComponent)

| Method | Arg Type | Works? | Requires Codeware |
|--------|---------|--------|------------------|
| `cam:SetLocalOrientation(Quaternion)` | Quaternion | Yes | No |
| `cam:GetLocalOrientation()` | Returns Quaternion | Yes (read) | No |
| `cam.sensitivityMultX = 0` | Float | Yes | No |
| `cam.sensitivityMultY = 0` | Float | Yes | No |
| `cam.headingLocked` | Bool | Yes (use with caution) | No |
| `cam.pitchMin` / `cam.pitchMax` | Float | Yes | No |
| `cam.yawMaxLeft` / `cam.yawMaxRight` | Float | Yes | No |

```lua
-- Set camera orientation from Euler
cam:SetLocalOrientation(EulerAngles.new(roll, pitch, yaw):ToQuat())

-- Set camera orientation from raw Quaternion (no gimbal lock)
cam:SetLocalOrientation(Quaternion.new(x, y, z, w))
```

**Gotchas**:
- Camera has its own update loop — set `sensitivityMultX/Y = 0` to stop mouse override.
- `headingLocked = true` freezes camera in **world space** — do NOT use for vehicle rotation mods. The camera stops following the vehicle heading.
- TweakDB `fppCameraParamSets.Vehicle.pitchMin/Max` also constrain pitch range.

### Generic Entity (Entity base class)

| Method | Arg Type | Works? | Requires Codeware |
|--------|---------|--------|------------------|
| `entity:SetWorldTransform(WorldTransform)` | WorldTransform | Yes | Yes |
| `TeleportationFacility:Teleport(entity, pos, EulerAngles)` | EulerAngles | Yes | No |
| `entity:GetWorldOrientation()` | Returns Quaternion | Yes (read) | No |
| `entity:GetWorldPosition()` | Returns Vector4 | Yes (read) | No |

### Components (IComponent, IPlacedComponent)

| Method | Arg Type | Works? | Requires Codeware |
|--------|---------|--------|------------------|
| `component:SetLocalOrientation(Quaternion)` | Quaternion | Yes | No |
| `component:GetLocalOrientation()` | Returns Quaternion | Yes (read) | No |
| `component.worldTransform` | WorldTransform | Yes (IPlacedComponent) | Yes |

```lua
component:SetLocalOrientation(EulerAngles.new(roll, pitch, yaw):ToQuat())
```

---

## WorldTransform Construction

`WorldTransform.new()` then call setters:

```lua
-- Pattern 1: Position + Quaternion orientation
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientation(quaternion)
entity:SetWorldTransform(wt)

-- Pattern 2: Position + Euler orientation
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientationEuler(EulerAngles.new(roll, pitch, yaw))
entity:SetWorldTransform(wt)

-- Pattern 3: Copy from existing entity
local wt = WorldTransform.new()
wt:SetOrientation(entity:GetWorldOrientation())
wt:SetPosition(entity:GetWorldPosition())
```

Source: `sources/codeware/scripts/Base/Addons/WorldTransform.reds`
```cs
@addField(WorldTransform)
public native let Position: WorldPosition;

@addField(WorldTransform)
public native let Orientation: Quaternion;
```

---

## TeleportationFacility:Teleport() Signature

```lua
Game.GetTeleportationFacility():Teleport(entity, position: Vector4, rotation: EulerAngles)
```

- **entity**: Any Entity/GameObject (player, NPC, vehicle)
- **position**: `Vector4.new(x, y, z, 1)` — w=1 for positions
- **rotation**: `EulerAngles.new(roll, pitch, yaw)` — **accepts EulerAngles, NOT Quaternion**

Key limitation: Teleport only accepts EulerAngles. Quaternion→Euler conversion is unavoidable here, introducing gimbal lock risk. Use `SetWorldTransform` with raw Quaternion to avoid this.

---

## Key Gotchas

1. **EulerAngles order is (roll, pitch, yaw)** — NOT (pitch, roll, yaw) despite okf doc comment
2. **Quaternion.new takes (x, y, z, w)** — NOT (w, x, y, z)
3. **Quaternion internal fields are `.i`, `.j`, `.k`, `.r`** — NOT `.x`, `.y`, `.z`, `.w`
4. **Teleport only accepts EulerAngles** — gimbal lock at pitch ±90° is unavoidable
5. **SetWorldTransform requires Codeware** — it's an `@addMethod`, not a native method
6. **SetWorldOrientation does NOT exist on vehicles** — use SetWorldTransform instead
7. **Camera `headingLocked = true` is wrong for vehicles** — freezes camera in world space
8. **Vehicle physics fights orientation changes** — zero velocity each frame with PSMImpulse
9. **Gimbal lock at pitch ±90°** — use raw quaternions via SetWorldTransform/SetLocalOrientation to avoid
10. **Quaternion.new() may be unreliable** — if it fails, fall back to `GetSingleton('Quaternion'):SetAxisAngle()` or `EulerAngles:ToQuat()`
