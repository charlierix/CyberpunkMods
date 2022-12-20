using System.Windows.Media;
using System.Windows;

namespace WallJumpConfig.Models.misc
{
    public record RotatableLine
    {
        public FrameworkElement Line { get; init; }
        public RotateTransform Rotate { get; init; }
    }
}
