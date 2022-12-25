using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Converters;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_Horizontal
    {
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

                Percent_Up = GetAvg(prev_prop, next_prop, o => o.Percent_Up, () => VM_PropsAtAngle.Get_Percent_Up(0.5)),
                Percent_Along = GetAvg(prev_prop, next_prop, o => o.Percent_Along, () => VM_PropsAtAngle.Get_Percent_Along(0.5)),
                Percent_Away = GetAvg(prev_prop, next_prop, o => o.Percent_Away, () => VM_PropsAtAngle.Get_Percent_Away(0.5)),
                Percent_YawTurn = GetAvg(prev_prop, next_prop, o => o.Percent_YawTurn, () => VM_PropsAtAngle.Get_Percent_YawTurn(0.5)),
                Percent_Look = GetAvg(prev_prop, next_prop, o => o.Percent_Look, () => VM_PropsAtAngle.Get_Percent_Look(0.5)),
            };

            AddExtraAngle(angle, props);
        }
        public void AddExtraAngle(VM_Slider angle, VM_PropsAtAngle props)
        {
            angle.NameChanged += (s, e) => { props.Name = angle.Name; };        // they can only change the name from the angle control

            ExtraAngles.Add(angle);
            PropsAtAngles.Insert(ExtraAngles.Count, props);     // props has an extra item at [0], so using the 1 based extra.count as the 0 based insert index
        }

        public static VM_Horizontal FromModel(SaveWPF_Horizontal model)
        {
            var retVal = new VM_Horizontal()
            {
                Speed_FullStrength = VM_Slider.FromModel(SliderPropType.Other, "Speed - full strength", 0, 18, model.Speed_FullStrength, false),
                Speed_ZeroStrength = VM_Slider.FromModel(SliderPropType.Other, "Speed - zero strength", 0, 18, model.Speed_ZeroStrength, false),
                Strength = VM_Slider.FromModel(SliderPropType.Other, "Jump Strength", 0, 24, model.Strength, false),
            };

            new VM_Horizontal();

            retVal.PropsAtAngles.Add(VM_PropsAtAngle.FromModel(model.Props_DirectFaceWall, "Directly Facing Wall", null));
            retVal.PropsAtAngles.Add(VM_PropsAtAngle.FromModel(model.Props_DirectAway, "Directly Away From Wall", null));

            for (int i = 0; i < model.Degrees_Extra.Length; i++)
            {
                var angle = VM_Slider.FromModel(model.Degrees_Extra[i], true);
                var props = VM_PropsAtAngle.FromModel(model.Props_Extra[i], model.Degrees_Extra[i].Name, model.Degrees_Extra[i].Color);

                retVal.AddExtraAngle(angle, props);
            }

            return retVal;
        }

        private static VM_Slider GetAvg(VM_PropsAtAngle prev, VM_PropsAtAngle next, Func<VM_PropsAtAngle, VM_Slider> selector, Func<VM_Slider> getDefault)
        {
            if (prev == null || next == null)
                return getDefault();

            VM_Slider prev_val = selector(prev);
            VM_Slider next_val = selector(next);

            return new VM_Slider()
            {
                PropType = prev_val.PropType,
                IsNameReadonly = true,
                Name = prev_val.Name,
                Color = Colors.Transparent,

                Minimum = prev_val.Minimum,
                Maximum = prev_val.Maximum,
                Value = Math1D.Avg(prev_val.Value, next_val.Value),
            };
        }
    }
}
