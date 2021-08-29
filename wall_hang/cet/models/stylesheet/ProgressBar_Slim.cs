using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace grapple_ui.models.stylesheet
{
    public record ProgressBar_Slim
    {
        public double border_cornerRadius { get; init; }
        public double border_thickness { get; init; }

        public double height { get; init; }
    }
}
