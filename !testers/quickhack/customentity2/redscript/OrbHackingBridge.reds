// ============================================================
// OrbHackingBridge -- REDscript Bridge for Device Hacking
// (Red4ext-backed)
// ============================================================
//
// Purpose: Expose the SetUp() call and native action execution
//   pipeline to CET Lua. This is the core of the shell entity
//   proposal -- proving that SetUp(ps) + native pipeline
//   execution produces visible device hack effects.
//
//   In customentity2, the Red4ext C++ plugin hooks IsPossible()
//   to bypass executor validation for CE2_DRONE-tagged drones.
//
// File: OrbHackingBridge.reds
// Install: r6/scripts/OrbHackingBridge.reds
// Requires: RED4ext + REDscript
//
// Access from CET:
//   local bridge = Game.GetScriptableSystem("OrbHackingBridge")
//   bridge:ExecuteDeviceActionByName(device, "PingDevice", executor)
//
// ============================================================

public class OrbHackingBridge extends ScriptableSystem {

  // ============================================================
  // ExecuteDeviceAction -- Full native pipeline execution
  // ============================================================

  public func ExecuteDeviceAction(
    device: ref<Entity>,
    actionName: String,
    executor: ref<Entity>
  ) -> String {
    if !IsDefined(device) {
      return "ERROR: device is null";
    }

    let deviceObj = device as Device;
    if !IsDefined(deviceObj) {
      return "ERROR: not a Device";
    }
    let ps = deviceObj.GetDevicePS() as ScriptableDeviceComponentPS;
    if !IsDefined(ps) {
      return "NO_DEVICE_PS";
    }

    let executorObj = executor as GameObject;
    if !IsDefined(executorObj) {
      return "ERROR: executor is not a GameObject";
    }

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
      let action = actions[i];
      if IsDefined(action) {
        let baseAction = action as BaseScriptableAction;
        if IsDefined(baseAction) {
          let record = baseAction.GetObjectActionRecord();
          if IsDefined(record) {
            let recordName = NameToString(record.ActionName());
            if Equals(recordName, actionName) {
              targetAction = baseAction;
            }
          }
        }
      }
      i += 1;
    }

    if !IsDefined(targetAction) {
      return "NO_ACTION";
    }

    // THE CRITICAL STEP: SetUp(ps) -- now backed by Red4ext hook
    targetAction.SetUp(ps);

    targetAction.SetExecutor(executorObj);

    let game = GetGameInstance();
    if !targetAction.IsPossible(executorObj) {
      return "NOT_POSSIBLE";
    }

    targetAction.CompleteAction(game);

    return "SUCCESS";
  }

  // ============================================================
  // ExecuteDeviceActionByName -- convenience wrapper for CET
  // ============================================================

  public func ExecuteDeviceActionByName(
    device: ref<Entity>,
    actionName: String,
    executor: ref<Entity>
  ) -> String {
    return this.ExecuteDeviceAction(device, actionName, executor);
  }

  // ============================================================
  // GetEntityInfo -- diagnostic info for CET
  // ============================================================

  public func GetEntityInfo(entity: ref<Entity>) -> String {
    if !IsDefined(entity) { return "NULL"; }
    let id = entity.GetEntityID();
    let pos = entity.GetWorldPosition();
    return s"ID=\(id) Pos=(\(pos.X), \(pos.Y), \(pos.Z))";
  }

  // ============================================================
  // ValidateEntity -- check if entity is usable as executor
  // ============================================================

  public func ValidateEntity(entity: ref<Entity>) -> String {
    if !IsDefined(entity) { return "NULL"; }
    let result = "";
    let id = entity.GetEntityID();
    result += s"EntityID: \(id)\n";

    let puppet = entity as ScriptedPuppet;
    if IsDefined(puppet) {
      result += "Type: ScriptedPuppet\n";
      result += s"IsActive: \(puppet.IsActive())\n";
    } else {
      result += "Type: Not ScriptedPuppet\n";
    }

    let pos = entity.GetWorldPosition();
    result += s"Position: (\(pos.X), \(pos.Y), \(pos.Z))\n";
    return result;
  }
}
