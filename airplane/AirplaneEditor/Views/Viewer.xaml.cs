using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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
using System.Windows.Shapes;

namespace AirplaneEditor.Views
{
    /// <summary>
    /// This shows the plane, as well as extra info about the plane
    /// </summary>
    /// <remarks>
    /// It might be annoying to have multiple windows, but splitting it up means this dedicated viewer
    /// can be a little bit busy with the visuals.  It's purpose is to make sure the user has a good
    /// idea of the plane
    /// 
    /// There can be as many editor windows as desired, each set to their own camera orientation/position
    /// </remarks>
    public partial class Viewer : Window
    {
        #region class: PartVisual

        private record PartVisual
        {
            public PlanePart_VM Part { get; init; }

            public Visual3D Visual { get; init; }

            public Transform3D Transform { get; init; }
            public TranslateTransform3D Translate { get; init; }
            public QuaternionRotation3D Rotate { get; init; }
            public ScaleTransform3D Scale { get; init; }
        }

        #endregion

        #region Declaration Section

        private TrackBallRoam _trackball = null;

        private List<PartVisual> _parts = new List<PartVisual>();

        #endregion

        #region Constructor

        public Viewer()
        {
            InitializeComponent();
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                _trackball = new TrackBallRoam(_camera)
                {
                    EventSource = grdViewPort,      //NOTE:  If this control doesn't have a background color set, the trackball won't see events (I think transparent is ok, just not null)
                    AllowZoomOnMouseWheel = true,
                    ShouldHitTestOnOrbit = false,
                    //KeyPanScale = ???,
                    //InertiaPercentRetainPerSecond_Linear = ???,
                    //InertiaPercentRetainPerSecond_Angular = ???,
                };
                _trackball.Mappings.AddRange(TrackBallMapping.GetPrebuilt(TrackBallMapping.PrebuiltMapping.MouseComplete));
                //_trackball.GetOrbitRadius += new GetOrbitRadiusHandler(Trackball_GetOrbitRadius);

                CreateStaticVisuals();

                Blackboard.Instance.NewPlane += Blackboard_NewPlane;

                if (Blackboard.PlaneRoot != null)
                    AddPart(Blackboard.PlaneRoot);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Blackboard_NewPlane(object sender, EventArgs e)
        {
            try
            {
                Clear();

                AddPart(Blackboard.PlaneRoot);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Children_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            try
            {
                switch (e.Action)
                {
                    case NotifyCollectionChangedAction.Add:
                        foreach (PlanePart_VM part in e.NewItems)
                        {
                            AddPart(part);
                        }

                        break;

                    case NotifyCollectionChangedAction.Remove:
                        foreach (PlanePart_VM part in e.OldItems)
                        {
                            RemovePart(part);
                        }
                        break;

                    default:
                        throw new ApplicationException($"Unexpected NotifyCollectionChangedAction: {e.Action}");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Part_IsCenterlineChanged(object sender, EventArgs e)
        {
            try
            {
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Part_PositionChanged(object sender, EventArgs e)
        {
            try
            {
                if (sender is PlanePart_VM part)
                {
                    PartVisual visual = FindParentVisual(part);
                    if (visual == null)
                        return;

                    visual.Translate.OffsetX = part.Position.X;
                    visual.Translate.OffsetY = part.Position.Y;
                    visual.Translate.OffsetZ = part.Position.Z;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Part_RotationChanged(object sender, EventArgs e)
        {
            try
            {
                if (sender is PlanePart_VM part)
                {
                    PartVisual visual = FindParentVisual(part);
                    if (visual == null)
                        return;

                    visual.Rotate.Quaternion = part.Orientation;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Part_SizeChanged(object sender, EventArgs e)
        {
            try
            {
                if (sender is PlanePart_VM part)
                {
                    PartVisual visual = FindParentVisual(part);
                    if (visual == null)
                        return;

                    AdjustScale(visual, part);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void Clear()
        {
            foreach (PartVisual part in _parts)
            {
                UnhookEvents(part);
                _viewport.Children.Remove(part.Visual);
            }

            _parts.Clear();
        }

        private void AddPart(PlanePart_VM part)
        {
            if (FindParentVisual(part) != null)
                throw new ApplicationException($"Part already added: {part.PartType}");

            Transform3D parent_transform = FindParentVisual(part.Parent)?.Transform;

            Util_Visuals.CreatedVisual visual;
            switch (part.PartType)
            {
                case PlanePartType.Fuselage:
                    visual = Util_Visuals.Get_Fuselage(parent_transform);
                    break;

                case PlanePartType.Wing:
                    visual = Util_Visuals.Get_Wing(parent_transform);
                    break;

                case PlanePartType.Engine:
                    visual = Util_Visuals.Get_Engine(parent_transform);
                    break;

                case PlanePartType.Bomb:
                    visual = Util_Visuals.Get_Bomb(parent_transform);
                    break;

                case PlanePartType.Gun:
                    visual = Util_Visuals.Get_Gun(parent_transform);
                    break;

                default:
                    throw new ApplicationException($"Unknown PlanePartType: {part.PartType}");
            }

            var part_visual = new PartVisual()
            {
                Part = part,
                Visual = visual.Visual,
                Transform = visual.Transform,
                Translate = visual.Translate,
                Rotate = visual.Rotate,
                Scale = visual.Scale,
            };

            part_visual.Translate.OffsetX = part.Position.X;
            part_visual.Translate.OffsetY = part.Position.Y;
            part_visual.Translate.OffsetZ = part.Position.Z;

            part_visual.Rotate.Quaternion = part.Orientation;

            AdjustScale(part_visual, part);

            _parts.Add(part_visual);

            _viewport.Children.Add(part_visual.Visual);

            HookEvents(part_visual);

            foreach (var child in part.Children)
            {
                AddPart(child);
            }
        }
        private void RemovePart(PlanePart_VM part)
        {
            foreach (PlanePart_VM child in part.Children)
            {
                RemovePart(child);
            }

            PartVisual part_visual = FindParentVisual(part);
            if (part_visual == null)
                throw new ApplicationException($"Didn't find part: {part.PartType}");

            UnhookEvents(part_visual);

            _viewport.Children.Remove(part_visual.Visual);
        }

        private void HookEvents(PartVisual part)
        {
            part.Part.Children.CollectionChanged += Children_CollectionChanged;
            part.Part.IsCenterlineChanged += Part_IsCenterlineChanged;
            part.Part.PositionChanged += Part_PositionChanged;
            part.Part.RotationChanged += Part_RotationChanged;
            part.Part.SizeChanged += Part_SizeChanged;
        }

        private void UnhookEvents(PartVisual part)
        {
            part.Part.Children.CollectionChanged -= Children_CollectionChanged;
            part.Part.IsCenterlineChanged -= Part_IsCenterlineChanged;
            part.Part.PositionChanged -= Part_PositionChanged;
            part.Part.RotationChanged -= Part_RotationChanged;
            part.Part.SizeChanged -= Part_SizeChanged;
        }

        private void CreateStaticVisuals()
        {
            const double AXIS_LENGTH = 6;
            const double AXIS_THICKNEESS = 0.025;

            _viewport.Children.Add(Debug3DWindow.GetLine(new Point3D(0, 0, 0), new Point3D(AXIS_LENGTH, 0, 0), AXIS_THICKNEESS, UtilityWPF.ColorFromHex("FF6060")));
            _viewport.Children.Add(Debug3DWindow.GetLine(new Point3D(0, 0, 0), new Point3D(0, AXIS_LENGTH, 0), AXIS_THICKNEESS, UtilityWPF.ColorFromHex("30E830")));
            _viewport.Children.Add(Debug3DWindow.GetLine(new Point3D(0, 0, 0), new Point3D(0, 0, AXIS_LENGTH), AXIS_THICKNEESS, UtilityWPF.ColorFromHex("6060FF")));
        }

        private PartVisual FindParentVisual(PlanePart_VM part)
        {
            if (part == null)
                return null;

            foreach (PartVisual existing in _parts)
            {
                if (existing.Part == part)
                    return existing;
            }

            return null;
        }

        private static void AdjustScale(PartVisual visual, PlanePart_VM part)
        {
            if(part is PlanePart_Wing_VM wing)
            {
                visual.Scale.ScaleX = wing.Span;
                visual.Scale.ScaleY = wing.Chord;
            }
        }

        #endregion
    }
}
