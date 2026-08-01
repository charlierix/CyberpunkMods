# Testing Plan: hover_rot_tester_vehicle2

## Assumptions Under Test

From `init.lua` lines 374-388:

| # | Assumption | Source (init.lua line) | Status |
|---|---|---|---|
| A1 | Zeroing out vehicle/player velocity is needed | 375 | ❓ |
| A2 | Setting vehicle's world orientation does anything at all (verify the value actually changes after setting it) | 377 | ❓ |
| A2b | Maybe SetWorldOrientation should be called AFTER Teleport (order matters) | 379 | ❓ |
| A3 | Teleporting is honoring the quat/euler passed in (it may be ignoring it) | 381 | ❓ |
| A3b | Maybe use impulses instead of Teleport (initial teleport, then hover with impulses) | 383 | ❓ |
| A4 | Setting player camera's local orientation is needed for pitch/roll | 385 | ❓ |
| A5 | GetWorldOrientation() returns a Quaternion; Teleport() may accept it directly instead of EulerAngles | 408 | ❓ |


## Variables

The onUpdate function has 4 code blocks that can be toggled/reordered:

| Block | Label | Current State |
|---|---|---|
| **V** | `zeroVelocity(vehicle)` + `zeroVelocity(player)` | Commented (line 394-395) |
| **O** | `vehicle:SetWorldOrientation(gameQuat)` | Active (line 398-401) |
| **T** | `Teleport(vehicle, pos, vehicle:GetWorldOrientation():ToEulerAngles())` | Active (line 405-409) |
| **C** | `cam:SetLocalOrientation(...)` + `cam.pitchMin/Max = euler.pitch` | Commented (line 415-426) |

### Alternative Teleport Approaches

| Variant | Code |
|---|---|
| **T-curr** | `Teleport(vehicle, pos, vehicle:GetWorldOrientation():ToEulerAngles())` — preserves current orientation (NanoDrone pattern) |
| **T-quat** | `Teleport(vehicle, pos, Quat.toEuler(state.quat))` — passes our quaternion as euler |
| **T-quat-direct** | `Teleport(vehicle, pos, gameQuat)` — passes game Quaternion directly (does Teleport accept Quaternion?) |
| **T-identity** | `Teleport(vehicle, pos, EulerAngles.new(0, 0, 0))` — passes identity euler (test if Teleport overrides orientation) |
| **T-none** | No Teleport at all (test if SetWorldOrientation alone holds position) |

### Alternative Orderings

| Order | Description |
|---|---|
| **O→T** | SetWorldOrientation first, then Teleport (current order) |
| **T→O** | Teleport first, then SetWorldOrientation (does SetWorldOrientation stick after Teleport?) |
| **O-only** | SetWorldOrientation only, no Teleport |
| **T-only** | Teleport only, no SetWorldOrientation |

## Test Matrix

### Phase 1: Baseline & Isolation Tests

Each test: activate mod, push Yaw+30 once, observe if camera visually rotates, then deactivate.

| Test | V | O | T variant | C | Purpose | Tests assumption |
|---|---|---|---|---|---|---|
| **T01** | ❌ | ❌ | T-curr | ❌ | Baseline — Teleport with current orient only (no SetWorldOrient, no camera forcing) | A3 (does T-curr preserve orient?) |
| **T02** | ❌ | ✅ | ❌ | ❌ | SetWorldOrientation alone, no Teleport — does it rotate the vehicle? Does it hold position? | A2 (does O stick?), A3b (can we skip T?) |
| **T03** | ❌ | ❌ | T-quat | ❌ | Teleport with our quat euler — does Teleport alone apply rotation? | A3 (does T honor euler?) |
| **T04** | ❌ | ❌ | T-identity | ❌ | Teleport with identity euler — does Teleport force the euler we pass? | A3 (does T honor euler or ignore it?) |
| **T05** | ❌ | ✅ | T-curr | ❌ | O then T-curr — SetWorldOrient then Teleport preserving current orient | A2 (does O stick through T?), A2b (order O→T) |
| **T06** | ❌ | ✅ | T-quat | ❌ | O then T-quat — both set our orientation | A2 + A3 (does either or both apply?) |
| **T07** | ❌ | ✅ | T-curr | ✅ | Full combo: O→T-curr + camera forcing | A2, A3, A4 (does C add pitch/roll?) |

### Phase 2: Order Tests

| Test | V | O | T variant | C | Purpose | Tests assumption |
|---|---|---|---|---|---|---|
| **T08** | ❌ | ✅(after) | T-curr | ❌ | T→O order: Teleport first, then SetWorldOrientation | A2b (does order matter? does O stick after T?) |

### Phase 3: Velocity Zeroing Tests

| Test | V | O | T variant | C | Purpose | Tests assumption |
|---|---|---|---|---|---|---|
| **T09** | ✅ | ✅ | T-curr | ❌ | Same as T05 but with velocity zeroing | A1 (does V change anything?) |
| **T10** | ✅ | ❌ | T-curr | ❌ | Velocity zeroing + Teleport only (no O) | A1 (does vehicle drift without V?) |

### Phase 4: Camera Forcing Tests

| Test | V | O | T variant | C | Purpose | Tests assumption |
|---|---|---|---|---|---|---|
| **T11** | ❌ | ✅ | T-curr | ✅(full) | O→T + SetLocalOrientation + pitchMin/Max | A4 (does C add pitch/roll?) |
| **T12** | ❌ | ✅ | T-curr | ✅(pitch only) | C with only pitchMin/Max, no SetLocalOrientation | A4 (is pitchMin/Max alone enough for pitch?) |
| **T13** | ❌ | ✅ | T-curr | ✅(roll only) | C with only SetLocalOrientation (roll), no pitchMin/Max | A4 (is SetLocalOrientation alone enough for roll?) |

### Phase 5: Alternative Hover Approaches

| Test | V | O | T variant | C | Purpose | Tests assumption |
|---|---|---|---|---|---|---|
| **T14** | ✅ | ✅ | T-curr (initial only) | ❌ | Initial Teleport to hover pos, then rely on SetWorldOrientation + velocity zeroing only | A3b (impulses/alternative hover instead of continuous Teleport) |

## How to Run Each Test

1. **Edit `init.lua`** — uncomment/comment the relevant blocks per the test matrix
2. **Reload mod** in CET console: `ReloadAllMods()` or restart game
3. **Get in a vehicle**
4. **Press toggle hotkey** — note the console output
5. **Push Yaw+30 once** — observe:
   - Does the camera/view visually rotate? (yes/no)
   - Does the vehicle model visually rotate? (yes/no)
   - Does the vehicle stay at hover position? (yes/no)
   - Any screen warping/fighting? (yes/no)
6. **Optionally push Pitch+30 and Roll+30** to test all axes
7. **Press toggle to deactivate**
8. **Record results** in the Results section below

## Diagnostic Logging (already added to init.lua)

The following print statements have been added to `init.lua` onUpdate:

```lua
print("DIAG target: roll=X pitch=X yaw=X")        -- what we want to set
print("DIAG BEFORE: roll=X pitch=X yaw=X")          -- vehicle orient before changes
print("DIAG AFTER SetWorldOrient: roll=X pitch=X yaw=X")  -- did SetWorldOrientation change it?
print("DIAG AFTER Teleport: roll=X pitch=X yaw=X")   -- did Teleport preserve or override it?
print("DIAG pos after: (X, X, X) target hover: (X, X, X)")  -- is position held?
```

This will show at each frame:
- Whether SetWorldOrientation actually changed the orientation (A2)
- Whether Teleport preserved or overrode it (A3)
- Whether the vehicle stayed at hover position

## Results Template

Copy this for each test:

```
### TXX Results
- Date tested: 
- Console output: 
- Visual rotation after Yaw+30: YES / NO
- Vehicle stays at hover pos: YES / NO
- Screen warping: YES / NO
- Notes: 
- Conclusion: assumption confirmed / denied / inconclusive
```

## Priority Order

If short on time, test in this order:

1. **T05** (O→T-curr, no V, no C) — core question: does SetWorldOrientation stick through Teleport?
2. **T03** (T-quat only) — does Teleport alone apply our euler?
3. **T08** (T→O order) — does SetWorldOrientation stick after Teleport? (order test)
4. **T07** (O→T-curr + C) — full combo with camera forcing
5. **T02** (O only, no T) — does SetWorldOrientation alone work without Teleport?

These 5 tests answer the core assumptions with minimal effort.
