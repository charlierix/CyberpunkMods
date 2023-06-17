local NoNoSquares = {}

function NoNoSquares.Tick(o)
    -- clean up old cubes
end

function NoNoSquares.AddRayHit(point, normal)

    -- assume this hit is the center of a square

    -- look for nearby hits with the same normal
    --  if found, enlarge the assumed square


    -- define a cube based on the square's area (may want more depth than just a cube)




end

-- Returns a list of cubes that are inside the search sphere
function NoNoSquares.GetNearby(point, radius)
    
end

return NoNoSquares