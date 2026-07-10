---
type: "Class System"
title: "Items System"
description: "Items system: base item action, berserk, consume, crack, disassemble, drop, equip, generic use, item actions helper, read, corrupted sandevistan, heal charge, sandevistan, anti-radar, attack, combat gadgets (helper, frag grenade, Kurt throwable knife, claymore mine, nanowire grenade, piercing grenade), cyberware mute arm, drill machine, health consumable, inspectable item, item, melee katana, throwable weapon, virtual item, and weapon."
resource: "!cyberpunk/items/actions/baseItemAction.swift"
tags: ['cyberpunk', 'items']
timestamp: 2026-07-01T13:00:55Z
---

# Items System

Items system: base item action, berserk, consume, crack, disassemble, drop, equip, generic use, item actions helper, read, corrupted sandevistan, heal charge, sandevistan, anti-radar, attack, combat gadgets (helper, frag grenade, Kurt throwable knife, claymore mine, nanowire grenade, piercing grenade), cyberware mute arm, drill machine, health consumable, inspectable item, item, melee katana, throwable weapon, virtual item, and weapon.

## Source Files

- `cyberpunk/items/actions/baseItemAction.swift`
- `cyberpunk/items/actions/berserkAction.swift`
- `cyberpunk/items/actions/consumeAction.swift`
- `cyberpunk/items/actions/crackAction.swift`
- `cyberpunk/items/actions/disassembleAction.swift`
- `cyberpunk/items/actions/dropAction.swift`
- `cyberpunk/items/actions/equipAction.swift`
- `cyberpunk/items/actions/genericUseAction.swift`
- `cyberpunk/items/actions/itemActionsHelper.swift`
- `cyberpunk/items/actions/readAction.swift`
- `cyberpunk/items/actions/useCorruptedSandevistanAction.swift`
- `cyberpunk/items/actions/useHealCharge.swift`
- `cyberpunk/items/actions/useSandevistanAction.swift`
- `cyberpunk/items/antiRadar.swift`
- `cyberpunk/items/attack.swift`
- `cyberpunk/items/combat_gadgets/combatGadgetHelper.swift`
- `cyberpunk/items/combat_gadgets/fragGrenade.swift`
- `cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift`
- `cyberpunk/items/combat_gadgets/mines/claymoreMine.swift`
- `cyberpunk/items/combat_gadgets/nanowireGrenade.swift`
- `cyberpunk/items/combat_gadgets/piercingGrenade.swift`
- `cyberpunk/items/cyberware/muteArm.swift`
- `cyberpunk/items/drill_machine/drillMachine.swift`
- `cyberpunk/items/drill_machine/drillMachineComponents.swift`
- `cyberpunk/items/healthConsumable.swift`
- `cyberpunk/items/inspectableItem.swift`
- `cyberpunk/items/item.swift`
- `cyberpunk/items/melee/katana.swift`
- `cyberpunk/items/throwableWeapon.swift`
- `cyberpunk/items/virtualItem.swift`
- `cyberpunk/items/weapon.swift`

## Member Types

**Total declarations: 86**

### Classs (55)

| Name | Bases | Source File |
|------|-------|-------------|
| BaseItemAction | BaseScriptableAction | cyberpunk/items/actions/baseItemAction.swift |
| UseBerserkAction | UseAction | cyberpunk/items/actions/berserkAction.swift |
| DisableBerserkAction | UseAction | cyberpunk/items/actions/berserkAction.swift |
| ConsumeAction | BaseItemAction | cyberpunk/items/actions/consumeAction.swift |
| CrackAction | BaseItemAction | cyberpunk/items/actions/crackAction.swift |
| DisassembleAction | BaseItemAction | cyberpunk/items/actions/disassembleAction.swift |
| DropAction | BaseItemAction | cyberpunk/items/actions/dropAction.swift |
| EquipAction | BaseItemAction | cyberpunk/items/actions/equipAction.swift |
| UseAction | BaseItemAction | cyberpunk/items/actions/genericUseAction.swift |
| ItemActionsHelper | IScriptable | cyberpunk/items/actions/itemActionsHelper.swift |
| ReadAction | BaseItemAction | cyberpunk/items/actions/readAction.swift |
| UseCorruptedSandevistanAction | UseAction | cyberpunk/items/actions/useCorruptedSandevistanAction.swift |
| DisableCorruptedSandevistanAction | UseAction | cyberpunk/items/actions/useCorruptedSandevistanAction.swift |
| UseHealChargeAction | BaseItemAction | cyberpunk/items/actions/useHealCharge.swift |
| UseSandevistanAction | UseAction | cyberpunk/items/actions/useSandevistanAction.swift |
| DisableSandevistanAction | UseAction | cyberpunk/items/actions/useSandevistanAction.swift |
| AntiRadar | WeaponObject | cyberpunk/items/antiRadar.swift |
| gameAttackComputed | IScriptable | cyberpunk/items/attack.swift |
| Attack_Continuous | Attack_GameEffect | cyberpunk/items/attack.swift |
| Attack_Beam | Attack_Continuous | cyberpunk/items/attack.swift |
| LaserSight | Attack_Beam | cyberpunk/items/attack.swift |
| RoyceLaserSight | Attack_Beam | cyberpunk/items/attack.swift |
| Bombus_Flame_Beam | Attack_Continuous | cyberpunk/items/attack.swift |
| CombatGadgetHelper | IScriptable | cyberpunk/items/combat_gadgets/combatGadgetHelper.swift |
| WeaponGrenade | ItemObject | cyberpunk/items/combat_gadgets/fragGrenade.swift |
| BaseGrenade | WeaponGrenade | cyberpunk/items/combat_gadgets/fragGrenade.swift |
| ConsumablesChargesHelper | IScriptable | cyberpunk/items/combat_gadgets/fragGrenade.swift |
| GrenadeCollisionEvaluator | gameprojectileScriptCollisionEvaluator | cyberpunk/items/combat_gadgets/fragGrenade.swift |
| ThrowableKnifeNPC | BaseProjectile | cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift |
| KurtTakedownKnifeLanded | AIbehaviorconditionScript | cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift |
| KurtMeleeTakedownCooldownActive | AIbehaviorconditionScript | cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift |
| ForceKurtStatusEffect | AIbehaviortaskScript | cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift |
| ForcePlayerLookat_Kurt | AIbehaviortaskScript | cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift |
| ClaymoreMine | WeaponObject | cyberpunk/items/combat_gadgets/mines/claymoreMine.swift |
| nanowireGrenade | BaseProjectile | cyberpunk/items/combat_gadgets/nanowireGrenade.swift |
| EffectExecutor_NanowireGrenadePull | EffectExecutor_Scripted | cyberpunk/items/combat_gadgets/nanowireGrenade.swift |
| piercingGrenade | BaseProjectile | cyberpunk/items/combat_gadgets/piercingGrenade.swift |
| MuteArm | WeaponObject | cyberpunk/items/cyberware/muteArm.swift |
| drillMachine | WeaponObject | cyberpunk/items/drill_machine/drillMachine.swift |
| DrillMachineScanManager | ScriptableComponent | cyberpunk/items/drill_machine/drillMachineComponents.swift |
| RewireComponent | ScriptableComponent | cyberpunk/items/drill_machine/drillMachineComponents.swift |
| HealthConsumable | gameCpoPickableItem | cyberpunk/items/healthConsumable.swift |
| InspectDummy | GameObject | cyberpunk/items/inspectableItem.swift |
| InspectableItemObject | ItemObject | cyberpunk/items/inspectableItem.swift |
| ItemObject | TimeDilatable | cyberpunk/items/item.swift |
| Katana | WeaponObject | cyberpunk/items/melee/katana.swift |
| gameEffectExecutor_KatanaBulletBending | EffectExecutor_Scripted | cyberpunk/items/melee/katana.swift |
| ThrowableWeaponObject | WeaponObject | cyberpunk/items/throwableWeapon.swift |
| WeaponCollisionEvaluator | gameprojectileScriptCollisionEvaluator | cyberpunk/items/throwableWeapon.swift |
| VirtualItem_TEMP | GameObject | cyberpunk/items/virtualItem.swift |
| WeaponObject | ItemObject | cyberpunk/items/weapon.swift |
| AIWeapon | IScriptable | cyberpunk/items/weapon.swift |
| OverheatStatListener | ScriptStatPoolsListener | cyberpunk/items/weapon.swift |
| DamageStatListener | ScriptStatsListener | cyberpunk/items/weapon.swift |
| WeaponChargeStatListener | CustomValueStatPoolsListener | cyberpunk/items/weapon.swift |

### Static Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| PreloadGameEffectAttackResources |  | cyberpunk/items/attack.swift |
| ReleaseGameEffectAttackResources |  | cyberpunk/items/attack.swift |

### Funcs (29)

| Name | Bases | Source File |
|------|-------|-------------|
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| IsVisible |  | cyberpunk/items/actions/consumeAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| IsVisible |  | cyberpunk/items/actions/consumeAction.swift |
| IsPossible |  | cyberpunk/items/actions/genericUseAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| IsVisible |  | cyberpunk/items/actions/consumeAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| CompleteAction |  | cyberpunk/items/actions/consumeAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| StartAction |  | cyberpunk/items/actions/berserkAction.swift |
| OnTick |  | cyberpunk/items/attack.swift |
| OnStop |  | cyberpunk/items/attack.swift |
| OnTick |  | cyberpunk/items/attack.swift |
| OnTick |  | cyberpunk/items/attack.swift |
| OnStop |  | cyberpunk/items/attack.swift |
| OnTick |  | cyberpunk/items/attack.swift |
| OnStop |  | cyberpunk/items/attack.swift |
| OnTick |  | cyberpunk/items/attack.swift |
| OnStatPoolValueChanged |  | cyberpunk/items/weapon.swift |
| OnStatChanged |  | cyberpunk/items/weapon.swift |
| OnStatPoolValueChanged |  | cyberpunk/items/weapon.swift |

## Citations

- `cyberpunk/items/actions/baseItemAction.swift`
- `cyberpunk/items/actions/berserkAction.swift`
- `cyberpunk/items/actions/consumeAction.swift`
- `cyberpunk/items/actions/crackAction.swift`
- `cyberpunk/items/actions/disassembleAction.swift`
- `cyberpunk/items/actions/dropAction.swift`
- `cyberpunk/items/actions/equipAction.swift`
- `cyberpunk/items/actions/genericUseAction.swift`
- `cyberpunk/items/actions/itemActionsHelper.swift`
- `cyberpunk/items/actions/readAction.swift`
- `cyberpunk/items/actions/useCorruptedSandevistanAction.swift`
- `cyberpunk/items/actions/useHealCharge.swift`
- `cyberpunk/items/actions/useSandevistanAction.swift`
- `cyberpunk/items/antiRadar.swift`
- `cyberpunk/items/attack.swift`
- `cyberpunk/items/combat_gadgets/combatGadgetHelper.swift`
- `cyberpunk/items/combat_gadgets/fragGrenade.swift`
- `cyberpunk/items/combat_gadgets/kurtThrowableKnife.swift`
- `cyberpunk/items/combat_gadgets/mines/claymoreMine.swift`
- `cyberpunk/items/combat_gadgets/nanowireGrenade.swift`
- `cyberpunk/items/combat_gadgets/piercingGrenade.swift`
- `cyberpunk/items/cyberware/muteArm.swift`
- `cyberpunk/items/drill_machine/drillMachine.swift`
- `cyberpunk/items/drill_machine/drillMachineComponents.swift`
- `cyberpunk/items/healthConsumable.swift`
- `cyberpunk/items/inspectableItem.swift`
- `cyberpunk/items/item.swift`
- `cyberpunk/items/melee/katana.swift`
- `cyberpunk/items/throwableWeapon.swift`
- `cyberpunk/items/virtualItem.swift`
- `cyberpunk/items/weapon.swift`
