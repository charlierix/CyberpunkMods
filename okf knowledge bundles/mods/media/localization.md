---
type: Mechanic Pattern
title: "Localization"
description: "Text localization, language strings, and localization provider manipulation patterns"
tags: [media, localization]
timestamp: 2026-07-04T00:00:00Z
---

# Localization

Text localization, language strings, and localization provider manipulation patterns.

## Localization Provider Registration

Registering custom LocalizationProvider to inject custom text strings for UI, items, and quests.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/FrameworkIntegration.reds` | let localization: ref<LocalizationSystem> = LocalizationSystem.GetInstance(this.m_player.GetGame()); |
| Much Better Impacts | `r6/scripts/MuchBetterImpacts/Localization/LocalizationProvider.reds` | public class LocalizationProvider extends ModLocalizationProvider { |
| Much Better Netrunning | `r6/scripts/BetterNetrunning/Localization/LocalizationProvider.reds` | public class LocalizationProvider extends ModLocalizationProvider { |
| NCX Wireless | `r6/scripts/NCXWireless/NCXWireless.MapPinLocalization.reds` | public class NCXWirelessTowerLocalizationProvider extends ModLocalizationProvider { |
| NPCNameplates-26615-1-11-1-1778363372 | `r6/scripts/NPCNameplates/Localization.reds` | public class NPCNameplateLocalizationProvider { |
| Unified Mod Settings | `r6/scripts/UnifiedModSettings/Localization/LocalizationProvider.reds` | public class LocalizationProvider extends ModLocalizationProvider { |
| VRealtimeInfo-22515-0-5-3-1754438881 | `r6/scripts/VRealtimeInfo/localization.reds:149` | public class VRILocalizationProvider extends ModLocalizationProvider { |
| Weapon Conditioning-10479-1-2-1-1776102382 | `r6/scripts/Weapon Conditioning/Localization.reds` | public class LocalizationProvider extends ModLocalizationProvider { |

*45 more mods use this pattern.*

## Translation Packs

Archive-based translation packs that replace or add localized text via .archive files.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A. Ubiquitous Chib - Heywood - Upcoming Merc-21088-1-2-0-1754859537 | `archive/pc/mod/theubiquitouschib_heywood.archive.xl` | localization: |
| A. Ubiquitous Chib - Santo Domingo - Upcoming Merc-21490-1-2-0-1754861078 | `archive/pc/mod/theubiquitouschib_santodomingo.archive.xl` | localization: |
| A. Ubiquitous Chib - Westbrook - Upcoming Merc-21175-1-2-0-1754860503 | `archive/pc/mod/theubiquitouschib_westbrook.archive.xl` | localization: |
| Abstract Street Shirt-28198-abstract-01-1773425811 | `archive/pc/mod/Abstract_StreetShirt_HERA.xl` | localization: |
| Aeryn Wu Babydoll Cami And Panties 4k-28889-1-3-1779444103 | `archive/pc/mod/aw_babydoll_set.archive.xl` | localization: |
| Aeryn Wu Off-Shoulder Button-Up-27453-1-2-1778877916 | `archive/pc/mod/aw_off_shoulder_shirt.archive.xl` | localization: |
| Aeryn Wu Princess Platforms and Socks 4k-26301-1-0-1765925489 | `archive/pc/mod/aw_princess_platforms.archive.xl:4` | localization: |
| All Night Lingerie-27772-1-0-1771855134 | `archive/pc/mod/tony_allnight_lingerie.xl` | localization: |

*515 more mods use this pattern.*

## Inline String Injection

Injecting localized strings inline via Lua or Redscript for runtime text display.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/see.lua:4343` | userData.title = GetLocalizedText("Story-base-gameplay-gui-widgets-notifications-quest_update-_local |
| grappling_hook | `inventory/util_inventory.lua:623` | -- -- Get the localization key (LocKey) of the "displayName" property |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/Modules/core.lua:630` | this.trackName:SetLocalizationKey(lockey) |
| Advert Controller (Toggle Ads)-18118-4-05-1778533573 | `r6/tweaks/Advert_Controller/AdvertController.yaml` | localizationKey: LocKey#36326 |
| BVSC-28504-1-0-0-1774891592 | `bin/x64/plugins/cyber_engine_tweaks/mods/BVSC/Helpers/GetLocalizedTextByName.lua` | -- When `LocKey` function is applied to a string with a `secondaryKey` of `localizationPersistenceOn |
| DropPointsReimagined-29563-1-0-0-1778351569 | `bin/x64/plugins/cyber_engine_tweaks/mods/DropPointsReimagined/Helpers/GetLocalizedTextByName.lua` | -- When `LocKey` function is applied to a string with a `secondaryKey` of `localizationPersistenceOn |
| Give Em Guns-22200-2-0-0-1778658387 | `bin/x64/plugins/cyber_engine_tweaks/mods/GiveEmGuns/Helpers/GetLocalizedTextByName.lua` | -- When `LocKey` function is applied to a string with a `secondaryKey` of `localizationPersistenceOn |
| HUDitor-3315-1-1-0-1770366067 | `r6/scripts/HUDitor/preview.reds:140` | data.title = GetLocalizedText("Story-base-gameplay-gui-widgets-notifications-quest_update-_localizat |

*19 more mods use this pattern.*


## Related Concepts

- [HUD & Menus](..//ui/hud-menus.md) — related manipulation pattern
