local this = {}

local isDragging = false

local previousPosition3D = nil
local forward = nil
local up = nil

function DrawWindow_Trackball(vars, vars_ui, o, window, debug, const)
    local style_trackball = vars_ui.style.trackball

    -- Use this so the window will snap to this size
    local total_size = style_trackball.size + (style_trackball.margin * 2)
    ImGui.SetCursorPos(0, window.title_height)
    ImGui.Dummy(total_size, total_size)

    local offset = 5        -- for some reason, everything is drawing a little negative left and up

    local center = (style_trackball.size / 2) + style_trackball.margin + offset
    local center_x = center
    local center_y = center + window.title_height
    local radius = (style_trackball.size / 2) * style_trackball.radius_percent      -- making the ball smaller than it needs to be will allow them to drag beyond the ball a little.  This makes it easier to over rotate a little and won't stop abruptly (wouldn't be needed if mouse was captured on mouse down, released on mouse up)

    -- NOTE: None of these functions are accessible to CET: ImGui.IsMouseClicked(0, false), ImGui.IsMouseReleased(0), ImGui.IsMouseDown(0)
    -- Fortunately, IsItemClicked returns true on mouse down and InvisibleButton returns true when the mouse is released

    local isClickEnded, isHovered = Draw_InvisibleButton("Trackball_Background", center_x, center_y, style_trackball.size, style_trackball.size, 0)
    local isClickStarted = isHovered and ImGui.IsItemClicked(0)
    if isClickStarted then      -- 0 is left mouse button
        isDragging = true       -- IsItemClicked only fires for one frame
    elseif isClickEnded or not isHovered then        -- isClickEnded only fires for one frame
        isDragging = false
    end

    if isDragging then
        this.HandleDragging(window.left + center_x, window.top + center_y, radius, isClickStarted, vars.deltas, const, debug)
    end

    Draw_Circle(window.left, window.top, center_x, center_y, radius, isHovered, style_trackball.glass_color_back_standard_abgr, style_trackball.glass_color_back_hovered_abgr, style_trackball.glass_color_border_standard_abgr, style_trackball.glass_color_border_hovered_abgr, style_trackball.glass_thickness)

    --TODO: Draw a faint arc to simulate sphere glass reflection
    --ImDrawList::PathArcTo (see if this is this a standalone function.  Other functions have the word add in them)

    local forward, up = this.GetRotatedLines(o)

    this.DrawGradientLine(window.left, window.top, center_x, center_y, radius, forward, style_trackball, "forward_color")
    this.DrawGradientLine(window.left, window.top, center_x, center_y, radius, up, style_trackball, "up_color")
end

----------------------------------- Private Methods -----------------------------------

function this.HandleDragging(center_x_screen, center_y_screen, radius, isClickStarted, deltaList, const, debug)
    local pos2D_x, pos2D_y = this.GetPosition2D(center_x_screen, center_y_screen)
    local pos3D = this.ProjectToTrackball(pos2D_x, pos2D_y, radius)

    if not isClickStarted then      -- if this is the start, then let it go a frame so that there are two points
        -- Calculate the delta quaternion between the two points on a sphere
        local delta = GetRotation(previousPosition3D, pos3D, const.trackball_mult)
        if not IsIdentityQuaternion(delta) then

            --TODO: May need to rotate this delta by some fixed offset
            if const.shouldShowDebugWindow then
                debug.delta_axis = vec_str(delta:GetAxis())
                debug.delta_angle = Round(Radians_to_Degrees(delta:GetAngle()), 1)
            end


            deltaList[#deltaList+1] = delta
        end
    end

    previousPosition3D = pos3D
end

function this.GetPosition2D(center_x_screen, center_y_screen)
    local mouse_x, mouse_y = ImGui.GetMousePos()

    return
        mouse_x - center_x_screen,
        mouse_y - center_y_screen
end

-- This pretends the 2D point is a ray pointed straight down onto a sphere and returns the hit
-- point on that sphere
function this.ProjectToTrackball(x, y, radius)
    -- Scale the inputs so -1 to 1 is the edge of the circle
    x = x / radius
    y = y / radius

    y = -y;     -- Flip so +Y is up instead of down

    -- Wrap (otherwise, everything greater than 1 will map to the permiter of the sphere where z = 0)
    local x1, invertX = this.ProjectToTrackball_Wrap(x);
    local y1, invertY = this.ProjectToTrackball_Wrap(y);

    local shouldInvertZ = invertX or invertY

    x = x1
    y = y1

    -- Project onto a sphere
    local z2 = 1 - (x * x) - (y * y)        -- z^2 = 1 - x^2 - y^2
    local z = 0
    if z2 > 0 then      -- NOTE:  The wrap logic above should make it so is always true
        z = math.sqrt(z2);
    end

    if shouldInvertZ then
        z = -z
    end

    return Vector4.new(x, y, z)
end

-- This wraps the value so it stays between -1 and 1
--
-- This function is only needed when they drag beyond the ball's bounds.  For example, they start dragging and keep
-- dragging to the right.  Since the mouse is captured, mouse events keep firing even though the mouse is off the control.
-- As they keep dragging, the value needs to wrap by multiples of the control's radius (value was normalized to between
-- -1 and 1, so this can hardcoded to 4)
--
-- NOTE: this lua script stops dragging when no longer hovered, but this code was copied from a c# control that properly
-- captures/releases the mouse.  Even though it's limited use here, the effect is still seen if they drag into the corners
-- of this control (outside the radius of the circle)
function this.ProjectToTrackball_Wrap(value)
    -- Everything starts over at 4 (4 becomes zero)
    local retVal = value % 4

    local abs = math.abs(retVal)
    local isNeg = retVal < 0

    local shouldInvertZ = false

    if abs >= 3 then
        -- Anything from 3 to 4 needs to be -1 to 0
        -- Anything from -4 to -3 needs to be 0 to 1
        retVal = 4 - abs

        if not isNeg then
            retVal = -retVal
        end
    elseif abs > 1 then
        -- This is the back side of the sphere
        -- Anything from 1 to 3 needs to be flipped (1 stays 1, 2 becomes 0, 3 becomes -1)
        -- -1 stays -1, -2 becomes 0, -3 becomes 1
        retVal = 2 - abs

        if isNeg then
            retVal = -retVal
        end

        shouldInvertZ = true
    end

    return retVal, shouldInvertZ
end

function this.GetRotatedLines(o)
    if not forward then
        forward = Vector4.new(0, 1, 0, 1)
    end

    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local quat = o:FPP_GetLocalOrientation()

    local rot_forward = RotateVector3D(forward, quat)
    local rot_up = RotateVector3D(up, quat)

    rot_forward.y = -rot_forward.y
    rot_up.y = -rot_up.y

    return rot_forward, rot_up
end

-- TODO: Clean this up and make it a generic function
-- There doesn't appear to be a native function that takes a gradient, so draw several lines, each with
-- a color and thickness for that section
function this.DrawGradientLine(screenOffset_x, screenOffset_y, center_x, center_y, radius, pos3D, style_trackball, colorKey)
    if IsNearZero(pos3D.x) and IsNearZero(pos3D.y) then
        -- Straight up and down
        do return end
    end

    if IsNearZero(pos3D.z) then
        -- The entire line is the zero color
        Draw_Line(screenOffset_x, screenOffset_y, center_x, center_y, center_x + (pos3D.x * radius), center_y + (pos3D.y * radius), style_trackball[colorKey .. "_zeroZ_abgr"], style_trackball.line_thickness_zeroZ)
    end

    -- Get the from/to colors (always drawing from zero out).  The line won't reach all the way to the
    -- to color
    local suffix = "_negZ"
    if pos3D.z > 0 then
        suffix = "_posZ"
    end

    local from_a, from_h, from_s, from_v = this.GetHSVFromColorKey(style_trackball, colorKey, "_zeroZ")
    local to_a, to_h, to_s, to_v = this.GetHSVFromColorKey(style_trackball, colorKey, suffix)

    local from_thickness = style_trackball.line_thickness_zeroZ
    local to_thickness = style_trackball["line_thickness" .. suffix]

    local num_segments = math.ceil(radius / 4)      -- every four pixels

    local x1 = 0
    local y1 = 0

    for i = 0, num_segments - 1 do
        -- To Position
        local percent = (i + 1) / num_segments
        local x2 = pos3D.x * percent       -- pos3D is 0 to 1
        local y2 = pos3D.y * percent

        -- Color
        percent = (i + 0.5) / num_segments      -- use the midway point
        percent = percent * math.abs(pos3D.z)      -- multiplying by z, because the to color should only be full if to abs(z) is 1

        local a, h, s, v = Color_LERP(from_a, from_h, from_s, from_v, to_a, to_h, to_s, to_v, percent)
        local r, g, b = HSV_RGB(h, s, v)
        local color = ToABGR(a, r, g, b)

        -- Thickness
        local thickness = from_thickness + ((to_thickness - from_thickness) * percent)

        -- Draw
        Draw_Line(screenOffset_x, screenOffset_y, center_x + (x1 * radius), center_y + (y1 * radius), center_x + (x2 * radius), center_y + (y2 * radius), color, thickness)

        x1 = x2
        y1 = y2
    end
end

-- Pulls rgb values from the style, then converts to hsv
function this.GetHSVFromColorKey(style_trackball, colorKey, suffix)
    local key = colorKey .. suffix

    local a = style_trackball[key .. "_a"]
    local r = style_trackball[key .. "_r"]
    local g = style_trackball[key .. "_g"]
    local b = style_trackball[key .. "_b"]

    local h, s, v = RGB_HSV(r, g, b)

    return a, h, s, v
end