---
type: Mechanic Pattern
title: "Custom Perk Frameworks"
description: "Creating entirely new perk frameworks with custom perk definitions and effects"
tags: [player, perks, framework]
timestamp: 2026-07-04T00:00:00Z
---

# Custom Perk Frameworks

Creating entirely new perk frameworks with custom perk definitions and effects.

## Approach

This technique involves creating entirely new perk frameworks with custom perk definitions and effects. Mods use this to intercept, modify, or extend the game's player development system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Bag and Tag - CET Rewrite-28746-1-0-21-1776129453 | `cp2077_mod_sanity_test/bin/x64/plugins/cyber_engine_tweaks/mods/virtu_mod_sanity_test/init.lua:740` | return p:NBH_AddPerkPoints(amount) == true |
| Custom Perk Framework-26771-2-12-1773960387 | `bin/x64/plugins/cyber_engine_tweaks/mods/CustomPerkFramework/init.lua` | Override('CustomPerkFramework.CustomPerkFrameworkConfig', 'ControllerType;', function() |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Utils/PlayerDevelopment.lua` | function PlayerDevelopment.AddPerk(perkType, force) |
| GoodFeelings-26874-1-0-5-1768609317 | `GoodFeelings/bin/x64/plugins/cyber_engine_tweaks/mods/GoodFeelings/Utils/PlayerDevelopment.lua` | function PlayerDevelopment.AddPerk(perkType, force) |
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/FrameworkIntegration.reds` | import CustomPerkFramework.* |
| ProjectE3-HUD-Tweaks-23901-2-5-1777305492 | `r6/scripts/ProjectE3-HUD-Tweaks/E3HUDTweaks-Fixes.reds:38` | @if(ModuleExists("TheyWillRemember.Disguise") // ModuleExists("StealthRunner.HubMenu") // ModuleExis |
| Stealthrunner | `r6/scripts/StealthRunner/notification.reds:345` | this.AddPerkPointToRewardRow(row); |


## Related Concepts

- [Player Development](./index.md) — parent concept
- [Perk Tree Modification](perk-modification.md) — alternative approach
- [Skill Progression Modification](skill-progression.md) — alternative approach
- [Experience Gain Modifiers](experience-modifiers.md) — alternative approach
