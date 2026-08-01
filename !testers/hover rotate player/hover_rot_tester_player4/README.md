### What it does

Same structure as vehicle2 but targets the **player** with `TeleportationFacility:Teleport()`:

```
Game.GetTeleportationFacility():Teleport(
    player,
    Vector4.new(hoverX, hoverY, hoverZ, 1),
    targetEuler    -- full EulerAngles(roll, pitch, yaw) from quaternion
)
```

The quaternion→EulerAngles conversion is the same proven path from vehicle2 (`Quat.toEuler` → `EulerAngles.new(roll, pitch, yaw)`), so it sends **all 3 axes**, not just yaw.

### 8 hotkeys

| Hotkey | Action |
|-------|--------|
| Toggle Hover | Start/stop hover + camera lock |
| Yaw ±30 | Rotate around Z |
| Pitch ±30 | Rotate around X |
| Roll ±30 | Rotate around Y |
| Toggle Quat-Direct | Try passing `Quaternion` as 3rd arg instead of `EulerAngles` — tests for undocumented overload |

### Diagnostic output (3 frames after each rotation)

- **Target euler**: what we asked for
- **BEFORE Teleport**: current player orientation
- **Teleport(EulerAngles) SUCCESS/FAILED**: whether the call errored
- **AFTER Teleport**: what the player orientation actually is
- **MATCH: roll=X pitch=X yaw=X**: whether each axis stuck (within 1°)
- **CAM**: camera local orientation + sensitivity state

### Key differences from vehicle2

| Aspect | Vehicle2 | Player4 |
|--------|----------|---------|
| Target entity | `Game.GetMountedVehicle(player)` | `Game.GetPlayer()` directly |
| Orientation method | `gameQuat:ToEulerAngles()` | `Quat.toEuler(state.quat)` — same math, pure Lua |
| Hover target | Vehicle position + height | Player position + height |
| Quat-direct test | No | Yes — toggle hotkey tests if Teleport accepts Quaternion |
| SetWorldOrientation | Tried (failed) | Not attempted — already proven no-op |

### What to look for in the log

1. **If `MATCH: roll=true pitch=true yaw=true`** → Teleport with full EulerAngles works! We have our rotation method.
2. **If only `yaw=true`** → Locomotion is still overriding roll/pitch even through Teleport. Next step: tester 5 with `EnableTransformUpdates(false)`.
3. **If `Teleport(Quaternion) SUCCESS`** → there's an undocumented overload that takes Quaternion directly.
4. **If `Teleport(EulerAngles) FAILED`** → the signature differs for players vs vehicles.

### Install

Copy to `bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player4`, bind hotkeys in Settings > Key Bindings, press Toggle, then press a rotation key and check the CET console.