using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Effects;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_PropsAtAngle : DependencyObject
    {
        public string Name
        {
            get { return (string)GetValue(NameProperty); }
            set { SetValue(NameProperty, value); }
        }
        public static readonly DependencyProperty NameProperty = DependencyProperty.Register("Name", typeof(string), typeof(VM_PropsAtAngle), new PropertyMetadata(""));

        public Brush HeaderBorder
        {
            get { return (Brush)GetValue(HeaderBorderProperty); }
            set { SetValue(HeaderBorderProperty, value); }
        }
        public static readonly DependencyProperty HeaderBorderProperty = DependencyProperty.Register("HeaderBorder", typeof(Brush), typeof(VM_PropsAtAngle), new PropertyMetadata(Brushes.Transparent));

        public Brush HeaderBackground
        {
            get { return (Brush)GetValue(HeaderBackgroundProperty); }
            set { SetValue(HeaderBackgroundProperty, value); }
        }
        public static readonly DependencyProperty HeaderBackgroundProperty = DependencyProperty.Register("HeaderBackground", typeof(Brush), typeof(VM_PropsAtAngle), new PropertyMetadata(Brushes.Transparent));

        public Effect HeaderDropShadow
        {
            get { return (Effect)GetValue(HeaderDropShadowProperty); }
            set { SetValue(HeaderDropShadowProperty, value); }
        }
        public static readonly DependencyProperty HeaderDropShadowProperty = DependencyProperty.Register("HeaderDropShadow", typeof(Effect), typeof(VM_PropsAtAngle), new PropertyMetadata(null));

        public VM_Slider Percent_Up { get; set; }
        public VM_Slider Percent_Along { get; set; }
        public VM_Slider Percent_Away { get; set; }

        public VM_Slider Percent_YawTurn { get; set; }

        public VM_Slider Percent_Look { get; set; }

        // ------------- Helper Methods -------------
        public static VM_PropsAtAngle FromModel(PropsAtAngle props, string name, string color)
        {
            var brushes = GetBrushes(color);

            return new VM_PropsAtAngle()
            {
                Name = name,

                HeaderBorder = brushes.border,
                HeaderBackground = brushes.background,
                HeaderDropShadow = brushes.dropshadow,

                Percent_Up = Get_Percent_Up(props.Percent_Up),
                Percent_Along = Get_Percent_Along(props.Percent_Along),
                Percent_Away = Get_Percent_Away(props.Percent_Away),

                Percent_YawTurn = Get_Percent_YawTurn(props.Percent_YawTurn),

                Percent_Look = Get_Percent_Look(props.Percent_Look),
            };
        }

        public static (Brush border, Brush background, Effect dropshadow) GetBrushes(string color)
        {
            Color color_cast = string.IsNullOrWhiteSpace(color) ?
                Colors.Transparent :
                UtilityWPF.ColorFromHex(color);

            return GetBrushes(color_cast);
        }
        public static (Brush border, Brush background, Effect dropshadow) GetBrushes(Color color)
        {
            Brush border = Brushes.Transparent;
            Brush background = Brushes.Transparent;
            Effect dropshadow = null;

            if (color != Colors.Transparent)
            {
                border = new LinearGradientBrush(
                    UtilityWPF.AlphaBlend(color, Colors.Transparent, 0.15),
                    Colors.Transparent,
                    270);

                // It can't have transparency, or the drop shadow will be around the text
                //background = new SolidColorBrush(UtilityWPF.AlphaBlend(color, Colors.Transparent, 0.1));      
                background = new SolidColorBrush(UtilityWPF.AlphaBlend(color, SystemColors.ControlColor, 0.1));

                dropshadow = new DropShadowEffect()
                {
                    Color = color,
                    Direction = 270,
                    ShadowDepth = 4,
                    BlurRadius = 5,
                    Opacity = 0.09,
                };
            }

            return (border, background, dropshadow);
        }

        public static VM_Slider Get_Percent_Up(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Up %", 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Along(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Along %", 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Away(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Away %", 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_YawTurn(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Yaw Turn %", 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Look(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Look Influence %", 0, 1, value, false);
        }
    }
}
