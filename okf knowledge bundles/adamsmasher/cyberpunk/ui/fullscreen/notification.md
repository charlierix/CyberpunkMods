---
type: "UI System"
title: "Notification UI"
description: "Notification UI: account sign-in, authorization, bounty, codex popup, crafting, currency, expansion, generic, in-game, item log, items queue, journal, level up, marketing consent, message popup, notification actions, patch note, popup manager, shard collected, shards, transfer save, UI, and zone alert."
resource: "!cyberpunk/UI/fullscreen/notification/accountSignInPopup.swift"
tags: ['cyberpunk', 'ui', 'fullscreen', 'notification']
timestamp: 2026-07-01T13:00:55Z
---

# Notification UI

Notification UI: account sign-in, authorization, bounty, codex popup, crafting, currency, expansion, generic, in-game, item log, items queue, journal, level up, marketing consent, message popup, notification actions, patch note, popup manager, shard collected, shards, transfer save, UI, and zone alert.

## Source Files

- `cyberpunk/UI/fullscreen/notification/accountSignInPopup.swift`
- `cyberpunk/UI/fullscreen/notification/authorisationNotification.swift`
- `cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift`
- `cyberpunk/UI/fullscreen/notification/codexPopup.swift`
- `cyberpunk/UI/fullscreen/notification/craftingNotification.swift`
- `cyberpunk/UI/fullscreen/notification/currencyNotification.swift`
- `cyberpunk/UI/fullscreen/notification/expansionPopup.swift`
- `cyberpunk/UI/fullscreen/notification/genericNotification.swift`
- `cyberpunk/UI/fullscreen/notification/ingameUINotification.swift`
- `cyberpunk/UI/fullscreen/notification/item_log.swift`
- `cyberpunk/UI/fullscreen/notification/itemsQueue.swift`
- `cyberpunk/UI/fullscreen/notification/journalNotification.swift`
- `cyberpunk/UI/fullscreen/notification/levelupNotification.swift`
- `cyberpunk/UI/fullscreen/notification/marketingConsentPopup.swift`
- `cyberpunk/UI/fullscreen/notification/messagePopup.swift`
- `cyberpunk/UI/fullscreen/notification/notificationActions.swift`
- `cyberpunk/UI/fullscreen/notification/patchNotePopup.swift`
- `cyberpunk/UI/fullscreen/notification/popupManager.swift`
- `cyberpunk/UI/fullscreen/notification/shardCollectedNotification.swift`
- `cyberpunk/UI/fullscreen/notification/shardsNotification.swift`
- `cyberpunk/UI/fullscreen/notification/transferSaveGameNotification.swift`
- `cyberpunk/UI/fullscreen/notification/uiNotification.swift`
- `cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift`

## Member Types

**Total declarations: 152**

### Classs (74)

| Name | Bases | Source File |
|------|-------|-------------|
| SignInPopupController | BaseGOGProfileController | cyberpunk/UI/fullscreen/notification/accountSignInPopup.swift |
| SignInQrCodeController | BaseGOGRegisterController | cyberpunk/UI/fullscreen/notification/accountSignInPopup.swift |
| AuthorisationNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| AuthorisationNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| BountyCollectedNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| BountyCollectedNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| BountyCollectedNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| CodexPopupGameController | inkGameController | cyberpunk/UI/fullscreen/notification/codexPopup.swift |
| CraftingNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| CraftingNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| CraftingNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| CurrencyChangeInventoryCallback | InventoryScriptCallback | cyberpunk/UI/fullscreen/notification/currencyNotification.swift |
| CurrencyUpdateNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/currencyNotification.swift |
| CurrencyNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/currencyNotification.swift |
| ExpansionStatePopupGameController | inkGameController | cyberpunk/UI/fullscreen/notification/expansionPopup.swift |
| ExpansionPopupGameController | inkGameController | cyberpunk/UI/fullscreen/notification/expansionPopup.swift |
| FeaturesExpansionPopupController | inkLogicController | cyberpunk/UI/fullscreen/notification/expansionPopup.swift |
| ReloadingExpansionPopupController | inkLogicController | cyberpunk/UI/fullscreen/notification/expansionPopup.swift |
| PreOrderPopupController | inkLogicController | cyberpunk/UI/fullscreen/notification/expansionPopup.swift |
| GenericNotificationViewData | IScriptable | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GenericNotificationController | gameuiGenericNotificationReceiverGameController | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| UIInGameNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/ingameUINotification.swift |
| UIInGameNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/ingameUINotification.swift |
| UIInGameNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/ingameUINotification.swift |
| UIInGameNotificationEvent | Event | cyberpunk/UI/fullscreen/notification/ingameUINotification.swift |
| ItemLog | gameuiMenuGameController | cyberpunk/UI/fullscreen/notification/item_log.swift |
| ItemLogPopupLogicController | inkLogicController | cyberpunk/UI/fullscreen/notification/item_log.swift |
| ItemsNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| ItemAddedInventoryCallback | InventoryScriptCallback | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| ItemAddedNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| ItemAddedNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| TarotCardAddedNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| RewardNotificationCurrencyDelayed | DelayCallback | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| QuestUpdateNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| PhoneMessageNotificationViewData | QuestUpdateNotificationViewData | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| JournalNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| MessengerNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| JournalNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| NewLocationNotification | JournalNotification | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| NCPDJobDoneNotification | JournalNotification | cyberpunk/UI/fullscreen/notification/journalNotification.swift |
| LevelUpNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/levelupNotification.swift |
| LevelUpNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/levelupNotification.swift |
| LevelUpNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/levelupNotification.swift |
| MarketingConsentPopupController | inkGameController | cyberpunk/UI/fullscreen/notification/marketingConsentPopup.swift |
| PhoneMessagePopupGameController | gameuiNewPhoneRelatedGameController | cyberpunk/UI/fullscreen/notification/messagePopup.swift |
| GenericNotificationBaseAction | IScriptable | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| TrackQuestNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenMessengerNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenSmsMessengerAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenPhoneMessageAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| ItemNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenPerksNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenSkillsNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenShardNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenWorldMapNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OpenTarotCollectionNotificationAction | GenericNotificationBaseAction | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| PatchNotePopupController | inkGameController | cyberpunk/UI/fullscreen/notification/patchNotePopup.swift |
| PopupsManager | inkGameController | cyberpunk/UI/fullscreen/notification/popupManager.swift |
| ShardCollectedInventoryCallback | InventoryScriptCallback | cyberpunk/UI/fullscreen/notification/shardCollectedNotification.swift |
| ShardCollectedNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/shardCollectedNotification.swift |
| ShardCollectedNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/shardCollectedNotification.swift |
| ShardNotificationController | inkGameController | cyberpunk/UI/fullscreen/notification/shardsNotification.swift |
| TransferSaveSystemNotificationLogicController | inkGenericSystemNotificationLogicController | cyberpunk/UI/fullscreen/notification/transferSaveGameNotification.swift |
| TransferSaveGameController | inkGameController | cyberpunk/UI/fullscreen/notification/transferSaveGameNotification.swift |
| UIMenuNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/uiNotification.swift |
| UIMenuNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/uiNotification.swift |
| UINotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/uiNotification.swift |
| ZoneAlertNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| VehicleAlertNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| AwacsAlertNotificationViewData | GenericNotificationViewData | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| ZoneAlertNotificationQueue | gameuiGenericNotificationGameController | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| ZoneAlertNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| VehicleAlertNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |
| AwacsAlertNotification | GenericNotificationController | cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift |

### Funcs (78)

| Name | Bases | Source File |
|------|-------|-------------|
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| OnItemQuantityChanged |  | cyberpunk/UI/fullscreen/notification/currencyNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| OnRemoveNotification |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GetPriority |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| OnRemoveNotification |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| OnItemNotification |  | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| Call |  | cyberpunk/UI/fullscreen/notification/itemsQueue.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| OnRemoveNotification |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GetPriority |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GetPriority |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| Execute |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| GetLabel |  | cyberpunk/UI/fullscreen/notification/notificationActions.swift |
| OnItemQuantityChanged |  | cyberpunk/UI/fullscreen/notification/currencyNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| OnRemoveNotification |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| OnRemoveNotification |  | cyberpunk/UI/fullscreen/notification/genericNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| CanMerge |  | cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift |
| GetShouldSaveState |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| GetID |  | cyberpunk/UI/fullscreen/notification/craftingNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |
| SetNotificationData |  | cyberpunk/UI/fullscreen/notification/authorisationNotification.swift |

## Citations

- `cyberpunk/UI/fullscreen/notification/accountSignInPopup.swift`
- `cyberpunk/UI/fullscreen/notification/authorisationNotification.swift`
- `cyberpunk/UI/fullscreen/notification/bountyCollectedNotification.swift`
- `cyberpunk/UI/fullscreen/notification/codexPopup.swift`
- `cyberpunk/UI/fullscreen/notification/craftingNotification.swift`
- `cyberpunk/UI/fullscreen/notification/currencyNotification.swift`
- `cyberpunk/UI/fullscreen/notification/expansionPopup.swift`
- `cyberpunk/UI/fullscreen/notification/genericNotification.swift`
- `cyberpunk/UI/fullscreen/notification/ingameUINotification.swift`
- `cyberpunk/UI/fullscreen/notification/item_log.swift`
- `cyberpunk/UI/fullscreen/notification/itemsQueue.swift`
- `cyberpunk/UI/fullscreen/notification/journalNotification.swift`
- `cyberpunk/UI/fullscreen/notification/levelupNotification.swift`
- `cyberpunk/UI/fullscreen/notification/marketingConsentPopup.swift`
- `cyberpunk/UI/fullscreen/notification/messagePopup.swift`
- `cyberpunk/UI/fullscreen/notification/notificationActions.swift`
- `cyberpunk/UI/fullscreen/notification/patchNotePopup.swift`
- `cyberpunk/UI/fullscreen/notification/popupManager.swift`
- `cyberpunk/UI/fullscreen/notification/shardCollectedNotification.swift`
- `cyberpunk/UI/fullscreen/notification/shardsNotification.swift`
- `cyberpunk/UI/fullscreen/notification/transferSaveGameNotification.swift`
- `cyberpunk/UI/fullscreen/notification/uiNotification.swift`
- `cyberpunk/UI/fullscreen/notification/zoneAlertNotification.swift`
