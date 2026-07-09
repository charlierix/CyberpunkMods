---
type: Mechanic Pattern
title: "Archive Injection"
description: "Asset injection via .archive files for model, texture, and UI replacement patterns"
tags: [economy, archive, injection]
timestamp: 2026-07-04T00:00:00Z
---

# Archive Injection

Asset injection via .archive files for model, texture, and UI replacement patterns.

## Archive Asset Replacement

Replacing vanilla game assets (models, textures, UI) via .archive file injection.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animal Cache KR translation-23417-1-0-0-1754998164 | `archive/pc/mod/misoru_cache_animals_kr.archive.xl` | extend: misoru_cache_animals.archive.xl |
| Animals Cache - New Iconic Weapons PTBR-23201-1-0-0-1754357758 | `archive/pc/mod/animalscacheptbr.archive.xl` | extend: misoru_cache_animals.archive.xl |
| Dialogue History - PT-BR-25568-1-0-1762799585 | `archive/pc/mod/Dialogue_History_PT-BR.archive.xl` | extend: dialogue_history.archive.xl |
| Looting QoL PTBR-18309-1-8-1757096713 | `archive/pc/mod/Looting QoL PTBR.archive.xl` | extend: LootingQoL.archive.xl |
| Mox Cache - New Iconic Weapons PTBR-20117-1-0-0-1740981508 | `archive/pc/mod/moxcacheptbr.archive.xl` | extend: misoru_cache_mox.archive.xl |
| NCPD Cache - New Iconic Weapons PTBR-23000-1-0-1-1753665599 | `archive/pc/mod/ncpdcacheptbr.archive.xl` | extend: misoru_cache_ncpd.archive.xl |
| New Lifepath Intro - Fresh Start PTBR-18295-1-3-0-1753490803 | `archive/pc/mod/#FreshStart PTBR.archive.xl` | extend: #FreshStart_PTBR.archive |
| Nomad Cache - New Iconic Weapons PTBR-19357-1-0-1737965667 | `archive/pc/mod/nomadcachaptbr.archive.xl` | extend: misoru_cache_nomad.archive.xl |

*67 more mods use this pattern.*

## ArchiveXL Dynamic Loading

Using ArchiveXL (.xl) for dynamic asset loading to add new items without replacing vanilla.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animal Cache KR translation-23417-1-0-0-1754998164 | `archive/pc/mod/misoru_cache_animals_kr.archive.xl` | extend: misoru_cache_animals.archive.xl |
| Animals Cache - New Iconic Weapons PTBR-23201-1-0-0-1754357758 | `archive/pc/mod/animalscacheptbr.archive.xl` | extend: misoru_cache_animals.archive.xl |
| Dialogue History - PT-BR-25568-1-0-1762799585 | `archive/pc/mod/Dialogue_History_PT-BR.archive.xl` | extend: dialogue_history.archive.xl |
| Looting QoL PTBR-18309-1-8-1757096713 | `archive/pc/mod/Looting QoL PTBR.archive.xl` | extend: LootingQoL.archive.xl |
| Mox Cache - New Iconic Weapons PTBR-20117-1-0-0-1740981508 | `archive/pc/mod/moxcacheptbr.archive.xl` | extend: misoru_cache_mox.archive.xl |
| NCPD Cache - New Iconic Weapons PTBR-23000-1-0-1-1753665599 | `archive/pc/mod/ncpdcacheptbr.archive.xl` | extend: misoru_cache_ncpd.archive.xl |
| Nomad Cache - New Iconic Weapons PTBR-19357-1-0-1737965667 | `archive/pc/mod/nomadcachaptbr.archive.xl` | extend: misoru_cache_nomad.archive.xl |
| Quickhack Fixes PTBR-20361-1-2-18-1753242026 | `archive/pc/mod/quickhackfixesPTBR.archive.xl` | extend: Quickhack_Fixes.archive.xl |

*35 more mods use this pattern.*

## Tweak Appearance Records

Combining archive injection with TweakDB YAML to add new appearance records for items.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:3177` | elseif archive.name == "AMM_Cheri_Appearances" and archive.active then |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:17` | -- psiberx         for codeware, TweakDB, & ArchiveXL, documentation and various help using them & C |
| Gambling-29866-1-1779352615 | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:17` | -- psiberx         for codeware, TweakDB, & ArchiveXL, documentation and various help using them & C |
| Wardrobe Courier - EquipmentEx Addon-18519-2-0-1773766270 | `bin/x64/plugins/cyber_engine_tweaks/mods/wardrobe_courier/init.lua:169` | ImGui.TextWrapped("JSON export: a readable file with each outfit, its slots, item names, archive pat |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/ArchiveXL/Bundle/Migration.xl:5` | archive_xl\characters\head\player_base_heads\appearances\head\hel_000_pma__basehead.app: |
| ArasakaOfficeJob V1.3.4-29054-2-1781029231 | `r6/scripts/ArasakaOfficeJob/ArasakaSystem.reds:485` | // shipped the .yaml at archive/pc/mod/ — a path TweakXL |
| CET NPC Body Tweaks with Codeware Extensions-10458-2-2-5-1781078870 | `bin/x64/plugins/cyber_engine_tweaks/mods/CET_NPC_Body_Tweaks/init.lua:380` | if type(archiveModsData.exclusionTemplates.excludedAppearances) == 'table' then |
| Sleeves-3309-3-2-9-1779721461 | `r6/scripts/sleeves.reds:2` | @if(ModuleExists("ArchiveXL.DynamicAppearance")) |


## Related Concepts

- [Equipment & Wardrobe](..//player/equipment.md) — related manipulation pattern
