---
type: Mechanic Pattern
title: "Loot & Drops"
description: "Loot tables, item drops, and loot generation manipulation patterns"
tags: [combat, loot]
timestamp: 2026-07-04T00:00:00Z
---

# Loot & Drops

Loot tables, item drops, and loot generation manipulation patterns.

## Loot Table Modification

Modifying loot drop tables, drop chances, and loot pool definitions via TweakDB.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_world.yaml` | LootTables.Loot_misoru_ronin_case_OLD: # case loot table |
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/Character.valentinos_Boss_ranged3.yaml:39` | lootDrop: LootTables.valentinos_Boss_loot_table |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/tweakdb-ids.lua:279` | [0x00000014BAD3C36F] = "Items.MoneyLootTable", |
| Less Lethal Cops mod | `r6/tweaks/less_lethal_cops/Character.arr_ncpd_police_melee2_baton_ma.yaml:96` | lootDrop: LootTables.Empty |
| davidsapogee-16784-v2-25-3-1741706742 | `bin/x64/plugins/cyber_engine_tweaks/mods/DavidsApogee/martinez.lua:37` | martinez.FalcosLootBox    = 'LootTables.mq049_jacket_lt' |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/data/ItemList.lua:2800` | "LootTables.Base_ma_simple_enhancers_inline9", |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds:772` | public native let lootTables: array<TweakDBID>; |
| BVSC-28504-1-0-0-1774891592 | `r6/tweaks/BVSC/Item/Firework/Loot.yaml` | $type: gamedataLootTable_Record |

*32 more mods use this pattern.*

## Loot Rule Customization

Creating custom loot generation rules, conditional drops, and rarity modifiers.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_world.yaml` | lootGenerationType: dropChance |
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/LootTables.q304_kurtz_loot.yaml` | lootGenerationType: dropChance |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds:30443` | public static func GetLootModCyberwarePath() -> CName = n"loot_mod_cyberware"; |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds:17821` | CraftingMaterialDropChance = 300, |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds:30443` | public static func GetLootModCyberwarePath() -> CName = n"loot_mod_cyberware"; |
| BVSC-28504-1-0-0-1774891592 | `r6/tweaks/BVSC/Item/Firework/Loot.yaml` | lootGenerationType: dropChance |
| Drone Companions (Revamp)-23980-0-5-0-1757655327 | `r6/tweaks/DCO Misc/DCO_01_Misc_Vendor.yaml:58` | dropChance: 1 |
| DropPointsReimagined-29563-1-0-0-1778351569 | `r6/tweaks/DropPointsReimagined/Package/NPCPackage/Lifepath.yaml:19` | lootGenerationType: dropChance |

*22 more mods use this pattern.*


## Related Concepts

- [Inventory](..//player/inventory.md) — related manipulation pattern
