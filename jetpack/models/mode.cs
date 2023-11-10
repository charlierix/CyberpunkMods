// See mode_defaults.lua for default values
public record Mode
{
    // ----------------------------------------------------------------
    // Only in the live version of the mode class (not the data class that gets serialized to/from json)
    public long mode_key { get; init; }
    // ----------------------------------------------------------------

    public string name { get; init; }

    public string description { get; init; }

    // Flight Method
    // True: Impulse based flight
    // False: Teleport based flight
    public bool useImpulse { get; init; }

    // Enum: see const in init.lua
    public thrust_sound_type sound_type { get; init; }

    // Only one of these two can be populated (or none)
    public double? timeDilation { get; init; }     // 0.0001 is frozen time, 1 is standard
    public TimeDilation_Gradient_Type timeDilation_gradient { get; init; }     // this defines bullet time based on abs(vel.z)

    public record TimeDilation_Gradient_Type
    {
        public double timeDilation_lowZSpeed { get; init; }        // the bullet time to use when z speed is lower than this
        public double lowZSpeed { get; init; }

        public double timeDilation_highZSpeed { get; init; }
        public double highZSpeed { get; init; }
    }

    public Jump_Land_Type jump_land { get; init; }
    public record Jump_Land_Type
    {
        public double holdJumpDelay { get; init; }      // how long to hold down the jump key to start flight

        public bool explosiveJumping { get; init; }     // this will ragdoll nearby NPCs when jumping from ground (a small force compared to landing)
        public bool explosiveLanding { get; init; }     // this will ragdoll nearby NPCs when landing

        // TODO: electric landing (applies the electric shock effect).  more notes in flightutil.ExplosivelyLand

        public bool shouldSafetyFire { get; init; }     // this detects when they are falling fast and close to the ground.  It will blip teleport to eliminate velocity and avoid death
    }

    public Accel_Type accel { get; init; }
    public record Accel_Type
    {
        public double gravity { get; init; }        // this is what the game uses for player's gravity (thrown items are -9.8)

        public double horz_stand { get; init; }     // standard is when you hold down a key (not dashing)
        public double horz_dash { get; init; }      // dash is when you tap then hold a direction
        public double vert_stand { get; init; }
        public double vert_dash { get; init; }

        public double? vert_initial { get; init; }  // a one time burst up when jetpack is first activated (only works when starting from the ground)
    }

    public Energy_Type energy { get; init; }
    public record Energy_Type
    {
        public double maxBurnTime { get; init; }        // seconds
        public double burnRate_dash { get; init; }      // uses up "energy" at this higher rate when dashing (energy being time left to burn the thrusters)
        public double burnRate_horz { get; init; }      // how much "energy" horizontal thruster firing uses
        public double recoveryRate { get; init; }       // how quickly "energy" recharges when not using thrust
    }

    public RotateVelocity_Type rotateVel { get; init; }
    public record RotateVelocity_Type
    {
        public bool is_used { get; init; }              // This should only be done in teleport based flight (non impulse).  This will pull the velocity to line up with the direction facing
        public double percent_horz { get; init; }       // How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
        public double percent_vert { get; init; }       // Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
        public double dotPow { get; init; }             // unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
        public double minSpeed { get; init; }           // the speed to start rotating velocity to look dir
        public double maxSpeed { get; init; }           // the speed is above this, percent will be at its max
    }

    // can be null
    public Rebound_Type rebound { get; init; }          // allows the player to bounce off the ground if they hit jump as they hit the ground
    public record Rebound_Type
    {
        public double percent_at_zero { get; init; }    // the percent of Z part of velocity to rebound with when speed along Z is zero
        public double percent_at_max { get; init; }     // the percent to use at a high impact speed
        public double speed_of_max { get; init; }       // the speed where percent_at_max should be applied.  Any speed higher than this will also use percent_at_max
    }



    // These are optional classes that do custom actions when corresponding button is pressed or held in
    // There are multiple possible types that it could be.  Live object instance will be different
    // than the data object's definition
    public object extra_rmb { get; init; }
    public object extra_key1 { get; init; }
    public object extra_key2 { get; init; }

    // ----------------------------------------------------------------
    // These are types that the extra_xxx props could be in the data class (serialized to json and stored in database)

    public record Extra_Hover_Type
    {
        public extra_type extra_type { get; init; }     // Enum: see const in init.lua
        public double mult { get; init; }
        public double accel_up { get; init; }
        public double accel_down { get; init; }
        public double burnRate { get; init; }
        public double holdDuration { get; init; }
    }

    public record Extra_PushUp_Type
    {
        public extra_type extra_type { get; init; }     // Enum: see const in init.lua
        public double force { get; init; }
        public double randHorz { get; init; }
        public double randVert { get; init; }
        public double burnRate { get; init; }
    }

    public record Extra_Dash_Type
    {
        public extra_type extra_type { get; init; }     // Enum: see const in init.lua
        public double acceleration { get; init; }
        public double burnRate { get; init; }
    }

    // ----------------------------------------------------------------
}