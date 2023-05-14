-- Ported from this c# version
-- https://gist.github.com/Flafla2/1a0b9ebef678bbce3215

local this = {}

local permutation = { 151,160,137,91,90,15,					                        -- Hash lookup table as defined by Ken Perlin.  This is a randomly
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,	-- arranged array of all numbers from 0-255 inclusive.
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180 }

local p = nil                                                                       -- Doubled permutation to avoid overflow

--- Runs perlin for each octave.  This will create more complex shapes (good for terrain, not sure what else
--- it what else octaves would be useful for)
---@param x number
---@param y number
---@param z number
---@param num_octaves integer Use a count greater than 1 (1 would just be the same as calling the underlying perlin function)
---@param persistence number? Affects the size of following octaves
---@return number result Sum of perlin calls at this point
function Perlin_Octaves(x, y, z, num_octaves, persistence)
    if not persistence then
        persistence = 1
    end

    local total = 0
    local frequency = 1
    local amplitude = 1

    for i = 1, num_octaves, 1 do
        total = total + Perlin(x * frequency, y * frequency, z * frequency) * amplitude

        amplitude = amplitude * persistence
        frequency = frequency * 2
    end

    return total
end

--- Takes in a 3D coord and returns a number from 0 to 1
---
--- The way to walk a perlin is to choose an initial random position and direction.  Then for some later time,
--- find the point to pass to perlin: pos + dir * elapsedtime
---
--- The magnitude of direction vector will change the frequency of perlin's output.  (try vector length 1 first)
---@param x number
---@param y number
---@param z number
---@return number 0 to 1
function Perlin(x, y, z)
    this.Initialize()

    -- Calculate the "unit cube" that the point asked will be located in The left bound is ( |_x_|,|_y_|,|_z_| )
    -- and the right bound is that plus 1.  Next we calculate the location (from 0.0 to 1.0) in that cube
    --int xi = (int)x & 255;
    --int yi = (int)y & 255;
    --int zi = (int)z & 255;
    --double xf = x - (int)x;
    --double yf = y - (int)y;
    --double zf = z - (int)z;

    -- This section replaces the above commented code.  It supports negative inputs
    local xi, yi, zi
    local xf, yf, zf

    if x < 0 then
        xi = 255 - bit32.band(ToInteger(-x), 255)
        xf = 1 + x - ToInteger(x)
    else
        xi = bit32.band(ToInteger(x), 255)
        xf = x - ToInteger(x)
    end

    if y < 0 then
        yi = 255 - bit32.band(ToInteger(-y), 255)
        yf = 1 + y - ToInteger(y);
    else
        yi = bit32.band(ToInteger(y), 255)
        yf = y - ToInteger(y)
    end

    if z < 0 then
        zi = 255 - bit32.band(ToInteger(-z), 255)
        zf = 1 + z - ToInteger(z)
    else
        zi = bit32.band(ToInteger(z), 255)
        zf = z - ToInteger(z)
    end

    -- Fade the location to smooth the result
    local u = this.Fade(xf)
    local v = this.Fade(yf)
    local w = this.Fade(zf)

    -- (the +1 everywhere is because lua arrays are 1 based.  this was copied from a c# port of perlin, which is 0 based)

    local a = p[xi+1] + yi                                  -- This here is Perlin's hash function.  We take our x value (remember,
    local aa = p[a+1] + zi                                  -- between 0 and 255) and get a random value (from our p[] array above) between
    local ab = p[a+1 + 1] + zi                              -- 0 and 255.  We then add y to it and plug that into p[], and add z to that.
    local b = p[xi+1 + 1] + yi                              -- Then, we get another random value by adding 1 to that and putting it into p[]
    local ba = p[b+1] + zi                                  -- and add z to it.  We do the whole thing over again starting with x+1.  Later
    local bb = p[b+1 + 1] + zi                              -- we plug aa, ab, ba, and bb back into p[] along with their +1's to get another set.
                                                            -- in the end we have 8 values between 0 and 255 - one for each vertex on the unit cube.
                                                            -- These are all interpolated together using u, v, and w below.

    local x1, x2, y1, y2
    x1 = LERP(this.Grad(p[aa+1], xf, yf, zf),               -- This is where the "magic" happens.  We calculate a new set of p[] values and use that to get
              this.Grad(p[ba+1], xf - 1, yf, zf),           -- our final gradient values.  Then, we interpolate between those gradients with the u value to get
              u)                                            -- 4 x-values.  Next, we interpolate between the 4 x-values with v to get 2 y-values.  Finally,
    x2 = LERP(this.Grad(p[ab+1], xf, yf - 1, zf),           -- we interpolate between the y-values to get a z-value.
              this.Grad(p[bb+1], xf - 1, yf - 1, zf),
              u)                                            -- When calculating the p[] values, remember that above, p[a+1] expands to p[xi]+yi+1 -- so you are
    y1 = LERP(x1, x2, v)                                    -- essentially adding 1 to yi.  Likewise, p[ab+1] expands to p[p[xi]+yi+1]+zi+1] -- so you are adding
                                                            -- to zi.  The other 3 parameters are your possible return values (see grad()), which are actually
    x1 = LERP(this.Grad(p[aa+1 + 1], xf, yf, zf - 1),       -- the vectors from the edges of the unit cube to the point in the unit cube itself.
              this.Grad(p[ba+1 + 1], xf - 1, yf, zf - 1),
              u)
    x2 = LERP(this.Grad(p[ab+1 + 1], xf, yf - 1, zf - 1),
              this.Grad(p[bb+1 + 1], xf - 1, yf - 1, zf - 1),
              u)
    y2 = LERP(x1, x2, v)

    return (LERP(y1, y2, w) + 1) / 2                        -- For convenience we bound it to 0 - 1 (theoretical min/max before is -1 - 1)
end

----------------------------------- Private Methods -----------------------------------

function this.Initialize()
    if not p then
        p = {}
        for i = 0, 512-1, 1 do
            p[i+1] = permutation[(i % 256)+1]
        end
    end
end

function this.BitAND(a,b)--Bitwise and
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end

---@param hash integer
---@param x number
---@param y number
---@param z number
---@return number
function this.Grad(hash, x, y, z)
    --int h = hash & 15;                            -- Take the hashed value and take the first 4 bits of it (15 == 0b1111)
    local h = bit32.band(hash, 15)  -- 1111         -- lua 5.1 doesn't have & yet

    local u                                         -- If the most signifigant bit (MSB) of the hash is 0 then set u = x.  Otherwise y.
    if h < 8 then   -- 1000
        u = x
    else
        u = y
    end

    local v                                         -- In Ken Perlin's original implementation this was another conditional operator (?:).  I expanded it for readability.
    if h < 4 then   -- 0100                         -- If the first and second signifigant bits are 0 set v = y
        v = y
    elseif h == 12 or h == 14 then  -- 1100, 1110   -- If the first and second signifigant bits are 1 set v = x
        v = x
    else                                            -- If the first and second signifigant bits are not equal (0/1, 1/0) set v = z
        v = z
    end

    if bit32.band(h, 1) ~= 0 then                   -- Use the last 2 bits to decide if u and v are positive or negative.  Then return their addition.
        u = -u
    end

    if bit32.band(h, 2) ~= 0 then
        v = -v
    end

    return u + v
end

function this.Fade(t)
    -- Fade function as defined by Ken Perlin.  This eases coordinate values
    -- so that they will "ease" towards integral values.  This ends up smoothing
    -- the final output.
    return t * t * t * (t * (t * 6 - 15) + 10)      -- 6t^5 - 15t^4 + 10t^3
end