local this = {}

SwingPropsOverride = {}

-- may want to keep track of when forward and back are held in
-- back would affect air resistance and possibly anti gravity

local MULT_BOOST = 1
local MULT_NONBOOST = -1

function SwingPropsOverride:new(o)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o

    -- Increased when they apply boost, decays over time.  Used to determine air resistance
    obj.charge = 0

    obj.boost_tracker = RollingBuffer:new(6)
    for i = 1, obj.boost_tracker:GetSize(), 1 do        -- prime it up front to save a bunch of if statements each frame
        obj.boost_tracker:Add(false)
    end
    obj.is_boosting = false

    return obj
end

function SwingPropsOverride:Tick(deltaTime)
    local is_boosting = this.AdjustBoostTracking(self)

    if not is_boosting and IsNearZero(self.charge) then
        self.charge = 0
        do return end
    end

    if is_boosting then
        self.charge = this.IncreaseCharge(self.charge, deltaTime)
    else
        self.charge = this.DecreaseCharge(self.charge, deltaTime)
    end
end

function SwingPropsOverride:Clear()
    self.charge = 0
    self.is_boosting = false
end

-- Called each frame that boost is being applied.  This will potentially get blipped each time they kick off a
-- new swing.  It's the long presses that matter
function SwingPropsOverride:BoostApplied()
    self.is_boosting = true
end

----------------------------------- Private Methods -----------------------------------

-- This smooths is_boosting over a few frames.  Every time they initiate a swing, there is a chance for boost to be applied for a frame
-- or two, since it's applied by holding in the keys
function this.AdjustBoostTracking(obj)
    obj.boost_tracker:Add(obj.is_boosting)
    obj.is_boosting = false     -- this will get set to true each frame from BoostApplied()

    local count = 0

    -- The constructor filled this buffer with false, so it's safe to just iterate the whole array
    for i = 2, #obj.boost_tracker, 1 do     -- since the entire list is being iterated, just look at each element directly, regardless which of them is the latest or oldest
        if obj.boost_tracker[i] then      
            count = count + 1
        end
    end

    return count / obj.boost_tracker:GetSize() >= 0.5
end

function this.IncreaseCharge(charge, deltaTime)
    -- This is using the equation for charging up a capacitor.  As the capacitor charges up, the amount of current decreases,
    -- so it charges fast at first, and slow
    -- (assuming constant voltage, resistance, capacitance)

    -- When you search for the equation online, they are written in a form that is easy to graph: y=f(x).  This function is
    -- charge based on current charge and a small delta time of charging

    -- Q(t) = Q(0) * e ^ (-t / (RC)) + I * R * (1 - e ^ (-t / (RC)))

    local resistance = 1        -- it seems like resistance should be how fast it charges, but it seems to affect max charge
    local current = 1     -- current slows it down, but I think it also caps the max
    local capacitance = 1

    local mult = 0.35      -- the easiest way to change how fast or slow it charges is to play with time

    local exp = 2.7182818 ^ (-(deltaTime * mult) / (resistance * capacitance))

    return charge * exp + current * resistance * (1 - exp)
end
function this.DecreaseCharge(charge, deltaTime)
    if charge < 0 or IsNearZero(charge) then
        return 0

    elseif charge > 1 then      -- should never happen
        return 1

    elseif IsNearValue(charge, 1) then
        return charge * 0.999 * deltaTime        -- sqrt of 1 is 1, so just reduce is linearly a bit
    end

    local power = 1.3     -- needs to be greater than 1, since between 0 and 1, squared is a smaller number
    local mult = 1

    local retain_percent = 1 - ((1 - charge) ^ power)
    local delta = charge - (charge * retain_percent)
    local retVal = charge - (delta * mult * deltaTime)

    if retVal < 0 then
        retVal = 0
    end

    return retVal
end