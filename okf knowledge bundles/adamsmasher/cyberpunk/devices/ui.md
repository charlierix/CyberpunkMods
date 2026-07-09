---
type: "UI System"
title: "Device UI"
description: "Device UI: access point, action buttons, apartment screen, arcade machine, backdoor, backdoor data stream, computer (banner, bunker, document, document thumbnail, full banner, game controller, inner bunker, main layout, main menu, menu button, menu, Yaiba showroom, news feed), confessional, core (action controller, button logic, device controller, game controller, logic controller, thumbnail controller, master game controller), data term, door, drop point terminal, electric box, elevator (arrows, game controller, numeric display), interactive signs, intercom, internet (Yaiba showroom, browser, vehicle brand filter, vehicle details, vehicle offer, vehicle shop), jukebox (big screen, main), keypad, visibility, LCD screen (game controller, logic controller, sign), NCART timetable, network (controlled device logic, controlled devices), radio, smart house, smart window, systems, terminal (elevator, game controller, main layout), TV (display glass, scene screen, device logic, game controller), vending machine (simple bink, ice machine, image action, interactive ad, vending machine, weapon machine)."
resource: "!cyberpunk/devices/UI/accessPoint/accessPointGameController.swift"
tags: ['cyberpunk', 'devices', 'ui']
timestamp: 2026-07-01T13:00:55Z
---

# Device UI

Device UI: access point, action buttons, apartment screen, arcade machine, backdoor, backdoor data stream, computer (banner, bunker, document, document thumbnail, full banner, game controller, inner bunker, main layout, main menu, menu button, menu, Yaiba showroom, news feed), confessional, core (action controller, button logic, device controller, game controller, logic controller, thumbnail controller, master game controller), data term, door, drop point terminal, electric box, elevator (arrows, game controller, numeric display), interactive signs, intercom, internet (Yaiba showroom, browser, vehicle brand filter, vehicle details, vehicle offer, vehicle shop), jukebox (big screen, main), keypad, visibility, LCD screen (game controller, logic controller, sign), NCART timetable, network (controlled device logic, controlled devices), radio, smart house, smart window, systems, terminal (elevator, game controller, main layout), TV (display glass, scene screen, device logic, game controller), vending machine (simple bink, ice machine, image action, interactive ad, vending machine, weapon machine).

## Source Files

- `cyberpunk/devices/UI/accessPoint/accessPointGameController.swift`
- `cyberpunk/devices/UI/accessPoint/accessPointGameVisualController.swift`
- `cyberpunk/devices/UI/accessPoint/inkButtonTintController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameBufferController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameEndScreenController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameGridController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift`
- `cyberpunk/devices/UI/actionButtons/callActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/payActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/playPauseActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/vendorItemActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/weaponVendorActionLogicController.swift`
- `cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift`
- `cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift`
- `cyberpunk/devices/UI/backDoor/backDoorGameController.swift`
- `cyberpunk/devices/UI/backdoorDataStream.swift`
- `cyberpunk/devices/UI/computer/computerBannerController.swift`
- `cyberpunk/devices/UI/computer/computerBunkerControllers.swift`
- `cyberpunk/devices/UI/computer/computerDocumentController.swift`
- `cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift`
- `cyberpunk/devices/UI/computer/computerFullBannerController.swift`
- `cyberpunk/devices/UI/computer/computerGameController.swift`
- `cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift`
- `cyberpunk/devices/UI/computer/computerMainLayoutController.swift`
- `cyberpunk/devices/UI/computer/computerMainMenuController.swift`
- `cyberpunk/devices/UI/computer/computerMenuButtonController.swift`
- `cyberpunk/devices/UI/computer/computerMenuController.swift`
- `cyberpunk/devices/UI/computer/computerYaibaShowroom.swift`
- `cyberpunk/devices/UI/computer/newsFeedMenuController.swift`
- `cyberpunk/devices/UI/confessional/confessionalGameController.swift`
- `cyberpunk/devices/UI/core/deviceActionControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceButtonLogicControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceDeviceControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceGameControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceLogicControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceThumbnailControllerBase.swift`
- `cyberpunk/devices/UI/core/masterDeviceGameControllerBase.swift`
- `cyberpunk/devices/UI/dataTerm/dataTermGameController.swift`
- `cyberpunk/devices/UI/door/doorGameController.swift`
- `cyberpunk/devices/UI/door/doorTerminalMasterGameController.swift`
- `cyberpunk/devices/UI/drop_point_terminal/dropPointTerminalGameController.swift`
- `cyberpunk/devices/UI/electricBox/electricBoxGameController.swift`
- `cyberpunk/devices/UI/elevator/elevatorArrowsLogicController.swift`
- `cyberpunk/devices/UI/elevator/elevatorGameController.swift`
- `cyberpunk/devices/UI/elevator/numericDisplayUIController.swift`
- `cyberpunk/devices/UI/interactiveSigns/inkInteractiveSignGameController.swift`
- `cyberpunk/devices/UI/intercom/intercomGameController.swift`
- `cyberpunk/devices/UI/internet/YaibaShowroom.swift`
- `cyberpunk/devices/UI/internet/browserController.swift`
- `cyberpunk/devices/UI/internet/vehicleBrandFilterLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleDetailsLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleOfferLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleShopGameController.swift`
- `cyberpunk/devices/UI/jukebox/jukeboxBigScreenGameController.swift`
- `cyberpunk/devices/UI/jukebox/jukeboxGameController.swift`
- `cyberpunk/devices/UI/layout/keypadSimpleController.swift`
- `cyberpunk/devices/UI/layout/visibilitySimpleController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenGameController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenLogicController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenSignGameController.swift`
- `cyberpunk/devices/UI/ncartTimeTable/ncartTimetableGameController.swift`
- `cyberpunk/devices/UI/network/controlledDeviceLogicController.swift`
- `cyberpunk/devices/UI/network/controlledDevicesGameController.swift`
- `cyberpunk/devices/UI/radio/radioGameController.swift`
- `cyberpunk/devices/UI/smartHouse/smartHouseDeviceLogicController.swift`
- `cyberpunk/devices/UI/smartWindow/smartWindowGameController.swift`
- `cyberpunk/devices/UI/smartWindow/smartWindowMainLayoutController.swift`
- `cyberpunk/devices/UI/systems/systemDeviceWidgetController.swift`
- `cyberpunk/devices/UI/terminal/elevatorTerminalLogicController.swift`
- `cyberpunk/devices/UI/terminal/terminalGameController.swift`
- `cyberpunk/devices/UI/terminal/terminalMainLayoutController.swift`
- `cyberpunk/devices/UI/tv/displayGlassGameController.swift`
- `cyberpunk/devices/UI/tv/sceneScreenGameController.swift`
- `cyberpunk/devices/UI/tv/tvDeviceLogicController.swift`
- `cyberpunk/devices/UI/tv/tvGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/SimpleBinkGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/iceMachineGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/imageActionButtonLogicController.swift`
- `cyberpunk/devices/UI/vendingMachine/interactiveAdGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/vendingMachineGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/weaponMachineInkGameController.swift`

## Member Types

**Total declarations: 269**

### Classs (123)

| Name | Bases | Source File |
|------|-------|-------------|
| NetworkInkGameController | inkGameController | cyberpunk/devices/UI/accessPoint/accessPointGameController.swift |
| NetworkMinigameVisualController | inkLogicController | cyberpunk/devices/UI/accessPoint/accessPointGameVisualController.swift |
| NetworkMinigameAnimationCallManager | inkLogicController | cyberpunk/devices/UI/accessPoint/accessPointGameVisualController.swift |
| NetworkMinigameAnimationCallbacksTransmitter | inkLogicController | cyberpunk/devices/UI/accessPoint/accessPointGameVisualController.swift |
| inkButtonTintController | inkButtonController | cyberpunk/devices/UI/accessPoint/inkButtonTintController.swift |
| NetworkMinigameBufferController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameBufferController.swift |
| NetworkMinigameElementController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| NetworkMinigameAnimatedElementController | NetworkMinigameElementController | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| NetworkMinigameEndScreenController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameEndScreenController.swift |
| NetworkMinigameGridController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameGridController.swift |
| NetworkMinigameGridCellController | inkButtonController | cyberpunk/devices/UI/accessPoint/networkMinigameGridController.swift |
| NetworkMinigameProgramController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift |
| NetworkMinigameBasicProgramController | NetworkMinigameProgramController | cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift |
| NetworkMinigameProgramListController | inkLogicController | cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift |
| CallActionWidgetController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| NextPreviousActionWidgetController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift |
| PayActionWidgetController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/actionButtons/payActionLogicController.swift |
| PlayPauseActionWidgetController | NextPreviousActionWidgetController | cyberpunk/devices/UI/actionButtons/playPauseActionLogicController.swift |
| VendorItemActionWidgetController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/actionButtons/vendorItemActionLogicController.swift |
| WeaponVendorActionWidgetController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/actionButtons/weaponVendorActionLogicController.swift |
| ApartmentScreenInkGameController | LcdScreenInkGameController | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| ArcadeMachineInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| BackdoorInkGameController | MasterDeviceInkGameControllerBase | cyberpunk/devices/UI/backDoor/backDoorGameController.swift |
| BackdoorDataStreamController | BackdoorInkGameController | cyberpunk/devices/UI/backdoorDataStream.swift |
| TextSpawnerController | inkLogicController | cyberpunk/devices/UI/backdoorDataStream.swift |
| ComputerBannerWidgetController | DeviceInkLogicControllerBase | cyberpunk/devices/UI/computer/computerBannerController.swift |
| BaseBunkerComputerGameController | gameuiBaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| StatusScreenGameController | BaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| SystemStatusLogicController | inkLogicController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| GateStatusLogicController | inkLogicController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| OpeningGateScreenGameController | BaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| SystemConsoleLogicController | inkLogicController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| GateSchemeLogicController | inkLogicController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| DatatermLoginGameController | BaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| DatatermDetailGameController | BaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| BunkerComputerButtonController | LinkController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| BunkerMapGameController | StatusScreenGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| BunkerComputerController | ComputerController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| BunkerComputerControllerPS | ComputerControllerPS | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| OuterBunkerComputerEntranceGameController | gameuiBaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| ComputerDocumentWidgetController | DeviceInkLogicControllerBase | cyberpunk/devices/UI/computer/computerDocumentController.swift |
| ComputerDocumentThumbnailWidgetController | DeviceButtonLogicControllerBase | cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift |
| ComputerFullBannerWidgetController | ComputerBannerWidgetController | cyberpunk/devices/UI/computer/computerFullBannerController.swift |
| ComputerInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/computer/computerGameController.swift |
| BaseInnerBunkerComputerGameController | gameuiBaseBunkerComputerGameController | cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift |
| InnerBunkerCoreScreenGameController | BaseInnerBunkerComputerGameController | cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift |
| InnerBunkerSystemStatusLogicController | inkLogicController | cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift |
| InnerSubsystemScreenGameController | BaseInnerBunkerComputerGameController | cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift |
| InnerAdminPanelScreenGameController | BaseInnerBunkerComputerGameController | cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift |
| ComputerMainLayoutWidgetController | inkLogicController | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ComputerMainMenuWidgetController | inkLogicController | cyberpunk/devices/UI/computer/computerMainMenuController.swift |
| ComputerMenuButtonController | DeviceButtonLogicControllerBase | cyberpunk/devices/UI/computer/computerMenuButtonController.swift |
| ComputerMenuWidgetController | inkLogicController | cyberpunk/devices/UI/computer/computerMenuController.swift |
| CheckYaibaOption | inkLogicController | cyberpunk/devices/UI/computer/computerYaibaShowroom.swift |
| YaibaOptionPreview | inkLogicController | cyberpunk/devices/UI/computer/computerYaibaShowroom.swift |
| YaibaButton | inkButtonController | cyberpunk/devices/UI/computer/computerYaibaShowroom.swift |
| ComputerYaibaShowroomController | inkGameController | cyberpunk/devices/UI/computer/computerYaibaShowroom.swift |
| NewsFeedMenuWidgetController | inkLogicController | cyberpunk/devices/UI/computer/newsFeedMenuController.swift |
| ConfessionalInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/confessional/confessionalGameController.swift |
| DeviceActionWidgetControllerBase | DeviceButtonLogicControllerBase | cyberpunk/devices/UI/core/deviceActionControllerBase.swift |
| DeviceButtonLogicControllerBase | inkButtonController | cyberpunk/devices/UI/core/deviceButtonLogicControllerBase.swift |
| DeviceWidgetControllerBase | DeviceInkLogicControllerBase | cyberpunk/devices/UI/core/deviceDeviceControllerBase.swift |
| AsyncSpawnData | IScriptable | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| DoorWidgetCustomData | WidgetCustomData | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| LiftWidgetCustomData | WidgetCustomData | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| DeviceInkGameControllerBase | inkGameController | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| DeviceInkLogicControllerBase | inkLogicController | cyberpunk/devices/UI/core/deviceLogicControllerBase.swift |
| DeviceThumbnailWidgetControllerBase | DeviceButtonLogicControllerBase | cyberpunk/devices/UI/core/deviceThumbnailControllerBase.swift |
| MasterDeviceInkGameControllerBase | DeviceInkGameControllerBase | cyberpunk/devices/UI/core/masterDeviceGameControllerBase.swift |
| DataTermInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/dataTerm/dataTermGameController.swift |
| DoorInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/door/doorGameController.swift |
| DoorTerminalMasterInkGameControllerBase | MasterDeviceInkGameControllerBase | cyberpunk/devices/UI/door/doorTerminalMasterGameController.swift |
| DropPointTerminalInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/drop_point_terminal/dropPointTerminalGameController.swift |
| ElectricBoxInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/electricBox/electricBoxGameController.swift |
| ElevatorArrowsLogicController | DeviceInkLogicControllerBase | cyberpunk/devices/UI/elevator/elevatorArrowsLogicController.swift |
| ElevatorInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/elevator/elevatorGameController.swift |
| ElevatorTerminalFakeGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/elevator/elevatorGameController.swift |
| NumericDispalyUIController | DeviceInkGameControllerBase | cyberpunk/devices/UI/elevator/numericDisplayUIController.swift |
| InteractiveSignCustomData | WidgetCustomData | cyberpunk/devices/UI/interactiveSigns/inkInteractiveSignGameController.swift |
| InteractiveSignInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/interactiveSigns/inkInteractiveSignGameController.swift |
| IntercomInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/intercom/intercomGameController.swift |
| YaibaShowroomConnectionPage | inkGameController | cyberpunk/devices/UI/internet/YaibaShowroom.swift |
| BrowserGameController | inkGameController | cyberpunk/devices/UI/internet/browserController.swift |
| BrowserController | inkLogicController | cyberpunk/devices/UI/internet/browserController.swift |
| LinkController | inkButtonController | cyberpunk/devices/UI/internet/browserController.swift |
| WebPage | inkLogicController | cyberpunk/devices/UI/internet/browserController.swift |
| WebsiteLoadingSpinner | inkLogicController | cyberpunk/devices/UI/internet/browserController.swift |
| VehicleBrandFilterLogicController | BaseButtonView | cyberpunk/devices/UI/internet/vehicleBrandFilterLogicController.swift |
| VehicleDetailsLogicController | inkLogicController | cyberpunk/devices/UI/internet/vehicleDetailsLogicController.swift |
| VehicleOfferLogicController | BaseButtonView | cyberpunk/devices/UI/internet/vehicleOfferLogicController.swift |
| gameuiVehicleShopGameController | inkGameController | cyberpunk/devices/UI/internet/vehicleShopGameController.swift |
| VehicleShopUtils | IScriptable | cyberpunk/devices/UI/internet/vehicleShopGameController.swift |
| VehicleShopPlayerBalanceCallback | InventoryScriptCallback | cyberpunk/devices/UI/internet/vehicleShopGameController.swift |
| JukeboxBigGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/jukebox/jukeboxBigScreenGameController.swift |
| JukeboxInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/jukebox/jukeboxGameController.swift |
| KeypadButtonSpawnData | IScriptable | cyberpunk/devices/UI/layout/keypadSimpleController.swift |
| KeypadDeviceController | DeviceWidgetControllerBase | cyberpunk/devices/UI/layout/keypadSimpleController.swift |
| VisibilitySimpleControllerBase | inkLogicController | cyberpunk/devices/UI/layout/visibilitySimpleController.swift |
| LcdScreenInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/lcdScreen/lcdScreenGameController.swift |
| LcdScreenILogicController | inkLogicController | cyberpunk/devices/UI/lcdScreen/lcdScreenLogicController.swift |
| LcdScreenSignInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/lcdScreen/lcdScreenSignGameController.swift |
| NcartTimetableInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/ncartTimeTable/ncartTimetableGameController.swift |
| ControlledDeviceLogicController | inkLogicController | cyberpunk/devices/UI/network/controlledDeviceLogicController.swift |
| ControlledDevicesInkGameController | inkGameController | cyberpunk/devices/UI/network/controlledDevicesGameController.swift |
| RadioInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/radio/radioGameController.swift |
| SmartHouseDeviceWidgetController | DeviceWidgetControllerBase | cyberpunk/devices/UI/smartHouse/smartHouseDeviceLogicController.swift |
| SmartWindowInkGameController | ComputerInkGameController | cyberpunk/devices/UI/smartWindow/smartWindowGameController.swift |
| SmartWindowMainLayoutWidgetController | ComputerMainLayoutWidgetController | cyberpunk/devices/UI/smartWindow/smartWindowMainLayoutController.swift |
| SystemDeviceWidgetController | DeviceWidgetControllerBase | cyberpunk/devices/UI/systems/systemDeviceWidgetController.swift |
| ElevatorTerminalLogicController | DeviceWidgetControllerBase | cyberpunk/devices/UI/terminal/elevatorTerminalLogicController.swift |
| TerminalInkGameControllerBase | MasterDeviceInkGameControllerBase | cyberpunk/devices/UI/terminal/terminalGameController.swift |
| TerminalMainLayoutWidgetController | inkLogicController | cyberpunk/devices/UI/terminal/terminalMainLayoutController.swift |
| DisplayGlassInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/tv/displayGlassGameController.swift |
| SceneScreenGameController | inkGameController | cyberpunk/devices/UI/tv/sceneScreenGameController.swift |
| TvDeviceWidgetController | DeviceWidgetControllerBase | cyberpunk/devices/UI/tv/tvDeviceLogicController.swift |
| TvChannelSpawnData | IScriptable | cyberpunk/devices/UI/tv/tvGameController.swift |
| TvInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/tv/tvGameController.swift |
| SimpleBinkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/vendingMachine/SimpleBinkGameController.swift |
| IceMachineInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/vendingMachine/iceMachineGameController.swift |
| ImageActionButtonLogicController | DeviceActionWidgetControllerBase | cyberpunk/devices/UI/vendingMachine/imageActionButtonLogicController.swift |
| InteractiveAdInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/vendingMachine/interactiveAdGameController.swift |
| VendingMachineInkGameController | DeviceInkGameControllerBase | cyberpunk/devices/UI/vendingMachine/vendingMachineGameController.swift |
| WeaponMachineInkGameController | VendingMachineInkGameController | cyberpunk/devices/UI/vendingMachine/weaponMachineInkGameController.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| SWidgetPackageBase |  | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |

### Static Funcs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorEqual |  | cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift |

### Funcs (144)

| Name | Bases | Source File |
|------|-------|-------------|
| SetContent |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| SetHighlightStatus |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| Consume |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| SetContent |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| SetHighlightStatus |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| Consume |  | cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift |
| ShowCompleted |  | cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift |
| ShowCompleted |  | cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Decline |  | cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift |
| Reset |  | cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Reset |  | cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| OnToggleZoomInteraction |  | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| OnQuestForceCameraZoom |  | cyberpunk/devices/UI/computer/computerBunkerControllers.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| ResolveSelection |  | cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| SetDevicesMenu |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| GetComputerInkLibraryPath |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| GetTerminalInkLibraryPath |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| UpdateMenuButtonsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateMainMenuButtonsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateBannersWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateMailsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateFilesWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateMailsThumbnailsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateFilesThumbnailsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| GetMainLayoutController |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| InitializeMenuButtons |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetTopNavigationBarHidden |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetScreenSaver |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetWallpaper |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetMailsMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetFilesMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetDevicesMenu |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| SetNewsFeedMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetMainMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetInternetMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowNewsfeed |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowMails |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowFiles |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowDevices |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowMainMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowInternet |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetDevicesMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetNewsfeedMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetMailsMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetFilesMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| InitializeMenuButtons |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| InitializeFiles |  | cyberpunk/devices/UI/computer/computerMenuController.swift |
| InitializeFilesThumbnails |  | cyberpunk/devices/UI/computer/computerMenuController.swift |
| InitializeBanners |  | cyberpunk/devices/UI/computer/newsFeedMenuController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| ClearButtonActions |  | cyberpunk/devices/UI/core/deviceActionControllerBase.swift |
| FinalizeActionExecution |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| ToggleSelection |  | cyberpunk/devices/UI/core/deviceButtonLogicControllerBase.swift |
| ResolveSelection |  | cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift |
| RegisterBaseInputCallbacks |  | cyberpunk/devices/UI/core/deviceButtonLogicControllerBase.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| GetParentForActionWidgets |  | cyberpunk/devices/UI/core/deviceDeviceControllerBase.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| UpdateDeviceWidgets |  | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| UpdateBreadCrumbBar |  | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateDeviceWidgets |  | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| OnItemQuantityChanged |  | cyberpunk/devices/UI/internet/vehicleShopGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| ResolveMessegeRecord |  | cyberpunk/devices/UI/lcdScreen/lcdScreenLogicController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| UpdateControlledDevicesWidgets |  | cyberpunk/devices/UI/network/controlledDevicesGameController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| GetMainLayoutController |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateMailsWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| UpdateFilesWidgets |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| GetDevicesMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetNewsfeedMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetMailsMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| GetFilesMenuContainer |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetMailsMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetFilesMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| SetDevicesMenu |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| SetNewsFeedMenu |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowNewsfeed |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowMails |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowFiles |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| ShowDevices |  | cyberpunk/devices/UI/computer/computerMainLayoutController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| UpdateBreadCrumbBar |  | cyberpunk/devices/UI/core/deviceGameControllerBase.swift |
| GetMainLayoutController |  | cyberpunk/devices/UI/computer/computerGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| Refresh |  | cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift |
| TurnOn |  | cyberpunk/devices/UI/tv/tvGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| Initialize |  | cyberpunk/devices/UI/actionButtons/callActionLogicController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |
| UpdateActionWidgets |  | cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift |

## Citations

- `cyberpunk/devices/UI/accessPoint/accessPointGameController.swift`
- `cyberpunk/devices/UI/accessPoint/accessPointGameVisualController.swift`
- `cyberpunk/devices/UI/accessPoint/inkButtonTintController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameBufferController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameElementController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameEndScreenController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameGridController.swift`
- `cyberpunk/devices/UI/accessPoint/networkMinigameProgramController.swift`
- `cyberpunk/devices/UI/actionButtons/callActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/nextPreviousActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/payActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/playPauseActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/vendorItemActionLogicController.swift`
- `cyberpunk/devices/UI/actionButtons/weaponVendorActionLogicController.swift`
- `cyberpunk/devices/UI/apartmentScreen/apartmentScreenGameController.swift`
- `cyberpunk/devices/UI/arcadeMachine/arcadeMachineGameController.swift`
- `cyberpunk/devices/UI/backDoor/backDoorGameController.swift`
- `cyberpunk/devices/UI/backdoorDataStream.swift`
- `cyberpunk/devices/UI/computer/computerBannerController.swift`
- `cyberpunk/devices/UI/computer/computerBunkerControllers.swift`
- `cyberpunk/devices/UI/computer/computerDocumentController.swift`
- `cyberpunk/devices/UI/computer/computerDocumentThumbnailController.swift`
- `cyberpunk/devices/UI/computer/computerFullBannerController.swift`
- `cyberpunk/devices/UI/computer/computerGameController.swift`
- `cyberpunk/devices/UI/computer/computerInnerBunkerControllers.swift`
- `cyberpunk/devices/UI/computer/computerMainLayoutController.swift`
- `cyberpunk/devices/UI/computer/computerMainMenuController.swift`
- `cyberpunk/devices/UI/computer/computerMenuButtonController.swift`
- `cyberpunk/devices/UI/computer/computerMenuController.swift`
- `cyberpunk/devices/UI/computer/computerYaibaShowroom.swift`
- `cyberpunk/devices/UI/computer/newsFeedMenuController.swift`
- `cyberpunk/devices/UI/confessional/confessionalGameController.swift`
- `cyberpunk/devices/UI/core/deviceActionControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceButtonLogicControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceDeviceControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceGameControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceLogicControllerBase.swift`
- `cyberpunk/devices/UI/core/deviceThumbnailControllerBase.swift`
- `cyberpunk/devices/UI/core/masterDeviceGameControllerBase.swift`
- `cyberpunk/devices/UI/dataTerm/dataTermGameController.swift`
- `cyberpunk/devices/UI/door/doorGameController.swift`
- `cyberpunk/devices/UI/door/doorTerminalMasterGameController.swift`
- `cyberpunk/devices/UI/drop_point_terminal/dropPointTerminalGameController.swift`
- `cyberpunk/devices/UI/electricBox/electricBoxGameController.swift`
- `cyberpunk/devices/UI/elevator/elevatorArrowsLogicController.swift`
- `cyberpunk/devices/UI/elevator/elevatorGameController.swift`
- `cyberpunk/devices/UI/elevator/numericDisplayUIController.swift`
- `cyberpunk/devices/UI/interactiveSigns/inkInteractiveSignGameController.swift`
- `cyberpunk/devices/UI/intercom/intercomGameController.swift`
- `cyberpunk/devices/UI/internet/YaibaShowroom.swift`
- `cyberpunk/devices/UI/internet/browserController.swift`
- `cyberpunk/devices/UI/internet/vehicleBrandFilterLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleDetailsLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleOfferLogicController.swift`
- `cyberpunk/devices/UI/internet/vehicleShopGameController.swift`
- `cyberpunk/devices/UI/jukebox/jukeboxBigScreenGameController.swift`
- `cyberpunk/devices/UI/jukebox/jukeboxGameController.swift`
- `cyberpunk/devices/UI/layout/keypadSimpleController.swift`
- `cyberpunk/devices/UI/layout/visibilitySimpleController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenGameController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenLogicController.swift`
- `cyberpunk/devices/UI/lcdScreen/lcdScreenSignGameController.swift`
- `cyberpunk/devices/UI/ncartTimeTable/ncartTimetableGameController.swift`
- `cyberpunk/devices/UI/network/controlledDeviceLogicController.swift`
- `cyberpunk/devices/UI/network/controlledDevicesGameController.swift`
- `cyberpunk/devices/UI/radio/radioGameController.swift`
- `cyberpunk/devices/UI/smartHouse/smartHouseDeviceLogicController.swift`
- `cyberpunk/devices/UI/smartWindow/smartWindowGameController.swift`
- `cyberpunk/devices/UI/smartWindow/smartWindowMainLayoutController.swift`
- `cyberpunk/devices/UI/systems/systemDeviceWidgetController.swift`
- `cyberpunk/devices/UI/terminal/elevatorTerminalLogicController.swift`
- `cyberpunk/devices/UI/terminal/terminalGameController.swift`
- `cyberpunk/devices/UI/terminal/terminalMainLayoutController.swift`
- `cyberpunk/devices/UI/tv/displayGlassGameController.swift`
- `cyberpunk/devices/UI/tv/sceneScreenGameController.swift`
- `cyberpunk/devices/UI/tv/tvDeviceLogicController.swift`
- `cyberpunk/devices/UI/tv/tvGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/SimpleBinkGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/iceMachineGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/imageActionButtonLogicController.swift`
- `cyberpunk/devices/UI/vendingMachine/interactiveAdGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/vendingMachineGameController.swift`
- `cyberpunk/devices/UI/vendingMachine/weaponMachineInkGameController.swift`
