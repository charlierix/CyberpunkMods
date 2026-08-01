# Hover Rot Tester Player 6a — PSM State Machine Manipulation (Fixed)

Copy of tester 6 with critical bug fixes that made tester 6 inconclusive.

## What Changed from Tester 6

### 1. Re-Teleport Bug Fixed (CRITICAL)

**Tester 6 bug:** When the player fell below the re-teleport threshold, the code teleported to the falling position instead of the target height. This kept the player at ground level, causing continuous re-teleporting every frame.

**Fix:** Re-teleport now sends the player back to targetZ height.

### 2. DIAG Output No Longer Blocked

**Tester 6 bug:** The re-teleport code path had an early return that skipped the DIAG diagnostic section entirely. No diagnostic data was ever printed.

**Fix:** Removed the early return. The code now continues to PSM manipulation, rotation, and DIAG output even after re-teleport.

### 3. Improved SM Identifier Construction

**Tester 6 bug:** IsStateMachinePresent() returned false for all named state machines. Only one identifier approach was tried.

**Fix:** Now tries 4 different StateMachineIdentifier construction approaches, plus Dump() probing and GetActiveStateMachines/GetStateMachines method attempts.

### 4. Names Updated

All mod names, hotkey IDs, and labels updated from Player6/HRTP6 to Player6a/HRTP6A.

## What to Test

Same 9 PSM state modes as tester 6, but now with working diagnostics:

1. Toggle hover — player should teleport to z+50 and stay airborne
2. Press rotation hotkeys — DIAG output should print showing target vs actual orientation
3. Cycle through state modes — test each PSM mode with both Teleport and SetWorldTransform
4. Check DIAG MATCH lines — look for any mode where roll/pitch match = true
5. Use Probe SM Component — see if any of the 4 identifier approaches return true
6. Use Dump PSM State — verify PSM blackboard values are being written

## Hotkeys

| Hotkey | Action |
|--------|--------|
| Toggle Hover (Player6a) | Enable/disable tester |
| Cycle State Mode (Player6a) | Cycle through 9 PSM modes |
| Toggle Rotation Method (P6a) | Switch Teleport and SetWorldTransform |
| Dump PSM State (Player6a) | Print all PSM blackboard values |
| Probe SM Component (Player6a) | Dump gamestateMachineComponent info |
| Yaw plus/minus 30 (Player6a) | Rotate yaw |
| Pitch plus/minus 30 (Player6a) | Rotate pitch |
| Roll plus/minus 30 (Player6a) | Rotate roll |

## Install

Copy to bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player6a

## Expected DIAG Output

With the fixes, you should now see lines like:

```
[HoverRotTesterPlayer6a] DIAG mode=FELLED method=Teleport z=96.5
[HoverRotTesterPlayer6a] DIAG target: roll=30.0 pitch=60.0 yaw=90.0
[HoverRotTesterPlayer6a] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=90.0
[HoverRotTesterPlayer6a] DIAG Teleport SUCCESS
[HoverRotTesterPlayer6a] DIAG AFTER: roll=0.0 pitch=0.0 yaw=90.0
[HoverRotTesterPlayer6a] DIAG MATCH: roll=false pitch=false yaw=true
[HoverRotTesterPlayer6a] DIAG PSM: LocDetailed=31 HighLevel=0 Vitals=0 Felled=true
```

If any mode shows roll=true or pitch=true in DIAG MATCH, that PSM state successfully bypasses the locomotion clamp.
