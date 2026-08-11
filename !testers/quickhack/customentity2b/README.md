# Custom Entity Tester 2b (CE2b)

## REDscript Lifecycle Fix + Phased Quickhack Testing

### Purpose

Follow-up to customentity2a (CE2a). CE2a fixed the bridge access API but the bridge still returned nil -- both `GetScriptableSystem()` and `GetScriptableSystemsContainer():Get()` returned `ok=true, bridge=false`.

**Root cause**: The REDscript `OrbHackingBridge` class was missing `OnAttach()` and `OnDetach()` lifecycle methods. All working custom ScriptableSystems (Equipment-EX, Codeware, BetterOpticalCamo) define these methods. Without them, the engine does not instantiate the ScriptableSystem, so `Get()` returns nil even though the class compiles correctly.

CE2b ships a fixed REDscript with `OnAttach()` and `OnDetach()` added, plus a `GetInstance()` static accessor following the Equipment-EX pattern.

### What CE2b Tests

1. **REDscript lifecycle fix** -- Does adding `OnAttach()`/`OnDetach()` to the OrbHackingBridge ScriptableSystem cause the engine to instantiate it, making `GetScriptableSystemsContainer():Get("OrbHackingBridge")` return a non-nil bridge?
2. **Test with player as executor** (Phase 1) -- Does the REDscript bridge (SetUp + native pipeline) produce a visible device hack effect when the player is the executor?
3. **Test with drone as executor** (Phase 2) -- Does the drone pass the `IsPossible()` validation gate?

### Lineage

| Tester | Result | Key Lesson |
|---|---|---|
| customentity2 | Partial | Drone spawns, target acquired, wrong bridge API, Red4ext stub |
| customentity2a | Partial | Bridge API fixed but still nil -- REDscript missing OnAttach/OnDetach |
| **customentity2b** | Testing | Fixed REDscript with OnAttach/OnDetach; phased testing (player first, then drone) |

### What Changed from CE2a

| Aspect | CE2a | CE2b |
|---|---|---|
| REDscript | Reused from CE2 (no OnAttach/OnDetach) | Ships own fixed REDscript with OnAttach/OnDetach + GetInstance() |
| Bridge result | nil (ok=true, bridge=false) | Expected: non-nil bridge |
| CET Lua | Same API fix | Same (no changes needed) |
| Red4ext | Reused from CE2 | Reused from CE2 (no changes) |
| Files to deploy | 1 (Lua only) | 2 (Lua + Reds -- must replace old Reds) |

### Files

| File | Language | Install Path |
|---|---|---|
| `cet/init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity2b/init.lua` |
| `redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` (replaces old version from CE2) |
| *(reuse)* `customentity2/red4ext/.../OrbHackingBridge.dll` | C++ | `red4ext/plugins/OrbHackingBridge/` (already deployed) |

### REDscript Fix (Key Change)

The only change to the REDscript is adding `OnAttach()` and `OnDetach()` lifecycle methods:

```reds
public class OrbHackingBridge extends ScriptableSystem {

  // ADDED: Required for ScriptableSystem instantiation
  public func OnAttach() -> Void {
    // Engine calls this when the system is created
  }

  public func OnDetach() -> Void {
    // Engine calls this when the system is destroyed
  }

  // ADDED: Static accessor (follows Equipment-EX pattern)
  public static func GetInstance(game: GameInstance) -> ref<OrbHackingBridge> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"OrbHackingBridge") as OrbHackingBridge;
  }

  // ... all original methods unchanged ...
}
```

### Hotkeys (2 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE2b: Spawn/Despawn Drone` | Spawn or despawn the drone near player |
| 2 | `CE2b: Run Ping Quickhack Test` | Execute ping quickhack on targeted device (Phase 1: player, Phase 2: drone if spawned) |

### Testing Protocol

#### Step 1: Deploy

1. Copy `cet/init.lua` to `<game>/bin/x64/plugins/cyber_engine_tweaks/mods/customentity2b/init.lua`
2. Copy `redscript/OrbHackingBridge.reds` to `<game>/r6/scripts/OrbHackingBridge.reds` (replaces old version from CE2)
3. Red4ext DLL from customentity2 should already be in place

#### Step 2: Verify Bridge Loads

1. Launch the game
2. Check CET console for `[CE2b] Bridge loaded via GetScriptableSystemsContainer():Get("OrbHackingBridge")`
3. If bridge loads: lifecycle fix worked! Proceed to Step 3.
4. If bridge still nil: OnAttach/OnDetach was not the issue -- investigate further

#### Step 3: Phase 1 -- Player as Executor

1. Look at a hackable device (camera, TV, turret, access point)
2. Press `CE2b: Run Ping Quickhack Test`
3. Check CET log for `Phase 1 result: SUCCESS`
4. Verify visible ping effect in game

#### Step 4: Phase 2 -- Drone as Executor

1. Press `CE2b: Spawn/Despawn Drone` to spawn a drone
2. Look at a hackable device again
3. Press `CE2b: Run Ping Quickhack Test` again
4. Check CET log for `Phase 2 result: ...`

### Expected Outcomes

| Phase 1 Result | Phase 2 Result | Meaning |
|---|---|---|
| SUCCESS | NOT_POSSIBLE | Bridge works! IsPossible is the gate for drone. Build real Red4ext hook for tester3. |
| SUCCESS | SUCCESS | Bridge works AND drone passes IsPossible naturally. No Red4ext needed! |
| SUCCESS | ERROR | Bridge works but drone executor causes a different error. Investigate. |
| NO_ACTION | -- | Device has no PingDevice quickhack. Try a different device or action. |
| NOT_POSSIBLE | -- | Even player fails IsPossible. Check if player has cyberdeck equipped. |
| ERROR | -- | Bridge call itself errors. Check REDscript method signatures. |
| Bridge still nil | -- | OnAttach/OnDetach fix did not work. Need deeper investigation. |

### References

- [customentity2/FINAL ANALYSIS.md](../customentity2/FINAL%20ANALYSIS.md) -- Root cause analysis of CE2 failures
- [customentity2a/README.md](../customentity2a/README.md) -- CE2a bridge API fix attempt
