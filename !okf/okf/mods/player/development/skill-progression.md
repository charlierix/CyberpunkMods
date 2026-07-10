---
type: Mechanic Pattern
title: "Skill Progression Modification"
description: "Modifying skill leveling curves, proficiency gains, and attribute progression"
tags: [player, skills, progression]
timestamp: 2026-07-04T00:00:00Z
---

# Skill Progression Modification

Modifying skill leveling curves, proficiency gains, and attribute progression.

## Approach

This technique involves modifying skill leveling curves, proficiency gains, and attribute progression. Mods use this to intercept, modify, or extend the game's player development system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:2205` | ["helperTitle"] = "Player : Give Skill Point", |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnUtil.lua:350` | function getSkillProficiencyType(skill) |
| Cyberpunk Story Quest Fixes | `bin/x64/plugins/cyber_engine_tweaks/mods/anygoodname_cp77_story_quest_fixes/init.lua:924` | ObserveAfter('LevelUpNotification', 'SetNotificationData', function(); |
| NanoDrone 1.6-3419-1-6-1710086061 | `bin/x64/plugins/cyber_engine_tweaks/mods/nanoDrone/modules/drone.lua:292` | if target:HasAnySkillCheckActive() then |
| davidsapogee-16784-v2-25-3-1741706742 | `bin/x64/plugins/cyber_engine_tweaks/mods/DavidsApogee/gui.lua:250` | ImGui.Text(l.Debug_SectionRunner_SkillLevel..":"..NetRunnerLevelText) |
| Custom Perk Framework-26771-2-12-1773960387 | `r6/scripts/CustomPerkFramework/UI/Popup.reds:559` | // Second bar: Attribute Points / Indicators / Perk Points |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds:4413` | public static func GetSkillSelectPath() -> CName = n"skill_select"; |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Utils/PlayerDevelopment.lua` | return data and data:GetProficiencyLevel(profType) or nil |

*71 more mods use this pattern.*


## Related Concepts

- [Player Development](./index.md) — parent concept
- [Perk Tree Modification](perk-modification.md) — alternative approach
- [Custom Perk Frameworks](custom-perk-framework.md) — alternative approach
- [Experience Gain Modifiers](experience-modifiers.md) — alternative approach
