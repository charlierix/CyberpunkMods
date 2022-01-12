using AirplaneEditor.Models_viewmodels;
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
using System.Windows.Shapes;
using System.Windows.Threading;

namespace AirplaneEditor.Views
{
    public partial class ForcesViewer : Window
    {
        #region record: WorkResult

        private record WorkResult
        {
            public PlanePart_VM[] PartVMs { get; init; }
        }

        #endregion

        #region Declaration Section

        private TrackBallRoam _trackball = null;

        private DispatcherTimer _reset_timer = null;

        // This is just a placeholder for setting/clearing visuals
        private WorkResult _showing = null;

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

                //CreateStaticVisuals();

                Blackboard.Instance.NewPlane += Blackboard_NewPlane;

                if (Blackboard.PlaneRoot != null)
                    RefreshPlane();
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


                //TODO: Create visuals


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


            //TODO: remove visuals


            _showing = null;
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
    }
}
