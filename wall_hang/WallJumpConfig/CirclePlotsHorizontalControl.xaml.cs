using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class CirclePlotsHorizontalControl : UserControl
    {
        private const double RADIUS = 30;
        private const string TITLE = "CirclePlotsHorizontalControl";

        private VM_Horizontal _listeningShow = null;
        private List<VM_Slider> _listeningProps = new List<VM_Slider>();

        public CirclePlotsHorizontalControl()
        {
            InitializeComponent();
        }

        private VM_Horizontal _viewmodel_horizontal = null;
        public VM_Horizontal ViewModelHorizontal
        {
            get
            {
                return _viewmodel_horizontal;
            }
            set
            {
                if (_viewmodel_horizontal != null)
                {
                    _viewmodel_horizontal.ExtraAngles.CollectionChanged -= ExtraAngles_CollectionChanged;
                    _viewmodel_horizontal.PropsAtAngles.CollectionChanged -= ExtraAngles_CollectionChanged;
                }

                _viewmodel_horizontal = value;

                _viewmodel_horizontal.ExtraAngles.CollectionChanged += ExtraAngles_CollectionChanged;
                _viewmodel_horizontal.PropsAtAngles.CollectionChanged += ExtraAngles_CollectionChanged;
                ReHookPropEvents();
                Redraw();
            }
        }

        private void ExtraAngles_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            try
            {
                ReHookPropEvents();
                Redraw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PropValue_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                Redraw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Horizontal_ShowFilterChanged(object sender, EventArgs e)
        {
            try
            {
                Redraw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ReHookPropEvents()
        {
            // Clear
            if (_listeningShow != null)
                _listeningShow.ShowFilterChanged -= Horizontal_ShowFilterChanged;
            _listeningShow = null;

            foreach (VM_Slider prop in _listeningProps)
            {
                prop.ValueChanged -= PropValue_ValueChanged;
            }
            _listeningProps.Clear();

            if (_viewmodel_horizontal == null)
                return;

            // Visibility
            _viewmodel_horizontal.ShowFilterChanged += Horizontal_ShowFilterChanged;
            _listeningShow = _viewmodel_horizontal;

            // Extra Angles
            foreach (VM_Slider angle in _viewmodel_horizontal.ExtraAngles)
            {
                angle.ValueChanged += PropValue_ValueChanged;
                _listeningProps.Add(angle);
            }

            // Values for Props
            var props = _viewmodel_horizontal.PropsAtAngles.
                SelectMany(o => new[]
                {
                    o.Percent_Up,
                    o.Percent_Along,
                    o.Percent_Away,
                    o.Percent_YawTurn,
                    o.Percent_Look,
                    o.Percent_LookStrength,
                    o.Percent_LatchAfterJump,
                    o.RelatchTime_Emoseconds,
                    o.WallAttract_DistanceMax,
                    o.WallAttract_Accel,
                    o.WallAttract_Pow,
                    o.WallAttract_Antigrav,
                });

            foreach (VM_Slider prop in props)
            {
                prop.ValueChanged += PropValue_ValueChanged;
                _listeningProps.Add(prop);
            }
        }

        private void Redraw()
        {
            panel.Children.Clear();

            if (_viewmodel_horizontal == null)
                return;

            if (_viewmodel_horizontal.HasHorizontal && _viewmodel_horizontal.ShowUpAlongAway)
            {
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Up %", o => o.Percent_Up));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Along %", o => o.Percent_Along));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Away %", o => o.Percent_Away));
            }

            if (_viewmodel_horizontal.HasHorizontal && _viewmodel_horizontal.ShowLook)
            {
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Look %", o => o.Percent_Look));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Look Strength %", o => o.Percent_LookStrength));
            }

            if (_viewmodel_horizontal.HasHorizontal && _viewmodel_horizontal.ShowYaw)
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Yaw Turn %", o => o.Percent_YawTurn));

            if (_viewmodel_horizontal.HasHorizontal && _viewmodel_horizontal.ShowRelatch)
            {
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Latch %", o => o.Percent_LatchAfterJump, true));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Relatch Time", o => o.RelatchTime_Emoseconds));
            }

            if (_viewmodel_horizontal.HasHorizontal && _viewmodel_horizontal.ShowWallAttract)
            {
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "WallAttract Dist", o => o.WallAttract_DistanceMax));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "WallAttract Accel", o => o.WallAttract_Accel));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "WallAttract Pos", o => o.WallAttract_Pow));
                panel.Children.Add(BuildPlot(_viewmodel_horizontal, "WallAttract Antigrav", o => o.WallAttract_Antigrav));
            }
        }

        private static FrameworkElement BuildPlot(VM_Horizontal horizontal, string title, Func<VM_PropsAtAngle, VM_Slider> getSlider, bool isThresholdPlot = false)
        {
            var retVal = new StackPanel()
            {
                Margin = new Thickness(0, 4, 0, 4),
            };

            AnimationCurve curve = CurveBuilder.ToAnimationCurve(CurveBuilder.GetPoints_HorizontalProps_Degrees(horizontal, o => getSlider(o).Value));

            double minimum = getSlider(horizontal.PropsAtAngles[0]).Minimum;
            double maximum = getSlider(horizontal.PropsAtAngles[0]).Maximum;

            retVal.Children.Add(DrawPlot(minimum, maximum, curve, isThresholdPlot));

            retVal.Children.Add(new TextBlock()
            {
                Text = title,
                FontSize = 10,
                Foreground = UtilityWPF.BrushFromHex("999"),
                HorizontalAlignment = HorizontalAlignment.Center,
                Margin = new Thickness(0, 4, 0, 0),
            });

            return retVal;
        }
        private static FrameworkElement DrawPlot(double minimum, double maximum, AnimationCurve curve, bool isThresholdPlot)
        {
            var values = new List<(double angle, double value, double x, double y)>();

            for (int angle = 0; angle <= 180; angle += 5)
            {
                double value = curve.Evaluate(angle);
                double x = RADIUS * Math.Cos(Math1D.DegreesToRadians(angle + 90));      // 0 should be +y
                double y = RADIUS * Math.Sin(Math1D.DegreesToRadians(angle + 90));

                if (isThresholdPlot)
                    value = value >= Math1D.Avg(minimum, maximum) ? maximum : minimum;

                values.Add((angle, value, x, y));
            }

            var retVal = new Canvas()
            {
                Width = RADIUS * 2,
                Height = RADIUS * 2,
            };

            for (int i = 0; i < values.Count - 1; i++)
            {
                var (brush, thickness) = GetPlotPointValues(minimum, maximum, (values[i].value + values[i + 1].value) / 2);

                retVal.Children.Add(new Line()
                {
                    X1 = RADIUS + values[i].x,
                    Y1 = RADIUS - values[i].y,
                    X2 = RADIUS + values[i + 1].x,
                    Y2 = RADIUS - values[i + 1].y,
                    Stroke = brush,
                    StrokeThickness = thickness,
                });

                retVal.Children.Add(new Line()
                {
                    X1 = RADIUS - values[i].x,
                    Y1 = RADIUS - values[i].y,
                    X2 = RADIUS - values[i + 1].x,
                    Y2 = RADIUS - values[i + 1].y,
                    Stroke = brush,
                    StrokeThickness = thickness,
                });
            }

            return retVal;
        }

        private static (Brush brush, double thickness) GetPlotPointValues(double minimum, double maximum, double value)
        {
            Color max_color = Colors.Black;

            if (minimum < 0)
            {
                if (value < 0)
                {
                    maximum = minimum;        // -1 to 0 instead of -1 to 1
                    minimum = 0;
                    max_color = Colors.Maroon;
                }
                else
                {
                    minimum = 0;        // 0 to 1 instead of -1 to 1
                    max_color = Colors.Navy;
                }
            }

            double percent = UtilityMath.GetScaledValue(0, 1, minimum, maximum, value);

            Brush brush = new SolidColorBrush(UtilityWPF.AlphaBlend(max_color, Color.FromArgb(0, 255, 255, 255), percent));
            double thickness = UtilityMath.GetScaledValue(0.25, 4, 0, 1, percent);

            return (brush, thickness);
        }
    }
}
