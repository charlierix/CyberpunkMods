---
type: "UI System"
title: "Pre-Game UI"
description: "Pre-game UI: booth mode, character creation (body morph, gender/backstory, menu, navigation, punk randomizer, stats, summary, top bar), continue game, difficulty, expansion new game, find servers, GOG profile, GOG rewards, load game, menu account, multiplayer, new game, play recorded session, pre-game menu, pre-game scenarios, save game, server info, and singleplayer."
resource: "!cyberpunk/UI/fullscreen/pregame/boothMode.swift"
tags: ['cyberpunk', 'ui', 'fullscreen', 'pregame']
timestamp: 2026-07-01T13:00:55Z
---

# Pre-Game UI

Pre-game UI: booth mode, character creation (body morph, gender/backstory, menu, navigation, punk randomizer, stats, summary, top bar), continue game, difficulty, expansion new game, find servers, GOG profile, GOG rewards, load game, menu account, multiplayer, new game, play recorded session, pre-game menu, pre-game scenarios, save game, server info, and singleplayer.

## Source Files

- `cyberpunk/UI/fullscreen/pregame/boothMode.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphImageThumbnail.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationNavigationBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationPunkRandomizerMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationStatsAttributeBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationStatsMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationSummaryListItem.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationSummaryMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationTopBar.swift`
- `cyberpunk/UI/fullscreen/pregame/continueGameTooltip.swift`
- `cyberpunk/UI/fullscreen/pregame/difficultySelection.swift`
- `cyberpunk/UI/fullscreen/pregame/expansionNewGame.swift`
- `cyberpunk/UI/fullscreen/pregame/findServersMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/gogProfileController.swift`
- `cyberpunk/UI/fullscreen/pregame/gogRewardsListController.swift`
- `cyberpunk/UI/fullscreen/pregame/loadGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/menuAccountController.swift`
- `cyberpunk/UI/fullscreen/pregame/multiplayerMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/newGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/playRecordedSessionMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameMenuGameController.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift`
- `cyberpunk/UI/fullscreen/pregame/saveGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/serverInfoController.swift`
- `cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift`

## Member Types

**Total declarations: 88**

### Classs (79)

| Name | Bases | Source File |
|------|-------|-------------|
| BoothModeGameController | inkGameController | cyberpunk/UI/fullscreen/pregame/boothMode.swift |
| characterCreationBodyMorphImageThumbnail | inkButtonAnimatedController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphImageThumbnail.swift |
| CharacterCreationBodyMorphBaseOption | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationVoiceOverSwitcher | CharacterCreationBodyMorphBaseOption | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphOption | CharacterCreationBodyMorphBaseOption | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphOptionSelectorButton | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphColorOption | CharacterCreationBodyMorphBaseOption | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphOptionColorPickerButton | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphOptionColorPickerItem | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphOptionColorPicker | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift |
| characterCreationBodyMorphMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphMenu.swift |
| characterCreationGenderBackstoryBtn | inkButtonController | cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryBtn.swift |
| characterCreationLifePathBtn | inkButtonController | cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryBtn.swift |
| CharacterCreationBackstorySelectionMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryMenu.swift |
| CharacterCreationGenderSelectionMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryMenu.swift |
| CharacterCreationGenderBackstoryPathHeader | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryMenu.swift |
| gameuiICharacterCustomizationSystem | IGameSystem | cyberpunk/UI/fullscreen/pregame/characterCreationMenu.swift |
| BaseCharacterCreationController | gameuiMenuGameController | cyberpunk/UI/fullscreen/pregame/characterCreationMenu.swift |
| characterCreationNavigationBtn | inkButtonController | cyberpunk/UI/fullscreen/pregame/characterCreationNavigationBtn.swift |
| RandomizationLockListItem | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationPunkRandomizerMenu.swift |
| PunkScoreSelectorControllerInt | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationPunkRandomizerMenu.swift |
| gameuiCharacterRandomizationController | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationPunkRandomizerMenu.swift |
| CharacterCreationAttributeData | IScriptable | cyberpunk/UI/fullscreen/pregame/characterCreationStatsAttributeBtn.swift |
| characterCreationStatsAttributeBtn | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationStatsAttributeBtn.swift |
| CharacterCreationStatsMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/characterCreationStatsMenu.swift |
| CharacterCreationTooltip | MessageTooltip | cyberpunk/UI/fullscreen/pregame/characterCreationStatsMenu.swift |
| characterCreationSummaryListItem | ListItemController | cyberpunk/UI/fullscreen/pregame/characterCreationSummaryListItem.swift |
| characterCreationSummaryMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/characterCreationSummaryMenu.swift |
| CharacterCreationPersistantElements | inkLogicController | cyberpunk/UI/fullscreen/pregame/characterCreationTopBar.swift |
| CharacterCreationTopBarHeader | inkButtonController | cyberpunk/UI/fullscreen/pregame/characterCreationTopBar.swift |
| ContinueGameTooltip | inkLogicController | cyberpunk/UI/fullscreen/pregame/continueGameTooltip.swift |
| DifficultySelectionMenu | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/difficultySelection.swift |
| ExpansionNewGame | BaseCharacterCreationController | cyberpunk/UI/fullscreen/pregame/expansionNewGame.swift |
| FindServersMenuGameController | PreGameSubMenuGameController | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| GOGProfileLogicController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GOGProfileGameController | BaseGOGProfileController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GogRegisterController | BaseGOGRegisterController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GogRewardsController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GogRewardEntryController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| CrossplayInfoPanelController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GogErrorNotificationController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogProfileController.swift |
| GogRewardsListController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogRewardsListController.swift |
| GogRewardsGroupController | inkLogicController | cyberpunk/UI/fullscreen/pregame/gogRewardsListController.swift |
| SaveMetadataInfo | IScriptable | cyberpunk/UI/fullscreen/pregame/loadGameMenu.swift |
| LoadGameMenuGameController | gameuiSaveHandlingController | cyberpunk/UI/fullscreen/pregame/loadGameMenu.swift |
| LoadListItem | AnimatedListItemController | cyberpunk/UI/fullscreen/pregame/loadGameMenu.swift |
| MenuAccountLogicController | inkLogicController | cyberpunk/UI/fullscreen/pregame/menuAccountController.swift |
| MultiplayerMenuGameController | PreGameSubMenuGameController | cyberpunk/UI/fullscreen/pregame/multiplayerMenu.swift |
| NewGameMenuGameController | PreGameSubMenuGameController | cyberpunk/UI/fullscreen/pregame/newGameMenu.swift |
| PlayRecordedSessionMenuGameController | PreGameSubMenuGameController | cyberpunk/UI/fullscreen/pregame/playRecordedSessionMenu.swift |
| PreGameSubMenuGameController | inkGameController | cyberpunk/UI/fullscreen/pregame/preGameMenu.swift |
| gameuiPreGameMenuGameController | gameuiBaseMenuGameController | cyberpunk/UI/fullscreen/pregame/preGameMenuGameController.swift |
| MenuScenario_PreGameSubMenu | inkMenuScenario | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_EngagementScreen | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_SingleplayerMenu | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_Settings | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_CreditsPicker | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_Credits | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_CreditsEp1 | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_NewGame | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_LoadGame | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_MultiplayerMenu | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_FindServers | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_PlayRecordedSession | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_BoothMode | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_LifePathSelection | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_BodyTypeSelection | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_CharacterCustomization | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_StatsAdjustment | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_Summary | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_Difficulty | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_ExpansionNewGame | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| MenuScenario_DLC | MenuScenario_PreGameSubMenu | cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift |
| SaveGameMenuGameController | gameuiSaveHandlingController | cyberpunk/UI/fullscreen/pregame/saveGameMenu.swift |
| ServerInfoController | ListItemController | cyberpunk/UI/fullscreen/pregame/serverInfoController.swift |
| gameuiSaveHandlingController | gameuiMenuGameController | cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift |
| ExpansionBannerController | inkLogicController | cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift |
| SingleplayerMenuGameController | MainMenuGameController | cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift |
| ExpansionErrorPopupController | inkGameController | cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift |

### Funcs (9)

| Name | Bases | Source File |
|------|-------|-------------|
| SetData |  | cyberpunk/UI/fullscreen/pregame/characterCreationStatsMenu.swift |
| InitializeMenuName |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeButtons |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeMenuName |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeButtons |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeMenuName |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeButtons |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeMenuName |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |
| InitializeButtons |  | cyberpunk/UI/fullscreen/pregame/findServersMenu.swift |

## Citations

- `cyberpunk/UI/fullscreen/pregame/boothMode.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphImageThumbnail.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphListItem.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationBodyMorphMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationGenderBackstoryMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationNavigationBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationPunkRandomizerMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationStatsAttributeBtn.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationStatsMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationSummaryListItem.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationSummaryMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/characterCreationTopBar.swift`
- `cyberpunk/UI/fullscreen/pregame/continueGameTooltip.swift`
- `cyberpunk/UI/fullscreen/pregame/difficultySelection.swift`
- `cyberpunk/UI/fullscreen/pregame/expansionNewGame.swift`
- `cyberpunk/UI/fullscreen/pregame/findServersMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/gogProfileController.swift`
- `cyberpunk/UI/fullscreen/pregame/gogRewardsListController.swift`
- `cyberpunk/UI/fullscreen/pregame/loadGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/menuAccountController.swift`
- `cyberpunk/UI/fullscreen/pregame/multiplayerMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/newGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/playRecordedSessionMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameMenuGameController.swift`
- `cyberpunk/UI/fullscreen/pregame/preGameScenarios.swift`
- `cyberpunk/UI/fullscreen/pregame/saveGameMenu.swift`
- `cyberpunk/UI/fullscreen/pregame/serverInfoController.swift`
- `cyberpunk/UI/fullscreen/pregame/singleplayerMenu.swift`
