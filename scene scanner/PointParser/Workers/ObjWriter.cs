using Game.Core;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using PointParser.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace PointParser.Workers
{
    public static class ObjWriter
    {
        #region record: Options

        public record Options
        {
            public bool DoubleSidedFaces { get; init; }
            public bool RandColorPerPoly { get; init; }
            public string CustomName { get; init; }
            public MaterialColors MaterialColors { get; init; }
        }

        #endregion

        #region record: Definition

        private record Definition
        {
            public Vertex[] Vertices { get; init; }

            public Face[] Faces { get; init; }

            public Mat[] Materials { get; init; }
        }

        #endregion
        #region record: Mat

        /// <summary>
        /// This material is the .obj and .mtl file's definition of material
        /// </summary>
        private record Mat      // wpf already has a Material class
        {
            public string Name { get; init; }
            public Color Color { get; init; }       // this can be semitransparent
        }

        #endregion
        #region record: Face

        private record Face
        {
            public int MaterialIndex { get; init; }     // this is zero based, since it's pointing to a private list
            public (int v1, int v2, int v3)[] Triangles { get; init; }      // these indices are one based
        }

        #endregion
        #region record: Vertex

        private record Vertex
        {
            public Point3D Point { get; init; }
            public Vector3D Normal { get; init; }
        }

        #endregion

        #region record: BuildingDefinition

        private record BuildingDefinition
        {
            public List<Mat> Materials { get; init; }
            public List<Face> Faces { get; init; }
            public List<Vertex> Verticies { get; init; }
        }

        #endregion

        public static void Write(SceneFace_Polygons scene, string folder, string filename_obj, string filename_mtl, Options options)
        {
            var materialColors = FinishMaterialColors(scene, options.MaterialColors);

            var definition = CreateDefinition(scene, materialColors, options.RandColorPerPoly);

            Directory.CreateDirectory(folder);

            using (StreamWriter writer = new StreamWriter(filename_obj, false))
            {
                Write_Obj(writer, definition, Path.GetFileName(filename_mtl), options.CustomName, options.DoubleSidedFaces);
            }

            using (StreamWriter writer = new StreamWriter(filename_mtl, false))
            {
                Write_Mat(writer, definition);
            }
        }

        #region Private Methods

        /// <summary>
        /// This takes in a predefined mapping (or null), and returns random colors for any missing materials
        /// </summary>
        private static MaterialColors FinishMaterialColors(SceneFace_Polygons scene, MaterialColors materialColors)
        {
            if (materialColors == null)
                materialColors = new MaterialColors() { Map = new KeyValuePair<string, System.Windows.Media.Color>[0] };

            string[] materials_rand = scene.Materials.
                Except(materialColors.Map.Select(o => o.Key)).
                ToArray();

            var randoms = new KeyValuePair<string, Color>[0];

            if (materials_rand.Length > 0)
            {
                // Get random colors for unmapped materials.  The function tries to return unique colors, so passing
                // in the existing will force the returned colors to avoid those existing colors
                Color[] colors_rand = UtilityWPF.GetRandomColors(materials_rand.Length, 128, 225, materialColors.Map.Select(o => o.Value).ToArray());

                randoms = Enumerable.Range(0, materials_rand.Length).
                    Select(o => new KeyValuePair<string, Color>(materials_rand[o], colors_rand[o])).
                    ToArray();
            }

            return new MaterialColors()
            {
                Map = materialColors.Map.
                    Concat(randoms).
                    ToArray(),
            };
        }

        private static Definition CreateDefinition(SceneFace_Polygons scene, MaterialColors materialColors, bool randColorPerPoly)
        {
            var build = new BuildingDefinition()
            {
                Faces = new List<Face>(),
                Materials = new List<Mat>(),
                Verticies = new List<Vertex>(),
            };

            foreach (var scene_mat in scene.Faces.ToLookup(o => o.MaterialIndex))
            {
                // Add all the polygons tied to this material (input format's material, not .mtl material)
                CreateDefinition_Material(build, scene_mat, scene, materialColors, randColorPerPoly);
            }

            return new Definition()
            {
                Vertices = build.Verticies.ToArray(),
                Faces = build.Faces.ToArray(),
                Materials = build.Materials.ToArray(),
            };
        }
        private static void CreateDefinition_Material(BuildingDefinition build, IGrouping<int, Face3D_Polygon> scene_mat, SceneFace_Polygons scene, MaterialColors materialColors, bool randColorPerPoly)
        {
            string material_name = scene.Materials[scene_mat.Key];
            Color material_color = FindColor(material_name, materialColors);
            ColorHSV material_colorHSV = material_color.ToHSV();

            if (!randColorPerPoly)
            {
                // Same color for all polygons tied to this material
                build.Materials.Add(new Mat()
                {
                    Name = GetSafeName(material_name),
                    Color = material_color,
                });
            }

            foreach (var polygon in scene_mat)
            {
                if (randColorPerPoly)
                {
                    // Each polygon gets a slightly drifted version of the material color
                    build.Materials.Add(new Mat()
                    {
                        Name = GetSafeName(material_name) + $"_{build.Materials.Count}",
                        Color = new ColorHSV(
                            StaticRandom.NextDrift(material_colorHSV.H, 16),
                            StaticRandom.NextDrift(material_colorHSV.S, 4),
                            StaticRandom.NextDrift(material_colorHSV.V, 4)).
                            ToRGB(),
                    });
                }

                CreateDefinition_Polygon(build, polygon);
            }
        }
        private static void CreateDefinition_Polygon(BuildingDefinition build, Face3D_Polygon polygon)
        {
            if (!ValidateSamePoints(polygon.Mesh))
                throw new ApplicationException("polygon's triangles don't all reference the same points");

            int offset = build.Verticies.Count + 1;     // .obj is one based

            build.Verticies.AddRange(polygon.Mesh[0].AllPoints.
                Select(o => new Vertex()
                {
                    Normal = polygon.Normal,
                    Point = o,
                }));

            build.Faces.Add(new Face()
            {
                MaterialIndex = build.Materials.Count - 1,
                Triangles = polygon.Mesh.
                    Select(o => (o.Index0 + offset, o.Index1 + offset, o.Index2 + offset)).
                    ToArray(),
            });
        }

        private static bool ValidateSamePoints(ITriangleIndexed_wpf[] mesh)
        {
            for (int outer = 1; outer < mesh.Length; outer++)
            {
                if (mesh[0].AllPoints.Length != mesh[outer].AllPoints.Length)
                    return false;

                for (int inner = 0; inner < mesh[0].AllPoints.Length; inner++)
                {
                    if (!mesh[0].AllPoints[inner].IsNearValue(mesh[outer].AllPoints[inner]))
                        return false;
                }
            }

            return true;
        }

        private static void Write_Obj(StreamWriter writer, Definition def, string mat_filename, string customName, bool doubleSidedFaces)
        {
            writer.WriteLine("# Cyberpunk 2077 Scene Scan Recreation Tool");

            writer.WriteLine($"mtllib {mat_filename}");

            if (string.IsNullOrWhiteSpace(customName))
                writer.WriteLine("o scene");
            else
                writer.WriteLine($"o {GetSafeName(customName.Trim())}");

            foreach (var vertex in def.Vertices)
            {
                writer.Write("v ");
                writer.WriteLine(VectorString(vertex.Point));
            }

            foreach (var vertex in def.Vertices)
            {
                writer.Write("vn ");
                writer.WriteLine(VectorString(vertex.Normal));
            }

            if (doubleSidedFaces)       // putting these after the other normals, so a simple offset can be used
            {
                foreach (var vertex in def.Vertices)
                {
                    writer.Write("vn ");
                    writer.WriteLine(VectorString(-vertex.Normal));
                }
            }

            int materialIndex = -1;

            foreach (var face in def.Faces)     // these are ordered by material
            {
                if (face.MaterialIndex != materialIndex)
                {
                    materialIndex = face.MaterialIndex;

                    writer.WriteLine($"usemtl {def.Materials[face.MaterialIndex].Name}");
                    writer.WriteLine("s off");      // this will disable smooth shading
                }

                foreach (var triangle in face.Triangles)
                {
                    // this example is v/vt/vn
                    //f 48414/2016/2021 48410/2017/2022 48418/2018/2023

                    // since this project doesn't deal with textures, it's just
                    //f v1//vn1 v2//vn2 v3//vn3 ...
                    writer.WriteLine(string.Format("f {0}//{0} {1}//{1} {2}//{2}", triangle.v1.ToString(), triangle.v2.ToString(), triangle.v3.ToString()));
                }

                if (doubleSidedFaces)
                {
                    foreach (var triangle in face.Triangles)
                    {
                        // Reusing the points, but pointing to the set of opposite facing normals
                        writer.WriteLine(string.Format(
                            "f {0}//{3} {1}//{4} {2}//{5}",
                            triangle.v1.ToString(),
                            triangle.v3.ToString(),     //NOTE: that 3 and 2 are reversed, just in case right hand rule is used by the app that reads this file
                            triangle.v2.ToString(),
                            (def.Vertices.Length + triangle.v1).ToString(),
                            (def.Vertices.Length + triangle.v3).ToString(),
                            (def.Vertices.Length + triangle.v2).ToString()));
                    }
                }
            }
        }
        private static void Write_Mat(StreamWriter writer, Definition def)
        {
            writer.WriteLine($"#Material Count: {def.Materials.Length}");

            foreach (var material in def.Materials)
            {
                writer.WriteLine("");

                writer.WriteLine($"newmtl {material.Name}");

                writer.WriteLine("Ka 1.000000 1.000000 1.000000");      // ambient, not sure when this would be something besides 1's

                writer.WriteLine($"Kd {ColorString(material.Color)}");      // diffuse

                writer.WriteLine($"d {OpacityString(material.Color)}");     // 1 is opaque, 0 is transparent

                writer.WriteLine("illum 2");        // illumination, see if this can be left out
            }
        }

        /// <summary>
        /// Returns the color, or magenta
        /// </summary>
        private static Color FindColor(string material, MaterialColors materialColors)
        {
            foreach (var pair in materialColors.Map)
            {
                if (pair.Key == material)
                    return pair.Value;
            }

            return Colors.Magenta;
        }

        private static string GetSafeName(string name)
        {
            // There doesn't seem to be a limitation defined, but to be safe, only include alphanumeric and underscore
            return Regex.Replace(name, @"[^\w]", "_");
        }

        private static string OpacityString(Color color)
        {
            return DoubleString(color.A / 255d);
        }
        private static string ColorString(Color color)
        {
            return $"{DoubleString(color.R / 255d)} {DoubleString(color.G / 255d)} {DoubleString(color.B / 255d)}";
        }
        private static string VectorString(Point3D point)
        {
            return $"{DoubleString(point.X)} {DoubleString(point.Y)} {DoubleString(point.Z)}";
        }
        private static string VectorString(Vector3D vector)
        {
            return $"{DoubleString(vector.X)} {DoubleString(vector.Y)} {DoubleString(vector.Z)}";
        }
        private static string DoubleString(double value)
        {
            return Math.Round(value, 6).ToString();
        }

        #endregion
    }
}
