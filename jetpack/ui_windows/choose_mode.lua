local this = {}

local datautil = require "data/datautil"

local items = nil

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_ChooseMode(vars_ui, const)
    local choose_mode = {}
    vars_ui.choose_mode = choose_mode

    choose_mode.title = Define_Title("Choose Mode", const)


    choose_mode.available = this.Define_Available(const)



    choose_mode.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(choose_mode)
end

function ActivateWindow_ChooseMode(vars_ui, const)
    if not vars_ui.mode_energy then
        DefineWindow_ChooseMode(vars_ui, const)
    end

    local choose_mode = vars_ui.choose_mode

    items = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_ChooseMode(isCloseRequested, vars, vars_ui, player, window, o, const)
    local choose_mode = vars_ui.choose_mode

    ------------------------- Finalize models for this frame -------------------------

    if not items then
        items = true

        this.GetModes(vars.sounds_thrusting, const)
    end






    --this.Refresh_IsDirty(choose_mode.okcancel, choose_mode.available.selected_index)
    this.Refresh_IsDirty(choose_mode.okcancel, nil)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(choose_mode.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(choose_mode.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------


    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(choose_mode.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save()
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not choose_mode.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Available(const)
    -- ListBox
    return
    {
        invisible_name = "ChooseMode_Available",

        -- These are populated for real in activate
        items = {},
        selected_index = 0,

        width = 340,
        height = 480,

        position =
        {
            pos_x = 36,
            pos_y = 48,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_ListBox,
    }
end


function this.Refresh_IsDirty(def, selected_index)
    local isDirty = false


    def.isDirty = isDirty
end

function this.Save()

end

---------------------------------------------------------------------------------------

function this.GetModes(sounds_thrusting, const)
    local modes, errMsg = datautil.GetModeList(sounds_thrusting, const)






end