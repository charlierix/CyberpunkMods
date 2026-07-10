---
type: "Class System"
title: "Player System"
description: "Player system: disarm component, player, player combat controller, player covers, player events, player listeners, player vision mode controller, player weapon handler, and PSM transitions."
resource: "!cyberpunk/player/disarmComponent.swift"
tags: ['cyberpunk', 'player']
timestamp: 2026-07-01T13:00:55Z
---

# Player System

Player system: disarm component, player, player combat controller, player covers, player events, player listeners, player vision mode controller, player weapon handler, and PSM transitions.

## Source Files

- `cyberpunk/player/disarmComponent.swift`
- `cyberpunk/player/player.swift`
- `cyberpunk/player/playerCombatController.swift`
- `cyberpunk/player/playerCovers.swift`
- `cyberpunk/player/playerEvents.swift`
- `cyberpunk/player/playerListeners.swift`
- `cyberpunk/player/playerVisionModeController.swift`
- `cyberpunk/player/playerWeaponHandler.swift`

## Member Types

**Total declarations: 77**

### Classs (39)

| Name | Bases | Source File |
|------|-------|-------------|
| DisarmComponent | ScriptableComponent | cyberpunk/player/disarmComponent.swift |
| PlayerPuppetPS | ScriptedPuppetPS | cyberpunk/player/player.swift |
| CPOMissionDataState | IScriptable | cyberpunk/player/player.swift |
| PlayerPuppet | ScriptedPuppet | cyberpunk/player/player.swift |
| PlayerCombatController | IScriptable | cyberpunk/player/playerCombatController.swift |
| PlayerCoverHelper | IScriptable | cyberpunk/player/playerCovers.swift |
| SceneForceWeaponAim | Event | cyberpunk/player/playerEvents.swift |
| SceneFirstEquipState | Event | cyberpunk/player/playerEvents.swift |
| SceneForceWeaponSafe | Event | cyberpunk/player/playerEvents.swift |
| ManagePersonalLinkChangeEvent | Event | cyberpunk/player/playerEvents.swift |
| EnableBraindanceActions | Event | cyberpunk/player/playerEvents.swift |
| BraindanceInputChangeEvent | Event | cyberpunk/player/playerEvents.swift |
| DisableBraindanceActions | Event | cyberpunk/player/playerEvents.swift |
| ForceBraindanceCameraToggle | Event | cyberpunk/player/playerEvents.swift |
| PauseBraindance | Event | cyberpunk/player/playerEvents.swift |
| FelledEvent | Event | cyberpunk/player/playerEvents.swift |
| MemoryListener | CustomValueStatPoolsListener | cyberpunk/player/playerListeners.swift |
| DelayedEhxautionSoundClue | DelayCallback | cyberpunk/player/playerListeners.swift |
| StaminaListener | CustomValueStatPoolsListener | cyberpunk/player/playerListeners.swift |
| OxygenStatListener | CustomValueStatPoolsListener | cyberpunk/player/playerListeners.swift |
| BaseChargesStatListener | CustomValueStatPoolsListener | cyberpunk/player/playerListeners.swift |
| AimAssistSettingsListener | ConfigVarListener | cyberpunk/player/playerListeners.swift |
| AccessibilityControlsListener | ConfigVarListener | cyberpunk/player/playerListeners.swift |
| AimToggleListener | ConfigVarListener | cyberpunk/player/playerListeners.swift |
| RadioportSettingsListener | ConfigVarListener | cyberpunk/player/playerListeners.swift |
| PlayerPuppetAllStatListener | ScriptStatsListener | cyberpunk/player/playerListeners.swift |
| AutoRevealStatListener | ScriptStatsListener | cyberpunk/player/playerListeners.swift |
| VisibilityStatListener | ScriptStatsListener | cyberpunk/player/playerListeners.swift |
| SecondHeartStatListener | ScriptStatsListener | cyberpunk/player/playerListeners.swift |
| PlayerPuppetAttachmentSlotsCallback | AttachmentSlotsScriptCallback | cyberpunk/player/playerListeners.swift |
| ArmorStatListener | ScriptStatPoolsListener | cyberpunk/player/playerListeners.swift |
| HealthStatListener | ScriptStatPoolsListener | cyberpunk/player/playerListeners.swift |
| HealingItemsChargeStatListener | BaseChargesStatListener | cyberpunk/player/playerListeners.swift |
| GrenadesChargeStatListener | BaseChargesStatListener | cyberpunk/player/playerListeners.swift |
| ProjectileLauncherChargeStatListener | BaseChargesStatListener | cyberpunk/player/playerListeners.swift |
| OpticalCamoChargeStatListener | BaseChargesStatListener | cyberpunk/player/playerListeners.swift |
| OverclockChargeListener | BaseChargesStatListener | cyberpunk/player/playerListeners.swift |
| PlayerVisionModeController | IScriptable | cyberpunk/player/playerVisionModeController.swift |
| PlayerWeaponHandlingModifiers | IScriptable | cyberpunk/player/playerWeaponHandler.swift |

### Static Funcs (5)

| Name | Bases | Source File |
|------|-------|-------------|
| GetPlayer |  | cyberpunk/player/player.swift |
| GetMainPlayer |  | cyberpunk/player/player.swift |
| GetPlayerObject |  | cyberpunk/player/player.swift |
| IsHostileTowardsPlayer |  | cyberpunk/player/player.swift |
| IsFriendlyTowardsPlayer |  | cyberpunk/player/player.swift |

### Funcs (33)

| Name | Bases | Source File |
|------|-------|-------------|
| HasPrimaryOrSecondaryEquipment |  | cyberpunk/player/player.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| Call |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |
| MaxStatPoolValue |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| GetCharges |  | cyberpunk/player/playerListeners.swift |
| GetRechargeDuration |  | cyberpunk/player/playerListeners.swift |
| OnVarModified |  | cyberpunk/player/playerListeners.swift |
| OnVarModified |  | cyberpunk/player/playerListeners.swift |
| OnVarModified |  | cyberpunk/player/playerListeners.swift |
| OnVarModified |  | cyberpunk/player/playerListeners.swift |
| OnStatChanged |  | cyberpunk/player/playerListeners.swift |
| OnStatChanged |  | cyberpunk/player/playerListeners.swift |
| OnStatChanged |  | cyberpunk/player/playerListeners.swift |
| OnStatChanged |  | cyberpunk/player/playerListeners.swift |
| OnItemEquipped |  | cyberpunk/player/playerListeners.swift |
| OnItemUnequipped |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |
| MaxStatPoolValue |  | cyberpunk/player/playerListeners.swift |
| GetRechargeDuration |  | cyberpunk/player/playerListeners.swift |
| GetCharges |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |
| GetRechargeDuration |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |
| GetRechargeDuration |  | cyberpunk/player/playerListeners.swift |
| OnStatPoolValueChanged |  | cyberpunk/player/playerListeners.swift |
| Init |  | cyberpunk/player/playerListeners.swift |

## Citations

- `cyberpunk/player/disarmComponent.swift`
- `cyberpunk/player/player.swift`
- `cyberpunk/player/playerCombatController.swift`
- `cyberpunk/player/playerCovers.swift`
- `cyberpunk/player/playerEvents.swift`
- `cyberpunk/player/playerListeners.swift`
- `cyberpunk/player/playerVisionModeController.swift`
- `cyberpunk/player/playerWeaponHandler.swift`
