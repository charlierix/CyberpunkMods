local this = {}

local DISTANCE = 3

-- New version (still unreliable)

function SpawnNPC_exEntitySpawner_FromAMM_MoreNotesThanCode(path, pos, quat)
    local transform = Game.GetPlayer():GetWorldTransform()
    transform:SetOrientation(quat)
    transform:SetPosition(pos)


    -- local props = {}
    -- for prop in db:nrows(f("SELECT * FROM saved_props WHERE trigger = '%s'", trigger.str)) do
    --   table.insert(props, Props:NewProp(prop.uid, prop.entity_id, prop.name, prop.template_path, prop.pos, prop.tag))
    -- end


--------------------------    

    --https://github.com/yamashi/CyberEngineTweaks/pull/572

    -- spawnPosition = Game.GetPlayer():GetWorldTransform()

    -- -- [Simple]
    -- -- Spawn 'Character.Judy' just like prevention system
    -- -- Optionally set appearance to 'judy_diving_suit'
    -- judyEntityID = exEntitySpawner.SpawnRecord('Character.Judy', spawnPosition)
    -- judyEntityID = exEntitySpawner.SpawnRecord('Character.Judy', spawnPosition, 'judy_diving_suit')
    
    -- -- [Advanced]
    -- -- Spawn base\quest\secondary_characters\judy.ent
    -- -- Optionally set appearance to 'default'
    -- -- Optionally set TweakDB record to 'Character.Judy' (VO/Name/Equipment/etc)
    -- judyEntityID = exEntitySpawner.Spawn([[base\quest\secondary_characters\judy.ent]], spawnPosition)
    -- judyEntityID = exEntitySpawner.Spawn([[base\quest\secondary_characters\judy.ent]], spawnPosition, 'default')
    -- judyEntityID = exEntitySpawner.Spawn([[base\quest\secondary_characters\judy.ent]], spawnPosition, 'default', 'Character.Judy')
    
    -- -- Some time later...
    -- -- entities are not spawned instantly, FindEntityByID may return nil
    -- judy = Game.FindEntityByID(judyEntityID)
    
    -- exEntitySpawner.Despawn(judy)


------------------------













    -- psiberx — 08/11/2021
    -- exEntitySpawner.Spawn("base\\gameplay\\devices\\arcade_machines\\arcade_machine_1.ent", Game.GetPlayer():GetWorldTransform())
    -- huh that was unexpected: crashes on release 1.15 (and any github build since exEntitySpawner) but works fine on build from source


    --local template = ????
    local template = [[base\gameplay\devices\home_appliances\movable_wall_screen\movable_wall_screen.ent]]


    ent.entityID = exEntitySpawner.Spawn(template, transform)
end

-- This sort of works.  They spawn quickly, but won't shoot when hostile.  Also, I grabbed one to choke out.
-- While grabbed, I backed up and they didn't move (I was still in the grab animation).  Couldn't do anything
-- until I got close to them again, then they knocked me off of them
function SpawnNPC_exEntitySpawner(o, path)
    local transform = this.GetTransform_InFrontOfPlayer(o)

    local appearance = ''

    exEntitySpawner.SpawnRecord(path, transform, appearance)        -- third param is optional, fourth param is optional tweakdb record (not sure what the advantage of that is, maybe cross saves?)
end

function Despawn_exEntitySpawner(handle)
    exEntitySpawner.Despawn(handle)
end

--------------------

-- Legacy version

-- This works, but they don't really spawn at the ground.  Would need to do some ray casts to make sure they are on the ground
-- It also takes a long time for them to spawn.  Not sure how AMM does it so quickly
function SpawnNPC_PreventionSpawnSystem(o, path)
    local transform = this.GetTransform_InFrontOfPlayer(o)

    -- preventionLevel: 0 thru 4
    local preventionLevel = -99     -- not sure what using a negative number will do for an unsigned int
    --local preventionLevel = 5

    --public native RequestSpawn(recordID: TweakDBID, preventionLevel: Uint32, spawnTransform: WorldTransform): EntityID
	local entityID = Game.GetPreventionSpawnSystem():RequestSpawn(TweakDBID.new(path), preventionLevel, transform)

    print("SpawnNPC_PreventionSpawnSystem: " .. tostring(entityID))

    return entityID
end

-- Despawn seems to happen naturally.  I don't think they persist if you reload
function DespawnNPC_PreventionSpawnSystem()
end

----------------------------------- Private Methods -----------------------------------

-- TODO: Do a ray cast to put them on the ground
function this.GetTransform_InFrontOfPlayer(o)
    local transform = o:GetPlayerWorldTransform()
    if not transform then
        print("couldn't get world transform")
        do return end
    end

    o:GetCamera()
    if not o.camera then
        print("couldn't get camera")
        do return end
    end

    local spawnPoint = Vector4.new(o.pos.x + (o.lookdir_forward.x * DISTANCE), o.pos.y + (o.lookdir_forward.y * DISTANCE), o.pos.z + (o.lookdir_forward.z * DISTANCE), 1)

    transform:SetPosition(spawnPoint)

    return transform
end