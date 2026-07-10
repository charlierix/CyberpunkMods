---
type: Mechanic Pattern
title: "Damage Calculation Overrides"
description: "Overriding DamageManager, HitData, and damage calculation pipelines"
tags: [combat, damage, calculation]
timestamp: 2026-07-04T00:00:00Z
---

# Damage Calculation Overrides

Overriding DamageManager, HitData, and damage calculation pipelines.

## Approach

This technique involves overriding damagemanager, hitdata, and damage calculation pipelines. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/observers/player.lua` | --if (targetGodMode == gameGodModeType.Invulnerable or hitEvent.attackData:HasFlag(hitFlag.WasBlocke |
| KnockOutChildren_V110.zip-8614-1-1-1701965225 | `bin/x64/plugins/cyber_engine_tweaks/mods/KnockOutChildren/init.lua` | if hitEvent.attackData and hitEvent.attackData.instigator then |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnUtil.lua:340` | function scaleDamage(hitEvent, mult) |
| Random Outfit Destruction (cp2077 v2.3)-22660-1-5-1769976819 | `ROD/bin/x64/plugins/cyber_engine_tweaks/mods/Random Outfit Destruction/init.lua:375` | local state = string.match(tostring(hitEvent.attackData.attackType),"%d+") |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:503` | Observe('DamageSystem', 'ProcessRagdollHit', function(self, hitEvent) |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/module/SpawnUtil.lua:374` | function scaleDamage(hitEvent, mult) |
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/Perks/perk_body.reds` | private final func ProcessLocalizedDamage(hitEvent: ref<gameHitEvent>) -> Void { |
| NDO - Nil's Difficulty Options-25047-1-0-0-1760560434 | `r6/scripts/Nils Difficulty Options/NDO_03_Gameplay.reds:40` | if !NDOSettings.ImmersiveDamage() // !IsDefined(hitEvent) { |

*42 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
