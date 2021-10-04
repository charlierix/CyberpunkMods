using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
using PointParser.Models;
using PointParser.Testers;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PointParser
{
    public partial class MainWindow : Window
    {
        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;
        }

        #endregion

        #region Event Listeners

        private void txtInputFile_PreviewDragEnter(object sender, DragEventArgs e)
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
        private void txtInputFile_Drop(object sender, DragEventArgs e)
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

                txtInputFile.Text = filenames[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ShowPoints_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                ScenePoints points = SceneFileReader.ParsePointsFile(txtInputFile.Text);
                if (points.Materials.Length == 0 || points.Points.Length == 0)
                {
                    MessageBox.Show("The file was incomplete", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                #region draw

                Point3D center = Math3D.GetCenter(points.Points.Select(o => o.Hit).ToArray());

                var colors = UtilityWPF.GetRandomColors(points.Materials.Length, 128, 225);

                var window = new Debug3DWindow();

                var sizes = Debug3DWindow.GetDrawSizes(points.Points.Select(o => o.Hit), center);

                window.AddAxisLines(12, sizes.line / 4);

                foreach (var byMaterial in points.Points.ToLookup(o => o.MaterialIndex))
                {
                    window.AddDots(byMaterial.Select(o => o.Hit - center), sizes.dot / 3, colors[byMaterial.First().MaterialIndex]);
                }

                if (chkShowNormals.IsChecked.Value)
                {
                    var lines = points.Points.
                        Select(o => o with { Hit = (o.Hit - center).ToPoint() }).
                        Select(o => (o.Hit, o.Hit + o.Normal));

                    window.AddLines(lines, sizes.line / 6, Colors.Chartreuse);
                }

                window.Show();

                #endregion
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void ShowFaces_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                ScenePoints points = SceneFileReader.ParsePointsFile(txtInputFile.Text);
                if (points.Materials.Length == 0 || points.Points.Length == 0)
                {
                    MessageBox.Show("The file was incomplete", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                SceneFace_Points faces = PointsToPlanes.ConvertToFaces(points);

                #region draw

                foreach (var byMaterial in faces.Faces.ToLookup(o => o.MaterialIndex).OrderBy(o => o.Count()))
                {
                    var window = new Debug3DWindow()
                    {
                        Title = faces.Materials[byMaterial.Key],
                    };

                    Point3D center = Math3D.GetCenter(byMaterial.SelectMany(o => o.ContainedPoints).ToArray());

                    var colors = UtilityWPF.GetRandomColors(byMaterial.Count(), 128, 225);

                    var sizes = Debug3DWindow.GetDrawSizes(byMaterial.SelectMany(o => o.ContainedPoints), center);

                    window.AddAxisLines(12, sizes.line);

                    int index = 0;
                    foreach (var face in byMaterial)
                    {
                        window.AddDots(face.ContainedPoints.Select(o => o - center), sizes.dot, colors[index]);

                        if (chkShowNormals.IsChecked.Value)
                        {
                            window.AddLine(face.Center - center, (face.Center - center) + face.Normal, sizes.line, Colors.Chartreuse);
                        }

                        index++;
                    }

                    window.Show();
                }

                #endregion
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void ShowFacePolygons_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                // Read from the file
                ScenePoints points = SceneFileReader.ParsePointsFile(txtInputFile.Text);
                if (points.Materials.Length == 0 || points.Points.Length == 0)
                {
                    MessageBox.Show("The file was incomplete", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                // Center around origin
                Point3D center = Math3D.GetCenter(points.Points.Select(o => o.Hit).ToArray());

                points = points with
                {
                    Points = points.Points.
                        Select(o => o with { Hit = (o.Hit - center).ToPoint() }).
                        ToArray(),
                };

                center = new Point3D(0, 0, 0);

                // Convert into polygons
                SceneFace_Points faces_point = PointsToPlanes.ConvertToFaces(points);
                SceneFace_Polygons faces_polygon = FacePlanesToPolygons.ConvertToPolygons(faces_point);

                #region draw

                Random rand = StaticRandom.GetRandomForThread();

                var colors = UtilityWPF.GetRandomColors(faces_polygon.Materials.Length, 128, 225).
                    Select(o => UtilityWPF.RGBtoHSV(o)).
                    ToArray();

                var window = new Debug3DWindow();

                var sizes = Debug3DWindow.GetDrawSizes(points.Points.Select(o => o.Hit));

                window.AddAxisLines(12, sizes.line / 4);

                foreach (var face in faces_polygon.Faces)
                {
                    ColorHSV color = new ColorHSV(
                        rand.NextDrift(colors[face.MaterialIndex].H, 16),
                        rand.NextDrift(colors[face.MaterialIndex].S, 4),
                        rand.NextDrift(colors[face.MaterialIndex].V, 4));

                    var mesh = UtilityWPF.GetMeshFromTriangles(face.Mesh);

                    window.AddMesh(mesh, color.ToRGB());

                    if (chkShowPerimiterLines.IsChecked.Value)
                    {
                        var perimiterLines = face.Edges.
                            Select(o => mesh.Positions[o]);

                        window.AddLines(perimiterLines, sizes.line / 12, new ColorHSV(color.H, color.S + 5, color.V + 10).ToRGB());
                    }

                    if (chkShowNormals.IsChecked.Value)
                    {
                        window.AddLine(face.Center, face.Center + face.Normal, sizes.line / 12, Colors.Chartreuse);
                    }
                }

                window.Show();

                #endregion
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void PointsToPolygons_Points_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                CallTester(txtInputFile, Title, Tester_PointsToPolygons.JustPoints);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PointsToPolygons_Basic_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                CallTester(txtInputFile, Title, Tester_PointsToPolygons.Grid_Basic);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PointsToPolygons_Boundries_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                CallTester(txtInputFile, Title, Tester_PointsToPolygons.Grid_Boundries);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PointsToPolygons_Islands_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                CallTester(txtInputFile, Title, Tester_PointsToPolygons.Grid_Islands);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void PointsToPolygons_LowPopulation_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                CallTester(txtInputFile, Title, Tester_PointsToPolygons.Grid_LowPopulation);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void RandomCirclePoints_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                MiscTests.RandomCirclePoints();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private static void CallTester(TextBox textbox, string title, Action<Face3D_Points, string> method)
        {
            if (textbox.Text == "")
            {
                MessageBox.Show("Please select a file", title, MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            string[] filenames;
            if (System.IO.File.Exists(textbox.Text))
            {
                filenames = new[] { textbox.Text };
            }
            else if (System.IO.Directory.Exists(textbox.Text))
            {
                filenames = System.IO.Directory.GetFiles(textbox.Text);
            }
            else
            {
                MessageBox.Show("Invalid file/folder", title, MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            foreach (string filename in filenames)
            {
                Face3D_Points face = System.Text.Json.JsonSerializer.Deserialize<Face3D_Points>(System.IO.File.ReadAllText(filename));

                // Center it on zero to make visualizations easier
                face = face with
                {
                    Center = new Point3D(0, 0, 0),
                    ContainedPoints = face.ContainedPoints.
                        Select(o => (o - face.Center).ToPoint()).
                        ToArray(),
                };

                method(face, System.IO.Path.GetFileName(filename));
            }

        }

        #endregion
    }
}
