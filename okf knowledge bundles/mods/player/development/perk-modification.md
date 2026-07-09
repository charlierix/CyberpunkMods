---
type: Mechanic Pattern
title: "Perk Tree Modification"
description: "Modifying perk trees, perk effects, and perk unlock conditions via TweakDB"
tags: [player, perks, tweakdb]
timestamp: 2026-07-04T00:00:00Z
---

# Perk Tree Modification

Modifying perk trees, perk effects, and perk unlock conditions via TweakDB.

## Approach

This technique involves modifying perk trees, perk effects, and perk unlock conditions via tweakdb. Mods use this to intercept, modify, or extend the game's player development system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:133` | $base: Perks.ApplyStatusEffectOnPlayer |
| Arasaka Hideout - AMM Preset - v0.2-10346-0-2-1698377567 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua:1991` | name = "Perk Collectibles Case", |
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/Character.valentinos_Boss_ranged3.yaml:129` | - Takedown.NewPerkFinisher |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:2183` | ["helperTitle"] = "Player : Give Perk Point", |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/cetUtils.lua:13` | function CetUtils.GetLocalizedPerkName(newPerkType) |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:77` | togglePerkOverclock = true, |
| Judys Cabin Redone-13799-1-0-1711151322 | `Judys Cabin Redone - AMM Preset/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua:1991` | name = "Perk Collectibles Case", |
| MagazineReload-25511-1-4-1773098387 | `bin/x64/plugins/cyber_engine_tweaks/mods/MagazineReload/fastReload.lua:18` | - Aplicar efecto de estado "BaseStatusEffect.RelaxedCoolPerkSE" al jugador -> funciona pero solo par |

*89 more mods use this pattern.*


## Related Concepts

- [Player Development](./index.md) — parent concept
- [Skill Progression Modification](skill-progression.md) — alternative approach
- [Custom Perk Frameworks](custom-perk-framework.md) — alternative approach
- [Experience Gain Modifiers](experience-modifiers.md) — alternative approach
