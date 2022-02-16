-- This class is used to show 3D debug info on the screen

local this = {}

DebugRenderScreen = {}

-- If enable_logging is false, then calling the rest of the functions do nothing.  This allows
-- logging code to be left in with almost zero performance issues
function DebugRenderScreen:new(enable_rendering)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.enable_rendering = enable_rendering

    obj.categories = {}

    -- This holds all 3D objects (same as logger's frames[#frames].items)
    obj.items = {}

    obj:NewFrame()

    return obj
end

-- This can make it easier to group similar items into the same category.  All items will be shown with
-- the color and size specified here
function DebugRenderScreen:DefineCategory(name, color, size_mult)
    local category =
    {
        name = name,
        color = color,
        size_mult = size_mult
    }

    table.insert(self.categories, category)
end

-- This resets the frame
function DebugRenderScreen:NewFrame()
    if not self.enable_rendering then
        do return end
    end

    --TODO: See if there's a more efficient way to clear the list
    self.items = {}
end

-- Category and after are all optional.  If a category is passed in, then the item will use that
-- category's size and color, unless overridden in the add method call
function DebugRenderScreen:Add_Dot(position, category, color, size_mult)
    if not self.enable_rendering then
        do return end
    end

    local item = this.GetItemBase(position, category, color, size_mult)

    item.position = this.ConvertVector(position)

    table.insert(self.items, item)
end

function DebugRenderScreen:Draw()
    if not self.enable_rendering then
        do return end
    end

    if #self.items == 0 then
        do return end
    end






end

----------------------------------- Private Methods -----------------------------------

function this.GetItemBase(position, category, color, size_mult)
    return
    {
        position = position,
        category = category,
        color = color,
        size_mult = size_mult,
    }
end

-- public func ScreenXY(position: Vector4, offsetX: Float, offsetY: Float) -> Vector2 {
-- if IsDefined(this.controller) {
    -- let translation = this.controller.ProjectWorldToScreen(position);
    -- translation.X = translation.X * 1920.0 + offsetX;
    -- translation.Y = translation.Y * -1080.0 + offsetY;
    -- return translation;
-- } else {
    -- return new Vector2(0.0, 0.0);
-- }
-- }

function this.ScreenXY(position)
    --public let controller: ref<inkGameController>;
    




end






