### What It Does

Spawns a **Zetatech Bombus drone** (using CE4's proven `exEntitySpawner` pattern), then applies visual effects to that drone using `GameObjectEffectHelper.StartEffectEvent` with an `entSpawnEffectEvent` fallback.

The key insight from your `fx_tester` research: effects only fire on entities that have `FxResourceMapperComponent` with matching CName tag mappings. Generic props like `sponge.ent` don't have these. The Bombus drone IS a complex vehicle entity, so it should have effect mappings for damage/destruction/etc.

### Hotkeys (bind in Settings > Key Bindings > FxTester2)

| Hotkey | Action |
|---|---|
| **Fx2: Spawn/Despawn Drone** | Toggle drone spawn/despawn + ImGui window |
| **Fx2: Play Effect** | Apply current effect to the drone |
| **Fx2: Stop Effect** | Stop all active effects |
| **Fx2: Cycle Effect** | Switch to next effect in the list |
| **Fx2: Dump Components** | **Diagnostic** — dumps all drone components to CET console, highlights any FxResourceMapper/Effect components and tries to list their effect tag mappings |

### Effect List (38 entries)

- **Vehicle tags** (most likely to work): `explosion`, `destroyed`, `damage`, `damage_smoke`, `destruction`, `engine_fire`, `engine_smoke`, `fire`, `smoke`, `thrust`, `hover`, `afterburner`, `exhaust`, `turn_signal`, `headlight`, `siren`, `muzzle_flash`, `weapon_fire`
- **Device/generic tags**: `broken`, `active`, `glitchEffect`, `frameEffect`, `light_on_destr`, flare smoke, candles, mine lasers
- **Player-only tags** (fallback, applies to player not drone): `blackwall_use_force`, `charge`, `dash`, `cloak_on/off`, `cyberware_explosion`

### Usage

1. **Spawn drone** (hotkey) — drone appears 3m in front of you, ImGui window opens
2. **Dump Components** (hotkey) — check CET console for what FX components the drone actually has
3. **Play Effect** (hotkey) — try current effect on the drone
4. **Cycle Effect** (hotkey) — move to next effect, try again
5. **Despawn** (same spawn hotkey) — clean up

### Important Notes

- All `registerHotkey()` calls are at **file root level** (lines 529-547), per the CET hotkey rule in your project
- Effects auto-stop after 5 seconds (configurable in `Config`)
- The **Dump Components** hotkey is the real diagnostic tool — it will tell you exactly which effect tags the drone's `FxResourceMapperComponent` supports, so you know which ones will actually work
- Not all 38 effect tags will fire visible effects — only the ones the drone's entity template has mapped will work. That's expected and why the dump diagnostic exists