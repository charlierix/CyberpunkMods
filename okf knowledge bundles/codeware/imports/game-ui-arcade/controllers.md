---
type: "Import"
title: "Game-Ui-Arcade Controllers"
description: "Imported game-ui-arcade controllers types (69 types)."
resource: "codeware/scripts/"
tags: "[imports, controllers]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game-ui-arcade controllers types (69 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameuiarcadeArcadeBackgroundController | class | inkLogicController | backgroundLayerList |
| gameuiarcadeArcadeGameController | class | inkGameController | minigame, defaultScreenTransitionTotalTime, screenTransitionWidget, menu, gameplay |
| gameuiarcadeArcadeGameplayController | class | gameuiarcadeIArcadeScreenController | score, pauseText |
| gameuiarcadeArcadeHealthController | class | inkLogicController | widget |
| gameuiarcadeArcadeMenuController | class | gameuiarcadeIArcadeScreenController | startArrow, scoreboardArrow |
| gameuiarcadeArcadeObjectController | class | inkLogicController | image, colliderList |
| gameuiarcadeArcadeParallaxPlaneController | class | inkLogicController | displacementAxis, loopType, segmentList |
| gameuiarcadeArcadeParallaxPlaneControllerDisplacementAxis | enum | — | Horizontal, Vertical |
| gameuiarcadeArcadeParallaxPlaneControllerLoopType | enum | — | None, Repeat |
| gameuiarcadeArcadePlayerController | class | inkLogicController | colliderList |
| gameuiarcadeArcadeScoreController | class | inkLogicController | scoreText |
| gameuiarcadeArcadeScoreboardController | class | gameuiarcadeIArcadeScreenController | endingPanel, playerCurrentScore, playerHighestScore, playerHighestScoreAlert, pressToPlayAgainText |
| gameuiarcadeArcadeSpawnerController | class | inkLogicController | objectLibraryID, initialObjectsCount |
| gameuiarcadeIArcadeScreenController | class | inkLogicController | — |
| gameuiarcadeRoachRaceBackgroundController | class | gameuiarcadeArcadeBackgroundController | parallaxPlaneRelativeVelocityList, daynightWidget, backgroundObjectSpawner, cloudSpawner |
| gameuiarcadeRoachRaceCloudSpawnerController | class | gameuiarcadeArcadeSpawnerController | minCloudRelativeVelocity, maxCloudRelativeVelocity, cloudSpawnTime |
| gameuiarcadeRoachRaceGameplayController | class | gameuiarcadeArcadeGameplayController | defaultWorldVelocity, cycleWorldVelocityMultiplier, carrotPowerupPointsPerSecond, carrotPowerupTime, carrotPowerupWorldVelocityMultiplier |
| gameuiarcadeRoachRaceObstacleController | class | gameuiarcadeArcadeObjectController | — |
| gameuiarcadeRoachRaceObstacleSpawnerController | class | gameuiarcadeArcadeSpawnerController | initialMinimumSpawnTime, initialDoubleSpawnChance, spawnRateIncreasePerCycle, doubleSpawnChanceIncreasePerLevel, doubleSpawnDelay |
| gameuiarcadeRoachRacePlayerController | class | inkLogicController | singleJumpBoost, doubleJumpBoost, gravity, teleportLockoutTime, carrotPowerupVelocityBoostModifier |
| gameuiarcadeRoachRaceSceneryObjectSpawnerController | class | gameuiarcadeArcadeSpawnerController | sceneryObjectSpawnTime |
| gameuiarcadeShooterAIController | class | gameuiarcadeShooterAIBase | — |
| gameuiarcadeShooterAIFlyingDroneController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIMeleeController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAINPCDroneController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIPickUpTransporterController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIRangeController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIRangeGrenadeController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIRescueTransporterController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAISpiderDroneController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAITransporterController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIVIPController | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterArcadeScoreboardController | class | gameuiarcadeArcadeScoreboardController | scoreBackground, endingScoreBackground, playerNames, ranks, scores |
| gameuiarcadeShooterBackgroundController | class | inkLogicController | layerInfo, allowMarginTranslation, expPlatformImageDetails |
| gameuiarcadeShooterBossController | class | gameuiarcadeShooterAIBase | customBoundSize, bossSize |
| gameuiarcadeShooterBulletSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeShooterCollisionController | class | inkLogicController | explosionPlatformDelay, respawnPlatformDetails |
| gameuiarcadeShooterGameController | class | gameuiarcadeArcadeGameController | — |
| gameuiarcadeShooterGameplayController | class | gameuiarcadeArcadeGameplayController | player, hud, levelContainer |
| gameuiarcadeShooterHUDController | class | inkLogicController | selectedWeaponSlot, secondWeaponSlot, thirdWeaponSlot, healthContainer, continueText |
| gameuiarcadeShooterHealthController | class | gameuiarcadeArcadeHealthController | — |
| gameuiarcadeShooterLevelController | class | inkLogicController | playerSpawnPoint, background, collision, levelType, spawner |
| gameuiarcadeShooterObjectController | class | gameuiarcadeArcadeObjectController | — |
| gameuiarcadeShooterPlatformCollisionController | class | inkLogicController | — |
| gameuiarcadeShooterPlatformController | class | gameuiarcadeShooterObjectController | — |
| gameuiarcadeShooterPlayerLevelTransitionController | class | inkLogicController | — |
| gameuiarcadeShooterSpawnController | class | inkLogicController | enemyType, spawnCondition, spawnDelay, spawnCount, offScreenSpawnExpiryTime |
| gameuiarcadeShooterSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeShooterTransporterSpawnerController | class | inkLogicController | spawnDelay, isRandomSpawn, choosenMounts, choosenOnes |
| gameuiarcadeShooterTraumaMemberController | class | gameuiarcadeShooterObjectController | baseFollowDelay |
| gameuiarcadeShooterVFXController | class | gameuiarcadeShooterObjectController | — |
| gameuiarcadeShooterVFXSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankBackgroundController | class | gameuiarcadeArcadeBackgroundController | decorationSpawner |
| gameuiarcadeTankCounterHUDController | class | inkLogicController | counterText |
| gameuiarcadeTankDecorationSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankDestroyableObjectController | class | gameuiarcadeArcadeObjectController | — |
| gameuiarcadeTankEnemyController | class | gameuiarcadeTankDestroyableObjectController | headParent, head |
| gameuiarcadeTankEnemySpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankGameplayController | class | gameuiarcadeArcadeGameplayController | player, enemySpawner, obstacleSpawner, pickupSpawner, projectileSpawner |
| gameuiarcadeTankObstacleSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankPickupController | class | gameuiarcadeArcadeObjectController | pickup, pickupText |
| gameuiarcadeTankPickupSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankPlayerAEAMSController | class | inkLogicController | — |
| gameuiarcadeTankPlayerController | class | gameuiarcadeArcadePlayerController | avatarRef, health, lives, aeams, projectileSpawner |
| gameuiarcadeTankPlayerHealthController | class | inkLogicController | health |
| gameuiarcadeTankPlayerLivesController | class | inkLogicController | — |
| gameuiarcadeTankProjectileController | class | gameuiarcadeArcadeObjectController | — |
| gameuiarcadeTankProjectileSpawnerController | class | gameuiarcadeArcadeSpawnerController | — |
| gameuiarcadeTankScoreMultiplierHUDController | class | inkLogicController | scoreMultiplierBarFill |

# Citations

- `codeware/scripts/Base/Imports/gameuiarcadeArcadeBackgroundController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeGameController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeGameplayController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeHealthController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeMenuController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeObjectController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeParallaxPlaneController.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeParallaxPlaneControllerDisplacementAxis.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeParallaxPlaneControllerLoopType.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadePlayerController.reds`
- ... and 59 more source files
