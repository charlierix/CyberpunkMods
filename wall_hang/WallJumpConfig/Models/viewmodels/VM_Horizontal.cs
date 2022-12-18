using System.Collections.ObjectModel;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_Horizontal
    {
        public VM_Horizontal()
        {
            ExtraAngles = new ObservableCollection<VM_Slider>();
        }

        public VM_Slider DirectFaceWall { get; set; }
        public ObservableCollection<VM_Slider> ExtraAngles { get; private set; }
        public VM_Slider DirectAway { get; set; }
    }
}
