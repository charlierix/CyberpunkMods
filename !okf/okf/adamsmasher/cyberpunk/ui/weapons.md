---
type: "UI System"
title: "Weapon UI"
description: "Weapon UI: crosshairs (base, container, persistent dot, tech, basic, blackwall, driver combat missile, driver combat power, launcher, mantis blade, melee, no weapon, rasetsu, simple, smart rifle, tech hex, tech round, charge bar, hercules, HMG, health change listener, ironsight, kill marker, power defender, melee hammer/knife/misc, nano wire, tech omaha, power overture, power tactician, power saratoga), crouch indicator, melee leap attack tagger, rifles, shotguns, weapon indicator, and weapon roster."
resource: "!cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift"
tags: ['cyberpunk', 'ui', 'weapons']
timestamp: 2026-07-01T13:00:55Z
---

# Weapon UI

Weapon UI: crosshairs (base, container, persistent dot, tech, basic, blackwall, driver combat missile, driver combat power, launcher, mantis blade, melee, no weapon, rasetsu, simple, smart rifle, tech hex, tech round, charge bar, hercules, HMG, health change listener, ironsight, kill marker, power defender, melee hammer/knife/misc, nano wire, tech omaha, power overture, power tactician, power saratoga), crouch indicator, melee leap attack tagger, rifles, shotguns, weapon indicator, and weapon roster.

## Source Files

- `cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairContainerController.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairControllerPersistentDot.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Basic.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Blackwall.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_MissileLauncher.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_PowerWeapon.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Launcher.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Mantis_Blade.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Melee.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_NoWeapon.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Rasetsu.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Simple.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Hex.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Round.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshair_chargebar.swift`
- `cyberpunk/UI/weapons/crosshairs/custom/crosshairController_Hercules.swift`
- `cyberpunk/UI/weapons/crosshairs/custom/militech/crosshair_custom_hmg.swift`
- `cyberpunk/UI/weapons/crosshairs/detail/crosshairHealthChangeListener.swift`
- `cyberpunk/UI/weapons/crosshairs/ironsight.swift`
- `cyberpunk/UI/weapons/crosshairs/kill_marker.swift`
- `cyberpunk/UI/weapons/crosshairs/lmgs/con_arms/crosshair_power_defender.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_hammer.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_knife.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_misc.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_nano_wire.swift`
- `cyberpunk/UI/weapons/crosshairs/meleeLeapAttackObjectTagger.swift`
- `cyberpunk/UI/weapons/crosshairs/pistols/militech/crosshair_tech_omaha.swift`
- `cyberpunk/UI/weapons/crosshairs/revolvers/malorian/crosshair_power_overture.swift`
- `cyberpunk/UI/weapons/crosshairs/shotguns/con_arms/crosshair_power_tactian.swift`
- `cyberpunk/UI/weapons/crosshairs/submachineguns/militech/crosshair_power_saratoga.swift`
- `cyberpunk/UI/weapons/crouchIndicator.swift`
- `cyberpunk/UI/weapons/rifles/megatronControllers.swift`
- `cyberpunk/UI/weapons/shotguns/blunderbussWeaponController.swift`
- `cyberpunk/UI/weapons/weaponIndicatorController.swift`
- `cyberpunk/UI/weapons/weaponRoster.swift`

## Member Types

**Total declarations: 137**

### Classs (66)

| Name | Bases | Source File |
|------|-------|-------------|
| gameuiCrosshairBaseGameController | inkGameController | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| gameuiCrosshairBaseMelee | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| CrosshairStaminaListener | CustomValueStatPoolsListener | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OpticalCamoListener | ScriptStatusEffectListener | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| gameuiCrosshairContainerController | inkHUDGameController | cyberpunk/UI/weapons/crosshairs/crosshairContainerController.swift |
| PersistentDotSettingsListener | ConfigVarListener | cyberpunk/UI/weapons/crosshairs/crosshairControllerPersistentDot.swift |
| CrosshairGameControllerPersistentDot | inkHUDGameController | cyberpunk/UI/weapons/crosshairs/crosshairControllerPersistentDot.swift |
| CrosshairWeaponStatsListener | ScriptStatsListener | cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift |
| BaseTechCrosshairController | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift |
| CrosshairGameController_Basic | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Basic.swift |
| CrosshairGameController_BlackwallForce | CrosshairGameController_Smart_Rifl | cyberpunk/UI/weapons/crosshairs/crosshairController_Blackwall.swift |
| gameuiDriverCombatMountedMissileLauncherCrosshairGameController | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_MissileLauncher.swift |
| gameuiDriverCombatMountedPowerWeaponCrosshairGameController | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_PowerWeapon.swift |
| CrosshairGameController_Launcher | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Launcher.swift |
| CrosshairGameController_Mantis_Blade | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Mantis_Blade.swift |
| CrosshairGameController_Melee | gameuiCrosshairBaseMelee | cyberpunk/UI/weapons/crosshairs/crosshairController_Melee.swift |
| MeleeResourcePoolListener | ScriptStatPoolsListener | cyberpunk/UI/weapons/crosshairs/crosshairController_Melee.swift |
| CrosshairGameController_NoWeapon | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_NoWeapon.swift |
| CrosshairLogicController_RasetsuHipFire | inkLogicController | cyberpunk/UI/weapons/crosshairs/crosshairController_Rasetsu.swift |
| CrosshairLogicController_RasetsuAimFire | inkLogicController | cyberpunk/UI/weapons/crosshairs/crosshairController_Rasetsu.swift |
| CrosshairGameController_Rasetsu | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Rasetsu.swift |
| CrosshairGameController_Simple | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Simple.swift |
| CrosshairGameController_Smart_Rifl | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift |
| DelayedSmartGunUISoundClue | DelayCallback | cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift |
| Crosshair_Smart_Rifl_Bucket | inkLogicController | cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift |
| CrosshairGameController_Tech_Hex | BaseTechCrosshairController | cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Hex.swift |
| CrosshairGameController_Tech_Round | BaseTechCrosshairController | cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Round.swift |
| Crosshair_ChargeBar | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/crosshair_chargebar.swift |
| HerculesCrosshairtGameController | IronsightGameController | cyberpunk/UI/weapons/crosshairs/custom/crosshairController_Hercules.swift |
| Crosshair_Custom_HMG | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/custom/militech/crosshair_custom_hmg.swift |
| CrosshairHealthChangeListener | CustomValueStatPoolsListener | cyberpunk/UI/weapons/crosshairs/detail/crosshairHealthChangeListener.swift |
| IronsightDetail | IScriptable | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| ChargebarStatsListener | ScriptStatsListener | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| ChargebarController | inkLogicController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| AltimeterController | inkLogicController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| AnimationChain | IScriptable | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| AnimationChainPlayer | IScriptable | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| BasicAnimationController | inkLogicController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| TargetAttitudeAnimationController | BasicAnimationController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| AimDownSightController | BasicAnimationController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| CompassController | inkLogicController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| IronsightTargetHealthChangeListener | ScriptStatPoolsListener | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| IronsightGameController | gameuiIronsightGameController | cyberpunk/UI/weapons/crosshairs/ironsight.swift |
| KillMarkerGameController | inkGameController | cyberpunk/UI/weapons/crosshairs/kill_marker.swift |
| Crosshair_Power_Defender | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/lmgs/con_arms/crosshair_power_defender.swift |
| Crosshair_Melee_Hammer | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_hammer.swift |
| Crosshair_Melee_Knife | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_knife.swift |
| ThrowingKnifeResourcePoolListener | ScriptStatPoolsListener | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_knife.swift |
| Crosshair_Melee_Misc | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_misc.swift |
| Crosshair_Melee_Nano_Wire | CrosshairGameController_Melee | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_nano_wire.swift |
| MeleeLeapAttackObjectTagger | IScriptable | cyberpunk/UI/weapons/crosshairs/meleeLeapAttackObjectTagger.swift |
| Crosshair_Tech_Omaha | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/pistols/militech/crosshair_tech_omaha.swift |
| Crosshair_Power_Overture | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/revolvers/malorian/crosshair_power_overture.swift |
| Crosshair_Power_Tactician | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/shotguns/con_arms/crosshair_power_tactian.swift |
| Crosshair_Power_Saratoga | gameuiCrosshairBaseGameController | cyberpunk/UI/weapons/crosshairs/submachineguns/militech/crosshair_power_saratoga.swift |
| CrouchIndicatorGameController | inkHUDGameController | cyberpunk/UI/weapons/crouchIndicator.swift |
| megatronModeInfoController | TriggerModeLogicController | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| megatronFullAutoController | AmmoLogicController | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| megatronChargeController | ChargeLogicController | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| megatronCrosshairGameController | inkGameController | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| blunderbussWeaponController | inkGameController | cyberpunk/UI/weapons/shotguns/blunderbussWeaponController.swift |
| TriggerModeLogicController | inkLogicController | cyberpunk/UI/weapons/weaponIndicatorController.swift |
| AmmoLogicController | inkLogicController | cyberpunk/UI/weapons/weaponIndicatorController.swift |
| ChargeLogicController | inkLogicController | cyberpunk/UI/weapons/weaponIndicatorController.swift |
| weaponIndicatorController | inkHUDGameController | cyberpunk/UI/weapons/weaponIndicatorController.swift |
| WeaponRosterGameController | inkHUDGameController | cyberpunk/UI/weapons/weaponRoster.swift |

### Funcs (71)

| Name | Bases | Source File |
|------|-------|-------------|
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| HandleDeadEye |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatusEffectApplied |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatusEffectRemoved |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnVarModified |  | cyberpunk/UI/weapons/crosshairs/crosshairControllerPersistentDot.swift |
| OnStatChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| SetChargeScale |  | cyberpunk/UI/weapons/crosshairs/crosshairController_Melee.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| HandleDeadEye |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| Call |  | cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| SetReloadBar |  | cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_knife.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnStatPoolValueChanged |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetIntroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| GetOutroAnimation |  | cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift |
| OnTriggerModeChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnMagazineAmmoCountChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnMagazineAmmoCapacityChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnChargeChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnTriggerModeChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnMagazineAmmoCountChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnMagazineAmmoCapacityChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |
| OnChargeChanged |  | cyberpunk/UI/weapons/rifles/megatronControllers.swift |

## Citations

- `cyberpunk/UI/weapons/crosshairs/crosshairBaseControllers.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairContainerController.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairControllerPersistentDot.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_BaseTech.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Basic.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Blackwall.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_MissileLauncher.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_DriverCombat_PowerWeapon.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Launcher.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Mantis_Blade.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Melee.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_NoWeapon.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Rasetsu.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Simple.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Smart_Rifle.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Hex.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshairController_Tech_Round.swift`
- `cyberpunk/UI/weapons/crosshairs/crosshair_chargebar.swift`
- `cyberpunk/UI/weapons/crosshairs/custom/crosshairController_Hercules.swift`
- `cyberpunk/UI/weapons/crosshairs/custom/militech/crosshair_custom_hmg.swift`
- `cyberpunk/UI/weapons/crosshairs/detail/crosshairHealthChangeListener.swift`
- `cyberpunk/UI/weapons/crosshairs/ironsight.swift`
- `cyberpunk/UI/weapons/crosshairs/kill_marker.swift`
- `cyberpunk/UI/weapons/crosshairs/lmgs/con_arms/crosshair_power_defender.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_hammer.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_knife.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_misc.swift`
- `cyberpunk/UI/weapons/crosshairs/melee/crosshair_melee_nano_wire.swift`
- `cyberpunk/UI/weapons/crosshairs/meleeLeapAttackObjectTagger.swift`
- `cyberpunk/UI/weapons/crosshairs/pistols/militech/crosshair_tech_omaha.swift`
- `cyberpunk/UI/weapons/crosshairs/revolvers/malorian/crosshair_power_overture.swift`
- `cyberpunk/UI/weapons/crosshairs/shotguns/con_arms/crosshair_power_tactian.swift`
- `cyberpunk/UI/weapons/crosshairs/submachineguns/militech/crosshair_power_saratoga.swift`
- `cyberpunk/UI/weapons/crouchIndicator.swift`
- `cyberpunk/UI/weapons/rifles/megatronControllers.swift`
- `cyberpunk/UI/weapons/shotguns/blunderbussWeaponController.swift`
- `cyberpunk/UI/weapons/weaponIndicatorController.swift`
- `cyberpunk/UI/weapons/weaponRoster.swift`
