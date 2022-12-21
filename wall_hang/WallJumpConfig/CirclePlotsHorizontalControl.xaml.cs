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
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using WallJumpConfig.Models.savewpf;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class CirclePlotsHorizontalControl : UserControl
    {
        private const double RADIUS = 30;

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
                //if (_viewmodel_horizontal != null)
                //    _viewmodel_horizontal.ExtraAngles.CollectionChanged -= ExtraAngles_CollectionChanged;

                _viewmodel_horizontal = value;

                //_viewmodel_horizontal.ExtraAngles.CollectionChanged += ExtraAngles_CollectionChanged;
                Redraw();
            }
        }

        private void Redraw()
        {
            panel.Children.Clear();

            if (_viewmodel_horizontal == null)
                return;

            panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Percent Up", o => o.Percent_Up));
            panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Percent Along", o => o.Percent_Along));
            panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Percent Away", o => o.Percent_Away));
            panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Yaw Turn Percent", o => o.Percent_YawTurn));
            panel.Children.Add(BuildPlot(_viewmodel_horizontal, "Percent Look", o => o.Percent_Look));
        }

        private static FrameworkElement BuildPlot(VM_Horizontal horizontal, string title, Func<VM_PropsAtAngle, VM_Slider> getSlider)
        {
            var retVal = new StackPanel()
            {
                Margin = new Thickness(0, 4, 0, 4),
            };

            AnimationCurve curve = CurveBuilder.ToAnimationCurve(CurveBuilder.GetPoints_HorizontalProps_Degrees(horizontal, o => getSlider(o).Value));

            double minimum = getSlider(horizontal.PropsAtAngles[0]).Minimum;
            double maximum = getSlider(horizontal.PropsAtAngles[0]).Maximum;

            retVal.Children.Add(DrawPlot(minimum, maximum, curve));

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
        private static FrameworkElement DrawPlot(double minimum, double maximum, AnimationCurve curve)
        {
            var values = new List<(double angle, double value, double x, double y)>();

            for (int angle = 0; angle <= 180; angle += 5)
            {
                double value = curve.Evaluate(angle);
                double x = RADIUS * Math.Cos(Math1D.DegreesToRadians(angle + 90));      // 0 should be +y
                double y = RADIUS * Math.Sin(Math1D.DegreesToRadians(angle + 90));
                values.Add((angle, value, x, y));
            }

            var retVal = new Canvas()
            {
                Width = RADIUS * 2,
                Height = RADIUS * 2,
            };

            for (int i = 0; i < values.Count - 1; i++)
            {
                double percent = UtilityMath.GetScaledValue(0, 1, minimum, maximum, (values[i].value + values[i + 1].value) / 2);
                Brush brush = new SolidColorBrush(UtilityWPF.AlphaBlend(Colors.Black, Color.FromArgb(0, 255, 255, 255), percent));
                double thickness = UtilityMath.GetScaledValue(0.25, 4, 0, 1, percent);

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
    }
}
