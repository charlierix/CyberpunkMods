---
type: Mechanic Pattern
title: "Experience Gain Modifiers"
description: "Modifying experience gain rates, bonus XP, and level-up rewards"
tags: [player, xp, experience]
timestamp: 2026-07-04T00:00:00Z
---

# Experience Gain Modifiers

Modifying experience gain rates, bonus XP, and level-up rewards.

## Approach

This technique involves modifying experience gain rates, bonus xp, and level-up rewards. Mods use this to intercept, modify, or extend the game's player development system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/fact.lua:1663` | [0x00000019EFB9932F] = { id = "Items.DemolitionSkillbook", name = "SKILL SHARD: ANNIHILATION", kind  |
| Cyberpunk Story Quest Fixes | `bin/x64/plugins/cyber_engine_tweaks/mods/anygoodname_cp77_story_quest_fixes/init.lua:924` | ObserveAfter('LevelUpNotification', 'SetNotificationData', function(); |
| Custom Perk Framework-26771-2-12-1773960387 | `r6/scripts/CustomPerkFramework/UI/Popup.reds:48` | this.m_footer.SetFluffText("Modular Perk Expansion System"); |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Utils/DataExtractors/GeneralLoader.lua:59` | "SkillbookReward_Tech", |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/module/Props.lua:346` | pds:AddExperience(10000, gamedataProficiencyType.Level, telemetryLevelGainReason.Gameplay) |
| GoodFeelings-26874-1-0-5-1768609317 | `GoodFeelings/bin/x64/plugins/cyber_engine_tweaks/mods/GoodFeelings/Utils/DataExtractors/GeneralLoader.lua:59` | "SkillbookReward_Tech", |
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/Localization/Packages/English.reds:12` | this.Text("MercProtocol-Reward-PerkPoint", "+1 Perk Point"); |
| Much Better Netrunning | `r6/scripts/BetterNetrunning/Logging/XPGrantDiagnostic.reds:31` | public final static func AwardExperienceInstantly(player: wref<PlayerPuppet>, amount: Int32, type: g |

*22 more mods use this pattern.*


## Related Concepts

- [Player Development](./index.md) — parent concept
- [Perk Tree Modification](perk-modification.md) — alternative approach
- [Skill Progression Modification](skill-progression.md) — alternative approach
- [Custom Perk Frameworks](custom-perk-framework.md) — alternative approach
