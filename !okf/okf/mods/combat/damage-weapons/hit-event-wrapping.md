---
type: Mechanic Pattern
title: "Hit Event Interception"
description: "Wrapping ReactToHitProcess and hit event methods to intercept damage before it resolves"
tags: [combat, damage, hit-events]
timestamp: 2026-07-04T00:00:00Z
---

# Hit Event Interception

Wrapping ReactToHitProcess and hit event methods to intercept damage before it resolves.

## Approach

This technique involves wrapping reacttohitprocess and hit event methods to intercept damage before it resolves. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:697` | Observe("VehicleObject", "OnDamageReceived", function(this, evt) |
| Merc Protocol - Perk Gameplay Expansion-26751-2-12-1775533259 | `r6/scripts/MercProtocol/Perks/perk_body.reds` | private final func ProcessLocalizedDamage(hitEvent: ref<gameHitEvent>) -> Void { |
| NDO - Nil's Difficulty Options-25047-1-0-0-1760560434 | `r6/scripts/Nils Difficulty Options/NDO_04_UI.reds` | private final func ShouldShowDamage(evt: ref<gameDamageReceivedEvent>) -> Bool { |
| Weapon Conditioning-10479-1-2-1-1776102382 | `r6/scripts/Weapon Conditioning/DegradeManager.reds:213` | } else if !WeaponConfig.isMeleeDegradeOnlyOnHit { |
| Drone Companions (Revamp)-23980-0-5-0-1757655327 | `bin/x64/plugins/cyber_engine_tweaks/mods/Drone Companions (Revamp)/Modules/Techdecks.lua:468` | local damageHitEvent = gameprojectileHitEvent:new() |
| Knuckle Sandwich-30000-1-8-1780525776 | `bin/x64/plugins/cyber_engine_tweaks/mods/KnuckleSandwich/init.lua` | ObserveAfter('NPCPuppet', 'OnHit', OnWeaponHit) |
| MeatAndSteel_ArmorOverhaul-27592-1-1-3-1773266518 | `r6/scripts/meat&steel_armoroverhaul/IncomingDamageHook.reds:22` | protected func DealDamages(hitEvent: ref<gameHitEvent>) -> Void { |
| Night City Allies - Core Mod | `r6/scripts/NightCityAllies/Event/EventBus.reds:86` | public final func OnCompanionDealDamage(npc: ref<NpcHandle>, evt: ref<gameHitEvent>) -> Void { |

*20 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
