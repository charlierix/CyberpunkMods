---
type: "UI System"
title: "Scanner HUD"
description: "Scanner HUD: main controller, border, chunks, crosshair, data, details, details elements, hint, and skill checks."
resource: "!cyberpunk/UI/hud/scanner/scanner.swift"
tags: ['cyberpunk', 'ui', 'hud', 'scanner']
timestamp: 2026-07-01T13:00:55Z
---

# Scanner HUD

Scanner HUD: main controller, border, chunks, crosshair, data, details, details elements, hint, and skill checks.

## Source Files

- `cyberpunk/UI/hud/scanner/scanner.swift`
- `cyberpunk/UI/hud/scanner/scanner_border.swift`
- `cyberpunk/UI/hud/scanner/scanner_chunks.swift`
- `cyberpunk/UI/hud/scanner/scanner_crosshair.swift`
- `cyberpunk/UI/hud/scanner/scanner_data.swift`
- `cyberpunk/UI/hud/scanner/scanner_details.swift`
- `cyberpunk/UI/hud/scanner/scanner_details_elements.swift`
- `cyberpunk/UI/hud/scanner/scanner_hint.swift`
- `cyberpunk/UI/hud/scanner/scanner_skill_checks.swift`

## Member Types

**Total declarations: 93**

### Classs (61)

| Name | Bases | Source File |
|------|-------|-------------|
| scannerGameController | inkHUDGameController | cyberpunk/UI/hud/scanner/scanner.swift |
| scannerBorderLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_border.swift |
| scannerBorderGameController | inkProjectedHUDGameController | cyberpunk/UI/hud/scanner/scanner_border.swift |
| BaseChunkGameController | inkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerNPCHeaderGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerDeviceHeaderGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerNPCBodyGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerDeviceBodyGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerBountySystemGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerVulnerabilitiesGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerVulnerabilityItemLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerAbilitiesGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerAbilityItemLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerResistancesGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerDescriptionGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerRequirementsGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerRequirementItemLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerQuestCluesGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannervehicleGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| QuickHackDescriptionGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| TwintoneDescriptionGameController | BaseChunkGameController | cyberpunk/UI/hud/scanner/scanner_chunks.swift |
| ScannerCrosshairLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_crosshair.swift |
| ScannerChunk | IScriptable | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerBountySystem | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerName | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerLevel | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerRarity | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerArchetype | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerWeaponBasic | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerWeaponDetailed | ScannerWeaponBasic | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerHealth | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVulnerabilities | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerFaction | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerSquadInfo | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerResistances | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerAbilities | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerAttitude | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerDeviceStatus | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerNetworkLevel | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerNetworkStatus | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerAuthorization | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerDescription | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerSkillchecks | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerConnections | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleName | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleManufacturer | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleProdYears | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleDriveLayout | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleHorsepower | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleMass | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleState | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleInfo | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerQuickHackDescription | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| ScannerVehicleCustomizationTemplate | ScannerChunk | cyberpunk/UI/hud/scanner/scanner_data.swift |
| scannerDetailsGameController | inkHUDGameController | cyberpunk/UI/hud/scanner/scanner_details.swift |
| ScannerQuestClue | inkLogicController | cyberpunk/UI/hud/scanner/scanner_details_elements.swift |
| ScannerHintInkGameController | inkGameController | cyberpunk/UI/hud/scanner/scanner_hint.swift |
| ScannerSkillCheckLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_skill_checks.swift |
| ScannerSkillCheckItemLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_skill_checks.swift |
| ScannerSkillCheckConditionDataItemLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_skill_checks.swift |
| ScannerSkillCheckConditionDescriptionLogicController | inkLogicController | cyberpunk/UI/hud/scanner/scanner_skill_checks.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| BountyUI |  | cyberpunk/UI/hud/scanner/scanner_data.swift |

### Funcs (31)

| Name | Bases | Source File |
|------|-------|-------------|
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |
| GetType |  | cyberpunk/UI/hud/scanner/scanner_data.swift |

## Citations

- `cyberpunk/UI/hud/scanner/scanner.swift`
- `cyberpunk/UI/hud/scanner/scanner_border.swift`
- `cyberpunk/UI/hud/scanner/scanner_chunks.swift`
- `cyberpunk/UI/hud/scanner/scanner_crosshair.swift`
- `cyberpunk/UI/hud/scanner/scanner_data.swift`
- `cyberpunk/UI/hud/scanner/scanner_details.swift`
- `cyberpunk/UI/hud/scanner/scanner_details_elements.swift`
- `cyberpunk/UI/hud/scanner/scanner_hint.swift`
- `cyberpunk/UI/hud/scanner/scanner_skill_checks.swift`
