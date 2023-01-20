using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
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
    public partial class AddRemoveAngleButtons : UserControl
    {
        private const string TITLE = "AddRemoveAngleButtons";

        public AddRemoveAngleButtons()
        {
            InitializeComponent();
        }

        private void Remove_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var vm_slider = DataContext as VM_Slider;
                if (vm_slider == null)
                    return;

                var vm_horz = vm_slider.Parent as VM_Horizontal;
                if (vm_horz == null)
                    return;

                int index = vm_horz.ExtraAngles.IndexOf(vm_slider);
                if (index < 0)
                    return;

                vm_horz.ExtraAngles.RemoveAt(index);
                vm_horz.PropsAtAngles.RemoveAt(index + 1);        // props at angles always has one for 0 degrees and one for 180.  Extras sit between
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Add_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var vm_slider = DataContext as VM_Slider;
                if (vm_slider == null)
                    return;

                var vm_horz = vm_slider.Parent as VM_Horizontal;
                if (vm_horz == null)
                    return;

                vm_horz.AddExtraAngle(vm_slider);      // this takes care of viewmodel.ExtraAngles and viewmodel.PropsAtAngles
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
