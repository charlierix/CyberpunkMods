---
type: Mechanic Pattern
title: Appearance Menu Mod (AMM) Framework
description: Integration with the Appearance Menu Mod framework for appearance manipulation, prop spawning, and preset sharing across Cyberpunk 2077 mods.
tags: [lua, cet, amm, appearance-menu-mod, appearance, props, presets, framework]
timestamp: 2026-07-04T00:00:00:00Z
---

## Approach

Appearance Menu Mod (AMM) is one of the most popular Cyberpunk 2077 modding frameworks, providing a CET-based UI for changing player and NPC appearances, spawning props, creating scenes, and sharing presets. Mods integrate with AMM by placing Lua files in the `AppearanceMenuMod/Collabs/` directory or by referencing AMM APIs in their own scripts.

**Integration patterns:**

```lua
-- Custom prop registration for AMM Collabs
local props = {
    { name = "My Custom Prop", path = "my_mod/props/item.ent", category = "Custom" }
}
-- Placed in AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua

-- AMM compatibility module
local amm = require("AppearanceMenuMod")
if amm then
    amm.RegisterAppearance("My Appearance", "my_mod/app/entity.ent")
end
```

Key characteristics:
- Collab/Custom Props files are the most common integration method, allowing mods to register custom props that appear in AMM's prop spawning menu
- Localization files (`Localization/*.lua`) provide translated UI strings for the AMM interface itself
- Cyberscript provides an AMM compatibility layer (`zzzzzz_cyberscript_amm_compatibility/`) for cross-framework support
- Preset packs place prop definitions directly in the AMM Collabs directory structure
- AMM's update notes are tracked in `update_notes.lua` with version history
- The framework is entirely CET/Lua-based; no Redscript component is required for basic prop integration

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| Appearance Creator Mod | `mods/lua/Appearance Creator Mod-10795-1-0-1-1699493978/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua` (L699) | AMM integration for appearance creation and export |
| Appearance FR | `mods/lua/Appearance FR-11713-1-0-1703089504/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/fr_FR.lua` (L747) | French localization for AMM UI strings |
| Appearance Menu Mod - PT-BR | `mods/lua/Appearance Menu Mod - PT-BR-17703-1-2-1753920668/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Localization/pt_BR.lua` (L1023) | Brazilian Portuguese localization for AMM |
| Arasaka Hideout - AMM Preset | `mods/lua/Arasaka Hideout - AMM Preset - v0.2-10346-0-2-1698377567/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua` (L2785) | Custom prop registration for Arasaka Hideout scene preset |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/core.lua` (L770) | AMM API references in cyberscript core module for cross-framework support |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/zzzzzz_cyberscript_amm_compatibility/init.lua` | Dedicated AMM compatibility shim module |
| EnemyMultipier | `mods/lua/EnemyMultipier-27637-1-0-1771338458/bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua` (L1520) | AMM reference for NPC appearance manipulation in spawn logic |
| Judys Cabin Redone | `mods/lua/Judys Cabin Redone-13799-1-0-1711151322/Judys Cabin Redone - AMM Preset/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4.lua` (L2785) | AMM preset prop registration for Judy's Cabin scene |
| Legion THE FIRMWARE | `mods/lua/Legion THE FIRMWARE-27399-1-1a-1771536241/bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/init.lua` (L852) | AMM integration for appearance firmware features |
| The Love Nest 2.0 | `mods/lua/The Love Nest 2.0-13048-2-0-1718743353/Love Nest 2.0 - AMM Preset/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/Collabs/Custom Props/proximas_propshop_v4_clean.lua` (L2151) | AMM preset with cleaned prop definitions for Love Nest scene |

*53 more mods use this pattern*

## Related Concepts

- [Cyberscript](cyberscript.md) — Cyberscript provides an AMM compatibility layer for cross-framework integration
- [Virtual Atelier](virtual-atelier.md) — Alternative store-based framework for item distribution
- [OOP Patterns](../lua-utils/oop-patterns.md) — AMM prop objects use setmetatable-based OOP internally
