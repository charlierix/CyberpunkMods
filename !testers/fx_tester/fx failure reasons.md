## Why Regular Effects Don't Work in `fx_tester`

After deep-diving through `okf`, the downloaded FX mods, and CET Lua mod sources, the root cause is clear:

### The Core Problem

**CName effect tags are entity-specific.** When you call:
```lua
GameObjectEffectHelper.StartEffectEvent(entity, "broken", false)
```

The engine doesn't look up a global effect database — it looks in **that entity's `FxResourceMapperComponent`**, which maps CName tags to actual `.effect` resource paths (like `base\\fx\\devices\\mine\\mine_destroyed.effect`).

The generic props in `fx_tester` (`sponge.ent`, `workspot_anim.ent`) **don't have `FxResourceMapperComponent`** mappings for tags like `broken`, `active`, `mine_laser_green`, `fx_candles`, etc. So `StartEffectEvent` silently succeeds but plays nothing.

**Player effects work** because the player puppet (`PlayerPuppet`) has an `FxResourceMapperComponent` with tags like `blackwall_use_force`, `charge`, `dash`, `cloak_on`, etc. already mapped to `.effect` resources.

### How Downloaded FX Mods Actually Work

The mods in `sources - extra/fx/` **don't spawn effects at arbitrary positions at all**. They use three different approaches:

| Mod | Approach |
|-----|----------|
| **Egghanced Blood Fx** | `TweakDB:SetFlat` to change weapon impact VFX chances and dismemberment settings |
| **Enhanced Vehicle Collision FX** | `TweakDB:SetFlat` to swap `.effect` resource paths in `Vehicle.FxCollisionMaterial_*` records |
| **FxEffects** | TweakXL YAML to swap weapon `fxPackage` records and define new `MaterialFx` records with custom `.effect` paths |
| **Dark Smoke / Rain FX / Footsteps** | `.archive` file replacements — swap the actual `.effect` or mesh assets via ArchiveXL |
| **Blackwall Begone** | `.archive` replacement to remove/replace the Blackwall visual |

For example, `EnhancedVehicleCollisionFX/init.lua` does:
```lua
TweakDB:SetFlat("Vehicle.FxCollisionMaterial_Default.scratch_particles",
  [[base\\fx\\_library\\sparks\\lib_sparks_spike_curved_small_01.effect]])
```

This **replaces** the `.effect` resource path that the game's vehicle collision system already uses. The game spawns the effect itself — the mod just changes *which* `.effect` file gets loaded.

### Why There's No Simple "Spawn .effect at Position" API in CET Lua

From the okf API docs, I found these native types exist but **aren't exposed to CET Lua**:

- **`gameEffectExecutor_VisualEffect`** — has fields: `effect`, `attached`, `breakLoopOnDetach`, `effectTag`, `vectorEvaluator` (RED4ext/redscript only)
- **`gameEffectPreAction_VisualEffectAtPosition`** — has: `effect`, `attached`, `breakLoopOnDetach`, `vertical`, `effectTag` (RED4ext/redscript only)
- **`gameTransformAnimation_SpawnEffect`** — has: `effectName`, `effectTag`, `persistOnDetach` (used in transform animation tracks, not CET-accessible)
- **`worldEffectNode`** — has: `effect`, `streamingDistanceOverride` (world placement node, editor-only)
- **`entEffectSpawnerComponent`** — marked as `unknown` with no exposed members (entity component, not CET-accessible)

The `SpawnEffect` and `SpawnTestEffect` native types exist in the API but have **0 fields and 0 methods** exposed — they're internal engine types.

### Practical Solutions

**Option 1: Spawn entities that already have the desired effect tags**

Instead of generic props, spawn actual game entities that have `FxResourceMapperComponent` mappings for the effects you want. For example:
- Mine entities for `mine_laser_green`, `mine_laser_red`
- Device entities for `broken`, `active`, `destroyed`, `glitchEffect`
- You'd need to find the right entity template paths (`.ent` files) that include those effect mappings

**Option 2: Use TweakDB to create custom effect packages**

Like the downloaded mods do — use TweakDB/TweakXL to define new `WeaponFxPackage` or `MaterialFx` records that reference your desired `.effect` files, then trigger them through existing game systems (weapon attacks, explosions, etc.)

**Option 3: Use redscript/RED4ext for direct effect spawning**

Write a small redscript or RED4ext plugin that can access `gameEffectExecutor_VisualEffect` or `gameEffectPreAction_VisualEffectAtPosition` to play `.effect` resources at arbitrary positions. CET Lua simply doesn't have this capability.

**Option 4: ArchiveXL approach**

Use `.archive` files to add/replace effect mappings on specific entity templates, so that when you spawn those entities via CET, they have the effect tags you want.

### Summary

| What | Status |
|------|-------|
| `GameObjectEffectHelper.StartEffectEvent` on generic props | ❌ Silently fails — props lack `FxResourceMapperComponent` mappings |
| Player-attached effects | ✅ Work — player puppet has the tags mapped |
| `entSpawnEffectEvent` on generic props | ❌ Same issue — tag lookup fails without mappings |
| TweakDB `.effect` path swaps | ✅ Works — replaces paths in existing game systems |
| `.archive` asset replacement | ✅ Works — replaces visual assets at the file level |
| Direct `.effect` spawning at world position via CET | ❌ Not possible — no CET-exposed API for this |
| Direct `.effect` spawning via redscript/RED4ext | ✅ Possible — has access to `gameEffectExecutor_VisualEffect` etc. |

The fx_tester's effect list is also misleading — those CName tags (`e_vfx_flare_smoke_red_1`, `fx_candles`, etc.) aren't universal effect IDs, they're **per-entity effect map keys** that only exist on specific entity templates. To make them work, you'd need to spawn the *correct* entity that has those tags in its effect map.