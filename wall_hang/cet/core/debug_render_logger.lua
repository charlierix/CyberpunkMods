-- This class is used to log visuals and text, save to a file, then view from a c# app

-- It would be better to draw directly in game, but this is the next best thing.  Drawing
-- in game should be possible with imgui.  Would need to calculate the 2D screen coords
-- by knowing the camera's position, orientation, fov.  Maybe someday :)

-- All colors are hex format.  ARGB, alpha is optional
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)

local this = {}

DebugRenderLogger = {}

function DebugRenderLogger:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.frames = {}
    obj.categories = {}

    obj:NewFrame()

    return obj
end

-- Category and after are all optional.  If a category is passed in, then the item will use that
-- category's size and color, unless overridden in the add method call
function DebugRenderLogger:Add_Dot(position, category, color, size_mult, tooltip)
end
function DebugRenderLogger:Add_Line(point1, point2, category, color, size_mult, tooltip)
end
function DebugRenderLogger:Add_Circle(center, normal, radius, category, color, size_mult, tooltip)
end
function DebugRenderLogger:Add_Square(center, normal, size_x, size_y, category, color, size_mult, tooltip)
end

-- This is any extra text attached to the frame, useful for including log dumps next to the picture
function DebugRenderLogger:WriteLine_Frame(text, color, fontsize_mult)
end
-- This is text that is shown regardless of frames
function DebugRenderLogger:WriteLine_Global(text, color, fontsize_mult)
end

-- This is optional.  When used, all add actions get tied to the current frame.  This allows views to
-- be logged over time, then the viewer will have a scrollbar to flip between frames
--
-- There is no need to call this after instantiation, a first frame is implied (but there's no harm in
-- explicitly calling it for the first frame)
function DebugRenderLogger:NewFrame(name, back_color)
end

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
function DebugRenderLogger:DefineCategory(name, color, size_mult)
end

-- Saves everything into a file, clears all frames, so more can be added.  Keeps categories
function DebugRenderLogger:Save(name)
end

----------------------------------- Private Methods -----------------------------------

function DebugRenderLogger:ClearFrames()
end