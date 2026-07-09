---
type: Mechanic Pattern
title: Redscript @addField / @addMethod Pattern
description: Extend native classes with new fields and methods using @addField and @addMethod without modifying existing behavior.
tags: [redscript, redmod, addfield, addmethod, extension, native-classes]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

The `@addField` and `@addMethod` attributes allow mods to add new instance variables and methods to native game classes. This is the least invasive Redscript pattern — it does not alter existing behavior, only augments the class with new members that the mod's own code (often combined with `@wrapMethod`) can use.

**Canonical usage:**

```reds
// Add a new private field to a native UI controller
@addField(NewPerksCategoriesGameController)
private let m_customPerkFrameworkButton: ref<inkCanvas>;

@addField(NewPerksCategoriesGameController)
private let m_customPerkFrameworkPopup: ref<CustomPerkScreenPopup>;

// Add a new method to a native class
@addMethod(NewPerksCategoriesGameController)
private func CreateCustomPerkFrameworkButton() -> Void {
    let skillsButton: ref<inkWidget> = inkWidgetRef.Get(this.m_skillsScreenButton);
    if !IsDefined(skillsButton) { return; }
    // ... custom UI creation logic ...
}
```

Key characteristics:
- `@addField` adds instance variables (state) to native classes; fields are per-instance, not static
- `@addMethod` adds new methods to native classes; the method body is mod-defined and has access to `this`
- Both are **non-conflicting** — multiple mods can add different fields/methods to the same class without issues
- Added fields must be `private` (or `let`) to avoid name collisions with vanilla or other mods
- Commonly paired with `@wrapMethod` — the added field stores mod state, the wrapped method initializes and uses it
- Works on any native class: `PlayerPuppet`, UI controllers, `ScriptedPuppet`, `UISystem`, etc.

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ACU - Character Customization | `mods/lua, red/ACU - Character Customization-3850-3-2-1-1777741508/r6/scripts/appearanceChangeUnlocker/mirrorUnlocker.reds` (L603) | @addField on characterCreationBodyMorphMenu |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/r6/scripts/BetterOpticalCamo/compat/CustomQuickslots.reds` | @addMethod on HotkeyItemController.IsOpticalCamoCyberwareAbility() |
| Autofixer Discount Controls | `mods/lua, red/Autofixer Discount Controls - normal shard cost-17101-1-0-1728681346/r6/scripts/AutofixerDiscountControls/AutofixerDiscountControls.reds` (L244) | @addField on gameuiVehicleShopGameController |
| Bag and Tag - CET Rewrite | `mods/lua, red/Bag and Tag - CET Rewrite-28746-1-0-21-1776129453/cp2077_mod_sanity_test/r6/scripts/virtu_mod_sanity_test.reds` | @addField on ScriptedPuppet |
| Better Flashlight | `mods/lua, red/Better Flashlight-27721-1-32-1777321233/r6/scripts/BetterFlashlight/BetterFlashlight.reds` (L215) | @addField on PlayerPuppet |
| Custom Perk Framework | `mods/lua, red/Custom Perk Framework-26771-2-12-1773960387/r6/scripts/CustomPerkFramework/UI/CharacterScreenButton.reds` (L186) | @addField on NewPerksCategoriesGameController |
| Custom Quickslots | `mods/lua, red/Custom Quickslots-3096-5-6-0-1776732197/r6/scripts/custom_quickslots/hotkeys_widget_controller.reds` (L308) | @addField on HotkeysWidgetController |
| CustomHackingSystem | `mods/lua, red/CustomHackingSystem v1.3.0-5091-1-3-0-1704395205/r6/scripts/CustomHackingSystem/CodewareExtensions/TickManager.reds` (L166) | @addField on PlayerPuppet |
| Immersive Odometer and Fuel System | `mods/lua, red/Immersive Odometer and Fuel System - PL-24443-1-3-2-1780088111/r6/scripts/VehicleMileage/UI/VMHUD.reds` (L1854) | @addField on UISystem |
| Kinda Realistic Flashlight | `mods/lua, red/Kinda Realistic Flashlight-12559-4-0-0-1774906094/r6/scripts/KindaRealisticFlashlight/Init.reds` (L117) | @addField on PlayerPuppet |
| Merc Protocol - Perk Gameplay Expansion | `mods/lua, red/Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259/r6/scripts/MercProtocol/Perks/perk_body.reds` (L112) | @addField on PlayerPuppet |
| Much Better Netrunning | `mods/lua, red/Much Better Netrunning/r6/scripts/BetterNetrunning/APCacheBuilder.reds` (L170) | @addField on PlayerPuppet |

*301 more mods use this pattern*

## Related Concepts

- [Wrap Method](wrap-method.md) — @addField stores state that @wrapMethod hooks then initialize and use
- [Replace Method](replace-method.md) — Full method override when adding new methods is insufficient
- [Codeware Framework](codeware-framework.md) — Codeware UI components stored in @addField variables
