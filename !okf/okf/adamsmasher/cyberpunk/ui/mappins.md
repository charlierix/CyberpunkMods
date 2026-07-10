---
type: "UI System"
title: "Mappins UI"
description: "Mappins: gameplay, interaction, UI profile, utils, containers, controllers, minimap, ping system, quest, quickhack, remote player, and stealth."
resource: "!cyberpunk/UI/mappins/gameplayMappins.swift"
tags: ['cyberpunk', 'ui', 'mappins']
timestamp: 2026-07-01T13:00:55Z
---

# Mappins UI

Mappins: gameplay, interaction, UI profile, utils, containers, controllers, minimap, ping system, quest, quickhack, remote player, and stealth.

## Source Files

- `cyberpunk/UI/mappins/gameplayMappins.swift`
- `cyberpunk/UI/mappins/interactionMappins.swift`
- `cyberpunk/UI/mappins/mappinUIProfile.swift`
- `cyberpunk/UI/mappins/mappinUtils.swift`
- `cyberpunk/UI/mappins/mappinsContainers.swift`
- `cyberpunk/UI/mappins/mappinsControllers.swift`
- `cyberpunk/UI/mappins/minimapMappins.swift`
- `cyberpunk/UI/mappins/pingSystemMappin.swift`
- `cyberpunk/UI/mappins/questMappins.swift`
- `cyberpunk/UI/mappins/quickHackMappin.swift`
- `cyberpunk/UI/mappins/remotePlayerMappin.swift`
- `cyberpunk/UI/mappins/stealthMappins.swift`

## Member Types

**Total declarations: 42**

### Classs (33)

| Name | Bases | Source File |
|------|-------|-------------|
| GameplayMappinController | QuestMappinController | cyberpunk/UI/mappins/gameplayMappins.swift |
| InteractionMappinController | BaseInteractionMappinController | cyberpunk/UI/mappins/interactionMappins.swift |
| MappinsContainerController | inkProjectedHUDGameController | cyberpunk/UI/mappins/mappinsContainers.swift |
| CyberspaceMappinsContainerController | MappinsContainerController | cyberpunk/UI/mappins/mappinsContainers.swift |
| CyberspaceMappinController | BaseQuestMappinController | cyberpunk/UI/mappins/mappinsContainers.swift |
| WorldMappinsContainerController | MappinsContainerController | cyberpunk/UI/mappins/mappinsContainers.swift |
| BaseMappinBaseController | inkLogicController | cyberpunk/UI/mappins/mappinsControllers.swift |
| MapPinUtility | IScriptable | cyberpunk/UI/mappins/mappinsControllers.swift |
| BaseMinimapMappinController | BaseMappinBaseController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapStealthMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapQuestMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapQuestAreaMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapDeviceMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapSecurityAreaMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapRemotePlayerMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapPingSystemMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapPOIMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| RoadBlockadeMappinController | MinimapPOIMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapPreventionVehicleMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapDynamicEventMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| VehicleMinimapMappinComponent | IScriptable | cyberpunk/UI/mappins/minimapMappins.swift |
| PreventionMinimapMappinComponent | IScriptable | cyberpunk/UI/mappins/minimapMappins.swift |
| MinimapStubMappinController | BaseMinimapMappinController | cyberpunk/UI/mappins/minimapMappins.swift |
| PingSystemMappinController | BaseInteractionMappinController | cyberpunk/UI/mappins/pingSystemMappin.swift |
| QuestMappinController | BaseQuestMappinController | cyberpunk/UI/mappins/questMappins.swift |
| QuestAnimationMappinController | BaseQuestMappinController | cyberpunk/UI/mappins/questMappins.swift |
| VehicleMappinComponent | IScriptable | cyberpunk/UI/mappins/questMappins.swift |
| VehicleMappinDelayedDiscreteModeCallback | DelayCallback | cyberpunk/UI/mappins/questMappins.swift |
| QuickHackMappinController | BaseInteractionMappinController | cyberpunk/UI/mappins/quickHackMappin.swift |
| QuickHackQueueItem | inkLogicController | cyberpunk/UI/mappins/quickHackMappin.swift |
| RemotePlayerMappinController | BaseInteractionMappinController | cyberpunk/UI/mappins/remotePlayerMappin.swift |
| StealthMappinGameController | inkGameController | cyberpunk/UI/mappins/stealthMappins.swift |
| StealthMappinController | BaseInteractionMappinController | cyberpunk/UI/mappins/stealthMappins.swift |

### Structs (3)

| Name | Bases | Source File |
|------|-------|-------------|
| MappinUIProfile |  | cyberpunk/UI/mappins/mappinUIProfile.swift |
| MappinUtils |  | cyberpunk/UI/mappins/mappinUtils.swift |
| MappinUIUtils |  | cyberpunk/UI/mappins/mappinUtils.swift |

### Funcs (6)

| Name | Bases | Source File |
|------|-------|-------------|
| CreateMappinUIProfile |  | cyberpunk/UI/mappins/mappinsContainers.swift |
| CreateMappinUIProfile |  | cyberpunk/UI/mappins/mappinsContainers.swift |
| CreateMappinUIProfile |  | cyberpunk/UI/mappins/mappinsContainers.swift |
| GetWidgetForNameplateSlot |  | cyberpunk/UI/mappins/mappinsControllers.swift |
| Call |  | cyberpunk/UI/mappins/questMappins.swift |
| GetWidgetForNameplateSlot |  | cyberpunk/UI/mappins/mappinsControllers.swift |

## Citations

- `cyberpunk/UI/mappins/gameplayMappins.swift`
- `cyberpunk/UI/mappins/interactionMappins.swift`
- `cyberpunk/UI/mappins/mappinUIProfile.swift`
- `cyberpunk/UI/mappins/mappinUtils.swift`
- `cyberpunk/UI/mappins/mappinsContainers.swift`
- `cyberpunk/UI/mappins/mappinsControllers.swift`
- `cyberpunk/UI/mappins/minimapMappins.swift`
- `cyberpunk/UI/mappins/pingSystemMappin.swift`
- `cyberpunk/UI/mappins/questMappins.swift`
- `cyberpunk/UI/mappins/quickHackMappin.swift`
- `cyberpunk/UI/mappins/remotePlayerMappin.swift`
- `cyberpunk/UI/mappins/stealthMappins.swift`
