local OrbSwarmGoals = {}

local this = {}

local swarm_util = require "processing/swarm_util"

function OrbSwarmGoals.GetAccelGoals(props, interested_items, goals, limits)
    if interested_items:GetCount() == 0 then
        return 0, 0, 0, 0
    end

    local accel_x = 0
    local accel_y = 0
    local accel_z = 0
    local max_goal_percent = 0

    for i = 1, interested_items:GetCount(), 1 do
        local interested_item = interested_items:GetItem(i)

        local toward_item = SubtractVectors(interested_item.item.pos, props.pos)
        local distance = GetVectorLength(toward_item)

        local reported_goal_percent = this.GetReportedGoalPercent(interested_item.percent, distance, goals)
        max_goal_percent = math.max(max_goal_percent, reported_goal_percent)

        if not IsNearZero(distance) then
            local toward_item_unit = DivideVector(toward_item, distance)

            -- attract toward the item
            local accel_dist_x, accel_dist_y, accel_dist_z = this.AccelByDistance(toward_item_unit, distance, goals.accel_distance, limits.max_accel)

            -- drag orth toward item
            local accel_orthvel_x, accel_orthvel_y, accel_orthvel_z = swarm_util.Drag_Orth_Velocity(toward_item_unit, props.vel, distance, goals.drag_orth_velocity_speed, goals.drag_orth_velocity_distance, limits.max_accel, limits.max_speed)

            -- combine these, taking interest percent into account
            accel_x = accel_x + ((accel_dist_x + accel_orthvel_x) * interested_item.percent)
            accel_y = accel_y + ((accel_dist_y + accel_orthvel_y) * interested_item.percent)
            accel_z = accel_z + ((accel_dist_z + accel_orthvel_z) * interested_item.percent)
        end
    end

    return accel_x, accel_y, accel_z, max_goal_percent
end

----------------------------------- Private Methods -----------------------------------

function this.AccelByDistance(toward_item_unit, distance, accel_distance, max_accel)
    local percent_accel = swarm_util.ApplyPropertyMult(accel_distance, distance)

    return
        toward_item_unit.x * percent_accel * max_accel,
        toward_item_unit.y * percent_accel * max_accel,
        toward_item_unit.z * percent_accel * max_accel
end

function this.GetReportedGoalPercent(percent, distance, goals)
    local adjust_percent = swarm_util.ApplyPropertyMult(goals.report_percent_distance, distance)

    return percent * adjust_percent
end

return OrbSwarmGoals