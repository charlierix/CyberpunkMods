-- This class is used to log visuals and text, save to a file, then view from a c# app

-- It would be better to draw directly in game, but this is the next best thing.  Drawing
-- in game should be possible with imgui.  Would need to calculate the 2D screen coords
-- by knowing the camera's position, orientation, fov.  Maybe someday :)

-- All colors are hex format.  ARGB, alpha is optional
--  "444" becomes "FF444444" (very dark gray)
--  "806A" becomes "880066AA" (dusty blue)
--  "FF8040" becomes "FFFF8040" (sort of a coral)
--  "80FFFFFF" (50% transparent white)

local FOLDER = "!logs"

local this = {}

DebugRenderLogger = {}

-- If enable_logging is false, then calling the rest of the functions do nothing.  This allows
-- logging code to be left in with almost zero performance issues
function DebugRenderLogger:new(enable_logging)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.enable_logging = enable_logging

    obj.categories = {}
    obj.frames = {}
    obj.global_text = {}

    obj:NewFrame()

    return obj
end

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
function DebugRenderLogger:DefineCategory(name, color, size_mult)
    local category =
    {
        name = name,
        color = color,
        size_mult = size_mult
    }

    table.insert(self.categories, category)
end

-- This is optional.  When used, all add actions get tied to the current frame.  This allows views to
-- be logged over time, then the viewer will have a scrollbar to flip between frames
--
-- There is no need to call this after instantiation, a first frame is implied (but there's no harm in
-- explicitly calling it for the first frame)
function DebugRenderLogger:NewFrame(name, back_color)
    if not self.enable_logging then
        do return end
    end

    local frame =
    {
        name = name,
        back_color = back_color,
        items = {},
        text = {},
    }

    table.insert(self.frames, frame)
end

-- Category and after are all optional.  If a category is passed in, then the item will use that
-- category's size and color, unless overridden in the add method call
function DebugRenderLogger:Add_Dot(position, category, color, size_mult, tooltip)
    if not self.enable_logging then
        do return end
    end

    local item = this.GetItemBase(category, color, size_mult, tooltip)

    item.position = this.ConvertVector(position)

    table.insert(self.frames[#self.frames].items, item)
end
function DebugRenderLogger:Add_Line(point1, point2, category, color, size_mult, tooltip)
    if not self.enable_logging then
        do return end
    end

    local item = this.GetItemBase(category, color, size_mult, tooltip)

    item.point1 = this.ConvertVector(point1)
    item.point2 = this.ConvertVector(point2)

    table.insert(self.frames[#self.frames].items, item)
end
function DebugRenderLogger:Add_Circle(center, normal, radius, category, color, size_mult, tooltip)
    if not self.enable_logging then
        do return end
    end

    local item = this.GetItemBase(category, color, size_mult, tooltip)

    item.center = this.ConvertVector(center)
    item.normal = this.ConvertVector(normal)
    item.radius = radius

    table.insert(self.frames[#self.frames].items, item)
end
function DebugRenderLogger:Add_Square(center, normal, size_x, size_y, category, color, size_mult, tooltip)
    if not self.enable_logging then
        do return end
    end

    local item = this.GetItemBase(category, color, size_mult, tooltip)

    item.center = this.ConvertVector(center)
    item.normal = this.ConvertVector(normal)
    item.size_x = size_x
    item.size_y = size_y

    table.insert(self.frames[#self.frames].items, item)
end

-- This is any extra text attached to the frame, useful for including log dumps next to the picture
function DebugRenderLogger:WriteLine_Frame(text, color, fontsize_mult)
    if not self.enable_logging then
        do return end
    end

    local text_entry = this.GetTextEntry(text, color, fontsize_mult)

    table.insert(self.frames[#self.frames].text, text_entry)
end
-- This is text that is shown regardless of frames
function DebugRenderLogger:WriteLine_Global(text, color, fontsize_mult)
    if not self.enable_logging then
        do return end
    end

    local text_entry = this.GetTextEntry(text, color, fontsize_mult)

    table.insert(self.global_text, text_entry)
end

-- This returns true if there is something to save (this ignores categories, since that is considered
-- prep, and not real logged items)
function DebugRenderLogger:IsPopulated()
    if not self.enable_logging then
        return false
    end

    if #self.global_text > 0 then
        return true
    end

    for i = 1, #self.frames do
        if #self.frames[i].items > 0 then
            return true
        end

        if #self.frames[i].text > 0 then
            return true
        end
    end

    return false
end

-- Saves everything into a file, clears all frames, so more can be added.  Keeps categories
function DebugRenderLogger:Save(name)
    if not self.enable_logging then
        do return end
    end

    this.PossiblyRemoveFirstFrame(self.frames)

    local scene =
    {
        categories = self.categories,
        frames = self.frames,
        text = self.global_text,
    }

    local filename = this.GetFilename(name)

    --os.execute("mkdir " .. FOLDER)        -- cet blocks os.execute, so it's up to the user to create the folder

    local handle = io.open(filename, "w+")

    handle:write(extern_json.encode(scene))

    handle:close()

    self.frames = {}
    self.global_text = {}
end

----------------------------------- Private Methods -----------------------------------

function this.GetTextEntry(text, color, fontsize_mult)
    return
    {
        text = text,
        color = color,
        fontsize_mult = fontsize_mult,
    }
end

function this.GetItemBase(category, color, size_mult, tooltip)
    return
    {
        category = category,
        color = color,
        size_mult = size_mult,
        tooltip = tooltip,
    }
end

-- JSON encode doesn't like vectors, so convert to strings
-- json.lua:165: unexpected type 'userdata'
function this.ConvertVector(vector)
    return tostring(vector.x) .. ", " .. tostring(vector.y) .. ", " .. tostring(vector.z)
end

-- The constructor calls NewFrame with no params.  But the user might immediately call NewFrame with params.  That
-- would leave an empty first frame.  This function detects and removes that first frame
function this.PossiblyRemoveFirstFrame(frames)
    if #frames < 2 then
        do return end
    end

    if not frames[1].name and not frames[1].back_color and #frames[1].items == 0 and #frames[1].text == 0 then
        table.remove(frames, 1)
    end
end

function this.GetFilename(name)
    local retVal = FOLDER .. "/" .. os.date('%Y-%m-%d %H-%M-%S')

    if name then
        retVal = retVal .. " - " .. name
    end

    retVal = retVal .. ".json"

    return retVal
end