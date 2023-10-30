local this = {}

function CalculateSizes(render_nodes, style, const, line_heights, scale)
    for i = 1, #render_nodes do
        local control = render_nodes[i].control

        this.EnsureRenderPosExists(control)

        -- The control will calculate its size and store the result in control.render_pos
        if control.CalcSize then
            control.CalcSize(control, style, const, line_heights, scale)      --NOTE: CalcSize is just a delegate to a static method, so can't use the :, need to pass control explicitely
        else
            LogError("ERROR: Control doesn't have CalcSize")
            ReportTable(control)
        end

        -- Recurse
        if render_nodes[i].children then
            CalculateSizes(render_nodes[i].children, style, const, line_heights, scale)
        end
    end
end

function CalculatePositions(render_nodes, parent_width, parent_height, const, scale)
    for i = 1, #render_nodes do
        local control = render_nodes[i].control

        local left, top = GetControlPosition(control.position, control.render_pos.width, control.render_pos.height, parent_width, parent_height, const, scale)
        control.render_pos.left = left
        control.render_pos.top = top

        -- Recurse
        if render_nodes[i].children then
            CalculatePositions(render_nodes[i].children, parent_width, parent_height, const, scale)
        end
    end
end

-- This is for controls that are part of a child element (like a scrollable listbox)
function AdjustPositions(render_nodes, x, y)
    for _, node in ipairs(render_nodes) do
        local control = node.control

        control.render_pos.left = control.render_pos.left + x
        control.render_pos.top = control.render_pos.top + y

        -- Recurse
        if node.children then
            AdjustPositions(node.children, x, y)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureRenderPosExists(control)
    if not control.render_pos then
        control.render_pos =
        {
            width = 0,
            height = 0,
            left = 0,
            top = 0,
        }
    end
end