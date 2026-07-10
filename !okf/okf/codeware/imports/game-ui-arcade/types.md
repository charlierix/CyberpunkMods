---
type: "Import"
title: "Game-Ui-Arcade Types"
description: "Imported game-ui-arcade types types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game-ui-arcade types types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameuiarcadeArcadeColliderType | enum | — | Body, Up, Right, Bottom, Left |
| gameuiarcadeArcadeMinigame | enum | — | RoachRace, Shooter, Tank |
| gameuiarcadeBoundingCircle | class | gameuiarcadeBoundingShape | — |
| gameuiarcadeBoundingRect | class | gameuiarcadeBoundingShape | — |
| gameuiarcadeBoundingShape | class | IScriptable | boundingShape |
| gameuiarcadeRoachRaceObjectType | enum | — | BoostObject_Apple, BoostObject_Carrot, Obstacle |
| gameuiarcadeShooterAIBase | class | gameuiarcadeShooterObjectController | — |
| gameuiarcadeShooterAIProp | class | gameuiarcadeShooterAIController | — |
| gameuiarcadeShooterAIType | enum | — | MELEE, RANGESHOOTER, RANGEGRENADE, FLYINGDRONE, SPIDERDRONE |
| gameuiarcadeShooterBossBasilisk | class | gameuiarcadeShooterBossController | — |
| gameuiarcadeShooterBossMeatHead | class | gameuiarcadeShooterBossController | — |
| gameuiarcadeShooterBossNinja | class | gameuiarcadeShooterBossController | — |
| gameuiarcadeShooterBullet | class | gameuiarcadeShooterObjectController | customBoundSize, boundSize |
| gameuiarcadeShooterExplodingPlatformSpawnDetail | struct | — | spawnPlatformName |
| gameuiarcadeShooterExplodingPlatformsImageWidgetDetail | struct | — | platformName |
| gameuiarcadeShooterLayerInfo | struct | — | referenceWidget, layerName |
| gameuiarcadeShooterLevelType | enum | — | HORIZONTAL, VERTICALUP, VERTICALDOWN |
| gameuiarcadeShooterPlatformImageDetail | struct | — | platformImage |
| gameuiarcadeShooterPowerup | class | gameuiarcadeShooterObjectController | — |
| gameuiarcadeShooterSpawnerCondition | enum | — | ScreenLeft, ScreenRight, ScreenTop, ScreenBottom, EventTrigger |
| gameuiarcadeShooterTriggerType | enum | — | Delay, SpawnerFinish, SpawnerObjectsDeath |
| gameuiarcadeTankEnemyMovementType | enum | — | x_axis, x_axisL, x_axisR, y_axis |
| gameuiarcadeTankPickupType | enum | — | Patch_Kit, AEAMS, Mini_Tank, Pile_of_Eddies, Pile_of_Guns |

# Citations

- `codeware/scripts/Base/Imports/gameuiarcadeArcadeColliderType.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeArcadeMinigame.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeBoundingCircle.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeBoundingRect.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeBoundingShape.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeRoachRaceObjectType.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeShooterAIBase.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeShooterAIProp.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeShooterAIType.reds`
- `codeware/scripts/Base/Imports/gameuiarcadeShooterBossBasilisk.reds`
- ... and 13 more source files
