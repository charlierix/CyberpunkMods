---
type: Mechanic Pattern
title: Cyberscript Framework
description: Cyberscript framework for scripted quest creation, scene building, NPC management, and trigger-based storytelling in Cyberpunk 2077 mods.
tags: [lua, cet, cyberscript, framework, quests, scenes, triggers, npc, storytelling]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Cyberscript is a comprehensive CET-based modding framework that provides high-level APIs for creating scripted quests, managing NPCs, building scenes, and defining trigger-based interactions. It abstracts low-level game API calls into a modular system of Lua modules that other mods can build upon.

**Framework architecture:**

```lua
-- Cyberscript module access
cyberscript = require("cyberscript")

-- Quest/scene creation via cyberscript API
local quest = cyberscript.api.CreateQuest("my_custom_quest")
quest:AddTrigger({
    type = "proximity",
    position = Vector4.new(0, 0, 0, 1),
    radius = 5.0,
    callback = function(player) 
        -- Trigger fired
    end
})
```

Key characteristics:
- Modular architecture: `modules/` directory contains api, core, db, gang, housing, inventory, loader, location, modpack, npc, var, av, see modules
- Data-driven design: `data/` directory contains actiontemplate, entities, entitieshash, workspot, factdump, triggertemplate data files
- External dependencies: vendored libraries for GameSession, GameUI, cpstyling, json, UIButton, UIScroller, Vector2
- Entity database: massive entity lookup tables (`entities.lua`, `entitieshash.lua` at 54K+ lines each) for game object resolution
- Workspot system: 126K+ line `workspot.lua` defining animation and scene workspot data
- AMM compatibility: dedicated `zzzzzz_cyberscript_amm_compatibility/` module for cross-framework support
- Trigger system: `triggertemplate.lua` defines reusable trigger patterns for quest scripting

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/init.lua` (L106) | Main initialization entry point for cyberscript framework |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/api.lua` | Core API module exposing quest/scene/trigger creation functions |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/core.lua` (L770) | Core module with framework initialization and AMM references |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/gang.lua` (L655) | Gang management module for NPC group definitions |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/housing.lua` (L847) | Housing module for apartment/interior management |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/npc.lua` (L3851) | NPC management module (3800+ lines) for entity spawning and control |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/triggertemplate.lua` (L936) | Reusable trigger templates for quest scripting |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/workspot.lua` (L126607) | Massive workspot database (126K+ lines) for animation/scene definitions |
| Appearance Menu Mod | `mods/lua, arch/Appearance Menu Mod-790-2-12-5-1749642728/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/update_notes.lua` (L2216) | Cyberscript references in AMM update notes for compatibility tracking |

*31 more mods use this pattern*

## Related Concepts

- [Appearance Menu Mod](appearance-menu-mod.md) — Cyberscript provides AMM compatibility via dedicated shim module
- [OOP Patterns](../lua-utils/oop-patterns.md) — Cyberscript modules use setmetatable-based OOP internally
- [Error Handling](../lua-utils/error-handling.md) — Cyberscript's JSON parser uses pcall for safe parsing
- [TweakXL](tweakxl.md) — Some cyberscript mods reference TweakXL for TweakDB modifications
