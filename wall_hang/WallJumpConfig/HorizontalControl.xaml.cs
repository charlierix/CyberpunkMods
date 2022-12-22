using Game.Core;
using System;
using System.Windows;
using System.Windows.Controls;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class HorizontalControl : UserControl
    {
        private const string TITLE = "HorizontalControl";

        public HorizontalControl()
        {
            InitializeComponent();
        }

        private void RemoveAngle_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                var viewmodel = DataContext as VM_Horizontal;
                if(viewmodel == null)
                    return;

                if (viewmodel.ExtraAngles.Count == 0)
                    return;

                viewmodel.ExtraAngles.RemoveAt(viewmodel.ExtraAngles.Count - 1);
                viewmodel.PropsAtAngles.RemoveAt(viewmodel.PropsAtAngles.Count - 2);        // props at angles always has one for 0 degrees and one for 180.  Extras sit between
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void AddAngle_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                var viewmodel = DataContext as VM_Horizontal;
                if (viewmodel == null)
                    return;

                viewmodel.AddExtraAngle();      // this takes care of viewmodel.ExtraAngles and viewmodel.PropsAtAngles
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
