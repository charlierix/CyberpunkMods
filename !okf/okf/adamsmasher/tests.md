---
type: "Module"
title: "Test Code"
description: "Test code: disassemble master controller, CPO data access point, CPO voting device, multiplayer test, test step logic, and functional test utils."
resource: "!tests/disassembleMasterController.swift"
tags: ['tests']
timestamp: 2026-07-01T13:00:55Z
---

# Test Code

Test code: disassemble master controller, CPO data access point, CPO voting device, multiplayer test, test step logic, and functional test utils.

## Source Files

- `tests/disassembleMasterController.swift`
- `tests/functionalTestsUtils/AT_UI/AT_UI.swift`
- `tests/functionalTestsUtils/workspots.swift`
- `tests/interactionCPODataAccessPoint.swift`
- `tests/interactionCPOVotingDevice.swift`
- `tests/interactionMultiplayerTest.swift`
- `tests/testStepLogicImport.swift`

## Member Types

**Total declarations: 13**

### Classs (8)

| Name | Bases | Source File |
|------|-------|-------------|
| DisassembleMasterController | MasterController | tests/disassembleMasterController.swift |
| DisassembleMasterControllerPS | MasterControllerPS | tests/disassembleMasterController.swift |
| WorkspotFunctionalTestsDebugListener | IScriptable | tests/functionalTestsUtils/workspots.swift |
| CPOMissionDevice | GameObject | tests/interactionCPODataAccessPoint.swift |
| CPOMissionDataAccessPoint | CPOMissionDevice | tests/interactionCPODataAccessPoint.swift |
| MultiplayerGiveChoiceTokenEvent | Event | tests/interactionCPODataAccessPoint.swift |
| CPOVotingDevice | CPOMissionDevice | tests/interactionCPOVotingDevice.swift |
| muliplayerInteractionTest | GameObject | tests/interactionMultiplayerTest.swift |

### Static Funcs (3)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorArray |  | tests/functionalTestsUtils/AT_UI/AT_UI.swift |
| OperatorOr |  | tests/testStepLogicImport.swift |
| OperatorAnd |  | tests/testStepLogicImport.swift |

### Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| GetActions |  | tests/disassembleMasterController.swift |
| OnDisassembleDevice |  | tests/disassembleMasterController.swift |

## Citations

- `tests/disassembleMasterController.swift`
- `tests/functionalTestsUtils/AT_UI/AT_UI.swift`
- `tests/functionalTestsUtils/workspots.swift`
- `tests/interactionCPODataAccessPoint.swift`
- `tests/interactionCPOVotingDevice.swift`
- `tests/interactionMultiplayerTest.swift`
- `tests/testStepLogicImport.swift`
