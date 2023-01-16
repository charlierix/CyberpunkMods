using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_StraightUp
    {
        public bool HasStraightUp { get; set; }

        public VM_Slider Angle_StraightUp { get; set; }
        public VM_Slider Angle_Standard { get; set; }

        public VM_Slider Speed_FullStrength { get; set; }
        public VM_Slider Speed_ZeroStrength { get; set; }

        public VM_Slider Strength { get; set; }

        public bool LatchAfterJump { get; set; }
        public VM_Slider WallAttract_DistanceMax { get; set; }
        public VM_Slider WallAttract_Accel { get; set; }
        public VM_Slider WallAttract_Pow { get; set; }
        public VM_Slider WallAttract_Antigrav { get; set; }

        // ------------- Helper Methods -------------
        public static VM_StraightUp FromModel(SaveWPF_Vertical_StraightUp model)
        {
            var retVal = new VM_StraightUp()
            {
                HasStraightUp = model != null,
            };

            if (model != null)
            {
                retVal.Angle_StraightUp = VM_Slider.FromModel(SliderPropType.Angle, "Angle - straight up", 0, 90, 60, false, "5AA4E0");
                retVal.Angle_Standard = VM_Slider.FromModel(SliderPropType.Angle, "Angle - standard", 0, 90, 40, false, "30A030");

                retVal.Speed_FullStrength = VM_Slider.FromModel(SliderPropType.Other, "Speed - full strength", 0, 18, model.Speed_FullStrength, false);
                retVal.Speed_ZeroStrength = VM_Slider.FromModel(SliderPropType.Other, "Speed - zero strength", 0, 18, model.Speed_ZeroStrength, false);

                retVal.Strength = VM_Slider.FromModel(SliderPropType.Other, "Jump Strength", 0, 24, model.Strength, false);

                retVal.LatchAfterJump = false;
                retVal.WallAttract_DistanceMax = VM_PropsAtAngle.Get_WallAttract_DistanceMax(model.WallAttract_DistanceMax);
                retVal.WallAttract_Accel = VM_PropsAtAngle.Get_WallAttract_Accel(model.WallAttract_Accel);
                retVal.WallAttract_Pow = VM_PropsAtAngle.Get_WallAttract_Pow(model.WallAttract_Pow);
                retVal.WallAttract_Antigrav = VM_PropsAtAngle.Get_WallAttract_Antigrav(model.WallAttract_Antigrav);
            }

            return retVal;
        }
    }
}
