need a different way to enforce instructions

----

I tried multiple times in 6a and 6b to state that logic from 6 should be used about teleporting to safety

for 6b I made it very clear that the fall from 50 is lethal

but once the test was deactivated, the player was allowed to fall to their death.  I haven't looked at the code, but I would guess there is no safety teleport in deactivate function, even though I had one in 6.  the instruction was clear - copy safety teleport logic from 6

I'm guessing the model got distracted by other requirements.  but to consistently fail on that one requirement is odd

----

ok, I just looked at the code in deactivate function:
```lua
-- Final teleport to safe height
local pos = player:GetWorldPosition()
local roll, pitch, yaw = Quat.toEulerRaw(state.quat or Quat.identity())
teleportWithOrientation(player, pos, 0, 0, yaw)
```

which is a copy of what was in 6.  it was 5 where I made my change:
```lua
-- do a final teleport so the player doesn't fall to their death
teleportToHeight(player, state.reTeleportThreshold)
```

so the problem was when 6 was written, they changed the safe z value passed in with current pos.  current position doesn't get player below the lethal height

----

still, any code written should be verified by a separate agent:

agent only knows stated intent

code gets handed to validator agent.  agent should ask: does this safety teleport actually make the player safe?
