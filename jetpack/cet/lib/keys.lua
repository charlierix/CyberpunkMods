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

    obj.jump = false
    obj.rmb = false

    obj.prev_jump = false
    obj.prev_rmb = false

    return obj
end

local suppress_mousex_zero_ALL =
{
    "right_stick_y",
    "UI_MoveX_Axis",
    "UI_MoveY_Axis",
    "UI_LookX_Axis",
    "UI_LookY_Axis",
    "UI_FakeMovement",
    "UI_FakeCamera",
    "UI_Drop",
    "UI_Skip",
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
    "mouse_x",
    "mouse_y",
    "CameraMouseY",
    "option_switch_next_settings",
    "option_switch_prev_settings",
    "option_switch_next",
    "option_switch_prev",
    "Forward",
    "Back",
    "Left",
    "Right",
    "Jump",
}

local suppress_mousex_zero =
{
    "left_stick_x",
    "left_stick_y",
    "right_stick_y",
    "right_stick_y_scroll",
    "MoveX",        -- keyboard+mouse isn't affected by this, but controller is
    "MoveY",
    "UI_MoveX_Axis",
    "UI_MoveY_Axis",
    "UI_LookX_Axis",
    "UI_LookY_Axis",
    "UI_FakeMovement",
    "UI_FakeCamera",
    "UI_Drop",
    "UI_Skip",
    "Choice_MoveX_Axis",
    "Choice_MoveY_Axis",
    "QuestLeft",
    "world_map_menu_move_horizontal",
    "world_map_menu_move_vertical",
    "world_map_menu_move_horizontal_alt",
    "world_map_menu_move_vertical_alt",
    "world_map_menu_rotate_pitch",
    "world_map_menu_rotate_yaw",
    "popup_axisX",
    "popup_axisY",
    "popup_axisX_right",
}

function Keys:MapAction(action)
    local actionName = Game.NameToString(action:GetName())
    local actionType = action:GetType(action).value
    local pressed = actionType == "BUTTON_PRESSED"
    local released = actionType == "BUTTON_RELEASED"

    --self.debug.keys_actionName = actionName

    -- This seems to be firing for keyboard inputs as well
    if actionName == "MoveX" then
        --self.debug.movex_at = actionType      -- "AXIS_CHANGE"
        self.analog_x = action:GetValue(action)
    elseif actionName == "MoveY" then
        self.analog_y = action:GetValue(action)
    elseif actionType == "AXIS_CHANGE" then
        self.debug.move0 = actionName
        self.analog_x = 0
        self.analog_y = 0
    end

    if actionName == "CameraMouseX" then
        --print("CameraMouseX: " .. actionType)       -- "RELATIVE_CHANGE"
        self.mouse_x = action:GetValue(action)

    elseif actionName == "right_stick_x" then
        --print("right_stick_x: " .. actionType)        -- "AXIS_CHANGE"
        self.mouse_x = action:GetValue(action) * self.const.rightstick_sensitivity


    -- I'm not sure why I was setting this to zero.  There are a lot extra actions going on, leaving this commented
    -- has no noticable effect

    -- elseif actionType ~= "AXIS_CHANGE" or Contains(suppress_mousex_zero, actionName) then
    --     -- these are extra actions that fire when they use the right thumbstick.  They just need to be ignored
    -- else
    --     self.mouse_x = 0
    --     self.debug.keys_thezero = actionName .. " | " .. actionType



    end

    if actionName == "Forward" then
        if pressed then
            --self.forward = true
            self.analog_y = 1
        elseif released then
            --self.forward = false
            self.analog_y = 0
        end

    elseif actionName == "Back" then
        if pressed then
            --self.backward = true
            self.analog_y = -1
        elseif released then
            --self.backward = false
            self.analog_y = 0
        end

    elseif actionName == "Left" then
        if pressed then
            --self.left = true
            self.analog_x = -1
        elseif released then
            --self.left = false
            self.analog_x = 0
        end

    elseif actionName == "Right" then
        if pressed then
            --self.right = true
            self.analog_x = 1
        elseif released then
            --self.right = false
            self.analog_x = 0
        end

    elseif actionName == "Jump" then
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