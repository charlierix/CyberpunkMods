using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
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
            }
        }
    }
}
