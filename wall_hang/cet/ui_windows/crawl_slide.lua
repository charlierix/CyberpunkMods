local this = {}

function DefineWindow_CrawlSlide(vars_ui, const)
    local crawl_slide = {}
    vars_ui.crawl_slide = crawl_slide

    crawl_slide.changes = Changes:new()

    crawl_slide.title = Define_Title("Crawl/Slide", const)

    crawl_slide.slide_label = this.Define_Slide_Label(const)
    crawl_slide.slide_help = this.Define_Slide_Help(crawl_slide.slide_label, const)

    -- player_arcade.wallSlide_minSpeed
    crawl_slide.slide_speed = this.Define_SlideSpeed(crawl_slide.slide_label, const)
    crawl_slide.slide_speed_label = this.Define_SlideSpeed_Label(crawl_slide.slide_speed, const)
    crawl_slide.slide_speed_help = this.Define_SlideSpeed_Help(crawl_slide.slide_speed_label, const)

    -- player_arcade.wallSlide_dragAccel
    crawl_slide.slide_drag = this.Define_SlideDrag(crawl_slide.slide_speed, const)
    crawl_slide.slide_drag_label = this.Define_SlideDrag_Label(crawl_slide.slide_drag, const)
    crawl_slide.slide_drag_help = this.Define_SlideDrag_Help(crawl_slide.slide_drag_label, const)

    crawl_slide.crawl_label = this.Define_Crawl_Label(crawl_slide.slide_drag, const)
    crawl_slide.crawl_help = this.Define_Crawl_Help(crawl_slide.crawl_label, const)

    -- player_arcade.wallcrawl_speed_horz
    crawl_slide.crawl_horz = this.Define_CrawlHorz(crawl_slide.crawl_label, const)
    crawl_slide.crawl_horz_label = this.Define_CrawlHorz_Label(crawl_slide.crawl_horz, const)
    crawl_slide.crawl_horz_help = this.Define_CrawlHorz_Help(crawl_slide.crawl_horz_label, const)

    -- player_arcade.wallcrawl_speed_up
    crawl_slide.crawl_up = this.Define_CrawlUp(crawl_slide.crawl_horz, const)
    crawl_slide.crawl_up_label = this.Define_CrawlUp_Label(crawl_slide.crawl_up, const)
    crawl_slide.crawl_up_help = this.Define_CrawlUp_Help(crawl_slide.crawl_up_label, const)

    -- player_arcade.wallcrawl_speed_down
    crawl_slide.crawl_down = this.Define_CrawlDown(crawl_slide.crawl_up, const)
    crawl_slide.crawl_down_label = this.Define_CrawlDown_Label(crawl_slide.crawl_down, const)
    crawl_slide.crawl_down_help = this.Define_CrawlDown_Help(crawl_slide.crawl_down_label, const)

    crawl_slide.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(crawl_slide)
end

function ActivateWindow_CrawlSlide(vars_ui, const)
    if not vars_ui.crawl_slide then
        DefineWindow_CrawlSlide(vars_ui, const)
    end

    vars_ui.crawl_slide.changes:Clear()

    vars_ui.crawl_slide.slide_speed.value = nil
    vars_ui.crawl_slide.slide_drag.value = nil
    vars_ui.crawl_slide.crawl_horz.value = nil
    vars_ui.crawl_slide.crawl_up.value = nil
    vars_ui.crawl_slide.crawl_down.value = nil
end

function DrawWindow_CrawlSlide(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local crawl_slide = vars_ui.crawl_slide

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_SlideSpeed(crawl_slide.slide_speed, player_arcade)

    this.Refresh_SlideDrag(crawl_slide.slide_drag, player_arcade)

    this.Refresh_CrawlHorz(crawl_slide.crawl_horz, player_arcade)

    this.Refresh_CrawlUp(crawl_slide.crawl_up, player_arcade)

    this.Refresh_CrawlDown(crawl_slide.crawl_down, player_arcade)

    this.Refresh_IsDirty(crawl_slide.okcancel, player_arcade, crawl_slide.slide_speed, crawl_slide.slide_drag, crawl_slide.crawl_horz, crawl_slide.crawl_up, crawl_slide.crawl_down)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(crawl_slide.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(crawl_slide.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(crawl_slide.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(crawl_slide.slide_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.slide_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(crawl_slide.slide_speed_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.slide_speed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(crawl_slide.slide_speed, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(crawl_slide.slide_drag_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.slide_drag_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(crawl_slide.slide_drag, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(crawl_slide.crawl_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.crawl_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(crawl_slide.crawl_horz_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.crawl_horz_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(crawl_slide.crawl_horz, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(crawl_slide.crawl_up_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.crawl_up_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(crawl_slide.crawl_up, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(crawl_slide.crawl_down_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(crawl_slide.crawl_down_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(crawl_slide.crawl_down, vars_ui.style.slider, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(crawl_slide.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, player_arcade, crawl_slide.slide_speed, crawl_slide.slide_drag, crawl_slide.crawl_horz, crawl_slide.crawl_up, crawl_slide.crawl_down)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not crawl_slide.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Slide_Label(const)
    -- Label
    return
    {
        text = "Grab Sliding",

        position =
        {
            pos_x = -30,
            pos_y = -175,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Slide_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_Slide_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[When trying to grab a wall, the player will slide if they are falling too fast]]

    return retVal
end

function this.Define_SlideSpeed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Min Speed",

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
function this.Define_SlideSpeed_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_SlideSpeed_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is the speed where the player can finally grab

If moving faster than this speed, drag will be applied to slow the player down

If moving slower than this speed, the player will stop and hang at that spot]]

    return retVal
end
function this.Define_SlideSpeed(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "CrawlSlide_SlideSpeed_Value",

        min = 0,
        max = 12,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_SlideSpeed(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallSlide_minSpeed
    end
end

function this.Define_SlideDrag_Label(relative_to, const)
    -- Label
    return
    {
        text = "Drag",

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
function this.Define_SlideDrag_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_SlideDrag_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[When trying to grab and going too fast, this is how much acceleration to apply in order to slow the player down]]

    return retVal
end
function this.Define_SlideDrag(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "CrawlSlide_SlideDrag_Value",

        min = 8,
        max = 32,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_SlideDrag(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallSlide_dragAccel
    end
end

function this.Define_Crawl_Label(relative_to, const)
    -- Label
    return
    {
        text = "Crawl Speed",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 50,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Crawl_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_Crawl_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is how fast the player can crawl along walls]]

    return retVal
end

function this.Define_CrawlHorz_Label(relative_to, const)
    -- Label
    return
    {
        text = "Horizontal",

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
function this.Define_CrawlHorz_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_CrawlHorz_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Crawling speed horizontally]]

    return retVal
end
function this.Define_CrawlHorz(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "CrawlSlide_CrawlHorz_Value",

        min = 0,
        max = 4,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_CrawlHorz(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallcrawl_speed_horz
    end
end

function this.Define_CrawlUp_Label(relative_to, const)
    -- Label
    return
    {
        text = "Up",

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
function this.Define_CrawlUp_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_CrawlUp_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Crawling speed when going up]]

    return retVal
end
function this.Define_CrawlUp(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "CrawlSlide_CrawlUp_Value",

        min = 0,
        max = 4,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_CrawlUp(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallcrawl_speed_up
    end
end

function this.Define_CrawlDown_Label(relative_to, const)
    -- Label
    return
    {
        text = "Down",

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
function this.Define_CrawlDown_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "CrawlSlide_CrawlDown_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Crawling speed when going down]]

    return retVal
end
function this.Define_CrawlDown(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "CrawlSlide_CrawlDown_Value",

        min = 0,
        max = 4,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_CrawlDown(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallcrawl_speed_down
    end
end

function this.Refresh_IsDirty(def, player_arcade, slide_speed, slide_drag, crawl_horz, crawl_up, crawl_down)
    local isDirty = false

    if not IsNearValue(slide_speed.value, player_arcade.wallSlide_minSpeed) then
        isDirty = true

    elseif not IsNearValue(slide_drag.value, player_arcade.wallSlide_dragAccel) then
        isDirty = true

    elseif not IsNearValue(crawl_horz.value, player_arcade.wallcrawl_speed_horz) then
        isDirty = true

    elseif not IsNearValue(crawl_up.value, player_arcade.wallcrawl_speed_up) then
        isDirty = true

    elseif not IsNearValue(crawl_down.value, player_arcade.wallcrawl_speed_down) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, player_arcade, slide_speed, slide_drag, crawl_horz, crawl_up, crawl_down)
    player_arcade.wallSlide_minSpeed = slide_speed.value
    player_arcade.wallSlide_dragAccel = slide_drag.value
    player_arcade.wallcrawl_speed_horz = crawl_horz.value
    player_arcade.wallcrawl_speed_up = crawl_up.value
    player_arcade.wallcrawl_speed_down = crawl_down.value

    player_arcade:Save()
    player:Reset()
end