# Let There Be Flight — C++ Hook Architecture

> **Source:** `sources - extra/flying vehicles/let_there_be_flight - repo/src/red4ext/`

## Overview

Let There Be Flight (LTBF) is a **RED4ext C++ plugin** that adds 6DOF flight to Cyberpunk 2077 vehicles. Unlike CET Lua mods (which are limited to `PhysicalImpulseEvent` and event-based APIs), LTBF hooks directly into the game's native physics engine to:

- Write `force` and `torque` directly to `vehicle->physicsData` raw struct fields
- Disable gravity via direct struct field manipulation (`physicsData->unk1B0`)
- Block external collision impulses via function detour hooks
- Read exact velocity/angular velocity from native struct fields
- Register custom RTTI types as first-class game systems

---

## Architecture: RTTI Type System

LTBF uses Cyberpunk's native RTTI (Run-Time Type Information) system to register custom C++ classes as if they were native game types. This allows the plugin to create game systems, scriptable objects, and entity components that the engine treats identically to built-in ones.

### Class Hierarchy

```mermaid
classDiagram
    class game_IGameSystem {
        +OnWorldAttached(scene)
        +OnWorldDetached(scene)
        +OnGameSave(stream)
        +OnGameLoad(stream)
        +OnGamePaused()
        +OnGameResumed()
        +OnInitialize(job)
        +OnUninitialize()
        +OnRegisterUpdates(registrar)
    }

    class IFlightSystem {
        <<abstract>>
        +RegisterComponent(handle) void
        +UnregisterComponent(handle) void
        -OnRegister(descriptor)*
        -OnDescribe(descriptor, rtti)*
    }

    class FlightSystem {
        +int32_t cameraIndex
        +WeakHandle~FlightComponent~ playerComponent
        +Handle~FlightAudio~ audio
        +unordered_map~uint64_t, WeakHandle~ flightComponents
        +SharedSpinLock flightComponentsMutex
        +GetInstance() Handle~FlightSystem~
        +RegisterComponent(handle) void
        +UnregisterComponent(handle) void
        +OnWorldAttached(scene)
        +OnBeforeWorldDetach(scene)
        +OnGameLoad(job, success, stream)
        +OnGameRestored() bool
        +OnStreamingWorldLoaded(scene, a2, job)
    }

    class IScriptable {
        <<RED4ext native>>
    }

    class FlightController {
        +bool enabled
        +bool active
        +int32_t mode
        +GetInstance() Handle~FlightController~
    }

    class FlightSettings {
        +GetInstance() Handle~FlightSettings~
        +GetFloat(name) float
        +SetFloat(name, value) void
        +GetVector3(name) Vector3
        +GetBool(name) bool
        +GetProperty~T~(name) T
    }

    class IFlightConfiguration {
        +WeakHandle~FlightComponent~ component
        +DynArray~Handle~IFlightThruster~~ thrusters
        +CName flightCameraBone
        +Vector3 flightCameraOffset
        +int32_t originalShapeCount
        +Setup(vehicle) void
        +AddSlots(slotComponent) void
        +AddColliders() void
        +RemoveColliders() void
        +OnActivationCore() void
        +OnDeactivationCore() void
        +GetConfigurationClass(entity) CClass*
    }

    class FlightComponent {
        +Vector4 force
        +Vector4 torque
        +bool active
        +bool hasUpdate
        +Handle~IFlightConfiguration~ configuration
        +OnUpdate(deltaTime) void
        +Get(vehicle) FlightComponent*
    }

    class FlightThruster {
        +Vector3 position
        +float power
    }

    game_IGameSystem <|-- IFlightSystem
    IFlightSystem <|-- FlightSystem
    IScriptable <|-- FlightController
    IScriptable <|-- FlightSettings
    IScriptable <|-- IFlightConfiguration
    IFlightConfiguration o-- FlightComponent : component
    IFlightConfiguration *-- FlightThruster : thrusters
    FlightSystem o-- FlightComponent : flightComponents map
    FlightComponent *-- IFlightConfiguration : configuration
```

### How RTTI Registration Works

LTBF uses a template-based RTTI system (`Engine::RTTIClass<Derived, Base>`) that hooks into RED4ext's `CRTTISystem`. Each class provides two static callbacks:

| Callback | Purpose |
|----------|---------|
| `OnRegister(Descriptor*)` | Sets class flags (abstract, native, import-only) |
| `OnDescribe(Descriptor*, CRTTISystem*)` | Registers functions, properties, and methods visible to REDscript |

**Example — `FlightController` registration:**

```cpp
RTTI_DEFINE_CLASS(FlightController, {
  RTTI_METHOD(GetInstance);
  RTTI_PROPERTY(enabled);
  RTTI_PROPERTY(active);
  RTTI_PROPERTY(mode);
});
```

This makes `FlightController.enabled`, `.active`, `.mode`, and `GetInstance()` directly accessible from REDscript — as if it were a native game class.

**Offset assertions** enforce struct layout correctness:

```cpp
RED4EXT_ASSERT_OFFSET(FlightSystem, cameraIndex, 0x48);
RED4EXT_ASSERT_OFFSET(FlightSystem, flightComponents, 0x70);
RED4EXT_ASSERT_OFFSET(FlightController, enabled, 0x40);
```

---

## Architecture: Hook System

LTBF installs **function detour hooks** on internal physics methods. When flight is active, these hooks intercept and modify the game's normal physics behavior.

### Hook Framework

```mermaid
classDiagram
    class IFlightModuleHook {
        <<interface>>
        +Load(sdk, handle) void
        +Unload(sdk, handle) void
    }

    class FlightModuleHook {
        +string m_name
        +uintptr_t m_address
        +void* m_hook
        +void** m_original
        +Load(sdk, handle) void
        +Unload(sdk, handle) void
    }

    class FlightModuleHookHash {
        +FlightModuleHookHash(name, hash, hook, original)
        +m_address = Resolve(hash) - moduleBase
    }

    class FlightModuleFactory {
        -vector~loads~ s_loads
        -vector~unloads~ s_unloads
        -vector~registers~ s_registers
        -vector~hooks~ s_hooks
        +GetInstance() FlightModuleFactory&
        +registerClass~T~(name) void
        +registerHook(hook) void
        +Load(sdk, handle) void
        +Unload(sdk, handle) void
        +RegisterTypes() void
        +PostRegisterTypes() void
    }

    class FlightModuleRegister~T~ {
        +FlightModuleRegister(name)
    }

    IFlightModuleHook <|.. FlightModuleHook
    IFlightModuleHook <|.. FlightModuleHookHash
    FlightModuleFactory o-- IFlightModuleHook : s_hooks
    FlightModuleFactory o-- FlightModuleRegister : s_loads/s_registers
```

### Hook Registration Macros

Two macros register hooks at compile time. The hash-based variant resolves addresses via `RED4ext::UniversalRelocBase::Resolve(hash)` — a system that maps function hashes to runtime addresses across game patches.

```cpp
// Address-based (requires a known absolute address)
REGISTER_FLIGHT_HOOK(retType, func, ...)

// Hash-based (resolves address from function hash — patch-resistant)
REGISTER_FLIGHT_HOOK_HASH(retType, hash, func, ...)
```

Each macro:
1. Declares the hook function and a `_Original` function pointer
2. Creates a `FlightModuleHookHash` instance that self-registers with `FlightModuleFactory`
3. Defines the hook function body

The `FlightModuleFactory` singleton collects all hooks at static init, then `Load()` / `Unload()` attaches/detaches them all via the RED4ext SDK hooking interface.

---

## Physics Hooks

These are the core hooks that give LTBF control over vehicle physics. Each hook checks `FlightComponent::Get(vehicle)` and checks `fc->active` — if flight is active, the hook modifies or blocks the original behavior.

```mermaid
classDiagram
    class VehiclePhysicsUpdate {
        +ProcessAirResistance(self, dt)
        +ApplyTorqueAtPosition(physicsData, offset, torque)
        +ApplyForceAtPosition(physicsData, offset, force)
        +VehicleHelperUpdate(self, dt)
        +VehicleUpdateOrientationWithPID(a1, a2, a3, a4)
        +CarSuspension_AnimationUpdate(a1, dt)
        +BikeSuspension_AnimationUpdate(a1, dt)
    }

    class PhysicsData {
        +Vector3 force
        +Vector3 torque
        +Vector3 velocity
        +Vector3 angularVelocity
        +Vector3 centerOfMass
        +Matrix localInertiaTensor
        +bool unk1B0  -- gravity flag
        +vehicle::BaseObject* vehicle
    }

    class WheeledPhysics {
        +PhysicsData* parent_physicsData
        +vehicle::BaseObject* parent
        +DynArray driveHelpers
        +ApplyAirResistance(vel, dt)
        +ApplyLowSpeedResistances(vel, dt)
    }

    class CarBaseObject {
        +AdjustSplineTransformToRoad(transform, a, b)
    }

    class CarPhysics {
        +vehicle::BaseObject* parent
        +input turnInput
    }

    class BikePhysics {
        +vehicle::BaseObject* parent
        +float turnRate
        +bool tiltControlEnabled
    }

    class AreaSpeedLimiter {
        +Update_PreMove(delta, vehicle)
    }

    VehiclePhysicsUpdate ..> PhysicsData : reads/writes
    VehiclePhysicsUpdate ..> WheeledPhysics : hooks
    VehiclePhysicsUpdate ..> CarBaseObject : hooks
    VehiclePhysicsUpdate ..> CarPhysics : hooks
    VehiclePhysicsUpdate ..> BikePhysics : hooks
    VehiclePhysicsUpdate ..> AreaSpeedLimiter : hooks
```

### Hook Details

| Hook Function | Hash | What It Does When Flight Active |
|---------------|------|-------------------------------|
| `ApplyForceAtPosition` | 611586815 | **Returns immediately** — blocks ALL external force application (collisions, impacts). The vehicle is immune to external physical interactions. |
| `ApplyTorqueAtPosition` | 3303544265 | **Returns immediately** — blocks ALL external torque application. |
| `VehicleHelperUpdate` | 3281786499 | Saves `driveHelpers.size`, sets it to `0` during the call (disables ground driving helpers), then restores original size. |
| `VehicleUpdateOrientationWithPID` | 1414536155 | **Returns immediately** — blocks the game's road alignment PID that forces vehicles onto road splines. |
| `CarSuspension_AnimationUpdate` | 2879787320 | Reads `FlightComponent.roll` property and feeds it into `turnInput` for car animation, then calls original. |
| `BikeSuspension_AnimationUpdate` | 3191280029 | Sets `turnInput = 0`, `turnRate = 0`, `tiltControlEnabled = 0` — disables bike leaning physics. Calls original. |
| `ProcessAirResistance` | 2526549425 | Only applies air resistance when speed ≥ 100 m/s (skips below). Calls original regardless. |
| `AreaSpeedLimiter_Update` | 1836326624 | **Returns immediately** — blocks the area speed limiter (zone-based speed caps). |

### Pattern: Active Check

Every physics hook follows the same pattern:

```cpp
REGISTER_FLIGHT_HOOK_HASH(void __fastcall, HASH, HookName, Args...) {
  auto fc = FlightComponent::Get(self->parent);  // or vehicle
  if (fc && fc->active) {
    // Modify behavior or return early
    return;  // or modify args then call original
  }
  // Flight inactive — pass through to original
  HookName_Original(args...);
}
```

---

## Native Method Injection (Extensions)

LTBF injects native methods onto `vehicle::BaseObject` via RTTI expansion. These methods provide direct struct field access that CET Lua cannot achieve.

```mermaid
classDiagram
    class vehicle_BaseObject {
        <<RED4ext native>>
        +physicsData : PhysicsData*
    }

    class VehicleObjectExtensions {
        <<injected via RTTI>>
        +GetCenterOfMass() Vector3
        +GetAngularVelocity() Vector3
        +GetLinearVelocity() Vector3
        +EnableGravity(bool) void
        +HasGravity() bool
        +GetInertiaTensor() Matrix
        +ForceEnablePhysics() void
    }

    class PhysicsData {
        +Vector3 centerOfMass
        +Vector3 angularVelocity
        +Vector3 velocity
        +bool unk1B0
        +Matrix localInertiaTensor
    }

    vehicle_BaseObject --> VehicleObjectExtensions : @addMethod
    VehicleObjectExtensions ..> PhysicsData : direct field read/write
```

### Injected Methods and Their Implementations

| Method | Implementation | Field Accessed |
|--------|---------------|---------------|
| `GetCenterOfMass()` | `return this->physicsData->centerOfMass;` | Direct struct read |
| `GetAngularVelocity()` | `return this->physicsData->angularVelocity;` | Direct struct read |
| `EnableGravity(bool)` | `this->physicsData->unk1B0 = gravity;` | Direct struct write (reverse-engineered offset) |
| `HasGravity()` | `return this->physicsData->unk1B0;` | Direct struct read |
| `GetInertiaTensor()` | `return this->physicsData->localInertiaTensor;` | Direct struct read |
| `ForceEnablePhysics()` | Internal call to enable physics processing | Engine internal |

**Key insight:** `GetLinearVelocity()` may be a built-in vanilla method (it's used in REDscript without being in the `@addMethod` list). All others are LTBF-injected and do **not** exist in vanilla CET.

---

## FlightComponent — Per-Vehicle Flight Logic

`FlightComponent` is the central per-vehicle flight controller. Each vehicle that enters flight mode gets one.

```mermaid
classDiagram
    class FlightComponent {
        +Vector4 force
        +Vector4 torque
        +bool active
        +bool hasUpdate
        +Handle~IFlightConfiguration~ configuration
        +float roll
        +OnUpdate(deltaTime) void
        +OnPhysicsUpdate(deltaTime) void
        +Get(vehicle) FlightComponent*
    }

    class FlightSystem {
        +unordered_map flightComponents
        +RegisterComponent(handle) void
        +UnregisterComponent(handle) void
        +playerComponent : WeakHandle
    }

    class IFlightConfiguration {
        +thrusters : DynArray~Handle~IFlightThruster~~
        +Setup(vehicle) void
        +OnActivationCore() void
        +OnDeactivationCore() void
    }

    class FlightThruster {
        +position : Vector3
        +thrusterTensor : Matrix
    }

    FlightSystem "1" o-- "many" FlightComponent : registers
    FlightComponent --> IFlightConfiguration : configuration
    IFlightConfiguration *-- "4" FlightThruster : at wheel positions
```

### Force/Torque Application Flow

The critical mechanism — `FlightComponent::OnUpdate()` runs after the REDscript `OnUpdate()` (which accumulates desired force/torque from PID controllers and input), then writes directly to the physics struct:

```mermaid
sequenceDiagram
    participant RED as REDscript OnUpdate
    participant FC as FlightComponent::OnUpdate (C++)
    participant PD as physicsData struct
    participant Engine as Physics Engine

    RED->>RED: PID controllers compute force/torque
    RED->>RED: Store in fc.force, fc.torque (Vector4)
    FC->>FC: ExecuteFunction(REDscript OnUpdate)
    FC->>PD: physicsData->force += fc.force.AsVector3()
    FC->>PD: physicsData->torque += fc.torque.AsVector3()
    FC->>FC: Reset force/torque to zero
    Engine->>PD: Integration step reads force/torque
```

**This is the fundamental difference from CET Lua:** `physicsData->force` is a **raw field on the physics rigid body struct**, not an event. The physics engine reads it directly during integration. There is no `PhysicalImpulseEvent`, no `QueueEvent`, no radius sphere, no collision body intersection — just a direct force accumulator.

---

## FlightSystem Lifecycle

`FlightSystem` is registered as a `game::IGameSystem` — the engine calls its lifecycle methods automatically.

```mermaid
sequenceDiagram
    participant Engine
    participant FS as FlightSystem
    participant FC as FlightComponent

    Engine->>FS: OnRegisterUpdates(registrar)
    Engine->>FS: OnWorldAttached(scene)
    Engine->>FS: OnStreamingWorldLoaded(scene, ...)
    Note over FS: Flight system active
    Engine->>FS: RegisterComponent(handle)
    FS->>FS: flightComponents[id] = handle
    Engine->>FC: OnUpdate(deltaTime)
    FC->>FC: Write force/torque to physicsData
    Engine->>FS: OnGameSave(stream)
    Engine->>FS: OnGameLoad(stream)
    Engine->>FS: OnBeforeWorldDetach(scene)
    Engine->>FS: OnWorldDetached(scene)
```

### Save/Load Support

`FlightSystem` implements full save/load:
- `OnBeforeGameSave` — prepare for serialization
- `OnGameSave` — write flight state to stream
- `OnGameLoad` — restore flight state from stream
- `OnGameRestored` — post-load verification
- `IsSavingLocked` — can block saving during critical physics states

---

## Hook Installation Flow

```mermaid
sequenceDiagram
    participant RED4ext
    participant Factory as FlightModuleFactory
    participant Hooks as Registered Hooks
    participant SDK as RED4ext SDK

    Note over Hooks: Static init: each REGISTER_FLIGHT_HOOK_HASH\ncreates a FlightModuleHookHash and\nregisters with Factory
    RED4ext->>Factory: Load(sdk, handle)
    Factory->>Factory: RegisterTypes() — RTTI type registration
    Factory->>Factory: PostRegisterTypes() — post-registration setup
    Factory->>Hooks: for each hook: hook.Load(sdk, handle)
    Hooks->>SDK: sdk->hooking->Attach(handle, address, hookFunc, &original)
    SDK-->>Hooks: Original function pointer stored
    Note over Hooks: Hook active — calls intercepted
    RED4ext->>Factory: Unload(sdk, handle)
    Factory->>Hooks: for each hook: hook.Unload(sdk, handle)
    Hooks->>SDK: sdk->hooking->Detach(handle, address)
```

---

## Summary: What Makes LTBF's C++ Approach Unique

| Capability | CET Lua | LTBF C++ |
|-----------|---------|----------|
| **Force application** | `PhysicalImpulseEvent` (event-based, spherical) | Direct write to `physicsData->force` / `->torque` |
| **Gravity control** | Per-frame anti-gravity delta-v compensation | `physicsData->unk1B0 = false` — disabled at struct level |
| **Velocity reading** | Position delta / deltaTime (jittery) | `physicsData->velocity` / `physicsData->angularVelocity` — exact |
| **Collision immunity** | Not possible | Hook `ApplyForceAtPosition` / `ApplyTorqueAtPosition` — return early |
| **Road alignment** | Cannot disable | Hook `AdjustSplineTransformToRoad` — return early |
| **Custom game system** | Not possible | Register as `game::IGameSystem` via RTTI |
| **Custom entity component** | Not possible | `FlightComponent` with RTTI registration |
| **Scriptable properties** | Not possible | `FlightController`, `FlightSettings` with RTTI-exposed properties |
| **Torque computation** | Avoided (center of mass impulse) | Full PID controllers with inertia tensor scaling |
| **Thruster model** | Single point | 4 thrusters at wheel positions with per-axis tensor scaling |

### Key Files Reference

| File | Purpose |
|------|---------|
| `FlightSystem.hpp` / `IFlightSystem.hpp` | Game system registration and lifecycle |
| `FlightController.hpp` | Scriptable singleton (enabled/active/mode) |
| `FlightSettings.hpp` | Scriptable settings bridge (get/set float/vector/bool) |
| `FlightConfiguration.hpp` | Per-vehicle-type flight config (thrusters, camera, colliders) |
| `Flight/Component.cpp` | Per-vehicle force/torque application to physicsData |
| `Physics/VehiclePhysicsUpdate.cpp` | All physics detour hooks |
| `Extensions/VehicleObject.cpp` | Native method injection onto VehicleObject |
| `Engine/RTTIClass.hpp` | Template base for RTTI type registration |
| `Engine/RTTIRegistrar.cpp` | RTTI registration infrastructure |
| `Utils/FlightModule.hpp` | Hook framework: macros, factory, registration |
| `EntityAddComponent.cpp` | Dynamic component attachment to entities |
