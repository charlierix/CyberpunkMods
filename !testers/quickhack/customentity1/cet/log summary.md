# Custom Entity Tester 1 (CE1) - Log Summary

## Overview

| Property | Value |
|---|---|
| **Log file** | `log.txt` |
| **Total lines** | 67 |
| **Mod** | customentity1 |
| **Session start** | 2026-08-06 16:56:16 UTC-05:00 (mod load) |
| **Init time** | 2026-08-06 16:56:29 |
| **Spawn attempt** | 2026-08-06 16:58:54 |
| **Purpose** | Shell entity creation + REDscript bridge validation for cyberware proxy device hacking |
| **Target game** | Cyberpunk 2077 v2.2+ |
| **Requires** | CET 1.39.1+, REDscript, RED4ext |

## Initialization (16:56:29)

- CE1 initialized with 7 entity path candidates configured
- Entity paths:
  1. `base\_ieee\ieee_03_km.ent`
  2. `base\_ieee\ieee_04_km.ent`
  3. `base\_ieee\ieee_05_km.ent`
  4. `base\_ieee\ieee_06_km.ent`
  5. `base\_ieee\ieee_07_km.ent`
  6. `base\_ieee\ieee_08_km.ent`
  7. `base\_ieee\init_spawner_demo.ent`
- **WARNING: OrbHackingBridge not found** — REDscript mod not installed (compilation error)
- Entity spawning will work but action execution tests will fail

## Spawn Attempt (16:58:54)

The spawn hotkey was pressed at 16:58:54. The code attempted to spawn a shell entity at the player's position offset by (+2.0 x, +2.0 z):

- **Spawn position**: (-636.82, 897.08, 21.75)

### Code That Tried to Spawn (init.lua, SpawnShellEntity function, lines 133-224)

```lua
local function SpawnShellEntity()
    LogSection('SPAWN SHELL ENTITY')
    if state.shellEntity then
        Log('Entity exists, despawning first...')
        DespawnShellEntity()
    end
    local player = GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return false
    end
    local pos = player:GetWorldPosition()
    pos.z = pos.z + 2.0
    pos.y = pos.y + 2.0
    Log(string.format('Spawn pos: (%.2f, %.2f, %.2f)', pos.x, pos.y, pos.z))

    local spawnTransform = player:GetWorldTransform()
    spawnTransform:SetPosition(pos)

    -- Check if exEntitySpawner exists (note: it is userdata, not a table, in CET)
    if not exEntitySpawner then
        Log('ERROR: exEntitySpawner is not available in this CET version')
        Log('Trying WorldFunctionalTests.SpawnEntity as fallback...')
        for i, entityPath in ipairs(ENTITY_PATHS) do
            Log(string.format('Trying entity path [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
            local ok, entityID = SafeCall('WorldFunctionalTests.SpawnEntity', function()
                return WorldFunctionalTests.SpawnEntity(entityPath, spawnTransform, ENTITY_APPEARANCE)
            end)
            if ok and entityID then
                state.shellEntityID = entityID
                state.pendingSpawn = true
                state.shellEntityValid = false
                state.shellEntity = nil
                state.currentEntityPath = entityPath
                Log(string.format('Spawn requested via WorldFunctionalTests, entity ID: %s (pending...)', tostring(entityID)))
                return true
            end
            if ok and not entityID then
                Log(string.format('Path not found (returned nil): %s', entityPath))
            end
        end
        Log('ERROR: Spawn failed - exEntitySpawner missing and WorldFunctionalTests fallback failed')
        return false
    end

    -- Try each entity path with exEntitySpawner.Spawn until one works
    for i, entityPath in ipairs(ENTITY_PATHS) do
        Log(string.format('Trying entity path [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
        local ok, entityID = SafeCall('exEntitySpawner.Spawn', function()
            return exEntitySpawner.Spawn(entityPath, spawnTransform, ENTITY_APPEARANCE)
        end)
        if ok and entityID then
            state.shellEntityID = entityID
            state.pendingSpawn = true
            state.shellEntityValid = false
            state.shellEntity = nil
            state.currentEntityPath = entityPath
            Log(string.format('Spawn requested, entity ID: %s (pending...)', tostring(entityID)))
            Log(string.format('Using entity path: %s', entityPath))
            return true
        end
        if ok and not entityID then
            Log(string.format('Path not found (returned nil): %s', entityPath))
        end
    end

    -- All paths failed with exEntitySpawner, try WorldFunctionalTests as fallback
    Log('All entity paths failed with exEntitySpawner.Spawn')
    Log('Trying WorldFunctionalTests.SpawnEntity as fallback...')
    for i, entityPath in ipairs(ENTITY_PATHS) do
        Log(string.format('Trying fallback [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
        local ok, entityID = SafeCall('WorldFunctionalTests.SpawnEntity', function()
            return WorldFunctionalTests.SpawnEntity(entityPath, spawnTransform, ENTITY_APPEARANCE)
        end)
        if ok and entityID then
            state.shellEntityID = entityID
            state.pendingSpawn = true
            state.shellEntityValid = false
            state.shellEntity = nil
            state.currentEntityPath = entityPath
            Log(string.format('Spawn requested via WorldFunctionalTests, entity ID: %s (pending...)', tostring(entityID)))
            return true
        end
        if ok and not entityID then
            Log(string.format('Fallback path not found (returned nil): %s', entityPath))
        end
    end

    Log('ERROR: Spawn failed - no entity path worked with any spawn API')
    Log('Check that the entity paths exist in your game version')
    return false
end
```

## Error Analysis

### Phase 1: exEntitySpawner.Spawn — All 7 Paths Failed

The code tried each of the 7 entity paths with `exEntitySpawner.Spawn`. Every single one returned `nil` (no error thrown, just silent nil return):

| # | Entity Path | Result |
|---|---|---|
| 1 | `base\_ieee\ieee_03_km.ent` | Path not found (returned nil) |
| 2 | `base\_ieee\ieee_04_km.ent` | Path not found (returned nil) |
| 3 | `base\_ieee\ieee_05_km.ent` | Path not found (returned nil) |
| 4 | `base\_ieee\ieee_06_km.ent` | Path not found (returned nil) |
| 5 | `base\_ieee\ieee_07_km.ent` | Path not found (returned nil) |
| 6 | `base\_ieee\ieee_08_km.ent` | Path not found (returned nil) |
| 7 | `base\_ieee\init_spawner_demo.ent` | Path not found (returned nil) |

**Key detail**: `exEntitySpawner.Spawn` did not throw errors — the `SafeCall` wrapper reported `ok = true` but `entityID = nil` for every path. This means the engine accepted the call but could not resolve the entity template path.

### Phase 2: WorldFunctionalTests.SpawnEntity Fallback — All 7 Paths Failed

After all `exEntitySpawner.Spawn` attempts returned nil, the code fell back to `WorldFunctionalTests.SpawnEntity`. Same result — all 7 paths returned nil:

| # | Entity Path | Result |
|---|---|---|
| 1 | `base\_ieee\ieee_03_km.ent` | Fallback path not found (returned nil) |
| 2 | `base\_ieee\ieee_04_km.ent` | Fallback path not found (returned nil) |
| 3 | `base\_ieee\ieee_05_km.ent` | Fallback path not found (returned nil) |
| 4 | `base\_ieee\ieee_06_km.ent` | Fallback path not found (returned nil) |
| 5 | `base\_ieee\ieee_07_km.ent` | Fallback path not found (returned nil) |
| 6 | `base\_ieee\ieee_08_km.ent` | Fallback path not found (returned nil) |
| 7 | `base\_ieee\init_spawner_demo.ent` | Fallback path not found (returned nil) |

### Final Error

```
[CE1] ERROR: Spawn failed - no entity path worked with any spawn API
[CE1] Check that the entity paths exist in your game version
```

## Root Cause

All 7 entity template paths are returning `nil` from both spawn APIs. The entity paths `base\_ieee\ieee_XX_km.ent` and `base\_ieee\init_spawner_demo.ent` **do not exist in the game's current archive**. The engine silently returns `nil` when it cannot resolve the template path rather than throwing an error.

### Additional Issue: OrbHackingBridge Missing

```
[CE1] WARNING: OrbHackingBridge not found. Is REDscript mod installed?
[CE1] Entity spawning will work but action execution tests will fail.
```

The REDscript bridge (`OrbHackingBridge`) is not loaded — likely a REDscript compilation error. While this does not block spawning, it means even if the entity spawned successfully, all action execution tests would fail.

## What Needs to Happen Next

1. **Fix entity paths**: The `base\_ieee\ieee_XX_km.ent` paths need to be verified against the actual game archive. Either find correct existing entity paths, or create/pack the custom `.ent` files into the game using WolvenKit/ArchiveXL
2. **Fix OrbHackingBridge**: Investigate the REDscript compilation error preventing `OrbHackingBridge` from loading (prior solution: check for duplicate blocks in `.reds` file and field name mismatches like `QuickHack` vs `deviceAction`)
