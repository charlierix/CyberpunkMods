using DebugRenderViewer.Models;
using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace DebugRenderViewer
{
    /// <summary>
    /// This views 3D objects defined in a json file that was built from in game
    /// </summary>
    /// <remarks>
    /// Models\LogScene is the root filetype
    /// 
    /// See txtFile_TextChanged
    /// 
    /// A lot of this code is just copied from Debug3DWindow and UtilityWPF
    /// https://github.com/charlierix/PartyPeople/blob/master/Math_WPF/WPF/Controls3D/Debug3DWindow.xaml
    /// https://github.com/charlierix/PartyPeople/blob/master/Math_WPF/WPF/UtilityWPF.cs
    /// </remarks>
    public partial class MainWindow : Window
    {
        #region record: VisualEntry

        public record VisualEntry
        {
            public ItemBase Model { get; init; }
            public Visual3D Visual { get; init; }
        }

        #endregion
        #region record: WindowSettings

        private record WindowSettings
        {
            public double BackgroundPercent { get; init; }
            public PointCentering PointCentering { get; init; }
            public bool ShowEmptyFrames { get; init; }

            public double? Width { get; init; }
            public double? Height { get; init; }
        }

        #endregion

        #region Declaration Section

        private readonly DropShadowEffect _errorEffect;
        private readonly DefaultColorBrushes _defaultBrushes = GetDefaultBrushes();

        private readonly string _settingsFilename;
        private WindowSettings _settings = null;

        private TrackBallRoam _trackball = null;

        private LogScene _scene_orig = null;
        private LogScene _scene = null;     // this one is a copy of orig, but with filters applied

        private List<Visual3D> _visuals = new List<Visual3D>();
        private List<BillboardLine3DSet> _lines_defaultColor = new List<BillboardLine3DSet>();
        private List<VisualEntry> _tooltips = new List<VisualEntry>();

        private bool _hasAutoSetCamera = false;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            DataContext = this;

            _errorEffect = new DropShadowEffect()
            {
                Color = UtilityWPF.ColorFromHex("C02020"),
                Direction = 0,
                ShadowDepth = 0,
                BlurRadius = 8,
                Opacity = .8,
            };

            _settingsFilename = System.IO.Path.Combine(Environment.CurrentDirectory, "window settings.json");

            //TODO: Use a graphic instead
            btnLeft.Content = "<";
            btnRight.Content = ">";

            cboCenterPoints.Items.Add(new KeyValuePair<string, PointCentering>("Across Frames", PointCentering.AcrossFrames));
            cboCenterPoints.Items.Add(new KeyValuePair<string, PointCentering>("Per Frame", PointCentering.PerFrame));
            cboCenterPoints.Items.Add(new KeyValuePair<string, PointCentering>("None", PointCentering.None));
            cboCenterPoints.SelectedIndex = 0;

            EnableDisableMultiFrame();
        }

        #endregion

        #region Public Properties

        // Elements in xaml are bound to these properties
        public Brush TextBrush
        {
            get
            {
                return (Brush)GetValue(TextBrushProperty);
            }
            set
            {
                SetValue(TextBrushProperty, value);
            }
        }
        public static readonly DependencyProperty TextBrushProperty = DependencyProperty.Register("TextBrush", typeof(Brush), typeof(MainWindow));

        public Brush HintBrush
        {
            get
            {
                return (Brush)GetValue(HintBrushProperty);
            }
            set
            {
                SetValue(HintBrushProperty, value);
            }
        }
        public static readonly DependencyProperty HintBrushProperty = DependencyProperty.Register("HintBrush", typeof(Brush), typeof(MainWindow));

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

                LoadSettings();

                RefreshColors();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            try
            {
                SaveSettings();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtFile_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                e.Effects = DragDropEffects.Copy;
            }
            else
            {
                e.Effects = DragDropEffects.None;
            }

            e.Handled = true;
        }
        private void txtFile_Drop(object sender, DragEventArgs e)
        {
            try
            {
                string[] filenames = e.Data.GetData(DataFormats.FileDrop) as string[];

                if (filenames == null || filenames.Length == 0)
                {
                    MessageBox.Show("No files selected", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (filenames.Length > 1)
                {
                    MessageBox.Show("Only one file allowed", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                txtFile.Text = filenames[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtFile_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (txtFile.Text == "")
                {
                    txtFile.Effect = null;
                    lblFileHint.Visibility = Visibility.Visible;
                    return;
                }

                lblFileHint.Visibility = Visibility.Collapsed;

                if (!File.Exists(txtFile.Text))
                {
                    txtFile.Effect = _errorEffect;
                    return;
                }

                string jsonString = System.IO.File.ReadAllText(txtFile.Text);

                //TODO: This should also return a list of warnings
                LogScene scene = FileReader.ParseJSON(jsonString);

                LoadScene(scene);

                txtFile.Effect = null;
            }
            catch (Exception)
            {
                txtFile.Effect = _errorEffect;
            }
        }

        private void trkBackground_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try
            {
                RefreshColors();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void cboCenterPoints_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (_scene_orig != null)
                    LoadScene(_scene_orig);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void chkEmptyFrames_Checked(object sender, RoutedEventArgs e)
        {
            try
            {
                if (_scene_orig != null)
                    LoadScene(_scene_orig);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void grdViewPort_MouseMove(object sender, MouseEventArgs e)
        {
            try
            {
                borderToolTip.Visibility = Visibility.Collapsed;

                if (_tooltips.Count == 0)
                    return;

                // Fire a ray at the mouse point
                Point clickPoint = e.GetPosition(grdViewPort);

                var hits = UtilityWPF.CastRay(out RayHitTestParameters clickRay, clickPoint, grdViewPort, _camera, _viewport, true, onlyVisuals: _tooltips.Select(o => o.Visual));
                if (hits.Count == 0)
                    return;

                VisualEntry entry = Util_Runtime.GetTooltipHit(_tooltips, hits);

                borderToolTip.Margin = new Thickness(clickPoint.X + 16, clickPoint.Y + 16, 0, 0);
                borderToolTip.Visibility = Visibility.Visible;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void btnLeft_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (trkMultiFrame.Value > trkMultiFrame.Minimum)
                    trkMultiFrame.Value--;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void btnRight_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (trkMultiFrame.Value < trkMultiFrame.Maximum)
                    trkMultiFrame.Value++;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void trkMultiFrame_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            try
            {
                if (_scene?.frames == null)
                    return;

                ShowFrame(_scene.frames[Convert.ToInt32(trkMultiFrame.Value)]);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private void SaveSettings()
        {
            var settings = (_settings ?? new WindowSettings()) with
            {
                BackgroundPercent = trkBackground.Value,
                PointCentering = ((KeyValuePair<string, PointCentering>)cboCenterPoints.SelectedItem).Value,
                ShowEmptyFrames = chkEmptyFrames.IsChecked.Value,
            };

            if (WindowState == WindowState.Normal)
            {
                settings = settings with
                {
                    Width = Width,
                    Height = Height,
                };
            }

            var options = new JsonSerializerOptions()
            {
                WriteIndented = true,
            };

            string serialized = JsonSerializer.Serialize(settings, options);

            File.WriteAllText(_settingsFilename, serialized);
        }
        private void LoadSettings()
        {
            if (!File.Exists(_settingsFilename))
                return;

            try
            {
                string jsonString = System.IO.File.ReadAllText(_settingsFilename);

                var settings = JsonSerializer.Deserialize<WindowSettings>(jsonString);

                trkBackground.Value = settings.BackgroundPercent;
                chkEmptyFrames.IsChecked = settings.ShowEmptyFrames;
                cboCenterPoints.SelectedIndex = Util_Runtime.SelectComboBox_ByValue<string, PointCentering>(cboCenterPoints, settings.PointCentering);

                if (settings.Width != null && settings.Height != null)
                {
                    Width = settings.Width.Value;
                    Height = settings.Height.Value;
                }

                _settings = settings;
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        /// <summary>
        /// Any item that doesn't have an explicit color defined will but updated by this function.  Colors are chosen
        /// that will stand out against the current background
        /// </summary>
        /// <remarks>
        /// This modifies 2D controls as well as items in the 3D scene
        /// </remarks>
        private void RefreshColors()
        {
            // Figure out the background
            Color background;
            double percentGray;

            if (_scene?.frames[(int)trkMultiFrame.Value]?.back_color != null)
            {
                background = _scene.frames[(int)trkMultiFrame.Value].back_color.Value;
                percentGray = UtilityWPF.ConvertToGray(background).R / 255d;
            }
            else
            {
                background = Util_Runtime.GetGray(trkBackground.Value);
                percentGray = trkBackground.Value;
            }

            Background = new SolidColorBrush(background);

            // Apply the opposite color to other items
            Color opposite = UtilityWPF.OppositeColor_BW(background);
            TextBrush = new SolidColorBrush(opposite);
            HintBrush = new SolidColorBrush(Color.FromArgb(128, opposite.R, opposite.G, opposite.B));

            //TODO: May want these to use different offsets so they stand out more
            _defaultBrushes.Dot_Brush.Color = Util_Runtime.GetGray(Util_Runtime.GetComplementaryGray(percentGray));
            _defaultBrushes.Line_Color = Util_Runtime.GetGray(Util_Runtime.GetComplementaryGray(percentGray));
            _defaultBrushes.Circle_Brush.Color = Util_Runtime.GetGray(Util_Runtime.GetComplementaryGray(percentGray));
            _defaultBrushes.Square_Brush.Color = Util_Runtime.GetGray(Util_Runtime.GetComplementaryGray(percentGray), 0.5);
            _defaultBrushes.Text_Brush.Color = opposite;

            foreach (var line in _lines_defaultColor)
            {
                line.Color = _defaultBrushes.Line_Color;
            }
        }
        private static DefaultColorBrushes GetDefaultBrushes()
        {
            var dot_brush = new SolidColorBrush(Colors.Black);
            var circle_brush = new SolidColorBrush(Colors.Black);
            var square_brush = new SolidColorBrush(Colors.Black);
            var text_brush = new SolidColorBrush(Colors.Black);

            return new DefaultColorBrushes()
            {
                Dot_Brush = dot_brush,
                Dot_Material = Util_Creation.GetMaterial(dot_brush),

                Line_Color = Colors.Black,

                Circle_Brush = circle_brush,
                Circle_Material = Util_Creation.GetMaterial(circle_brush),

                Square_Brush = square_brush,
                Square_Material = Util_Creation.GetMaterial(square_brush),

                Text_Brush = text_brush,
            };
        }

        /// <summary>
        /// This is a complete refresh of all items (3D objects, log text)
        /// </summary>
        private void LoadScene(LogScene scene)
        {
            _viewport.Children.RemoveAll(_visuals);
            _visuals.Clear();
            panelGlobalText.Children.Clear();
            panelFrameText.Children.Clear();

            _scene_orig = scene;

            scene = Util_Runtime.Apply_EmptyFrameRemoval(scene, chkEmptyFrames.IsChecked.Value);
            scene = Util_Runtime.Apply_Centering(scene, ((KeyValuePair<string, PointCentering>)cboCenterPoints.SelectedItem).Value);

            _scene = scene;

            EnableDisableMultiFrame();      // this needs to be called before the call to ShowFrame, since it calls RefreshColors, and that uses wherever trkMultiFrame is pointing.  So switching from a scene with more frames than this scene (and viewing one of those excess frames) would have caused an index out of range exception

            if (_scene.frames.Length > 0)
                ShowFrame(_scene.frames[0]);

            Util_Creation.ShowText(panelGlobalText, _scene.text, _defaultBrushes.Text_Brush);

            RefreshColors();
        }

        /// <summary>
        /// Items are broken down into frames.  Each frame holds the actual 3D objects, as well as a frame specific log
        /// </summary>
        /// <remarks>
        /// This makes it easy to create a visual each tick, or create multiple types of drawings all bundled into a
        /// single file
        /// </remarks>
        private void ShowFrame(LogFrame frame)
        {
            _viewport.Children.RemoveAll(_visuals);
            _visuals.Clear();
            _lines_defaultColor.Clear();
            _tooltips.Clear();
            panelFrameText.Children.Clear();

            //TODO: Don't make a visual per item.  Group by type, only create separate if there are tooltips

            var sorted_items = frame.items.
                Select(o => new
                {
                    sort_val = o is ItemSquare_Filled ?     // wpf doesn't handle semitransparency well.  Visuals added after a semitransparent mesh will make that mess seem opaque.  So semitransparent meshes need to be loaded last
                        999 : 0,
                    item = o,
                }).
                OrderBy(o => o.sort_val).
                Select(o => o.item);

            foreach (var item in sorted_items)
            {
                Visual3D visual = Util_Creation.GetVisual(item, _defaultBrushes, _lines_defaultColor);
                if (visual == null)
                    continue;

                _visuals.Add(visual);
                _viewport.Children.Add(visual);

                if (!string.IsNullOrWhiteSpace(item.tooltip))
                {
                    _tooltips.Add(new VisualEntry()
                    {
                        Model = item,
                        Visual = visual,
                    });
                }
            }

            if (!_hasAutoSetCamera)
            {
                AutoSetCamera();
                _hasAutoSetCamera = true;
            }

            Util_Creation.ShowText(panelFrameText, frame.text, _defaultBrushes.Text_Brush);

            RefreshColors();
        }

        /// <summary>
        /// Only show navigation controls if there is more than one frame
        /// </summary>
        private void EnableDisableMultiFrame()
        {
            trkMultiFrame.Minimum = 0;
            trkMultiFrame.Value = 0;

            if (_scene?.frames == null || _scene.frames.Length < 2)
            {
                btnLeft.Visibility = Visibility.Collapsed;
                btnRight.Visibility = Visibility.Collapsed;
                trkMultiFrame.Visibility = Visibility.Collapsed;
                return;
            }

            trkMultiFrame.Maximum = _scene.frames.Length - 1;

            //btnLeft.Visibility = Visibility.Visible;
            //btnRight.Visibility = Visibility.Visible;
            btnLeft.Visibility = Visibility.Collapsed;      //TODO: Add these if they feel missed (would need to draw the arrows, don't use buttons, just a simple nearly transparent background)
            btnRight.Visibility = Visibility.Collapsed;

            trkMultiFrame.Visibility = Visibility.Visible;
        }

        //TODO: Finish this
        private void AutoSetCamera()
        {
            //NOTE: this was copied from Debug3DWindow

            //Point3D[] points = TryGetVisualPoints(this.Visuals3D);

            //Tuple<Point3D, Vector3D, Vector3D> cameraPos = GetCameraPosition(points);      // this could return null
            //if (cameraPos == null)
            //{
            //    cameraPos = Tuple.Create(new Point3D(0, 0, 7), new Vector3D(0, 0, -1), new Vector3D(0, 1, 0));
            //}

            //_camera.Position = cameraPos.Item1;
            //_camera.LookDirection = cameraPos.Item2;
            //_camera.UpDirection = cameraPos.Item3;

            //double distance = _camera.Position.ToVector().Length;
            //double scale = distance * .0214;

            //_trackball.PanScale = scale / 10;
            //_trackball.ZoomScale = scale;
            //_trackball.MouseWheelScale = distance * .0007;
        }

        #endregion
    }
}
