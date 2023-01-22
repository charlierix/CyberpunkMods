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
using WallJumpConfig.Models.misc;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class StickFigureVerticalControl : UserControl
    {
        #region Declaration Section

        private const string TITLE = "StickFigureVerticalControl";

        private List<ShownAngle> _listeningAngles = new List<ShownAngle>();

        #endregion

        #region Constructor

        public StickFigureVerticalControl()
        {
            InitializeComponent();
        }

        #endregion

        #region Public Properties

        private VM_StraightUp _viewmodel_straightup = null;
        public VM_StraightUp ViewModelStraightUp
        {
            get
            {
                return _viewmodel_straightup;
            }
            set
            {
                if(_viewmodel_straightup != null)
                    _viewmodel_straightup.HasStraightUpChanged -= HasStraightUpChanged;

                _viewmodel_straightup = value;

                if(_viewmodel_straightup != null)
                    _viewmodel_straightup.HasStraightUpChanged += HasStraightUpChanged;

                Redraw();
            }
        }

        #endregion

        #region Event Listeners

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

        private void HasStraightUpChanged(object sender, EventArgs e)
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

        private void Angle_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                RefreshAngles();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void Redraw()
        {
            ClearListeningAngles();
            canvas.Children.Clear();

            double width = canvas.ActualWidth;
            double height = canvas.ActualHeight;
            Point center = new Point(width / 2, height / 2);

            canvas.Children.Add(StickFigureUtil.GetGraphic_Stickman(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Vertical_Arrows_Three(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Vertical_Wall(center + new Vector(Math.Max(StickFigureUtil.VERT_RADIUS1, StickFigureUtil.VERT_RADIUS2) + 24, 0)));

            if (_viewmodel_straightup == null || !_viewmodel_straightup.HasStraightUp)
                return;

            var angles = new[]
            {
                _viewmodel_straightup.Angle_StraightUp,
                _viewmodel_straightup.Angle_Standard,
            };

            foreach (VM_Slider extra_angle in angles)
            {
                Color color = extra_angle.Color == Colors.Transparent ?
                    Colors.Gray :
                    extra_angle.Color;

                Brush brush = new SolidColorBrush(color);
                var right = StickFigureUtil.GetGraphic_RotateableLine(center, brush, StickFigureUtil.VERT_INNER2_RADIUS, StickFigureUtil.VERT_OUTER2_RADIUS, true);
                canvas.Children.Add(right.Line);

                extra_angle.ValueChanged += Angle_ValueChanged;
                _listeningAngles.Add(new ShownAngle()
                {
                    ViewModel = extra_angle,
                    Right = right,
                });
            }

            RefreshAngles();
        }
        private void RefreshAngles()
        {
            //NOTE: these are in order, so a later angle can't be greater than one that came before
            double prev_angle = 90;

            foreach (var angle in _listeningAngles)
            {
                double angle_cur = Math.Min(prev_angle, angle.ViewModel.Value);
                prev_angle = angle_cur;

                angle.Right.Rotate.Angle = 90 - angle_cur;
            }
        }

        private void ClearListeningAngles()
        {
            foreach (ShownAngle angle in _listeningAngles)
            {
                angle.ViewModel.ValueChanged -= Angle_ValueChanged;
            }

            _listeningAngles.Clear();
        }

        #endregion
    }
}
