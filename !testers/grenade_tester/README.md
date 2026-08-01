# Grenade Tester — CET Mod

Spawns a grenade **N meters along your look direction** and **detonates after N seconds**.

Pure CET (Lua) — no redscript, no archives, no TweakXL.

## Install

1. Copy the `grenade_tester/` folder to:
   ```
   bin/x64/plugins/cyber_engine_tweaks/mods/grenade_tester/
   ```
2. Launch the game.
3. Go to **Settings → Key Bindings → GrenadeTester** and bind:
   - **Spawn Test Grenade** — spawns the grenade at the target position
   - **Cycle Grenade Type** — switches between frag / emp / flash / incendiary / biohazard / recon / cutting

## Configuration

Edit `init.lua` → `Config` table (top of file):

| Setting | Default | Description |
|---|---|---|
| `fuseTime` | `3.0` | Seconds before detonation |
| `spawnDistance` | `5.0` | Meters along look direction |
| `grenadeType` | `"frag"` | Which grenade effect to apply |
| `applyToPlayer` | `true` | Apply explosion to player (easy to see/test) |
| `applyToTargeted` | `true` | Also apply to entity under crosshair |
| `debug` | `true` | Print info to CET console |

## How It Works

1. **Hotkey** → `registerHotkey` (CET native)
2. **Look direction** → `Game.GetCameraSystem():GetActiveCameraForward()`
3. **Spawn position** → `player:GetWorldPosition() + forward * spawnDistance`
4. **Visual entity** → `WorldFunctionalTests.SpawnEntity(path, transform, "")` using the grenade's `entityTemplatePath` from TweakDB
5. **Fuse timer** → `SetTimeout(fuseMs, ...)`
6. **Explosion** → `Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, effect)` with grenade-specific status effects
7. **Cleanup** → spawned entity disposed after detonation

## Grenade Types

| Key | TweakDB Item | Explosion Status Effect |
|---|---|---|
| `frag` | `Items.GrenadeFragRegular` | `BaseStatusEffect.CommonFragGrenadeExplosion` |
| `emp` | `Items.GrenadeEMPRegular` | `BaseStatusEffect.BaseEmpGrenade` |
| `flash` | `Items.GrenadeFlashRegular` | `BaseStatusEffect.CommonFlashGrenade` |
| `incendiary` | `Items.GrenadeIncendiaryRegular` | `BaseStatusEffect.BurnGrenade` |
| `biohazard` | `Items.GrenadeBiohazardRegular` | `BaseStatusEffect.BioGrenade` |
| `recon` | `Items.GrenadeReconRegular` | `BaseStatusEffect.ReconGrenadeAttack` |
| `cutting` | `Items.GrenadeCuttingRegular` | `BaseStatusEffect.CuttingGrenadeAttack` |

## Notes

- The explosion is triggered via **status effects** (the same mechanism used by `GameEntityExaminerTool`). This applies the visual + damage effect without needing to spawn a functional projectile with physics.
- If the `entityTemplatePath` can't be resolved from TweakDB at runtime, the visual entity spawn is skipped but the explosion still fires.
- `applyToPlayer = true` lets you see/feel the explosion immediately. Set to `false` if you only want to affect NPCs/targets.
