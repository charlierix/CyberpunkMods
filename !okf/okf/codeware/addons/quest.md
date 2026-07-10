---
type: "Addon"
title: "Quest Addons"
description: "Field additions to quest types via @addField (37 types)."
resource: "codeware/scripts/"
tags: "[addons, quest]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Field additions to quest types via @addField (37 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| JournalBriefingMapSection | addon | — | mapLocation |
| JournalBriefingVideoSection | addon | — | videoResource |
| JournalCodexCategory | addon | — | categoryName |
| JournalCodexDescription | addon | — | subTitle, textContent |
| JournalCodexEntry | addon | — | title, imageId, linkImageId |
| JournalCodexGroup | addon | — | groupName, isSorted |
| JournalContact | addon | — | name, avatarID, type, useFlatMessageLayout, isCallableDefault |
| JournalContainerEntry | addon | — | entries |
| JournalEmail | addon | — | sender, addressee, title, content, videoResource |
| JournalEntry | addon | — | id, journalEntryOverrideDataList |
| JournalEntryOverrideData | addon | — | overriddenLocalizationString |
| JournalFile | addon | — | title, content, videoResource, pictureTweak |
| JournalImageEntry | addon | — | imageId, thumbnailImageId |
| JournalInternetBase | addon | — | name, linkAddress, tintColor, hoverTintColor |
| JournalInternetCanvas | addon | — | isHidden |
| JournalInternetImage | addon | — | textureAtlas, texturePart |
| JournalInternetPage | addon | — | address, factsToSet, additionallyFilledFromScripts, reloadOnZoomIn, widgetFile |
| JournalInternetSite | addon | — | shortName, mainPagePath, ignoredAtDesktop, textureAtlas, texturePart |
| JournalInternetText | addon | — | text |
| JournalInternetVideo | addon | — | videoResource |
| JournalMetaQuest | addon | — | title |
| JournalMetaQuestObjective | addon | — | description, progressPercent, iconID |
| JournalOnscreen | addon | — | tag, title, description, iconID |
| JournalPhoneChoiceEntry | addon | — | text, isQuestImportant, questCondition |
| JournalPhoneConversation | addon | — | title |
| JournalPhoneMessage | addon | — | sender, text, imageId, delay, attachment |
| JournalQuest | addon | — | title, type, recommendedLevelID, districtID |
| JournalQuestCodexLink | addon | — | path |
| JournalQuestDescription | addon | — | description |
| JournalQuestGuidanceMarker | addon | — | nodeRef, pathfindingType, isPortal |
| JournalQuestMapPin | addon | — | reference, slotName, mappinData, offset, uiAnimation |
| JournalQuestMapPinBase | addon | — | enableGPS |
| JournalQuestMapPinLink | addon | — | path |
| JournalQuestObjectiveBase | addon | — | description, counter, optional, locationPrefabRef, itemID |
| JournalQuestPhase | addon | — | locationPrefabRef |
| JournalRequestContext | addon | — | classFilter |
| JournalTarot | addon | — | index, name, description, imagePart |

# Citations

- `codeware/scripts/Base/Addons/JournalBriefingMapSection.reds`
- `codeware/scripts/Base/Addons/JournalBriefingVideoSection.reds`
- `codeware/scripts/Base/Addons/JournalCodexCategory.reds`
- `codeware/scripts/Base/Addons/JournalCodexDescription.reds`
- `codeware/scripts/Base/Addons/JournalCodexEntry.reds`
- `codeware/scripts/Base/Addons/JournalCodexGroup.reds`
- `codeware/scripts/Base/Addons/JournalContact.reds`
- `codeware/scripts/Base/Addons/JournalContainerEntry.reds`
- `codeware/scripts/Base/Addons/JournalEmail.reds`
- `codeware/scripts/Base/Addons/JournalEntry.reds`
- ... and 27 more source files
