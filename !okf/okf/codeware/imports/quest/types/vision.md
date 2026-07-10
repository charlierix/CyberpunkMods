---
type: "Import"
title: "Quest Types/Vision"
description: "Imported quest types/vision types (3 types)."
resource: "codeware/scripts/"
tags: "[imports, vision]"
timestamp: 2026-07-01T18:09:24Z
---

# Overview

Imported quest types/vision types (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questVisionModeType | enum | — | Undefined, FocusMode, EnhancedMode |
| questVisionMode_ConditionType | class | questISystemConditionType | timeInterval, visionModeType |
| questVision_ConditionType | class | questISensesConditionType | observerPuppetRef, observedTargetRef, isObservedTargetPlayer, inverted, isInstant |

# Citations

- `codeware/scripts/Base/Imports/questVisionModeType.reds`
- `codeware/scripts/Base/Imports/questVisionMode_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVision_ConditionType.reds`
