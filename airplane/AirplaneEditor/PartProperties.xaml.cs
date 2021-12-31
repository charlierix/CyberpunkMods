using AirplaneEditor.Models_viewmodels;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
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
using System.Windows.Media.Effects;
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

        private readonly DropShadowEffect _errorEffect;

        private PlanePart_VM _part = null;

        private bool _isSettingValues = false;

        #endregion

        #region Constructor

        public PartProperties()
        {
            InitializeComponent();

            _errorEffect = new DropShadowEffect()
            {
                Color = UtilityWPF.ColorFromHex("C02020"),
                Direction = 0,
                ShadowDepth = 0,
                BlurRadius = 8,
                Opacity = .8,
            };
        }

        #endregion

        #region Event Listeners

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Blackboard.Instance.SelectedPartChanged += Blackboard_SelectedPartChanged;

                Blackboard_SelectedPartChanged(this, null);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Blackboard_SelectedPartChanged(object sender, PlanePart_VM e)
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
                txtPosX.Effect = null;
                txtPosY.Text = FormatNumber(_part.Position.Y);
                txtPosY.Effect = null;
                txtPosZ.Text = FormatNumber(_part.Position.Z);
                txtPosZ.Effect = null;

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

        private void txtName_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (_part == null || _isSettingValues)
                    return;

                _part.Name = txtName.Text;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void chkIsCenterline_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_part == null || _isSettingValues)
                    return;

                _part.IsCenterline = chkIsCenterline.IsChecked.Value;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Position_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (_part == null || _isSettingValues)
                    return;

                double? x = ParseTextboxNumber(txtPosX, _errorEffect);
                double? y = ParseTextboxNumber(txtPosY, _errorEffect);
                double? z = ParseTextboxNumber(txtPosZ, _errorEffect);

                if (x != null && y != null && z != null)
                    _part.Position = new Point3D(x.Value, y.Value, z.Value);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Rotation_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (_part == null || _isSettingValues)
                    return;

                double? x = ParseTextboxNumber(txtRotX, _errorEffect);
                double? y = ParseTextboxNumber(txtRotY, _errorEffect);
                double? z = ParseTextboxNumber(txtRotZ, _errorEffect);
                double? angle = ParseTextboxNumber(txtAngle, _errorEffect);

                if (x == null || y == null || z == null || angle == null)
                    return;

                if (angle.Value.IsNearZero() || (x.Value.IsNearZero() && y.Value.IsNearZero() && z.Value.IsNearZero()))
                    _part.Orientation = Quaternion.Identity;
                else
                    _part.Orientation = new Quaternion(new Vector3D(x.Value, y.Value, z.Value), angle.Value);
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

        private static double? ParseTextboxNumber(TextBox textbox, Effect error_effect)
        {
            if (double.TryParse(textbox.Text, out double value))
            {
                textbox.Effect = null;
                return value;
            }
            else
            {
                textbox.Effect = error_effect;
                return null;
            }
        }

        #endregion
    }
}
