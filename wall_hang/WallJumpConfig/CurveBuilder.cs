using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using WallJumpConfig.Models.viewmodels;

namespace WallJumpConfig
{
    public static class CurveBuilder
    {
        public static KeyValuePair<double, double>[] GetPoints_HorizontalProps_Degrees(VM_Horizontal horizontal, Func<VM_PropsAtAngle, double> getValue)
        {
            var retVal = new List<KeyValuePair<double, double>>();

            retVal.Add(new KeyValuePair<double, double>(0, getValue(horizontal.PropsAtAngles[0])));

            for (int i = 0; i < horizontal.ExtraAngles.Count; i++)
            {
                retVal.Add(new KeyValuePair<double, double>(horizontal.ExtraAngles[i].Value, getValue(horizontal.PropsAtAngles[i + 1])));
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

        public static AnimationCurve ToAnimationCurve(KeyValuePair<double, double>[] points)
        {
            var retVal = new AnimationCurve();

            foreach (var point in points)
                retVal.AddKeyValue(point.Key, point.Value);

            return retVal;
        }
    }
}
