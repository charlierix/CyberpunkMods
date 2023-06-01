local Harvester = {}

local this = {}

local MAX_MOVE_RADIUS = 0.1
local RADIUS = 1      -- TODO: this should come from config
local ELAPSED_START = 0.25
local ELAPSED_FINISH = 2

local is_harvesting = false
local harvsting_start = 0
local initial_pos = nil
local initial_lookdir = nil
local initial_bodies = nil

function Harvester.Tick(o, keys, map, scanner_player)
    if is_harvesting then
        this.ContinueHarvesting(o, keys, map, scanner_player)
    else
        this.TryStartHarvesting(o, keys, map, scanner_player)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.TryStartHarvesting(o, keys, map, scanner_player)
    if not (keys.proceed and o.timer - keys.proceed_downtime > ELAPSED_START) then        -- F key.  Don't even start considering it until it's been held in a while (F is used a lot and don't want to do extra work until they're actually holding it in)
        do return end
    end

    if not o:IsCrouching() then
        do return end
    end

    --TODO: also look for defeated.  Defeated should take some time to kill, then raise, but should become a higher quality orb

    scanner_player:EnsureScanned()
    local bodies = map:GetNearby(o.pos, RADIUS, true, true, true, false)
    if #bodies == 0 then
        do return end
    end

    o:GetCamera()

    is_harvesting = true
    harvsting_start = o.timer
    initial_pos = o.pos
    initial_lookdir = o.lookdir_forward
    initial_bodies = bodies

    --TODO: give visual/audio clues

end

function this.ContinueHarvesting(o, keys, map, scanner_player)
    if not keys.proceed then
        this.CancelHarvest()
        do return end

    elseif not o:IsCrouching() then
        this.CancelHarvest()
        do return end

    elseif GetVectorDiffLengthSqr(o.pos, initial_pos) > MAX_MOVE_RADIUS * MAX_MOVE_RADIUS then
        this.CancelHarvest()
        do return end
    end

    if o.timer - harvsting_start > ELAPSED_FINISH then
        this.FinishHarvest(o, map, scanner_player)
        do return end
    end

    --TODO: if weapon is out, mark for corruption

    --TODO: if the look direction goes higher than horizontal then mark for corruption

    --TODO: if the look direction strays too far from initial, mark for corruption




    --TODO: progress visual/audio clues
    -- if corruption is occurring, give a negative sounding hint


    debug_render_screen.Add_Text2D(0.5, 0.6, "harvesting " .. tostring(#initial_bodies), nil, "A0643F0F", "FFF", nil, true)
end

function this.CancelHarvest()
    is_harvesting = false

    --TODO: mark interrupted bodies as corrupted based on time spent cooking

    --TODO: visual/audio failure

    debug_render_screen.Add_Text2D(0.5, 0.6, "harvest cancelled", nil, "B35E4440", "FFF", 2)

end

function this.FinishHarvest(o, map, scanner_player)
    scanner_player:EnsureScanned()
    local bodies = map:GetNearby(o.pos, RADIUS, true, true, true, false)

    local count = 0

    for _, body in ipairs(bodies) do
        local entity = Game.FindEntityByID(body.entityID)
        if entity then



            --TODO: the loot in the body also get disposed.  Either spawn them, or keep track of what they are and let them boost the spawned orb
            entity:Dispose()



            local vel = GetRandomVector_Cone(Vector4.new(0, 0, 1, 1), 0, 30, 0.1, 0.6)

            orb_pool.Add(body, o, vel)
            count = count + 1
        end

        -- either way, remove from the map
        map:Remove(body)
    end

    is_harvesting = false


    --TODO: visual/audio


    if count == 0 then
        debug_render_screen.Add_Text2D(0.5, 0.6, "nothing to harvest", nil, "B3A71D0B", "FFF", 2)
    else
        debug_render_screen.Add_Text2D(0.5, 0.6, "harvested " .. tostring(count), nil, "A0324121", "FFF", 2)
    end
end

return Harvester