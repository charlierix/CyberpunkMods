---
type: Mechanic Pattern
title: Redscript @wrapMethod Pattern
description: Intercept native class methods with @wrapMethod to run code before/after the original, preserving vanilla behavior.
tags: [redscript, redmod, wrapmethod, hooks, game-objects, native-classes]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

The `@wrapMethod` attribute is Redscript's primary hooking mechanism for native game classes. It wraps an existing native method, allowing mod code to execute before and/or after the original implementation. The original method is invoked via `wrappedMethod()`, which returns the original return value.

**Canonical usage:**

```reds
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    let result: Bool = wrappedMethod();
    // Custom initialization after player spawns
    this.betterFlashlightOn = false;
    this.bf_detectionRunning = false;
    return result;
}
```

Key characteristics:
- The wrapped method signature **must match** the original native method exactly (visibility, return type, parameters)
- `wrappedMethod()` calls the original implementation; omitting it entirely replaces behavior
- Multiple mods can wrap the same method; they execute in sequence (chain-of-responsibility)
- Callback methods (`protected cb func`) are the most common targets for game lifecycle hooks
- Used for UI controllers (`OnInitialize`, `OnUninitialize`), player pawns (`OnGameAttached`, `OnDetach`), and game state transitions

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ACU - Character Customization | `mods/lua, red/ACU - Character Customization-3850-3-2-1-1777741508/r6/scripts/appearanceChangeUnlocker/mirrorUnlocker.reds` (L603) | @wrapMethod on characterCreationBodyMorphMenu.OnInitialize() |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds` (L43614) | @wrapMethod on inkPuppetPreviewGameController.OnPreviewInitialized() |
| Atelier Price Fixer | `mods/lua, red/Atelier Price Fixer-28279-1-4-0-1774797187/r6/scripts/AtelierPriceFixer/Hooks.reds` | @wrapMethod on gameuiInGameMenuGameController.OnInitialize() |
| Autofixer Discount Controls | `mods/lua, red/Autofixer Discount Controls - normal shard cost-17101-1-0-1728681346/r6/scripts/AutofixerDiscountControls/AutofixerDiscountControls.reds` (L244) | @wrapMethod on gameuiVehicleShopGameController.OnInitialize() |
| Better Flashlight | `mods/lua, red/Better Flashlight-27721-1-32-1777321233/r6/scripts/BetterFlashlight/BetterFlashlight.reds` (L215) | @wrapMethod on PlayerPuppet.OnGameAttached() |
| Custom Perk Framework | `mods/lua, red/Custom Perk Framework-26771-2-12-1773960387/r6/scripts/CustomPerkFramework/UI/CharacterScreenButton.reds` (L186) | @wrapMethod on NewPerksCategoriesGameController.OnInitialize() |
| Custom Quickslots | `mods/lua, red/Custom Quickslots-3096-5-6-0-1776732197/r6/scripts/custom_quickslots/hotkeys_widget_controller.reds` (L308) | @wrapMethod on ChargedHotkeyItemCyberwareController.OnInitialize() |
| CustomHackingSystem | `mods/lua, red/CustomHackingSystem v1.3.0-5091-1-3-0-1704395205/r6/scripts/CustomHackingSystem/CodewareExtensions/TickManager.reds` (L166) | @wrapMethod on PlayerPuppet.OnGameAttached() |
| FieldItems V | `mods/lua, red/FieldItems V-2-0-2.zip-12367-2-0-2-1775478370/r6/scripts/TSU_mods/fielditems.reds` | @wrapMethod on WorldMapTooltipController.SetData() |
| Gambling | `mods/lua, red/Gambling-29866-1-1779352615/r6/scripts/Gambling_fix/no_save.reds` | @wrapMethod on ReactionManagerComponent.OnPlayerProximityStartEvent() |
| Immersive Odometer and Fuel System | `mods/lua, red/Immersive Odometer and Fuel System - PL-24443-1-3-2-1780088111/r6/scripts/VehicleMileage/UI/VMHUD.reds` (L1854) | @wrapMethod on UISystem.PushGameContext() |
| Kinda Realistic Flashlight | `mods/lua, red/Kinda Realistic Flashlight-12559-4-0-0-1774906094/r6/scripts/KindaRealisticFlashlight/Init.reds` (L117) | @wrapMethod on PlayerPuppet.OnGameAttached() |

*298 more mods use this pattern*

## Related Concepts

- [Replace Method](replace-method.md) — Full method override when wrapping is insufficient
- [Add Method](add-method.md) — Adding new fields and methods to native classes alongside wraps
- [Codeware Framework](codeware-framework.md) — Codeware UI components frequently used inside @wrapMethod hooks
