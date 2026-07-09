---
type: "Game System"
title: "Cyberpunk Systems"
description: "Cyberpunk systems: autocraft, data tracking, environment damage, equipment, first equip, input context, item modification, item modification requests, market system, ripperdoc token manager, vendor, phone, player development, player development requests, player handicap, and sub character."
resource: "!cyberpunk/systems/autocraftSystem.swift"
tags: ['cyberpunk', 'systems']
timestamp: 2026-07-01T13:00:55Z
---

# Cyberpunk Systems

Cyberpunk systems: autocraft, data tracking, environment damage, equipment, first equip, input context, item modification, item modification requests, market system, ripperdoc token manager, vendor, phone, player development, player development requests, player handicap, and sub character.

## Source Files

- `cyberpunk/systems/autocraftSystem.swift`
- `cyberpunk/systems/dataTrackingSystem.swift`
- `cyberpunk/systems/environmentDamageSystem.swift`
- `cyberpunk/systems/equipmentSystem.swift`
- `cyberpunk/systems/firstEquipSystem.swift`
- `cyberpunk/systems/inputContextSystem.swift`
- `cyberpunk/systems/itemModificationSystem.swift`
- `cyberpunk/systems/itemModificationSystemRequests.swift`
- `cyberpunk/systems/marketSystem/marketSystem.swift`
- `cyberpunk/systems/marketSystem/ripperdocTokenManager.swift`
- `cyberpunk/systems/marketSystem/vendor.swift`
- `cyberpunk/systems/phoneSystem.swift`
- `cyberpunk/systems/playerDevelopmentSystem.swift`
- `cyberpunk/systems/playerDevelopmentSystemRequests.swift`
- `cyberpunk/systems/playerHandicapSystem.swift`
- `cyberpunk/systems/subCharacterSystem.swift`

## Member Types

**Total declarations: 58**

### Classs (51)

| Name | Bases | Source File |
|------|-------|-------------|
| AutocraftSystem | ScriptableSystem | cyberpunk/systems/autocraftSystem.swift |
| DataTrackingSystem | ScriptableSystem | cyberpunk/systems/dataTrackingSystem.swift |
| DelayedAchivementCallback | DelayCallback | cyberpunk/systems/dataTrackingSystem.swift |
| EnvironmentDamageReceiverComponent | IPlacedComponent | cyberpunk/systems/environmentDamageSystem.swift |
| AssignHotkeyIfEmptySlot | PlayerScriptableSystemRequest | cyberpunk/systems/equipmentSystem.swift |
| HotkeyAssignmentRequest | PlayerScriptableSystemRequest | cyberpunk/systems/equipmentSystem.swift |
| Hotkey | IScriptable | cyberpunk/systems/equipmentSystem.swift |
| EquipmentSystemPlayerData | IScriptable | cyberpunk/systems/equipmentSystem.swift |
| EquipmentSystem | IEquipmentSystem | cyberpunk/systems/equipmentSystem.swift |
| FirstEquipSystem | ScriptableSystem | cyberpunk/systems/firstEquipSystem.swift |
| InputContextSystem | ScriptableSystem | cyberpunk/systems/inputContextSystem.swift |
| ItemModificationSystem | ScriptableSystem | cyberpunk/systems/itemModificationSystem.swift |
| InstallItemPart | ScriptableSystemRequest | cyberpunk/systems/itemModificationSystemRequests.swift |
| RemoveItemPart | ScriptableSystemRequest | cyberpunk/systems/itemModificationSystemRequests.swift |
| SwapItemPart | ScriptableSystemRequest | cyberpunk/systems/itemModificationSystemRequests.swift |
| MarketSystem | IMarketSystem | cyberpunk/systems/marketSystem/marketSystem.swift |
| AddItemToVendorRequest | ScriptableSystemRequest | cyberpunk/systems/marketSystem/marketSystem.swift |
| SetVendorPriceMultiplierRequest | ScriptableSystemRequest | cyberpunk/systems/marketSystem/marketSystem.swift |
| RipperdocTokenManager | IScriptable | cyberpunk/systems/marketSystem/ripperdocTokenManager.swift |
| Vendor | IScriptable | cyberpunk/systems/marketSystem/vendor.swift |
| PhoneStatusEffectListener | ScriptStatusEffectListener | cyberpunk/systems/phoneSystem.swift |
| PhoneStatsListener | ScriptStatsListener | cyberpunk/systems/phoneSystem.swift |
| PhoneSystem | ScriptableSystem | cyberpunk/systems/phoneSystem.swift |
| PlayerDevelopmentData | IScriptable | cyberpunk/systems/playerDevelopmentSystem.swift |
| PlayerDevelopmentSystem | ScriptableSystem | cyberpunk/systems/playerDevelopmentSystem.swift |
| RequestStatsBB | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| AddExperience | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| ProcessQueuedCombatExperience | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| SetProficiencyLevel | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| LevelUpProficiency | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| NewPerkActionRequest | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| NewPerkPoinsActionRequest | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| BuyPerk | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| RemovePerk | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| RemoveAllPerks | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| ResetProgressionForNewPerks | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| UnlockPerkArea | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| LockPerkArea | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| IncreaseTraitLevel | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| SetAttribute | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| BuyAttribute | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| AddDevelopmentPoints | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| ModifyStatCheckPrereq | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| ModifySkillCheckPrereq | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| UpdatePlayerDevelopment | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| SetProgressionBuild | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| BumpNetrunnerMinigameLevel | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| RefreshPerkAreas | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| ClearAllDevPointsRequest | PlayerScriptableSystemRequest | cyberpunk/systems/playerDevelopmentSystemRequests.swift |
| PlayerHandicapSystem | IPlayerHandicapSystem | cyberpunk/systems/playerHandicapSystem.swift |
| SubCharacterSystem | ScriptableSystem | cyberpunk/systems/subCharacterSystem.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| HotkeyManager |  | cyberpunk/systems/equipmentSystem.swift |

### Static Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| ProgressMultipleAchievementsImpl |  | cyberpunk/systems/dataTrackingSystem.swift |
| Cast |  | cyberpunk/systems/equipmentSystem.swift |

### Funcs (4)

| Name | Bases | Source File |
|------|-------|-------------|
| Call |  | cyberpunk/systems/dataTrackingSystem.swift |
| OnStatusEffectApplied |  | cyberpunk/systems/phoneSystem.swift |
| OnStatusEffectRemoved |  | cyberpunk/systems/phoneSystem.swift |
| OnStatChanged |  | cyberpunk/systems/phoneSystem.swift |

## Citations

- `cyberpunk/systems/autocraftSystem.swift`
- `cyberpunk/systems/dataTrackingSystem.swift`
- `cyberpunk/systems/environmentDamageSystem.swift`
- `cyberpunk/systems/equipmentSystem.swift`
- `cyberpunk/systems/firstEquipSystem.swift`
- `cyberpunk/systems/inputContextSystem.swift`
- `cyberpunk/systems/itemModificationSystem.swift`
- `cyberpunk/systems/itemModificationSystemRequests.swift`
- `cyberpunk/systems/marketSystem/marketSystem.swift`
- `cyberpunk/systems/marketSystem/ripperdocTokenManager.swift`
- `cyberpunk/systems/marketSystem/vendor.swift`
- `cyberpunk/systems/phoneSystem.swift`
- `cyberpunk/systems/playerDevelopmentSystem.swift`
- `cyberpunk/systems/playerDevelopmentSystemRequests.swift`
- `cyberpunk/systems/playerHandicapSystem.swift`
- `cyberpunk/systems/subCharacterSystem.swift`
