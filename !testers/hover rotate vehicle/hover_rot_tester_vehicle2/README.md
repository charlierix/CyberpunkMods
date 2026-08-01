### How it works

No entity spawning — you sit in a real vehicle, push the toggle hotkey, and the mod:

1. **Gets your mounted vehicle** via `Game.GetMountedVehicle(player)`
2. **Locks the player's FPPCameraComponent** (which vehicles DO use):
   - `sensitivityMultX = 0`, `sensitivityMultY = 0` — disables mouse override
   - `headingLocked = true` — locks heading
   - `pitchMin = -180`, `pitchMax = 180`, `yawMaxLeft/Right = 360` — full range
3. **Sets TweakDB flats** for `fppCameraParamSets.Vehicle.pitchMin/Max` to ±180° (same as VehicleFreeLook)
4. **Hovers vehicle** at 5m above ground (continuous teleport + velocity zeroing)
5. **Applies quaternion rotations** to the vehicle via `SetWorldOrientation` + position-only `Teleport`

### Why this should work where vehicle1 failed

| Issue | Vehicle1 (drone entity) | Vehicle2 (real vehicle) |
|---|---|---|
| Camera component | `entVirtualCameraComponent` (no locking props) | `FPPCameraComponent` (has all locking props) |
| Camera system | `SurveillanceCameraController` (own update) | Vehicle FPP camera (standard system) |
| Mouse override | Can't be locked (no sensitivity props) | `sensitivityMultX/Y = 0` stops it |
| Pitch range | Entity-level `maxPitch` only | `FPPCameraComponent.pitchMin/Max` + TweakDB |

### 7 hotkeys (Settings > Key Bindings > HoverRotTesterVehicle2)

| Hotkey | Label |
|---|---|
| `HRTV2_Toggle` | Toggle Hover (Vehicle2) |
| `HRTV2_YawPos` | Yaw +30 (Vehicle2) |
| `HRTV2_YawNeg` | Yaw -30 (Vehicle2) |
| `HRTV2_PitchPos` | Pitch +30 (Vehicle2) |
| `HRTV2_PitchNeg` | Pitch -30 (Vehicle2) |
| `HRTV2_RollPos` | Roll +30 (Vehicle2) |
| `HRTV2_RollNeg` | Roll -30 (Vehicle2) |

### Install

```
bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_vehicle2/
```

### Test steps

1. Get in any vehicle
2. Press the toggle hotkey
3. Look for `FPPCameraComponent locked` in CET console (this is the key indicator)
4. Push rotation hotkeys — they should now visually rotate the vehicle/camera
5. Press toggle again to deactivate (restores all camera settings)

Please share the CET console output — especially whether `camFound=true` and `FPPCameraComponent locked` appears.