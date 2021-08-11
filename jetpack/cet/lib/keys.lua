Keys = { }

function Keys:new(debug, const)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.debug = debug
    obj.const = const

    obj.cycleModes = false      --NOTE: This is a hotkey, and is set to true in init.lua

    obj.mouse_x = 0

    obj.analog_x = 0        -- this is a controller's analog stick
    obj.analog_y = 0

    -- obj.forward = false
    -- obj.backward = false
    -- obj.left = false
    -- obj.right = false
    obj.jump = false
    obj.rmb = false

    -- obj.prev_forward = false
    -- obj.prev_backward = false
    -- obj.prev_left = false
    -- obj.prev_right = false
    obj.prev_jump = false
    obj.prev_rmb = false

    return obj
end

local suppress_mousex_zero =
{
    "right_stick_y",
    "UI_MoveX_Axis",
    "UI_MoveY_Axis",
    "UI_LookX_Axis",
    "UI_LookY_Axis",
    "Choice_MoveX_Axis",
    "Choice_MoveY_Axis",
    "world_map_menu_move_horizontal",
    "world_map_menu_move_vertical",
    "world_map_menu_move_horizontal_alt",
    "world_map_menu_move_vertical_alt",
    "world_map_menu_rotate_pitch",
    "world_map_menu_rotate_yaw",
    "popup_axisX_right",
    "right_stick_y_scroll",
    "MoveX",        -- keyboard+mouse isn't affected by this, but controller is
    "MoveY",
    "QuestLeft",
    "popup_axisX",
    "popup_axisY",
}

function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --self.debug.keys_actionName = actionName

    -- This seems to be firing for keyboard inputs as well
    if actionName == "MoveX" then
        self.analog_x = action:GetValue(action)
    elseif actionName == "MoveY" then
        self.analog_y = action:GetValue(action)
    else
        self.analog_x = 0
        self.analog_y = 0
    end

    if actionName == "CameraMouseX" then
        self.mouse_x = action:GetValue(action)

    elseif actionName == "right_stick_x" then
        self.mouse_x = action:GetValue(action) * self.const.rightstick_sensitivity

    elseif Contains(suppress_mousex_zero, actionName) then
        -- these are extra actions that fire when they use the right thumbstick.  They just need to be ignored

    else
        self.mouse_x = 0
        --self.debug.keys_thezero = actionName
    end

    -- if actionName == "Forward" then
    --     if pressed then
    --         self.forward = true
    --     elseif released then
    --         self.forward = false
    --     end

    -- elseif actionName == "Back" then
    --     if pressed then
    --         self.backward = true
    --     elseif released then
    --         self.backward = false
    --     end

    -- elseif actionName == "Left" then
    --     if pressed then
    --         self.left = true
    --     elseif released then
    --         self.left = false
    --     end

    -- elseif actionName == "Right" then
    --     if pressed then
    --         self.right = true
    --     elseif released then
    --         self.right = false
    --     end

    if actionName == "Jump" then
        if pressed then
            self.jump = true
        elseif released then
            self.jump = false
        end

    --elseif (actionName == "CameraAim") or (actionName == "RangedADS") or (actionName == "MeleeBlock") then
    elseif actionName == "CameraAim" then
        if pressed then
            self.rmb = true
        elseif released then
            self.rmb = false
        end
    end
end

function Keys:Tick()
    self.cycleModes = false     -- this is a hotkey, so needs to be manually turned off after one tick

    -- self.prev_forward = self.forward
    -- self.prev_backward = self.backward
    -- self.prev_left = self.left
    -- self.prev_right = self.right
    self.prev_jump = self.jump
    self.prev_rmb = self.rmb
end
