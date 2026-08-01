# Device Hacks Research

## Problem Statement

Tester3 used a static list of 5 device status effects for ALL device types:

| # | Name | Record ID |
|---|------|-----------|
| 1 | Distraction Duration | `BaseStatusEffect.DistractionDuration` |
| 2 | EMP | `BaseStatusEffect.EMP` |
| 3 | Base EMP | `BaseStatusEffect.BaseEMP` |
| 4 | Overload EMP | `BaseStatusEffect.OverloadEMP` |
| 5 | Base Overload | `BaseStatusEffect.BaseOverload` |

All returned API SUCCESS but **nothing visibly happened** on any device (vending machines, fuel bottles, explosive devices, cleaning machines, forklifts, reflectors, traps, access points). The user observed that the list did not match actual cyberdeck options — e.g., crate stacks have a "break chain" hack, flood lights have "initiate overload," but none of those appeared in the tester list.

## Root Cause: Wrong Record Type + Static List

### Problem 1: Base Status Effects Instead of Quickhack Attack Records

The tester applied **base status effect** IDs (`BaseStatusEffect.*`), which only contain visual/behavioral modules. Device hacks require the **quickhack attack** records (`Attacks.QuickHack.*`), which trigger the full interaction pipeline including the device-specific behavior.

| What Tester Used | What Should Be Used |
|------------------|---------------------|
| `BaseStatusEffect.DistractionDuration` | `Attacks.QuickHack.Distraction` |
| `BaseStatusEffect.EMP` | `Attacks.QuickHack.Overload` or device-specific attack record |
| `BaseStatusEffect.OverloadEMP` | `Attacks.QuickHack.Overload` |

### Problem 2: Static List Instead of Per-Device Dynamic List

The tester used the **same 5 effects for every device type**. In Cyberpunk 2077, the available device hacks are **determined dynamically** by three factors:

1. **Device type** — Each device class (AccessPoint, ExplosiveDevice, CleaningMachine, Reflector, etc.) has specific quickhack interactions defined in its TweakDB record.
2. **Player cyberdeck** — The cyberdeck (cyberware operating system) determines which quickhack programs are installed and available.
3. **Intelligence attribute** — Higher intelligence unlocks additional device hacks (e.g., car hacks at Intelligence >= 2, more device interactions at higher levels).

A vending machine and a flood light have **different** available hacks. The tester static list could not account for this.

## Cyberware Operating System (Cyberdeck)

### What It Is

The **cyberdeck** is the **cyberware operating system** installed in the player head. It is the hardware that enables quickhacking. Different cyberdecks provide:

- Different numbers of **quickhack slots** (determines how many quickhack programs can be equipped)
- Different **base RAM** costs
- Special bonuses (e.g., increased damage for specific hack types, reduced cooldowns)

### Standard Quickhack List

These are the quickhack programs that can be installed in cyberdeck slots:

| Quickhack | Target Type | Description |
|-----------|-------------|-------------|
| **Distract** | NPC + Device | Creates a distraction (sound/alert). Works on devices to make them create noise. |
| **Overload** | Device | Overloads a device, causing it to malfunction or explode. Used on flood lights, explosive devices, etc. |
| **Overheat** | NPC + Device | Overheats a target. On NPCs: burning damage. On devices: can cause malfunction. |
| **Ping** | NPC + Device | Reveals target on mini-map and highlights connected entities. |
| **Contagion** | NPC | Applies poison damage (chemical DOT). NPC-only. |
| **Short Circuit** | NPC | Applies EMP damage. NPC-only. |
| **Whistle** | NPC | Draws NPC attention to a location. NPC-only. |
| **Reboot Optics** | NPC | Blinds the NPC ("cyberpsychosis" visual). NPC-only. |
| **Cyber Psychosis** | NPC | Causes NPC to attack allies. NPC-only. |
| **Suicide** | NPC | Instantly kills the NPC. NPC-only. |
| **Car Hacks** | Vehicle | Various vehicle hacks (remote control, self-destruct, etc.). Requires Intelligence >= 2. |

### Intelligence Gating

| Intelligence Level | Unlocks |
|-------------------|---------|
| >= 2 | Car hacks (remote door, summon, force brake, self-destruct) |
| >= 5 | Additional device hacks and advanced quickhack variants |

Higher intelligence also increases RAM capacity and reduces quickhack costs, making more hacks available in practice.

## Device-Specific Quickhack Records

### Quickhack Attack Records for Devices

| Quickhack | TweakDB Path | Description |
|-----------|-------------|-------------|
| Distract | `Attacks.QuickHack.Distraction` | Makes the device create a distraction (sound/alert). |
| Overload | `Attacks.QuickHack.Overload` | Overloads the device — malfunction or explosion. |
| Overheat | `Attacks.QuickHack.Overheat` | Overheats the device — malfunction or explosion. |
| Ping | `Attacks.QuickHack.Ping` | Pings the device, revealing it and connected entities. |

### Device-Specific Interactions

Different device types support different subsets of the above hacks. Examples observed by the user:

| Device | Available Hacks (observed in-game) |
|--------|-----------------------------------|
| Crate stack | Break chain (Overload variant) |
| Flood light | Initiate overload (Overload) |
| Vending machine | Distract (creates noise) |
| Access point | Breach/Quickhack interface (Ping, data mining) |
| Explosive device | Overload (detonate) |
| Car (hackable) | Remote control, self-destruct, force brake (Int >= 2) |

### How to Get the Correct Device Hack List

The correct approach is to **query the QuickhackSystem** for available hacks for a specific target entity, rather than using a hardcoded static list:

```lua
-- Get the quickhack system
local quickhackSystem = Game.GetQuickhackSystem()

-- Get available quickhacks for a specific device entity
local availableHacks = quickhackSystem:GetAvailableQuickhacksForTarget(target)

-- This returns the dynamically determined list based on:
-- 1. The device type/TweakDB record
-- 2. The player cyberdeck and installed quickhack programs
-- 3. The player intelligence level
```

Alternatively, query the device TweakDB record directly for its quickhack interaction modules.

## Why Tester3 Device Hacks Produced No Visible Effect

1. **Wrong record type**: Applied `BaseStatusEffect.*` (visual only) instead of `Attacks.QuickHack.*` (device interaction). The base status effects do not contain the device interaction modules.

2. **Static list**: The same 5 effects were applied to all device types. A vending machine does not support Overload, and a flood light does not support DistractionDuration. The list did not match what each device actually supports.

3. **No cyberdeck/intelligence check**: The tester did not check whether the player cyberdeck had the relevant quickhack programs installed, or whether intelligence requirements were met.

4. **API returned SUCCESS but nothing happened**: `StatusEffectHelper.ApplyStatusEffect` returned SUCCESS because the status effect was technically applied to the entity. But since the base status effect record does not contain device interaction modules, the device did not respond.

## Recommendations for Tester 4 (Device Path)

1. **Use `QuickhackSystem:GetAvailableQuickhacksForTarget(target)`** to dynamically get the correct hack list per device type.
2. **Use `Attacks.QuickHack.*` records** instead of `BaseStatusEffect.*` records.
3. **Or use `QuickhackSystem:ExecuteQuickhack(target)`** to trigger the full quickhack pipeline (which handles device interaction correctly).
4. **Check the device TweakDB record** for its quickhack interaction modules to understand what hacks each device type supports.
5. **Account for intelligence gating** — some device hacks require Intelligence >= 2 or higher.
6. **Account for cyberdeck** — the player cyberdeck determines which quickhack programs are installed and available.

## Sources

- okf knowledge base: `okf/api/devices/device_interaction.md`
- okf knowledge base: `okf/api/devices/device_quickhack_modules.md`
- okf knowledge base: `okf/api/game-systems/quickhack_system.md`
- okf knowledge base: `okf/api/tweakdb-records/quickhack_records.md`
- okf knowledge base: `okf/api/tweakdb-records/device_quickhack_records.md`
- Web search: cyberpunk.fandom.com/wiki/Cyberdeck
- Test results: `testers/quickhack/statuseffect_tester3/TEST RESULTS.md`
- Prior analysis: `testers/quickhack/QUICKHACK_PREREQUISITES_ANALYSIS.md`
