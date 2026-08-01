it would be good to make a basic tester that:
- looks at an npc's current health / max health
- gets modifiers of damage types (resistant to fire, vulnerable to shock...)

then eaither add or subtract a certain amount of health to the npc

then observe
- if added amount exceeds 100%, does it cap to 100%
- if subtracted amount drops below 0%, do the npc die

also research incapacitated state, how to get that vs death

-----

### DealDamageModule creates a HitEvent with damage data
from `testers\quickhack\statuseffect_tester3\research_npc_damage_system.md`:
```lua
-- Construct a HitEvent and process it
local hitEvent = HitEvent.new()
hitEvent.damageValues = {100.0}  -- damage amount
hitEvent.hitPosition = target:GetWorldPosition()
hitEvent.source = Game.GetPlayer()
Game.GetDamageSystem():ProcessHitEvent(hitEvent)
```