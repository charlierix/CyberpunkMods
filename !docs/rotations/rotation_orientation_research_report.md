# Cyberpunk 2077 CET Modding: Rotation & Orientation Patterns — Comprehensive Research Report

*Generated from analysis of 50+ mods, okf knowledge base, codeware source, and tester code*

---

## Table of Contents
1. [API Reference: Math Types](#1-api-reference-math-types)
2. [EulerAngles.new() Argument Order](#2-euleranglesnew-argument-order)
3. [Quaternion.new() Argument Order](#3-quaternionnew-argument-order)
4. [Quaternion ↔ EulerAngles Conversion & Gimbal Lock](#4-quaternion--eulerangles-conversion--gimbal-lock)
5. [WorldTransform Construction](#5-worldtransform-construction)
6. [TeleportationFacility:Teleport() Signature](#6-teleportationfacilityteleport-signature)
7. [Entity Type: Player (GameObject)](#7-entity-type-player-gameobject)
8. [Entity Type: Vehicle (gameVehicle/mounted vehicle)](#8-entity-type-vehicle)
9. [Entity Type: Camera (FPPCameraComponent)](#9-entity-type-camera-fppcameracomponent)
10. [Entity Type: Generic Entities (Entity base class)](#10-entity-type-generic-entities)
11. [Entity Type: Components (IComponent, IPlacedComponent)](#11-entity-type-components)
12. [Flying Vehicle Mod Patterns](#12-flying-vehicle-mod-patterns)
13. [Wall Running Mod Patterns](#13-wall-running-mod-patterns)
14. [Summary Matrix](#14-summary-matrix)

---

## 1. API Reference: Math Types

### Vector4
~~~lua
local pos = Vector4.new(x, y, z, w)  -- w=1 for positions, w=0 for directions
~~~
- Source: `okf/mods/modding/cet-runtime/vector-math.md`

### Vector3
~~~lua
local dir = Vector3.new(x, y, z)  -- 3-component variant, less common
~~~

### EulerAngles
~~~lua
local angle = EulerAngles.new(roll, pitch, yaw)  -- degrees, see §2
~~~

### Quaternion
~~~lua
local quat = Quaternion.new(x, y, z, w)  -- see §3
-- OR via singleton:
local rotQuat = GetSingleton('Quaternion'):SetAxisAngle(axis_unit, radians)
local rotated = GetSingleton('Quaternion'):Transform(quat, vector)
local blended = GetSingleton('Quaternion'):Slerp(q1, q2, 0.5)
~~~
- Source: `okf/mods/modding/cet-runtime/singleton-access.md`, `okf/mods/modding/cet-runtime/vector-math.md`
- Internal fields: `.i`, `.j`, `.k`, `.r` (NOT `.x`, `.y`, `.z`, `.w`)
  - Source: `sources/mods/lua/jetpack/core/math_vector.lua` lines 10-13

### Quaternion Singleton Methods
~~~lua
GetSingleton('Quaternion'):SetAxisAngle(axis: Vector4, angle: Float) -> Quaternion
GetSingleton('Quaternion'):Transform(quat: Quaternion, vec: Vector4) -> Vector4
GetSingleton('Quaternion'):Slerp(from: Quaternion, to: Quaternion, t: Float) -> Quaternion
GetSingleton('EulerAngles'):ToQuat(euler: EulerAngles) -> Quaternion
GetSingleton('Quaternion'):ToEulerAngles(quat: Quaternion) -> EulerAngles
~~~
- Source: `okf/mods/modding/cet-runtime/singleton-access.md`
- Note: CET converts native `out` parameters to return values

---

## 2. EulerAngles.new() Argument Order

### Answer: **(roll, pitch, yaw)** — confirmed by actual mod code across the entire codebase

### Evidence

**okf documentation** (`okf/mods/modding/cet-runtime/vector-math.md` line 42) states:
> `EulerAngles.new(pitch, roll, yaw)` — rotation in degrees (note: pitch, roll, yaw order)

**However, ALL actual mod code uses (roll, pitch, yaw):**

1. **Cyberscript Core** (`sources/mods/lua/Cyberscript Core-.../mod/modules/housing.lua` line 54):
~~~lua
local angle = EulerAngles.new(item.Roll, item.Pitch, item.Yaw)
~~~

2. **Cyberscript Core** (`npc.lua` line 41):
~~~lua
spawnTransform:SetOrientationEuler(EulerAngles.new(angle.roll, angle.pitch, angle.yaw))
~~~

3. **Cyberscript Core** (`see.lua` line 9904 comment):
~~~lua
--EulerAngles.new(ROLL, PITCH, YAW)
~~~

4. **Cyberscript Core** (`npc.lua` line 170):
~~~lua
Game.GetTeleportationFacility():Teleport(entiwk, enti:GetWorldPosition(), EulerAngles.new(angle.roll, angle.pitch, angle.yaw))
~~~

5. **Jackie's Garage** (`coffeeWorkspot.lua` line 89):
~~~lua
GetPlayer():GetFPPCameraComponent():SetLocalOrientation(EulerAngles.new(0, currentPitch, 0):ToQuat())
~~~

6. **Shift mod** (`init.lua` line 2068):
~~~lua
fpp:SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(roll, basePitchDeg + pitch, baseYawDeg + yaw)))
~~~

7. **Tester code** (`testers/hover_rot_tester_vehicle2/init.lua` line 119 comment):
~~~lua
-- CET EulerAngles.new(roll, pitch, yaw) — confirmed by Jackie's Garage mod pattern
return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
~~~

8. **Memory solution** (user-verified empirically):
> CET's EulerAngles takes args as (roll, pitch, yaw) NOT (pitch, roll, yaw). Swapping causes pitch/roll swap that makes yaw+pitch combinations produce incorrect orientations.

**Conclusion**: The okf doc comment saying "pitch, roll, yaw" is **wrong**. Actual mod code universally uses `(roll, pitch, yaw)`. The `.roll`, `.pitch`, `.yaw` field names on EulerAngles objects confirm this order.

---

## 3. Quaternion.new() Argument Order

### Answer: **(x, y, z, w)** — confirmed by multiple sources

### Evidence

1. **Jetpack mod** (`sources/mods/lua/jetpack/core/math_vector.lua` line 215):
~~~lua
return Quaternion.new(x, y, z, w)
~~~
  - Where `x`, `y`, `z` are the imaginary components and `w` is the real component
  - Same pattern in `grappling_hook`, `low_flying_v`, `wall_hang` (all share same `math_vector.lua`)

2. **Identity quaternion** (`math_vector.lua` line 226):
~~~lua
return Quaternion.new(0, 0, 0, 1)  -- identity = (0, 0, 0, 1)
~~~

3. **Shift mod** (`init.lua` line 1157):
~~~lua
fppCamera:SetLocalOrientation(Quaternion.new(cameraSettings.Current.cameraXRotation, cameraSettings.Current.cameraYRotation, -cameraSettings.Current.cameraZRotation, 1.0))
~~~
  - Comment at line 2048: `-- Quaternion.new(X=pitch, Y=roll, Z=yaw)`
  - This maps camera rotation axes to quaternion components: X=pitch, Y=roll, Z=yaw, W=1.0

4. **Appearance Menu Mod** (`tools.lua` line 199):
~~~lua
{rot = Quaternion.new(0.0, 0.0, 0.0, 1.0)},  -- identity
~~~

5. **Tester code** (`testers/hover_rot_tester_vehicle2/init.lua` line 131):
~~~lua
-- Quaternion.new(x, y, z, w) — args are (x, y, z, w), NOT (w, x, y, z).
return Quaternion.new(q.x, q.y, q.z, q.w)
~~~

6. **Internal field access** (`math_vector.lua` lines 10-13):
~~~lua
function quat_str(quat)
    return tostring(Round(quat.i, 3)) .. ", " .. tostring(Round(quat.j, 3)) .. ", " .. tostring(Round(quat.k, 3)) .. ", " .. tostring(Round(quat.r, 3))
end
~~~
  - Quaternion has fields: `.i` (x), `.j` (y), `.k` (z), `.r` (w)
  - The constructor takes positional args mapped as (i, j, k, r) = (x, y, z, w)

7. **Memory solution** notes:
> `Quaternion.new()` is unreliable in CET — use `GetSingleton('Quaternion'):SetAxisAngle()` singleton pattern instead

**Conclusion**: `Quaternion.new(x, y, z, w)` where x/y/z are imaginary components (i, j, k) and w is the real component (r). Internal field access uses `.i`, `.j`, `.k`, `.r`.

---

## 4. Quaternion ↔ EulerAngles Conversion & Gimbal Lock

### Conversion Methods

**EulerAngles → Quaternion:**
~~~lua
-- Method 1: Instance method
local quat = EulerAngles.new(roll, pitch, yaw):ToQuat()

-- Method 2: Singleton method
local quat = GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(roll, pitch, yaw))
~~~
- Both confirmed working across dozens of mods

**Quaternion → EulerAngles:**
~~~lua
-- Method 1: Instance method
local euler = entity:GetWorldOrientation():ToEulerAngles()

-- Method 2: Singleton method
local euler = GetSingleton('Quaternion'):ToEulerAngles(quat)
~~~
- Source: `sources/mods/lua/Cyberscript Core-.../mod/modules/npc.lua` line 32, line 149

### Gimbal Lock

**Can Quaternion reliably convert to EulerAngles? No — gimbal lock is inherent.**

When pitch approaches ±90°, the roll and yaw axes become colinear (gimbal lock). The Euler representation loses a degree of freedom and the conversion becomes ambiguous.

**Evidence from tester code** (`testers/hover_rot_tester_vehicle2/init.lua` line 127-131):
~~~lua
function Quat.toGameQuat(q)
    q = Quat.normalize(q)
    -- Quaternion.new(x, y, z, w) — builds a raw quaternion WITHOUT going through Euler (no gimbal lock)
    local ok, gameQuat = pcall(function()
        return Quaternion.new(q.x, q.y, q.z, q.w)
    end)
    if ok and gameQuat then return gameQuat end
    -- Fallback through euler (lossy at gimbal lock)
    return Quat.toEuler(q):ToQuat()
end
~~~

**Pure Lua quaternion→Euler implementation** (from tester, lines 91-119):
~~~lua
function Quat.toEuler(q)
    q = Quat.normalize(q)
    local w, x, y, z = q.w, q.x, q.y, q.z
    -- Roll (x-axis rotation)
    local sinr_cosp = 2 * (w * x + y * z)
    local cosr_cosp = 1 - 2 * (x * x + y * y)
    local roll = math.atan2(sinr_cosp, cosr_cosp)
    -- Pitch (y-axis rotation)
    local sinp = 2 * (w * y - z * x)
    if math.abs(sinp) >= 1 then sinp = sinp > 0 and 1 or -1 end
    local pitch = math.asin(sinp)
    -- Yaw (z-axis rotation)
    local siny_cosp = 2 * (w * z + x * y)
    local cosy_cosp = 1 - 2 * (y * y + z * z)
    local yaw = math.atan2(siny_cosp, cosy_cosp)
    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end
~~~

**Best practice**: Use `Quaternion.new(x, y, z, w)` directly to build quaternions for `SetWorldTransform`/`SetWorldOrientation`. Only convert to EulerAngles when calling `Teleport()` (which requires EulerAngles).

---

## 5. WorldTransform Construction

### Structure (from source)

`sources/codeware/scripts/Base/Addons/WorldTransform.reds`:
~~~cs
@addField(WorldTransform)
public native let Position: WorldPosition;

@addField(WorldTransform)
public native let Orientation: Quaternion;
~~~

`sources/codeware/scripts/Base/Addons/WorldPosition.reds`:
~~~cs
@addField(WorldPosition)
public native let x: FixedPoint;
@addField(WorldPosition)
public native let y: FixedPoint;
@addField(WorldPosition)
public native let z: FixedPoint;
~~~

### Construction Pattern

~~~lua
-- Pattern 1: SetPosition + SetOrientation (Quaternion)
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(x, y, z, 1))
wt:SetOrientation(quaternion)
entity:SetWorldTransform(wt)
~~~

**Source**: `testers/hover_rot_tester_vehicle2/init.lua` lines 437-440, `sources/mods/lua, arch/Dedka Dealership.../init.lua` line 953

~~~lua
-- Pattern 2: SetPosition + SetOrientationEuler (EulerAngles)
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, pos.w or 1))
wt:SetOrientationEuler(EulerAngles.new(0, 0, yawDeg or 0))
~~~

**Source**: `sources/mods/lua, arch/RA Militech Behemoth.../init.lua` lines 253-255 (Dedratruck)

~~~lua
-- Pattern 3: Copy from entity
local wt = WorldTransform.new()
wt:SetOrientation(entity:GetWorldOrientation())
wt:SetPosition(entity:GetWorldPosition())
~~~

**Source**: `sources/mods/lua, arch/Dedka Dealership.../init.lua` line 953, Dedratruck line 199-201

### Methods Available on WorldTransform (in CET Lua)
| Method | Arg Type | Notes |
|--------|----------|-------|
| `SetPosition(Vector4)` | Vector4 | Sets world position |
| `SetOrientation(Quaternion)` | Quaternion | Sets orientation from quat |
| `SetOrientationEuler(EulerAngles)` | EulerAngles | Sets orientation from euler angles |
| `.Position` | WorldPosition | Direct field (FixedPoint x/y/z) |
| `.Orientation` | Quaternion | Direct field |

---

## 6. TeleportationFacility:Teleport() Signature

### Signature

~~~lua
Game.GetTeleportationFacility():Teleport(entity, position: Vector4, rotation: EulerAngles)
~~~

- **entity**: Any Entity/GameObject (player, NPC, vehicle)
- **position**: `Vector4.new(x, y, z, 1)` — w=1 for positions
- **rotation**: `EulerAngles.new(roll, pitch, yaw)` — **accepts EulerAngles, NOT Quaternion**

### Evidence

1. **Cyberscript Core** (`npc.lua` line 170):
~~~lua
Game.GetTeleportationFacility():Teleport(entiwk, enti:GetWorldPosition(), EulerAngles.new(angle.roll, angle.pitch, angle.yaw))
~~~

2. **Cyberscript Core** (`npc.lua` line 1203):
~~~lua
Game.GetTeleportationFacility():Teleport(Game.GetPlayer(), Game.GetPlayer():GetWorldPosition(), EulerAngles.new(0,0,-yaw))
~~~

3. **Tester code** (`hover_rot_tester_vehicle2/init.lua` lines 453-456):
~~~lua
Game.GetTeleportationFacility():Teleport(
    vehicle,
    hoverPos,    -- Vector4
    euler        -- EulerAngles
)
~~~

4. **EnemyMultiplier** (`init.lua` line 755):
~~~lua
Game.GetTeleportationFacility():Teleport(clone, newPos, EulerAngles.new(0, 0, yaw))
~~~

5. **Arrest mod** (from `okf/mods/player/teleport.md`):
~~~lua
Game.GetTeleportationFacility():Teleport(GetPlayer(), ToVector4 { x = x, y = y, z = z, w = 1 }, ...)
~~~

**Key limitation**: Teleport only accepts EulerAngles for rotation. This means quaternion→Euler conversion is unavoidable when using Teleport, introducing gimbal lock risk. Use `SetWorldTransform` with raw Quaternion to avoid this.

---

## 7. Entity Type: Player (GameObject)

### Methods for Setting Orientation

| Method | Arg Type | Source | Works? |
|--------|----------|--------|--------|
| `TeleportationFacility:Teleport(player, pos, EulerAngles)` | EulerAngles | Native CET | ✅ Yes |
| `player:GetWorldOrientation()` | Returns Quaternion | Native CET | ✅ Yes (read only) |
| `player:GetWorldPosition()` | Returns Vector4 | Native CET | ✅ Yes (read only) |
| `player:GetWorldTransform()` | Returns WorldTransform | Native CET | ✅ Yes (read only) |
| `player:GetFPPCameraComponent():SetLocalOrientation(quat)` | Quaternion | Native CET | ✅ Yes (camera only) |

### Code Examples

**Teleport player with orientation:**
~~~lua
Game.GetTeleportationFacility():Teleport(
    Game.GetPlayer(),
    Vector4.new(x, y, z, 1),
    EulerAngles.new(0, 0, yaw)  -- roll=0, pitch=0, yaw=desired
)
~~~
Source: `sources/mods/lua/Cyberscript Core-.../mod/modules/npc.lua` line 1203

**Read player orientation:**
~~~lua
local angles = GetSingleton('Quaternion'):ToEulerAngles(Game.GetPlayer():GetWorldOrientation())
-- OR
local angles = Game.GetPlayer():GetWorldOrientation():ToEulerAngles()
~~~
Source: `sources/mods/lua/Cyberscript Core-.../mod/modules/npc.lua` lines 492, 4930

**Set player camera orientation:**
~~~lua
Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(
    EulerAngles.new(roll, pitch, yaw):ToQuat()
)
~~~
Source: `sources/mods/lua, arch/Jackie's Garage.../coffeeWorkspot.lua` line 182

### Known Limitations
- Player orientation can only be set via Teleport (EulerAngles) — no direct `SetWorldOrientation` on player
- Camera orientation is separate from player body orientation
- `headingLocked = true` on FPPCameraComponent freezes camera in world space

---

## 8. Entity Type: Vehicle (gameVehicle/mounted vehicle)

### Methods for Setting Orientation

| Method | Arg Type | Source | Works? |
|--------|----------|--------|--------|
| `TeleportationFacility:Teleport(vehicle, pos, EulerAngles)` | EulerAngles | Native CET | ⚠️ Sets position+yaw only |
| `vehicle:SetWorldTransform(WorldTransform)` | WorldTransform | Codeware @addMethod | ✅ Yes (requires codeware) |
| `vehicle:SetWorldOrientation(Quaternion)` | Quaternion | Unknown origin | ⚠️ Unreliable (see below) |
| `vehicle:GetWorldOrientation()` | Returns Quaternion | Native CET | ✅ Yes (read only) |
| `vehicle:GetWorldPosition()` | Returns Vector4 | Native CET | ✅ Yes (read only) |

### SetWorldOrientation on Vehicles — Unreliable

**Memory solution notes:**
> `vehicle:SetWorldOrientation(quat)` returns nil error — method does NOT exist on vehicle objects natively.

**Dedratruck mod attempts it** (`init.lua` line 838):
~~~lua
local euler = EulerAngles.new(0, 0, targetYaw)
pcall(function()
    local quat = euler:ToQuat()
    veh:SetWorldOrientation(quat)
end)
~~~
Wrapped in pcall — suggests it may fail silently.

### Recommended Approach: SetWorldTransform (codeware)

~~~lua
local wt = WorldTransform.new()
wt:SetPosition(Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1))
wt:SetOrientation(gameQuat)  -- raw Quaternion, no gimbal lock
vehicle:SetWorldTransform(wt)
~~~
Source: `testers/hover_rot_tester_vehicle2/init.lua` lines 435-440

Entity.reds confirms `SetWorldTransform` is a codeware-added method:
~~~cs
@addMethod(Entity)
public native func SetWorldTransform(transform: WorldTransform)
~~~
Source: `sources/codeware/scripts/Entity/Entity.reds` line 17

### Teleport Fallback for Vehicles

~~~lua
local euler = gameQuat:ToEulerAngles()  -- must convert to EulerAngles
Game.GetTeleportationFacility():Teleport(vehicle, hoverPos, euler)
~~~
Source: `testers/hover_rot_tester_vehicle2/init.lua` lines 448-456

**Note**: Teleport with EulerAngles only reliably sets yaw on vehicles. Roll and pitch may not be honored.

### Known Limitations
- Vehicle physics system fights orientation changes — zero velocity each frame
- Camera system (TakeOverControl) overrides orientation every frame if not locked
- FPPCameraComponent sensitivity must be set to 0 to prevent mouse override
- `headingLocked = true` on camera is WRONG for vehicles — prevents following vehicle heading
- Teleport EulerAngles may only honor yaw on vehicles

---

## 9. Entity Type: Camera (FPPCameraComponent)

### Methods

| Method | Arg Type | Source | Works? |
|--------|----------|--------|--------|
| `cam:SetLocalOrientation(Quaternion)` | Quaternion | Native CET | ✅ Yes |
| `cam:GetLocalOrientation()` | Returns Quaternion | Native CET | ✅ Yes |
| `cam:SetLocalPosition(Vector4)` | Vector4 | Native CET | ✅ Yes |
| `cam.sensitivityMultX` | Float (property) | Native CET | ✅ Yes |
| `cam.sensitivityMultY` | Float (property) | Native CET | ✅ Yes |
| `cam.headingLocked` | Bool (property) | Native CET | ✅ Yes (use with caution) |
| `cam.pitchMin` / `cam.pitchMax` | Float (property) | Native CET | ✅ Yes |
| `cam.yawMaxLeft` / `cam.yawMaxRight` | Float (property) | Native CET | ✅ Yes |

### Code Examples

**Set camera orientation from EulerAngles:**
~~~lua
-- Pattern 1: EulerAngles:ToQuat()
Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(
    EulerAngles.new(roll, pitch, yaw):ToQuat()
)
~~~
Source: `sources/mods/lua, arch/Jackie's Garage.../coffeeWorkspot.lua` line 89

**Set camera orientation from singleton:**
~~~lua
-- Pattern 2: GetSingleton('EulerAngles'):ToQuat()
fppComp:SetLocalOrientation(GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(roll, pitch, yaw)))
~~~
Source: `sources/mods/lua/Cyberscript Core-.../mod/modules/see.lua` line 10023

**Set camera orientation from raw Quaternion:**
~~~lua
-- Pattern 3: Quaternion.new() directly
fppCamera:SetLocalOrientation(Quaternion.new(pitch, roll, -yaw, 1.0))
~~~
Source: `sources/mods/lua/Shift-.../init.lua` line 1157
Comment: `-- Quaternion.new(X=pitch, Y=roll, Z=yaw)`

**Reset camera to identity:**
~~~lua
Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(EulerAngles.new(0, 0, 0):ToQuat())
-- OR
Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(Quaternion.new(0.0, 0.0, 0.0, 1.0))
~~~
Source: `sources/mods/lua, arch/Appearance Menu Mod.../tools.lua` line 643

**Force pitch via pitchMin/Max trick:**
~~~lua
cam.pitchMin = desiredPitch - 0.01
cam.pitchMax = desiredPitch
cam:SetLocalOrientation(EulerAngles.new(roll, pitch, 0):ToQuat())
~~~
Source: Tester code pattern (from memory solution)

### Known Limitations
- Camera has its own update loop that overrides `SetLocalOrientation` every frame if mouse input isn't disabled
- Set `sensitivityMultX = 0` and `sensitivityMultY = 0` to disable mouse override
- `headingLocked = true` freezes camera in world space — do NOT use for vehicle rotation mods
- TweakDB `fppCameraParamSets.Vehicle.pitchMin/Max` also constrain camera pitch

---

## 10. Entity Type: Generic Entities (Entity base class)

### Methods (from Codeware source)

`sources/codeware/scripts/Entity/Entity.reds`:
~~~cs
@addMethod(Entity)
public native func GetTemplatePath() -> ResRef

@addMethod(Entity)
public native func GetComponents() -> array<ref<IComponent>>

@addMethod(Entity)
public native func FindComponentByType(type: CName) -> ref<IComponent>

@addMethod(Entity)
public native func AddComponent(component: ref<IComponent>)

@addMethod(Entity)
public native func ApplyMorphTarget(target: CName, region: CName, value: Float) -> Bool

@addMethod(Entity)
public native func SetWorldTransform(transform: WorldTransform)
~~~

### Methods Available in CET Lua (native + codeware)

| Method | Arg Type | Source | Works? |
|--------|----------|--------|--------|
| `entity:SetWorldTransform(WorldTransform)` | WorldTransform | Codeware @addMethod | ✅ Yes (requires codeware) |
| `entity:GetWorldOrientation()` | Returns Quaternion | Native CET | ✅ Yes |
| `entity:GetWorldPosition()` | Returns Vector4 | Native CET | ✅ Yes |
| `entity:GetWorldTransform()` | Returns WorldTransform | Native CET | ✅ Yes |
| `TeleportationFacility:Teleport(entity, pos, EulerAngles)` | EulerAngles | Native CET | ✅ Yes |
| `entity:GetForward()` / `GetWorldForward()` | Returns Vector4 | Native CET | ✅ Yes |
| `entity:GetRight()` / `GetWorldRight()` | Returns Vector4 | Native CET | ✅ Yes |

### Code Examples

**Spawn entity with WorldTransform:**
~~~lua
local transform = WorldTransform.new()
transform:SetPosition(Vector4.new(x, y, z, 1))
transform:SetOrientationEuler(EulerAngles.new(roll, pitch, yaw))
entity:SetWorldTransform(transform)
~~~
Source: `sources/mods/lua, red, arch/World Builder.../spawnable.lua` line 205

**Teleport generic entity:**
~~~lua
Game.GetTeleportationFacility():Teleport(entity, entity:GetWorldPosition(), EulerAngles.new(0, 0, yaw))
~~~
Source: `sources/mods/lua/Cyberscript Core-.../mod/modules/npc.lua` line 1562

**WorldTransform for FX spawning:**
~~~lua
local t = WorldTransform.new()
t:SetOrientation(player:GetWorldOrientation())
t:SetPosition(player:GetWorldPosition())
Game.GetFxSystem():SpawnEffect(fx, t)
~~~
Source: `sources/mods/lua, arch/RA Militech Behemoth.../init.lua` lines 199-203

---

## 11. Entity Type: Components (IComponent, IPlacedComponent)

### Source Structure

`sources/codeware/scripts/Entity/IPlacedComponent.reds`:
~~~cs
@addField(IPlacedComponent)
public native let worldTransform: WorldTransform;
~~~

`sources/codeware/scripts/Entity/IComponent.reds`:
~~~cs
@addField(IComponent)
public native let appearanceName: CName;
@addField(IComponent)
public native let appearancePath: ResRef;
@addMethod(IComponent)
public native func ChangeResource(path: ResRef, opt wait: Bool) -> Bool
@addMethod(IComponent)
public native func ChangeAppearance(name: CName, opt wait: Bool) -> Bool
@addMethod(IComponent)
public native func RefreshAppearance() -> Bool
~~~

### Methods for Components

| Method | Arg Type | Source | Works? |
|--------|----------|--------|--------|
| `component:SetLocalOrientation(Quaternion)` | Quaternion | Native CET | ✅ Yes |
| `component:GetLocalOrientation()` | Returns Quaternion | Native CET | ✅ Yes |
| `component:SetLocalPosition(Vector4)` | Vector4 | Native CET | ✅ Yes |
| `component:GetLocalPosition()` | Returns Vector4 | Native CET | ✅ Yes |
| `.worldTransform` | WorldTransform (field) | Codeware @addField | Read/write (IPlacedComponent only) |

### Code Examples

**Set component orientation via EulerAngles:**
~~~lua
local angle = EulerAngles.new(0, 0, yaw)
component:SetLocalOrientation(angle:ToQuat())
~~~
Source: `sources/mods/lua, red/NightHawk.../av.lua` line 1205

**Mesh component rotation (.reds):**
~~~redscript
mesh.SetLocalOrientation(q);
widget.SetLocalOrientation(q);
~~~
Source: `sources/mods/lua, red, arch/DyingNightCounts.../ELMDyingNightKillCounter.reds` lines 255, 258

**UI widget rotation (.reds):**
~~~redscript
this.SetLocalOrientation(EulerAngles.ToQuat(rot));
~~~
Source: `sources/mods/lua, red, arch/ImmersiveOdometerFuel0E.../VM3DOdoHUD.reds` line 242

---

## 12. Flying Vehicle Mod Patterns

### Let There Be Flight (LTBF)
- **Location**: `sources - extra/flying vehicles/let_there_be_flight_0.3.17.../red4ext/plugins/let_there_be_flight/`
- **Files found**: `module.reds`, `packed.reds`
- **Pattern**: RED4ext C++ DLL mod (not CET Lua) — orientation handled at native engine level via physics system, not accessible from Lua patterns
- **No grep matches** for orientation/rotation/Quaternion in .reds files — logic is in compiled DLL

### NanoDrone
- **Location**: `sources - extra/flying vehicles/NanoDrone 1.6.../bin/x64/plugins/cyber_engine_tweaks/mods/nanoDrone/`
- **Files**: `init.lua`, `modules/collision.lua`, localization files
- **Pattern**: CET Lua mod but no orientation-specific grep matches found — likely uses position-only Teleport without explicit rotation control

### VehicleFreeLook
- **Location**: `sources - extra/flying vehicles/VehicleFreeLook.../bin/x64/plugins/cyber_engine_tweaks/mods/VehicleFreeLook/init.lua`
- **Pattern**: Single CET Lua file — camera free-look while driving
- **No orientation grep matches** — likely modifies camera properties (sensitivity, heading) rather than explicit rotation calls

### NightHawk / Drive an Aerial Vehicle
- **Location**: `sources/mods/lua, red/NightHawk.../DriveAerialVehicle/Modules/av.lua`
- **Pattern**: Uses `component:SetLocalOrientation(angle:ToQuat())` on thruster components
~~~lua
component:SetLocalOrientation(angle:ToQuat())  -- line 1205
thruster:SetLocalOrientation(angle:ToQuat())  -- line 1209
~~~
- Sets component-level rotation, not entity-level

### ImmersiveOdometer Drone
- **Location**: `sources/mods/lua, red, arch/ImmersiveOdometerFuel0E.../VM_DroneOrbit.reds`
- **Pattern**: Uses `SetWorldTransform` on drone entity
~~~redscript
this.drone.SetWorldTransform(transform);  -- line 339
~~~

---

## 13. Wall Running Mod Patterns

### Overclocked Lynx Paws
- **Location**: `sources - extra/wall running/Overclocked Lynx Paws 27692.../`
- **Lua files**: `helpers.lua`, `phases.lua`, `init.lua`, `lynxpaw.lua`, etc.
- **Reds files**: `config.reds`, `hooks.reds`
- **Pattern**: Uses camera orientation locking during wall running, NOT player body rotation

From `helpers.lua` line 388 (in archived version `sources/mods/lua, red, arch/OverclockedLynxPaws.../helpers.lua`):
~~~lua
camComp:SetLocalOrientation(quat)
~~~

From `phases.lua` line 618:
~~~lua
camComp:SetLocalOrientation(EulerAngles.ToQuat(EulerAngles.new(0, 0, 0)))  -- reset camera
~~~

From `helpers.lua` line 108 (WorldTransform for player position):
~~~lua
local transform = WorldTransform.new()
~~~

**Key insight**: Wall running mods manipulate **camera orientation** (`SetLocalOrientation` on FPPCameraComponent), not player/entity body rotation. The player's physical orientation during wall running is handled by the game's animation system.

### Walljumping Lynx Paws & Alternative Midair Movement
- Files not directly readable in this session but follow similar patterns based on file structure
- These mods likely use impulse/velocity manipulation rather than direct orientation setting

---

## 14. Summary Matrix

### All Orientation Methods by Entity Type

| Entity Type | Method | Arg Type | Requires Codeware | Reliable | Notes |
|-------------|--------|----------|-------------------|----------|-------|
| **Player** | `TeleportationFacility:Teleport()` | EulerAngles | No | ✅ | Only way to set player orientation |
| **Player** | `GetFPPCameraComponent():SetLocalOrientation()` | Quaternion | No | ✅ | Camera only, not body |
| **Vehicle** | `SetWorldTransform()` | WorldTransform | Yes | ✅ | Best method for 6DOF |
| **Vehicle** | `SetWorldOrientation()` | Quaternion | Unknown | ⚠️ | Unreliable, may not exist natively |
| **Vehicle** | `TeleportationFacility:Teleport()` | EulerAngles | No | ⚠️ | Yaw only, roll/pitch unreliable |
| **Camera** | `SetLocalOrientation()` | Quaternion | No | ✅ | Most widely used pattern |
| **Camera** | `sensitivityMultX/Y = 0` | Float | No | ✅ | Disables mouse override |
| **Entity (generic)** | `SetWorldTransform()` | WorldTransform | Yes | ✅ | Works on all Entity subclasses |
| **Entity (generic)** | `TeleportationFacility:Teleport()` | EulerAngles | No | ✅ | Native, but Euler only |
| **Component** | `SetLocalOrientation()` | Quaternion | No | ✅ | Local space rotation |
| **Component** | `.worldTransform` | WorldTransform | Yes | ✅ | Direct field access (IPlacedComponent) |

### Constructor Argument Orders

| Type | Constructor | Arg Order | Evidence |
|------|------------|-----------|---------|
| **EulerAngles** | `EulerAngles.new(a, b, c)` | **(roll, pitch, yaw)** | 50+ mod files, `.roll`/`.pitch`/`.yaw` field names |
| **Quaternion** | `Quaternion.new(a, b, c, d)` | **(x, y, z, w)** = (i, j, k, r) | jetpack, Shift, AMM mods; `.i`/`.j`/`.k`/`.r` fields |
| **Vector4** | `Vector4.new(a, b, c, d)` | **(x, y, z, w)** | Universal, w=1 positions, w=0 directions |
| **WorldTransform** | `WorldTransform.new()` | No args | Then use SetPosition/SetOrientation |

### Key Gotchas

1. **EulerAngles order is (roll, pitch, yaw)** — NOT (pitch, roll, yaw) despite okf doc comment
2. **Quaternion.new takes (x, y, z, w)** — NOT (w, x, y, z)
3. **Quaternion internal fields are `.i`, `.j`, `.k`, `.r`** — NOT `.x`, `.y`, `.z`, `.w`
4. **Teleport only accepts EulerAngles** — quaternion→Euler conversion introduces gimbal lock risk
5. **SetWorldTransform requires Codeware** — it's an `@addMethod` not a native method
6. **SetWorldOrientation is unreliable on vehicles** — may not exist natively
7. **Camera `headingLocked = true` is wrong for vehicles** — freezes camera in world space
8. **Vehicle physics fights orientation changes** — zero velocity each frame with PSMImpulse
9. **`Quaternion.new()` may be unreliable in CET** — prefer `GetSingleton('Quaternion'):SetAxisAngle()` singleton pattern
10. **Gimbal lock at pitch ±90°** — use raw quaternions (SetWorldTransform) instead of EulerAngles (Teleport) for full 6DOF

---

## Source File Index

| Source | Path |
|--------|------|
| okf vector-math | `okf/mods/modding/cet-runtime/vector-math.md` |
| okf singleton-access | `okf/mods/modding/cet-runtime/singleton-access.md` |
| okf camera | `okf/mods/ui/camera.md` |
| okf teleport | `okf/mods/player/teleport.md` |
| okf entity | `okf/codeware/entity.md` |
| okf vehicle | `okf/codeware/vehicle.md` |
| okf world addons | `okf/codeware/addons/world.md` |
| Entity.reds | `sources/codeware/scripts/Entity/Entity.reds` |
| WorldTransform.reds | `sources/codeware/scripts/Base/Addons/WorldTransform.reds` |
| WorldPosition.reds | `sources/codeware/scripts/Base/Addons/WorldPosition.reds` |
| IComponent.reds | `sources/codeware/scripts/Entity/IComponent.reds` |
| IPlacedComponent.reds | `sources/codeware/scripts/Entity/IPlacedComponent.reds` |
| GameObject.reds | `sources/codeware/scripts/Entity/GameObject.reds` |
| Jetpack math | `sources/mods/lua/jetpack/core/math_vector.lua` |
| Tester v2 | `testers/hover_rot_tester_vehicle2/init.lua` |
| Tester v1 | `testers/hover_rot_tester_vehicle/init.lua` |
| Tester notes | `testers/hover_rot_tester_vehicle/RESEARCH_NOTES.md` |
| Dedratruck | `sources/mods/lua, arch/RA Militech Behemoth.../Dedratruckcustom/init.lua` |
| Shift mod | `sources/mods/lua/Shift-.../init.lua` |
| Cyberscript | `sources/mods/lua/Cyberscript Core-.../mod/modules/` |
| Jackie's Garage | `sources/mods/lua, arch/Jackie's Garage.../` |
| AMM | `sources/mods/lua, arch/Appearance Menu Mod.../` |
| NightHawk | `sources/mods/lua, red/NightHawk.../DriveAerialVehicle/Modules/av.lua` |
| OverclockedLynxPaws | `sources - extra/wall running/Overclocked Lynx Paws.../` |
| LTBF | `sources - extra/flying vehicles/let_there_be_flight.../` |
| NanoDrone | `sources - extra/flying vehicles/NanoDrone.../` |
| VehicleFreeLook | `sources - extra/flying vehicles/VehicleFreeLook.../` |
| World Builder | `sources/mods/lua, red, arch/World Builder.../` |
| Native Interactions | `sources/mods/lua, red, arch/Native Interactions Framework.../` |
| CyberTrials | `sources/mods/lua, arch/CyberTrials.../` |
| Gambling System | `sources/mods/lua, arch/Gambling System - Roulette.../` |
| Story Quest Fixes | `sources/mods/lua, arch/Cyberpunk Story Quest Fixes/` |
| ImmersiveOdometer | `sources/mods/lua, red, arch/ImmersiveOdometerFuel0E.../` |
| DyingNightCounts | `sources/mods/lua, red, arch/DyingNightCounts.../` |
