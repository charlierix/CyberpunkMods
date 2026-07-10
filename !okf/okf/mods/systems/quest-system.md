---
type: Mechanic Pattern
title: "Quest System"
description: "Quest tracking, journal entries, and quest state management manipulation patterns"
tags: [systems, quest, system]
timestamp: 2026-07-04T00:00:00Z
---

# Quest System

Quest tracking, journal entries, and quest state management manipulation patterns.

## Quest State Manipulation

Manipulating quest states, flags, and progression via GetQuestsSystem.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:260` | return Game.GetQuestsSystem():GetFactStr(sessionKeyFactName) |
| Arasaka HUD-22720-1-0-1752541406 | `bin/x64/plugins/cyber_engine_tweaks/mods/ArasakaHUD/init.lua` | local quests_system = Game.GetQuestsSystem() |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:418` | Observe("QuestsSystem", "SetFact", function(this, factName, value) |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:374` | local is_enable_quest_fact    = Game.GetQuestsSystem():GetFact("sq017_enable_kerry_usc_radio_songs") |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:195` | local isPossessed = Game.GetQuestsSystem():GetFactStr(Game.GetPlayerSystem():GetPossessedByJohnnyFac |
| Cyberpunk Glitch FPS-28256-v6-0-1776762686 | `Cyberpunk Glitch FPS/bin/x64/plugins/cyber_engine_tweaks/mods/GlitchFPS/Glitch.lua:1421` | qs = GameInstance.GetQuestsSystem(game) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:260` | return Game.GetQuestsSystem():GetFactStr(sessionKeyFactName) |
| DebugViewToggle-v1.1-21927-1-1-1749148558 | `bin/x64/plugins/cyber_engine_tweaks/mods/debugviewtoggle/init.lua:102` | elseif type(QuestsSystem.ExecuteNode) ~= 'function' then |

*181 more mods use this pattern.*

## Custom Quest Content

Creating custom quest entries, journal entries, and quest-related interactions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:152` | local JM = Game.GetJournalManager(); |
| Batch Console Command Executor-18427-1-4-1758931128 | `bin/x64/plugins/cyber_engine_tweaks/mods/Batch Console Command Executor/init.lua:379` | ObserveAfter("JournalManager", "OnQuestEntryTracked", function(this, entry) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:4246` | ["helperTitle"] = "Quest : Change Journal entry to state", |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/logic/sms.lua:112` | Observe('JournalNotificationQueue', 'OnMenuUpdate', function(self) |
| CyberTrials-16094-2-31-1761092030 | `bin/x64/plugins/cyber_engine_tweaks/mods/CyberTrials/init.lua:135` | if Game.GetJournalManager() and not Game.GetJournalManager():GetTrackedEntry() and raceLogic.tracked |
| Cyberpunk Story Quest Fixes | `bin/x64/plugins/cyber_engine_tweaks/mods/anygoodname_cp77_story_quest_fixes/init.lua:126` | local journalManager, questsSystem, transactionSystem, delaySystem, vehicleSystem |
| Jackie's Garage-20780-1-0-1743866245 | `bin/x64/plugins/cyber_engine_tweaks/mods/JackiesGarage/modules/utils/worldInteraction.lua` | local questName = Game.GetJournalManager():GetParentEntry(Game.GetJournalManager():GetParentEntry(Ga |
| davidsapogee-16784-v2-25-3-1741706742 | `bin/x64/plugins/cyber_engine_tweaks/mods/DavidsApogee/init.lua:1472` | -- This is to trigger: JournalNotificationQueue/OnMenuUpdate |

*66 more mods use this pattern.*


## Related Concepts

- [Blackboard System](..//systems/blackboard.md) — related manipulation pattern
- [Mappins](..//world/mappins.md) — related manipulation pattern
