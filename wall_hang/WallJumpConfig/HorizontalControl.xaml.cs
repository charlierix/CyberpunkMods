using System.Windows.Controls;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class HorizontalControl : UserControl
    {
        public HorizontalControl()
        {
            InitializeComponent();
        }

        private VM_Horizontal _viewmodel = null;
        public VM_Horizontal ViewModel
        {
            get => _viewmodel;
            set
            {
                _viewmodel = value;
                panelAngles.ItemsSource = _viewmodel?.ExtraAngles;

                panelPropsAtAngle.ItemsSource = _viewmodel?.PropsAtAngles;

                speedFullStrength.DataContext = _viewmodel?.Speed_FullStrength;
                speedZeroStrength.DataContext = _viewmodel?.Speed_ZeroStrength;
            }
        }
    }
}
