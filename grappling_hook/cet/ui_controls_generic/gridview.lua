local this = {}

function CalcSize_GridView(def, style, const, line_heights, scale)
	if not def.sizes then
        def.sizes =
        {
            -- Measured sizes.  Each element has .width, .height
            -- These are both arrays of the text's size (these don't take into account the header's min/max,
            -- just the actual size)
            headers = {},           -- 1D array
            cells = {},             -- jagged array

            -- final sizes
            final_columns = {},     -- width of each column, taking min/max width into account
            final_row_header = 0,   -- height of header
            final_rows_cells = {},  -- height of each row
        }
    end

    -- Calculate size of the text
    this.Calculate_Size(def.headers, def.headers, def.sizes.headers, scale)

    for i = 1, #def.cells do
        if i > #def.sizes.cells then
            def.sizes.cells[i] = {}
        end

        this.Calculate_Size(def.headers, def.cells[i], def.sizes.cells[i], scale)
    end

    -- Store final column widths
    for i = 1, #def.headers do
        def.sizes.final_columns[i] = this.GetFinalWidth_Column(def.headers[i], def.sizes, i, scale)
    end

    -- Final height of each line
    def.sizes.final_row_header = this.GetFinalHeight_Row(def.sizes.headers, style.gridview.min_row_height, scale)

    for i = 1, #def.sizes.cells do
        def.sizes.final_rows_cells[i] = this.GetFinalHeight_Row(def.sizes.cells[i], style.gridview.min_row_height, scale)
    end

    def.render_pos.width = this.GetFinalWidth(def.sizes.final_columns, style.gridview.gap_horizontal * scale)
    def.render_pos.height = this.GetFinalHeight(def.sizes, style.gridview.gap_vertical * scale)
end

function Draw_GridView(def, style_grid, style_colors, const, scale)
    local y = def.render_pos.top

    ---------- Headers ----------
    if def.sizes.final_row_header > 0 then
        ImGui.PushStyleColor(ImGuiCol.Text, style_grid.foreground_color_header_abgr)

        local x = def.render_pos.left

        this.DrawRow(
            x,
            y,
            def.headers,
            def.headers,        -- passing headers as the row to draw.  This is possible because GridView_Header and GridView_Cell both have a .text property
            def.sizes.headers,
            def.sizes.final_columns,
            def.sizes.final_row_header,
            style_grid.gap_horizontal * scale,
            style_colors,
            const,
            true)

        y = y + def.sizes.final_row_header

        ImGui.PopStyleColor()
    end

    ---------- Cells ----------
    ImGui.PushStyleColor(ImGuiCol.Text, style_grid.foreground_color_cell_abgr)      -- individual cells might override this, push/pop their own

    for i = 1, #def.cells do
        if def.sizes.final_rows_cells[i] > 0 then     -- don't draw completely empty rows
            if y > def.render_pos.top then
                y = y + (style_grid.gap_vertical * scale)
            end

            local x = def.render_pos.left

            this.DrawRow(
                x,
                y,
                def.headers,
                def.cells[i],
                def.sizes.cells[i],
                def.sizes.final_columns,
                def.sizes.final_rows_cells[i],
                style_grid.gap_horizontal * scale,
                style_colors,
                const,
                false)

            y = y + def.sizes.final_rows_cells[i]
        end
    end

    ImGui.PopStyleColor()
end

----------------------------------- Private Methods -----------------------------------

-- Measures the width of each cell in row, stores in list
function this.Calculate_Size(headers, row, list, scale)
    local width = 0
    local height = 0

    for i = 1, #headers do
        if i <= #row and row[i].text then
            if headers[i].max_width then
                width, height = ImGui.CalcTextSize(row[i].text, false, headers[i].max_width * scale)        -- possible word wrapping
            else
                width, height = ImGui.CalcTextSize(row[i].text)
            end
        else
            -- Text is nil, or more headers than cell columns
            width = 0
            height = 0
        end

        if not list[i] then
            list[i] = {}
        end

        list[i].width = width
        list[i].height = height
    end
end

-- Gets the width of this cell, taking the header's min/max into account
function this.GetFinalWidth_Column(header, sizes, col, scale)
    --NOTE: max_width is already accounted for in headers.width and cells.width

    local retVal = sizes.headers[col].width     -- header and cell width already have scale applied (in this.Calculate_Size)

    for row = 1, #sizes.cells do
        retVal = math.max(retVal, sizes.cells[row][col].width)
    end

    if header.min_width then
        retVal = math.min(retVal, header.min_width * scale)
    end

    return retVal
end

-- Gets the height of this row, taking the style's min_row_height into account
function this.GetFinalHeight_Row(row, min, scale)
    local retVal = 0

    for i = 1, #row do
        retVal = math.max(retVal, row[i].height)
    end

    -- If zero, then there is no text.  It should not be shown, so don't apply min height
    if IsNearZero(retVal) then
        return retVal
    end

    if min then
        retVal = math.max(retVal, min * scale)
    end

    return retVal
end

function this.GetFinalWidth(columns, gap)
    local retVal = 0

    for i = 1, #columns do
        if i > 1 then
            retVal = retVal + gap
        end

        retVal = retVal + columns[i]
    end

    return retVal
end
function this.GetFinalHeight(sizes, gap)
    local retVal = 0

    if sizes.final_row_header > 0 then
        retVal = sizes.final_row_header
    end

    for i = 1, #sizes.final_rows_cells do
        if sizes.final_rows_cells[i] > 0 then
            if retVal > 0 then
                retVal = retVal + gap
            end

            retVal = retVal + sizes.final_rows_cells[i]
        end
    end

    return retVal
end

function this.DrawRow(x, y, headers, row, sizes_text, final_columns, final_row, gap_horizontal, style_colors, const, isHeader)
    for i = 1, #headers do
        -- Since cells is a jagged array, it's possible that not all rows will be filled out completely
        if #row >= i then
            --NOTE: foreground_override is only defined for cells.  This check is harmless for headers, since it will always be nil for headers
            if row[i].foreground_override then
                local color = GetNamedColor(style_colors, row[i].foreground_override)
                ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_abgr)
            end

            local align = headers[i].horizontal
            if isHeader then
                align = const.alignment_horizontal.center
            end

            this.DrawCell(
                x,
                y,
                row[i].text,
                sizes_text[i].width,
                sizes_text[i].height,
                final_columns[i],
                final_row,
                align,
                headers[i].max_width ~= nil,
                const)

            if row[i].foreground_override then
                ImGui.PopStyleColor()
            end
        end

        x = x + final_columns[i] + gap_horizontal
    end
end

function this.DrawCell(x, y, text, text_width, text_height, cell_width, cell_height, alignment, has_maxWidth, const)
    if not text or text == "" then
        do return end
    end

    local left
    if alignment == const.alignment_horizontal.left then
        left = x

    elseif alignment == const.alignment_horizontal.center then
        left = x + (cell_width / 2) - (text_width / 2)

    elseif alignment == const.alignment_horizontal.right then
        left = x + cell_width - text_width

    else
        LogError("DrawCell: Unknown alignment: " .. tostring(alignment))
    end

    local top = y + (cell_height / 2) - (text_height / 2)

    ImGui.SetCursorPos(left, top)

    if has_maxWidth then
        ImGui.PushTextWrapPos(left + text_width)        -- the text_width calculation already considered header.max_width
    end

    ImGui.Text(text)

    if has_maxWidth then
        ImGui.PopTextWrapPos()
    end
end