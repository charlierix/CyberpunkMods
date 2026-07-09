---
type: "Import"
title: "Tools Types"
description: "Imported game engine types in the tools domain (71 types)."
resource: "codeware/scripts/"
tags: "[imports, tools]"
timestamp: 2026-07-01T18:09:33Z
---

# Overview

Imported game engine types in the tools domain (71 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| DrawClimbDebug | class | Event | — |
| DrawVaultDebug | class | DrawClimbDebug | — |
| EditorMeshComponent | class | MeshComponent | — |
| FunctionalTestQueryOverlapResult | struct | — | entityID |
| FunctionalTestsDataMemoryPoolRuntimeData | class | ISerializable | poolName, bytesAllocated, allocationCount |
| FunctionalTestsDataMemoryPoolStaticData | class | ISerializable | poolName, budget, childrenBudget, children, parent |
| FunctionalTestsDataMemoryStatsData | class | ISerializable | totalPhysicalMemory, availablePhysicalMemory, runtimeTotalBytesAllocated, cpuBytesAllocated, gpuBytesAllocated |
| FunctionalTestsDataRenderingStatsData | class | ISerializable | engineTick, rawLocalTime, meshChunkCount, cameraTriangleCount, shadowTriangleCount |
| FunctionalTestsDataTimeStatsData | class | ISerializable | engineTick, lastFps, minFps, lastTimeDelta, engineTime |
| FunctionalTestsGameSystem | class | FunctionalTestsGameSystemInterface | — |
| FunctionalTestsGameSystemInterface | class | IGameSystem | — |
| FunctionalTestsIRuntimeSystem | class | worldIRuntimeSystem | — |
| FunctionalTestsInputManager | struct | — | — |
| FunctionalTestsRuntimeSystem | class | FunctionalTestsIRuntimeSystem | — |
| FunctionalTestsState_FunctionalTests | class | gsmState | — |
| FunctionalTestsState_InternalFunctionalTests | class | gsmState | — |
| GameplayFunctionalTestReturnValue | struct | — | value |
| InternalFunctionalTestsRuntimeSystem | class | FunctionalTestsIRuntimeSystem | — |
| TestCaseBase_Backend | class | IScriptable | — |
| TestStep | class | IScriptable | stepName, scriptId, reproStep, args, stepTimeout |
| TestStepLogic | class | IScriptable | maxExecutionTimeSec, executionTimeSec, paramsData |
| itempreviewUIObjectsLoaderSystemListener | class | gameuiIUIObjectsLoaderSystemListener | — |
| prvFunctionalTestsTrigger | class | IScriptable | — |
| puppetpreviewPuppetPreview_UIObjectsLoaderSystemListener | class | gameuiIUIObjectsLoaderSystemListener | — |
| toolsEditorObjectIDPath | struct | — | — |
| toolsIMessageLocation | class | ISerializable | — |
| toolsIMessageToken | class | ISerializable | — |
| toolsIResolverUserContext | class | ISerializable | — |
| toolsJiraAddAttachmentsResult | class | ISerializable | array |
| toolsJiraAttachment | struct | — | id, content |
| toolsJiraCommentIssueBody | class | ISerializable | body |
| toolsJiraCommentIssueResult | class | ISerializable | errorMessages |
| toolsJiraCreateIssueBody | class | ISerializable | fields |
| toolsJiraCreateIssueResult | class | ISerializable | id, key, errorMessages, errors |
| toolsJiraCurrentUserInfo | class | ISerializable | name |
| toolsJiraCustomFieldId | struct | — | id |
| toolsJiraCustomFieldName | struct | — | name |
| toolsJiraCustomFieldValue | struct | — | value |
| toolsJiraEditIssueBody | class | ISerializable | fields |
| toolsJiraEditIssueResult | class | ISerializable | errorMessages, errors |
| toolsJiraFixVersion | struct | — | id |
| toolsJiraIssue | struct | — | id, key |
| toolsJiraIssueFields | struct | — | project, resolution, issuetype, labels, description |
| toolsJiraIssueFieldsResult | struct | — | project, issuetype, labels, description, fixVersions |
| toolsJiraIssueTransition | struct | — | id |
| toolsJiraIssueType | struct | — | name |
| toolsJiraPerson | struct | — | name, displayName |
| toolsJiraPriority | struct | — | name |
| toolsJiraProject | struct | — | key |
| toolsJiraResolution | struct | — | name |
| toolsJiraSearchIssuesResult | class | ISerializable | startAt, maxResults, total, issues, errorMessages |
| toolsJiraService | struct | — | — |
| toolsJiraStatus | struct | — | name |
| toolsJiraTransitionIssueBody | class | ISerializable | transition |
| toolsLastNodeSelection | struct | — | editorName |
| toolsMessage | struct | — | severity, location, verbosity |
| toolsMessageLocation_BoundingBox | class | toolsIMessageLocation | box |
| toolsMessageLocation_EditorObject | class | toolsIMessageLocation | path |
| toolsMessageLocation_Point | class | toolsIMessageLocation | point |
| toolsMessageLocation_Resource | class | toolsIMessageLocation | — |
| toolsMessageLocation_Webpage | class | toolsIMessageLocation | link, text |
| toolsMessageSeverity | enum | — | Success, Info, Warning, Error |
| toolsMessageTokenType | enum | — | Text, Location, Tag |
| toolsMessageToken_Location | class | toolsIMessageToken | location |
| toolsMessageToken_Name | class | toolsIMessageToken | name |
| toolsMessageToken_Text | class | toolsIMessageToken | text |
| toolsMessageVerbosity | enum | — | Normal, Verbose |
| toolsVisualTagsDefinition | struct | — | name |
| toolsVisualTagsGroup | class | ISerializable | name, tags |
| toolsVisualTagsRoot | class | ISerializable | schemas |
| toolsVisualTagsSchema | class | ISerializable | name, categories, presets |

# Citations

- `codeware/scripts/Base/Imports/DrawClimbDebug.reds`
- `codeware/scripts/Base/Imports/DrawVaultDebug.reds`
- `codeware/scripts/Base/Imports/EditorMeshComponent.reds`
- `codeware/scripts/Base/Imports/FunctionalTestQueryOverlapResult.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsDataMemoryPoolRuntimeData.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsDataMemoryPoolStaticData.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsDataMemoryStatsData.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsDataRenderingStatsData.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsDataTimeStatsData.reds`
- `codeware/scripts/Base/Imports/FunctionalTestsGameSystem.reds`
- ... and 61 more source files
