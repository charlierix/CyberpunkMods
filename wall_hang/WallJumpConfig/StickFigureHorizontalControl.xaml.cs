using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using WallJumpConfig.Models.misc;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class StickFigureHorizontalControl : UserControl
    {
        #region Declaration Section

        private const string TITLE = "StickFigureHorizontalControl";

        private List<ShownAngle> _listeningAngles = new List<ShownAngle>();

        #endregion

        #region Constructor

        public StickFigureHorizontalControl()
        {
            InitializeComponent();
        }

        #endregion

        #region Public Properties

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

        private void ExtraAngles_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
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

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Arrows_Four(center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Wall(center + new Vector(0, -(Math.Max(StickFigureUtil.HORZ_RADIUS1, StickFigureUtil.HORZ_RADIUS2) + 24))));

            if (_viewmodel_horizontal == null)
                return;

            //TODO: add 0 and 180, but only show when they have mouse over the corresponding props expander

            foreach (VM_Slider extra_angle in _viewmodel_horizontal.ExtraAngles)
            {
                Color color = extra_angle.Color == Colors.Transparent ?
                    Colors.Gray :
                    extra_angle.Color;

                Brush brush = new SolidColorBrush(color);
                var left = StickFigureUtil.GetGraphic_RotateableLine(center, brush, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true);
                var right = StickFigureUtil.GetGraphic_RotateableLine(center, brush, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true);
                canvas.Children.Add(left.Line);
                canvas.Children.Add(right.Line);

                extra_angle.ValueChanged += Angle_ValueChanged;
                _listeningAngles.Add(new ShownAngle()
                {
                    ViewModel = extra_angle,
                    Left = left,
                    Right = right,
                });
            }

            RefreshAngles();
        }
        private void RefreshAngles()
        {
            //NOTE: these are in order, so a later angle can't be less than one that came before
            double prev_angle = 0;

            foreach(var angle in _listeningAngles)
            {
                double angle_cur = Math.Max(prev_angle, angle.ViewModel.Value);
                prev_angle = angle_cur;

                angle.Left.Rotate.Angle = angle_cur;
                angle.Right.Rotate.Angle = -angle_cur;
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
