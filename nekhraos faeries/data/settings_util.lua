local SettingsUtil = {}

local this = {}

function SettingsUtil.Limits_ORIG()
    -- models\swarmbot_limits
    return
    {
        min_speed = 0.5,
        max_speed = 4,
        max_dist_player = 12,
        max_accel = 1.5,

        boundary_percent_start = 0.75,
        speed_percent_start = 0.8,

        maxbyspeed =
        {
            percent_start = 7,

            speed_mult =
            {
                rate = 1.5,
                cap_min = 1,
                cap_max = 6,
            },

            dist_mult =
            {
                rate = 1.333,
                cap_min = 1,
                cap_max = 3,
            },
        },
        maxbydist =
        {
            speed_mult =
            {
                rate = 1.6667,
                cap_min = 1,
                cap_max = 12,
            },
        },

        outofbounds_speedingaway =
        {
            accel_mult_speed =      -- really letting it get big so the orb can turn around quickly
            {
                rate = 1,
                cap_min = 0,
                cap_max = 12,
            },
            accel_mult_bounds =     -- this isn't as important as reversing speed
            {
                rate = 1,
                cap_min = 0,
                cap_max = 1,
            }
        },
        outofbounds =
        {
            accel_mult =
            {
                rate = 4,
                cap_min = 0,
                cap_max = 2,
            },
        },
        overspeed =
        {
            accel_mult =
            {
                rate = 3,
                cap_min = 0,
                cap_max = 2,
            },
        },

        dragorthvelocity =
        {
            accel_mult =
            {
                rate = 0.15,
                cap_min = 0,
                cap_max = 0.6667,
            },
        },
    }
end

function SettingsUtil.Limits()
    -- models\swarmbot_limits
    return this.DeserializeJSON("!configs/limits.json")
end

function SettingsUtil.Neighbors()
    -- models\swarmbot_neighbors
    return this.DeserializeJSON("!configs/neighbors.json")
end

----------------------------------- Private Methods -----------------------------------

-- Small wrapper to file.open and json.decode
-- Returns
--  object, nil
--  nil, errMsg
function this.DeserializeJSON(filename)
    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local sucess, retVal = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if sucess then
        return retVal, nil
    else
        return nil, tostring(retVal)      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value.  It should already be a sting, but doing a tostring just to be safe
    end
end

return SettingsUtil