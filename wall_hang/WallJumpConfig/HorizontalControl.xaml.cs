using Game.Core;
using Game.Math_WPF.Mathematics;
using System;
using System.Linq;
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

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                RefreshHorizontalVisibility();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void UserControl_DataContextChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            try
            {
                RefreshHorizontalVisibility();

                var viewmodel = DataContext as VM_Horizontal;
                if (viewmodel == null)
                    return;

                viewmodel.ShowUpAlongAway = chkUpAlongAway.IsChecked.Value;
                viewmodel.ShowYaw = chkYaw.IsChecked.Value;
                viewmodel.ShowLook = chkLook.IsChecked.Value;
                viewmodel.ShowRelatch = chkRelatch.IsChecked.Value;
                viewmodel.ShowWallAttract = chkWallAttract.IsChecked.Value;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void HasHorizontal_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                RefreshHorizontalVisibility();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        /// <summary>
        /// This adds an angle after 0.  All other Add/Remove angles are handled in the AddRemoveAngleButtons control tied
        /// to each entry in VM_Horizontal.ExtraAngles
        /// </summary>
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

        private void LERP_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                //NOTE: None of these return cases should ever happen.  This is just written very defensively (maybe they should be exceptions?)

                var vm_horz = DataContext as VM_Horizontal;
                if (vm_horz == null)
                    return;

                var source = e.Source as FrameworkElement;
                if (source == null)
                    return;

                var vm_props = source.DataContext as VM_PropsAtAngle;       // this is the button that was clicked, but it still seems to have a reference to the viewmodel that was assigned to one of its ancestors
                if (vm_props == null)
                    return;

                int? index = Enumerable.Range(0, vm_horz.PropsAtAngles.Count).
                    FirstOrDefault(o => vm_horz.PropsAtAngles[o] == vm_props);

                if (index == null)
                    return;

                if (index.Value == 0 || index.Value == vm_horz.PropsAtAngles.Count - 1)
                    return;

                var prev = vm_horz.PropsAtAngles[index.Value - 1];
                var next = vm_horz.PropsAtAngles[index.Value + 1];

                double percent = GetAnglePercent(index.Value, vm_horz);

                vm_props.Percent_Up.Value = UtilityMath.GetScaledValue(prev.Percent_Up.Value, next.Percent_Up.Value, 0, 1, percent);
                vm_props.Percent_Along.Value = UtilityMath.GetScaledValue(prev.Percent_Along.Value, next.Percent_Along.Value, 0, 1, percent);
                vm_props.Percent_Away.Value = UtilityMath.GetScaledValue(prev.Percent_Away.Value, next.Percent_Away.Value, 0, 1, percent);
                vm_props.Percent_YawTurn.Value = UtilityMath.GetScaledValue(prev.Percent_YawTurn.Value, next.Percent_YawTurn.Value, 0, 1, percent);
                vm_props.Percent_Look.Value = UtilityMath.GetScaledValue(prev.Percent_Look.Value, next.Percent_Look.Value, 0, 1, percent);
                vm_props.Percent_LookStrength.Value = UtilityMath.GetScaledValue(prev.Percent_LookStrength.Value, next.Percent_LookStrength.Value, 0, 1, percent);
                vm_props.Percent_LatchAfterJump.Value = UtilityMath.GetScaledValue(prev.Percent_LatchAfterJump.Value, next.Percent_LatchAfterJump.Value, 0, 1, percent);
                vm_props.RelatchTime_Emoseconds.Value = UtilityMath.GetScaledValue(prev.RelatchTime_Emoseconds.Value, next.RelatchTime_Emoseconds.Value, 0, 1, percent);
                vm_props.WallAttract_DistanceMax.Value = UtilityMath.GetScaledValue(prev.WallAttract_DistanceMax.Value, next.WallAttract_DistanceMax.Value, 0, 1, percent);
                vm_props.WallAttract_Accel.Value = UtilityMath.GetScaledValue(prev.WallAttract_Accel.Value, next.WallAttract_Accel.Value, 0, 1, percent);
                vm_props.WallAttract_Pow.Value = UtilityMath.GetScaledValue(prev.WallAttract_Pow.Value, next.WallAttract_Pow.Value, 0, 1, percent);
                vm_props.WallAttract_Antigrav.Value = UtilityMath.GetScaledValue(prev.WallAttract_Antigrav.Value, next.WallAttract_Antigrav.Value, 0, 1, percent);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Filter_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                var viewmodel = DataContext as VM_Horizontal;
                if (viewmodel == null)
                    return;

                if (e.OriginalSource == chkUpAlongAway)
                    viewmodel.ShowUpAlongAway = chkUpAlongAway.IsChecked.Value;

                else if (e.OriginalSource == chkYaw)
                    viewmodel.ShowYaw = chkYaw.IsChecked.Value;

                else if (e.OriginalSource == chkLook)
                    viewmodel.ShowLook = chkLook.IsChecked.Value;

                else if (e.OriginalSource == chkRelatch)
                    viewmodel.ShowRelatch = chkRelatch.IsChecked.Value;

                else if (e.OriginalSource == chkWallAttract)
                    viewmodel.ShowWallAttract = chkWallAttract.IsChecked.Value;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void RefreshHorizontalVisibility()
        {
            if (DataContext is VM_Horizontal viewmodel)
            {
                panelHorizontal.Visibility = viewmodel.HasHorizontal ?
                    Visibility.Visible :
                    Visibility.Collapsed;
            }
            else
            {
                panelHorizontal.Visibility = Visibility.Visible;
            }
        }

        private static double GetAnglePercent(int index, VM_Horizontal vm_horz)
        {
            var angles = CurveBuilder.GetPoints_HorizontalProps_Degrees(vm_horz, o => 0);       // using this, because the sliders aren't reliable.  They may have a slider value less than a prev angle.  The curve builder has logic to ignore stuff like that

            double angle_diff = angles[index + 1].Key - angles[index - 1].Key;
            if (angle_diff.IsNearZero())
                return 0.5;     // they have their angle sliders messed up.  just go halfway between

            return (angles[index].Key - angles[index - 1].Key) / angle_diff;
        }
    }
}
