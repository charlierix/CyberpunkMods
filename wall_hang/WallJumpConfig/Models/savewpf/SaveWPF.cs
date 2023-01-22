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
        public string Description { get; init; }

        public SaveWPF_Horizontal Horizontal { get; init; }
        public SaveWPF_Vertical_StraightUp Vertical_StraightUp { get; init; }

        // ------------- Helper Methods -------------
        public static SaveWPF FromModel(VM_Horizontal horizontal, VM_StraightUp straightUp)
        {
            return new SaveWPF()
            {
                Description = horizontal.Description,
                Horizontal = SaveWPF_Horizontal.FromModel(horizontal),
                Vertical_StraightUp = SaveWPF_Vertical_StraightUp.FromModel(straightUp),
            };
        }
    }
}
