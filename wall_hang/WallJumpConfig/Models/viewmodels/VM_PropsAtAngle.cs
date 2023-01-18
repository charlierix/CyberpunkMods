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

        public Visibility LERPVisibility
        {
            get { return (Visibility)GetValue(LERPVisibilityProperty); }
            set { SetValue(LERPVisibilityProperty, value); }
        }
        public static readonly DependencyProperty LERPVisibilityProperty = DependencyProperty.Register("LERPVisibility", typeof(Visibility), typeof(VM_PropsAtAngle), new PropertyMetadata(Visibility.Collapsed));

        public VM_Slider Percent_Up { get; set; }
        public VM_Slider Percent_Along { get; set; }
        public VM_Slider Percent_Away { get; set; }

        public VM_Slider Percent_YawTurn { get; set; }

        public VM_Slider Percent_Look { get; set; }
        public VM_Slider Percent_LookStrength { get; set; }

        public VM_Slider Percent_LatchAfterJump { get; set; }
        public VM_Slider WallAttract_DistanceMax { get; set; }
        public VM_Slider WallAttract_Accel { get; set; }
        public VM_Slider WallAttract_Pow { get; set; }
        public VM_Slider WallAttract_Antigrav { get; set; }

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

                LERPVisibility = string.IsNullOrEmpty(color) ?      // 0 and 180 are uncolored, everything in the middle are colored
                    Visibility.Collapsed :
                    Visibility.Visible,

                Percent_Up = Get_Percent_Up(props.Percent_Up),
                Percent_Along = Get_Percent_Along(props.Percent_Along),
                Percent_Away = Get_Percent_Away(props.Percent_Away),

                Percent_YawTurn = Get_Percent_YawTurn(props.Percent_YawTurn),

                Percent_Look = Get_Percent_Look(props.Percent_Look),
                Percent_LookStrength = Get_Percent_LookStrength(props.Percent_LookStrength),

                Percent_LatchAfterJump = Get_Percent_LatchAfterJump(props.Percent_LatchAfterJump),
                WallAttract_DistanceMax = Get_WallAttract_DistanceMax(props.WallAttract_DistanceMax),
                WallAttract_Accel = Get_WallAttract_Accel(props.WallAttract_Accel),
                WallAttract_Pow = Get_WallAttract_Pow(props.WallAttract_Pow),
                WallAttract_Antigrav = Get_WallAttract_Antigrav(props.WallAttract_Antigrav),
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
            return VM_Slider.FromModel(SliderPropType.Percent, "Up %", HelpMessages.UpPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Along(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Along %", HelpMessages.AlongPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Away(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Away %", HelpMessages.AwayPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_YawTurn(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Yaw Turn %", HelpMessages.YawTurnPercent, -1, 1, value, false);
        }
        public static VM_Slider Get_Percent_Look(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Look Influence %", HelpMessages.LookInfluencePercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_LookStrength(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Look Strength %", HelpMessages.LookStrengthPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_LatchAfterJump(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Percent, "Latch After Jump %", HelpMessages.LatchAfterJumpPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_WallAttract_DistanceMax(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Other, "WallAttract Distance", HelpMessages.WallAttract_Distance, 1.2, 16, value, false);
        }
        public static VM_Slider Get_WallAttract_Accel(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Other, "WallAttract Accel", HelpMessages.WallAttract_Accel, 4, 24, value, false);
        }
        public static VM_Slider Get_WallAttract_Pow(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Other, "WallAttract Pow", HelpMessages.WallAttract_Pow, 1, 12, value, false);
        }
        public static VM_Slider Get_WallAttract_Antigrav(double value)
        {
            return VM_Slider.FromModel(SliderPropType.Other, "WallAttract AntiGrav", HelpMessages.WallAttract_AntiGrav, 0, 1.5, value, false);
        }
    }
}
