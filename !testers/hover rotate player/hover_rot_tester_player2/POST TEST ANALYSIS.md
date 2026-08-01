## Root Cause Found

I traced through the **Codeware C++ source** and found exactly why `SetWorldTransform` is a no-op on the player.

### The Implementation

From `/a0/usr/projects/cyberpunk/sources/codeware/src/App/Entity/EntityEx.hpp`:

```cpp
void SetWorldTransform(const Red::WorldTransform& aTransform)
{
    Raw::IPlacedComponent::SetTransform(transformComponent, aTransform);
}
```

Where `transformComponent` is defined in `Entity.hpp`:

```cpp
using TransformComponent = Core::OffsetPtr<0xB0, Red::IPlacedComponent*>;
```

### Why It's a No-Op

`SetWorldTransform` sets the transform on the entity's **visual/scene component** (`IPlacedComponent` at offset 0xB0), **not** on a physics rigid body.

- **Vehicles work** because they're physics-driven — their rigid body drives the `transformComponent`, so setting it actually moves the entity
- **Players don't work** because they're **locomotion-driven** — the player's locomotion state machine overwrites `transformComponent` every frame, undoing whatever we set

The Codeware wiki even confirms this: *"Static entities can be moved now without respawning them at new position"* — it was designed for static entities, not animated/physics-driven ones.

### No Mod Examples Found

I searched all of `sources/mods/`, `sources/adamsmasher/`, and `okf/` — **no mod uses `SetWorldTransform` on the player**. It's completely uncharted territory. The only usages are the Codeware definition itself.

---

## Your Ragdoll Idea Is Spot On

This is the key insight. When the player is ragdolled:

1. The **locomotion state machine stops running** — it doesn't overwrite `transformComponent`
2. The body becomes **physics-driven** — the ragdoll rigid body takes control of the transform
3. `SetWorldTransform` might actually stick because nothing is overwriting it

This is exactly what the jetpack mod does with NPCs — it forces ragdoll first, *then* applies impulses:

```lua
-- From jetpack ragdoll.lua:
npc:QueueEvent(CreateForceRagdollEvent("Launch Up"))
-- Must wait a frame for ragdoll to activate
DelayEventNextFrame(npc, CreateRagdollApplyImpulseEvent(npc_pos, direction, 5))
```

### The Ragdoll API (from adamsmasher source)

```swift
// Force ragdoll activation
CreateForceRagdollEvent("debugName")           // full ragdoll with power pose
CreateForceRagdollNoPowerPoseEvent("debugName")  // ragdoll without power pose

// Disable ragdoll
CreateDisableRagdollEvent("debugName")

// Apply impulse to ragdolled body
CreateRagdollApplyImpulseEvent(worldPos, impulseVec, influenceRadius)

// Capability checks
ScriptedPuppet.CanRagdoll(entity)
entity:CanEnableRagdollComponent()
```

### Why This Might Work

The ragdoll state creates a **real physics rigid body** for the player. In that state:
- `SetWorldTransform` targets the `transformComponent`, which the ragdoll rigid body drives
- The locomotion system isn't overwriting it anymore
- We might be able to set orientation that sticks

### Why It Might Not Work

- The player may not support `CanRagdoll()` (NPCs are puppets, player is a different entity type)
- Even if ragdolled, `SetWorldTransform` sets the **scene component**, not the **ragdoll rigid body** — the ragdoll physics might overwrite it
- The ragdoll has its own physics integration that could ignore our transform
- The player loses all control during ragdoll

---

## Suggested Next Steps

1. **Quick probe**: Try `ScriptedPuppet.CanRagdoll(Game.GetPlayer())` — does the player even support ragdoll?

2. **Ragdoll + SetWorldTransform tester**: If the player supports ragdoll:
   - Force ragdoll on activation
   - Hover with impulses (same as V2)
   - Call `SetWorldTransform` with orientation while ragdolled
   - See if the orientation sticks
   - Try `CreateDisableRagdollEvent` and teleport to recover

3. **Alternative**: Instead of `SetWorldTransform`, try `RagdollApplyImpulseEvent` at offset positions to create **torque** on the ragdolled body — this would rotate the body via actual physics, not transform overrides

Want me to create a tester for the ragdoll approach?