---
type: "UI System"
title: "Vehicle UI"
description: "Vehicle UI: car visual customization, car HUD, car race HUD, driver combat HUD, dex limo, motorcycle HUD, vehicle interior, vehicle UI, remote control driving, vcar controller, vehicle debug, and base vehicle HUD."
resource: "!cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift"
tags: ['cyberpunk', 'ui', 'vehicles']
timestamp: 2026-07-01T13:00:55Z
---

# Vehicle UI

Vehicle UI: car visual customization, car HUD, car race HUD, driver combat HUD, dex limo, motorcycle HUD, vehicle interior, vehicle UI, remote control driving, vcar controller, vehicle debug, and base vehicle HUD.

## Source Files

- `cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift`
- `cyberpunk/UI/vehicles/car_hud.swift`
- `cyberpunk/UI/vehicles/car_race_hud.swift`
- `cyberpunk/UI/vehicles/driver_combat_hud.swift`
- `cyberpunk/UI/vehicles/ink_dex_limo_controller.swift`
- `cyberpunk/UI/vehicles/ink_motorcycle_hud_controller.swift`
- `cyberpunk/UI/vehicles/ink_vehicle_interior_ui_controller.swift`
- `cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift`
- `cyberpunk/UI/vehicles/remote_control_driving_hud.swift`
- `cyberpunk/UI/vehicles/vcar_controller.swift`
- `cyberpunk/UI/vehicles/vehicle_debug_ui_game_controller.swift`

## Member Types

**Total declarations: 51**

### Classs (28)

| Name | Bases | Source File |
|------|-------|-------------|
| ColorTemplatePreviewVirtualController | inkVirtualCompoundItemController | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| ColorTemplatePreviewDisplayController | BaseButtonView | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| TwintoneTemplateGridController | inkGridController | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| WrappedTemplateData | IScriptable | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| VehicleVisualCustomizationTemplateClassifier | inkVirtualItemTemplateClassifier | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| VehicleVisualCustomizationTemplatePositionProvider | inkItemPositionProvider | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| hudCarController | inkHUDGameController | cyberpunk/UI/vehicles/car_hud.swift |
| CarSpeedometerSettingsListener | ConfigVarListener | cyberpunk/UI/vehicles/car_hud.swift |
| hudCarRaceController | inkHUDGameController | cyberpunk/UI/vehicles/car_race_hud.swift |
| DriverCombatHUDGameController | inkHUDGameController | cyberpunk/UI/vehicles/driver_combat_hud.swift |
| inkDexLimoGameController | inkGameController | cyberpunk/UI/vehicles/ink_dex_limo_controller.swift |
| inkMotorcycleHUDGameController | BaseVehicleHUDGameController | cyberpunk/UI/vehicles/ink_motorcycle_hud_controller.swift |
| vehicleInteriorUIGameController | inkHUDGameController | cyberpunk/UI/vehicles/ink_vehicle_interior_ui_controller.swift |
| vehicleUIGameController | inkHUDGameController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| IVehicleModuleController | inkLogicController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| speedometerLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| tachometerLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| gametimeLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| instrumentPanelLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| gearboxLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RadioLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| analogTachLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| analogSpeedometerLogicController | IVehicleModuleController | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RemoteControlDrivingHUDGameController | inkHUDGameController | cyberpunk/UI/vehicles/remote_control_driving_hud.swift |
| vehicleVcarRootLogicController | inkLogicController | cyberpunk/UI/vehicles/vcar_controller.swift |
| vehicleVcarGameController | inkGameController | cyberpunk/UI/vehicles/vcar_controller.swift |
| BaseVehicleHUDGameController | inkHUDGameController | cyberpunk/UI/vehicles/vehicle_debug_ui_game_controller.swift |
| vehicleDebugUIGameController | BaseVehicleHUDGameController | cyberpunk/UI/vehicles/vehicle_debug_ui_game_controller.swift |

### Funcs (23)

| Name | Bases | Source File |
|------|-------|-------------|
| CanNavigateToItem |  | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| ClassifyItem |  | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| GetItemPosition |  | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| SaveItemPosition |  | cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift |
| OnVarModified |  | cyberpunk/UI/vehicles/car_hud.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| RegisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |
| UnregisterCallbacks |  | cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift |

## Citations

- `cyberpunk/UI/vehicles/carVisualCustomizationTemplatePreview.swift`
- `cyberpunk/UI/vehicles/car_hud.swift`
- `cyberpunk/UI/vehicles/car_race_hud.swift`
- `cyberpunk/UI/vehicles/driver_combat_hud.swift`
- `cyberpunk/UI/vehicles/ink_dex_limo_controller.swift`
- `cyberpunk/UI/vehicles/ink_motorcycle_hud_controller.swift`
- `cyberpunk/UI/vehicles/ink_vehicle_interior_ui_controller.swift`
- `cyberpunk/UI/vehicles/ink_vehicle_ui_controller.swift`
- `cyberpunk/UI/vehicles/remote_control_driving_hud.swift`
- `cyberpunk/UI/vehicles/vcar_controller.swift`
- `cyberpunk/UI/vehicles/vehicle_debug_ui_game_controller.swift`
