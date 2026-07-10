---
type: "UI System"
title: "UI Widgets"
description: "UI widgets: autodrive, braindance, car modding (color handler, color selection), context menus, CPO (chat box, HUD root, narration journal, narrative plate, player list, target hit indicator), cursor device, damage indicator, stealth indicator, debug (artist test area, NPC nameplate), dpad hint (car radio, dpad hint item, dpad wheel, keyboard hint item, keyboard hint), healthbar (boss, companion, damage preview, entity, nameplate visuals, NPC nameplate), HUD progress bar, HUD signal progress, input hints, minimap, notifications (character levelup, custom quest, levelup, new area, new codex, phone, progression, stealth alert, vehicle summon), quickhacks (list item, quickhacks), timer, and wanted bar."
resource: "!cyberpunk/UI/widgets/autodrive/autodrive.swift"
tags: ['cyberpunk', 'ui', 'widgets']
timestamp: 2026-07-01T13:00:55Z
---

# UI Widgets

UI widgets: autodrive, braindance, car modding (color handler, color selection), context menus, CPO (chat box, HUD root, narration journal, narrative plate, player list, target hit indicator), cursor device, damage indicator, stealth indicator, debug (artist test area, NPC nameplate), dpad hint (car radio, dpad hint item, dpad wheel, keyboard hint item, keyboard hint), healthbar (boss, companion, damage preview, entity, nameplate visuals, NPC nameplate), HUD progress bar, HUD signal progress, input hints, minimap, notifications (character levelup, custom quest, levelup, new area, new codex, phone, progression, stealth alert, vehicle summon), quickhacks (list item, quickhacks), timer, and wanted bar.

## Source Files

- `cyberpunk/UI/widgets/autodrive/autodrive.swift`
- `cyberpunk/UI/widgets/braindance/braindance.swift`
- `cyberpunk/UI/widgets/carModding/carColorHandler.swift`
- `cyberpunk/UI/widgets/carModding/carColorSelection.swift`
- `cyberpunk/UI/widgets/contextMenus/radialMenu.swift`
- `cyberpunk/UI/widgets/cpo/chatBox.swift`
- `cyberpunk/UI/widgets/cpo/cpoHudRoot.swift`
- `cyberpunk/UI/widgets/cpo/narrationJournal.swift`
- `cyberpunk/UI/widgets/cpo/narrativePlate.swift`
- `cyberpunk/UI/widgets/cpo/playerList.swift`
- `cyberpunk/UI/widgets/cpo/targetHitIndicator.swift`
- `cyberpunk/UI/widgets/cursors/cursor_device.swift`
- `cyberpunk/UI/widgets/damage_indicator/damage_indicator.swift`
- `cyberpunk/UI/widgets/damage_indicator/stealth_indicator.swift`
- `cyberpunk/UI/widgets/debug/artist_test_area/artist_test_area_r.swift`
- `cyberpunk/UI/widgets/debug/debugNpcNamePlate.swift`
- `cyberpunk/UI/widgets/dpad_hint/car_radio.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpad_wheel.swift`
- `cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift`
- `cyberpunk/UI/widgets/dpad_hint/keyboard_hint.swift`
- `cyberpunk/UI/widgets/healthbar/bossHealthBar.swift`
- `cyberpunk/UI/widgets/healthbar/companionHealthbar.swift`
- `cyberpunk/UI/widgets/healthbar/damagePreview.swift`
- `cyberpunk/UI/widgets/healthbar/entityHealthBar.swift`
- `cyberpunk/UI/widgets/healthbar/nameplateVisuals.swift`
- `cyberpunk/UI/widgets/healthbar/npcNamePlate.swift`
- `cyberpunk/UI/widgets/hud_progress_bar/HUD_progress_bar.swift`
- `cyberpunk/UI/widgets/hud_progress_bar/hud_signal_progress.swift`
- `cyberpunk/UI/widgets/inputHints/inputHints.swift`
- `cyberpunk/UI/widgets/minimap/minimap.swift`
- `cyberpunk/UI/widgets/notifications/character_levelup.swift`
- `cyberpunk/UI/widgets/notifications/custom_quest.swift`
- `cyberpunk/UI/widgets/notifications/levelup.swift`
- `cyberpunk/UI/widgets/notifications/new_area_discovered.swift`
- `cyberpunk/UI/widgets/notifications/new_codex_entry.swift`
- `cyberpunk/UI/widgets/notifications/phoneNotification.swift`
- `cyberpunk/UI/widgets/notifications/progression_notification.swift`
- `cyberpunk/UI/widgets/notifications/stealth_alert.swift`
- `cyberpunk/UI/widgets/notifications/vehicle_summon_notification.swift`
- `cyberpunk/UI/widgets/quickhacks/quickhackListItem.swift`
- `cyberpunk/UI/widgets/quickhacks/quickhacks.swift`
- `cyberpunk/UI/widgets/timer/timer.swift`
- `cyberpunk/UI/widgets/wanted/wantedBar.swift`

## Member Types

**Total declarations: 107**

### Classs (88)

| Name | Bases | Source File |
|------|-------|-------------|
| AutoDriveController | inkHUDGameController | cyberpunk/UI/widgets/autodrive/autodrive.swift |
| AutoDriveAnimationEventListener | inkLogicController | cyberpunk/UI/widgets/autodrive/autodrive.swift |
| BraindanceGameController | inkHUDGameController | cyberpunk/UI/widgets/braindance/braindance.swift |
| BraindanceClueLogicController | inkLogicController | cyberpunk/UI/widgets/braindance/braindance.swift |
| SpeedIndicatorIconsManager | inkLogicController | cyberpunk/UI/widgets/braindance/braindance.swift |
| BraindanceBarLogicController | inkLogicController | cyberpunk/UI/widgets/braindance/braindance.swift |
| vehicleColorInkController | inkHUDGameController | cyberpunk/UI/widgets/carModding/carColorHandler.swift |
| vehicleColorSelectorGameController | inkGameController | cyberpunk/UI/widgets/carModding/carColorSelection.swift |
| RadialMenuGameController | inkHUDGameController | cyberpunk/UI/widgets/contextMenus/radialMenu.swift |
| RadialMenuHelper | IScriptable | cyberpunk/UI/widgets/contextMenus/radialMenu.swift |
| gameuiChatBoxGameController | inkHUDGameController | cyberpunk/UI/widgets/cpo/chatBox.swift |
| TextSectionLogicController | inkLogicController | cyberpunk/UI/widgets/cpo/chatBox.swift |
| CpoHudRootGameController | inkGameController | cyberpunk/UI/widgets/cpo/cpoHudRoot.swift |
| NarrationJournalGameController | inkHUDGameController | cyberpunk/UI/widgets/cpo/narrationJournal.swift |
| LogEntryLogicController | inkLogicController | cyberpunk/UI/widgets/cpo/narrationJournal.swift |
| NarrativePlateGameController | inkProjectedHUDGameController | cyberpunk/UI/widgets/cpo/narrativePlate.swift |
| NarrativePlateLogicController | inkLogicController | cyberpunk/UI/widgets/cpo/narrativePlate.swift |
| gameuiPlayerListGameController | inkHUDGameController | cyberpunk/UI/widgets/cpo/playerList.swift |
| PlayerListEntryLogicController | inkLogicController | cyberpunk/UI/widgets/cpo/playerList.swift |
| TargetHitIndicatorGameController | inkGameController | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| TargetHitIndicatorLogicController | inkLogicController | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| HitIndicatorWeaponZoomListener | ScriptStatsListener | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| WeaponChangedListener | AttachmentSlotsScriptCallback | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| cursorDeviceGameController | inkGameController | cyberpunk/UI/widgets/cursors/cursor_device.swift |
| DamageIndicatorGameController | inkHUDGameController | cyberpunk/UI/widgets/damage_indicator/damage_indicator.swift |
| DamageIndicatorPartLogicController | BaseDirectionalIndicatorPartLogicController | cyberpunk/UI/widgets/damage_indicator/damage_indicator.swift |
| StealthIndicatorGameController | inkHUDGameController | cyberpunk/UI/widgets/damage_indicator/stealth_indicator.swift |
| StealthIndicatorPartLogicController | BaseDirectionalIndicatorPartLogicController | cyberpunk/UI/widgets/damage_indicator/stealth_indicator.swift |
| artist_test_area_r | inkHUDGameController | cyberpunk/UI/widgets/debug/artist_test_area/artist_test_area_r.swift |
| DebugNpcNameplateGameController | inkProjectedHUDGameController | cyberpunk/UI/widgets/debug/debugNpcNamePlate.swift |
| CarRadioGameController | inkHUDGameController | cyberpunk/UI/widgets/dpad_hint/car_radio.swift |
| HotkeyWidgetStatsListener | ScriptStatusEffectListener | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| GenericHotkeyController | gameuiNewPhoneRelatedHUDGameController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| PhoneHotkeyController | GenericHotkeyController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| CarHotkeyController | GenericHotkeyController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| RadioHotkeyController | GenericHotkeyController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| HotkeyItemController | GenericHotkeyController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemBaseController | HotkeyItemController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemConsumableController | ChargedHotkeyItemBaseController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemGadgetController | ChargedHotkeyItemBaseController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemGadgetVehicleController | ChargedHotkeyItemGadgetController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemCyberwareController | ChargedHotkeyItemBaseController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargeIndicatorGameController | ChargedHotkeyItemBaseController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| ChargedHotkeyItemStatListener | ScriptStatPoolsListener | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| vehicleVisualCustomizationHotkeyController | GenericHotkeyController | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| HotkeyRadioStatusListener | ScriptStatusEffectListener | cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift |
| HotkeyCustomRadioWidgetController | gameuiNewPhoneRelatedHUDGameController | cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift |
| HotkeyConsumableWidgetController | gameuiNewPhoneRelatedHUDGameController | cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift |
| HotkeysWidgetController | gameuiNewPhoneRelatedHUDGameController | cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift |
| DpadWheelGameController | inkHUDGameController | cyberpunk/UI/widgets/dpad_hint/dpad_wheel.swift |
| DpadWheelItemController | inkLogicController | cyberpunk/UI/widgets/dpad_hint/dpad_wheel.swift |
| KeyboardHintItemController | AHintItemController | cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift |
| AHintItemController | inkLogicController | cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift |
| keyboardHintGameController | inkHUDGameController | cyberpunk/UI/widgets/dpad_hint/keyboard_hint.swift |
| BossHealthBarGameController | inkHUDGameController | cyberpunk/UI/widgets/healthbar/bossHealthBar.swift |
| BossHealthStatListener | ScriptStatPoolsListener | cyberpunk/UI/widgets/healthbar/bossHealthBar.swift |
| CompanionHealthStatListener | ScriptStatPoolsListener | cyberpunk/UI/widgets/healthbar/companionHealthbar.swift |
| CompanionHealthBarGameController | inkHUDGameController | cyberpunk/UI/widgets/healthbar/companionHealthbar.swift |
| DamagePreviewController | inkLogicController | cyberpunk/UI/widgets/healthbar/damagePreview.swift |
| EntityHealthStatListener | ScriptStatPoolsListener | cyberpunk/UI/widgets/healthbar/entityHealthBar.swift |
| EntityHealthBarGameController | inkGameController | cyberpunk/UI/widgets/healthbar/entityHealthBar.swift |
| NameplateVisualsLogicController | inkLogicController | cyberpunk/UI/widgets/healthbar/nameplateVisuals.swift |
| NpcNameplateGameController | inkProjectedHUDGameController | cyberpunk/UI/widgets/healthbar/npcNamePlate.swift |
| HUDProgressBarController | inkHUDGameController | cyberpunk/UI/widgets/hud_progress_bar/HUD_progress_bar.swift |
| HUDSignalProgressBarController | inkHUDGameController | cyberpunk/UI/widgets/hud_progress_bar/hud_signal_progress.swift |
| MinimapContainerController | MappinsContainerController | cyberpunk/UI/widgets/minimap/minimap.swift |
| CharacterLevelUpGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/character_levelup.swift |
| CustomQuestNotificationGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/custom_quest.swift |
| LevelUpGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/levelup.swift |
| NewAreaGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/new_area_discovered.swift |
| NewCodexEntryGameController | inkGameController | cyberpunk/UI/widgets/notifications/new_codex_entry.swift |
| PhoneMessageNotificationsGameController | inkGameController | cyberpunk/UI/widgets/notifications/phoneNotification.swift |
| ProgressionViewData | GenericNotificationViewData | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| ProgressionWidgetGameController | gameuiGenericNotificationGameController | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| ProgressionNotification | GenericNotificationController | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| stealthAlertGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/stealth_alert.swift |
| VehicleSummonWidgetGameController | inkHUDGameController | cyberpunk/UI/widgets/notifications/vehicle_summon_notification.swift |
| QuickhacksListItemController | ListItemController | cyberpunk/UI/widgets/quickhacks/quickhackListItem.swift |
| QuickhacksListGameController | inkHUDGameController | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| QuickHackScreenOpen | Event | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| QuickHackTimeDilationOverride | Event | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| QuickHackLockHacks | Event | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| QuickhacksVulnerabilityLogicController | inkLogicController | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| ProgramEntry | IScriptable | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| EquippedQuickHackData | IScriptable | cyberpunk/UI/widgets/quickhacks/quickhacks.swift |
| TimerGameController | inkHUDGameController | cyberpunk/UI/widgets/timer/timer.swift |
| WantedBarGameController | inkHUDGameController | cyberpunk/UI/widgets/wanted/wantedBar.swift |
| StarController | inkLogicController | cyberpunk/UI/widgets/wanted/wantedBar.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| SNameplateRangesData |  | cyberpunk/UI/widgets/healthbar/npcNamePlate.swift |

### Static Funcs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| SendInputHintData |  | cyberpunk/UI/widgets/inputHints/inputHints.swift |

### Funcs (17)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatChanged |  | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| OnItemEquipped |  | cyberpunk/UI/widgets/cpo/targetHitIndicator.swift |
| OnStatusEffectApplied |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatusEffectRemoved |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatusEffectApplied |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatusEffectRemoved |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| Animate |  | cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift |
| Animate |  | cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift |
| CreateMappinUIProfile |  | cyberpunk/UI/widgets/minimap/minimap.swift |
| CanMerge |  | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| GetShouldSaveState |  | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| GetID |  | cyberpunk/UI/widgets/notifications/progression_notification.swift |
| SetNotificationData |  | cyberpunk/UI/widgets/notifications/progression_notification.swift |

## Citations

- `cyberpunk/UI/widgets/autodrive/autodrive.swift`
- `cyberpunk/UI/widgets/braindance/braindance.swift`
- `cyberpunk/UI/widgets/carModding/carColorHandler.swift`
- `cyberpunk/UI/widgets/carModding/carColorSelection.swift`
- `cyberpunk/UI/widgets/contextMenus/radialMenu.swift`
- `cyberpunk/UI/widgets/cpo/chatBox.swift`
- `cyberpunk/UI/widgets/cpo/cpoHudRoot.swift`
- `cyberpunk/UI/widgets/cpo/narrationJournal.swift`
- `cyberpunk/UI/widgets/cpo/narrativePlate.swift`
- `cyberpunk/UI/widgets/cpo/playerList.swift`
- `cyberpunk/UI/widgets/cpo/targetHitIndicator.swift`
- `cyberpunk/UI/widgets/cursors/cursor_device.swift`
- `cyberpunk/UI/widgets/damage_indicator/damage_indicator.swift`
- `cyberpunk/UI/widgets/damage_indicator/stealth_indicator.swift`
- `cyberpunk/UI/widgets/debug/artist_test_area/artist_test_area_r.swift`
- `cyberpunk/UI/widgets/debug/debugNpcNamePlate.swift`
- `cyberpunk/UI/widgets/dpad_hint/car_radio.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpadHintItem.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpad_hint.swift`
- `cyberpunk/UI/widgets/dpad_hint/dpad_wheel.swift`
- `cyberpunk/UI/widgets/dpad_hint/keyboardHintItem.swift`
- `cyberpunk/UI/widgets/dpad_hint/keyboard_hint.swift`
- `cyberpunk/UI/widgets/healthbar/bossHealthBar.swift`
- `cyberpunk/UI/widgets/healthbar/companionHealthbar.swift`
- `cyberpunk/UI/widgets/healthbar/damagePreview.swift`
- `cyberpunk/UI/widgets/healthbar/entityHealthBar.swift`
- `cyberpunk/UI/widgets/healthbar/nameplateVisuals.swift`
- `cyberpunk/UI/widgets/healthbar/npcNamePlate.swift`
- `cyberpunk/UI/widgets/hud_progress_bar/HUD_progress_bar.swift`
- `cyberpunk/UI/widgets/hud_progress_bar/hud_signal_progress.swift`
- `cyberpunk/UI/widgets/inputHints/inputHints.swift`
- `cyberpunk/UI/widgets/minimap/minimap.swift`
- `cyberpunk/UI/widgets/notifications/character_levelup.swift`
- `cyberpunk/UI/widgets/notifications/custom_quest.swift`
- `cyberpunk/UI/widgets/notifications/levelup.swift`
- `cyberpunk/UI/widgets/notifications/new_area_discovered.swift`
- `cyberpunk/UI/widgets/notifications/new_codex_entry.swift`
- `cyberpunk/UI/widgets/notifications/phoneNotification.swift`
- `cyberpunk/UI/widgets/notifications/progression_notification.swift`
- `cyberpunk/UI/widgets/notifications/stealth_alert.swift`
- `cyberpunk/UI/widgets/notifications/vehicle_summon_notification.swift`
- `cyberpunk/UI/widgets/quickhacks/quickhackListItem.swift`
- `cyberpunk/UI/widgets/quickhacks/quickhacks.swift`
- `cyberpunk/UI/widgets/timer/timer.swift`
- `cyberpunk/UI/widgets/wanted/wantedBar.swift`
