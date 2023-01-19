using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA_Horizontal
    {
        public SaveLUA_KeyValue[] percent_up { get; init; }
        public SaveLUA_KeyValue[] percent_along { get; init; }
        public SaveLUA_KeyValue[] percent_away { get; init; }

        public SaveLUA_KeyValue[] percent_at_speed { get; init; }

        public SaveLUA_KeyValue[] percent_look { get; init; }
        public SaveLUA_KeyValue[] percent_look_strength { get; init; }

        public SaveLUA_KeyValue[] yaw_turn { get; init; }

        public SaveLUA_KeyValue[] percent_latch_after_jump { get; init; }
        public SaveLUA_KeyValue[] relatch_time_seconds { get; init; }

        public SaveLUA_KeyValue[] wallattract_distance_max { get; init; }
        public SaveLUA_KeyValue[] wallattract_accel { get; init; }
        public SaveLUA_KeyValue[] wallattract_pow { get; init; }
        public SaveLUA_KeyValue[] wallattract_antigrav { get; init; }

        public double strength { get; init; }

        // ------------- Helper Methods -------------
        public static SaveLUA_Horizontal FromModel(SaveWPF_Horizontal model)
        {
            var to_lua = new Func<KeyValuePair<double, double>, SaveLUA_KeyValue>(o => new SaveLUA_KeyValue() { key = o.Key, value = o.Value });

            return new SaveLUA_Horizontal()
            {
                percent_up = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_Up).
                    Select(o => to_lua(o)).
                    ToArray(),

                percent_along = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_Along).
                    Select(o => to_lua(o)).
                    ToArray(),

                percent_away = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_Away).
                    Select(o => to_lua(o)).
                    ToArray(),

                percent_at_speed = GetPercentAtSpeed(model.Speed_FullStrength, model.Speed_ZeroStrength),

                percent_look = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_Look).
                    Select(o => to_lua(o)).
                    ToArray(),

                percent_look_strength = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_LookStrength).
                    Select(o => to_lua(o)).
                    ToArray(),

                yaw_turn = CurveBuilder.BuildYawTurn_DotProduct_Radians(CurveBuilder.GetPoints_HorizontalProps_Degrees(model, o => o.Percent_YawTurn)).
                    Select(o => to_lua(o)).
                    ToArray(),

                percent_latch_after_jump = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.Percent_LatchAfterJump).
                    Select(o => to_lua(o)).
                    ToArray(),

                relatch_time_seconds = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.RelatchTime_Emoseconds / (12 * 12 * 12)).       // converting emoseconds to seconds (base 12 1000s)
                    Select(o => to_lua(o)).
                    ToArray(),

                wallattract_distance_max = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.WallAttract_DistanceMax).
                    Select(o => to_lua(o)).
                    ToArray(),

                wallattract_accel = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.WallAttract_Accel).
                    Select(o => to_lua(o)).
                    ToArray(),

                wallattract_pow = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.WallAttract_Pow).
                    Select(o => to_lua(o)).
                    ToArray(),

                wallattract_antigrav = CurveBuilder.GetPoints_HorizontalProps_DotProducts(model, o => o.WallAttract_Antigrav).
                    Select(o => to_lua(o)).
                    ToArray(),

                strength = model.Strength,
            };
        }

        public static SaveLUA_KeyValue[] GetPercentAtSpeed(double speed_full, double speed_zero)
        {
            return new (double speed, double percent)[]
            {
                (0, 1),
                (speed_full, 1),
                (speed_zero, 0),
                (speed_zero * 2, 0),
            }.
            Select(o => new SaveLUA_KeyValue()
            {
                key = o.speed,
                value = o.percent,
            }).
            ToArray();
        }
    }
}
