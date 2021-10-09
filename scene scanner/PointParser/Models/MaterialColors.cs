using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace PointParser.Models
{
    public record MaterialColors
    {
        public KeyValuePair<string, Color>[] Map { get; init; }
    }
}
