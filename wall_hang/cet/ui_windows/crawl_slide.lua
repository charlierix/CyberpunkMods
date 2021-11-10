local this = {}

function DefineWindow_CrawlSlide(vars_ui, const)
    local crawl_slide = {}
    vars_ui.crawl_slide = crawl_slide

    crawl_slide.changes = Changes:new()

    crawl_slide.title = Define_Title("Crawl/Slide", const)




    crawl_slide.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(crawl_slide)
end

function ActivateWindow_CrawlSlide(vars_ui, const)
    if not vars_ui.crawl_slide then
        DefineWindow_CrawlSlide(vars_ui, const)
    end

    vars_ui.crawl_slide.changes:Clear()
end

function DrawWindow_CrawlSlide(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local crawl_slide = vars_ui.crawl_slide

    ------------------------- Finalize models for this frame -------------------------


    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(crawl_slide.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(crawl_slide.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(crawl_slide.title, vars_ui.style.colors)




    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(crawl_slide.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        --this.Save(crawl_slide.latch_wallhang, crawl_slide.mouse_sensitivity, crawl_slide.rightstick_sensitivity, crawl_slide.jump_strength, const, player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not crawl_slide.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------
