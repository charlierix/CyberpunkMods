---
type: "Device System"
title: "Traffic Devices"
description: "Traffic devices: crossing light, crossing light controller, intersection manager controller, NCART timetable, NCART timetable controller, traffic light, traffic light controller, traffic zebra, and traffic zebra controller."
resource: "!cyberpunk/devices/traffic/crossingLight.swift"
tags: ['cyberpunk', 'devices', 'traffic']
timestamp: 2026-07-01T13:00:55Z
---

# Traffic Devices

Traffic devices: crossing light, crossing light controller, intersection manager controller, NCART timetable, NCART timetable controller, traffic light, traffic light controller, traffic zebra, and traffic zebra controller.

## Source Files

- `cyberpunk/devices/traffic/crossingLight.swift`
- `cyberpunk/devices/traffic/crossingLightController.swift`
- `cyberpunk/devices/traffic/intersectionManagerController.swift`
- `cyberpunk/devices/traffic/ncartTimetable.swift`
- `cyberpunk/devices/traffic/ncartTimetableController.swift`
- `cyberpunk/devices/traffic/trafficLight.swift`
- `cyberpunk/devices/traffic/trafficLightController.swift`
- `cyberpunk/devices/traffic/zebra.swift`
- `cyberpunk/devices/traffic/zebraController.swift`

## Member Types

**Total declarations: 21**

### Classs (18)

| Name | Bases | Source File |
|------|-------|-------------|
| CrossingLight | TrafficLight | cyberpunk/devices/traffic/crossingLight.swift |
| CrossingLightController | TrafficLightController | cyberpunk/devices/traffic/crossingLightController.swift |
| CrossingLightControllerPS | TrafficLightControllerPS | cyberpunk/devices/traffic/crossingLightController.swift |
| InitiateTrafficLightChange | ActionBool | cyberpunk/devices/traffic/intersectionManagerController.swift |
| TrafficIntersectionManagerController | MasterController | cyberpunk/devices/traffic/intersectionManagerController.swift |
| TrafficIntersectionManagerControllerPS | MasterControllerPS | cyberpunk/devices/traffic/intersectionManagerController.swift |
| NcartTimetable | InteractiveDevice | cyberpunk/devices/traffic/ncartTimetable.swift |
| NcartTimetableController | ScriptableDeviceComponent | cyberpunk/devices/traffic/ncartTimetableController.swift |
| NcartTimetableControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/traffic/ncartTimetableController.swift |
| TrafficLight | Device | cyberpunk/devices/traffic/trafficLight.swift |
| ToggleLight | ActionBool | cyberpunk/devices/traffic/trafficLightController.swift |
| TrafficLightGreen | ActionBool | cyberpunk/devices/traffic/trafficLightController.swift |
| TrafficLightRed | ActionBool | cyberpunk/devices/traffic/trafficLightController.swift |
| TrafficLightController | ScriptableDeviceComponent | cyberpunk/devices/traffic/trafficLightController.swift |
| TrafficLightControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/traffic/trafficLightController.swift |
| TrafficZebra | TrafficLight | cyberpunk/devices/traffic/zebra.swift |
| TrafficZebraController | TrafficLightController | cyberpunk/devices/traffic/zebraController.swift |
| TrafficZebraControllerPS | TrafficLightControllerPS | cyberpunk/devices/traffic/zebraController.swift |

### Funcs (3)

| Name | Bases | Source File |
|------|-------|-------------|
| GetQuestActions |  | cyberpunk/devices/traffic/intersectionManagerController.swift |
| ResavePersistentData |  | cyberpunk/devices/traffic/ncartTimetable.swift |
| GetQuestActions |  | cyberpunk/devices/traffic/intersectionManagerController.swift |

## Citations

- `cyberpunk/devices/traffic/crossingLight.swift`
- `cyberpunk/devices/traffic/crossingLightController.swift`
- `cyberpunk/devices/traffic/intersectionManagerController.swift`
- `cyberpunk/devices/traffic/ncartTimetable.swift`
- `cyberpunk/devices/traffic/ncartTimetableController.swift`
- `cyberpunk/devices/traffic/trafficLight.swift`
- `cyberpunk/devices/traffic/trafficLightController.swift`
- `cyberpunk/devices/traffic/zebra.swift`
- `cyberpunk/devices/traffic/zebraController.swift`
