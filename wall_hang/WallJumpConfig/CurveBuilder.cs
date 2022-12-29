using Game.Core;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using WallJumpConfig.Models.savewpf;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public static class CurveBuilder
    {
        public static KeyValuePair<double, double>[] GetPoints_HorizontalProps_Degrees(VM_Horizontal horizontal, Func<VM_PropsAtAngle, double> getValue)
        {
            var retVal = new List<KeyValuePair<double, double>>();

            retVal.Add(new KeyValuePair<double, double>(0, getValue(horizontal.PropsAtAngles[0])));
            double prev_angle = 0;

            for (int i = 0; i < horizontal.ExtraAngles.Count; i++)
            {
                double angle = Math.Max(prev_angle, horizontal.ExtraAngles[i].Value);
                prev_angle = angle;

                retVal.Add(new KeyValuePair<double, double>(angle, getValue(horizontal.PropsAtAngles[i + 1])));
            }

            retVal.Add(new KeyValuePair<double, double>(180, getValue(horizontal.PropsAtAngles[^1])));

            return retVal.ToArray();
        }
        public static KeyValuePair<double, double>[] GetPoints_HorizontalProps_DotProducts(VM_Horizontal horizontal, Func<VM_PropsAtAngle, double> getValue)
        {
            return GetPoints_HorizontalProps_Degrees(horizontal, getValue).
                Select(o => new KeyValuePair<double, double>(Math1D.Degrees_to_Dot(180 - o.Key), o.Value)).     // 180 because looking at the wall is 180 degrees (look dot wall normal)
                ToArray();
        }

        public static KeyValuePair<double, double>[] GetPoints_HorizontalProps_Degrees(SaveWPF_Horizontal horizontal, Func<PropsAtAngle, double> getValue)
        {
            var retVal = new List<KeyValuePair<double, double>>();

            retVal.Add(new KeyValuePair<double, double>(0, getValue(horizontal.Props_DirectFaceWall)));
            double prev_angle = 0;

            for (int i = 0; i < horizontal.Degrees_Extra.Length; i++)
            {
                double angle = Math.Max(prev_angle, horizontal.Degrees_Extra[i].Degrees);
                prev_angle = angle;

                retVal.Add(new KeyValuePair<double, double>(angle, getValue(horizontal.Props_Extra[i])));
            }

            retVal.Add(new KeyValuePair<double, double>(180, getValue(horizontal.Props_DirectAway)));

            return retVal.ToArray();
        }
        public static KeyValuePair<double, double>[] GetPoints_HorizontalProps_DotProducts(SaveWPF_Horizontal horizontal, Func<PropsAtAngle, double> getValue)
        {
            return GetPoints_HorizontalProps_Degrees(horizontal, getValue).
                Select(o => new KeyValuePair<double, double>(Math1D.Degrees_to_Dot(180 - o.Key), o.Value)).     // 180 because looking at the wall is 180 degrees (look dot wall normal)
                ToArray();
        }

        // The wpf preset just needs raw slider values, but the final code that uses yawturn mapping needs a map from
        // input angle to delta output angle (instead of input angle to percent)
        public static KeyValuePair<double, double>[] BuildYawTurn_Degrees(KeyValuePair<double, double>[] percents_degrees)
        {
            const int COUNT = 36;

            AnimationCurve curve = ToAnimationCurve(percents_degrees);

            var angles = new List<double>();
            angles.AddRange(percents_degrees.Select(o => o.Key));
            angles.AddRange(Enumerable.Range(0, COUNT).Select(o => UtilityMath.GetScaledValue(0, 180, 0, COUNT - 1, o)));

            return angles.
                Distinct((o1, o2) => o1.IsNearValue(o2)).
                OrderBy(o => o).
                Select(o =>
                {
                    double percent = curve.Evaluate(o);

                    if (percent.IsNearZero())
                        return new KeyValuePair<double, double>(o, 0);

                    double diff = percent > 0 ?
                        180 - o :
                        o;      // if percent is negative, then go backward (percent of -1 would put them at zero degrees).  Setting diff to positive instead of negative, because percent is already negative (neg * neg would be pos)

                    return new KeyValuePair<double, double>(o, diff * percent);
                }).
                ToArray();
        }
        public static KeyValuePair<double, double>[] BuildYawTurn_DotProduct_Radians(KeyValuePair<double, double>[] percents_degrees)
        {
            //NOTE: map_degrees must be in degrees.  dot product conversion is done last
            return BuildYawTurn_Degrees(percents_degrees).
                Select(o => new KeyValuePair<double, double>(Math1D.Degrees_to_Dot(180 - o.Key), Math1D.DegreesToRadians(o.Value))).     // 180 because looking at the wall is 180 degrees (look dot wall normal)
                ToArray();
        }

        public static AnimationCurve ToAnimationCurve(KeyValuePair<double, double>[] points)
        {
            var retVal = new AnimationCurve();

            foreach (var point in points)
                retVal.AddKeyValue(point.Key, point.Value);

            return retVal;
        }
    }
}
