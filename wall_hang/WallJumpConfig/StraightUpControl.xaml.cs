using System;
using System.Windows;
using System.Windows.Controls;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class StraightUpControl : UserControl
    {
        private const string TITLE = "StraightUpControl";

        public StraightUpControl()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                RefreshDetailVisibility();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void UserControl_DataContextChanged(object sender, System.Windows.DependencyPropertyChangedEventArgs e)
        {
            try
            {
                RefreshDetailVisibility();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void HasStraightUp_Checked(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                RefreshDetailVisibility();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void RefreshDetailVisibility()
        {
            if(DataContext is VM_StraightUp viewmodel)
            {
                panelDetails.Visibility = viewmodel.HasStraightUp ?
                    Visibility.Visible :
                    Visibility.Collapsed;
            }
            else
            {
                panelDetails.Visibility = Visibility.Visible;
            }
        }
    }
}
