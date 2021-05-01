using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models
{
    /// <summary>
    /// These are properties used by the UI
    /// </summary>
    /// <remarks>
    /// At runtime, all the color settings will be stored in both hex and r,g,b,a.  But the json
    /// will only have the hex version.  RGBA will be calculated as a post process of deserialization
    /// 
    /// Pattern is:
    /// ColorName = "hex value"
    /// ColorName_R = 0 to 1
    /// ColorName_G
    /// ColorName_B
    /// ColorName_A
    /// 
    /// NOTE: All color properties must have _color[^a-z0-9] in the name
    /// 
    /// NOTE: There is currently no mouse down color defined.  When CET allows ImGui to reliably report it, then add it at that time
    /// </remarks>
    public record Stylesheet
    {

        //TODO: Window colors


        public Stylesheet_SummaryButton summaryButton { get; init; }
    }
}
