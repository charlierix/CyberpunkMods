local this = {}

local JUMPSTRENGTH_MIN = 4
local JUMPSTRENGTH_MAX = 36

function DefineWindow_Jumping(vars_ui, const)
    local jumping = {}
    vars_ui.jumping = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)


    -- this.StoreModelValue(self, model, "jump_strength", 11)

    -- this.StoreModelValue(self, model, "jump_speed_fullStrength", 3)     -- any vertical speed lower than this will get full jump strength
    -- this.StoreModelValue(self, model, "jump_speed_zeroStrength", 7)     -- this is the vertical speed where no more impulse will be applied.  Gradient to full at jump_speed_fullStrength



    jumping.strength = this.Define_Strength(const)
    jumping.strength_label = this.Define_Strength_Label(jumping.strength, const)




    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping(vars_ui, const)
    if not vars_ui.jumping then
        DefineWindow_Jumping(vars_ui, const)
    end

    vars_ui.jumping.changes:Clear()

    vars_ui.jumping.strength.value = nil
end

function DrawWindow_Jumping(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Strength(jumping.strength, player_arcade)

    this.Refresh_IsDirty(jumping.okcancel, player_arcade, jumping.strength)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(jumping.title, vars_ui.style.colors)


    Draw_Label(jumping.strength_label, vars_ui.style.colors)
    Draw_Slider(jumping.strength, vars_ui.style.slider)


    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        this.Save(jumping.strength, player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not jumping.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Strength_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump Strength",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Strength(const)
    -- Slider
    return
    {
        invisible_name = "Main_Strength_Value",

        min = 0,
        max = 144,

        decimal_places = 0,

        width = 200,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Strength(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = GetScaledValue(def.min, def.max, JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, player_arcade.jump_strength)
    end
end

function this.Refresh_IsDirty(def, player_arcade, jump_strength)
    local isDirty = false

    if not IsNearValue(GetScaledValue(jump_strength.min, jump_strength.max, JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, player_arcade.jump_strength), jump_strength.value) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(jump_strength, player, player_arcade)
    player_arcade.jump_strength = GetScaledValue(JUMPSTRENGTH_MIN, JUMPSTRENGTH_MAX, jump_strength.min, jump_strength.max, jump_strength.value)

    player_arcade:Save()
    player:Reset()
end