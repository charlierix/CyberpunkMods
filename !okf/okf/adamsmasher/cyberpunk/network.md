---
type: "Device System"
title: "Network System"
description: "Network system: squad node, door system, door system controller, personnel system, personnel system controller, surveillance system, surveillance system controller, and system base controller."
resource: "!cyberpunk/network/squadNode.swift"
tags: ['cyberpunk', 'network']
timestamp: 2026-07-01T13:00:55Z
---

# Network System

Network system: squad node, door system, door system controller, personnel system, personnel system controller, surveillance system, surveillance system controller, and system base controller.

## Source Files

- `cyberpunk/network/squadNode.swift`
- `cyberpunk/network/systems/doorSystem.swift`
- `cyberpunk/network/systems/doorSystemController.swift`
- `cyberpunk/network/systems/personnelSystem.swift`
- `cyberpunk/network/systems/personnelSystemController.swift`
- `cyberpunk/network/systems/surveillanceSystem.swift`
- `cyberpunk/network/systems/surveillanceSystemController.swift`
- `cyberpunk/network/systems/systemBaseController.swift`

## Member Types

**Total declarations: 17**

### Classs (12)

| Name | Bases | Source File |
|------|-------|-------------|
| CommunityProxyPS | MasterControllerPS | cyberpunk/network/squadNode.swift |
| DoorSystem | DeviceSystemBase | cyberpunk/network/systems/doorSystem.swift |
| DoorSystemController | BaseNetworkSystemController | cyberpunk/network/systems/doorSystemController.swift |
| DoorSystemControllerPS | BaseNetworkSystemControllerPS | cyberpunk/network/systems/doorSystemController.swift |
| PersonnelSystem | DeviceSystemBase | cyberpunk/network/systems/personnelSystem.swift |
| PersonnelSystemController | DeviceSystemBaseController | cyberpunk/network/systems/personnelSystemController.swift |
| PersonnelSystemControllerPS | DeviceSystemBaseControllerPS | cyberpunk/network/systems/personnelSystemController.swift |
| SurveillanceSystem | DeviceSystemBase | cyberpunk/network/systems/surveillanceSystem.swift |
| RevealEnemies | ActionBool | cyberpunk/network/systems/surveillanceSystemController.swift |
| SurveillanceSystemController | DeviceSystemBaseController | cyberpunk/network/systems/surveillanceSystemController.swift |
| SurveillanceSystemControllerPS | DeviceSystemBaseControllerPS | cyberpunk/network/systems/surveillanceSystemController.swift |
| BaseNetworkSystemController | MasterController | cyberpunk/network/systems/systemBaseController.swift |

### Funcs (5)

| Name | Bases | Source File |
|------|-------|-------------|
| OnSecuritySystemOutput |  | cyberpunk/network/squadNode.swift |
| OnSecurityAreaCrossingPerimeter |  | cyberpunk/network/squadNode.swift |
| OnTargetAssessmentRequest |  | cyberpunk/network/squadNode.swift |
| OnSetExposeQuickHacks |  | cyberpunk/network/squadNode.swift |
| GetActions |  | cyberpunk/network/systems/surveillanceSystemController.swift |

## Citations

- `cyberpunk/network/squadNode.swift`
- `cyberpunk/network/systems/doorSystem.swift`
- `cyberpunk/network/systems/doorSystemController.swift`
- `cyberpunk/network/systems/personnelSystem.swift`
- `cyberpunk/network/systems/personnelSystemController.swift`
- `cyberpunk/network/systems/surveillanceSystem.swift`
- `cyberpunk/network/systems/surveillanceSystemController.swift`
- `cyberpunk/network/systems/systemBaseController.swift`
