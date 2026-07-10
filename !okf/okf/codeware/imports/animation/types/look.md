---
type: "Import"
title: "Animation Types/Look"
description: "Imported animation types/look types (16 types)."
resource: "codeware/scripts/"
tags: "[imports, look]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/look types (16 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animLookAtAdditionalPreset | class | IScriptable | — |
| animLookAtAdditionalPreset_BothArms | class | animLookAtAdditionalPreset | rightHanded, softLimitAngle |
| animLookAtAdditionalPreset_Eyes | class | animLookAtAdditionalPreset | softLimitAngle |
| animLookAtAdditionalPreset_FullControl | class | animLookAtAdditionalPreset | useRightHand, attachHandToOtherOne, limits, suppress, mode |
| animLookAtAdditionalPreset_LeftArm | class | animLookAtAdditionalPreset | isAiming, softLimitAngle |
| animLookAtAdditionalPreset_RightArm | class | animLookAtAdditionalPreset | isAiming, softLimitAngle |
| animLookAtPreset | class | IScriptable | — |
| animLookAtPreset_DroneHorizontal | class | animLookAtPreset | softLimitDegrees, hardLimitDegrees, hardLimitDistance, backLimitDegrees, suppress |
| animLookAtPreset_DroneVertical | class | animLookAtPreset | softLimitDegrees, hardLimitDegrees, hardLimitDistance, backLimitDegrees, suppress |
| animLookAtPreset_Eyes | class | animLookAtPreset | softLimitAngle |
| animLookAtPreset_EyesHead | class | animLookAtPreset | suppressHeadAnimation, headMobility, softLimitAngle |
| animLookAtPreset_EyesHeadWithBodyAttached | class | animLookAtPreset | suppressHeadAnimation, headMobility, suppressChestAnimation, chestMobility, softLimitAngle |
| animLookAtPreset_EyesHeadWithBodyFree | class | animLookAtPreset | suppressHeadAnimation, headMobility, suppressChestAnimation, chestMobility, softLimitAngle |
| animLookAtPreset_EyesHeadWithBodyFreeForFollower | class | animLookAtPreset | suppressHeadAnimation, headMobility, suppressChestAnimation, chestMobility, softLimitAngle |
| animLookAtPreset_EyesHeadWithoutSuppress | class | animLookAtPreset | headMobility, softLimitAngle |
| animLookAtPreset_FullControl | class | animLookAtPreset | limits, eyesSuppress, eyesMode, headSuppress, headMode |

# Citations

- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset.reds`
- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset_BothArms.reds`
- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset_Eyes.reds`
- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset_FullControl.reds`
- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset_LeftArm.reds`
- `codeware/scripts/Base/Imports/animLookAtAdditionalPreset_RightArm.reds`
- `codeware/scripts/Base/Imports/animLookAtPreset.reds`
- `codeware/scripts/Base/Imports/animLookAtPreset_DroneHorizontal.reds`
- `codeware/scripts/Base/Imports/animLookAtPreset_DroneVertical.reds`
- `codeware/scripts/Base/Imports/animLookAtPreset_Eyes.reds`
- ... and 6 more source files
