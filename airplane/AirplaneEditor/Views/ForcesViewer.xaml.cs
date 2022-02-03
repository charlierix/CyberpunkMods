using AirplaneEditor.Airplane;
using AirplaneEditor.Models;
using AirplaneEditor.Models_viewmodels;
using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
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
using System.Windows.Media.Media3D;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace AirplaneEditor.Views
{
    //TODO: Have an option for the plane to be tied to a couple ropes.  This will need a RigidBody and AircraftPhysics

    public partial class ForcesViewer : Window
    {
        #region record: WorkResult

        private record WorkResult
        {
            public PlanePart_VM[] PartVMs { get; init; }
        }

        #endregion
        #region record: WingVisual

        private record WingVisual
        {
            public PlanePart_Wing Model { get; init; }
            public Visual3D Visual { get; init; }

            public AeroSurface Aero { get; init; }
        }

        #endregion

        #region class: FluidVisual

        /// <summary>
        /// This is a wrapper to a line that moves through the world at the speed of the fluid
        /// </summary>
        /// <remarks>
        /// This is a copy of WindTunnelWindow.FluidVisual.  May want to make a subfolder of useful classes like this
        /// </remarks>
        private class FluidVisual : IDisposable
        {
            #region Declaration Section

            private Viewport3D _viewport = null;
            private BillboardLine3DSet _line = null;        // set inherits from visual.  It will only hold one line per instance of FluidVisual

            private readonly QuaternionRotation3D _line_rotate = new QuaternionRotation3D();
            private readonly TranslateTransform3D _line_translate = new TranslateTransform3D();

            #endregion

            #region Constructor

            /// <summary>
            /// NOTE:  Keep the model coords along X.  The line will be rotated into world coords
            /// </summary>
            public FluidVisual(Viewport3D viewport, Point3D modelFromPoint, Point3D modelToPoint, Point3D worldStartPoint, Vector3D worldFlow, Color color, double maxDistance)
            {
                _viewport = viewport;
                Position = worldStartPoint;
                WorldFlow = worldFlow;
                MaxDistance = maxDistance;
                MaxDistanceSqr = maxDistance * maxDistance;

                _line = new BillboardLine3DSet(false);
                _line.Color = color;
                _line.BeginAddingLines();
                _line.AddLine(modelFromPoint, modelToPoint, 0.03);
                _line.EndAddingLines();

                Transform3DGroup transform = new Transform3DGroup();
                transform.Children.Add(new RotateTransform3D(_line_rotate));
                transform.Children.Add(_line_translate);

                _line.Transform = transform;

                _viewport.Children.Add(_line);
            }

            #endregion

            #region IDisposable Members

            public void Dispose()
            {
                Dispose(true);
                GC.SuppressFinalize(this);
            }

            protected virtual void Dispose(bool disposing)
            {
                if (disposing)
                {
                    if (_viewport != null && _line != null)
                    {
                        _viewport.Children.Remove(_line);
                        _viewport = null;
                        _line = null;
                    }
                }
            }

            #endregion

            #region Public Properties

            private Vector3D _worldFlow;
            public Vector3D WorldFlow
            {
                get => _worldFlow;
                set
                {
                    _worldFlow = value;
                    _line_rotate.Quaternion = Math3D.GetRotation(new Vector3D(-1, 0, 0), _worldFlow);
                }
            }

            private Point3D _position;
            public Point3D Position
            {
                get => _position;
                private set
                {
                    _position = value;
                    _line_translate.OffsetX = _position.X;
                    _line_translate.OffsetY = _position.Y;
                    _line_translate.OffsetZ = _position.Z;
                }
            }

            /// <summary>
            /// When the line gets farther from the center than this, then it should be removed
            /// </summary>
            public double MaxDistance { get; private set; }
            public double MaxDistanceSqr { get; private set; }

            #endregion

            #region Public Methods

            /// <summary>
            /// Moves the line through the world
            /// </summary>
            public void Update(double elapsedTime)
            {
                Position += WorldFlow * elapsedTime;
            }

            #endregion
        }

        #endregion
        #region class: ItemColors

        // This was copied from WindTunnel2
        private class ItemColors
        {
            //public Color ForceLine = UtilityWPF.AlphaBlend(Colors.HotPink, Colors.Plum, .25d);

            //public Color HullFace = UtilityWPF.AlphaBlend(Colors.Ivory, Colors.Transparent, .2d);
            //public SpecularMaterial HullFaceSpecular = new SpecularMaterial(new SolidColorBrush(Color.FromArgb(255, 86, 68, 226)), 100d);
            //public Color HullWireFrame = UtilityWPF.AlphaBlend(Colors.Ivory, Colors.Transparent, .3d);

            //public Color GhostBodyFace = Color.FromArgb(40, 192, 192, 192);
            //public SpecularMaterial GhostBodySpecular = new SpecularMaterial(new SolidColorBrush(Color.FromArgb(96, 86, 68, 226)), 25);

            //public Color Anchor = Colors.Gray;
            //public SpecularMaterial AnchorSpecular = new SpecularMaterial(new SolidColorBrush(Colors.Silver), 50d);
            //public Color Rope = Colors.Silver;
            //public SpecularMaterial RopeSpecular = new SpecularMaterial(new SolidColorBrush(UtilityWPF.AlphaBlend(Colors.Silver, Colors.White, .5d)), 25d);

            public Color FluidLine => UtilityWPF.GetRandomColor(255, 153, 168, 186, 191, 149, 166);

            public DiffuseMaterial TrackballAxisMajor = new DiffuseMaterial(new SolidColorBrush(Color.FromArgb(255, 147, 98, 229)));
            public DiffuseMaterial TrackballAxisMinor = new DiffuseMaterial(new SolidColorBrush(Color.FromArgb(255, 127, 112, 153)));
            public Color TrackballAxisLine = Color.FromArgb(96, 117, 108, 97);
            public SpecularMaterial TrackballAxisSpecular = new SpecularMaterial(UtilityWPF.BrushFromHex("3DDD"), 6d);

            public Color TrackballGrabberHoverLight = Color.FromArgb(255, 74, 37, 138);

            public Color Force = UtilityWPF.ColorFromHex("F09C35");
            public Color Drag = UtilityWPF.ColorFromHex("DE432F");
            public Color Lift = UtilityWPF.ColorFromHex("F2E963");

            private Color cyan = UtilityWPF.ColorFromHex("66F4FA");     // maybe use for torque?

            //public Color BlockedCell = UtilityWPF.ColorFromHex("60BAE5B1");
            //public Color FieldBoundry = UtilityWPF.ColorFromHex("40B5C9B1");
        }

        #endregion

        #region Declaration Section

        private const int NUMFLUIDVISUALS = 80;
        private const double FLUIDVISUALMAXPOS = 60d;

        private readonly ItemColors _colors = new ItemColors();

        private TrackBallRoam _trackball = null;

        private DispatcherTimer _reset_timer = null;
        private DispatcherTimer _update_timer = null;

        // This is just a placeholder for setting/clearing visuals
        private WorkResult _showing = null;

        private readonly List<WingVisual> _wingVisuals = new List<WingVisual>();

        private BillboardLine3DSet _forceLines = null;
        private BillboardLine3DSet _dragLines = null;
        private BillboardLine3DSet _liftLines = null;

        private readonly List<FluidVisual> _fluidVisuals = new List<FluidVisual>();

        private TrackballGrabber _flowOrientationTrackball = null;

        private double _airSpeed = 8;
        private double _airDensity = 5;

        #endregion

        #region Constructor

        public ForcesViewer()
        {
            InitializeComponent();

            _reset_timer = new DispatcherTimer()
            {
                Interval = TimeSpan.FromMilliseconds(150),
                IsEnabled = false,
            };
            _reset_timer.Tick += ResetTimer_Tick;

            _update_timer = new DispatcherTimer()
            {
                Interval = TimeSpan.FromMilliseconds(20),
                IsEnabled = true,
            };
            _update_timer.Tick += UpdateTimer_Tick;
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

                _forceLines = new BillboardLine3DSet()
                {
                    Color = _colors.Force,
                    IsReflectiveColor = false,
                };
                _viewport.Children.Add(_forceLines);

                _dragLines = new BillboardLine3DSet()
                {
                    Color = _colors.Drag,
                    IsReflectiveColor = false,
                };
                _viewport.Children.Add(_dragLines);

                _liftLines = new BillboardLine3DSet()
                {
                    Color = _colors.Lift,
                    IsReflectiveColor = false,
                };
                _viewport.Children.Add(_liftLines);

                SetupFlowTrackball();

                //CreateStaticVisuals();

                Blackboard.Instance.NewPlane += Blackboard_NewPlane;

                if (Blackboard.PlaneRoot != null)
                    RefreshPlane();

                UpdateFlowLines(0);
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
                RefreshPlane();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Part_Changed(object sender, EventArgs e)
        {
            try
            {
                RefreshPlane();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Children_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            try
            {
                RefreshPlane();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ResetTimer_Tick(object sender, EventArgs e)
        {
            try
            {
                _reset_timer.Stop();

                ClearExisting();

                if (Blackboard.PlaneRoot == null)
                    return;

                var airplane = Util_ToModel.ToModel(Blackboard.PlaneRoot, "");

                PlanePart_VM[] all_parts = GetAllParts(Blackboard.PlaneRoot);

                foreach (PlanePart_VM part in all_parts)
                {
                    part.IsCenterlineChanged += Part_Changed;
                    part.PositionChanged += Part_Changed;
                    part.RotationChanged += Part_Changed;
                    part.SizeChanged += Part_Changed;
                    part.Children.CollectionChanged += Children_CollectionChanged;
                }

                foreach (var wing in airplane.Wings)
                {
                    _wingVisuals.Add(CreateWingVisual(wing));
                }


                //TODO: Other parts


                _showing = new WorkResult()
                {
                    PartVMs = all_parts,
                };
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void UpdateTimer_Tick(object sender, EventArgs e)
        {
            try
            {
                UpdateFlowLines(_update_timer.Interval.TotalSeconds);

                UpdateAeroForces();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void FlowOrientationTrackball_RotationChanged(object sender, EventArgs e)
        {
            try
            {
                VelocityDensityChanged();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), this.Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ResetWind_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                _flowOrientationTrackball.ResetToDefault();
                VelocityDensityChanged();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void ResetView_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                // These values are the same has how it's set up in the xaml
                _camera.Position = new Point3D(0, -12, 0);
                _camera.LookDirection = new Vector3D(0, 1, 0);
                _camera.UpDirection = new Vector3D(0, 0, 1);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void RefreshPlane()
        {
            _reset_timer.Stop();

            if (Blackboard.PlaneRoot == null)
            {
                if (_showing != null)
                    ClearExisting();

                return;
            }

            _reset_timer.Start();
        }

        private void ClearExisting()
        {
            if (_showing == null)
                return;

            foreach (PlanePart_VM part in _showing.PartVMs)
            {
                part.IsCenterlineChanged -= Part_Changed;
                part.PositionChanged -= Part_Changed;
                part.RotationChanged -= Part_Changed;
                part.SizeChanged -= Part_Changed;
                part.Children.CollectionChanged -= Children_CollectionChanged;
            }

            foreach (var wing in _wingVisuals)
            {
                _viewport.Children.Remove(wing.Visual);
            }
            _wingVisuals.Clear();

            _showing = null;
        }

        private WingVisual CreateWingVisual(PlanePart_Wing wing)
        {
            var transforms = Util_ToModel.GetTransforms(wing.Position, wing.Orientation);

            var visual = Util_Visuals.Get_Wing(transforms.to_world);
            visual.Scale.ScaleX = wing.span;
            visual.Scale.ScaleY = wing.chord;

            _viewport.Children.Add(visual.Visual);


            //TODO: visual for force at point


            AeroSurface aero = new AeroSurface(wing.ToAeroConfig(), transforms.to_world, transforms.to_local);

            return new WingVisual()
            {
                Model = wing,
                Visual = visual.Visual,
                Aero = aero,
            };
        }

        private static PlanePart_VM[] GetAllParts(PlanePart_VM part)
        {
            var retVal = new List<PlanePart_VM>();

            retVal.Add(part);

            foreach (PlanePart_VM child in part.Children)
            {
                retVal.AddRange(GetAllParts(child));
            }

            return retVal.ToArray();
        }

        #endregion
        #region Private Methods - fluid flow

        private void SetupFlowTrackball()
        {
            // NOTE: The trackball just stores a quaternion under the hood (defaults to identity).  It's up to the client to make sure that
            // _cameraFlowRotate's position/direction are pointed correctly.  Also that the visuals are created along the correct axis, as
            // well as default_direction

            var default_direction = new DoubleVector_wpf(new Vector3D(0, -1, 0), new Vector3D(0, 0, 1));

            // Big purple arrow
            var permanentVisuals = new List<Visual3D>();
            permanentVisuals.Add(new ModelVisual3D() { Content = TrackballGrabber.GetMajorArrow(Axis.Y, false, _colors.TrackballAxisMajor, _colors.TrackballAxisSpecular) });

            // Faint lines
            var hoverVisuals = new List<Visual3D>();
            hoverVisuals.Add(TrackballGrabber.GetGuideLine(Axis.Y, true, _colors.TrackballAxisLine));
            hoverVisuals.Add(TrackballGrabber.GetGuideLineDouble(Axis.X, _colors.TrackballAxisLine));
            hoverVisuals.Add(TrackballGrabber.GetGuideLineDouble(Axis.Z, _colors.TrackballAxisLine));

            // Create the trackball
            _flowOrientationTrackball = new TrackballGrabber(grdFlowRotateViewport, _viewportFlowRotate, permanentVisuals.ToArray(), hoverVisuals.ToArray(), 1d, _colors.TrackballGrabberHoverLight, default_direction);

            _flowOrientationTrackball.RotationChanged += new EventHandler(FlowOrientationTrackball_RotationChanged);
        }

        private void UpdateFlowLines(double elapsedTime)
        {
            int index = 0;
            while (index < _fluidVisuals.Count)
            {
                _fluidVisuals[index].Update(elapsedTime);

                if (_fluidVisuals[index].Position.ToVector().LengthSquared > _fluidVisuals[index].MaxDistanceSqr)
                {
                    _fluidVisuals[index].Dispose();
                    _fluidVisuals.RemoveAt(index);
                }
                else
                {
                    index++;
                }
            }

            int maxFluidVisuals = Convert.ToInt32(NUMFLUIDVISUALS * _airDensity);
            if (_fluidVisuals.Count < maxFluidVisuals)
            {
                AddFluidVisuals(maxFluidVisuals - _fluidVisuals.Count);
            }



            //// Update the flow line speed
            //Vector3D worldFlow = GetWorldFlow();
            //foreach (FluidVisual fluidLine in _fluidVisuals)
            //{
            //    fluidLine.WorldFlow = worldFlow;
            //}


        }

        private void AddFluidVisuals(int count)
        {
            for (int cntr = 0; cntr < count; cntr++)
            {
                double length = .5d + Math.Abs(Math1D.GetNearZeroValue(3d));
                Point3D modelFrom = new Point3D(-length, 0, 0);
                Point3D modelTo = new Point3D(length, 0, 0);

                Color color = _colors.FluidLine;        // the property get returns a random color each time

                Point3D position = Math3D.GetRandomVector_Spherical(FLUIDVISUALMAXPOS).ToPoint();

                double maxDistance = position.ToVector().Length;
                maxDistance = UtilityMath.GetScaledValue_Capped(maxDistance, FLUIDVISUALMAXPOS, 0d, 1d, StaticRandom.NextDouble());

                _fluidVisuals.Add(new FluidVisual(_viewport, modelFrom, modelTo, position, GetWorldFlow(), color, maxDistance));
            }
        }

        private void VelocityDensityChanged()
        {
            // may want to add these slider
            //_airDensity = trkAirDensity.Value;
            //_airSpeed = trkAirSpeed.Value;

            // Adjust number of flow lines based on viscosity
            IncreaseDecreaseFlowLines();

            // Update the flow line speed
            Vector3D worldFlow = GetWorldFlow();
            foreach (FluidVisual fluidLine in _fluidVisuals)
            {
                fluidLine.WorldFlow = worldFlow;
            }
        }
        private void IncreaseDecreaseFlowLines()
        {
            int maxFluidVisuals = Convert.ToInt32(NUMFLUIDVISUALS * _airDensity);

            if (_fluidVisuals.Count < maxFluidVisuals)
            {
                AddFluidVisuals(maxFluidVisuals - _fluidVisuals.Count);
            }
            else if (_fluidVisuals.Count > maxFluidVisuals)
            {
                int numToRemove = _fluidVisuals.Count - maxFluidVisuals;

                for (int cntr = 1; cntr <= numToRemove; cntr++)
                {
                    int removeIndex = StaticRandom.Next(_fluidVisuals.Count);
                    _fluidVisuals[removeIndex].Dispose();
                    _fluidVisuals.RemoveAt(removeIndex);
                }
            }
        }

        private Vector3D GetWorldFlow()
        {
            return _flowOrientationTrackball.Direction.Standard * _airSpeed;
        }

        #endregion
        #region Private Methods - aero forces

        private void UpdateAeroForces()
        {
            Vector3D worldFlow = GetWorldFlow();

            _forceLines.BeginAddingLines();     // billboard set is designed for this rapid addition/removal.  It reuses models under the hood
            _dragLines.BeginAddingLines();
            _liftLines.BeginAddingLines();

            Point3D rigidbody_centermass = new Point3D();

            foreach (WingVisual wing in _wingVisuals)
            {
                Point3D center = wing.Aero.Position_world;        // the point is twice as far as model's.  Probably: the transform includes parent+child, then child point is run through the transform, instead of passing zero to the transform

                var forces = wing.Aero.CalculateForces(worldFlow, _airDensity, wing.Aero.Position_world - rigidbody_centermass);

                _forceLines.AddLine(center, center + forces.force, 0.07);

                _dragLines.AddLine(center, center + forces.drag, 0.045);
                _liftLines.AddLine(center, center + forces.lift, 0.045);
            }

            _forceLines.EndAddingLines();
            _dragLines.EndAddingLines();
            _liftLines.EndAddingLines();
        }

        #endregion
    }
}
