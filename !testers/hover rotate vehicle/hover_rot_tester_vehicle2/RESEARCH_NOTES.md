two different concerns:

# get vehicle to reliably rotate

the teleport is reliably rotating the vehicle, I can't get it to gimbal lock


# get player's camera to rotate relative to vehicle

player's camera rotation messes up

when activating while in first person, the camera snaps to look almost completely backward.  it's the same direction every time, so maybe that is the direction of identity quat?

third person camera isn't affected.  it sits back and watches the vehicle rotated in place

### 3rd/1st trick

while in third person, if you look along the vehicle (rotate camera so it's at rear looking toward the front), then switch back to first person, the view will be forward

now as the vehicle is rotated, the first person view stays in line with the direction it's looking

> NOTE: there is something that resists change (probably so it's not jolting around with every bump).  this seems to be strongest when looking along the horizon

### 1st person mouse

the mouse also doesn't do anything.  maybe because of the constant teleports?