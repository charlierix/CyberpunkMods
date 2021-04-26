local extern_json = require "external/json"

function InitializeUI(vars_ui)
    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = LoadStylesheet()

    ReportTable_lite(vars_ui)

    --TestJSON()

end

function GetScreenInfo()
    local width, height = GetDisplayResolution()

    return
    {
        width = width,
        height = height,
        center_x = width / 2,
        center_y = height / 2,
    }
end

function LoadStylesheet()
    local file = io.open("ui/stylesheet.json", "r")
    if not file then
        print("GRAPPLING HOOK ERROR: Can't find file: ui/stylesheet.json")
        return nil
    end

    local json = file:read("*all")

    --local style = Deserialize_Table(json)
    local style = extern_json.decode(json)

    ReportTable_lite(style)

    print("-----------------------")

    --TODO: Convert color strings

    return style
end

function TestJSON()
    local input =
    {
        summaryButton_border_cornerRadius = 8,
        summaryButton_border_thickness = 2,
        summaryButton_border_color_standard = "FFF",
        summaryButton_border_color_hover = "FFF",
        summaryButton_background_color_standard = "3666",
        summaryButton_background_color_hover = "5888",
        summaryButton_padding = 16,
        summaryButton_header_color = "FFF",
        summaryButton_header_gap = 4,
        summaryButton_content_color_prompt = "888",
        summaryButton_content_color_value = "AAA",
    }

    print("-------- input --------")

    ReportTable_lite(input)

    print("-------- json --------")

    local json = Serialize_Table(input)

    print(json)

    print("-------- output --------")

    local output = Deserialize_Table(json)

    ReportTable_lite(output)



end