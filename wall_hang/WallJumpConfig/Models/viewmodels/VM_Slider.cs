using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Effects;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_Slider : DependencyObject
    {
        public SliderPropType PropType { get; set; }

        public double Minimum { get; set; }
        public double Maximum { get; set; }

        // ------------- Name -------------
        public bool IsNameReadonly { get; set; }

        public string Name
        {
            get { return (string)GetValue(NameProperty); }
            set { SetValue(NameProperty, value); }
        }
        public static readonly DependencyProperty NameProperty = DependencyProperty.Register("Name", typeof(string), typeof(VM_Slider), new PropertyMetadata("", OnNameChanged));

        private static void OnNameChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Slider parent = (VM_Slider)d;
            parent.NameChanged?.Invoke(parent, new EventArgs());
        }

        public event EventHandler NameChanged = null;

        // ------------- Color and dependent DropShadow -------------
        public Color Color
        {
            get { return (Color)GetValue(ColorProperty); }
            set { SetValue(ColorProperty, value); }
        }
        public static readonly DependencyProperty ColorProperty = DependencyProperty.Register("Color", typeof(Color), typeof(VM_Slider), new PropertyMetadata(Colors.Transparent, OnColorChanged));

        private static void OnColorChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Slider parent = (VM_Slider)d;

            parent.Effect = parent.Color == Colors.Transparent ?
                null :
                new DropShadowEffect()
                {
                    Color = parent.Color,
                    Direction = 0,
                    ShadowDepth = 0,
                    BlurRadius = 6,
                    Opacity = .66,
                };
        }

        public Effect Effect
        {
            get { return (Effect)GetValue(EffectProperty); }
            set { SetValue(EffectProperty, value); }
        }
        public static readonly DependencyProperty EffectProperty = DependencyProperty.Register("Effect", typeof(Effect), typeof(VM_Slider), new PropertyMetadata(null));

        // ------------- Value and dependent ValueDisplay -------------
        public double Value
        {
            get { return (double)GetValue(ValueProperty); }
            set
            {
                SetValue(ValueProperty, value);
            }
        }
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register("Value", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d, OnValueChanged));

        private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Slider parent = (VM_Slider)d;
            parent.ValueDisplay = GetValueDisplay_Dozenal(parent.PropType, parent.Value);        // setting this to force the textblock to update
            parent.ValueChanged?.Invoke(parent, new EventArgs());
        }

        public event EventHandler ValueChanged = null;

        public string ValueDisplay
        {
            get { return (string)GetValue(ValueDisplayProperty); }
            set { SetValue(ValueDisplayProperty, value); }
        }
        public static readonly DependencyProperty ValueDisplayProperty = DependencyProperty.Register("ValueDisplay", typeof(string), typeof(VM_Slider), new PropertyMetadata("0"));

        private static string GetValueDisplay_Decimal(SliderPropType prop_type, double value)
        {
            switch (prop_type)
            {
                case SliderPropType.Angle:
                    return value.ToInt_Round().ToString();

                case SliderPropType.Percent:
                    return (value * 100).ToInt_Round().ToString();

                case SliderPropType.Other:
                default:
                    return value.ToStringSignificantDigits(1);
            }
        }
        private static string GetValueDisplay_Dozenal(SliderPropType prop_type, double value)
        {
            switch (prop_type)
            {
                case SliderPropType.Angle:
                    return UtilityCore.Format_DecimalToDozenal(value, 0);

                case SliderPropType.Percent:
                    return UtilityCore.Format_DecimalToDozenal(value * 144, 0);

                case SliderPropType.Other:
                default:
                    return UtilityCore.Format_DecimalToDozenal(value, 1);
            }
        }

        // ------------- Helper Methods -------------

        public static VM_Slider FromModel(NamedAngle angle, bool allow_name_change)
        {
            return new VM_Slider()
            {
                PropType = SliderPropType.Angle,
                Name = angle.Name,
                IsNameReadonly = !allow_name_change,
                Minimum = 0,
                Maximum = 180,
                Value = angle.Degrees,
                Color = string.IsNullOrWhiteSpace(angle.Color) ?
                    Colors.Transparent :
                    UtilityWPF.ColorFromHex(angle.Color),
            };
        }
        public static VM_Slider FromModel(SliderPropType prop_type, string name, double minimum, double maximum, double value, bool allow_name_change, string color = null)
        {
            return new VM_Slider()
            {
                PropType = prop_type,
                Name = name,
                IsNameReadonly = !allow_name_change,
                Minimum = minimum,
                Maximum = maximum,
                Value = value,
                Color = string.IsNullOrWhiteSpace(color) ?
                    Colors.Transparent :
                    UtilityWPF.ColorFromHex(color),
            };
        }
    }
}
