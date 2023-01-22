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
    public partial class PowerGraphControl : UserControl
    {
        private const string TITLE = "PowerGraphControl";

        public VM_Slider PowerSlider
        {
            get { return (VM_Slider)GetValue(PowerSliderProperty); }
            set { SetValue(PowerSliderProperty, value); }
        }
        public static readonly DependencyProperty PowerSliderProperty = DependencyProperty.Register("PowerSlider", typeof(VM_Slider), typeof(PowerGraphControl), new PropertyMetadata(null));

        public PowerGraphControl()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Redraw_StickFigure();
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
                if (PowerSlider != null)
                    PowerSlider.ValueChanged -= PowerSlider_ValueChanged;

                PowerSlider = null;

                var viewmodel = DataContext as VM_PropsAtAngle;
                if (viewmodel == null)
                {
                    Redraw_Graph();
                    return;
                }

                PowerSlider = viewmodel.WallAttract_Pow;

                PowerSlider.ValueChanged += PowerSlider_ValueChanged;

                Redraw_Graph();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PowerSlider_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                Redraw_Graph();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void canvas_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            try
            {
                Redraw_StickFigure();
                Redraw_Graph();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Redraw_StickFigure()
        {
            var figure = StickFigureUtil.GetGraphic_Stickman(new Point(-40, 0));
            figure.HorizontalAlignment = HorizontalAlignment.Center;
            figure.VerticalAlignment = VerticalAlignment.Center;

            figure.LayoutTransform = new ScaleTransform()
            {
                ScaleX = 0.66,
                ScaleY = 0.66,
            };


            stickfigure.Content = figure;



        }

        private void Redraw_Graph()
        {
            canvas.Children.Clear();

            if (PowerSlider == null)
                return;

            double pow = PowerSlider.Value;

            double width = canvas.ActualWidth;
            double height = canvas.ActualHeight;

            int count = 144;

            double x1 = -1;
            double y1 = -1;

            for (int i = 0; i < count; i++)
            {
                double x2 = (double)i / (double)(count - 1);
                double y2 = 1d - Math.Pow(x2, pow);

                if (i > 0)
                {
                    canvas.Children.Add(new Line()
                    {
                        X1 = x1 * width,
                        Y1 = height - (y1 * height),        // 0 is at the top, but it should drawn at the bottom
                        X2 = x2 * width,
                        Y2 = height - (y2 * height),
                        Stroke = Brushes.Black,
                        StrokeThickness = 1,
                    });
                }

                x1 = x2;
                y1 = y2;
            }
        }
    }
}
