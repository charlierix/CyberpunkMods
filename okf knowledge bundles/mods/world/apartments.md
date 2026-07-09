---
type: Mechanic Pattern
title: "Apartments"
description: "Player apartment system, home locations, and interior management manipulation patterns"
tags: [world, apartments]
timestamp: 2026-07-04T00:00:00Z
---

# Apartments

Player apartment system, home locations, and interior management manipulation patterns.

## Apartment Spawning

Adding new apartment locations, interiors, and home access points to the game.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Chill Heywood Apartment - Main File-26263-1-0-3-1776030342 | `archive/pc/mod/DP77_Chill_Heywood_Apartment.xl` | - dp77_chill_heywood_apartment/all.streamingblock |
| Coyote Cojo's rooftop apartment - With friends-27269-1-1-1775592923 | `archive/pc/mod/coyotes_bar_apartment_friends_1.1.xl` | {"streaming":{"blocks":["coyotes_bar_apartment_friends_1.1/all.streamingblock"]},"resource":{"patch" |
| Gomorrah Standalone-23350-2-0-1778351476 | `archive/pc/mod/Gomorrah_removed.xl:591` | - resource: base\environment\architecture\common\int\int_ent_apartment_a\int_ent_apartment_a_ceiling |
| Japanese Apartment-24200-1-0-3-1762291063 | `archive/pc/mod/japaneseapartment.xl` | {"streaming":{"blocks":["japaneseapartment1.02/all.streamingblock"]},"resource":{"patch":{"japanesea |
| Lucy Apartment Remastered 2025-23239-1-4-1756798060 | `archive/pc/mod/lucy_apartment.xl` | {"streaming":{"blocks":["lucy_apartment/all.streamingblock"]},"resource":{"patch":{"lucy_apartment/c |
| Nomad Trailer Apartment-27369-2-0-1773573312 | `archive/pc/mod/nomad_trailer_apartment.xl` | {"streaming":{"blocks":["nomad_trailer_apartment/all.streamingblock"]},"resource":{"patch":{"nomad_t |
| Arasaka Hideout - AMM Preset - v0.2-10346-0-2-1698377567 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua:1776` | path = "base\\amm_props\\collab\\entity\\int_nkt_apartment_a_neon_light_1300_aa.ent", |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:568` | settings.useNewGame2, changedUseNewGame2 = ImGui.Checkbox("##Run On New Game (On First Time Entering |

*74 more mods use this pattern.*

## Interior Modification

Modifying existing apartment interiors with custom props, decorations, and interactive elements.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| (ARCHIVE) Cyber Noir Flat - Preem Edition-9765-1-0-1749524024 | `archive/pc/mod/cyber_noir_flat_preem_edition_cleaner.xl:1` | {"streaming":{"sectors":[{"nodeDeletions":[{"resource":"base\\environment\\decoration\\lighting\\res |
| Dogtown Hideout Remake - Authentic-26694-2-1-1773346537 | `archive/pc/mod/Dogtown_Hideout_Clean.xl:1` | {"streaming":{"sectors":[{"path":"base\\worlds\\03_night_city\\_compiled\\default\\ep1\\interior_-70 |
| Lizzie'S Bar Ovehaul-30128-1-1780143257 | `archive/pc/mod/Lizzie's Removal.xl:1` | {"streaming":{"sectors":[{"nodeDeletions":[{"resource":"base\\environment\\decoration\\food\\fast_fo |
| H10 - Tidy Your Trash-25124-2-2-1-1774002106 | `archive/pc/mod/TidyYourTrash_H10_Removals.xl:1` | {"streaming":{"sectors":[{"path":"base\\worlds\\03_night_city\\_compiled\\default\\interior_-44_39_3 |
| JT - Tidy Your Trash-25536-1-2-0-1773987172 | `archive/pc/mod/TidyYourTrash_JT_Removals.xl:1` | {"streaming":{"sectors":[{"path":"base\\worlds\\03_night_city\\_compiled\\default\\interior_-25_30_0 |
| NCX Wireless | `bin/x64/plugins/cyber_engine_tweaks/mods/ncx_story_suppression/init.lua:764` | return getFact("apartment_on") > 0 or getFact("interior_manager_on") > 0 |
| Rockerdoll Japantown Apartment-28839-3-01-1778073807 | `Rockerdoll Japantown Apartment/archive/pc/mod/Rockerdoll Japantown Apartment Removal.xl:1` | {"streaming":{"sectors":[{"expectedNodes":201,"path":"base\\worlds\\03_night_city\\_compiled\\defaul |
| KIROSHI OPTICALS NETWATCH SCANNER-23664-2-1762280179 | `STREETKID/r6/scripts/backgroundScanner/text.reds:8609` | public static func JOB_EXPANSION_402_F() -> String { return "She %startedwork% as a luxury accommoda |

*2 more mods use this pattern.*


## Related Concepts

- [World State](..//systems/world-state.md) — related manipulation pattern
