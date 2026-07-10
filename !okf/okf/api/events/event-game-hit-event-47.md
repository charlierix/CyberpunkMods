---
type: Event
title: "Event / Gamehitevent"
description: "6 types in Event / gameHitEvent. Includes: gameHitEvent, gameTargetHitEvent, gameRagdollHitEvent."
tags: [event, game-hit-event, events]
timestamp: 2026-07-01T01:17:09.596774
---

# Event / Gamehitevent

## Overview

This concept covers 6 types (6 named, 0 unnamed) from the Cyberpunk 2077 API. 
These types belong to the **gameHitEvent** subgroup under **Event**.

## Member Types

| Type | Bases | Fields | Methods | Flags | Source |
|------|-------|--------|---------|-------|--------|
| gameHitEvent | Event, IScriptable | 11 | 0 | native | [14651.json](/api/cyberpunk-api/14651.json) |
| gameTargetHitEvent | gameHitEvent, Event, IScriptable | 0 | 0 | native | [39637.json](/api/cyberpunk-api/39637.json) |
| gameRagdollHitEvent | gameHitEvent, Event, IScriptable | 3 | 0 | - | [45124.json](/api/cyberpunk-api/45124.json) |
| gameVehicleHitEvent | gameHitEvent, Event, IScriptable | 2 | 0 | native | [45128.json](/api/cyberpunk-api/45128.json) |
| gameProjectedHitEvent | gameHitEvent, Event, IScriptable | 0 | 0 | native | [99145.json](/api/cyberpunk-api/99145.json) |
| gameCoverHitEvent | gameHitEvent, Event, IScriptable | 1 | 0 | final, native | [99154.json](/api/cyberpunk-api/99154.json) |

## Citations

- Source: [Cyberpunk API](https://codeberg.org/adamsmasher/cyberpunk-api)
- Concept covers 6 source files
