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
    public partial class MainWindow : Window
    {
        #region class: DefaultColorBrushes

        private record DefaultColorBrushes
        {
            public Material Dot_Material { get; init; }
            public SolidColorBrush Dot_Brush { get; init; }
        }

        #endregion

        #region Declaration Section

        private const double SIZE_DOT = 0.04;

        private readonly DropShadowEffect _errorEffect;
        private readonly DefaultColorBrushes _defaultBrushes = GetDefaultBrushes();

        private TrackBallRoam _trackball = null;

        private LogScene _scene = null;

        private List<Visual3D> _visuals = new List<Visual3D>();

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

            //TODO: Use a graphic instead
            btnLeft.Content = "<";
            btnRight.Content = ">";

            EnableDisableMultiFrame();
        }

        #endregion

        #region Public Properties

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

                RefreshColors();
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

        private void RefreshColors()
        {
            Color background = GetGray(trkBackground.Value);

            Background = new SolidColorBrush(background);

            Color opposite = UtilityWPF.OppositeColor_BW(background);
            TextBrush = new SolidColorBrush(opposite);
            HintBrush = new SolidColorBrush(Color.FromArgb(128, opposite.R, opposite.G, opposite.B));

            _defaultBrushes.Dot_Brush.Color = GetGray(GetComplementaryGray(trkBackground.Value));
        }

        private void LoadScene(LogScene scene)
        {
            _viewport.Children.RemoveAll(_visuals);
            _visuals.Clear();

            _scene = scene;

            if (scene.frames.Length > 0)
                ShowFrame(scene.frames[0]);

            EnableDisableMultiFrame();
        }

        private void ShowFrame(LogFrame frame)
        {
            _viewport.Children.RemoveAll(_visuals);
            _visuals.Clear();

            //TODO: Don't make a visual per item.  Group by type, only create separate if there are tooltips
            //var test = new Button();
            //test.ToolTip = "hello";     // FrameworkElement






            foreach (var item in frame.items)
            {
                if (item is ItemDot dot) { }
                else
                    continue;

                Visual3D visual = GetVisual_Dot(dot, _defaultBrushes.Dot_Brush);

                if (visual != null)
                {
                    _visuals.Add(visual);
                    _viewport.Children.Add(visual);
                }
            }

            if (!_hasAutoSetCamera)
            {
                AutoSetCamera();
                _hasAutoSetCamera = true;
            }
        }

        private static Visual3D GetVisual_Dot(ItemDot dot, Brush defaultBrush)
        {
            Material material = GetMaterial(GetBrush(dot, defaultBrush));

            GeometryModel3D geometry = new GeometryModel3D();
            geometry.Material = material;
            geometry.BackMaterial = material;
            geometry.Geometry = UtilityWPF.GetSphere_Ico(SIZE_DOT * (dot.size_mult ?? 1), 1, true);
            geometry.Transform = new TranslateTransform3D(dot.position.ToVector());

            var retVal = new ModelVisual3D
            {
                Content = geometry,
            };


            //TODO: There probably needs to be a global mouse handler.  Store tooltipped items in their own list so that
            //it's faster
            //if(dot.tooltip)
            //    retVal.


            return retVal;
        }

        private void EnableDisableMultiFrame()
        {
            if (_scene?.frames == null || _scene.frames.Length < 2)
            {
                btnLeft.Visibility = Visibility.Collapsed;
                btnRight.Visibility = Visibility.Collapsed;
                trkMultiFrame.Visibility = Visibility.Collapsed;
                return;
            }

            trkMultiFrame.Minimum = 0;
            trkMultiFrame.Maximum = _scene.frames.Length - 1;
            trkMultiFrame.Value = 0;

            btnLeft.Visibility = Visibility.Visible;
            btnRight.Visibility = Visibility.Visible;
            trkMultiFrame.Visibility = Visibility.Visible;
        }

        private void AutoSetCamera()
        {
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

        private static DefaultColorBrushes GetDefaultBrushes()
        {
            var dot_brush = new SolidColorBrush(Colors.Black);

            return new DefaultColorBrushes()
            {
                Dot_Brush = dot_brush,
                Dot_Material = GetMaterial(dot_brush),
            };
        }

        private static Material GetMaterial(Brush brush)
        {
            MaterialGroup retVal = new MaterialGroup();

            retVal.Children.Add(new DiffuseMaterial(brush));
            retVal.Children.Add(new SpecularMaterial(new SolidColorBrush(UtilityWPF.ColorFromHex("40989898")), 2));

            return retVal;
        }

        private static Brush GetBrush(ItemBase item, Brush defaultBrush)
        {
            if (item.color != null)
                return new SolidColorBrush(item.color.Value);
            else if (item.category?.color != null)
                return new SolidColorBrush(item.category.color.Value);
            else
                return defaultBrush;
        }

        private static double GetComplementaryGray(double percent)
        {
            const double DISTANCE = 0.4;

            if (percent + DISTANCE <= 1)
                return percent + DISTANCE;
            else
                return percent - DISTANCE;
        }
        private static Color GetGray(double percent)
        {
            byte gray = Convert.ToByte(255 * percent);
            return Color.FromRgb(gray, gray, gray);
        }

        #endregion
        #region Private Methods - ATTEMPT1

        private void ShowFrame_ATTEMPT1(LogFrame frame)
        {
            _viewport.Children.RemoveAll(_visuals);
            _visuals.Clear();

            //TODO: Don't make a visual per item.  Group by type, only create separate if there are tooltips
            //var test = new Button();
            //test.ToolTip = "hello";     // FrameworkElement

            foreach (var item in frame.items)
            {
                Visual3D visual = null;

                if (item is ItemDot dot)
                    visual = Debug3DWindow.GetDot(dot.position, 0.03, GetColor_ATTEMPT1(item));
                else if (item is ItemLine line)
                    visual = Debug3DWindow.GetLine(line.point1, line.point2, 0.02, GetColor_ATTEMPT1(item));
                else if (item is ItemCircle circle)
                    visual = Debug3DWindow.GetCircle(circle.center, circle.radius, 0.02, GetColor_ATTEMPT1(item));
                else if (item is ItemSquare square)
                    //visual = Debug3DWindow.GetSquare()
                    visual = null;
                else
                    throw new ApplicationException($"Unknown item type: {item.GetType()}");

                if (visual != null)
                {
                    _visuals.Add(visual);
                    _viewport.Children.Add(visual);
                }
            }

            if (!_hasAutoSetCamera)
            {
                AutoSetCamera();
                _hasAutoSetCamera = true;
            }
        }

        private static Color GetColor_ATTEMPT1(ItemBase item)
        {
            if (item.color != null)
                return item.color.Value;
            else if (item.category?.color != null)
                return item.category.color.Value;
            else
                return Colors.Black;        // TODO: use something that contrasts with background color
        }

        #endregion
    }
}
