KeyDashTracker_Analog = {}

local this = {}

local PERCENT_LOW = 0.5
local PERCENT_HIGH = 0.8
local MAX_DOT_DIFF = 0.92

local PULL_DIR_RADIANS = math.pi / 8        -- how quickly to pull the dashing direction toward the current direction (per second)

local DASH_GAP = 0.33
local DASH_WAIT = 0.12

function KeyDashTracker_Analog:new(o, keys, debug)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.keys = keys
    obj.debug = debug

    obj.analog_x = 0
    obj.analog_y = 0

    obj.analog_len = 0

    obj.isDashing = false

    -- When they go into dash, this is the direction that the stick was pointing.  While in dash, it gets pulled
    -- toward the current thumbstick direction.  This dashing direction isn't the direction that they will be going,
    -- it's just used to verify that they don't swivel the thumbstick too quickly
    obj.dashing_dir_x = nil
    obj.dashing_dir_y = nil

    obj.prev_isHigh = false

    obj.time_high = 0
    obj.time_high_prev = 0
    obj.time_low = 0

    return obj
end

function KeyDashTracker_Analog:Tick(deltaTime)
    self.analog_x = self.keys.analog_x
    self.analog_y = self.keys.analog_y

    local lenSqr = GetVectorLength2DSqr(self.analog_x, self.analog_y)
    if IsNearZero(lenSqr) then
        self.analog_len = 0
    else
        self.analog_len = math.sqrt(lenSqr)
    end

    if self.isDashing then
        self:Tick_Dashing(deltaTime)
    else
        self:Tick_Standard()
    end

    self.prev_isHigh = self.analog_len >= PERCENT_HIGH
end

----------------------------------- Private Methods -----------------------------------

function KeyDashTracker_Analog:Tick_Standard()
    if self.analog_len < PERCENT_LOW then
        self.time_low = self.o.timer        -- remember this so that hovering the thumbstick at the PERCENT_HIGH doesn't accidentally start a dash (make them go high low high)
        do return end

    elseif self.analog_len < PERCENT_HIGH then
        do return end
    end

    if not self.prev_isHigh then
        -- Transitioning to above high.  Remember the time
        self.time_high_prev = self.time_high
        self.time_high = self.o.timer
    end

    if self.time_high - self.time_high_prev > DASH_GAP then
        -- They took too long between high pulses - no dash for you
        do return end

    elseif self.time_low < self.time_high_prev or self.time_low > self.time_high then
        -- They pulsed between high/nonhigh, but they didn't go high low high
        do return end
    end

    if self.o.timer - self.time_high < DASH_WAIT then
        -- Just need to wait a little before actually dashing
        do return end
    end

    -- Go into dashing mode
    self.isDashing = true

    self.dashing_dir_x = self.analog_x / self.analog_len
    self.dashing_dir_y = self.analog_y / self.analog_len
end

function KeyDashTracker_Analog:Tick_Dashing(deltaTime)
    if self.analog_len < PERCENT_HIGH then
        self.isDashing = false
        do return end
    end

    -- Create a unit vector for the direction they are pointing
    local dir_x = self.analog_x / self.analog_len
    local dir_y = self.analog_y / self.analog_len

    local dot = DotProduct2D(dir_x, dir_y, self.dashing_dir_x, self.dashing_dir_y)

    if math.abs(1 - dot) > MAX_DOT_DIFF then
        self.isDashing = false
        do return end
    end

    -- Need to drag the dashing direction toward the current direction
    local new_dir_x, new_dir_y = this.PullDashDir(dir_x, dir_y, self.dashing_dir_x, self.dashing_dir_y, dot, deltaTime)
    self.dashing_dir_x = new_dir_x
    self.dashing_dir_y = new_dir_y
end

function this.PullDashDir(dir_x, dir_y, prev_x, prev_y, dot, deltaTime)
    local max_pull = PULL_DIR_RADIANS * deltaTime

    -- Drag the dashing direction toward the current direction
    local delta_rads = Dot_to_Radians(dot)

    if delta_rads <= max_pull then
        return dir_x, dir_y
    end

    -- Need to convert radians into a signed value
    if CrossProduct2D(prev_x, prev_y, dir_x, dir_y) < 0 then        -- 2D cross product just returns Z, so 1 or -1 for unit vectors
        max_pull = -max_pull
    end

    -- Now rotate prev direction toward current direction
    return RotateVector2D(prev_x, prev_y, max_pull)
end