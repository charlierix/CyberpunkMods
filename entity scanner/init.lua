--[[
    Entity Scanner - CET (Lua)
    A basic real-time entity scanner that shows info about whatever
    the player is currently looking at.

    Features:
      - Hotkey to enable/disable the overlay window
      - ImGui window shows even when CET console is not open
      - Displays name/type of the entity under the crosshair

    Install:
      Copy this folder to:
        bin/x64/plugins/cyber_engine_tweaks/mods/entity scanner/

    Bind hotkey in:
      Settings > Key Bindings > EntityScanner
]]

local ModName = "EntityScanner"

-- State
local enabled = false

-- Pre-built targeting query (constructed in onInit)
local searchQuery = nil

-- Current scan data (updated each frame in onUpdate, displayed in onDraw)
local Scan = {
    entity    = nil,
    typeName  = nil,
    className = nil,
    tweakID   = nil,
    templPath = nil,
    appearNm  = nil,
    distance  = nil,
    entityID  = nil,
}

--- Determine a human-readable type string for an entity
local function GetEntityType(ent)
    if not ent then return nil end

    if ent:IsNPC()     then return "NPC" end
    if ent:IsVehicle() then return "Vehicle" end
    if ent:IsDevice()  then return "Device" end
    if ent:IsItem()    then return "Item" end
    if ent:IsContainer() then return "Container" end

    -- Fallback: try to get the class name from the entity
    local class = nil
    pcall(function() class = ent:GetClassName() end)
    if class then return tostring(class) end

    return "Entity"
end

--- Get the entity the player is currently looking at
local function GetCrosshairEntity()
    local ts = Game.GetTargetingSystem()
    if not ts then return nil end

    local player = Game.GetPlayer()
    if not player then return nil end

    if not searchQuery then return nil end

    local comp = ts:GetComponentClosestToCrosshair(player, searchQuery)
    if not comp then return nil end

    return comp:GetEntity()
end

--- Update the Scan table with info about the looked-at entity
local function UpdateScan()
    -- Reset scan data
    Scan.entity    = nil
    Scan.typeName  = nil
    Scan.className = nil
    Scan.tweakID   = nil
    Scan.templPath = nil
    Scan.appearNm  = nil
    Scan.distance  = nil
    Scan.entityID  = nil

    local ent = GetCrosshairEntity()
    if not ent or not IsDefined(ent) then
        return
    end

    Scan.entity = ent

    -- Type classification
    Scan.typeName = GetEntityType(ent)

    -- Get record for detailed info
    local record = nil
    pcall(function() record = ent:GetRecord() end)

    if record and IsDefined(record) then
        -- Class name (record ToString)
        pcall(function() Scan.className = record:ToString() end)

        -- TweakDBID
        local recID = nil
        pcall(function() recID = record:GetRecordID() end)
        if recID then
            pcall(function() Scan.tweakID = recID.value end)
            if not Scan.tweakID then
                pcall(function() Scan.tweakID = tostring(recID) end)
            end
        end

        -- Entity template path
        local tmpl = nil
        pcall(function() tmpl = record:EntityTemplatePath() end)
        if tmpl then
            pcall(function() Scan.templPath = tmpl:ToString() end)
        end
    end

    -- Appearance name
    local app = nil
    pcall(function() app = ent:GetCurrentAppearanceName() end)
    if app then
        pcall(function() Scan.appearNm = app.value end)
        if not Scan.appearNm then
            pcall(function() Scan.appearNm = tostring(app) end)
        end
    end

    -- Entity ID
    local eid = nil
    pcall(function() eid = ent:GetEntityID() end)
    if eid then
        pcall(function() Scan.entityID = tostring(eid) end)
    end

    -- Distance from player
    local player = Game.GetPlayer()
    if player then
        local playerPos = nil
        local entPos = nil
        pcall(function() playerPos = player:GetWorldPosition() end)
        pcall(function() entPos = ent:GetWorldPosition() end)
        if playerPos and entPos then
            local dx = playerPos.x - entPos.x
            local dy = playerPos.y - entPos.y
            local dz = playerPos.z - entPos.z
            Scan.distance = math.sqrt(dx*dx + dy*dy + dz*dz)
        end
    end
end

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    -- Construct the targeting query (empty query = match everything, like TSQ_ALL() in Swift)
    searchQuery = NewObject("gameTargetSearchQuery")
    print(string.format("[%s] Initialized. Bind the toggle key in Settings > Key Bindings.", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if not enabled then return end
    if not Game.GetPlayer() then return end
    UpdateScan()
end)

registerForEvent("onDraw", function()
    if not enabled then return end
    if not Game.GetPlayer() then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(420, 260, ImGuiCond.FirstUseEver)

    if ImGui.Begin("Entity Scanner", true, ImGuiWindowFlags.AlwaysAutoResize) then
        if Scan.entity then
            ImGui.Text("Type:        " .. tostring(Scan.typeName or "Unknown"))
            if Scan.className then
                ImGui.Text("Class:       " .. tostring(Scan.className))
            end
            if Scan.tweakID then
                ImGui.Text("TweakDBID:   " .. tostring(Scan.tweakID))
            end
            if Scan.templPath then
                ImGui.Text("Template:    " .. tostring(Scan.templPath))
            end
            if Scan.appearNm then
                ImGui.Text("Appearance:  " .. tostring(Scan.appearNm))
            end
            if Scan.distance then
                ImGui.Text(string.format("Distance:    %.2f m", Scan.distance))
            end
            if Scan.entityID then
                ImGui.Separator()
                ImGui.TextWrapped("EntityID:    " .. Scan.entityID)
            end
        else
            ImGui.Text("Looking at nothing...")
            ImGui.Text("Look at an entity to see its info.")
        end

        ImGui.Separator()
        ImGui.TextDisabled("Press the Entity Scanner hotkey to toggle this window.")
    end
    ImGui.End()
end)

--============================================================================
-- HOTKEYS (MUST be at file root level - CET scans for these before onInit)
--============================================================================

registerHotkey("EntityScannerToggle", "Toggle Entity Scanner", function()
    enabled = not enabled
    print(string.format("[%s] %s", ModName, enabled and "Enabled" or "Disabled"))
end)
