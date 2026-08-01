## Let There Be Flight vs Hover Vehicle Tester 2 — Approach Comparison

### Architecture: Fundamentally Different

**Let There Be Flight (LTBF)** is a **RED4ext C++ plugin** — it ships a native `.dll` that hooks directly into Cyberpunk's physics engine. It does **not** use `PhysicalImpulseEvent` at all (that code is commented out at line 880). Instead, it writes `force` and `torque` directly to the vehicle's `physicsData` struct in native memory every frame.

**Tester 2** is a **pure CET Lua mod** — it uses `PhysicalImpulseEvent:QueueEvent()` as the only available physics interface from Lua. There's no DLL, no direct memory access, and no native physics hooks.

This is the single biggest difference and it cascades into everything else.

---

### Detailed Comparison

| Aspect | Tester 2 (CET Lua) | Let There Be Flight (RED4ext C++) |
|--------|--------------------|-----------------------------------|
| **Force application** | `PhysicalImpulseEvent` via `QueueEvent()` — spherical impulse at a world position | Writes directly to `vehicle->physicsData->force` / `->torque` raw struct fields |
| **Torque control** | Avoided by applying at center of mass (zero torque arm) | **Actively computed** — pitch/roll/yaw PID controllers generate corrective torque |
| **Coordinate space** | World space (impulse is world coords) | Local space first, then `force = orientation * force` to convert to world |
| **Gravity** | Compensated per-frame as anti-gravity delta-v | `EnableGravity(false)` disables it entirely, then manual gravity force added |
| **Velocity reading** | Estimated from position delta / deltaTime | `vehicle.GetLinearVelocity()` and `GetAngularVelocity()` — native, exact |
| **Angular velocity** | Not used | Read via `GetAngularVelocity()`, used for angular damping and aero dynamics |
| **Control algorithm** | Simple spring-damper (Kp/Kd) for Z height | PID controllers: `hoverGroundPID`, `pitchPID`, `rollPID`, `aeroYawPID`, `pitchAeroPID` |
| **Hover mode** | Spring-damper to `groundZ + HOVER_HEIGHT` | `FindGround(normal)` + `hoverGroundPID.GetCorrectionClamped(heightDiff)` + lift factor |
| **Orientation correction** | None (pure translation) | Aligns vehicle up vector to ground normal via pitch/roll PID corrections |
| **Mass handling** | `force = dv * mass` (correct) | `force *= stats.s_mass` (same approach) |
| **Inertia tensor** | Not used (no torque) | Considers inertia tensor and thruster positions for torque scaling |
| **External impulses** | Vehicle receives collision impulses normally | Hooks block `ApplyForceAtPosition` / `ApplyTorqueAtPosition` when flight is active |
| **Collision recovery** | None | Collision timer dampens force/torque for a recovery period |
| **Damping** | `DAMPING_K * velocity` (simple) | Linear + angular damping with brake factors, air resistance, speed ratio |
| **Aerodynamics** | None | Yaw/pitch directionality factors, aero corrections based on speed ratio |
| **Input** | Toggle on/off only | Full 6DOF: surge, lift, sway, yaw, pitch, roll, linear brake, angular brake |
| **Thruster positions** | Single center point | 4 thrusters at wheel positions — `thrusterTensor` scales torque per axis |
| **Strength** | 10% boost via `STRENGTH_MULT = 1.1` | Configurable per-axis factors (surge=15, lift=25, hover=10, yaw=2.5, etc.) |

---

### Key Takeaways for Your Hover Project

**1. LTBF doesn't use `PhysicalImpulseEvent`**

The commented-out code at line 880 shows they tried it:
```reds
// let impulseEvent: ref<PhysicalImpulseEvent> = new PhysicalImpulseEvent();
// impulseEvent.radius = 1.0;
// impulseEvent.worldPosition = Vector4.Vector4To3(evt.worldPosition);
// impulseEvent.worldImpulse = new Vector3(0.0, 0.0, 10000.0);
// vehicle.QueueEvent(impulseEvent);
```
They abandoned it in favor of a native DLL that applies force/torque directly. This suggests `PhysicalImpulseEvent` has limitations for continuous flight control — which aligns with the issues you saw in tester 1.

**2. LTBF disables gravity entirely**

Instead of compensating gravity each frame (`antiGravDV = g * delta`), LTBF calls `EnableGravity(false)` once on activation, then adds gravity back as a manual force. This is more stable because there's no per-frame gravity cancellation timing issue. From CET Lua, you may not have access to `EnableGravity()` — it's a native function LTBF adds via `@addMethod(VehicleObject)`.

**3. LTBF reads velocity natively**

Your tester estimates velocity from `pos - prevPos / delta`, which has frame-to-frame jitter and lag. LTBF calls `vehicle.GetLinearVelocity()` directly — exact, no lag. If this native function is accessible from CET, it would significantly improve your damper.

**4. LTBF uses PID controllers, not spring-damper**

Your spring-damper (`SPRING_K * err - DAMPING_K * vel`) is a basic PD controller. LTBF uses full PID controllers with clamping, which are more stable for large errors and prevent oscillation. The hover PID uses `GetCorrectionClamped(heightDifference, timeDelta, clamp)`.

**5. LTBF actively manages torque for orientation**

Your tester2 avoids torque entirely (center of mass impulse). LTBF **uses torque as a feature** — PID controllers compute pitch/roll corrections to keep the vehicle level and aligned with the ground normal. The 4 thrusters at wheel positions create a stable platform.

**6. LTBF blocks external physics events**

LTBF hooks and blocks the game's own impulse/force functions when flight is active, preventing collision impulses from knocking the vehicle around. Without this, your hover vehicle will get knocked around by collisions and terrain contact.

---

### Native C++ Implementation (from repo source)

Source: `sources - extra/flying vehicles/let_there_be_flight - repo/src/red4ext/`

#### How force is actually applied (`Flight/Component.cpp`, lines 57-83)

The `FlightComponent::OnUpdate()` C++ method runs after the REDscript `OnUpdate()` completes. It reads the `force` and `torque` Vector4 properties that the REDscript code accumulated, and writes them directly to the vehicle's raw physics struct:

```cpp
void FlightComponent::OnUpdate(float deltaTime) {
    // ... type checks ...
    if (this->hasUpdate) {
        vehicle->ForceEnablePhysics();
        // Run the REDscript OnUpdate (which accumulates force/torque)
        ExecuteFunction(this, this->nativeType->GetFunction("OnUpdate"), nullptr, deltaTime);
        // Write directly to physicsData — no events, no impulses
        vehicle->physicsData->force += this->force.AsVector3();
        vehicle->physicsData->torque += this->torque.AsVector3();
        // Reset for next frame
        this->force = Vector4();
        this->torque = Vector4();
    }
}
```

This is the critical difference: `vehicle->physicsData->force` is a **raw field on the physics rigid body struct**, not an event. The physics engine reads it directly during its integration step. There is no `PhysicalImpulseEvent`, no `QueueEvent`, no radius sphere, no collision body intersection test — just a direct force accumulator.

#### Native method implementations (`Extensions/VehicleObject.cpp`)

All the `@addMethod(VehicleObject)` native functions are thin C++ wrappers that read/write the `physicsData` struct:

```cpp
// Direct struct field access — no API calls
inline RED4ext::Vector3 GetCenterOfMass()    { return this->physicsData->centerOfMass; }
inline RED4ext::Vector3 GetAngularVelocity() { return this->physicsData->angularVelocity; }
inline void EnableGravity(bool gravity)      { this->physicsData->unk1B0 = gravity; }
inline bool HasGravity()                     { return this->physicsData->unk1B0; }
inline RED4ext::Matrix GetInertiaTensor()    { return this->physicsData->localInertiaTensor; }
```

These are **not** standard game API functions — they are private struct fields that LTBF accesses via memory layout knowledge. The `physicsData` pointer comes from the vehicle's native `vehicle::BaseObject` class, and fields like `unk1B0` (gravity flag) are reverse-engineered offsets. These functions simply **do not exist** in vanilla CET — they are injected by the RED4ext plugin's RTTI expansion system.

#### Physics hooks (`Physics/VehiclePhysicsUpdate.cpp`)

LTBF installs function hooks (via hash-based detours) on several internal physics methods. When flight is active, these hooks **block** the game's normal physics behavior:

| Hook | Hash | What it does when flight is active |
|------|------|-------------------------------------|
| `ApplyForceAtPosition` | 611586815 | **Blocks** all external force application (collisions, impacts, etc.) |
| `ApplyTorqueAtPosition` | 3303544265 | **Blocks** all external torque application |
| `VehicleHelperUpdate` | 3281786499 | Zeros `driveHelpers.size` — disables ground driving helpers |
| `VehicleUpdateOrientationWithPID` | 1414536155 | **Blocks** the game's orientation PID (road alignment) |
| `CarSuspension_AnimationUpdate` | 2879787320 | Feeds roll input into `turnInput` for car animation |
| `BikeSuspension_AnimationUpdate` | 3191280029 | Disables bike tilt control and turn rate |
| `ProcessAirResistance` | 2526549425 | Skips air resistance below 100 m/s |

The `ApplyForceAtPosition` and `ApplyTorqueAtPosition` hooks are the implementation behind the `ignoreImpulses` behavior. When `fc->active` is true, these functions simply return without calling the original — making the vehicle immune to all external physical interactions during flight.

#### What this means for CET-only mods

The C++ source confirms that **none of LTBF's physics approach is reproducible from CET Lua**:

- **`physicsData->force` direct write** — requires C++ pointer access to the vehicle's internal physics struct. CET has no equivalent.
- **`EnableGravity()` / `HasGravity()`** — reads/writes `physicsData->unk1B0`, a reverse-engineered offset. Injected as a native method by the RED4ext RTTI system. Not available in vanilla CET.
- **`GetAngularVelocity()`** — reads `physicsData->angularVelocity`. Same — injected native, not vanilla.
- **`GetLinearVelocity()`** — this one may exist as a vanilla vehicle method (it's used in the REDscript `FlightStats.UpdateDynamic()` without being in the `@addMethod` list, suggesting it might be a built-in).
- **Collision impulse blocking** — requires function detour hooks on internal physics methods. Impossible from CET.

The only potential avenue for a CET-only mod is if `GetLinearVelocity()` is a vanilla native on `VehicleObject` or a parent class. If it is, it would eliminate the position-delta velocity estimation in tester2. Worth testing from CET.

---

### What Tester 2 Could Borrow (if native functions are CET-accessible)

| Improvement | How | Why | CET-accessible? |
|-------------|-----|-----|-----------------|
| Read velocity natively | `vehicle:GetLinearVelocity()` | Eliminates position-delta jitter, better damping | Maybe — not in LTBF's `@addMethod` list |
| Disable gravity | `vehicle:EnableGravity(false)` on activate, `true` on deactivate | More stable than per-frame compensation | No — LTBF-injected native |
| Read angular velocity | `vehicle:GetAngularVelocity()` | Enable active orientation correction | No — LTBF-injected native |
| Block collision impulses | Hook `ApplyForceAtPosition` | Prevent terrain/collision knockback | No — requires C++ detour hooks |
| PID controller | Implement PID in Lua | More stable hover than spring-damper | Yes — pure math |
| Ground normal | Raycast + read hit normal | Align vehicle to slopes, not just world-up | Yes — raycast API exists |

The native functions `GetLinearVelocity()`, `GetAngularVelocity()`, `EnableGravity()`, `HasGravity()`, `GetCenterOfMass()`, and `ForceEnablePhysics()` are added to `VehicleObject` by LTBF's RED4ext plugin via C++ RTTI expansion — they do **not** exist in vanilla CET. Testing whether `GetLinearVelocity()` is a built-in vanilla method would be a worthwhile next step, as it's the only one that might already exist.
