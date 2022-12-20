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

namespace WallJumpConfig
{
    public partial class StickFigureVerticalControl : UserControl
    {
        private const string TITLE = "StickFigureVerticalControl";

        public StickFigureVerticalControl()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
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

        private void UserControl_SizeChanged(object sender, SizeChangedEventArgs e)
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

        private void Redraw()
        {
            canvas.Children.Clear();

            double width = canvas.ActualWidth;
            double height = canvas.ActualHeight;
            Point center = new Point(width / 2, height / 2);

            canvas.Children.Add(StickFigureUtil.GetGraphic_Stickman(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Vertical_Arrows_Three(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Vertical_Wall(center + new Vector(Math.Max(StickFigureUtil.VERT_RADIUS1, StickFigureUtil.VERT_RADIUS2) + 24, 0)));
        }
    }
}
