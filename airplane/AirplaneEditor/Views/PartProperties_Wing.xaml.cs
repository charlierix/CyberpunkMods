using AirplaneEditor.Models_viewmodels;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace AirplaneEditor.Views
{
    public partial class PartProperties_Wing : UserControl
    {
        #region Declaration Section

        private const string TITLE = "PartProperties_Wing";

        private readonly PlanePart_Wing_VM _wing;

        private readonly DropShadowEffect _errorEffect = PartProperties.GetErrorEffect();

        private bool _isSettingValues = false;

        #endregion

        #region Constructor

        public PartProperties_Wing(PlanePart_Wing_VM wing)
        {
            InitializeComponent();

            _wing = wing;

            _isSettingValues = true;

            txtSpan.Text = PartProperties.FormatNumber(_wing.Span);
            txtChord.Text = PartProperties.FormatNumber(_wing.Chord);
            trkThickness.Value = _wing.Thickness;

            _isSettingValues = false;
        }

        #endregion

        #region Event Listeners

        private void txtSpan_MouseEnter(object sender, MouseEventArgs e)
        {
            try
            {
                line_span.Visibility = Visibility.Visible;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void txtSpan_MouseLeave(object sender, MouseEventArgs e)
        {
            try
            {
                line_span.Visibility = Visibility.Collapsed;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtChord_MouseEnter(object sender, MouseEventArgs e)
        {
            try
            {
                line_chord.Visibility = Visibility.Visible;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void txtChord_MouseLeave(object sender, MouseEventArgs e)
        {
            try
            {
                line_chord.Visibility = Visibility.Collapsed;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }

        }

        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (_wing == null || _isSettingValues)
                    return;

                double? span = PartProperties.ParseTextboxNumber(txtSpan, _errorEffect);
                if (span != null)
                    _wing.Span = span.Value;

                double? chord = PartProperties.ParseTextboxNumber(txtChord, _errorEffect);
                if (chord != null)
                    _wing.Chord = chord.Value;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void trkThickness_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try
            {
                if (_wing == null || _isSettingValues)
                    return;

                double? span = PartProperties.ParseTextboxNumber(txtSpan, _errorEffect);
                if (span != null)
                    _wing.Span = span.Value;

                double? chord = PartProperties.ParseTextboxNumber(txtChord, _errorEffect);
                if (chord != null)
                    _wing.Chord = chord.Value;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion
    }
}
