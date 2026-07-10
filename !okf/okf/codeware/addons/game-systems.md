---
type: "Addon"
title: "Game-Systems Addons"
description: "Field additions to game-systems types via @addField (19 types)."
resource: "codeware/scripts/"
tags: "[addons, game-systems]"
timestamp: 2026-07-01T18:09:40Z
---

# Overview

Field additions to game-systems types via @addField (19 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| GameComponent | addon | — | persistentState |
| GameObject | addon | — | persistentState, playerSocket, tags, displayName, displayDescription |
| GamePuppetPS | addon | — | gender, wasQuickHacked, hasQuickHackBegunUpload, hasAlternativeName, isCrouch |
| GameTime | addon | — | seconds |
| gameContainerObjectBase | addon | — | giveHandicapAmmo |
| gameCpoPickableItem | addon | — | itemIDToEquip, quickSlotID |
| gameEffectExecutor_BulletImpact | addon | — | isBackfaceImpact, noAudio, isMeleeAttack |
| gameEffectExecutor_KatanaBulletBending | addon | — | effects |
| gameEffectExecutor_Ricochet | addon | — | outputRicochetVector |
| gameEffectObjectFilter_OnlyNearest | addon | — | count |
| gameEntityStubComponentPS | addon | — | entityLocalPosition, entityLocalRotation, spawnerId, ownerCommunityEntryName, selectedAppearanceName |
| gameHitEvent | addon | — | hitColliderTag |
| gameJournalPath | addon | — | realPath, fileEntryIndex, className |
| gameLightComponent | addon | — | emissiveOnly, materialZone, meshBrokenAppearance, onStrength, turnOnByDefault |
| gameLootContainerBase | addon | — | useAreaLoot, lootTables, contentAssignment, isIllegal, containerType |
| gameLootObject | addon | — | lootID |
| gameScanningComponentPS | addon | — | scanningState, pctScanned, isBlocked |
| gameVisionModeComponentPS | addon | — | hideInDefaultMode, hideInFocusMode, inactive, questInactive |
| gameaiCyberwareBreachGameController | addon | — | strokeHealthDepleation |

# Citations

- `codeware/scripts/Base/Addons/GameComponent.reds`
- `codeware/scripts/Base/Addons/GameObject.reds`
- `codeware/scripts/Base/Addons/GamePuppetPS.reds`
- `codeware/scripts/Base/Addons/GameTime.reds`
- `codeware/scripts/Base/Addons/gameContainerObjectBase.reds`
- `codeware/scripts/Base/Addons/gameCpoPickableItem.reds`
- `codeware/scripts/Base/Addons/gameEffectExecutor_BulletImpact.reds`
- `codeware/scripts/Base/Addons/gameEffectExecutor_KatanaBulletBending.reds`
- `codeware/scripts/Base/Addons/gameEffectExecutor_Ricochet.reds`
- `codeware/scripts/Base/Addons/gameEffectObjectFilter_OnlyNearest.reds`
- ... and 9 more source files
