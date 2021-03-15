function MapAction(action, keys, keys2)
    local actionName = Game.NameToString(action:GetName(action))

    --if actionName == "mouse_x" or actionName == "CameraMouseX" then
    if actionName == "CameraMouseX" then
        keys.mouse_x = tonumber(action:GetValue(action))
    else
        keys.mouse_x = 0
    end
end