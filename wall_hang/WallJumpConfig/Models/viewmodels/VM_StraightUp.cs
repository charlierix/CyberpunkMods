using System;
using System.Windows;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_StraightUp : DependencyObject
    {
        // ------------- HasHorizontal -------------

        public bool HasStraightUp
        {
            get { return (bool)GetValue(HasStraightUpProperty); }
            set { SetValue(HasStraightUpProperty, value); }
        }
        public static readonly DependencyProperty HasStraightUpProperty = DependencyProperty.Register("HasStraightUp", typeof(bool), typeof(VM_StraightUp), new PropertyMetadata(false, OnHasStraightUpChanged));

        private static void OnHasStraightUpChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            VM_StraightUp parent = (VM_StraightUp)d;

            parent.HasStraightUpChanged?.Invoke(parent, new EventArgs());
        }

        public event EventHandler HasStraightUpChanged = null;

        // ------------- Other Props -------------

        public VM_Slider Angle_StraightUp { get; set; }
        public VM_Slider Angle_Standard { get; set; }

        public VM_Slider Speed_FullStrength { get; set; }
        public VM_Slider Speed_ZeroStrength { get; set; }

        public VM_Slider Strength { get; set; }

        public bool LatchAfterJump { get; set; }
        public VM_Slider RelatchTime_Emoseconds { get; set; }

        public VM_Slider WallAttract_DistanceMax { get; set; }
        public VM_Slider WallAttract_Accel { get; set; }
        public VM_Slider WallAttract_Pow { get; set; }
        public VM_Slider WallAttract_Antigrav { get; set; }

        // ------------- Helper Methods -------------

        public static VM_StraightUp FromModel(SaveWPF_Vertical_StraightUp model)
        {
            var retVal = new VM_StraightUp()
            {
                HasStraightUp = model.HasStraightUp,
            };

            if (model == null)
                throw new ArgumentNullException("model should never be null");

            retVal.Angle_StraightUp = VM_Slider.FromModel(retVal, SliderPropType.Angle, "Angle - straight up", HelpMessages.AngleStraightUp, 0, 90, model.Degrees_StraightUp, false, "5AA4E0");
            retVal.Angle_Standard = VM_Slider.FromModel(retVal, SliderPropType.Angle, "Angle - standard", HelpMessages.AngleStandard, 0, 90, model.Degrees_Standard, false, "30A030");

            retVal.Speed_FullStrength = VM_Slider.FromModel(retVal, SliderPropType.Other_Small, "Speed - full strength", HelpMessages.Speed_FullStrength, 0, 18, model.Speed_FullStrength, false);
            retVal.Speed_ZeroStrength = VM_Slider.FromModel(retVal, SliderPropType.Other_Small, "Speed - zero strength", HelpMessages.Speed_ZeroStrength, 0, 18, model.Speed_ZeroStrength, false);

            retVal.Strength = VM_Slider.FromModel(retVal, SliderPropType.Other_Small, "Jump Strength", HelpMessages.JumpStrength, 0, 24, model.Strength, false);

            retVal.LatchAfterJump = model.LatchAfterJump;
            retVal.RelatchTime_Emoseconds = VM_PropsAtAngle.Get_RelatchTime_Emoseconds(retVal, model.RelatchTime_Emoseconds);

            retVal.WallAttract_DistanceMax = VM_PropsAtAngle.Get_WallAttract_DistanceMax(retVal, model.WallAttract_DistanceMax);
            retVal.WallAttract_Accel = VM_PropsAtAngle.Get_WallAttract_Accel(retVal, model.WallAttract_Accel);
            retVal.WallAttract_Pow = VM_PropsAtAngle.Get_WallAttract_Pow(retVal, model.WallAttract_Pow);
            retVal.WallAttract_Antigrav = VM_PropsAtAngle.Get_WallAttract_Antigrav(retVal, model.WallAttract_Antigrav);

            return retVal;
        }
    }
}
