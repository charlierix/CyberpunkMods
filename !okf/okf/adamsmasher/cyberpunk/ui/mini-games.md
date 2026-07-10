---
type: "UI System"
title: "Mini Games UI"
description: "Mini games: advanced controller, advanced score system, hacking minigame rules, hacking utils, panzer, quad racer (controller, logic, obstacle), roach race (bonus collision, obstacle collision, controller, game controller, player, scoreboard entity, scoreboard logic, loop animation), and side scroller (animated, controller, logic, score system)."
resource: "!cyberpunk/UI/miniGames/Advanced/minigameControllerAdvanced.swift"
tags: ['cyberpunk', 'ui', 'mini-games']
timestamp: 2026-07-01T13:00:55Z
---

# Mini Games UI

Mini games: advanced controller, advanced score system, hacking minigame rules, hacking utils, panzer, quad racer (controller, logic, obstacle), roach race (bonus collision, obstacle collision, controller, game controller, player, scoreboard entity, scoreboard logic, loop animation), and side scroller (animated, controller, logic, score system).

## Source Files

- `cyberpunk/UI/miniGames/Advanced/minigameControllerAdvanced.swift`
- `cyberpunk/UI/miniGames/Advanced/sideScrollerScoreSystemAdvanced.swift`
- `cyberpunk/UI/miniGames/hackingMinigameGenerationRules.swift`
- `cyberpunk/UI/miniGames/hackingMinigameUtils.swift`
- `cyberpunk/UI/miniGames/panzer/panzerGameController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerLogicController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift`
- `cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift`
- `cyberpunk/UI/miniGames/roachRace/obstacleCollisionLogic.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceController.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceGameController.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRacePlayer.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceScoreboardEntity.swift`
- `cyberpunk/UI/miniGames/roachRace/scoreboardLogicController.swift`
- `cyberpunk/UI/miniGames/roachRace/sideScrollerLoopAnimation.swift`
- `cyberpunk/UI/miniGames/sideScrollerAnimated.swift`
- `cyberpunk/UI/miniGames/sideScrollerMiniGameController.swift`
- `cyberpunk/UI/miniGames/sideScrollerMiniGameLogicController.swift`
- `cyberpunk/UI/miniGames/sideScrollerScoreSystem.swift`

## Member Types

**Total declarations: 32**

### Classs (32)

| Name | Bases | Source File |
|------|-------|-------------|
| MinigameControllerAdvanced | inkGameController | cyberpunk/UI/miniGames/Advanced/minigameControllerAdvanced.swift |
| SideScrollerMiniGameScoreSystemAdvanced | ScriptableSystem | cyberpunk/UI/miniGames/Advanced/sideScrollerScoreSystemAdvanced.swift |
| MinigameGenerationRule_Test | MinigameGenerationRule | cyberpunk/UI/miniGames/hackingMinigameGenerationRules.swift |
| TrapTooltipDisplayer | inkLogicController | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| HackingMinigameGameController | inkGameController | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| MinigameGenerationRule | IScriptable | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| MinigameGenerationRuleOverridePrograms | MinigameGenerationRule | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| MinigameGenerationRuleScalingPrograms | MinigameGenerationRule | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| MinigameGenerationRulePredefinedBoardWithTraps | MinigameGenerationRule | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| MinigameGenerationRulePredefinedBoard | MinigameGenerationRule | cyberpunk/UI/miniGames/hackingMinigameUtils.swift |
| panzerGameController | PanzerMiniGameController | cyberpunk/UI/miniGames/panzer/panzerGameController.swift |
| QuadRacerGameController | MinigameController | cyberpunk/UI/miniGames/quadRacer/quadRacerController.swift |
| QuadRacerLogicController | MinigameLogicController | cyberpunk/UI/miniGames/quadRacer/quadRacerLogicController.swift |
| QuadRacerObstacleCollisionLogic | MinigameCollisionLogic | cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift |
| QuadRacerBonusCollisionLogic | MinigameCollisionLogic | cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift |
| NitroCollisionLogic | QuadRacerBonusCollisionLogic | cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift |
| OneTimeCollisionLogic | QuadRacerBonusCollisionLogic | cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift |
| BonusCollisionLogic | MinigameCollisionLogic | cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift |
| HealthCollisionLogic | BonusCollisionLogic | cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift |
| DoublePointsCollisionLogic | BonusCollisionLogic | cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift |
| InvincibilityCollisionLogic | BonusCollisionLogic | cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift |
| ObstacleCollisionLogic | MinigameCollisionLogic | cyberpunk/UI/miniGames/roachRace/obstacleCollisionLogic.swift |
| RoachRaceLogicController | MinigameLogicController | cyberpunk/UI/miniGames/roachRace/roachRaceController.swift |
| RoachRaceGameController | MinigameController | cyberpunk/UI/miniGames/roachRace/roachRaceGameController.swift |
| RoachRacePlayerController | MinigamePlayerController | cyberpunk/UI/miniGames/roachRace/roachRacePlayer.swift |
| ScoreboardEntityLogicController | inkLogicController | cyberpunk/UI/miniGames/roachRace/roachRaceScoreboardEntity.swift |
| ScoreboardLogicController | inkLogicController | cyberpunk/UI/miniGames/roachRace/scoreboardLogicController.swift |
| LoopAnimationLogicController | inkLogicController | cyberpunk/UI/miniGames/roachRace/sideScrollerLoopAnimation.swift |
| AnimationLogicController | inkLogicController | cyberpunk/UI/miniGames/sideScrollerAnimated.swift |
| MinigameController | inkGameController | cyberpunk/UI/miniGames/sideScrollerMiniGameController.swift |
| MinigameLogicController | inkLogicController | cyberpunk/UI/miniGames/sideScrollerMiniGameLogicController.swift |
| SideScrollerMiniGameScoreSystem | ScriptableSystem | cyberpunk/UI/miniGames/sideScrollerScoreSystem.swift |

## Citations

- `cyberpunk/UI/miniGames/Advanced/minigameControllerAdvanced.swift`
- `cyberpunk/UI/miniGames/Advanced/sideScrollerScoreSystemAdvanced.swift`
- `cyberpunk/UI/miniGames/hackingMinigameGenerationRules.swift`
- `cyberpunk/UI/miniGames/hackingMinigameUtils.swift`
- `cyberpunk/UI/miniGames/panzer/panzerGameController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerLogicController.swift`
- `cyberpunk/UI/miniGames/quadRacer/quadRacerObstacle.swift`
- `cyberpunk/UI/miniGames/roachRace/bonusCollisionLogic.swift`
- `cyberpunk/UI/miniGames/roachRace/obstacleCollisionLogic.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceController.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceGameController.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRacePlayer.swift`
- `cyberpunk/UI/miniGames/roachRace/roachRaceScoreboardEntity.swift`
- `cyberpunk/UI/miniGames/roachRace/scoreboardLogicController.swift`
- `cyberpunk/UI/miniGames/roachRace/sideScrollerLoopAnimation.swift`
- `cyberpunk/UI/miniGames/sideScrollerAnimated.swift`
- `cyberpunk/UI/miniGames/sideScrollerMiniGameController.swift`
- `cyberpunk/UI/miniGames/sideScrollerMiniGameLogicController.swift`
- `cyberpunk/UI/miniGames/sideScrollerScoreSystem.swift`
