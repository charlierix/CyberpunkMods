using AirplaneEditor.Models_viewmodels;
using Game.Math_WPF.Mathematics;
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
using System.Windows.Media.Media3D;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace AirplaneEditor
{
    public partial class PartProperties : UserControl
    {
        #region Declaration Section

        private const string TITLE = "Part Properties";

        private PlanePart _part = null;

        private bool _isSettingValues = false;

        #endregion

        #region Constructor

        public PartProperties()
        {
            InitializeComponent();
        }

        #endregion

        #region Event Listeners

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Blackboard.Instance.SelectedPartChanged += Blackboard_SelectedPartChanged;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Blackboard_SelectedPartChanged(object sender, PlanePart e)
        {
            try
            {
                _part = e;

                if (_part == null)
                {
                    panel_base.Visibility = Visibility.Collapsed;
                    return;
                }

                panel_base.Visibility = Visibility.Visible;

                _isSettingValues = true;

                lblPartType.Text = _part.PartType.ToString();
                txtName.Text = _part.Name;

                chkIsCenterline.IsChecked = _part.IsCenterline;

                txtPosX.Text = FormatNumber(_part.Position.X);
                txtPosY.Text = FormatNumber(_part.Position.Y);
                txtPosZ.Text = FormatNumber(_part.Position.Z);

                if (_part.Orientation.IsIdentity)
                {
                    txtRotX.Text = "0";
                    txtRotY.Text = "0";
                    txtRotZ.Text = "0";
                    txtAngle.Text = "0";
                }
                else
                {
                    Vector3D axis = _part.Orientation.Axis;
                    txtRotX.Text = FormatNumber(axis.X);
                    txtRotY.Text = FormatNumber(axis.Y);
                    txtRotZ.Text = FormatNumber(axis.Z);

                    txtAngle.Text = FormatNumber(_part.Orientation.Angle);
                }

                _isSettingValues = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private static string FormatNumber(double value)
        {
            return Math.Round(value, 2).ToString();
        }

        #endregion
    }
}
