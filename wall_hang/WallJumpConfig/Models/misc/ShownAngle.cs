using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig.Models.misc
{
    public record ShownAngle
    {
        public VM_Slider ViewModel { get; init; }
        public RotatableLine Left { get; init; }
        public RotatableLine Right { get; init; }
    }
}
