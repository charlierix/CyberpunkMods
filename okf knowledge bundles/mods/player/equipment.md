---
type: Mechanic Pattern
title: "Equipment & Wardrobe"
description: "Equipment slots, wardrobe system, and outfit management manipulation patterns"
tags: [player, equipment]
timestamp: 2026-07-04T00:00:00Z
---

# Equipment & Wardrobe

Equipment slots, wardrobe system, and outfit management manipulation patterns.

## Equipment Slot Manipulation

Modifying equipment slots, adding new slots, or changing equip/unequip behavior.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A. Ubiquitous Chib - Heywood - Upcoming Merc-21088-1-2-0-1754859537 | `r6/tweaks/TheUbiquitousChib_Heywood.yaml:127` | OnEquip: [] |
| A. Ubiquitous Chib - Santo Domingo - Upcoming Merc-21490-1-2-0-1754861078 | `r6/tweaks/TheUbiquitousChib_SantoDomingo.yaml:150` | OnEquip: [] |
| A. Ubiquitous Chib - Westbrook - Upcoming Merc-21175-1-2-0-1754860503 | `r6/tweaks/TheUbiquitousChib_Westbrook.yaml:127` | OnEquip: [] |
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:62` | statType: BaseStats.EquipDuration |
| B. Ubiquitous Chib - Heywood - Legend of NC-21088-1-2-0-1754859589 | `r6/tweaks/TheUbiquitousChib_Heywood.yaml:118` | OnEquip: [] |
| Ops-Core FAST Helmet-13557-3-4-1757020329 | `r6/tweaks/scorpiontank/scorpion_military_opscore_helmet.yaml:32` | OnEquip: |
| The Zenitex Military Store-21735-1-2-1765449267 | `r6/tweaks/scorpiontank/scorpion_zenitex_store_scannable.yaml:214` | OnEquip: [] |
| Zenitex Assault Helmet | `r6/tweaks/scorpiontank/scorpion_zenitex_assault_helmet.yaml:441` | OnEquip: |

*195 more mods use this pattern.*

## Wardrobe & Outfit System

Using WardrobeSystem and OutfitSystem for outfit swapping, appearance management, and cosmetic overrides.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/npc.lua:1463` | playerEquipmentData:HideItem(gamedataEquipmentArea.Outfit, false) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/init.lua:220` | EQXUnlocker.ws = Game.GetWardrobeSystem()                                                            |
| Interactive Accessories-22472-1-0-1751421384 | `bin/x64/plugins/cyber_engine_tweaks/mods/InteractiveAccessories/modules/lang.lua` | ["QuickToggleSlot_1_desc"] = "The EquipmentEx OutfitSlot which will be used for Quick Toggle #1.", |
| Random Outfit Destruction (cp2077 v2.3)-22660-1-5-1769976819 | `ROD/bin/x64/plugins/cyber_engine_tweaks/mods/Random Outfit Destruction/init.lua:147` | -- Get every saved Equipment-EX outfit name in CET |
| Visual Holsters-21936-1-2-1751235859 | `bin/x64/plugins/cyber_engine_tweaks/mods/VisualHolster/init.lua:87` | local WardrobeSystem = nil |
| Wardrobe Items Adder-5742-2-1-0-1768421740 | `bin/x64/plugins/cyber_engine_tweaks/mods/wardrobe_items_adder/filters.lua` | local wardrobeSystem = Game.GetWardrobeSystem() |
| Kiroshi Night Vision Mod 1.81-8326-1-81-1719068439 | `bin/x64/plugins/cyber_engine_tweaks/mods/nightVision/init.lua:59` | local eqx = EquipmentEx_OutfitSystem |
| Atelier Price Fixer-28279-1-4-0-1774797187 | `r6/scripts/AtelierPriceFixer/Classifier.reds:21` | if Equals(equipArea, gamedataEquipmentArea.Outfit)     { return 6; } // Outfit |

*28 more mods use this pattern.*

## Appearance Override

Overriding player appearance via archive assets, appearance records, and visual substitution.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/npc.lua:1474` | playerEquipmentData:EquipVisuals(itemId) |
| Visual Holsters-21936-1-2-1751235859 | `bin/x64/plugins/cyber_engine_tweaks/mods/VisualHolster/init.lua:9` | -- data/slots.lua contains the list of EquipmentEx slots that are considered valid for items to be e |
| Drone Companions (Revamp)-23980-0-5-0-1757655327 | `bin/x64/plugins/cyber_engine_tweaks/mods/Drone Companions (Revamp)/Modules/Base Drones.lua:119` | local skip = { archetypeData=true, primaryEquipment=true, secondaryEquipment=true, displayName=true, |
| Bulge Detector 1.1-14775-1-1-1716025026 | `r6/scripts/BulgeDetector/BulgeDetector.reds:23` | public func OnItemEquippedVisual(slot: TweakDBID, item: ItemID) -> Void { |
| Street Sense | `r6/scripts/StreetSense/UNR_CrowdReactions.reds:17` | // EX outfit changes bypass OnEquipProcessVisualTags |
| CyberwareMeshExt-10629-1-7-1-1718531957 | `r6/scripts/CyberwareMeshExt/CyberwareMeshMenu.reds:260` | public func OnItemEquippedVisual(slot: TweakDBID, item: ItemID) -> Void{ |
| DynamicNPCItems-v1.5-16158-1-5-1742833376 | `r6/scripts/DynamicNPCItems/Main.reds:169` | txnSystem.ChangeItemAppearanceByName(entity, itemToEquip, randomApp); |
| Equipment-EX-6945-1-2-9-1773737132 | `r6/scripts/EquipmentEx/EquipmentEx.Global.reds:276` | private final func ClearItemAppearanceEvent(area: gamedataEquipmentArea) { |

*4 more mods use this pattern.*


## Related Concepts

- [Inventory](..//player/inventory.md) — related manipulation pattern
