using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Reflection.Metadata;
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
using WallJumpConfig.Models.misc;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public partial class YawTurnVisualControl : UserControl
    {
        #region record: RotateLines

        private record RotateLines
        {
            public RotatableLine Input_Left { get; init; }
            public RotatableLine Input_Right { get; init; }
            public RotatableLine Output_Left { get; init; }
            public RotatableLine Output_Right { get; init; }
        }

        #endregion

        #region Declaration Section

        private const string TITLE = "YawTurnVisualControl";

        private RotateLines _lines = null;

        private List<VM_Slider> _listening = new List<VM_Slider>();

        private AnimationCurve _yawmap = null;

        private Point _center = new Point(0, 0);
        private Point _mousepoint = new Point(0, 0);

        #endregion

        #region Constructor

        public YawTurnVisualControl()
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
        private void AngleYaw_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                RefreshYaw();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), TITLE, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Border_MouseMove(object sender, MouseEventArgs e)
        {
            _mousepoint = e.GetPosition(canvas);
            RefreshLines();
        }

        #endregion

        #region Private Methods

        private void Redraw()
        {
            ClearListeningAngles();
            _lines = null;
            canvas.Children.Clear();

            double width = canvas.ActualWidth;
            double height = canvas.ActualHeight;

            if (width.IsNearZero() || height.IsNearZero())
                return;

            _center = new Point(width / 2, height / 2);

            canvas.Children.Add(StickFigureUtil.GetGraphic_Stickman(_center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Arrows_Four(_center));

            canvas.Children.Add(StickFigureUtil.GetGraphic_Horizontal_Wall(_center + new Vector(0, -(Math.Max(StickFigureUtil.HORZ_RADIUS1, StickFigureUtil.HORZ_RADIUS2) + 24))));

            if (_viewmodel_horizontal == null)
                return;

            HookListeningAngles();

            Brush brush_input = UtilityWPF.BrushFromHex("DB6D51");
            Brush brush_output = UtilityWPF.BrushFromHex("84B543");

            _lines = new RotateLines()
            {
                Input_Left = StickFigureUtil.GetGraphic_RotateableLine(_center, brush_input, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true),
                Input_Right = StickFigureUtil.GetGraphic_RotateableLine(_center, brush_input, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true),
                Output_Left = StickFigureUtil.GetGraphic_RotateableLine(_center, brush_output, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true),
                Output_Right = StickFigureUtil.GetGraphic_RotateableLine(_center, brush_output, StickFigureUtil.HORZ_INNER2_RADIUS, StickFigureUtil.HORZ_OUTER2_RADIUS, true),
            };

            canvas.Children.Add(_lines.Output_Left.Line);
            canvas.Children.Add(_lines.Output_Right.Line);
            canvas.Children.Add(_lines.Input_Left.Line);
            canvas.Children.Add(_lines.Input_Right.Line);

            RefreshYaw();
        }

        private void ClearListeningAngles()
        {
            foreach (VM_Slider slider in _listening)
            {
                slider.ValueChanged -= AngleYaw_ValueChanged;
            }

            _listening.Clear();
        }
        private void HookListeningAngles()
        {
            foreach(var angle in _viewmodel_horizontal.ExtraAngles)
            {
                angle.ValueChanged += AngleYaw_ValueChanged;
                _listening.Add(angle);
            }

            foreach(var prop in _viewmodel_horizontal.PropsAtAngles)
            {
                prop.Percent_YawTurn.ValueChanged += AngleYaw_ValueChanged;
                _listening.Add(prop.Percent_YawTurn);
            }
        }

        private void RefreshYaw()
        {
            var percents = CurveBuilder.GetPoints_HorizontalProps_Degrees(_viewmodel_horizontal, o => o.Percent_YawTurn.Value);
            var angles = CurveBuilder.BuildYawTurn_Degrees(percents);
            _yawmap = CurveBuilder.ToAnimationCurve(angles);

            RefreshLines();
        }

        private void RefreshLines()
        {
            Vector3D up = new Vector3D(0, -1, 0);
            Vector3D current = (_mousepoint.ToPoint3D() - _center.ToPoint3D()).ToUnit();

            double dot = Vector3D.DotProduct(up, current);
            double angle_input = Math1D.Dot_to_Degrees(dot);

            double angle_output = angle_input + _yawmap.Evaluate(angle_input);

            _lines.Input_Left.Rotate.Angle = angle_input;
            _lines.Input_Right.Rotate.Angle = -angle_input;

            _lines.Output_Left.Rotate.Angle = angle_output;
            _lines.Output_Right.Rotate.Angle = -angle_output;
        }

        #endregion
    }
}
