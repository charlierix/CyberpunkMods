---
type: "Class System"
title: "Puppet System"
description: "Puppet system: puppet actions, scripted puppet, and scripted puppet PS."
resource: "!cyberpunk/puppet/puppetActions.swift"
tags: ['cyberpunk', 'puppet']
timestamp: 2026-07-01T13:00:55Z
---

# Puppet System

Puppet system: puppet actions, scripted puppet, and scripted puppet PS.

## Source Files

- `cyberpunk/puppet/puppetActions.swift`
- `cyberpunk/puppet/scriptedPuppet.swift`
- `cyberpunk/puppet/scriptedPuppetPS.swift`

## Member Types

**Total declarations: 24**

### Classs (12)

| Name | Bases | Source File |
|------|-------|-------------|
| PuppetAction | ScriptableDeviceAction | cyberpunk/puppet/puppetActions.swift |
| AIQuickHackAction | PuppetAction | cyberpunk/puppet/puppetActions.swift |
| LinkedStatusEffectListener | ScriptStatusEffectListener | cyberpunk/puppet/puppetActions.swift |
| PingSquad | PuppetAction | cyberpunk/puppet/puppetActions.swift |
| AccessBreach | PuppetAction | cyberpunk/puppet/puppetActions.swift |
| RevealRequestEvent | Event | cyberpunk/puppet/scriptedPuppet.swift |
| RevealRequestsStorage | IScriptable | cyberpunk/puppet/scriptedPuppet.swift |
| PuppetListener | IScriptable | cyberpunk/puppet/scriptedPuppet.swift |
| ScriptedPuppet | gamePuppet | cyberpunk/puppet/scriptedPuppet.swift |
| OverrideScannerPreset | Event | cyberpunk/puppet/scriptedPuppetPS.swift |
| ResetScannerPreset | Event | cyberpunk/puppet/scriptedPuppetPS.swift |
| ScriptedPuppetPS | GamePuppetPS | cyberpunk/puppet/scriptedPuppetPS.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| SecuritySystemData |  | cyberpunk/puppet/scriptedPuppetPS.swift |

### Funcs (11)

| Name | Bases | Source File |
|------|-------|-------------|
| GetTweakDBChoiceRecord |  | cyberpunk/puppet/puppetActions.swift |
| GetTweakDBChoiceID |  | cyberpunk/puppet/puppetActions.swift |
| OnStatusEffectRemoved |  | cyberpunk/puppet/puppetActions.swift |
| Kill |  | cyberpunk/puppet/scriptedPuppet.swift |
| SoftKill |  | cyberpunk/puppet/scriptedPuppet.swift |
| AddRecordEquipment |  | cyberpunk/puppet/scriptedPuppet.swift |
| SetSenseObjectType |  | cyberpunk/puppet/scriptedPuppet.swift |
| HasPrimaryOrSecondaryEquipment |  | cyberpunk/puppet/scriptedPuppet.swift |
| SetCurrentlyUploadingAction |  | cyberpunk/puppet/scriptedPuppet.swift |
| GetCurrentlyUploadingAction |  | cyberpunk/puppet/scriptedPuppet.swift |
| GenerateContext |  | cyberpunk/puppet/scriptedPuppetPS.swift |

## Citations

- `cyberpunk/puppet/puppetActions.swift`
- `cyberpunk/puppet/scriptedPuppet.swift`
- `cyberpunk/puppet/scriptedPuppetPS.swift`
