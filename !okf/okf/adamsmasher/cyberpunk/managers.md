---
type: "Game System"
title: "Game Managers"
description: "Game managers: bounty, cooldown storage, NPC, quick slots, RPG, stats, and targets."
resource: "!cyberpunk/managers/bountyManager.swift"
tags: ['cyberpunk', 'managers']
timestamp: 2026-07-01T13:00:55Z
---

# Game Managers

Game managers: bounty, cooldown storage, NPC, quick slots, RPG, stats, and targets.

## Source Files

- `cyberpunk/managers/bountyManager.swift`
- `cyberpunk/managers/cooldownStorage.swift`
- `cyberpunk/managers/npcManager.swift`
- `cyberpunk/managers/quickSlotsManager.swift`
- `cyberpunk/managers/rpgManager.swift`
- `cyberpunk/managers/statsManager.swift`
- `cyberpunk/managers/targetsManager.swift`

## Member Types

**Total declarations: 30**

### Classs (19)

| Name | Bases | Source File |
|------|-------|-------------|
| BountyManager | IScriptable | cyberpunk/managers/bountyManager.swift |
| SetBountyEvent | Event | cyberpunk/managers/bountyManager.swift |
| CooldownRequest | IScriptable | cyberpunk/managers/cooldownStorage.swift |
| CooldownPackage | IScriptable | cyberpunk/managers/cooldownStorage.swift |
| CooldownStorage | IScriptable | cyberpunk/managers/cooldownStorage.swift |
| NPCManager | IScriptable | cyberpunk/managers/npcManager.swift |
| QuickSlotsManagerPS | GameComponentPS | cyberpunk/managers/quickSlotsManager.swift |
| QuickSlotsManager | ScriptableComponent | cyberpunk/managers/quickSlotsManager.swift |
| RPGManager | IScriptable | cyberpunk/managers/rpgManager.swift |
| MathHelper | IScriptable | cyberpunk/managers/rpgManager.swift |
| StatusEffectTriggerListener | CustomValueStatPoolsListener | cyberpunk/managers/rpgManager.swift |
| PhoneCallUploadDurationListener | CustomValueStatPoolsListener | cyberpunk/managers/rpgManager.swift |
| QuickHackDurationListener | ActionUploadListener | cyberpunk/managers/rpgManager.swift |
| QuickHackUploadListener | ActionUploadListener | cyberpunk/managers/rpgManager.swift |
| UploadFromNPCToNPCListener | QuickHackUploadListener | cyberpunk/managers/rpgManager.swift |
| UploadFromNPCToPlayerListener | QuickHackUploadListener | cyberpunk/managers/rpgManager.swift |
| StatsManager | IScriptable | cyberpunk/managers/statsManager.swift |
| SimpleTargetManager | ScriptableComponent | cyberpunk/managers/targetsManager.swift |
| Target | IScriptable | cyberpunk/managers/targetsManager.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| QuickSlotCommand |  | cyberpunk/managers/quickSlotsManager.swift |

### Static Funcs (6)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorGreater |  | cyberpunk/managers/rpgManager.swift |
| OperatorGreaterEqual |  | cyberpunk/managers/rpgManager.swift |
| OperatorLess |  | cyberpunk/managers/rpgManager.swift |
| OperatorLessEqual |  | cyberpunk/managers/rpgManager.swift |
| OperatorEqual |  | cyberpunk/managers/targetsManager.swift |
| OperatorEqual |  | cyberpunk/managers/targetsManager.swift |

### Funcs (4)

| Name | Bases | Source File |
|------|-------|-------------|
| Initialize |  | cyberpunk/managers/rpgManager.swift |
| OnStatPoolValueChanged |  | cyberpunk/managers/rpgManager.swift |
| Initialize |  | cyberpunk/managers/rpgManager.swift |
| OnStatPoolValueChanged |  | cyberpunk/managers/rpgManager.swift |

## Citations

- `cyberpunk/managers/bountyManager.swift`
- `cyberpunk/managers/cooldownStorage.swift`
- `cyberpunk/managers/npcManager.swift`
- `cyberpunk/managers/quickSlotsManager.swift`
- `cyberpunk/managers/rpgManager.swift`
- `cyberpunk/managers/statsManager.swift`
- `cyberpunk/managers/targetsManager.swift`
