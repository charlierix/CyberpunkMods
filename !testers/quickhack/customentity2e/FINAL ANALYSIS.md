# FINAL ANALYSIS — Custom Entity 2 Series (CE2 through CE2e)

game version: Cyberpunk 2077 v2.31
CET version: 1.39.1
RED4ext: v1.30.0
REDscript: bundled with game
game platform: Steam / Windows
tester series: testers/quickhack/customentity2 through customentity2e
final tester: testers/quickhack/customentity2e

> **Status**: FULL SUCCESS -- The three-layer bridge pipeline (CET to REDscript to Device Action) works end-to-end. A spawned drone can execute the Ping quickhack on devices as executor, passing IsPossible() naturally. The player's RAM is not depleted.

---

## 1. What Was Proven

The CE2 series proved that a CET Lua mod can call into a REDscript ScriptableSystem bridge to execute quickhack actions on devices using a spawned drone as executor -- no Red4ext hooks required for premade drone entities.

### The Working Pipeline

CET Lua calls GetScriptableSystemsContainer():Get("OrbHackingBridge") to get the REDscript bridge. The bridge calls device.GetDevicePS() to get the persistent state, generates a quickhack context with Device.GetInteractionClearance(), calls GetQuickHackActions to get available actions, finds the action by name ("Ping"), then calls SetUp, SetExecutor, IsPossible, and CompleteAction. Both player and drone executors work.

### Key Facts for Future Testers

| Fact | Detail |
|---|---|
| Action name is "Ping" | Not "PingDevice". ObjectActionRecord.ActionName() returns "Ping". |
| Clearance method is Device.GetInteractionClearance() | GetInteractionQuickHackClearance() does NOT exist -- REDscript compilation fails. |
| Bridge access from CET | Game.GetScriptableSystemsContainer():Get("OrbHackingBridge") -- NOT Game.GetScriptableSystem() which doesn't exist. |
| Drone passes IsPossible() naturally | No Red4ext hook needed for premade drones. Phase 2 returns SUCCESS without any bypass. |
| Player RAM not depleted | User confirmed the ping execution does not cost the player's quickhack RAM. |
| pcall everything in CET | Game.GetScriptableSystem and other non-existent APIs throw errors that crash onInit if not wrapped. |
| registerHotkey at file root level | CET scans for hotkeys before onInit fires. Hotkeys inside onInit don't appear in Settings until a reload. |
| Drone spawn path | base\vehicles\special\av_zetatech_bombus__basic.ent via exEntitySpawner.Spawn() works reliably. |
| Target acquisition | Game.GetTargetingSystem():GetLookAtObject(player, true, false) returns the device the player is looking at. |

---

## 2. CE2e Test Results -- Full Success

### Log Status

| Log | Status | Evidence |
|---|---|---|
| REDscript | Compiled clean | "Compilation complete" -- no errors, no warnings |
| CET | No onInit crash | "API check: GetScriptableSystem = false" logged safely via pcall |
| Red4ext | Stub loaded | "OrbHackingBridge (version: 1.0.0) has been loaded" -- no hooks needed |

### Device Test Results

| Test | Device | Phase 1 (Player) | Phase 2 (Drone) | Fallback? |
|---|---|---|---|---|
| #1 | TV | SUCCESS | SUCCESS | No -- direct match on "Ping" |
| #2 | Speaker | SUCCESS | SUCCESS | No -- direct match on "Ping" |
| #3 | Jukebox | SUCCESS | SUCCESS | No -- direct match on "Ping" |
| #4 | Door | SUCCESS | SUCCESS | No -- direct match on "Ping" |

### User Observations (TEST RESULTS.md)

The user spawned the drone and was able to use ping against several devices (tv, speaker, window shutter). The ping worked and did not deplete the player's RAM, which is the desired behavior.

### Actions Found Per Device

| Device | Action Count | Actions |
|---|---|---|
| TV | 6 | GlitchScreenSuicide, GlitchScreenBlind, GlitchScreenGrenade, MalfunctionClassHack, RemoteBreach, Ping |
| Speaker | 3 | MalfunctionClassHack, RemoteBreach, Ping |
| Jukebox | 3 | MalfunctionClassHack, RemoteBreach, Ping |
| Door | 3 | ToggleStateClassHack, RemoteBreach, Ping |

---

## 3. CE2 Series Progression

### Tester Summary

| Tester | Focus | Key Achievement |
|---|---|---|
| CE2 | Red4ext stub + REDscript bridge | Bridge compiles and loads from CET via GetScriptableSystemsContainer():Get() |
| CE2a | CET Lua tester (drone spawn + target) | exEntitySpawner.Spawn() works; GetTargetingSystem():GetLookAtObject() works |
| CE2b | Combined CET + REDscript | Bridge loads, but onInit crashed (unwrapped Game.GetScriptableSystem) and actions returned NO_ACTION |
| CE2c | pcall fix + action dump + fallback | pcall prevented onInit crash; action dump worked; but REDscript didn't compile |
| CE2d | Reverted clearance method | REDscript compiles; action dump revealed action name is "Ping" not "PingDevice"; fallback SUCCESS; drone passes IsPossible() |
| CE2e | Ping action name fix | FULL SUCCESS -- both phases return SUCCESS directly, no fallback needed; player RAM not depleted |

### What Each Tester Established

**CE2 -- Bridge Architecture**
- Created OrbHackingBridge as a ScriptableSystem in REDscript
- Red4ext stub DLL loads without errors
- CET can access the bridge via GetScriptableSystemsContainer():Get("OrbHackingBridge")
- Bridge methods return strings (easy to log from CET)

**CE2a -- Drone Spawn + Target Acquisition**
- exEntitySpawner.Spawn() with base\vehicles\special\av_zetatech_bombus__basic.ent works reliably
- Game.GetTargetingSystem():GetLookAtObject(player, true, false) acquires the device the player is looking at
- Spawn pending pattern: spawn returns entity ID, then poll Game.FindEntityByID() in onUpdate until entity resolves

**CE2b -- Integration Test**
- Combined CE2 (bridge) + CE2a (spawn/target) into a single phased test
- Proved the bridge loads and can be called from CET
- Identified that Game.GetScriptableSystem doesn't exist (crashes if not pcall'd)
- GetQuickHackActions returned actions but the specific action name didn't match

**CE2c -- Diagnostic Enhancements**
- pcall wrapper on Game.GetScriptableSystem check prevents onInit crash
- ListAvailableActions() method dumps all quickhack action names on a device
- ExecuteFirstAvailableAction() fallback executes the first available action if the specific name doesn't match
- NO_ACTION result now includes available action names for debugging
- Three hotkeys: Spawn/Despawn Drone, Run Ping Test, List Device Actions
- REDscript didn't compile (hallucinated method name GetInteractionQuickHackClearance)

**CE2d -- Clearance Fix + Action Name Discovery**
- Reverted to Device.GetInteractionClearance() (which compiles)
- Action dump revealed the game uses "Ping" not "PingDevice"
- Fallback execution returned SUCCESS on all devices (VendingMachine, ExplosiveDevice, SurveillanceCamera, Speaker, TV)
- Critical discovery: drone passes IsPossible() naturally -- no Red4ext hook needed for premade drones
- User observed visible effects: food spitting, hacking minigame, speaker audio, glitched TV screen

**CE2e -- Action Name Fix + Full Success**
- Changed "PingDevice" to "Ping" in CET Lua
- Both phases return SUCCESS directly -- no fallback needed
- Tested on 4 devices (TV, Speaker, Jukebox, Door) -- all SUCCESS
- User confirmed: ping works, player RAM not depleted

---

## 4. Working Code Patterns (Reference for Future Testers)

### REDscript Bridge Pattern

```redscript
public class OrbHackingBridge extends ScriptableSystem {

  public func OnAttach() -> Void {}
  public func OnDetach() -> Void {}

  public static func GetInstance(game: GameInstance) -> ref<OrbHackingBridge> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"OrbHackingBridge") as OrbHackingBridge;
  }

  public func ExecuteDeviceAction(
    device: ref<Entity>,
    actionName: String,
    executor: ref<Entity>
  ) -> String {
    let deviceObj = device as Device;
    let ps = deviceObj.GetDevicePS() as ScriptableDeviceComponentPS;
    let executorObj = executor as GameObject;

    let context: GetActionsContext = ps.GenerateContext(
      gamedeviceRequestType.Remote,
      Device.GetInteractionClearance(),
      executorObj,
      executorObj.GetEntityID()
    );

    let actions: array<ref<DeviceAction>>;
    ps.GetQuickHackActions(actions, context);

    let targetAction: ref<BaseScriptableAction>;
    let i: Int32 = 0;
    while i < ArraySize(actions) {
      let baseAction = actions[i] as BaseScriptableAction;
      if IsDefined(baseAction) {
        let record = baseAction.GetObjectActionRecord();
        if Equals(NameToString(record.ActionName()), actionName) {
          targetAction = baseAction;
        }
      }
      i += 1;
    }

    if !IsDefined(targetAction) {
      return "NO_ACTION";
    }

    targetAction.SetUp(ps);
    targetAction.SetExecutor(executorObj);

    if !targetAction.IsPossible(executorObj) {
      return "NOT_POSSIBLE";
    }

    targetAction.CompleteAction(GetGameInstance());
    return "SUCCESS";
  }
}
```

### CET Lua Bridge Access Pattern

```lua
local function GetBridge()
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystemsContainer():Get("OrbHackingBridge")
    end)
    if ok and bridge then
        return bridge
    end
    return nil
end

-- Call a bridge method
local result = bridge:ExecuteDeviceActionByName(target, "Ping", executor)
```

### CET Lua Drone Spawn Pattern

```lua
local function SpawnDrone()
    local player = Game.GetPlayer()
    local transform = player:GetWorldTransform()
    local pos = player:GetWorldPosition()
    local forward = player:GetWorldForward()
    transform:SetPosition(Vector4.new(
        pos.x + forward.x * 3.0,
        pos.y + forward.y * 3.0,
        pos.z,
        pos.w
    ))

    local entityID = exEntitySpawner.Spawn(
        "base\\vehicles\\special\\av_zetatech_bombus__basic.ent",
        transform,
        ""
    )
    -- Poll for entity in onUpdate via Game.FindEntityByID(entityID)
end
```

### CET Lua Target Acquisition Pattern

```lua
local function AcquireTarget()
    local player = Game.GetPlayer()
    local ts = Game.GetTargetingSystem()
    local ok, result = pcall(function()
        return ts:GetLookAtObject(player, true, false)
    end)
    if ok and result then
        return result
    end
    return nil
end
```

### CET Lua Hotkey Registration Pattern

```lua
-- MUST be at file root level, NOT inside onInit
registerHotkey("MyMod_Action", "My Mod: Action", function()
    SafeCall('Action', MyActionFunction)
end)

registerForEvent("onInit", function()
    -- NO registerHotkey calls here
end)
```

---

## 5. Action Names Reference

Action names returned by ObjectActionRecord.ActionName() on various devices:

| Action Name | Description | Found On |
|---|---|---|
| Ping | Ping quickhack (reveals devices on network) | TV, Speaker, Jukebox, Door, VendingMachine, ExplosiveDevice, SurveillanceCamera |
| RemoteBreach | Remote breach protocol | Most devices |
| MalfunctionClassHack | Malfunction (distract) | TV, Speaker, Jukebox, VendingMachine, SurveillanceCamera |
| GlitchScreenSuicide | Glitch screen (suicide) | TV, VendingMachine |
| GlitchScreenBlind | Glitch screen (blind) | TV, VendingMachine |
| GlitchScreenGrenade | Glitch screen (grenade) | TV, VendingMachine |
| ToggleStateClassHack | Toggle state (open/close) | Door, SurveillanceCamera |
| OverloadClassHack | Overload (explode) | ExplosiveDevice |
| TakeControlCameraClassHack | Take control | SurveillanceCamera |
| OverrideAttitudeClassHack | Override attitude | SurveillanceCamera |

---

## 6. Methods That Work vs Methods That Don't

### Methods That Work

| Method | Class | Notes |
|---|---|---|
| GetScriptableSystemsContainer():Get(name) | GameInstance | Access ScriptableSystem from CET |
| GetDevicePS() | Device | Get persistent state |
| GenerateContext(Remote, clearance, executor, id) | ScriptableDeviceComponentPS | Create action context |
| GetInteractionClearance() | Device (static) | General interaction clearance |
| GetQuickHackActions(actions, context) | ScriptableDeviceComponentPS | Get quickhack action list |
| GetObjectActionRecord() | BaseScriptableAction | Get action record |
| ActionName() | ObjectActionRecord | Get action name string |
| SetUp(ps) | BaseScriptableAction | Initialize action |
| SetExecutor(executor) | BaseScriptableAction | Set who executes |
| IsPossible(executor) | BaseScriptableAction | Check if action is possible |
| CompleteAction(game) | BaseScriptableAction | Execute the action |
| exEntitySpawner.Spawn(path, transform, "") | Global | Spawn entity by .ent path |
| GetTargetingSystem():GetLookAtObject(player, true, false) | GameInstance | Get looked-at entity |
| FindEntityByID(entityID) | GameInstance | Resolve spawned entity |

### Methods That Don't Exist

| Method | Class | What Happens |
|---|---|---|
| GetInteractionQuickHackClearance() | Device | REDscript compilation fails -- UNRESOLVED_METHOD |
| Game.GetScriptableSystem(name) | GameInstance | CET metatable error -- crashes if not pcall'd |

---

## 7. Lessons Learned

1. **Action names come from the game, not from assumptions.** The action was "Ping" all along, not "PingDevice". The action dump diagnostic (ListAvailableActions) was essential for discovering this.

2. **Don't trust hallucinated method names.** GetInteractionQuickHackClearance was hallucinated by an AI query and caused a REDscript compilation failure. Always verify method names against the actual game API or test compilation.

3. **pcall everything that might not exist in CET.** Game.GetScriptableSystem doesn't exist, and accessing it throws a metatable error that crashes onInit. Wrap all uncertain API calls in pcall.

4. **registerHotkey must be at file root level.** CET scans for hotkeys before onInit fires. Hotkeys inside onInit don't appear in Settings > Key Bindings until a reload.

5. **The drone passes IsPossible() naturally.** This was a major discovery -- no Red4ext hook is needed to bypass IsPossible() for premade drone entities. The entire execution pipeline works with just CET + REDscript.

6. **Action dump diagnostics are invaluable.** The ListAvailableActions() method that dumps all quickhack action names on a targeted device was the key to debugging the NO_ACTION issue.

7. **Fallback execution confirms the pipeline works.** Even when the specific action name was wrong, ExecuteFirstAvailableAction() proved the bridge pipeline (SetUp to SetExecutor to IsPossible to CompleteAction) worked end-to-end.

8. **Phased testing (player then drone) isolates issues.** Phase 1 (player) proves the bridge and action pipeline. Phase 2 (drone) tests the executor gate. If Phase 1 fails, the issue is upstream of the executor.

---

## 8. Red4ext: When It Will Be Needed

The CE2 series proved that Red4ext is not needed for premade drone executors. The drone passes IsPossible() naturally.

However, the final goal is a completely custom entity, not a premade drone. A custom entity may:

- Lack the right device components and clearance by default
- Fail IsPossible() because it doesn't have the expected executor components
- Need component injection or clearance grants that can't be done from REDscript alone

Red4ext hooks that may be needed for a custom entity:

| Hook | Purpose |
|---|---|
| IsPossible bypass | If the custom entity fails the IsPossible() gate |
| Component injection | If the custom entity lacks device/executor components |
| Clearance override | If the custom entity doesn't have quickhack clearance |

The Red4ext stub from CE2 is in place and loads cleanly. When v3 begins, the stub can be expanded with the necessary hooks.

---

## 9. File Inventory

### Final Working Tester (CE2e)

| File | Lines | Path |
|---|---|---|
| CET Lua | 561 | cet/init.lua |
| REDscript | 266 | redscript/OrbHackingBridge.reds |
| README | 81 | README.md |
| TEST RESULTS | 3 | TEST RESULTS.md |
| CET log | 122 | log - cet.txt |
| REDscript log | 49 | log - redscript.txt |
| Red4ext log | 28 | log - red4ext.txt |

### All CE2 Series Testers

| Tester | Path | Key Files |
|---|---|---|
| CE2 | customentity2/ | Red4ext stub DLL, REDscript bridge, CET Lua, FINAL ANALYSIS.md |
| CE2a | customentity2a/ | CET Lua (spawn + target), README |
| CE2b | customentity2b/ | CET Lua, REDscript, logs, README |
| CE2c | customentity2c/ | CET Lua, REDscript (didn't compile), README |
| CE2d | customentity2d/ | REDscript (fixed), LOG ANALYSIS.md, TEST RESULTS.md, logs |
| CE2e | customentity2e/ | CET Lua (Ping fix), REDscript, README, logs, TEST RESULTS.md |

---

## 10. Deployment Guide for Future Testers

### To deploy the working CE2e pipeline

1. CET Lua: Copy cet/init.lua to game/bin/x64/plugins/cyber_engine_tweaks/mods/modname/init.lua
2. REDscript: Copy redscript/OrbHackingBridge.reds to game/r6/scripts/OrbHackingBridge.reds
3. Red4ext: Copy OrbHackingBridge.dll (stub) to game/red4ext/plugins/OrbHackingBridge/OrbHackingBridge.dll
4. Remove old testers: Delete or rename any previous CE2* CET mod folders to avoid hotkey conflicts
5. Bind hotkeys: Settings > Key Bindings > CE2e: Spawn/Despawn Drone, Run Ping Test, List Device Actions

### To adapt for a new tester

1. Copy the CE2e folder structure (cet/, redscript/, README.md)
2. Update MOD_NAME, LOG_PREFIX, hotkey names in the CET Lua
3. Update the REDscript class name if creating a new bridge (or keep OrbHackingBridge if extending)
4. Change the action name in ExecuteDeviceActionByName() if testing a different quickhack
5. Keep the phased testing pattern (Phase 1: player, Phase 2: drone/custom entity)
6. Keep the action dump diagnostic (ListAvailableActions) -- it is essential for debugging
7. Keep the fallback execution (ExecuteFirstAvailableAction) -- it proves the pipeline works even if the specific action name is wrong

---

## 11. References

- CE2e README -- CE2e deployment and testing guide
- CE2e TEST RESULTS.md -- User's observations
- CE2e log - cet.txt -- Full CET log (122 lines)
- CE2e log - redscript.txt -- REDscript compilation log (49 lines, no errors)
- CE2e log - red4ext.txt -- Red4ext log (28 lines, stub loads cleanly)
- ../customentity2d/LOG ANALYSIS.md -- CE2d detailed log analysis (action name discovery)
- ../customentity2d/TEST RESULTS.md -- CE2d user observations (visible effects on 5 devices)
- ../customentity2/FINAL ANALYSIS.md -- CE2 original final analysis
- ../customentity2/README.md -- CE2 bridge architecture
- ../../cet-hotkeys.promptinclude.md -- CET hotkey registration rule
