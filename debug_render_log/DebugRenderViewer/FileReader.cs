using DebugRenderViewer.Models;
using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Media3D;

namespace DebugRenderViewer
{
    public static class FileReader
    {
        #region deserialize classes

        // These are copies of the public models, but the types are changed to be able to be directly deserialized

        // An alternative would have been to parse as a document, but that looked like a lot unnecessary work
        //  var doc = JsonDocument.Parse(jsonString);
        //  doc.RootElement

        private record LogScene_local
        {
            public Category_local[] categories { get; init; }
            public LogFrame_local[] frames { get; init; }
            public Text_local[] text { get; init; }
        }

        private record Category_local
        {
            public string name { get; init; }
            public string color { get; init; }
            public double? size_mult { get; init; }
        }

        private record LogFrame_local
        {
            public string name { get; init; }
            public string back_color { get; init; }
            public Item_local[] items { get; init; }
            public Text_local[] text { get; init; }
        }

        /// <summary>
        /// The model has base and derived classes.  The type can be inferred by which property
        /// names are populated, so defining a single type here
        /// 
        /// Also, the vectors are stored as comma delimited strings
        /// </summary>
        private record Item_local
        {
            // -------------------- base --------------------
            public string category_key { get; init; }       //NOTE: The json will just be populate this property
            public string color { get; init; }
            public double? size_mult { get; init; }
            public string tooltip { get; init; }

            // ------------------- circle -------------------
            public string center { get; init; }
            public string normal { get; init; }
            public double? radius { get; init; }

            // -------------------- dot ---------------------
            public string position { get; init; }

            // -------------------- line --------------------
            public string point1 { get; init; }
            public string point2 { get; init; }

            // ------------------- square -------------------
            //public string center { get; init; }
            //public string normal { get; init; }
            public double? size_x { get; init; }
            public double? size_y { get; init; }
        }

        public record Text_local
        {
            public string text { get; init; }
            public string color { get; init; }
            public double? fontsize_mult { get; init; }
        }

        #endregion

        public static LogScene ParseJSON(string jsonString)
        {
            var intermediate = JsonSerializer.Deserialize<LogScene_local>(jsonString);

            var categories = intermediate.categories.
                Select(o => ConvertCategory(o)).
                ToArray();

            return new LogScene()
            {
                categories = categories,

                frames = intermediate.frames.
                    Select(o => ConvertFrame(o, categories)).
                    ToArray(),

                text = intermediate.text.
                    Select(o => ConvertText(o)).
                    ToArray(),
            };
        }

        #region Private Methods

        private static Category ConvertCategory(Category_local cat)
        {
            return new Category()
            {
                name = cat.name,
                color = ConvertColor(cat.color),
                size_mult = cat.size_mult,
            };
        }

        private static LogFrame ConvertFrame(LogFrame_local frame, Category[] categories)
        {
            return new LogFrame()
            {
                name = frame.name,

                back_color = ConvertColor(frame.back_color),

                items = frame.items.
                    Select(o => ConvertItem(o, categories)).
                    ToArray(),

                text = frame.text.
                    Select(o => ConvertText(o)).
                    ToArray(),
            };
        }

        private static ItemBase ConvertItem(Item_local item, Category[] categories)
        {
            ItemBase retVal = null;

            // Figure out and instantiate derived type
            if (!string.IsNullOrEmpty(item.position))
            {
                retVal = new ItemDot()
                {
                    position = ConvertPoint(item.position),
                };
            }
            else if(!string.IsNullOrEmpty(item.point1))
            {
                retVal = new ItemLine()
                {
                    point1 = ConvertPoint(item.point1),
                    point2 = ConvertPoint(item.point2),
                };
            }
            else if(item.radius != null)
            {
                retVal = new ItemCircle()
                {
                    center = ConvertPoint(item.center),
                    normal = ConvertVector(item.normal),
                    radius = item.radius.Value,
                };
            }
            else if(item.size_x != null)
            {
                retVal = new ItemSquare()
                {
                    center = ConvertPoint(item.center),
                    normal = ConvertVector(item.normal),
                    size_x = item.size_x.Value,
                    size_y = item.size_y.Value,
                };
            }
            else
            {
                throw new ApplicationException("Unkown item type:\r\n" + JsonSerializer.Serialize(item));
            }

            // Fill in the base properties
            retVal = retVal with
            {
                category_key = item.category_key,
                category = FindCategory(categories, item.category_key),

                color = ConvertColor(item.color),

                size_mult = item.size_mult,

                tooltip = item.tooltip,
            };

            return retVal;
        }

        private static Text ConvertText(Text_local text)
        {
            return new Text()
            {
                color = ConvertColor(text.color),
                fontsize_mult = text.fontsize_mult,
                text = text.text,
            };
        }

        private static Color? ConvertColor(string color)
        {
            if (string.IsNullOrWhiteSpace(color))
                return null;

            return UtilityWPF.ColorFromHex(color);
        }

        private static Point3D ConvertPoint(string position)
        {
            string[] split = position.Split(",");

            return new Point3D(Convert.ToDouble(split[0].Trim()), Convert.ToDouble(split[1].Trim()), Convert.ToDouble(split[2].Trim()));
        }
        private static Vector3D ConvertVector(string direction)
        {
            return ConvertPoint(direction).ToVector();
        }

        private static Category FindCategory(Category[] categories, string name)
        {
            if (string.IsNullOrWhiteSpace(name) || categories == null)
                return null;

            return categories.
                FirstOrDefault(o => o.name == name);        // case sensitive
        }

        #endregion
    }
}
