local ui = require "ui_ingame/grapple_render_ui"

local GrappleRender = {}

local this = {}

local controller = nil

local visuals_circle = StickyList:new()
local visuals_line = StickyList:new()
local visuals_triangle = StickyList:new()
local visuals_text = StickyList:new()

--------------------------------- Called From Events ----------------------------------

function GrappleRender.CallFrom_onInit()
    --NOTE: There may be a better controller to use.  Chose this because it seems to run every time
    --If you reload all mods from cet console, you will need to load a save for this event to fire again
	Observe("CrosshairGameController_NoWeapon", "OnInitialize", function(obj)
        controller = obj        -- this is an instance of CrosshairGameController_NoWeapon which extends worlduiIWidgetGameController, which has ProjectWorldToScreen()
	end)
end

-- It's up to the caller to only call update/draw in valid conditions (not in menus or workspots, not shutdown)

function GrappleRender.CallFrom_onUpdate(deltaTime)
    -- timer = timer + deltaTime

    -- -- Remove items that have exceeded lifespan_seconds
    -- this.RemoveExpiredItems()
    -- this.PossiblyStopSound(false)

    -- -- Go through items and populate visuals (only items that are in front of the camera).  Turns high level concepts
    -- -- like circle/square into line paths that match this frame's perspective
    -- frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

function GrappleRender.CallFrom_onDraw()
    if visuals_circle:GetCount() == 0 and visuals_line:GetCount() == 0 and visuals_triangle:GetCount() == 0 and visuals_text:GetCount() == 0 then
        do return end
    end

    ui.DrawCanvas(visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

----------------------------------- Public Methods ------------------------------------

function GrappleRender.StraightLine(from, to)





end

----------------------------------- Private Methods -----------------------------------

return GrappleRender