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
        public DependencyObject Parent { get; set; }

        public SliderPropType PropType { get; set; }

        // ------------- Min/Max Intervals -------------
        public double Minimum
        {
            get { return (double)GetValue(MinimumProperty); }
            set { SetValue(MinimumProperty, value); }
        }
        public static readonly DependencyProperty MinimumProperty = DependencyProperty.Register("Minimum", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d, OnMinMaxChanged));

        public double Maximum
        {
            get { return (double)GetValue(MaximumProperty); }
            set { SetValue(MaximumProperty, value); }
        }
        public static readonly DependencyProperty MaximumProperty = DependencyProperty.Register("Maximum", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d, OnMinMaxChanged));

        private static void OnMinMaxChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Slider parent = (VM_Slider)d;

            double diff = parent.Maximum - parent.Minimum;

            parent.LargChange = diff / 12;
            parent.SmallChange = diff / 144;
        }

        public double SmallChange
        {
            get { return (double)GetValue(SmallChangeProperty); }
            set { SetValue(SmallChangeProperty, value); }
        }
        public static readonly DependencyProperty SmallChangeProperty = DependencyProperty.Register("SmallChange", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d));

        public double LargChange
        {
            get { return (double)GetValue(LargChangeProperty); }
            set { SetValue(LargChangeProperty, value); }
        }
        public static readonly DependencyProperty LargChangeProperty = DependencyProperty.Register("LargChange", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d));

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

            if (parent.IsNameReadonly)
            {
                parent.TextboxBack = Brushes.Transparent;
                parent.TextboxBorder = Brushes.Transparent;
                parent.TextboxBorderThickness = 0;
            }
            else
            {
                parent.TextboxBack = UtilityWPF.BrushFromHex("5FFF");
                parent.TextboxBorder = UtilityWPF.BrushFromHex("2666");
                parent.TextboxBorderThickness = 1;
            }
        }

        public Effect Effect
        {
            get { return (Effect)GetValue(EffectProperty); }
            set { SetValue(EffectProperty, value); }
        }
        public static readonly DependencyProperty EffectProperty = DependencyProperty.Register("Effect", typeof(Effect), typeof(VM_Slider), new PropertyMetadata(null));

        public Brush TextboxBack
        {
            get { return (Brush)GetValue(TextboxBackProperty); }
            set { SetValue(TextboxBackProperty, value); }
        }
        public static readonly DependencyProperty TextboxBackProperty = DependencyProperty.Register("TextboxBack", typeof(Brush), typeof(VM_Slider), new PropertyMetadata(Brushes.Transparent));

        public Brush TextboxBorder
        {
            get { return (Brush)GetValue(TextboxBorderProperty); }
            set { SetValue(TextboxBorderProperty, value); }
        }
        public static readonly DependencyProperty TextboxBorderProperty = DependencyProperty.Register("TextboxBorder", typeof(Brush), typeof(VM_Slider), new PropertyMetadata(Brushes.Transparent));

        public double TextboxBorderThickness
        {
            get { return (double)GetValue(TextboxBorderThicknessProperty); }
            set { SetValue(TextboxBorderThicknessProperty, value); }
        }
        public static readonly DependencyProperty TextboxBorderThicknessProperty = DependencyProperty.Register("TextboxBorderThickness", typeof(double), typeof(VM_Slider), new PropertyMetadata(0d));

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

                case SliderPropType.Other_Small:
                case SliderPropType.Other_Large:
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

                case SliderPropType.Other_Large:
                    return UtilityCore.Format_DecimalToDozenal(value, 0);

                case SliderPropType.Other_Small:
                default:
                    return UtilityCore.Format_DecimalToDozenal(value, 1);
            }
        }

        // ------------- Help Popup Text -------------

        public string HelpText
        {
            get { return (string)GetValue(HelpTextProperty); }
            set { SetValue(HelpTextProperty, value); }
        }
        public static readonly DependencyProperty HelpTextProperty = DependencyProperty.Register("HelpText", typeof(string), typeof(VM_Slider), new PropertyMetadata("test string", OnHelpTextChanged));

        private static void OnHelpTextChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Slider parent = (VM_Slider)d;

            parent.HelpTextVisibility = string.IsNullOrWhiteSpace(parent.HelpText) ?
                Visibility.Collapsed :
                Visibility.Visible;
        }

        public Visibility HelpTextVisibility
        {
            get { return (Visibility)GetValue(HelpTextVisibilityProperty); }
            set { SetValue(HelpTextVisibilityProperty, value); }
        }
        public static readonly DependencyProperty HelpTextVisibilityProperty = DependencyProperty.Register("HelpTextVisibility", typeof(Visibility), typeof(VM_Slider), new PropertyMetadata(Visibility.Collapsed));

        // ------------- Helper Methods -------------

        public static VM_Slider FromModel(DependencyObject parent, NamedAngle angle, string help_text, bool allow_name_change)
        {
            return new VM_Slider()
            {
                Parent = parent,
                PropType = SliderPropType.Angle,
                Name = angle.Name,
                HelpText = help_text,
                IsNameReadonly = !allow_name_change,
                Minimum = 0,
                Maximum = 180,
                Value = angle.Degrees,
                Color = string.IsNullOrWhiteSpace(angle.Color) ?
                    Colors.Transparent :
                    UtilityWPF.ColorFromHex(angle.Color),
            };
        }
        public static VM_Slider FromModel(DependencyObject parent, SliderPropType prop_type, string name, string help_text, double minimum, double maximum, double value, bool allow_name_change, string color = null)
        {
            return new VM_Slider()
            {
                Parent = parent,
                PropType = prop_type,
                Name = name,
                HelpText = help_text,
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
