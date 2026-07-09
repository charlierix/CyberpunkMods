---
type: Mechanic Pattern
title: "World State"
description: "World state flags, environment state, and world building manipulation patterns"
tags: [systems, world, state]
timestamp: 2026-07-04T00:00:00Z
---

# World State

World state flags, environment state, and world building manipulation patterns.

## World Flag Manipulation

Toggling world state flags via GetWorldStateSystem to change environment states (doors, areas, events).

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Silver Pixel Cloud Gates Game Bug Patch 1.0.1-23573-1-0-1-1763420496 | `bin/x64/plugins/cyber_engine_tweaks/mods/SilverPixelCinemaGatesGameBugPatch/init.lua` | pcall(function() isExpectedCodewareActive = WorldStateSystem and type(WorldStateSystem.ToggleVariant |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:696` | --Game.GetWorldStateSystem():DeactivateCommunity(CreateNodeRef("#kab_07_com_ground_floor_crowd"), "C |
| Glen - Tidy Your Trash-26011-1-2-0-1773987724 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_Glen/init.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(variant.ref), variant.variant, variant |
| H10 - Tidy Your Trash-25124-2-2-1-1774002106 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_H10/init.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(variant.ref), variant.variant, variant |
| JT - Tidy Your Trash-25536-1-2-0-1773987172 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_JT/init.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(variant.ref), variant.variant, variant |
| Jackie's Garage-20780-1-0-1743866245 | `bin/x64/plugins/cyber_engine_tweaks/mods/JackiesGarage/modules/utils/variantUtils.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(ref), variant, state) |
| NS - Tidy Your Trash-25251-2-2-0-1773987512 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_NS/init.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(variant.ref), variant.variant, variant |
| Gambling-29866-1-1779352615 | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:734` | --Game.GetWorldStateSystem():DeactivateCommunity(CreateNodeRef("#kab_07_com_ground_floor_crowd"), "C |

*15 more mods use this pattern.*

## Environment State Control

Modifying persistent environment states, quest-triggered world changes, and area access controls.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Silver Pixel Cloud Gates Game Bug Patch 1.0.1-23573-1-0-1-1763420496 | `bin/x64/plugins/cyber_engine_tweaks/mods/SilverPixelCinemaGatesGameBugPatch/init.lua` | pcall(function() isExpectedCodewareActive = WorldStateSystem and type(WorldStateSystem.ToggleVariant |
| Gambling System - Roulette | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:696` | --Game.GetWorldStateSystem():DeactivateCommunity(CreateNodeRef("#kab_07_com_ground_floor_crowd"), "C |
| Glen - Tidy Your Trash-26011-1-2-0-1773987724 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_Glen/init.lua` | local function applyWorldState() |
| H10 - Tidy Your Trash-25124-2-2-1-1774002106 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_H10/init.lua` | local function applyWorldState() |
| JT - Tidy Your Trash-25536-1-2-0-1773987172 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_JT/init.lua` | local function applyWorldState() |
| Jackie's Garage-20780-1-0-1743866245 | `bin/x64/plugins/cyber_engine_tweaks/mods/JackiesGarage/modules/utils/variantUtils.lua` | Game.GetWorldStateSystem():TogglePrefabVariant(CreateNodeRef(ref), variant, state) |
| NS - Tidy Your Trash-25251-2-2-0-1773987512 | `bin/x64/plugins/cyber_engine_tweaks/mods/TidyYourTrash_NS/init.lua` | local function applyWorldState() |
| Gambling-29866-1-1779352615 | `bin/x64/plugins/cyber_engine_tweaks/mods/Gambling System - Roulette/init.lua:734` | --Game.GetWorldStateSystem():DeactivateCommunity(CreateNodeRef("#kab_07_com_ground_floor_crowd"), "C |

*16 more mods use this pattern.*


## Related Concepts

- [Blackboard System](..//systems/blackboard.md) — related manipulation pattern
- [Quest System](..//systems/quest-system.md) — related manipulation pattern
