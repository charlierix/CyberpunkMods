---
type: Mechanic Pattern
title: "Inventory"
description: "Player inventory management, item add/remove, and transaction system manipulation patterns"
tags: [player, inventory]
timestamp: 2026-07-04T00:00:00Z
---

# Inventory

Player inventory management, item add/remove, and transaction system manipulation patterns.

## Add/Remove Items

Using AddToInventory and TransactionSystem to programmatically add/remove items at runtime.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Abstract Street Shirt-28198-abstract-01-1773425811 | `r6/tweaks/heruhhh/Abstract_StreetShirt_HERA.yaml` | # Game.AddToInventory("Items.abstract_shirt_black",1) |
| All Night Lingerie-27772-1-0-1771855134 | `r6/tweaks/tony_allnight_lingerie.yaml:1` | # Game.AddToInventory("Items.tony_allnight_gloves_black") |
| Anna Henrietta-25414-1-0-1762026446 | `r6/tweaks/tony_annahenrietta.yaml:1` | # Game.AddToInventory("Items.tony_annahenrietta_hair") |
| Arasaka Elite Ninja-27459-1-0-1770766524 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Ninja.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_ninja_helmet_black") |
| Arasaka Elite Soldier-26758-1-2-1770784590 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Soldier.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_shirt_black") |
| Assassin Outfit-28900-1-0-1776186970 | `r6/tweaks/tony_assassin_outfit.yaml:1` | # Game.AddToInventory("Items.tony_assassin_glove_left_black") |
| Assassin Sister boots (EBB_EBBP_VANILLA)-19145-1-0-1737112891 | `r6/tweaks/tony_as_boots.yaml` | # Game.AddToInventory("Items.tony_as_boots_black") |
| Asymmetrical Suit-21667-1-0-1747932950 | `r6/tweaks/tony_asymmetrical_suit.yaml:1` | # Game.AddToInventory("Items.tony_asym_suit_l_black") |

*277 more mods use this pattern.*

## Custom Item Creation

Creating new items via TweakDB records with custom stats, appearances, and properties.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Abstract Street Shirt-28198-abstract-01-1773425811 | `r6/tweaks/heruhhh/Abstract_StreetShirt_HERA.yaml` | # Game.AddToInventory("Items.abstract_shirt_black",1) |
| All Night Lingerie-27772-1-0-1771855134 | `r6/tweaks/tony_allnight_lingerie.yaml:1` | # Game.AddToInventory("Items.tony_allnight_gloves_black") |
| Anna Henrietta-25414-1-0-1762026446 | `r6/tweaks/tony_annahenrietta.yaml:1` | # Game.AddToInventory("Items.tony_annahenrietta_hair") |
| Arasaka Elite Ninja-27459-1-0-1770766524 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Ninja.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_ninja_helmet_black") |
| Arasaka Elite Soldier-26758-1-2-1770784590 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Soldier.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_shirt_black") |
| Assassin Outfit-28900-1-0-1776186970 | `r6/tweaks/tony_assassin_outfit.yaml:1` | # Game.AddToInventory("Items.tony_assassin_glove_left_black") |
| Assassin Sister boots (EBB_EBBP_VANILLA)-19145-1-0-1737112891 | `r6/tweaks/tony_as_boots.yaml` | # Game.AddToInventory("Items.tony_as_boots_black") |
| Asymmetrical Suit-21667-1-0-1747932950 | `r6/tweaks/tony_asymmetrical_suit.yaml:1` | # Game.AddToInventory("Items.tony_asym_suit_l_black") |

*231 more mods use this pattern.*

## Inventory Management

Modifying inventory capacity, sorting, filtering, and item organization.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Abstract Street Shirt-28198-abstract-01-1773425811 | `r6/tweaks/heruhhh/Abstract_StreetShirt_HERA.yaml` | # Game.AddToInventory("Items.abstract_shirt_black",1) |
| All Night Lingerie-27772-1-0-1771855134 | `r6/tweaks/tony_allnight_lingerie.yaml:1` | # Game.AddToInventory("Items.tony_allnight_gloves_black") |
| Anna Henrietta-25414-1-0-1762026446 | `r6/tweaks/tony_annahenrietta.yaml:1` | # Game.AddToInventory("Items.tony_annahenrietta_hair") |
| Arasaka Elite Ninja-27459-1-0-1770766524 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Ninja.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_ninja_helmet_black") |
| Arasaka Elite Soldier-26758-1-2-1770784590 | `r6/tweaks/phntm/PHNTM_Arasaka_Elite_Soldier.yaml:1` | # Game.AddToInventory("Items.arasaka_elite_shirt_black") |
| Assassin Outfit-28900-1-0-1776186970 | `r6/tweaks/tony_assassin_outfit.yaml:1` | # Game.AddToInventory("Items.tony_assassin_glove_left_black") |
| Assassin Sister boots (EBB_EBBP_VANILLA)-19145-1-0-1737112891 | `r6/tweaks/tony_as_boots.yaml` | # Game.AddToInventory("Items.tony_as_boots_black") |
| Asymmetrical Suit-21667-1-0-1747932950 | `r6/tweaks/tony_asymmetrical_suit.yaml:1` | # Game.AddToInventory("Items.tony_asym_suit_l_black") |

*162 more mods use this pattern.*


## Related Concepts

- [Vendors & Market](..//economy/vendors-market/index.md) — related manipulation pattern
- [Equipment & Wardrobe](..//player/equipment.md) — related manipulation pattern
