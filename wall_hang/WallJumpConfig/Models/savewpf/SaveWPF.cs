using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.savewpf
{
    public record SaveWPF
    {
        public SaveWPF_Horizontal Horizontal { get; init; }
        public SaveWPF_Vertical_StraightUp Vertical_StraightUp { get; init; }

        public bool HasStraightUp => Vertical_StraightUp != null;

        // ------------- Helper Methods -------------
        public static SaveWPF FromModel(VM_Horizontal horizontal, VM_StraightUp straightUp)
        {
            var save_horz = SaveWPF_Horizontal.FromModel(horizontal);

            SaveWPF_Vertical_StraightUp save_vert = null;
            if (straightUp != null && straightUp.HasStraightUp)
                save_vert = SaveWPF_Vertical_StraightUp.FromModel(straightUp);

            return new SaveWPF()
            {
                Horizontal = save_horz,
                Vertical_StraightUp = save_vert,
            };
        }
    }
}
