﻿using grapple_ui.models.stylesheet;
using System.Collections.Generic;

namespace models.stylesheet
{
    /// <summary>
    /// These are properties used by the UI
    /// </summary>
    /// <remarks>
    /// At runtime, all the color settings will be converted into ints
    /// 
    /// The values in json are ARGB (see color.ConvertHexStringToNumbers)
    /// 
    /// Pattern is:
    ///     namewith_color = "hex value"
    ///     namewith_color_argb = int
    ///     namewith_color_abgr
    ///     // namewith_color_a = 0 to 1       -- these individual ints are no longer needed.  They could be added back if needed though
    ///     // namewith_color_r
    ///     // namewith_color_g
    ///     // namewith_color_b
    /// 
    /// NOTE: It's allowed to have text after _color
    ///     "sometext_color_hover": "ABC"
    ///     becomes
    ///     "sometext_color_hover" = nil
    ///     "sometext_color_hover_argb" = 0xFFAABBCC
    ///     "sometext_color_hover_abgr" = 0xFFCCBBAA        // almost all functions use this
    ///     // "sometext_color_hover_a" = 0xFF / 255        // no longer used (but could be added back if needed)
    ///     // "sometext_color_hover_r" = 0xAA / 255
    ///     // "sometext_color_hover_g" = 0xBB / 255
    ///     // "sometext_color_hover_b" = 0xCC / 255
    /// 
    /// NOTE: All color properties must have _color in the name
    /// NOTE: There is nothing to stop from bad names: "something_colorthisisbad"
    /// 
    /// NOTE: There is currently no mouse down color defined.  When CET allows ImGui to reliably report it, then add it at that time
    /// </remarks>
    public record Stylesheet
    {
        // Window colors
        public string title_color_focused { get; init; }
        public string title_color_notFocused { get; init; }
        public string title_color_collapsed { get; init; }

        public string title_color_foreground { get; init; }

        public string title_color_button_hover { get; init; }
        public string title_color_button_click { get; init; }

        public string back_color { get; init; }
        public string border_color { get; init; }

        public TextBox textbox { get; init; }

        public CheckBox checkbox { get; init; }

        public Slider slider { get; init; }

        public IconButton iconbutton { get; init; }

        public Button button { get; init; }

        public OkCancelButtons okcancelButtons { get; init; }

        public SummaryButton summaryButton { get; init; }

        public UpDownButtons updownButtons { get; init; }

        public ListBox listbox { get; init; }

        public MultiItemDisplayList multiitem_displaylist { get; init; }

        public GridView gridview { get; init; }

        public ProgressBar_Slim progressbar_slim { get; init; }

        public HelpButton helpButton { get; init; }

        public RemoveButton removeButton { get; init; }

        public Tooltip tooltip { get; init; }

        public ColorSample colorSample { get; init; }

        public DotPowGraph dotpow_graph { get; init; }

        /// <summary>
        /// For now, it's just a place to define named colors.  If more is needed later, change this to
        /// styles -- my background is wpf, not css :)
        /// </summary>
        /// <remarks>
        /// How to define in json
        ///     "colors":
        ///     [
        ///         "name1": { the_color: "color1" },
        ///         "name2": { the_color: "color2" }
        ///     ]
        /// </remarks>
        public Dictionary<string, NamedColor> colors { get; init; }
    }
}
