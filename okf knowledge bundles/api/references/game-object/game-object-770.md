---
type: Reference
title: "Gameobject"
description: "44 types in GameObject. Includes: VehicleObject, AVObject, TankObject."
tags: [references, game-object]
timestamp: 2026-07-01T01:17:09.596774
---

# Gameobject

## Overview

This concept covers 44 types (22 named, 22 unnamed) from the Cyberpunk 2077 API. 
These types descend from **GameObject**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| unnamed_22988 | GameObject, GameEntity, Entity (+1) | 9 | 93 | native | [22988.json](/api/cyberpunk-api/22988.json) |
| unnamed_44841 | VehicleObject, GameObject, GameEntity (+2) | 0 | 0 | native | [44841.json](/api/cyberpunk-api/44841.json) |
| unnamed_45122 | VehicleObject, GameObject, GameEntity (+2) | 0 | 0 | native | [45122.json](/api/cyberpunk-api/45122.json) |
| unnamed_52982 | VehicleObject, GameObject, GameEntity (+2) | 0 | 1 | native | [52982.json](/api/cyberpunk-api/52982.json) |
| VehicleObject | GameObject, GameEntity, Entity (+1) | 9 | 94 | native | [24581.json](/api/cyberpunk-api/24581.json) |
| AVObject | VehicleObject, GameObject, GameEntity (+2) | 0 | 0 | native | [47752.json](/api/cyberpunk-api/47752.json) |
| TankObject | VehicleObject, GameObject, GameEntity (+2) | 0 | 0 | native | [48622.json](/api/cyberpunk-api/48622.json) |
| WheeledObject | VehicleObject, GameObject, GameEntity (+2) | 0 | 1 | native | [51687.json](/api/cyberpunk-api/51687.json) |
| TimeDilatable | GameObject, GameEntity, Entity (+1) | 0 | 6 | native | [9712.json](/api/cyberpunk-api/9712.json) |
| ItemObject | TimeDilatable, GameObject, GameEntity (+2) | 2 | 23 | native | [14743.json](/api/cyberpunk-api/14743.json) |
| sampleTimeDilatable | TimeDilatable, GameObject, GameEntity (+2) | 1 | 4 | - | [152537.json](/api/cyberpunk-api/152537.json) |
| gamePuppetBase | TimeDilatable, GameObject, GameEntity (+2) | 0 | 9 | abstract, native | [9727.json](/api/cyberpunk-api/9727.json) |
| unnamed_9922 | GameObject, GameEntity, Entity (+1) | 0 | 6 | native | [9922.json](/api/cyberpunk-api/9922.json) |
| unnamed_150213 | TimeDilatable, GameObject, GameEntity (+2) | 1 | 4 | - | [150213.json](/api/cyberpunk-api/150213.json) |
| unnamed_17067 | TimeDilatable, GameObject, GameEntity (+2) | 2 | 21 | native | [17067.json](/api/cyberpunk-api/17067.json) |
| unnamed_9943 | TimeDilatable, GameObject, GameEntity (+2) | 0 | 9 | abstract, native | [9943.json](/api/cyberpunk-api/9943.json) |
| unnamed_40045 | GameObject, GameEntity, Entity (+1) | 0 | 3 | native | [40045.json](/api/cyberpunk-api/40045.json) |
| unnamed_149261 | WeakspotObject, GameObject, GameEntity (+2) | 0 | 3 | - | [149261.json](/api/cyberpunk-api/149261.json) |
| unnamed_91687 | WeakspotObject, GameObject, GameEntity (+2) | 8 | 24 | - | [91687.json](/api/cyberpunk-api/91687.json) |
| WeakspotObject | GameObject, GameEntity, Entity (+1) | 0 | 3 | native | [43597.json](/api/cyberpunk-api/43597.json) |
| TankTurret | WeakspotObject, GameObject, GameEntity (+2) | 0 | 1 | - | [151653.json](/api/cyberpunk-api/151653.json) |
| ScriptedWeakspotObject | WeakspotObject, GameObject, GameEntity (+2) | 11 | 24 | - | [95261.json](/api/cyberpunk-api/95261.json) |
| unnamed_72748 | GameObject, GameEntity, Entity (+1) | 5 | 9 | - | [72748.json](/api/cyberpunk-api/72748.json) |
| unnamed_96767 | CPOMissionDevice, GameObject, GameEntity (+2) | 5 | 3 | - | [96767.json](/api/cyberpunk-api/96767.json) |
| unnamed_96821 | CPOMissionDevice, GameObject, GameEntity (+2) | 1 | 4 | - | [96821.json](/api/cyberpunk-api/96821.json) |
| CPOMissionDevice | GameObject, GameEntity, Entity (+1) | 5 | 9 | - | [74718.json](/api/cyberpunk-api/74718.json) |
| CPOMissionDataAccessPoint | CPOMissionDevice, GameObject, GameEntity (+2) | 5 | 3 | - | [101224.json](/api/cyberpunk-api/101224.json) |
| CPOVotingDevice | CPOMissionDevice, GameObject, GameEntity (+2) | 1 | 4 | - | [101277.json](/api/cyberpunk-api/101277.json) |
| gameLootObject | GameObject, GameEntity, Entity (+1) | 2 | 6 | native | [14755.json](/api/cyberpunk-api/14755.json) |
| gameItemDropObject | gameLootObject, GameObject, GameEntity (+2) | 1 | 11 | final, native | [91983.json](/api/cyberpunk-api/91983.json) |
| unnamed_17001 | GameObject, GameEntity, Entity (+1) | 0 | 7 | native | [17001.json](/api/cyberpunk-api/17001.json) |
| unnamed_17122 | DeviceBase, GameObject, GameEntity (+2) | 46 | 411 | - | [17122.json](/api/cyberpunk-api/17122.json) |
| unnamed_17076 | GameObject, GameEntity, Entity (+1) | 2 | 6 | native | [17076.json](/api/cyberpunk-api/17076.json) |
| unnamed_91409 | gameLootObject, GameObject, GameEntity (+2) | 1 | 11 | final, native | [91409.json](/api/cyberpunk-api/91409.json) |
| DeviceBase | GameObject, GameEntity, Entity (+1) | 1 | 8 | native | [20625.json](/api/cyberpunk-api/20625.json) |
| Device | DeviceBase, GameObject, GameEntity (+2) | 46 | 419 | - | [20815.json](/api/cyberpunk-api/20815.json) |
| gameLootContainerBase | GameObject, GameEntity, Entity (+1) | 6 | 33 | native | [30494.json](/api/cyberpunk-api/30494.json) |
| gameContainerObjectBase | gameLootContainerBase, GameObject, GameEntity (+2) | 1 | 8 | native | [84955.json](/api/cyberpunk-api/84955.json) |
| unnamed_81967 | GameObject, GameEntity, Entity (+1) | 6 | 31 | native | [81967.json](/api/cyberpunk-api/81967.json) |
| unnamed_84645 | gameLootContainerBase, GameObject, GameEntity (+2) | 1 | 8 | native | [84645.json](/api/cyberpunk-api/84645.json) |
| unnamed_85607 | GameObject, GameEntity, Entity (+1) | 0 | 2 | native | [85607.json](/api/cyberpunk-api/85607.json) |
| unnamed_140256 | gameCpoPickableItem, GameObject, GameEntity (+2) | 4 | 5 | - | [140256.json](/api/cyberpunk-api/140256.json) |
| gameCpoPickableItem | GameObject, GameEntity, Entity (+1) | 0 | 2 | native | [86939.json](/api/cyberpunk-api/86939.json) |
| HealthConsumable | gameCpoPickableItem, GameObject, GameEntity (+2) | 4 | 5 | - | [142386.json](/api/cyberpunk-api/142386.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 44 source files
