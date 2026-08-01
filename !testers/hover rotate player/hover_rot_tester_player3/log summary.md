# Player 3 — Log Summary

## Test Conditions

- **Date**: 2026-07-19 23:13:37 UTC-05:00
- **Player position**: (-1321.85, -1685.45, 44.21)
- **Player orientation**: roll=0.00 pitch=0.00 yaw=174.35
- **Player velocity**: (0, 0, 0) — standing still

---

## 1. Identity & Class Hierarchy

| Check | Result |
|-------|--------|
| GetClassName() | `PlayerPuppet` |
| GetRecordID() | `Character.Player_Puppet_Base` |
| IsAttached() | `true` |
| IsA(PlayerPuppet) | ✅ true |
| IsA(ScriptedPuppet) | ✅ true |
| IsA(gamePuppet) | ✅ true |
| IsA(gamePuppetBase) | ✅ true |
| IsA(GameObject) | ❌ false |
| IsA(GameEntity) | ❌ false |
| IsA(Entity) | ❌ false |
| IsA(IScriptable) | ✅ true |

**Note**: Player is NOT a `GameObject` or `GameEntity` — it's a `gamePuppetBase` subclass. This matters because some transform methods may be puppet-specific.

---

## 2. Transform State

| Property | Value |
|----------|-------|
| Position | (-1321.85, -1685.45, 44.21, 1.0) |
| Orientation (quat) | i=0, j=0, k=0.9988, r=0.0493 |
| Orientation (euler) | roll=0, pitch=0, yaw=174.35 |
| Velocity | (0, 0, 0, 1) |
| GetLocalPosition | ❌ not available |
| GetLocalOrientation | ❌ not available |

---

## 3. Component Getters — Only 3 Found

| Getter | Result | Class |
|--------|--------|-------|
| GetFPPCameraComponent | ✅ FOUND | `gameFPPCameraComponent` |
| GetTargetTrackerComponent | ✅ FOUND | `TargetTrackingExtension` |
| GetSquadMemberComponent | ✅ FOUND | `SquadMemberBaseComponent` |

All other ~25 getter methods returned nil/not available.

---

## 4. FindComponentByName / GetComponent by Type

**ALL returned nil/error.** Neither `FindComponentByName` nor `GetComponent` found any components when called with type string names. This is because:
- `FindComponentByName` expects a CName (component name, not class name)
- `GetComponent` by string type doesn't exist in CET
- The correct method is **`FindComponentByType(type: CName)`** (found in Dump reflection)

---

## 5. GetComponents() — 174 Components Found!

`GetComponents()` returned **174 component handles**. This is the full component list. Key components:

### Movement / State / Physics

| # | Component | Significance |
|---|-----------|-------------|
| 24 | `gamestateMachineComponent` | **PSM / locomotion state machine** |
| 33 | `gameHumanoidBody` | **Body representation** |
| 35 | `moveComponent` | **Movement component** |
| 70 | `entColliderComponent` | **Physics collider** |
| 86 | `gamePlayerCommandConsumerComponent` | **Input → movement commands** |
| 87 | `gameinfluenceBumpComponent` | **Bump/physics influence** |
| 102 | `gameinfluenceObstacleComponent` | **Obstacle avoidance** |

### Animation / Visual

| # | Component | Significance |
|---|-----------|-------------|
| 1-5 | `entAnimatedComponent` (×5) | **Animation rigs** |
| 13 | `entAnimationControllerComponent` | **Animation controller** |
| 16-17, 21, 23, 25, 28, 30-31, 43-44, 47, 52, 55, 60, 158, 161, 164, 166-167, 169 | `entSkinnedMeshComponent` (×18) | **Body meshes** |
| 105 | `entMeshComponent` | **Static mesh** |
| 113 | `entVisualControllerComponent` | **Visual controller** |

### Camera

| # | Component | Significance |
|---|-----------|-------------|
| 62 | `gameFPPCameraComponent` | **First-person camera** |
| 108 | `gameWorldSpaceBlendCamera` | **World space camera blend** |
| 109 | `vehicleTPPCameraComponent` | **TPP camera** |
| 110 | `vehicleCameraManagerComponent` | **Camera manager** |
| 111 | `vehicleVehicleProxyBlendCamera` | **Vehicle proxy camera** |

### Targeting / Senses

| # | Component | Significance |
|---|-----------|-------------|
| 73-74 | `gameTargetingComponent` (×2) | **Targeting** |
| 90 | `gameTargetingActivatorComponent` | **Target activation** |
| 93 | `gameTargetShootComponent` | **Shooting** |
| 95 | `TargetTrackingExtension` | **Target tracking** |
| 96 | `senseSensorObjectComponent` | **Senses** |
| 101 | `senseVisibleObjectComponent` | **Visibility** |

### Other Notable

| # | Component | Significance |
|---|-----------|-------------|
| 8 | `gameStatsComponent` | **Stats** |
| 18 | `gameInventory` | **Inventory** |
| 22 | `gameAttachmentSlots` | **Equipment slots** |
| 42 | `gameStatusEffectComponent` | **Status effects** |
| 77 | `gamePlayerMappinComponent` | **Player mappin** |
| 79 | `SquadMemberBaseComponent` | **Squad** |
| 98 | `entTransformHistoryComponent` | **Transform history** |
| 99 | `entMorphTargetManagerComponent` | **Morph targets** |

### NO RAGDOLL COMPONENT

**Critical finding**: There is **no ragdoll component** in any of the 174 components. No `entRagdollComponent`, no `gameRagdollComponent`, nothing with "ragdoll" in the name.

---

## 6. Ragdoll Events

| Event | Result |
|-------|--------|
| CreateForceRagdollEvent | ❌ ERROR: requires 1 parameter |
| RagdollActivationRequestEvent | ✅ QUEUED OK |
| RagdollApplyImpulseEvent | ✅ QUEUED OK |
| RagdollDisableEvent | ✅ QUEUED OK |

Events queue without error, but since there's no ragdoll component, they likely have no effect.

---

## 7. Ragdoll Method Probes

| Method | Exists | Result |
|--------|--------|--------|
| CanRagdoll() | ✅ yes | ❌ **returns false** |
| IsRagdolling() | ❌ no | — |
| ForceRagdoll() | ❌ no | — |
| DisableRagdoll() | ❌ no | — |
| IsRagdolled() | ❌ no | — |
| GetRagdollComponent() | ❌ no | — |
| EnableRagdoll() | ❌ no | — |
| ToggleRagdoll() | ❌ no | — |

**Conclusion**: The player entity **cannot ragdoll**. `CanRagdoll()` returns false and no ragdoll component exists.

---

## 8. State Machine / Blackboard

| Method | Result |
|--------|--------|
| GetBlackboard() | ✅ FOUND (userdata) |
| GetActiveState() | ❌ nil |
| GetPSM() | ❌ nil |
| GetStateMachine() | ❌ nil |
| GetStateMachineComponent() | ❌ nil |

**Note**: `gamestateMachineComponent` EXISTS as component #24, but there's no direct getter method for it. Need to use `FindComponentByType("gamestateMachineComponent")`.

---

## 9. SetWorldTransform Identity Test

| Measurement | Value |
|-------------|-------|
| SetWorldTransform returned | `nil` (no error, no return value) |
| Position before | (-1321.85, -1685.45, 44.21) |
| Position after | (-1321.85, -1685.45, 44.21) — **unchanged** |
| Orientation after | roll=0, pitch=0, yaw=174.35 — **unchanged** |

**Confirmed**: SetWorldTransform is a complete no-op on the player entity, even with an identity transform.

---

## 10. TeleportationFacility

| Check | Result |
|-------|--------|
| Game.GetTeleportationFacility() | ✅ FOUND |
| TPFacility.Teleport() | ✅ EXISTS |

**This is a viable alternative path** — Teleport can set position + orientation via EulerAngles.

---

## 11. Method Existence Check — 22 Methods Found

| Method | Category |
|--------|----------|
| GetWorldPosition | Transform |
| GetWorldOrientation | Transform |
| GetWorldYaw | Transform |
| GetVelocity | Transform |
| SetWorldTransform | Transform (no-op) |
| GetEntityID | Entity |
| GetRecordID | Entity |
| GetRecord | Entity |
| IsAttached | Entity |
| QueueEvent | Entity |
| GetFPPCameraComponent | Component |
| FindComponentByName | Component |
| GetComponents | Component |
| CanRagdoll | Ragdoll (returns false) |
| GetBlackboard | State |
| GetMountedVehicle | Vehicle |
| GetCurrentAppearanceName | Appearance |
| GetDisplayName | Appearance |
| Kill | Combat |
| OnGameAttached | Lifecycle |
| GetEntity | Entity |
| GetGame | Entity |

**Notable absences**: No `SetWorldPosition`, `SetWorldOrientation`, `SetLocalPosition`, `SetLocalOrientation`, `GetAllComponents`, `HasComponent`, `GetMovementComponent`, `GetLocomotionComponent`, `GetPhysicsComponent`, `GetAnimationController`, `GetAnimatedComponent`, `GetPSM`, `GetStateMachine`, `Teleport`, `ApplyImpulse`, `AddImpulse`, `ApplyForce`.

---

## 12. Game Systems

**ALL Game.GetXxxSystem() calls returned nil/error.** This is likely because the CET access pattern is different — these systems need to be accessed via `Game.GetDriverGroundFramerateSystem()` or similar specific patterns, not `Game.GetStatsSystem()`.

---

## 13. Component Details — FPPCameraComponent

The FPPCameraComponent has **local transform setters**:

| Method | Available |
|--------|-----------|
| GetLocalPosition | ✅ |
| GetLocalOrientation | ✅ |
| SetLocalPosition | ✅ |
| SetLocalOrientation | ✅ |
| GetClassName | ✅ |
| GetName | ✅ |
| IsEnabled | ✅ |
| GetEntity | ✅ |

**This is significant** — the camera can be independently oriented via SetLocalOrientation.

---

## 14. CET Reflection Dump (Dump(player))

`Dump(player)` returned a massive reflection dump of ALL PlayerPuppet methods. Key methods discovered that weren't in our probe list:

| Method | Signature | Significance |
|--------|-----------|-------------|
| **EnableTransformUpdates** | `(enable: Bool)` | **Can disable locomotion transform override!** |
| **FindComponentByType** | `(type: CName) => (handle:entIComponent)` | **Correct component lookup method** |
| **GetWorldTransform** | `() => (WorldTransform)` | **Read full transform** |
| GetAnimationControllerComponent | `() => (handle:entAnimationControllerComponent)` | Animation controller access |
| GetTransformHistoryComponent | `() => (handle:entTransformHistoryComponent)` | Transform history |
| GetMovePolicesComponent | `() => (handle:movePoliciesComponent)` | Movement policies |
| GetStatesComponent | `() => (handle:NPCStatesComponent)` | NPC states |
| OnLocomotionStateChanged | `(newState: Int32) => (Bool)` | Locomotion state callback |
| OnTransformUpdated | `()` | Transform change callback |
| SetIndividualTimeDilation | `(reason: CName, dilation: Float, ...)` | Time dilation |
| ApplyMorphTarget | `(target: CName, region: CName, value: Float) => (Bool)` | Morph targets |
| GetPlayerStateMachineBlackboard | `() => (handle:gameIBlackboard)` | PSM blackboard |
| GetPuppetStateBlackboard | `() => (handle:gameIBlackboard)` | Puppet state blackboard |
| GetSensesComponent | `() => (handle:senseComponent)` | Senses |
| GetHitReactionComponent | `() => (handle:HitReactionComponent)` | Hit reactions |
| GetStimReactionComponent | `() => (handle:ReactionManagerComponent)` | Stim reactions |
| GetDismembermentComponent | `() => (handle:gameDismembermentComponent)` | Dismemberment |
| GetCrowdMemberComponent | `() => (handle:CrowdMemberBaseComponent)` | Crowd |
| GetSlotComponent | `() => (handle:entSlotComponent)` | Slots |
| GetBumpComponent | `() => (handle:gameinfluenceBumpComponent)` | Bump |
| GetSignalHandlerComponent | `() => (handle:AISignalHandlerComponent)` | AI signals |
| GetAIControllerComponent | `() => (handle:AIHumanComponent)` | AI controller |
