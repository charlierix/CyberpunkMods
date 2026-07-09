---
type: "Import"
title: "Animation Types/Rig"
description: "Imported animation types/rig types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, rig]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/rig types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animRig | class | CResource | boneNames, trackNames, rigExtraTracks, levelOfDetailStartIndices, distanceCategoryToLodMap |
| animRigIk2Setup | class | animIRigIkSetup | firstBone, secondBone, endBone, hingeAxis, firstBoneIdx |
| animRigIkLeftFootSetup | class | animRigIk2Setup | — |
| animRigIkRightFootSetup | class | animRigIk2Setup | — |
| animRigPart | struct | — | name, treeBones, mask |
| animRigPartBone | struct | — | bone |
| animRigRetarget | struct | — | sourceRig |
| animRigTagCondition | class | animIStaticCondition | tag |

# Citations

- `codeware/scripts/Base/Imports/animRig.reds`
- `codeware/scripts/Base/Imports/animRigIk2Setup.reds`
- `codeware/scripts/Base/Imports/animRigIkLeftFootSetup.reds`
- `codeware/scripts/Base/Imports/animRigIkRightFootSetup.reds`
- `codeware/scripts/Base/Imports/animRigPart.reds`
- `codeware/scripts/Base/Imports/animRigPartBone.reds`
- `codeware/scripts/Base/Imports/animRigRetarget.reds`
- `codeware/scripts/Base/Imports/animRigTagCondition.reds`
