# Status Effect Tester 3 — Log Summary

**Source files:** `log.txt` (1119 lines), `test results.md` (34 lines)  
**Session date:** 2026-07-28, 22:25–23:04 (~39 min)  
**Mod:** `statuseffect_tester3` (CET Lua mod)

---

## Mod Initialization

- Loaded alongside 8 other CET mods (entity scanner, GameEntityExaminerTool, ghost_forward, grappling_hook, HeavyMG, hundred_grand, jetpack, low_flying_v, wall_hang)
- **41 NPC status effects** discovered
- **5 device status effects** discovered
- Hotkeys registered: `SE3_TOGGLE_WINDOW`, `SE3_APPLY`
- Usage: look at NPC/device, press APPLY for a random weighted hack

---

## Targets Encountered

| Target | Class | Type | Notes |
|---|---|---|---|
| AccessPoint | AccessPoint | Device | 5 device hacks available |
| ExplosiveDevice | ExplosiveDevice | Device | 5 device hacks available |
| Maelstrom grunt (copperhead) | NPCPuppet | NPC | 41 NPC hacks, 1.82 m |
| Maelstrom grunt (lexington) | NPCPuppet | NPC | 41 NPC hacks, 1.29 m |
| LowlifeMale | NPCPuppet | NPC | 41 NPC hacks, 2.93 m |
| Tyger Claws gangster (knife) | NPCPuppet | NPC | 41 NPC hacks |
| Tyger Claws biker (baseball) | NPCPuppet | NPC | 41 NPC hacks, 10.13 m |
| Police (handgun) | NPCPuppet | NPC | 41 NPC hacks |
| Maelstrom grunt (lexington, far) | NPCPuppet | NPC | 41 NPC hacks, 19.54 m |
| Maelstrom grunt (ajax, far) | NPCPuppet | NPC | 41 NPC hacks, 31.34 m |
| CleaningMachine | CleaningMachine | Device | 5 device hacks |
| Forklift | forklift | Device | 5 device hacks |
| ActivatedDeviceTrapDestruction | ActivatedDeviceTrapDestruction | Device | 5 device hacks |
| Reflector | Reflector | Device | 5 device hacks |
| Vehicle (hackable Villefort) | vehicleCarBaseObject | **Rejected** | Neither NPC nor Device |

---

## Device Hacks (5 total)

| # | Name | Record ID | Attempts |
|---|---|---|---|
| 1 | Distraction Duration | BaseStatusEffect.DistractionDuration | 17 |
| 2 | EMP | BaseStatusEffect.EMP | 16 |
| 3 | Base EMP | BaseStatusEffect.BaseEMP | 17 |
| 4 | Overload EMP | BaseStatusEffect.OverloadEMP | 16 |
| 5 | Base Overload | BaseStatusEffect.BaseOverload | 17 |

**All results: SUCCESS** — every device hack applied returned SUCCESS at the API level.

---

## NPC Hacks (41 total)

| # | Name | Record ID | Attempts |
|---|---|---|---|
| 1 | Overheat | BaseStatusEffect.Overheat | 1 |
| 2 | Burning | BaseStatusEffect.Burning | 1 |
| 3 | Blind | BaseStatusEffect.Blind | 2 |
| 4 | Stun | BaseStatusEffect.Stun | 1 |
| 5 | Ping | BaseStatusEffect.Ping | 3 |
| 6 | Pain | BaseStatusEffect.Pain | 2 |
| 7 | NPCForceStagger | BaseStatusEffect.NPCForceStagger | 2 |
| 8 | LocomotionMalfunction | BaseStatusEffect.LocomotionMalfunction | 2 |
| 9 | CyberwareMalfunction | BaseStatusEffect.CyberwareMalfunction | 3 |
| 10 | CW Malfunction Blackwall | BaseStatusEffect.CyberwareMalfunctionBlackwall | 3 |
| 11 | Madness | BaseStatusEffect.Madness | 3 |
| 12 | BlackwallHackUpload | BaseStatusEffect.SoMi_Q306_BlackwallHackUpload | 2 |
| 13 | Contagion Poison | BaseStatusEffect.ContagionPoison | 0 |
| 14 | Base Contagion Poison | BaseStatusEffect.BaseContagionPoison | 2 |
| 15 | EMP | BaseStatusEffect.EMP | 3 |
| 16 | Base EMP | BaseStatusEffect.BaseEMP | 0 |
| 17 | QuickHack Blind | BaseStatusEffect.QuickHackBlind | 3 |
| 18 | Base QuickHack Blind | BaseStatusEffect.BaseQuickHackBlind | 1 |
| 19 | Poisoned | BaseStatusEffect.Poisoned | 3 |
| 20 | Base BrainMelt | BaseStatusEffect.BaseBrainMelt | 3 |
| 21 | Base CommsNoise | BaseStatusEffect.BaseCommsNoise | 2 |
| 22 | Base Overheat | BaseStatusEffect.BaseOverheat | 2 |
| 23 | Locomotion Lvl2 | BaseStatusEffect.LocomotionMalfunctionLevel2 | 2 |
| 24 | Locomotion Lvl3 | BaseStatusEffect.LocomotionMalfunctionLevel3 | 2 |
| 25 | Locomotion Lvl4 | BaseStatusEffect.LocomotionMalfunctionLevel4 | 0 |
| 26 | CW Malfunction Lvl1 | BaseStatusEffect.CyberwareMalfunctionLvl1 | 1 |
| 27 | CW Malfunction Lvl2 | BaseStatusEffect.CyberwareMalfunctionLvl2 | 2 |
| 28 | CW Malfunction Lvl3 | BaseStatusEffect.CyberwareMalfunctionLvl3 | 2 |
| 29 | CW Malfunction Lvl4 | BaseStatusEffect.CyberwareMalfunctionLvl4 | 1 |
| 30 | Overheat Lvl1 | BaseStatusEffect.OverheatLevel1 | 4 |
| 31 | Overheat Lvl2 | BaseStatusEffect.OverheatLevel2 | 2 |
| 32 | Overheat Lvl3 | BaseStatusEffect.OverheatLevel3 | 2 |
| 33 | Overheat Lvl4 | BaseStatusEffect.OverheatLevel4 | 3 |
| 34 | Ping Lvl2 | BaseStatusEffect.PingLevel2 | 3 |
| 35 | Ping Lvl3 | BaseStatusEffect.PingLevel3 | 4 |
| 36 | Ping Lvl4 | BaseStatusEffect.PingLevel4 | 1 |
| 37 | Moderate Blind | BaseStatusEffect.ModerateBlind | 3 |
| 38 | Major Blind | BaseStatusEffect.MajorBlind | 1 |
| 39 | Minor Blind | BaseStatusEffect.MinorBlind | 3 |
| 40 | Legendary Blind | BaseStatusEffect.LegendaryEffectBlind | 4 |
| 41 | Major QH Blind | BaseStatusEffect.MajorQuickHackBlind | 3 |

**All results: SUCCESS** — every NPC hack applied returned SUCCESS at the API level.

---

## Final Attempt Totals

| Category | Total Attempts |
|---|---|
| NPC effects | 87 |
| Device effects | 83 |
| **Grand total** | **170** |

Three NPC effects (Contagion Poison, Base EMP, Locomotion Lvl4) had 0 attempts — they were never randomly selected.

---

## Observations from `test results.md`

### Device Hacks
- The 5-hack list is **static regardless of device type** (vending machine, fuel bottle, explosive, cleaning machine, forklift, reflector, trap)
- Device hacks **do not match cyberdeck options** — e.g., crate stack usually has "break chain," flood light has "initiate overload," but none of those appear in the tester's list
- **Nothing visibly happened** when device hacks were applied — despite the API returning SUCCESS

### NPC Hacks
- All NPC hacks produced **visual/audio effects** — NPCs react as if they know they're being hacked
- Most hacks had **no observable gameplay effect** beyond the visual/audio cue
- **Exceptions that worked:**
  - **Blackwall** (CyberwareMalfunctionBlackwall / BlackwallHackUpload) — **killed the NPC**
  - **Madness** — NPC got confused and shot their friends
  - **Ping** — appeared to work
  - **Locomotion Malfunction** — appeared to halt the NPC

### Hypotheses
- There may be a **separate damage system** that is not triggered by applying status effects alone — status effects are visual/behavioral modifiers, not damage dealers
- The one Blackwall effect might be an **instant death** with extra effects and animations layered on top
- Mods that **directly modify NPC properties** (rather than just applying status effects) seem to produce visible results
