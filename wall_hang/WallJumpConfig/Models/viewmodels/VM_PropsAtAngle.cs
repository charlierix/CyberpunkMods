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
        public VM_Slider RelatchTime_Emoseconds { get; set; }

        public VM_Slider WallAttract_DistanceMax { get; set; }
        public VM_Slider WallAttract_Accel { get; set; }
        public VM_Slider WallAttract_Pow { get; set; }
        public VM_Slider WallAttract_Antigrav { get; set; }

        // ------------- Helper Methods -------------
        public static VM_PropsAtAngle FromModel(PropsAtAngle props, string name, string color)
        {
            var brushes = GetBrushes(color);

            var retVal = new VM_PropsAtAngle()
            {
                Name = name,

                HeaderBorder = brushes.border,
                HeaderBackground = brushes.background,
                HeaderDropShadow = brushes.dropshadow,

                LERPVisibility = string.IsNullOrEmpty(color) ?      // 0 and 180 are uncolored, everything in the middle are colored
                    Visibility.Collapsed :
                    Visibility.Visible,
            };

            retVal.Percent_Up = Get_Percent_Up(retVal, props.Percent_Up);
            retVal.Percent_Along = Get_Percent_Along(retVal, props.Percent_Along);
            retVal.Percent_Away = Get_Percent_Away(retVal, props.Percent_Away);

            retVal.Percent_YawTurn = Get_Percent_YawTurn(retVal, props.Percent_YawTurn);

            retVal.Percent_Look = Get_Percent_Look(retVal, props.Percent_Look);
            retVal.Percent_LookStrength = Get_Percent_LookStrength(retVal, props.Percent_LookStrength);

            retVal.Percent_LatchAfterJump = Get_Percent_LatchAfterJump(retVal, props.Percent_LatchAfterJump);
            retVal.RelatchTime_Emoseconds = Get_RelatchTime_Emoseconds(retVal, props.RelatchTime_Emoseconds);

            retVal.WallAttract_DistanceMax = Get_WallAttract_DistanceMax(retVal, props.WallAttract_DistanceMax);
            retVal.WallAttract_Accel = Get_WallAttract_Accel(retVal, props.WallAttract_Accel);
            retVal.WallAttract_Pow = Get_WallAttract_Pow(retVal, props.WallAttract_Pow);
            retVal.WallAttract_Antigrav = Get_WallAttract_Antigrav(retVal, props.WallAttract_Antigrav);

            return retVal;
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

        public static VM_Slider Get_Percent_Up(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Up %", HelpMessages.UpPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Along(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Along %", HelpMessages.AlongPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_Away(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Away %", HelpMessages.AwayPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_YawTurn(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Yaw Turn %", HelpMessages.YawTurnPercent, -1, 1, value, false);
        }
        public static VM_Slider Get_Percent_Look(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Look Influence %", HelpMessages.LookInfluencePercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_LookStrength(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Look Strength %", HelpMessages.LookStrengthPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_Percent_LatchAfterJump(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Percent, "Latch After Jump %", HelpMessages.LatchAfterJumpPercent, 0, 1, value, false);
        }
        public static VM_Slider Get_RelatchTime_Emoseconds(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Other_Large, "Relatch Time (emoseconds)", HelpMessages.RelatchTime, 0, 2 * 12 * 12 * 12, value, false);
        }
        public static VM_Slider Get_WallAttract_DistanceMax(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Other_Small, "WallAttract Distance", HelpMessages.WallAttract_Distance, 1.2, 16, value, false);
        }
        public static VM_Slider Get_WallAttract_Accel(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Other_Small, "WallAttract Accel", HelpMessages.WallAttract_Accel, 4, 24, value, false);
        }
        public static VM_Slider Get_WallAttract_Pow(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Other_Small, "WallAttract Pow", HelpMessages.WallAttract_Pow, 1, 12, value, false);
        }
        public static VM_Slider Get_WallAttract_Antigrav(DependencyObject parent, double value)
        {
            return VM_Slider.FromModel(parent, SliderPropType.Other_Small, "WallAttract AntiGrav", HelpMessages.WallAttract_AntiGrav, 0, 1.5, value, false);
        }
    }
}
