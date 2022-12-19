using Game.Math_WPF.WPF;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Media;
using WallJumpConfig.Models.wpf;

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

            //TODO: this should interpelate values between the items before and after it

            Color[] existing_colors = ExtraAngles.
                Where(o => o.Color != Colors.Transparent).
                Select(o => o.Color).
                ToArray();

            Color item_color = UtilityWPF.GetRandomColors(1, 110, 170, existing_colors)[0];     // this function treats colors like evenly distributed points in a cube, so it will choose a color that is as far away as possible from existing colors

            var brushes = VM_PropsAtAngle.GetBrushes(item_color);

            var angle = new VM_Slider()
            {
                PropType = SliderPropType.Angle,
                Name = $"Extra Angle {ExtraAngles.Count + 1}",
                Minimum = 0,
                Maximum = 180,
                Value = 90,
                Color = item_color,
                IsNameReadonly = false,
            };

            var props = new VM_PropsAtAngle()
            {
                Name = angle.Name,
                HeaderBorder = brushes.border,
                HeaderBackground = brushes.background,
                HeaderDropShadow = brushes.dropshadow,


                //TODO: helper method that returns a vm_slider that is the average of two
                //Percent_Along = 0.5,


            };

            AddExtraAngle(angle, props);
        }
        public void AddExtraAngle(VM_Slider angle, VM_PropsAtAngle props)
        {
            angle.NameChanged += (s, e) => { props.Name = angle.Name; };        // they can only change the name from the angle control

            ExtraAngles.Add(angle);
            PropsAtAngles.Add(props);
        }

        public void RemoveExtraAngle(int index)
        {
            ExtraAngles.RemoveAt(index);
            PropsAtAngles.RemoveAt(index);
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

            for (int i = 0; i < model.Degrees_Extra.Length; i++)
            {
                var angle = VM_Slider.FromModel(model.Degrees_Extra[i], true);
                var props = VM_PropsAtAngle.FromModel(model.Props_Extra[i], model.Degrees_Extra[i].Name, model.Degrees_Extra[i].Color);

                retVal.AddExtraAngle(angle, props);
            }

            return retVal;
        }
    }
}
