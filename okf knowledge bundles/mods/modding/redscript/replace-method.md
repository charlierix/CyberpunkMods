---
type: Mechanic Pattern
title: Redscript @replaceMethod Pattern
description: Fully override native class methods with @replaceMethod, replacing the original implementation entirely.
tags: [redscript, redmod, replacemethod, hooks, game-objects, native-classes]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

The `@replaceMethod` attribute fully replaces a native method's implementation. Unlike `@wrapMethod`, the original method body is not accessible — there is no `wrappedMethod()` call. The mod's method body becomes the sole implementation. This is used when a mod needs to fundamentally change how a method behaves, not merely augment it.

**Canonical usage:**

```reds
@replaceMethod(MeleeTransition)
protected final const func GetAttackDataFromState(stateContext: ref<StateContext>,
    scriptInterface: ref<StateGameScriptInterface>, stateName: String,
    attackNumber: Int32, out outgoingStruct: ref<MeleeAttackData>) -> Bool {
    // Custom attack data logic entirely replaces vanilla
    let attackRecord: wref<Attack_Melee_Record>;
    let weaponType: String;
    let multiplier: Float;
    // ... mod-specific implementation ...
    return true;
}
```

Key characteristics:
- The replaced method signature **must match** the original native method exactly
- There is no `wrappedMethod()` — the original body is inaccessible
- If multiple mods replace the same method, only one can win; this is a **conflict-prone** pattern — use sparingly
- Prefer `@wrapMethod` when augmentation suffices; use `@replaceMethod` only when the original logic must be entirely discarded
- Common targets: combat transitions, inventory data queries, UI state checks where vanilla logic is incompatible with mod goals

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ACU - Character Customization | `mods/lua, red/ACU - Character Customization-3850-3-2-1-1777741508/r6/scripts/appearanceChangeUnlocker/mirrorUnlocker.reds` (L603) | @replaceMethod on MenuScenario_CharacterCustomizationMirror.OnEnterScenario() |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/r6/scripts/Aether/DisableOxygenConsumption.reds` | @replaceMethod on LocomotionSwimmingEvents.OnEnter() |
| Autofixer Discount Controls | `mods/lua, red/Autofixer Discount Controls - normal shard cost-17101-1-0-1728681346/r6/scripts/AutofixerDiscountControls/AutofixerDiscountControls.reds` (L244) | @replaceMethod on gameuiVehicleShopGameController.UpdateDiscount() |
| Custom Quickslots | `mods/lua, red/Custom Quickslots-3096-5-6-0-1776732197/r6/scripts/custom_quickslots/hotkey_item_controller.reds` (L1097) | @replaceMethod on HotkeyItemController.IsAllowedByGameplay() |
| CustomHackingSystem | `mods/lua, red/CustomHackingSystem v1.3.0-5091-1-3-0-1704395205/r6/scripts/CustomHackingSystem/Main/Quickhacks/QuickhackExtensions.reds` (L210) | @replaceMethod on QuickHackableHelper.TranslateActionsIntoQuickSlotCommands() |
| Slots Slots Slots | `mods/lua, red/main-23111-0-1-1754053131/r6/scripts/Slots Slots Slots - Cyberdeck Doubled Quickhack Slots.reds` | @replaceMethod on InventoryDataManagerV2.IsProgramSlot() |
| Much Better Netrunning | `mods/lua, red/Much Better Netrunning/r6/scripts/BetterNetrunning/Breach/BreachHelpers.reds` (L271) | @replaceMethod on AccessPointControllerPS.CheckConnectedClassTypes() |
| NPCNameplates | `mods/lua, red/NPCNameplates-26615-1-11-1-1778363372/r6/scripts/NPCNameplates/NPCnameplates.reds` (L1358) | @replaceMethod on NpcNameplateGameController.HelperCheckDistance() |
| SiestaCyberRush | `mods/lua, red/SiestaCyberRush V2.7-29585-4-6-1779559140/r6/scripts/SiestaCyberRush/SiestaCyberRush.reds` (L155) | @replaceMethod on MeleeTransition.GetAttackDataFromState() |
| TroubleGenerator | `mods/lua, red/TroubleGenerator-24369-1-3-1772087293/r6/scripts/TroubleGenerator/TG_TroubledMind.reds` (L629) | @replaceMethod on ShouldNPCContinueInAlerted.Check() |
| v2_AIOTweaks | `mods/lua, red/v2_AIOTweaks-10064-1-1-1740438467/r6/scripts/v2/v2_NoAutoWalkToggle.reds` | @replaceMethod on DefaultTransition.ForceDisableToggleWalk() |
| Weapon Conditioning | `mods/lua, red/Weapon Conditioning-10479-1-2-1-1776102382/r6/scripts/Weapon Conditioning/InventoryFix/AddOnSystem.reds` (L199) | @replaceMethod on InventoryDataManagerV2.GetPlayerInventoryPartsForItemRef() |

*78 more mods use this pattern*

## Related Concepts

- [Wrap Method](wrap-method.md) — Prefer @wrapMethod when augmentation suffices; @replaceMethod is the nuclear option
- [Add Method](add-method.md) — Add new methods to native classes instead of replacing existing ones
- [Codeware Framework](codeware-framework.md) — Codeware UI components often used inside replaced methods
