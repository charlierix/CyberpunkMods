using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WallJumpConfig.Models.savewpf;

namespace WallJumpConfig.Models.savelua
{
    public record SaveLUA_Vertical_StraightUp
    {
        public SaveLUA_KeyValue[] percent { get; init; }

        public SaveLUA_KeyValue[] percent_vert_whenup { get; init; }
        public SaveLUA_KeyValue[] percent_horz_whenup { get; init; }        // this controls horizontal, but is only needed when they are looking straight up

        public SaveLUA_KeyValue[] percent_at_speed { get; init; }

        public double strength { get; init; }

        public bool latch_after_jump { get; init; }
        public double wallattract_distance_max { get; init; }
        public double wallattract_accel { get; init; }
        public double wallattract_pow { get; init; }
        public double wallattract_antigrav { get; init; }

        // ------------- Helper Methods -------------
        public static SaveLUA_Vertical_StraightUp FromModel(SaveWPF_Vertical_StraightUp model, SaveWPF_Horizontal model_horz)
        {
            return new SaveLUA_Vertical_StraightUp()
            {
                percent = GetPercent(model),

                percent_vert_whenup = GetPercentsWhenUp_Vert(model_horz),
                percent_horz_whenup = GetPercentsWhenUp_Horz(model_horz),

                percent_at_speed = SaveLUA_Horizontal.GetPercentAtSpeed(model.Speed_FullStrength, model.Speed_ZeroStrength),

                strength = model.Strength,

                latch_after_jump = model.LatchAfterJump,
                wallattract_distance_max = model.WallAttract_DistanceMax,
                wallattract_accel = model.WallAttract_Accel,
                wallattract_pow = model.WallAttract_Pow,
                wallattract_antigrav = model.WallAttract_Antigrav,
            };
        }

        private static SaveLUA_KeyValue[] GetPercent(SaveWPF_Vertical_StraightUp model)
        {
            // In the game, it uses a dot product (look dot up).  In the config editor, horizontal is 0 and up is 90

            double vertAngle = 90 - model.Degrees_StraightUp;
            double vertAngle_stop = 90 - Math1D.Avg(model.Degrees_StraightUp, model.Degrees_Standard);
            double vertAngle_stand = 90 - model.Degrees_Standard;

            return new (double degree, double value)[]
            {
                (0, 1),     // straight up
                (vertAngle, 1),     // the lowest the angle can be to still be full percent
                (vertAngle_stop, 0),        // where percent is zero
                (vertAngle_stand, 0),       // an extra point to force the curve to be S shaped
            }.
            Select(o => new SaveLUA_KeyValue()
            {
                key = Math1D.Degrees_to_Dot(o.degree),
                value = o.value,
            }).
            ToArray();
        }

        private static SaveLUA_KeyValue[] GetPercentsWhenUp_Vert(SaveWPF_Horizontal model_horz)
        {
            var angles = GetHorzAngles(model_horz);

            return new (double degree, double percent)[]
            {
                (0, 1),     // looking straight at the wall
                (angles.face_wall, 1),       // the start of the transition
                (angles.half, 0),      // halfway between, should be zero
                (angles.face_away, 0),     // an extra point to force the curve to be S shaped
                (180, 0),       // looking directly away from the wall (shouldn't be needed, just so there's no assumptions)
            }.
            Select(o => new SaveLUA_KeyValue()
            {
                key = Math1D.Degrees_to_Dot(180 - o.degree),        // 180 because looking at the wall is 180 degrees (look dot wall normal)
                value = o.percent,
            }).
            ToArray();
        }
        private static SaveLUA_KeyValue[] GetPercentsWhenUp_Horz(SaveWPF_Horizontal model_horz)
        {
            var angles = GetHorzAngles(model_horz);

            return new (double degree, double percent)[]
            {
                (0, 0),     // looking straight at the wall (shouldn't be needed, just so there's no assumptions)
                (angles.face_wall, 0),       // an extra point to force the curve to be S shaped
                (angles.half, 0),      // halfway between, should be zero
                (angles.face_away, 1),     // the start of the transition
                (Math1D.Avg(angles.face_away, 180), 1),
                (180, 1),       // looking directly away from the wall 
            }.
            Select(o => new SaveLUA_KeyValue()
            {
                key = Math1D.Degrees_to_Dot(180 - o.degree),        // 180 because looking at the wall is 180 degrees (look dot wall normal)
                value = o.percent,
            }).
            ToArray();
        }

        private static (double face_wall, double face_away, double half) GetHorzAngles(SaveWPF_Horizontal model)
        {
            const double MAX_FACEWALL = 45;
            const double MAX_FACEAWAY = 90;

            double face_wall = model.Degrees_Extra.Length > 0 && model.Degrees_Extra[0].Degrees < MAX_FACEWALL ?
                model.Degrees_Extra[0].Degrees :
                MAX_FACEWALL;

            double face_away = model.Degrees_Extra.Length > 1 && model.Degrees_Extra[1].Degrees < MAX_FACEAWAY ?
                model.Degrees_Extra[1].Degrees :
                MAX_FACEAWAY;

            return (face_wall, face_away, Math1D.Avg(face_wall, face_away));
        }
    }
}
