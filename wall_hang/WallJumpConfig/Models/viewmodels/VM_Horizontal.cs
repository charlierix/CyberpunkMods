using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Media;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_Horizontal : DependencyObject
    {
        // This belongs in a parent class, but there isn't one.  So just putting it here
        public string Description
        {
            get { return (string)GetValue(DescriptionProperty); }
            set { SetValue(DescriptionProperty, value); }
        }
        public static readonly DependencyProperty DescriptionProperty = DependencyProperty.Register("Description", typeof(string), typeof(VM_Horizontal), new PropertyMetadata(""));

        public VM_Horizontal()
        {
            ExtraAngles = new ObservableCollection<VM_Slider>();
            PropsAtAngles = new ObservableCollection<VM_PropsAtAngle>();
        }

        public ObservableCollection<VM_Slider> ExtraAngles { get; private set; }

        public ObservableCollection<VM_PropsAtAngle> PropsAtAngles { get; private set; }

        public VM_Slider Speed_FullStrength { get; set; }
        public VM_Slider Speed_ZeroStrength { get; set; }

        public VM_Slider Strength { get; set; }

        public event EventHandler ShowFilterChanged = null;

        // ------------- Show: UpAlongAway -------------

        public bool ShowUpAlongAway
        {
            get { return (bool)GetValue(ShowUpAlongAwayProperty); }
            set { SetValue(ShowUpAlongAwayProperty, value); }
        }
        public static readonly DependencyProperty ShowUpAlongAwayProperty = DependencyProperty.Register("ShowUpAlongAway", typeof(bool), typeof(VM_Horizontal), new PropertyMetadata(true, OnUpAlongAwayChanged));

        private static void OnUpAlongAwayChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Horizontal parent = (VM_Horizontal)d;

            parent.VisibilityUpAlongAway = parent.ShowUpAlongAway ?
                Visibility.Visible :
                Visibility.Collapsed;

            parent.VisibilityUpAlongAwaySeparator = parent.ShowUpAlongAway ?
                Visibility.Hidden :
                Visibility.Collapsed;

            parent.ShowFilterChanged?.Invoke(parent, new EventArgs());
        }

        public Visibility VisibilityUpAlongAway
        {
            get { return (Visibility)GetValue(VisibilityUpAlongAwayProperty); }
            set { SetValue(VisibilityUpAlongAwayProperty, value); }
        }
        public static readonly DependencyProperty VisibilityUpAlongAwayProperty = DependencyProperty.Register("VisibilityUpAlongAway", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Visible));

        public Visibility VisibilityUpAlongAwaySeparator
        {
            get { return (Visibility)GetValue(VisibilityUpAlongAwaySeparatorProperty); }
            set { SetValue(VisibilityUpAlongAwaySeparatorProperty, value); }
        }
        public static readonly DependencyProperty VisibilityUpAlongAwaySeparatorProperty = DependencyProperty.Register("VisibilityUpAlongAwaySeparator", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Hidden));

        // ------------- Show: Yaw -------------

        public bool ShowYaw
        {
            get { return (bool)GetValue(ShowYawProperty); }
            set { SetValue(ShowYawProperty, value); }
        }
        public static readonly DependencyProperty ShowYawProperty = DependencyProperty.Register("ShowYaw", typeof(bool), typeof(VM_Horizontal), new PropertyMetadata(true, OnYawChanged));

        private static void OnYawChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Horizontal parent = (VM_Horizontal)d;

            parent.VisibilityYaw = parent.ShowYaw ?
                Visibility.Visible :
                Visibility.Collapsed;

            parent.VisibilityYawSeparator = parent.ShowYaw ?
                Visibility.Hidden :
                Visibility.Collapsed;

            parent.ShowFilterChanged?.Invoke(parent, new EventArgs());
        }

        public Visibility VisibilityYaw
        {
            get { return (Visibility)GetValue(VisibilityYawProperty); }
            set { SetValue(VisibilityYawProperty, value); }
        }
        public static readonly DependencyProperty VisibilityYawProperty = DependencyProperty.Register("VisibilityYaw", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Visible));

        public Visibility VisibilityYawSeparator
        {
            get { return (Visibility)GetValue(VisibilityYawSeparatorProperty); }
            set { SetValue(VisibilityYawSeparatorProperty, value); }
        }
        public static readonly DependencyProperty VisibilityYawSeparatorProperty = DependencyProperty.Register("VisibilityYawSeparator", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Hidden));

        // ------------- Show: Look -------------

        public bool ShowLook
        {
            get { return (bool)GetValue(ShowLookProperty); }
            set { SetValue(ShowLookProperty, value); }
        }
        public static readonly DependencyProperty ShowLookProperty = DependencyProperty.Register("ShowLook", typeof(bool), typeof(VM_Horizontal), new PropertyMetadata(true, OnLookChanged));

        private static void OnLookChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Horizontal parent = (VM_Horizontal)d;

            parent.VisibilityLook = parent.ShowLook ?
                Visibility.Visible :
                Visibility.Collapsed;

            parent.VisibilityLookSeparator = parent.ShowLook ?
                Visibility.Hidden :
                Visibility.Collapsed;

            parent.ShowFilterChanged?.Invoke(parent, new EventArgs());
        }

        public Visibility VisibilityLook
        {
            get { return (Visibility)GetValue(VisibilityLookProperty); }
            set { SetValue(VisibilityLookProperty, value); }
        }
        public static readonly DependencyProperty VisibilityLookProperty = DependencyProperty.Register("VisibilityLook", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Visible));

        public Visibility VisibilityLookSeparator
        {
            get { return (Visibility)GetValue(VisibilityLookSeparatorProperty); }
            set { SetValue(VisibilityLookSeparatorProperty, value); }
        }
        public static readonly DependencyProperty VisibilityLookSeparatorProperty = DependencyProperty.Register("VisibilityLookSeparator", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Hidden));

        // ------------- Show: LatchPercent -------------

        public bool ShowRelatch
        {
            get { return (bool)GetValue(ShowRelatchProperty); }
            set { SetValue(ShowRelatchProperty, value); }
        }
        public static readonly DependencyProperty ShowRelatchProperty = DependencyProperty.Register("ShowRelatch", typeof(bool), typeof(VM_Horizontal), new PropertyMetadata(true, OnLatchPercentChanged));

        private static void OnLatchPercentChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Horizontal parent = (VM_Horizontal)d;

            parent.VisibilityRelatch = parent.ShowRelatch ?
                Visibility.Visible :
                Visibility.Collapsed;

            parent.VisibilityRelatchSeparator = parent.ShowRelatch ?
                Visibility.Hidden :
                Visibility.Collapsed;

            parent.ShowFilterChanged?.Invoke(parent, new EventArgs());
        }

        public Visibility VisibilityRelatch
        {
            get { return (Visibility)GetValue(VisibilityRelatchProperty); }
            set { SetValue(VisibilityRelatchProperty, value); }
        }
        public static readonly DependencyProperty VisibilityRelatchProperty = DependencyProperty.Register("VisibilityRelatch", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Visible));

        public Visibility VisibilityRelatchSeparator
        {
            get { return (Visibility)GetValue(VisibilityRelatchSeparatorProperty); }
            set { SetValue(VisibilityRelatchSeparatorProperty, value); }
        }
        public static readonly DependencyProperty VisibilityRelatchSeparatorProperty = DependencyProperty.Register("VisibilityRelatchSeparator", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Hidden));

        // ------------- Show: WallAttract -------------

        public bool ShowWallAttract
        {
            get { return (bool)GetValue(ShowWallAttractProperty); }
            set { SetValue(ShowWallAttractProperty, value); }
        }
        public static readonly DependencyProperty ShowWallAttractProperty = DependencyProperty.Register("ShowWallAttract", typeof(bool), typeof(VM_Horizontal), new PropertyMetadata(true, OnWallAttractChanged));

        private static void OnWallAttractChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_Horizontal parent = (VM_Horizontal)d;

            parent.VisibilityWallAttract = parent.ShowWallAttract ?
                Visibility.Visible :
                Visibility.Collapsed;

            parent.VisibilityWallAttractSeparator = parent.ShowWallAttract ?
                Visibility.Hidden :
                Visibility.Collapsed;

            parent.ShowFilterChanged?.Invoke(parent, new EventArgs());
        }

        public Visibility VisibilityWallAttract
        {
            get { return (Visibility)GetValue(VisibilityWallAttractProperty); }
            set { SetValue(VisibilityWallAttractProperty, value); }
        }
        public static readonly DependencyProperty VisibilityWallAttractProperty = DependencyProperty.Register("VisibilityWallAttract", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Visible));

        public Visibility VisibilityWallAttractSeparator
        {
            get { return (Visibility)GetValue(VisibilityWallAttractSeparatorProperty); }
            set { SetValue(VisibilityWallAttractSeparatorProperty, value); }
        }
        public static readonly DependencyProperty VisibilityWallAttractSeparatorProperty = DependencyProperty.Register("VisibilityWallAttractSeparator", typeof(Visibility), typeof(VM_Horizontal), new PropertyMetadata(Visibility.Hidden));

        // ------------- Helper Methods -------------
        public void AddExtraAngle()
        {
            double prev_angle = 0;
            if (ExtraAngles.Count > 0)
                prev_angle = ExtraAngles[^1].Value;

            var prev_prop = PropsAtAngles.Count >= 2 ? PropsAtAngles[^2] : null;
            var next_prop = PropsAtAngles.Count >= 2 ? PropsAtAngles[^1] : null;

            Color[] existing_colors = ExtraAngles.
                Where(o => o.Color != Colors.Transparent).
                Select(o => o.Color).
                ToArray();

            Color[] random_colors = UtilityWPF.GetRandomColors(1, 120, 210, existing_colors);     // this function treats colors like evenly distributed points in a cube, so it will choose a color that is as far away as possible from existing colors
            Color item_color = random_colors[0];        // statics are added to the end of the list

            var brushes = VM_PropsAtAngle.GetBrushes(item_color);

            var angle = new VM_Slider()
            {
                PropType = SliderPropType.Angle,
                Name = $"Extra Angle {ExtraAngles.Count + 1}",
                HelpText = HelpMessages.ExtraAngle,
                Minimum = 0,
                Maximum = 180,
                Value = Math1D.Avg(prev_angle, 180),        // this goes between the prev and 180 angle
                Color = item_color,
                IsNameReadonly = false,
            };

            var props = new VM_PropsAtAngle()
            {
                Name = angle.Name,

                HeaderBorder = brushes.border,
                HeaderBackground = brushes.background,
                HeaderDropShadow = brushes.dropshadow,

                LERPVisibility = Visibility.Visible,        // extra angles are always in the middle, so lerp is enabled

                Percent_Up = GetAvg(prev_prop, next_prop, o => o.Percent_Up),
                Percent_Along = GetAvg(prev_prop, next_prop, o => o.Percent_Along),
                Percent_Away = GetAvg(prev_prop, next_prop, o => o.Percent_Away),
                Percent_YawTurn = GetAvg(prev_prop, next_prop, o => o.Percent_YawTurn),
                Percent_Look = GetAvg(prev_prop, next_prop, o => o.Percent_Look),
                Percent_LookStrength = GetAvg(prev_prop, next_prop, o => o.Percent_LookStrength),
                Percent_LatchAfterJump = GetAvg(prev_prop, next_prop, o => o.Percent_LatchAfterJump),
                RelatchTime_Emoseconds = GetAvg(prev_prop, next_prop, o => o.RelatchTime_Emoseconds),
                WallAttract_DistanceMax = GetAvg(prev_prop, next_prop, o => o.WallAttract_DistanceMax),
                WallAttract_Accel = GetAvg(prev_prop, next_prop, o => o.WallAttract_Accel),
                WallAttract_Pow = GetAvg(prev_prop, next_prop, o => o.WallAttract_Pow),
                WallAttract_Antigrav = GetAvg(prev_prop, next_prop, o => o.WallAttract_Antigrav),
            };

            AddExtraAngle(angle, props);
        }
        public void AddExtraAngle(VM_Slider angle, VM_PropsAtAngle props)
        {
            angle.NameChanged += (s, e) => { props.Name = angle.Name; };        // they can only change the name from the angle control

            ExtraAngles.Add(angle);
            PropsAtAngles.Insert(ExtraAngles.Count, props);     // props has an extra item at [0], so using the 1 based extra.count as the 0 based insert index
        }

        public static VM_Horizontal FromModel(SaveWPF_Horizontal model, string description)
        {
            var retVal = new VM_Horizontal()
            {
                Description = description,
                Speed_FullStrength = VM_Slider.FromModel(SliderPropType.Other_Small, "Speed - full strength", HelpMessages.Speed_FullStrength, 0, 18, model.Speed_FullStrength, false),
                Speed_ZeroStrength = VM_Slider.FromModel(SliderPropType.Other_Small, "Speed - zero strength", HelpMessages.Speed_ZeroStrength, 0, 18, model.Speed_ZeroStrength, false),
                Strength = VM_Slider.FromModel(SliderPropType.Other_Small, "Jump Strength", HelpMessages.JumpStrength, 0, 24, model.Strength, false),
            };

            retVal.PropsAtAngles.Add(VM_PropsAtAngle.FromModel(model.Props_DirectFaceWall, "Directly Facing Wall", null));
            retVal.PropsAtAngles.Add(VM_PropsAtAngle.FromModel(model.Props_DirectAway, "Directly Away From Wall", null));

            for (int i = 0; i < model.Degrees_Extra.Length; i++)
            {
                var angle = VM_Slider.FromModel(model.Degrees_Extra[i], HelpMessages.ExtraAngle, true);
                var props = VM_PropsAtAngle.FromModel(model.Props_Extra[i], model.Degrees_Extra[i].Name, model.Degrees_Extra[i].Color);

                retVal.AddExtraAngle(angle, props);
            }

            return retVal;
        }

        private static VM_Slider GetAvg(VM_PropsAtAngle prev, VM_PropsAtAngle next, Func<VM_PropsAtAngle, VM_Slider> selector)
        {
            if (prev == null || next == null)
                throw new ArgumentNullException($"prev and next must both be populated.  prev: {(prev == null ? "null" : "populated")}, next: {(next == null ? "null" : "populated")}");

            VM_Slider prev_val = selector(prev);
            VM_Slider next_val = selector(next);

            return new VM_Slider()
            {
                PropType = prev_val.PropType,
                IsNameReadonly = true,
                Name = prev_val.Name,
                HelpText = prev_val.HelpText,
                Color = Colors.Transparent,

                Minimum = prev_val.Minimum,
                Maximum = prev_val.Maximum,
                Value = Math1D.Avg(prev_val.Value, next_val.Value),
            };
        }
    }
}
