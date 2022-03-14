local this = {}

local MOVE_RATIO = 0.2
local HALF_DEAD_SIZE = 0.1

-- The player should be a set distance from walls, but shouldn't just snap to that desired
-- distance.  So this function slides them along the wall's normal toward that ideal distance
-- based on how far they moved parallel to the wall this frame
-- Params:
--  position            the player's position
--  normal              the normal of the wall that the player is attached to (needs to be a unit vector)
--  ideal_distance      how far the player should be from the wall
--  current_distance    how far the player is currently from the wall
--  horz_moved          how far the player has moved this frame (parallel to the wall)
-- Returns:
--  New position (slid along normal toward ideal distance)
function MoveToIdealDistance(position, normal, ideal_distance, current_distance, horz_moved)
    local dist_from_ideal = current_distance - ideal_distance
    local abs_dist_from_ideal = math.abs(dist_from_ideal)

    local percent = 1
    if abs_dist_from_ideal < HALF_DEAD_SIZE then
        percent = GetScaledValue(0, 1, 0, HALF_DEAD_SIZE, abs_dist_from_ideal)
    end

    local max_can_move = horz_moved * MOVE_RATIO * percent

    if abs_dist_from_ideal <= max_can_move then
        return this.GetNewPosition(position, normal, -dist_from_ideal)
    elseif dist_from_ideal < 0 then
        return this.GetNewPosition(position, normal, max_can_move)
    else
        return this.GetNewPosition(position, normal, -max_can_move)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetNewPosition(position, normal, distance)
    return Vector4.new(
        position.x + (normal.x * distance),     -- it's expected that normal is a unit vector
        position.y + (normal.y * distance),
        position.z + (normal.z * distance),
        1)
end