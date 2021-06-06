local this = {}
local default_velaway = GetDefault_VelocityAway()

function DefineWindow_GrappleStraight_VelocityAway(vars_ui, const)
    local gst8_velaway = {}
    vars_ui.gst8_velaway = gst8_velaway

    gst8_velaway.changes = Changes:new()

    gst8_velaway.title = Define_Title("Grapple Straight - Extra Drag", const)

    gst8_velaway.name = Define_Name(const)

    gst8_velaway.stickFigure = Define_StickFigure(false, const)
    gst8_velaway.arrows = Define_GrappleArrows(true, false)
    gst8_velaway.desired_line = Define_GrappleDesiredLength(false)
    gst8_velaway.desired_extra = Define_GrappleAccelToDesired(true, true)

    -- Checkbox for whether to have vel away (Grapple.velocity_away)
    gst8_velaway.has_velaway = this.Define_HasVelocityAway(const)

    -- VelocityAway.accel_compression
    local check, value, updown, help = Define_PropertyPack_Vertical("Compression", -180, 100, const, true, "GrappleStraight_VelocityAway_Compression")
    gst8_velaway.has_compress = check
    gst8_velaway.compress_value = value
    gst8_velaway.compress_updown = updown
    gst8_velaway.compress_help = help

    -- VelocityAway.accel_tension
    check, value, updown, help = Define_PropertyPack_Vertical("Tension", 180, 100, const, true, "GrappleStraight_VelocityAway_Tension")
    gst8_velaway.has_tension = check
    gst8_velaway.tension_value = value
    gst8_velaway.tension_updown = updown
    gst8_velaway.tension_help = help

    -- VelocityAway.deadSpot
    gst8_velaway.deadspot_label = this.Define_DeadSpot_Label(const)
    gst8_velaway.deadspot_help = this.Define_DeadSpot_Help(const)
    gst8_velaway.deadspot_dist = this.Define_DeadSpot_Dist(const)

    --gst8_velaway.xpdebug = this.Define_XPDebug(const)
    gst8_velaway.experience = Define_Experience(const, "grapple")

    gst8_velaway.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

local isHovered_velaway_checkbox = false
local isHovered_compress_checkbox = false
local isHovered_tension_checkbox = false
local isHovered_deadspot_slider = false

function DrawWindow_GrappleStraight_VelocityAway(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_GrappleStraight_VelocityAway: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local velaway = grapple.velocity_away
    if not velaway then
        velaway = default_velaway
    end

    local startedWith_velaway = grapple.velocity_away ~= nil
    local startedWith_compress = velaway.accel_compression ~= nil
    local startedWith_tension = velaway.accel_tension ~= nil

    local gst8_velaway = vars_ui.gst8_velaway

    local changes = gst8_velaway.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_velaway.name, grapple.name)

    Refresh_GrappleArrows(gst8_velaway.arrows, grapple, true, not gst8_velaway.has_velaway.isChecked and isHovered_velaway_checkbox, false)
    Refresh_GrappleDesiredLength(gst8_velaway.desired_line, grapple, nil, changes, false)
    this.Refresh_GrappleAccelToDesired_Custom(gst8_velaway.desired_extra, grapple, velaway, gst8_velaway.deadspot_dist.value, isHovered_velaway_checkbox or isHovered_tension_checkbox, isHovered_velaway_checkbox or isHovered_compress_checkbox, isHovered_velaway_checkbox or isHovered_deadspot_slider)     -- this isn't visible when velaway checkbox is false, so there's no need to complicate the highlight logic

    this.Refresh_HasVelocityAway(gst8_velaway.has_velaway, player, grapple, velaway, changes)

    this.Refresh_HasCompression(gst8_velaway.has_compress, player, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)
    this.Refresh_Compress_Value(gst8_velaway.compress_value, velaway, changes)
    this.Refresh_Compress_UpDown(gst8_velaway.compress_updown, velaway, player, changes, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)

    this.Refresh_HasTension(gst8_velaway.has_tension, player, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)
    this.Refresh_Tension_Value(gst8_velaway.tension_value, velaway, changes)
    this.Refresh_Tension_UpDown(gst8_velaway.tension_updown, velaway, player, changes, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)

    this.Refresh_DeadSpot_Dist(gst8_velaway.deadspot_dist, velaway)

    --this.Refresh_XPDebug(gst8_velaway.xpdebug, player, grapple, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)
    this.Refresh_Experience(gst8_velaway.experience, player, grapple, changes, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)

    this.Refresh_IsDirty(gst8_velaway.okcancel, changes, grapple, gst8_velaway.deadspot_dist, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_velaway.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(gst8_velaway.name, vars_ui.style.colors, window.width, window.height, const)

    Draw_StickFigure(gst8_velaway.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(gst8_velaway.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(gst8_velaway.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    if gst8_velaway.has_velaway.isChecked then
        Draw_GrappleAccelToDesired(gst8_velaway.desired_extra, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    end

    local isChecked
    isChecked, isHovered_velaway_checkbox = Draw_CheckBox(gst8_velaway.has_velaway, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
    if isChecked then
        this.Update_HasVelocityAway(gst8_velaway.has_velaway, velaway, changes, startedWith_velaway)
    end

    if gst8_velaway.has_velaway.isChecked then
        -- Compression
        isChecked, isHovered_compress_checkbox = Draw_CheckBox(gst8_velaway.has_compress, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
        if isChecked then
            this.Update_HasCompression(gst8_velaway.has_compress, velaway, changes)
        end

        if gst8_velaway.has_compress.isChecked then
            Draw_Label(gst8_velaway.compress_value, vars_ui.style.colors, window.width, window.height, const)

            local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_velaway.compress_updown, vars_ui.style.updownButtons, window.width, window.height, const)
            this.Update_Compress(gst8_velaway.compress_updown, changes, isDownClicked, isUpClicked)

            Draw_HelpButton(gst8_velaway.compress_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)
        end

        -- Tension
        isChecked, isHovered_tension_checkbox = Draw_CheckBox(gst8_velaway.has_tension, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const)
        if isChecked then
            this.Update_HasTension(gst8_velaway.has_tension, velaway, changes)
        end

        if gst8_velaway.has_tension.isChecked then
            Draw_Label(gst8_velaway.tension_value, vars_ui.style.colors, window.width, window.height, const)

            local isDownClicked, isUpClicked = Draw_UpDownButtons(gst8_velaway.tension_updown, vars_ui.style.updownButtons, window.width, window.height, const)
            this.Update_Tension(gst8_velaway.tension_updown, changes, isDownClicked, isUpClicked)

            Draw_HelpButton(gst8_velaway.tension_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)
        end

        -- Dead Spot Distance
        Draw_Label(gst8_velaway.deadspot_label, vars_ui.style.colors, window.width, window.height, const)
        Draw_HelpButton(gst8_velaway.deadspot_help, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const)
        _, isHovered_deadspot_slider = Draw_Slider(gst8_velaway.deadspot_dist, vars_ui.style.slider, window.width, window.height, const, vars_ui.line_heights)
    else
        isHovered_deadspot_slider = false
    end

    --Draw_OrderedList(gst8_velaway.xpdebug, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)
    Draw_OrderedList(gst8_velaway.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_velaway.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, velaway, changes, gst8_velaway.deadspot_dist, startedWith_velaway, startedWith_compress, startedWith_tension, gst8_velaway.has_velaway.isChecked, gst8_velaway.has_compress.isChecked, gst8_velaway.has_tension.isChecked)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_velaway.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Refresh_GrappleAccelToDesired_Custom(def, grapple, velaway, changed_deadspot, shouldHighlight_accel_left, shouldHighlight_accel_right, shouldHighlight_dead)
    if grapple.desired_length then
        def.percent = grapple.desired_length / grapple.aim_straight.max_distance
    else
        def.percent = 1
    end

    local deadSpot = 0
    if changed_deadspot then
        deadSpot = changed_deadspot
    else
        deadSpot = velaway.deadSpot
    end

    def.show_accel_left = true
    def.show_accel_right = true
    def.show_dead = true

    def.isHighlight_accel_left = shouldHighlight_accel_left
    def.isHighlight_accel_right = shouldHighlight_accel_right
    def.isHighlight_dead = shouldHighlight_dead

    -- Scale drawn deadspot relative to the aim distance
    def.length_dead = GetScaledValue(0, def.to_x - def.from_x, 0, grapple.aim_straight.max_distance, deadSpot)
end

function this.Define_HasVelocityAway(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_VelocityAway_HasVelocityAway",

        text = "Has Extra Drag (applied when moving away from desired)",

        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_HasVelocityAway(def, player, grapple, velaway, changes)
    --NOTE: TransitionWindows_Straight_VelocityAway sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.velocity_away ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- it doesn't cost xp to remove, so the checkbox is always enabled here
    else
        def.isEnabled = player.experience + changes:Get("experience_buysell") >= velaway.experience
    end
end
function this.Update_HasVelocityAway(def, velaway, changes, startedWithVA)
    local total = velaway.experience        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, startedWithVA, changes, "experience_buysell", total)
end

function this.Refresh_HasCompression(def, player, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    --NOTE: TransitionWindows_Straight_VelocityAway sets this to nil
    if def.isChecked == nil then
        def.isChecked = velaway.accel_compression ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- they can always sell
    else
        -- Let's say they have some xp sunk into compression.  They uncheck the box, spend some of that on
        -- tension.  Now they may not have enough xp to add back compression
        local avail = player.experience + this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
        local cost = this.GetInitialCost(velaway.accel_compression, velaway.accel_compression_update) - changes:Get("experience_compression")

        def.isEnabled = avail >= cost
    end
end
function this.Update_HasCompression(def, velaway, changes)
    local total = this.GetInitialCost(velaway.accel_compression, velaway.accel_compression_update)        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, velaway.accel_compression, changes, "experience_buysell_compression", total)
end

function this.Refresh_Compress_Value(def, velaway, changes)
    --NOTE: This text will only show when the checkbox is checked
    local base = this.GetNullableMin(velaway.accel_compression, velaway.accel_compression_update.min)
    def.text = tostring(Round(base + changes:Get("accel_compression")))
end
function this.Refresh_Compress_UpDown(def, velaway, player, changes, has_velaway, has_compress, has_tension)
    local currentXP = this.GetCurrentExperience(player, changes, has_velaway, has_compress, has_tension)

    local base = this.GetNullableMin(velaway.accel_compression, velaway.accel_compression_update.min)
    local down, up = GetDecrementIncrement(velaway.accel_compression_update, base + changes:Get("accel_compression"), currentXP)
    Refresh_UpDownButton(def, down, up, 0)
end
function this.Update_Compress(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("accel_compression", def.value_down)
        changes:Add("experience_compression", 1)        -- experience needs to be independently tracked between compression and tension, because the checkbox tells whether to look at this or the buysell property
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("accel_compression", def.value_up)
        changes:Subtract("experience_compression", 1)
    end
end

function this.Refresh_HasTension(def, player, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    --NOTE: TransitionWindows_Straight_VelocityAway sets this to nil
    if def.isChecked == nil then
        def.isChecked = velaway.accel_tension ~= nil
    end

    if def.isChecked then
        def.isEnabled = true        -- they can always sell
    else
        -- Let's say they have some xp sunk into tension.  They uncheck the box, spend some of that on
        -- compression.  Now they may not have enough xp to add back tension
        local avail = player.experience + this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
        local cost = this.GetInitialCost(velaway.accel_tension, velaway.accel_tension_update) - changes:Get("experience_tension")

        def.isEnabled = avail >= cost
    end
end
function this.Update_HasTension(def, velaway, changes)
    local total = this.GetInitialCost(velaway.accel_tension, velaway.accel_tension_update)        -- this is the price when the window was started, changes are tracked separately

    PopulateBuySell(def.isChecked, velaway.accel_tension, changes, "experience_buysell_tension", total)
end

function this.Refresh_Tension_Value(def, velaway, changes)
    local base = this.GetNullableMin(velaway.accel_tension, velaway.accel_tension_update.min)
    def.text = tostring(Round(base + changes:Get("accel_tension")))
end
function this.Refresh_Tension_UpDown(def, velaway, player, changes, has_velaway, has_compress, has_tension)
    local currentXP = this.GetCurrentExperience(player, changes, has_velaway, has_compress, has_tension)

    local base = this.GetNullableMin(velaway.accel_tension, velaway.accel_tension_update.min)
    local down, up = GetDecrementIncrement(velaway.accel_tension_update, base + changes:Get("accel_tension"), currentXP)
    Refresh_UpDownButton(def, down, up, 0)
end
function this.Update_Tension(def, changes, isDownClicked, isUpClicked)
    if isDownClicked and def.isEnabled_down then
        changes:Subtract("accel_tension", def.value_down)
        changes:Add("experience_tension", 1)
    end

    if isUpClicked and def.isEnabled_up then
        changes:Add("accel_tension", def.value_up)
        changes:Subtract("experience_tension", 1)
    end
end

function this.Define_DeadSpot_Label(const)
    -- Label
    return
    {
        text = "Dead Spot",

        position =
        {
            pos_x = -117,
            pos_y = 210,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",
    }
end
function this.Define_DeadSpot_Help(const)
    -- HelpButton
    return
    {
        position =
        {
            pos_x = -70,
            pos_y = 210,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "GrappleStraight_VelocityAway_DeadSpot_Help"
    }
end
function this.Define_DeadSpot_Dist(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_VelocityAway_DeadSpot_Dist",

        min = 0,
        max = 6,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 240,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_DeadSpot_Dist(def, velaway)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: TransitionWindows_Straight_Distances sets this to nil
    if not def.value then
        def.value = velaway.deadSpot
    end
end

function this.Define_XPDebug(const)
    -- This gets complex with the outer checkbox, two inner checkboxes controlling independent updowns.  Needed
    -- chart it out

    -- OrderedList
    return
    {
        content =
        {
            ad_startedWith_velaway = { prompt = "startedWith_velaway" },
            ae_startedWith_compress = { prompt = "startedWith_compress" },
            af_startedWith_tension = { prompt = "startedWith_tension" },
            ag_has_velaway = { prompt = "has_velaway" },
            ah_has_compress = { prompt = "has_compress" },
            ai_has_tension = { prompt = "has_tension" },

            ba_player = { prompt = "player" },
            bb_grapple = { prompt = "grapple" },
            bc_velaway = { prompt = "velaway" },
            bd_initial_compress = { prompt = "initial_compress" },
            be_initial_tension = { prompt = "initial_tension" },

            cj_experience_buysell = { prompt = "experience_buysell" },
            cka_experience_buysell_compression = { prompt = "experience_buysell_compression" },
            ckb_experience_buysell_tension = { prompt = "experience_buysell_tension" },
            cla_experience_compression = { prompt = "experience_compression" },
            clb_experience_tension = { prompt = "experience_tension" },

            dm_avail = { prompt = "avail" },
            dn_cost_compress = { prompt = "cost_compress" },
            do_cost_tension = { prompt = "cost_tension" },
        },

        position =
        {
            pos_x = 12,
            pos_y = 84,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        gap = 12,

        color_prompt = "experience_prompt",
        color_value = "experience_value",
    }
end
function this.Refresh_XPDebug(def, player, grapple, velaway, changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    def.content.ad_startedWith_velaway.value = tostring(startedWith_velaway)
    def.content.ae_startedWith_compress.value = tostring(startedWith_compress)
    def.content.af_startedWith_tension.value = tostring(startedWith_tension)
    def.content.ag_has_velaway.value = tostring(has_velaway)
    def.content.ah_has_compress.value = tostring(has_compress)
    def.content.ai_has_tension.value = tostring(has_tension)

    def.content.ba_player.value = tostring(player.experience)
    def.content.bb_grapple.value = tostring(grapple.experience)
    def.content.bc_velaway.value = tostring(velaway.experience)

    def.content.bd_initial_compress.value = tostring(this.GetInitialCost(velaway.accel_compression, velaway.accel_compression_update))
    def.content.be_initial_tension.value = tostring(this.GetInitialCost(velaway.accel_tension, velaway.accel_tension_update))

    def.content.cj_experience_buysell.value = tostring(changes:Get("experience_buysell"))
    def.content.cka_experience_buysell_compression.value = tostring(changes:Get("experience_buysell_compression"))
    def.content.ckb_experience_buysell_tension.value = tostring(changes:Get("experience_buysell_tension"))
    def.content.cla_experience_compression.value = tostring(changes:Get("experience_compression"))
    def.content.clb_experience_tension.value = tostring(changes:Get("experience_tension"))

    def.content.dm_avail.value = tostring(player.experience + this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension))
    def.content.dn_cost_compress.value = tostring(this.GetInitialCost(velaway.accel_compression, velaway.accel_compression_update) - changes:Get("experience_compression"))
    def.content.do_cost_tension.value = tostring(this.GetInitialCost(velaway.accel_tension, velaway.accel_tension_update) - changes:Get("experience_tension"))
end

function this.Refresh_Experience(def, player, grapple, changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    local cost = this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)

    def.content.available.value = tostring(math.floor(player.experience + cost))
    def.content.used.value = tostring(Round(grapple.experience - cost))
end

function this.Refresh_IsDirty(def, changes, grapple, def_slider, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    local isDirty = false

    if has_velaway then
        if startedWith_velaway then
            isDirty =                           -- changing existing
                has_compress ~= startedWith_compress or
                has_tension ~= startedWith_tension or
                changes:IsDirty() or
                not IsNearValue(def_slider.value, grapple.velocity_away.deadSpot)
        else
            isDirty = true      -- creating a new one
        end
    else
        isDirty = startedWith_velaway       -- potentially removing one
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, velaway, changes, def_slider, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    if has_velaway then
        local deadspot = GetSliderValue(def_slider)

        if grapple.velocity_away then
            grapple.velocity_away.accel_compression = this.GetNewNullable(velaway, changes, has_compress, "accel_compression")
            grapple.velocity_away.accel_tension = this.GetNewNullable(velaway, changes, has_tension, "accel_tension")
            grapple.velocity_away.deadSpot = deadspot
            grapple.velocity_away.experience = velaway.experience - this.GetXPGainLoss_NonNull(changes, startedWith_compress, startedWith_tension, has_compress, has_tension)
        else
            grapple.velocity_away =
            {
                accel_compression = this.GetNewNullable(velaway, changes, has_compress, "accel_compression"),
                accel_compression_update = velaway.accel_compression_update,

                accel_tension = this.GetNewNullable(velaway, changes, has_tension, "accel_tension"),
                accel_tension_update = velaway.accel_tension_update,

                deadSpot = deadspot,

                experience = velaway.experience - this.GetXPGainLoss_NonNull(changes, startedWith_compress, startedWith_tension, has_compress, has_tension),
            }
        end
    else
        grapple.velocity_away = nil
    end

    local cost = this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)

    grapple.experience = grapple.experience - cost
    player.experience = player.experience + cost

    player:Save()
end

function this.GetNewNullable(velaway, changes, has, key)
    if has then
        local existing = velaway[key]
        if not existing then
            existing = velaway[key .. "_update"].min
        end

        return existing + changes:Get(key)
    else
        return nil
    end
end

function this.GetXPGainLoss(changes, startedWith_velaway, startedWith_compress, startedWith_tension, has_velaway, has_compress, has_tension)
    if has_velaway then
        if startedWith_velaway then
            return this.GetXPGainLoss_NonNull(changes, startedWith_compress, startedWith_tension, has_compress, has_tension)
        else
            return changes:Get("experience_buysell") + this.GetXPGainLoss_NonNull(changes, startedWith_compress, startedWith_tension, has_compress, has_tension)
        end
    else
        if startedWith_velaway then
            return changes:Get("experience_buysell")       -- not including any upgrades/buybacks on individual props, because they are selling what they started with
        else
            return 0
        end
    end
end
function this.GetXPGainLoss_NonNull(changes, startedWith_compress, startedWith_tension, has_compress, has_tension)
    return
        this.GetXPGainLoss_Component(changes, has_compress, startedWith_compress, "experience_buysell_compression", "experience_compression") +
        this.GetXPGainLoss_Component(changes, has_tension, startedWith_tension, "experience_buysell_tension", "experience_tension")
end
function this.GetXPGainLoss_Component(changes, has, startedWith, key_buysell, key_upgradedowngrade)
    if has then
        if startedWith then
            return changes:Get(key_upgradedowngrade)
        else
            return changes:Get(key_buysell) + changes:Get(key_upgradedowngrade)
        end
    else
        if startedWith then
            return changes:Get(key_buysell)
        else
            return 0
        end
    end
end

function this.GetCurrentExperience(player, changes, has_velaway, has_compress, has_tension)
    local retVal = player.experience + changes:Get("experience_buysell")

    if has_velaway then
        retVal = retVal + changes:Get("experience_buysell_compression")
        retVal = retVal + changes:Get("experience_buysell_tension")

        if has_compress then
            retVal = retVal + changes:Get("experience_compression")
        end

        if has_tension then
            retVal = retVal + changes:Get("experience_tension")
        end
    end

    return retVal
end

function this.GetInitialCost(value, update)
    if not value then
        return 0
    end

    return CalculateExperienceCost_Value(value, update)
end

function this.GetNullableMin(value, min)
    if value then
        return value
    else
        return min
    end
end