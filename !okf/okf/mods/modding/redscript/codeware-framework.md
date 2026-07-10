---
type: Mechanic Pattern
title: Codeware Framework Integration
description: Codeware UI and localization framework for Redscript mods providing reusable UI components, localization, and utility systems.
tags: [redscript, redmod, codeware, ui, localization, framework, library]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Codeware is a shared Redscript framework library that provides reusable UI components, localization systems, and gameplay utilities for Cyberpunk 2077 mods. It is distributed as a RED4ext plugin and imported via standard Redscript `import` statements. Mods using Codeware gain access to typed UI building blocks (`inkText`, `inkImage`, `inkButton`, etc.), localization providers, and event-driven game hooks without reimplementing boilerplate.

**Canonical usage:**

```reds
module MyMod

import Codeware.UI.*

@addField(gameuiVehicleShopGameController)
private let m_modDiscountButtonsContainer: ref<inkVerticalPanel>;

@addField(gameuiVehicleShopGameController)
private let m_modIncreaseButton: ref<SimpleButton>;

@wrapMethod(gameuiVehicleShopGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();
    // Create Codeware UI components
    this.m_modDiscountButtonsContainer = new inkVerticalPanel();
    this.m_modIncreaseButton = SimpleButton.Create()
        .SetLabel("Increase Discount")
        .Build();
    this.m_modDiscountButtonsContainer.AddChild(this.m_modIncreaseButton);
}
```

Key characteristics:
- Imported via `import Codeware.UI.*`, `import Codeware.Localization.*`, or specific submodules
- UI components follow a builder/fluent pattern: `.Create().SetLabel(...).Build()`
- Provides `SimpleButton`, `inkText`, `inkImage`, `inkVerticalPanel`, `inkHorizontalPanel`, and other typed wrappers over native `inkWidget` classes
- Localization system (`Codeware.Localization.*`) offers `LocalizationProvider` for multi-language string management
- `VirtualResolutionWatcher` handles UI scaling across different aspect ratios
- Commonly combined with `@addField` (to store Codeware component references) and `@wrapMethod` (to initialize components during UI lifecycle)

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| ACU - Character Customization | `mods/lua, red/ACU - Character Customization-3850-3-2-1-1777741508/r6/scripts/appearanceChangeUnlocker/mirrorUnlocker.reds` (L603) | import Codeware.UI.* for mirror UI customization |
| Advert Controller (Toggle Ads) | `mods/lua, red/Advert Controller (Toggle Ads)-18118-4-05-1778533573/r6/scripts/Advert_Controller/AdvertController.reds` (L411) | import Codeware.UI.* for toggle ad UI panel |
| all in one | `mods/lua, red/all in one-24528-2-1778729893/mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds` (L43614) | Core Codeware library source — defines all framework classes |
| Autofixer Discount Controls | `mods/lua, red/Autofixer Discount Controls - normal shard cost-17101-1-0-1728681346/r6/scripts/AutofixerDiscountControls/AutofixerDiscountControls.reds` (L244) | import Codeware.UI.* for vehicle shop discount buttons |
| CombatArena | `mods/lua, red/CombatArena-Vortex.zip-27580-0-2-1771142680/r6/scripts/CombatArena/arena_spawner.reds` (L810) | Codeware integration for combat arena spawner UI |
| Custom Perk Framework | `mods/lua, red/Custom Perk Framework-26771-2-12-1773960387/r6/scripts/CustomPerkFramework/UI/CharacterScreenButton.reds` (L186) | import Codeware.UI.* for custom perk screen popup |
| CustomHackingSystem | `mods/lua, red/CustomHackingSystem v1.3.0-5091-1-3-0-1704395205/r6/scripts/CustomHackingSystem/CodewareExtensions/InkCustomControllerExtensions.reds` (L212) | Extends Codeware UI controllers for custom hacking minigames |
| GPS Control | `mods/lua, red/GPS Control-22889-0-2-1753228515/r6/scripts/GPSControl/QuestTrackerMover.reds` | import Codeware.UI.* for quest tracker UI repositioning |
| Immersive Minimap | `mods/lua, red/Immersive Minimap (2.0 Hotfix 2)-3239-2-0h2-1701471004/r6/scripts/GPS Minimap/ImmersiveMinimap.reds` (L151) | import Codeware.UI.* for minimap overlay rendering |
| Immersive Odometer and Fuel System | `mods/lua, red/Immersive Odometer and Fuel System - PL-24443-1-3-2-1780088111/r6/scripts/VehicleMileage/UI/VMHUD.reds` (L1854) | import Codeware.UI.VirtualResolutionWatcher for HUD scaling |
| Merc Protocol | `mods/lua, red/Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259/r6/scripts/MercProtocol/FrameworkIntegration.reds` (L125) | import Codeware.UI.* for perk framework integration |
| Much Better Impacts | `mods/lua, red/Much Better Impacts/r6/scripts/MuchBetterImpacts/Localization/LocalizationProvider.reds` | import Codeware.Localization.* for impact string localization |

*188 more mods use this pattern*

## Related Concepts

- [Wrap Method](wrap-method.md) — Codeware UI components are initialized inside @wrapMethod lifecycle hooks
- [Add Method](add-method.md) — @addField stores Codeware component references on native classes
- [Replace Method](replace-method.md) — Some mods replace native UI methods to integrate Codeware components
