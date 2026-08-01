# Test Plan — Quickhack Tester 2

## Test 1: Targeting & List Available
1. Look at a vending machine
2. Press **List Available Hacks**
3. **Expected**: CET console shows the target class name and available quickhack actions with labels and class names
4. **Compare with v1**: The list should show the same actions (e.g. GlitchScreenSuicide, GlitchScreenBlind, etc. for vending machines)

## Test 2: Cycle Hack
1. Look at a vending machine
2. Press **Cycle Hack** multiple times
3. **Expected**: Each press cycles through the device's actual available quickhacks (e.g. 1/4, 2/4, 3/4, 4/4, 1/4...)
4. **Compare with v1**: v1 cycled through a hardcoded list (Distraction, Toggle On/Off, etc.) that didn't match what the device actually supported

## Test 3: Apply Quickhack
1. Look at a vending machine
2. Press **List Available Hacks** to see what's available
3. Use **Cycle Hack** to select a hack (e.g. the one that says "MalfunctionClassHack" — that's the distraction/malfunction hack)
4. Press **Apply Quickhack**
5. **Expected**:
   - CET console shows "StartAction OK — hack should be applying"
   - The vending machine should visually malfunction/distraction (screen glitch effect)
   - No RAM should be consumed (check RAM bar)
   - No XP should be gained
6. **Compare with v1**: v1 showed "StartAction failed" and "CompleteAction failed — hack may not have applied"

## Test 4: Different Device Types
1. Test on different devices:
   - Vending machine (should have glitch/malfunction hacks)
   - Door (should have toggle open hack)
   - Explosive (should have self-destruct hack)
   - Camera (should have camera-related hacks)
2. For each: List Available → Cycle Hack → Apply Quickhack
3. **Expected**: Each device shows its own specific available hacks, and applying them works

## Test 5: Cache Behavior
1. Look at vending machine A, press List Available (populates cache)
2. Look away, look at vending machine A again, press Cycle Hack
3. **Expected**: Cycle works immediately without re-querying (cache hit)
4. Look at vending machine B, press List Available
5. **Expected**: Cache updates to vending machine B's actions

## Key Things to Watch

- **StartAction OK** in the log — this is the key indicator that the fix worked
- **RAM bar** should not decrease when applying hacks
- **XP** should not increase when applying hacks
- **Visual effect** on the device (glitch, distraction, explosion, etc.) — this confirms QueuePSDeviceEvent worked
- If StartAction still fails, check if the action has a valid ObjectActionID (the debug output shows the action label and class name)
