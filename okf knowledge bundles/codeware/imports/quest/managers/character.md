---
type: "Import"
title: "Quest Managers/Character"
description: "Imported quest managers/character types (34 types)."
resource: "codeware/scripts/"
tags: "[imports, character]"
timestamp: 2026-07-01T18:09:26Z
---

# Overview

Imported quest managers/character types (34 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questCharacterManagerCombat_AssignSquad | class | questICharacterManagerCombat_NodeSubType | presetID, puppetRef, squadType |
| questCharacterManagerCombat_ChangeLevel | class | questICharacterManagerCombat_NodeSubType | puppetRef, level, setExactLevel |
| questCharacterManagerCombat_EquipWeapon | class | questICharacterManagerCombat_NodeSubType | equip, weaponID, slotID, equipLastWeapon, forceFirstEquip |
| questCharacterManagerCombat_Kill | class | questICharacterManagerCombat_NodeSubType | puppetRef, isPlayer, noAnimation, noRagdoll, skipDefeatedState |
| questCharacterManagerCombat_ManageRagdoll | class | questICharacterManagerCombat_NodeSubType | puppetRef, enableRagdoll |
| questCharacterManagerCombat_ModifyHealth | class | questICharacterManagerCombat_NodeSubType | puppetRef, isPlayer, percent, setExactValue, noDamageIndicator |
| questCharacterManagerCombat_NodeType | class | questICharacterManager_NodeType | subtype |
| questCharacterManagerCombat_SetDeathDirection | class | questICharacterManagerCombat_NodeSubType | puppetRef, direction |
| questCharacterManagerCombat_SetWeaponState | class | questICharacterManagerCombat_NodeSubType | areaType |
| questCharacterManagerParameters_EnableBumps | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, enable, policy |
| questCharacterManagerParameters_HealPlayer | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, heal, removeStatusEffects, removeBuffs |
| questCharacterManagerParameters_NodeType | class | questICharacterManager_NodeType | subtype |
| questCharacterManagerParameters_SetAnimset | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, variableName, value |
| questCharacterManagerParameters_SetAsCrowdObstacle | class | questICharacterManagerParameters_NodeSubType | params |
| questCharacterManagerParameters_SetAttitudeGroupForPuppet | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, groupName |
| questCharacterManagerParameters_SetCombatSpace | class | questICharacterManagerCombat_NodeSubType | puppetRef, combatSpaceSize |
| questCharacterManagerParameters_SetGender | class | questICharacterManagerParameters_NodeSubType | params |
| questCharacterManagerParameters_SetGroupsAttitude | class | questICharacterManagerParameters_NodeSubType | set, group1Name, group2Name, attitude |
| questCharacterManagerParameters_SetLifePath | class | questICharacterManagerParameters_NodeSubType | lifePathID |
| questCharacterManagerParameters_SetLowGravity | class | questICharacterManagerParameters_NodeSubType | enable |
| questCharacterManagerParameters_SetMortality | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, state, resetToDefault, source |
| questCharacterManagerParameters_SetProgressionBuild | class | questICharacterManagerParameters_NodeSubType | buildID |
| questCharacterManagerParameters_SetReactionPreset | class | questICharacterManagerParameters_NodeSubType | puppetRef, recordSelector |
| questCharacterManagerParameters_SetSensePreset | class | questICharacterManagerParameters_NodeSubType | puppetRef, presetID, main, resetToMain |
| questCharacterManagerParameters_SetStatusEffect | class | questICharacterManagerParameters_NodeSubType | puppetRef, isPlayer, statusEffectID, isPlayerStatusEffectSource, statusEffectSourceObject |
| questCharacterManagerVisuals_ChangeEntityAppearance | class | questCharacterManagerVisuals_EntityAppearanceOperationBase | — |
| questCharacterManagerVisuals_EntityAppearanceOperationBase | class | questICharacterManagerVisuals_NodeSubType | appearanceEntries |
| questCharacterManagerVisuals_EntityAppearanceOperationBaseEntityAppearanceEntry | struct | — | puppetRef, appearanceName |
| questCharacterManagerVisuals_GenitalsManager | class | questICharacterManagerVisuals_NodeSubType | bodyGroupName, puppetRef, isPlayer, enable |
| questCharacterManagerVisuals_NodeType | class | questICharacterManager_NodeType | subtype |
| questCharacterManagerVisuals_OverridePlayerCustomizations | class | questICharacterManagerVisuals_NodeSubType | customizationData |
| questCharacterManagerVisuals_OverridePlayerHairstyleAppearance | class | questICharacterManagerVisuals_NodeSubType | hairstyleIndex, hairstyleDefinitionName, beardIndex, beardPartIndex, beardDefinitionName |
| questCharacterManagerVisuals_PrefetchEntityAppearance | class | questCharacterManagerVisuals_EntityAppearanceOperationBase | — |
| questCharacterManagerVisuals_SetBrokenNoseStage | class | questICharacterManagerVisuals_NodeSubType | brokenNoseStage |

# Citations

- `codeware/scripts/Base/Imports/questCharacterManagerCombat_AssignSquad.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_ChangeLevel.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_EquipWeapon.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_Kill.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_ManageRagdoll.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_ModifyHealth.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_NodeType.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_SetDeathDirection.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerCombat_SetWeaponState.reds`
- `codeware/scripts/Base/Imports/questCharacterManagerParameters_EnableBumps.reds`
- ... and 24 more source files
