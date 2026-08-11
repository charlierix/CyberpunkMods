// OrbHackingBridge -- CE2d: Fixed REDscript (reverted clearance method)
//
// CE2c used Device.GetInteractionQuickHackClearance() which does NOT exist
// on the Device class — REDscript compilation failed. CE2d reverts to
// Device.GetInteractionClearance() (which compiled fine in CE2b) and keeps
// all CE2c enhancements: action dump, fallback execution, NO_ACTION detail.
//
// The CE2b NO_ACTION was likely because VendingMachines don't have
// PingDevice — not because of the clearance type. Use ListAvailableActions
// to see what actions are available, and target cameras/access points.

public class OrbHackingBridge extends ScriptableSystem {

  public func OnAttach() -> Void {
  }

  public func OnDetach() -> Void {
  }

  public static func GetInstance(game: GameInstance) -> ref<OrbHackingBridge> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"OrbHackingBridge") as OrbHackingBridge;
  }

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

    let actionNames: array<String>;
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
            ArrayPush(actionNames, recordName);
            if Equals(recordName, actionName) {
              targetAction = baseAction;
            }
          }
        }
      }
      i += 1;
    }

    if !IsDefined(targetAction) {
      let available: String = "";
      let j: Int32 = 0;
      while j < ArraySize(actionNames) {
        if j > 0 {
          available += ", ";
        }
        available += actionNames[j];
        j += 1;
      }
      if ArraySize(actionNames) == 0 {
        return "NO_ACTION (no quickhack actions returned -- check clearance/cyberdeck)";
      }
      return s"NO_ACTION (requested: \(actionName), available: \(available))";
    }

    targetAction.SetUp(ps);
    targetAction.SetExecutor(executorObj);

    let game = GetGameInstance();
    if !targetAction.IsPossible(executorObj) {
      return "NOT_POSSIBLE";
    }

    targetAction.CompleteAction(game);
    return "SUCCESS";
  }

  public func ExecuteDeviceActionByName(
    device: ref<Entity>,
    actionName: String,
    executor: ref<Entity>
  ) -> String {
    return this.ExecuteDeviceAction(device, actionName, executor);
  }

  public func ListAvailableActions(
    device: ref<Entity>,
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

    let result: String = "";
    let count: Int32 = 0;
    let i: Int32 = 0;
    while i < ArraySize(actions) {
      let action = actions[i];
      if IsDefined(action) {
        let baseAction = action as BaseScriptableAction;
        if IsDefined(baseAction) {
          let record = baseAction.GetObjectActionRecord();
          if IsDefined(record) {
            let recordName = NameToString(record.ActionName());
            if count > 0 {
              result += ", ";
            }
            result += recordName;
            count += 1;
          }
        }
      }
      i += 1;
    }

    if count == 0 {
      return "NO_ACTIONS (GetQuickHackActions returned 0 actions)";
    }
    return s"\(count) actions: \(result)";
  }

  public func ExecuteFirstAvailableAction(
    device: ref<Entity>,
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
    let foundName: String = "";
    let i: Int32 = 0;
    while i < ArraySize(actions) {
      let action = actions[i];
      if IsDefined(action) {
        let baseAction = action as BaseScriptableAction;
        if IsDefined(baseAction) {
          let record = baseAction.GetObjectActionRecord();
          if IsDefined(record) {
            foundName = NameToString(record.ActionName());
            targetAction = baseAction;
            break;
          }
        }
      }
      i += 1;
    }

    if !IsDefined(targetAction) {
      return "NO_ACTIONS (GetQuickHackActions returned 0 actions)";
    }

    targetAction.SetUp(ps);
    targetAction.SetExecutor(executorObj);

    let game = GetGameInstance();
    if !targetAction.IsPossible(executorObj) {
      return s"NOT_POSSIBLE (action: \(foundName))";
    }

    targetAction.CompleteAction(game);
    return s"SUCCESS (action: \(foundName))";
  }

  public func GetEntityInfo(entity: ref<Entity>) -> String {
    if !IsDefined(entity) { return "NULL"; }
    let id = entity.GetEntityID();
    let pos = entity.GetWorldPosition();
    return s"ID=\(id) Pos=(\(pos.X), \(pos.Y), \(pos.Z))";
  }

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
