---
type: Mechanic Pattern
title: Vendor UI Overrides
description: Wrapping vendor and ripperdoc game controllers to modify vendor interaction UI.
tags: [ui vendor ripperdoc shops]
timestamp: 2026-08-03T00:00:00Z
---

# Vendor UI Overrides

Wrapping vendor and ripperdoc game controllers to modify vendor interaction UI.

## Approach

Mods wrap `FullscreenVendorGameController` (36 wraps, 37 @addMethod) and `RipperDocGameController` (31 wraps) to modify vendor UI behavior. This includes custom vendor displays, modified item purchasing, or additional vendor UI features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/armorTweaks.reds` | Wraps `RipperDocGameController.UpdateArmorBar` |
| DropPointsReimagined-29563-1-0-0-1778351569 | `r6/scripts/DropPointsReimagined/Overrides/FullscreenVendorGameController.reds` | Wraps `FullscreenVendorGameController.HandleVendorSlotClick` |
| Enhanced Craft-4378-4-0-9-1779642516 | `r6/scripts/EnhancedCraft/core/Stash-Helpers.reds` | Wraps `FullscreenVendorGameController.PopulateVendorInventory` |
| Filthy Access Points-27698-1-2-1-1780438657 | `r6/scripts/FilthyAccessPoints/FilthyAccessPoints.reds` | Wraps `RipperDocGameController.SetButtonHints` |
| Immersive Cyberware-21916-1-0-2-1755792059 | `r6/scripts/ImmersiveCyberware/slotSupport.reds` | Wraps `RipperDocGameController.OnPreviewCyberwareClick` |

*13 more mods use this pattern.*

## Related Concepts

- [Vendor Logic Overrides](/economy/vendor-logic-overrides.md) — Wrapping Vendor class methods to change vendor interaction behavior at runtime.
- [Inventory UI Overrides](/ui/inventory-ui-overrides.md) — Wrapping inventory-related game controllers to modify inventory and backpack display.
