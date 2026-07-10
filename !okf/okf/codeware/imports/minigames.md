---
type: "Import"
title: "Minigames Types"
description: "Imported game engine types in the minigames domain (35 types)."
resource: "codeware/scripts/"
tags: "[imports, minigames]"
timestamp: 2026-07-01T18:09:18Z
---

# Overview

Imported game engine types in the minigames domain (35 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CasinoChips | class | GameObject | digitNames, flippedDigitNames |
| MinigameCollisionLogicAdvanced | class | inkLogicController | — |
| MinigameDynObjectAdvanced | class | inkLogicController | — |
| MinigameLogicControllerAdvanced | class | inkLogicController | playerLibraryName, playerColliderPositionOffset, playerColliderSizeOffset, gameplayRoot, baseSpeed |
| MinigamePlayerControllerAdvanced | class | inkLogicController | — |
| PanzerBonus | class | MinigameDynObjectAdvanced | fallingSpeed |
| PanzerBullet | class | MinigameDynObjectAdvanced | — |
| PanzerCloud | class | MinigameDynObjectAdvanced | — |
| PanzerEnemy | class | MinigameDynObjectAdvanced | noBonusChanceCoeff, health, score, shootPoint, bulletSpeed |
| PanzerEnemyAV | class | PanzerEnemy | speed, shotsAmount, longShotInterval, shortShotInterval |
| PanzerEnemyBullet | class | PanzerBullet | — |
| PanzerEnemyDrone | class | PanzerEnemy | speed, shootIntervalMinimum, shootIntervalMaximum |
| PanzerExplosion | class | MinigameDynObjectAdvanced | animationName |
| PanzerFriendlyBullet | class | PanzerBullet | — |
| PanzerGameLogicController | class | MinigameLogicControllerAdvanced | gameOverDelay, mainMenuLibraryName, scoreboardLibraryName, panelsLayer, gameLayer |
| PanzerGameState | class | MinigameStateAdvanced | — |
| PanzerLifeBonus | class | PanzerBonus | — |
| PanzerPlayerController | class | MinigameDynObjectAdvanced | bulletSpeed, bulletSpawnOffset, bulletLibraryname, shootInterval, gameLayerName |
| PanzerScoreBoard | class | MinigameDynObjectAdvanced | scoreboardList, champions, recordWidgetLibraryName |
| PanzerScoreBonus | class | PanzerBonus | — |
| PanzerScoreRecord | class | inkLogicController | nameWidget, scoreWidget |
| PanzerScoreRecordData | struct | — | name |
| Quad | struct | — | p1, p3 |
| QuadRacerPlayer | class | MinigamePlayerController | playerImage, leftTireSmoke, rightTireSmoke, rightFlame, leftFlame |
| QuadRacerRoad | class | MinigameDynObject | groundParts, roadParts |
| QuadRacerSprite | class | MinigameDynObject | — |
| RoachRaceChunk | unknown | — | — |
| RoachRaceChunkLayer | unknown | — | — |
| RoachRaceMinigameDynObject | class | MinigameDynObject | minSpawnY, maxSpawnY, extraSpeed, availableY |
| RoachRaceObstacle | unknown | — | — |
| ShooterPlayerController | class | gameuiarcadeArcadePlayerController | — |
| ShooterTraumaTeamController | class | inkLogicController | — |
| ShooterWeaponController | class | inkLogicController | — |
| SideScrollerCheatCodeAdvanced | struct | — | name |
| SideScrollerSpawnerAdvanced | class | IScriptable | — |

# Citations

- `codeware/scripts/Base/Imports/CasinoChips.reds`
- `codeware/scripts/Base/Imports/MinigameCollisionLogicAdvanced.reds`
- `codeware/scripts/Base/Imports/MinigameDynObjectAdvanced.reds`
- `codeware/scripts/Base/Imports/MinigameLogicControllerAdvanced.reds`
- `codeware/scripts/Base/Imports/MinigamePlayerControllerAdvanced.reds`
- `codeware/scripts/Base/Imports/PanzerBonus.reds`
- `codeware/scripts/Base/Imports/PanzerBullet.reds`
- `codeware/scripts/Base/Imports/PanzerCloud.reds`
- `codeware/scripts/Base/Imports/PanzerEnemy.reds`
- `codeware/scripts/Base/Imports/PanzerEnemyAV.reds`
- ... and 25 more source files
