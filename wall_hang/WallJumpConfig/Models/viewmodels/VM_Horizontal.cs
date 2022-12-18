using System.Collections.ObjectModel;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_Horizontal
    {
        public VM_Horizontal()
        {
            ExtraAngles = new ObservableCollection<VM_Slider>();
        }

        public ObservableCollection<VM_Slider> ExtraAngles { get; private set; }

        public VM_Slider Speed_FullStrength { get; set; }
        public VM_Slider Speed_ZeroStrength { get; set; }
    }
}
