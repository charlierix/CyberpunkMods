---
type: Mechanic Pattern
title: AI Behavior Modification
description: Modifying AI behavior classes and AISubAction records to alter NPC AI behavior.
tags: [systems ai behavior npc]
timestamp: 2026-08-03T00:00:00Z
---

# AI Behavior Modification

Modifying AI behavior classes and AISubAction records to alter NPC AI behavior.

## Approach

Mods modify `AISubActionApplyTimeDilation_Record_Implementation` (33 @addMethod instances) and `AIActionsFX.*` TweakDB records to alter AI behavior. This includes custom AI actions, modified time dilation behavior during AI actions, or custom AI effect definitions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Time Dilation Overhaul 4931 2.32 2026-07-28T22-51Z q7jg7fhKQ | `r6/scripts/EnemySandevistanRework/tickSystem.reds` | References AI behavior classes |

## Related Concepts

- [Reaction Manager Overrides](/systems/reaction-manager-overrides.md) — Wrapping ReactionManagerComponent to modify NPC reaction behavior.
- [NPC Puppet Extensions](/systems/npc-puppet-extensions.md) — Adding methods to NPCPuppet via @addMethod to extend NPC behavior and capabilities.
