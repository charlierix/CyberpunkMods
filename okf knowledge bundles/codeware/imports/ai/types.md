---
type: "Import"
title: "Ai Types"
description: "Imported ai types types (46 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:00Z
---

# Overview

Imported ai types types (46 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AIArchetype | class | CResource | behaviorDefinition, movementParameters |
| AIArchetypeSet | class | CResource | archetypeResources |
| AIArgumentBoolValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentCNameValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentEnumValue | class | AIArgumentDefinition | type, enumClass, defaultValue |
| AIArgumentFloatValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentGlobalNodeIdValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentIntValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentNodeRefValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentObjectValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentPuppetRefValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentReference | class | AIArgumentDefinition | type, defaultValue, rttiClassName |
| AIArgumentSerializableValue | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentUint64Value | class | AIArgumentDefinition | type, defaultValue |
| AIArgumentVectorValue | class | AIArgumentDefinition | type, defaultValue |
| AIAudioSquad | class | SquadBase | — |
| AICombatGuardAreaConnectedCommunity | struct | — | communityArea |
| AICommandContextsType | enum | — | Default, Immediate, Movement, Workspot, Aiming |
| AIDebugLogScope | struct | — | index |
| AIDefAI | class | AIResourceReference | — |
| AIEExecutionStatus | enum | — | STATUS_INVALID, STATUS_SUCCESS, STATUS_FAILURE, STATUS_RUNNING, STATUS_ABORTED |
| AIEInterruptionImportance | enum | — | Undefined, Casual, Rush, Immediate, ForcedImmediate |
| AIESharedVarDefinitionType | enum | — | SVInt, SVFloat, SVBool, SVName, SVTarget |
| AIEnemy | class | ISerializable | — |
| AIFiniteRoleType | enum | — | Patrol |
| AIForcedBehaviourPriority | enum | — | AboveIdle, AboveCombat, AboveCriticalState, AboveDeath |
| AIGameToneDetectorSquadAudioMember | class | AISquadAudioMemberBase | — |
| AIGuardArea | struct | — | — |
| AIGuardAreaConnectedCommunity | struct | — | communityArea |
| AIIObjectSelectionDebugProxy | unknown | — | — |
| AIInterruptionSignal | struct | — | importance |
| AIObjectId | struct | — | value |
| AIPlayMountedSlotWorkspotCommand | class | AICommand | mountData |
| AIPosition | struct | — | position |
| AIRunAwayFromPlayerCommand | class | AICommand | — |
| AIScriptEventResolver | class | IScriptable | — |
| AISocketsForRig | enum | — | Undefined, ManAverage, ManBig, ManFat, WomanAverage |
| AISquadAudioMemberBase | class | AISquadMemberBase | — |
| AISquadMemberBase | class | ISerializable | — |
| AISquadNPCMember | class | AISquadMemberBase | — |
| AIThreatBeliefPositionProvider | class | ThreatPositionProvider | — |
| AIThreatLastKnownPositionProvider | class | ThreatPositionProvider | — |
| AIThreatSharedBeliefPositionProvider | class | ThreatPositionProvider | — |
| AIThreatSharedLastKnownPositionProvider | class | ThreatPositionProvider | — |
| AITrafficWorkspotCompiled | class | worldTrafficSpotCompiled | — |
| gameinfluenceEBoundingBoxType | enum | — | Colider, Custom |

# Citations

- `codeware/scripts/Base/Imports/AIArchetype.reds`
- `codeware/scripts/Base/Imports/AIArchetypeSet.reds`
- `codeware/scripts/Base/Imports/AIArgumentBoolValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentCNameValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentEnumValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentFloatValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentGlobalNodeIdValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentIntValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentNodeRefValue.reds`
- `codeware/scripts/Base/Imports/AIArgumentObjectValue.reds`
- ... and 36 more source files
