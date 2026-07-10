---
type: "Device System"
title: "Utility Devices"
description: "Utility devices: chest press, electric light (alarm light, electric light, gameplay light), fan, netrunner chair, perk training, relic perk system, and weapon training."
resource: "!cyberpunk/devices/utilities/chestPress/chestPress.swift"
tags: ['cyberpunk', 'devices', 'utilities']
timestamp: 2026-07-01T13:00:55Z
---

# Utility Devices

Utility devices: chest press, electric light (alarm light, electric light, gameplay light), fan, netrunner chair, perk training, relic perk system, and weapon training.

## Source Files

- `cyberpunk/devices/utilities/chestPress/chestPress.swift`
- `cyberpunk/devices/utilities/chestPress/chestPressController.swift`
- `cyberpunk/devices/utilities/electricLight/alarmLight.swift`
- `cyberpunk/devices/utilities/electricLight/alarmLightController.swift`
- `cyberpunk/devices/utilities/electricLight/electricLight.swift`
- `cyberpunk/devices/utilities/electricLight/electricLightController.swift`
- `cyberpunk/devices/utilities/electricLight/gameplayLight.swift`
- `cyberpunk/devices/utilities/electricLight/gameplayLightController.swift`
- `cyberpunk/devices/utilities/fan/fan.swift`
- `cyberpunk/devices/utilities/fan/fanController.swift`
- `cyberpunk/devices/utilities/netrunner/netrunnerChair.swift`
- `cyberpunk/devices/utilities/netrunner/netrunnerChairController.swift`
- `cyberpunk/devices/utilities/perkTraining/perkTraining.swift`
- `cyberpunk/devices/utilities/perkTraining/perkTrainingController.swift`
- `cyberpunk/devices/utilities/perkTraining/relicPerkSystem.swift`
- `cyberpunk/devices/utilities/weaponTraining/weaponTraining.swift`

## Member Types

**Total declarations: 39**

### Classs (29)

| Name | Bases | Source File |
|------|-------|-------------|
| ChestPress | InteractiveDevice | cyberpunk/devices/utilities/chestPress/chestPress.swift |
| ChestPressController | ScriptableDeviceComponent | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| ChestPressControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| ChestPressWeightHack | ActionBool | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| E3Hack_QuestPlayAnimationWeightLift | ActionBool | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| E3Hack_QuestPlayAnimationKillNPC | ActionBool | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| AlarmLight | BasicDistractionDevice | cyberpunk/devices/utilities/electricLight/alarmLight.swift |
| AlarmLightController | ScriptableDeviceComponent | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| AlarmLightControllerPS | BasicDistractionDeviceControllerPS | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| ElectricLight | Device | cyberpunk/devices/utilities/electricLight/electricLight.swift |
| ElectricLightController | ScriptableDeviceComponent | cyberpunk/devices/utilities/electricLight/electricLightController.swift |
| ElectricLightControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/utilities/electricLight/electricLightController.swift |
| GameplayLight | InteractiveDevice | cyberpunk/devices/utilities/electricLight/gameplayLight.swift |
| GameplayLightController | ElectricLightController | cyberpunk/devices/utilities/electricLight/gameplayLightController.swift |
| GameplayLightControllerPS | ElectricLightControllerPS | cyberpunk/devices/utilities/electricLight/gameplayLightController.swift |
| Fan | BasicDistractionDevice | cyberpunk/devices/utilities/fan/fan.swift |
| FanController | BasicDistractionDeviceController | cyberpunk/devices/utilities/fan/fanController.swift |
| FanControllerPS | BasicDistractionDeviceControllerPS | cyberpunk/devices/utilities/fan/fanController.swift |
| NetrunnerChair | InteractiveDevice | cyberpunk/devices/utilities/netrunner/netrunnerChair.swift |
| NetrunnerChairController | ScriptableDeviceComponent | cyberpunk/devices/utilities/netrunner/netrunnerChairController.swift |
| NetrunnerChairControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/utilities/netrunner/netrunnerChairController.swift |
| PerkTraining | InteractiveDevice | cyberpunk/devices/utilities/perkTraining/perkTraining.swift |
| PerkTrainingController | ScriptableDeviceComponent | cyberpunk/devices/utilities/perkTraining/perkTraining.swift |
| PerkTrainingControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/utilities/perkTraining/perkTrainingController.swift |
| ConnectionEndedEvent | Event | cyberpunk/devices/utilities/perkTraining/perkTrainingController.swift |
| RelicPerkSystem | ScriptableSystem | cyberpunk/devices/utilities/perkTraining/relicPerkSystem.swift |
| PerkDeviceMappinData | IScriptable | cyberpunk/devices/utilities/perkTraining/relicPerkSystem.swift |
| WeaponTraining | InteractiveDevice | cyberpunk/devices/utilities/weaponTraining/weaponTraining.swift |
| WeaponTrainingController | ScriptableDeviceComponent | cyberpunk/devices/utilities/weaponTraining/weaponTraining.swift |

### Funcs (10)

| Name | Bases | Source File |
|------|-------|-------------|
| GetQuestActionByName |  | cyberpunk/devices/utilities/chestPress/chestPressController.swift |
| OnQuestForceSecuritySystemSafe |  | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| OnQuestForceSecuritySystemArmed |  | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| OnSecurityAlarmBreachResponse |  | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/utilities/electricLight/alarmLightController.swift |
| GetActions |  | cyberpunk/devices/utilities/electricLight/electricLightController.swift |
| EvaluateDeviceState |  | cyberpunk/devices/utilities/electricLight/electricLightController.swift |
| ResavePersistentData |  | cyberpunk/devices/utilities/fan/fan.swift |
| GetActions |  | cyberpunk/devices/utilities/electricLight/electricLightController.swift |
| GetActions |  | cyberpunk/devices/utilities/electricLight/electricLightController.swift |

## Citations

- `cyberpunk/devices/utilities/chestPress/chestPress.swift`
- `cyberpunk/devices/utilities/chestPress/chestPressController.swift`
- `cyberpunk/devices/utilities/electricLight/alarmLight.swift`
- `cyberpunk/devices/utilities/electricLight/alarmLightController.swift`
- `cyberpunk/devices/utilities/electricLight/electricLight.swift`
- `cyberpunk/devices/utilities/electricLight/electricLightController.swift`
- `cyberpunk/devices/utilities/electricLight/gameplayLight.swift`
- `cyberpunk/devices/utilities/electricLight/gameplayLightController.swift`
- `cyberpunk/devices/utilities/fan/fan.swift`
- `cyberpunk/devices/utilities/fan/fanController.swift`
- `cyberpunk/devices/utilities/netrunner/netrunnerChair.swift`
- `cyberpunk/devices/utilities/netrunner/netrunnerChairController.swift`
- `cyberpunk/devices/utilities/perkTraining/perkTraining.swift`
- `cyberpunk/devices/utilities/perkTraining/perkTrainingController.swift`
- `cyberpunk/devices/utilities/perkTraining/relicPerkSystem.swift`
- `cyberpunk/devices/utilities/weaponTraining/weaponTraining.swift`
