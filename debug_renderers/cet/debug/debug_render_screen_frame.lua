local DebugRenderScreen_Frame = {}

local this = {}

-- Looks at the high level 3D items, creates 2D circles/lines/triangles that will be shown in the draw event
function DebugRenderScreen_Frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line)
    this.ClearVisuals(visuals_circle, visuals_line)

    if not controller then      -- should never happen
        do return end
    end

    for _, item in ipairs(items) do
        if item.item_type == item_types.dot then
            this.RebuildVisuals_Dot(controller, item, visuals_circle)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.ClearVisuals(visuals_circle, visuals_line)
    while #visuals_circle > 0 do
        table.remove(visuals_circle, 1)
    end

    while #visuals_line > 0 do
        table.remove(visuals_line, 1)
    end
end

function this.RebuildVisuals_Dot(controller, item, visuals_circle)
    local point = controller:ProjectWorldToScreen(item.position)

    if not this.IsValidScreenPoint(point) then
        do return end
    end

    local size_mult = 1
    if item.size_mult then
        size_mult = item.size_mult
    end

    local visual =
    {
        color_background = this.GetColor_ABGR(item.color),
        color_border = nil,
        thickness = nil,
        center_x = point.X,
        center_y = point.Y,
        radius = 6 * size_mult,
    }

    table.insert(visuals_circle, visual)
end

function this.GetColor_ABGR(color)
    if not color then
        local magenta = ConvertHexStringToNumbers_Magenta()
        return magenta
    end

    local _, color_abgr = ConvertHexStringToNumbers()
    return color_abgr
end

function this.IsValidScreenPoint(point)
    return not ((point.X == -1 or point.X == 1) and (point.Y == -1 or point.Y == 1))
end

return DebugRenderScreen_Frame