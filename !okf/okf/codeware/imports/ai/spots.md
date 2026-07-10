---
type: "Import"
title: "Ai Spots"
description: "Imported ai spots types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, spots]"
timestamp: 2026-07-01T18:09:00Z
---

# Overview

Imported ai spots types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AIActionSpot | class | AISmartSpot | resource, ActorBodytypeE3, masterNodeRef, enabledWhenMasterOccupied, snapToGround |
| AIBehaviourSpot | class | AISmartSpot | behaviour |
| AISmartSpot | class | AISpot | — |
| AISpot | class | ISerializable | — |
| AISpotUsageToken | struct | — | — |

# Citations

- `codeware/scripts/Base/Imports/AIActionSpot.reds`
- `codeware/scripts/Base/Imports/AIBehaviourSpot.reds`
- `codeware/scripts/Base/Imports/AISmartSpot.reds`
- `codeware/scripts/Base/Imports/AISpot.reds`
- `codeware/scripts/Base/Imports/AISpotUsageToken.reds`
