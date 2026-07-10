---
type: "Class System"
title: "Weapon Prerequisites"
description: "Weapon-based prerequisites for ammo state, reload from empty, first reload state, and weapon shoot."
resource: "!core/gameplay/prereqs/weapon/ammoStatePrereq.swift"
tags: ['core', 'gameplay', 'prereqs', 'weapon']
timestamp: 2026-07-01T13:00:55Z
---

# Weapon Prerequisites

Weapon-based prerequisites for ammo state, reload from empty, first reload state, and weapon shoot.

## Source Files

- `core/gameplay/prereqs/weapon/ammoStatePrereq.swift`
- `core/gameplay/prereqs/weapon/reloadFromEmptyPrereq.swift`
- `core/gameplay/prereqs/weapon/weaponFirstReloadStatePrereq.swift`
- `core/gameplay/prereqs/weapon/weaponShootPrereq.swift`

## Member Types

**Total declarations: 12**

### Classs (10)

| Name | Bases | Source File |
|------|-------|-------------|
| AmmoStateHitTriggeredPrereqState | GenericHitPrereqState | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |
| AmmoStateHitTriggeredPrereq | HitTriggeredPrereq | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |
| AmmoStateHitCallback | HitCallback | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |
| AmmoStateHitTriggeredCallback | AmmoStateHitCallback | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |
| ReloadFromEmptyPrereqState | PrereqState | core/gameplay/prereqs/weapon/reloadFromEmptyPrereq.swift |
| ReloadFromEmptyPrereq | IScriptablePrereq | core/gameplay/prereqs/weapon/reloadFromEmptyPrereq.swift |
| WeaponFirstReloadStatePrereqState | PrereqState | core/gameplay/prereqs/weapon/weaponFirstReloadStatePrereq.swift |
| WeaponFirstReloadStatePrereq | IScriptablePrereq | core/gameplay/prereqs/weapon/weaponFirstReloadStatePrereq.swift |
| WeaponShootPrereqState | PrereqState | core/gameplay/prereqs/weapon/weaponShootPrereq.swift |
| WeaponShootPrereq | IScriptablePrereq | core/gameplay/prereqs/weapon/weaponShootPrereq.swift |

### Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| Evaluate |  | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |
| RegisterState |  | core/gameplay/prereqs/weapon/ammoStatePrereq.swift |

## Citations

- `core/gameplay/prereqs/weapon/ammoStatePrereq.swift`
- `core/gameplay/prereqs/weapon/reloadFromEmptyPrereq.swift`
- `core/gameplay/prereqs/weapon/weaponFirstReloadStatePrereq.swift`
- `core/gameplay/prereqs/weapon/weaponShootPrereq.swift`
