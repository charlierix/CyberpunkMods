# Hover Rot Tester Vehicle — Research Notes

## Goal

Create a CET tester mod that:
- Toggles hover mode with a single hotkey
- When active: hovers player a few meters above ground
- 6 hotkeys for ±30° yaw, pitch, roll
- Uses an entity-bound camera for true 6DOF (avoiding the euler tester's gimbal lock and world-locked mouse pitch issues)

## Approach

Bind the player camera to a spawned drone entity via `OnToggleTakeOverControl` (NanoDrone pattern), then rotate the entity with quaternion math.

## What Works

- ✅ Entity spawning (`exEntitySpawner.Spawn`)
- ✅ Camera binding (`OnToggleTakeOverControl`)
- ✅ Player hover (continuous teleport + velocity zeroing)
- ✅ Quaternion math (proper rotation combination, no gimbal lock)
- ✅ Hotkey registration (7 root-level `registerHotkey` calls)
- ✅ Spawn timeout and error handling
- ✅ Diagnostic component enumeration

## What Doesn't Work Yet

### Problem: Camera system overrides programmatic rotation

The TakeOverControl camera system processes mouse input every frame and overwrites any orientation we set via `SetWorldOrientation` or `Teleport` EulerAngles. Hotkey rotations log correctly but produce no visual change.

### Problem: Wrong camera component type

The drone entity (`base\nano_drone\drone.ent`) has these camera-related components:

| Component | Type |
|---|---|
| `entVirtualCameraComponent` | Virtual camera (not FPP) |
| `gameCameraComponent` | Base camera component |
| `gameDeviceCameraControlComponent` | Device camera control |
| `SurveillanceCameraController` | Surveillance camera controller |

**It does NOT have `FPPCameraComponent`**, so our sensitivity/headingLocked locking code (`camFound=false`) had no effect.

### Problem: Screen warping

With `TakeOverControlSystem.isInputLockedFromQuest = true`, the screen warps — rotating one way then back each frame. This means our `SetWorldOrientation` and the camera system's own update are fighting each frame.

### Problem: Mouse axis swap after TCS lock

| State | Mouse X (yaw) | Mouse Y (pitch) |
|---|---|---|
| No lock (before) | No effect | Controlled pitch |
| TCS input locked | Controlled yaw | No effect |

The TCS input lock partially works (changes which mouse axis is active) but doesn't fully prevent the camera system from updating orientation.

## Key API Discoveries

### TakeOverControlSystem (WolvenKit decompiled)

Location: `sources/WolvenKit/WolvenKit.RED4/Types/Classes/TakeOverControlSystem.cs`

Key fields:
- `controlledObject` — weak handle to the controlled entity
- `isInputRegistered` — whether input is being processed
- `isInputLockedFromQuest` — **locks all camera input when true** (partially works)
- `isChainForcedFromQuest` — forces control chain
- `TCSupdateRate` — update interval (default 0.1s)

Access from CET:
```lua
local tcs = Game.GetScriptableSystemsContainer():Get(CName.new('TakeOverControlSystem'))
```

### FPPCameraComponent (WolvenKit decompiled)

Location: `sources/WolvenKit/WolvenKit.RED4/Types/Classes/gameFPPCameraComponent.cs`

Key fields:
- `pitchMin`, `pitchMax` — pitch range (in degrees)
- `yawMaxLeft`, `yawMaxRight` — yaw range
- `headingLocked` — locks heading
- `sensitivityMultX`, `sensitivityMultY` — mouse sensitivity multipliers

**Problem**: The drone entity doesn't have this component. It uses `entVirtualCameraComponent` instead.

### NanoDrone patterns (from source)

Location: `sources - extra/flying vehicles/NanoDrone 1.6-.../`

Key insights:
- `drone:move()` NEVER sets orientation programmatically — only teleports for position
- `Teleport(self.handle, self.pos, self.handle:GetWorldOrientation():ToEulerAngles())` — preserves entity's own orientation
- `maxPitch = 3` (entity-level property, in degrees)
- Rotation is controlled entirely by mouse via the TakeOverControl camera system
- NanoDrone does NOT implement programmatic rotation at all

### VehicleFreeLook (trivial)

Just sets TweakDB flats:
```lua
TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMax", 60)
TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMin", -60)
```

### Cyberscript Core camera locking example

```lua
-- From location.lua
Game.GetPlayer():GetFPPCameraComponent().pitchMin = rot.pitch - 0.01
Game.GetPlayer():GetFPPCameraComponent().pitchMax = rot.pitch
Game.GetPlayer():GetFPPCameraComponent():SetLocalOrientation(
    GetSingleton('EulerAngles'):ToQuat(EulerAngles.new(rot.roll, 0, 0))
)
```

This works on the **player's** FPPCameraComponent, not on a drone entity's VirtualCameraComponent.

## Component Source Analysis (WolvenKit decompiled)

### entVirtualCameraComponent
Location: `sources/WolvenKit/.../entVirtualCameraComponent.cs`

Fields: `virtualCameraName`, `resolutionWidth`, `resolutionHeight`, `drawBackground`, `isEnabled`

**NO orientation, sensitivity, or locking properties.** Just render settings.

### gameCameraComponent (base)
Fields: FOV/zoom/DOF animation params, `fovOverrideWeight`, `zoomOverrideWeight`, weapon plane params

**NO orientation, sensitivity, or locking properties.** Just camera rendering params.

### gameDeviceCameraControlComponent
**EMPTY class** — no fields at all. Just a marker/component type.

### gameTransformAnimatorComponent
Fields: `animations` (array of `gameTransformAnimationDefinition`)

Could potentially be used for orientation animation, but requires constructing animation definitions.

### SurveillanceCameraController
This is the actual camera controller on the drone entity. It's a device controller, NOT an FPP camera system. The TakeOverControl system binds to this controller, which has its own internal orientation update mechanism.

## Root Cause: Wrong Camera System Type

The drone entity (`base\nano_drone\drone.ent`) uses a **surveillance camera system**:
- `SurveillanceCameraController` — device-based camera controller
- `entVirtualCameraComponent` — virtual camera for rendering
- `gameDeviceCameraControlComponent` — device camera control marker

It does NOT use the **FPP camera system** that vehicles and the player use:
- No `FPPCameraComponent` (which has `sensitivityMultX/Y`, `headingLocked`, `pitchMin/Max`, `yawMaxLeft/Right`)
- No `fppCameraParamSets` TweakDB entries
- The surveillance camera controller has its own internal orientation update that overrides `SetWorldOrientation` every frame

This explains:
- Why `camFound=false` (no FPPCameraComponent to lock)
- Why screen warps (our SetWorldOrientation fights the surveillance controller)
- Why mouse behavior is different from FPP (surveillance camera has different input handling)
- Why hotkeys have no visual effect (orientation overridden before render)

## Next Steps to Investigate

1. **Try a real vehicle entity** — vehicles have `FPPCameraComponent` with `sensitivityMultX/Y` and `headingLocked`, plus `fppCameraParamSets.Vehicle` TweakDB entries. LTBF already does flying vehicles with 6DOF.
2. **Consider Redscript** — hook the camera update function (e.g., `SurveillanceCameraController` update or `TakeOverControlSystem` update) to inject our orientation after mouse processing
3. **Try `gameTransformAnimatorComponent`** — add a transform animation definition that sets orientation
4. **Try `Observe` on SurveillanceCameraController** — hook its update method to override orientation after it processes input
5. **Research `vehicleCameraManagerComponent`** — vehicles have this component for camera management

## File Reference

- Mod file: `testers/hover_rot_tester_vehicle/init.lua` (539 lines)
- Entity: `base\nano_drone\drone.ent` (requires NanoDrone mod installed)
- WolvenKit source: `sources/WolvenKit/WolvenKit.RED4/Types/Classes/`
- NanoDrone source: `sources - extra/flying vehicles/NanoDrone 1.6-.../`
