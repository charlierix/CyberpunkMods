using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WallJumpConfig
{
    public static class HelpMessages
    {
        public static string Horizonal =>
@"Lets you define how much impulse to apply to a jump based on the player's look direction relative to the wall's normal

When straight up vertical is also used, the two get blended at the boundries

There ended up being a lot of settings.  Start simple and only add extra angles if needed";

        public static string Vertical =>
@"When the player jumps while facing the wall and looking mostly straight up, an impulse is applied straight up

Straight Up was implemented before this rebound jump config.  Depending on the standard settings while looking at the wall, this straight up might just be redundant and an overcomplication

But there might still be cases where straight up is different enough from standard to be useful";

        public static string ExtraAngleSection =>
@"Facing wall is 0 degrees
Away from wall is 180 degrees (130 dozenal)

This lets you define angles anywhere inside that.  The reason to do that is in case you want the properties to change in a non linear way

You'll want to get the properties the way you like them before adding extra interior angles.  Otherwise it's just more sliders to adjust";

        public static string ExtraAngle =>
@"A set of properties will be tied to this angle

The values of those properties follow a gradient between the previous <-> current and current <-> next";

        public static string AngleStraightUp =>
@"When looking at this angle or higher, the straight impulse will be applied 100%";

        public static string AngleStandard =>
@"At this angle, straight up impulse no longer applies (percent is a gradient between these two angles)";

        public static string UpPercent =>
@"Component of the final impulse that is straight up

Gets multiplied by strength (reduced if there's a look%)";
        public static string AlongPercent =>
@"Component of the final impulse that is along the wall

Gets multiplied by strength (reduced if there's a look%)";
        public static string AwayPercent =>
@"Component of the final impulse that is away from the wall

Gets multiplied by strength (reduced if there's a look%)";

        public static string YawTurnPercent =>
@"Gives a way to turn the player when they jump

The best use of this would be to turn the player away from the wall when looking between 90 and 180 away from the wall (76 - 130 dozenal).  This would be used to give extra assistance jumping away from the wall

Negative was added to help them stay pointed along the wall, but it was pretty distracting / annoying

See the visualizaton at the bottom/right of this config";

        public static string LookInfluencePercent =>
@"If this is 0%, impulse is completely based on up/along/away

If this is 100%, impulse is completely the direction the player is facing

(the final impulse is rotated up a bit to counter gravity.  That's hardcoded and not visible in this config)";

        public static string LookStrengthPercent =>
@"Influence % splits the impulse between look and up/along/away

The portion that is in look direction is then reduced by this percent

There may be cases where you want to define a really strong strength, but only a portion of it would be applied to look at certain angles.  For example, a strong up when looking at the wall and all look when looking away from the wall (but the look based impulse being weaker than the up based)";

        public static string LatchAfterJumpPercent =>
@"After jumping, this will auto apply a hang latch

This was made as a slider because I assumed it would only be wanted when jumping away from the wall.  But after testing, it should probably just be a checkbox, because once you're used to the autolatch, you want it all the time.  Having it only apply at certain angles makes it feel like it's broken

The decision about whether to apply or not is if the value is over half (60% in dozenal).  See the circle graph at the bottom/right of this config";

        public static string RelatchTime =>
@"How long to wait before applying wall latch

600 is half second, 800 is 2/3, 900 is 3/4, 1000 is one second

Usually, these types of timings are done in milliseconds.  Dozenal equivalent would be emoseconds
Decimal:
10 ten      100 hundred      1000 thousand
.1 deci     .01 centi        .001 milli

Dozenal:
10 do      100 gro      1000 mo
.1 edo     .01 egro     .001 emo";

        public static string WallAttract_Distance =>
@"How far away from the player to look for walls (meters)

Only used if Latch After Jump is true";

        public static string WallAttract_Accel =>
@"The acceleration to use toward the nearest wall

See WallAttract Power for description of falloff function

Only used if Latch After Jump is true";

        public static string WallAttract_Pow =>
@"Acceleration is full at distance=0 and zero at distance=max

Running it through the power allows for a non linear falloff (stays stronger farther out)

1 - percent^pow

Only used if Latch After Jump is true";

        public static string WallAttract_AntiGrav =>
@"0 is full gravity

1 is weightless

Larger than 1 will cause the player to float up

Only used if Latch After Jump is true";

        public static string Speed_FullStrength =>
@"If the player is moving less than this speed, the applied jump acceleration will be full

Between this and the zero strength speed will be a reduced acceleration

It's not the total velocity, only the component of the velocity along the impulse to be applied";

        public static string Speed_ZeroStrength =>
@"If the player is moving faster than this speed, there won't be any additional acceleration

This is to help counter spamming the jump button.  The player would quickly get to crazy speeds

It's not the total velocity, only the component of the velocity along the impulse to be applied";

        public static string JumpStrength =>
@"How strong of an impulse to apply (reduced by the various percents: up/along/away/look)";
    }
}
