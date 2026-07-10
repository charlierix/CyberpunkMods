---
type: "Device System"
title: "Vending Machines"
description: "Vending machines: animated sign, ice machine, ice machine controller, interactive ad, interactive ad controller, vending machine, vending machine controller, vending terminal, vending terminal controller, weapon vending machine, and weapon vending machine controller."
resource: "!cyberpunk/devices/vendingMachines/animatedSign.swift"
tags: ['cyberpunk', 'devices', 'vending-machines']
timestamp: 2026-07-01T13:00:55Z
---

# Vending Machines

Vending machines: animated sign, ice machine, ice machine controller, interactive ad, interactive ad controller, vending machine, vending machine controller, vending terminal, vending terminal controller, weapon vending machine, and weapon vending machine controller.

## Source Files

- `cyberpunk/devices/vendingMachines/animatedSign.swift`
- `cyberpunk/devices/vendingMachines/iceMachine.swift`
- `cyberpunk/devices/vendingMachines/iceMachineController.swift`
- `cyberpunk/devices/vendingMachines/interactiveAd.swift`
- `cyberpunk/devices/vendingMachines/interactiveAdController.swift`
- `cyberpunk/devices/vendingMachines/vendingMachine.swift`
- `cyberpunk/devices/vendingMachines/vendingMachineController.swift`
- `cyberpunk/devices/vendingMachines/vendingTerminal.swift`
- `cyberpunk/devices/vendingMachines/vendingTerminalController.swift`
- `cyberpunk/devices/vendingMachines/weaponVendingMachine.swift`
- `cyberpunk/devices/vendingMachines/weaponVendingMachineController.swift`

## Member Types

**Total declarations: 57**

### Classs (25)

| Name | Bases | Source File |
|------|-------|-------------|
| AnimatedSign | InteractiveDevice | cyberpunk/devices/vendingMachines/animatedSign.swift |
| IceMachine | VendingMachine | cyberpunk/devices/vendingMachines/iceMachine.swift |
| IceMachineController | VendingMachineController | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| IceMachineControllerPS | VendingMachineControllerPS | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| InteractiveAd | InteractiveDevice | cyberpunk/devices/vendingMachines/interactiveAd.swift |
| CloseAd | ActionBool | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| ShowVendor | ActionBool | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| InteractiveAdController | ScriptableDeviceComponent | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| InteractiveAdControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| VendingMachine | InteractiveDevice | cyberpunk/devices/vendingMachines/vendingMachine.swift |
| DispenseFreeItem | Event | cyberpunk/devices/vendingMachines/vendingMachine.swift |
| DispenseFreeSpecificItem | Event | cyberpunk/devices/vendingMachines/vendingMachine.swift |
| DispenseStackOfItems | Event | cyberpunk/devices/vendingMachines/vendingMachine.swift |
| VendingMachineController | ScriptableDeviceComponent | cyberpunk/devices/vendingMachines/vendingMachineController.swift |
| VendingMachineControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/vendingMachines/vendingMachineController.swift |
| VendingTerminal | InteractiveDevice | cyberpunk/devices/vendingMachines/vendingTerminal.swift |
| CraftItemForTarget | ActionBool | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| BuyItemFromVendor | ActionBool | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| SellItemToVendor | ActionBool | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| DispenceItemFromVendor | ActionBool | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| VendingTerminalController | ScriptableDeviceComponent | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| VendingTerminalControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| WeaponVendingMachine | VendingMachine | cyberpunk/devices/vendingMachines/weaponVendingMachine.swift |
| WeaponVendingMachineController | ScriptableDeviceComponent | cyberpunk/devices/vendingMachines/weaponVendingMachineController.swift |
| WeaponVendingMachineControllerPS | VendingMachineControllerPS | cyberpunk/devices/vendingMachines/weaponVendingMachineController.swift |

### Funcs (32)

| Name | Bases | Source File |
|------|-------|-------------|
| GetVendorID |  | cyberpunk/devices/vendingMachines/iceMachine.swift |
| GetGlitchStartSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetGlitchStopSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetTimeToCompletePurchase |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetHackedItemCount |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| OnDispenceItemFromVendor |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| GetActions |  | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| GetQuestActions |  | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| GetVendorID |  | cyberpunk/devices/vendingMachines/iceMachine.swift |
| GetTimeToCompletePurchase |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetGlitchStartSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetGlitchStopSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetHackedItemCount |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetActions |  | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| GetQuestActions |  | cyberpunk/devices/vendingMachines/interactiveAdController.swift |
| OnDispenceItemFromVendor |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| OnQuickHackDistraction |  | cyberpunk/devices/vendingMachines/vendingMachineController.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| CreateActionWidgetPackage |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/vendingMachines/vendingTerminalController.swift |
| GetVendorID |  | cyberpunk/devices/vendingMachines/iceMachine.swift |
| GetTimeToCompletePurchase |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetGlitchStartSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetGlitchStopSFX |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |
| GetHackedItemCount |  | cyberpunk/devices/vendingMachines/iceMachineController.swift |

## Citations

- `cyberpunk/devices/vendingMachines/animatedSign.swift`
- `cyberpunk/devices/vendingMachines/iceMachine.swift`
- `cyberpunk/devices/vendingMachines/iceMachineController.swift`
- `cyberpunk/devices/vendingMachines/interactiveAd.swift`
- `cyberpunk/devices/vendingMachines/interactiveAdController.swift`
- `cyberpunk/devices/vendingMachines/vendingMachine.swift`
- `cyberpunk/devices/vendingMachines/vendingMachineController.swift`
- `cyberpunk/devices/vendingMachines/vendingTerminal.swift`
- `cyberpunk/devices/vendingMachines/vendingTerminalController.swift`
- `cyberpunk/devices/vendingMachines/weaponVendingMachine.swift`
- `cyberpunk/devices/vendingMachines/weaponVendingMachineController.swift`
