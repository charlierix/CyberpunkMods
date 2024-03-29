local this = {}

function CalculateSizes(render_nodes, style, line_heights)
    for i = 1, #render_nodes do
        local control = render_nodes[i].control

        this.EnsureRenderPosExists(control)

        -- The control will calculate its size and store the result in control.render_pos
        if control.CalcSize then
            control.CalcSize(control, style, line_heights)      --NOTE: CalcSize is just a delegate to a static method, so can't use the :, need to pass control explicitely
        else
            LogError("Control doesn't have CalcSize")
            ReportTable(control)
        end

        -- Recurse
        if render_nodes[i].children then
            CalculateSizes(render_nodes[i].children, style, line_heights)
        end
    end
end

function CalculatePositions(render_nodes, parent_width, parent_height, const)
    for i = 1, #render_nodes do
        local control = render_nodes[i].control

        local left, top = GetControlPosition(control.position, control.render_pos.width, control.render_pos.height, parent_width, parent_height, const)
        control.render_pos.left = left
        control.render_pos.top = top

        -- Recurse
        if render_nodes[i].children then
            CalculatePositions(render_nodes[i].children, parent_width, parent_height, const)
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