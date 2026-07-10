---
type: "Import"
title: "Quest Types/Character"
description: "Imported quest types/character types (30 types)."
resource: "codeware/scripts/"
tags: "[imports, character]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/character types (30 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questCharacterAim_ConditionType | class | questICharacterConditionType | isPlayer, preciseAiming, targetRef |
| questCharacterAppearancePrefetched_ConditionType | class | questICharacterConditionType | puppetRef, isPlayer, appearanceName |
| questCharacterAttack_ConditionType | class | questICharacterConditionType | attackerRef, targetRef, isTargetPlayer |
| questCharacterBodyType_CondtionType | class | questICharacterConditionType | objectRef, isPlayer, gender |
| questCharacterCallReinforcements_ConditionType | class | questICharacterConditionType | puppetRef |
| questCharacterCombat_ConditionType | class | questICharacterConditionType | objectRef, isPlayer, inverted |
| questCharacterCondition | class | questTypedCondition | type |
| questCharacterControlledObjectHit_ConditionType | class | questICharacterConditionType | attackerRef, targetRef, isTargetPlayer, includeHitTypes, excludeHitTypes |
| questCharacterCover_ConditionType | class | questICharacterConditionType | puppetRef, coverRef |
| questCharacterCyberdeckProgram_ConditionType | class | questICharacterConditionType | cyberdeckProgramID |
| questCharacterEquippedItem_ConditionType | class | questICharacterConditionType | isPlayer, puppetRef, itemID, itemTag, excludedTweakDBIDs |
| questCharacterEquippedWeapon_ConditionType | class | questICharacterConditionType | anyWeaponEquipped, weaponID, weaponTag, inverted |
| questCharacterGender_CondtionType | class | questICharacterConditionType | objectRef, isPlayer, gender |
| questCharacterGroupAttitude_CondtionType | class | questICharacterConditionType | group1Name, group2Name, attitude |
| questCharacterHealth_ConditionType | class | questICharacterConditionType | objectRef, isPlayer, percent, comparisonType |
| questCharacterHitEventType | enum | — | Bullet, Explosion, Melee, Other |
| questCharacterHit_ConditionType | class | questICharacterConditionType | attackerRef, isAttackerPlayer, targetRef, isTargetPlayer, includeHitTypes |
| questCharacterKilled_ConditionType | class | questICharacterConditionType | objectRef, source, comparisonParams, killed, unconscious |
| questCharacterLifePath_ConditionType | class | questICharacterConditionType | lifePathID |
| questCharacterMount_ConditionType | class | questICharacterConditionType | anyParent, parentRef, parentIsPlayer, anyChild, childRef |
| questCharacterMountedTogether_ConditionType | class | questICharacterConditionType | vehicleType, vehicleOrigin, characters |
| questCharacterQuickHackUploadBegin_ConditionType | class | questICharacterConditionType | objectRef |
| questCharacterQuickHacked_ConditionType | class | questICharacterConditionType | objectRef, quickHacked |
| questCharacterReaction_ConditionType | class | questICharacterConditionType | puppetRef, isAnyReaction, reactionBehaviorID |
| questCharacterRoleFinished_ConditionType | class | questICharacterConditionType | objectRef, role |
| questCharacterSceneSpot_ConditionType | class | questICharacterConditionType | puppetRef, isPlayer, workName, waitForEnd |
| questCharacterSpawned_ConditionType | class | questICharacterConditionType | objectRef, comparisonParams |
| questCharacterStatPool_ConditionType | class | questICharacterConditionType | objectRef, isPlayer, percent, comparisonType, statPoolType |
| questCharacterStatusEffect_CondtionType | class | questICharacterConditionType | objectRef, isPlayer, statusEffectID, inverted |
| questCharacterWorkspot_ConditionType | class | questICharacterConditionType | puppetRef, isPlayer, spotRef, animationName, waitForAnimEnd |

# Citations

- `codeware/scripts/Base/Imports/questCharacterAim_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterAppearancePrefetched_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterAttack_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterBodyType_CondtionType.reds`
- `codeware/scripts/Base/Imports/questCharacterCallReinforcements_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterCombat_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterCondition.reds`
- `codeware/scripts/Base/Imports/questCharacterControlledObjectHit_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterCover_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCharacterCyberdeckProgram_ConditionType.reds`
- ... and 20 more source files
