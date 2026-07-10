---
type: "UI System"
title: "In-Game Menu UI"
description: "In-game menu: arcade minigame, death menu, debug hub, E3 end screen, final boards, hub experience bar, hub selector, character customization, in-game menu controller, scenarios, menu data builder, pause menu, time skip, and wardrobe."
resource: "!cyberpunk/UI/fullscreen/ingame/arcadeMinigameScenario.swift"
tags: ['cyberpunk', 'ui', 'fullscreen', 'ingame']
timestamp: 2026-07-01T13:00:55Z
---

# In-Game Menu UI

In-game menu: arcade minigame, death menu, debug hub, E3 end screen, final boards, hub experience bar, hub selector, character customization, in-game menu controller, scenarios, menu data builder, pause menu, time skip, and wardrobe.

## Source Files

- `cyberpunk/UI/fullscreen/ingame/arcadeMinigameScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/deathMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/deathScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/debugHubMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/e3EndScreenScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/finalBoardsScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/hubExperienceBar.swift`
- `cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameCharacterCustomizationGameController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift`
- `cyberpunk/UI/fullscreen/ingame/menuDataBuilder.swift`
- `cyberpunk/UI/fullscreen/ingame/networkBreachScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/pauseMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/pauseScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/timeSkipScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/wardrobeScenario.swift`

## Member Types

**Total declarations: 56**

### Classs (39)

| Name | Bases | Source File |
|------|-------|-------------|
| MenuScenario_ArcadeMinigame | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/arcadeMinigameScenario.swift |
| ArcadeMinigameUserData | inkUserData | cyberpunk/UI/fullscreen/ingame/arcadeMinigameScenario.swift |
| DeathMenuGameController | gameuiMenuItemListGameController | cyberpunk/UI/fullscreen/ingame/deathMenu.swift |
| MenuScenario_DeathMenu | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/deathScenario.swift |
| DebugHubMenuGameController | gameuiMenuGameController | cyberpunk/UI/fullscreen/ingame/debugHubMenu.swift |
| DebugHubMenuLogicController | inkLogicController | cyberpunk/UI/fullscreen/ingame/debugHubMenu.swift |
| DebugMenuScenario_HubMenu | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/debugHubMenu.swift |
| MenuScenario_E3EndMenu | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/e3EndScreenScenario.swift |
| E3EndMenuGameController | gameuiMenuItemListGameController | cyberpunk/UI/fullscreen/ingame/e3EndScreenScenario.swift |
| MenuScenario_FinalBoards | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/finalBoardsScenario.swift |
| MenuScenario_FinalBoardsEp1 | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/finalBoardsScenario.swift |
| HubExperienceBarController | inkLogicController | cyberpunk/UI/fullscreen/ingame/hubExperienceBar.swift |
| hubStaticSelectorController | SelectorController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| hubRadialStaticSelectorController | SelectorController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| hubSelectorSingleCarouselController | SelectorController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| hubSelectorController | SelectorController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| HubMenuLabelContentContainer | inkLogicController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| HubMenuLabelController | inkLogicController | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| gameuiInGameCharacterCustomizationGameController | gameuiBaseMenuGameController | cyberpunk/UI/fullscreen/ingame/inGameCharacterCustomizationGameController.swift |
| SetZoomLevelEvent | Event | cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift |
| gameuiInGameMenuGameController | gameuiBaseMenuGameController | cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift |
| ItemInPaperdollSlotCallback | AttachmentSlotsScriptCallback | cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift |
| StartHubMenuEvent | Event | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| MenuScenario_Idle | inkMenuScenario | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| MenuScenario_BaseMenu | inkMenuScenario | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| MenuScenario_CharacterCustomizationMirror | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| ScreenDisplayContextData | IScriptable | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| MenuUIUtils | IScriptable | cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift |
| MenuDataBuilder | IScriptable | cyberpunk/UI/fullscreen/ingame/menuDataBuilder.swift |
| HubMenuUtility | IScriptable | cyberpunk/UI/fullscreen/ingame/menuDataBuilder.swift |
| SubmenuDataBuilder | IScriptable | cyberpunk/UI/fullscreen/ingame/menuDataBuilder.swift |
| MenuScenario_NetworkBreach | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/networkBreachScenario.swift |
| PauseMenuBackgroundGameController | inkGameController | cyberpunk/UI/fullscreen/ingame/pauseMenu.swift |
| PauseMenuGameController | gameuiMenuItemListGameController | cyberpunk/UI/fullscreen/ingame/pauseMenu.swift |
| PauseMenuButtonItem | AnimatedListItemController | cyberpunk/UI/fullscreen/ingame/pauseMenu.swift |
| MenuScenario_CreditsPickerPause | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/pauseScenario.swift |
| MenuScenario_PauseMenu | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/pauseScenario.swift |
| MenuScenario_TimeSkip | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/timeSkipScenario.swift |
| MenuScenario_Wardrobe | MenuScenario_BaseMenu | cyberpunk/UI/fullscreen/ingame/wardrobeScenario.swift |

### Funcs (17)

| Name | Bases | Source File |
|------|-------|-------------|
| SetData |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetData |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetCarouselPosition |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetInteractive |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetCarouselPosition |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetIdentifier |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetSize |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetRealDesiredSize |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetRealDesiredWidth |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetTintedWidgets |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetTintColor |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| GetWidth |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetData |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetTargetData |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| SetActive |  | cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift |
| OnItemEquipped |  | cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift |
| OnItemUnequipped |  | cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift |

## Citations

- `cyberpunk/UI/fullscreen/ingame/arcadeMinigameScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/deathMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/deathScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/debugHubMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/e3EndScreenScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/finalBoardsScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/hubExperienceBar.swift`
- `cyberpunk/UI/fullscreen/ingame/hubSelectorController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameCharacterCustomizationGameController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameMenuGameController.swift`
- `cyberpunk/UI/fullscreen/ingame/inGameScenarios.swift`
- `cyberpunk/UI/fullscreen/ingame/menuDataBuilder.swift`
- `cyberpunk/UI/fullscreen/ingame/networkBreachScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/pauseMenu.swift`
- `cyberpunk/UI/fullscreen/ingame/pauseScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/timeSkipScenario.swift`
- `cyberpunk/UI/fullscreen/ingame/wardrobeScenario.swift`
