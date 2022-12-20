using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig.Models.savewpf
{
    public record SaveWPF
    {
        public SaveWPF_Horizontal Horizontal { get; init; }
        public SaveWPF_Vertical_StraightUp Vertical_StraightUp { get; init; }

        public bool HasStraightUp => Vertical_StraightUp != null;
    }
}
