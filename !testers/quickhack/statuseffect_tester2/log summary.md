# Log Summary — statuseffect_tester2

Generated from `log.txt` (1,802 lines, 190 KB)

## Session Overview

| Field | Value |
|-------|-------|
| Init time | 2026-07-27 00:12:39 UTC-05:00 |
| First action | 00:43:12 (LIST catalog) |
| Shutdown | 00:53:32 |
| Active testing window | ~10 min 20 sec |
| PID (load) | 19396 |
| PID (session) | 12460 |

## Init Fixes Applied (from Tester 1)

1. Target detection: `target.IsNPC(target)` (Blackwall pattern)
2. Real effect IDs: no `QH_` prefix (those were fake, caused silent no-ops)
3. Instigator: passes player as 3rd arg (GameEntityExaminerTool pattern)
4. TweakDB validation: checks record exists before applying
5. Multiple API overloads: tries 5 different call patterns
6. New hotkeys: DUMP (all records), DUMP_QH (quickhack-related), TARGET_INFO (debug)

## Hotkey Usage Tally

| Hotkey | Times Used | Notes |
|--------|-----------|-------|
| SE2_LIST | 6 | Catalog with TweakDB validation |
| SE2_CYCLE (forward) | 11 | Cycled from #1 to #16 |
| SE2_CYCLE_BACK | 0 | Not used |
| SE2_APPLY | 16 | 10s duration, all on crosshair target |
| SE2_APPLY_PERM | 0 | Not used |
| SE2_CHECK | 1 | Checked active effects on Chinese_Food_Woman |
| SE2_REMOVE | 0 | Not used |
| SE2_REMOVE_ALL | 0 | Not used |
| SE2_DUMP | 1 | Full TweakDB dump (1172 records) |
| SE2_DUMP_QH | 1 | Quickhack-related dump (223 records) |
| SE2_TARGET_INFO | 0 | **NOT TESTED** — only mentioned in init message |

## Testing Timeline

| Time | Event | Text |
|------|-------|------|
| 2026-07-27 00:12:39 UTC-05:00 | **INIT** | Status Effect Tester 2 initialized |
| 2026-07-27 00:43:12 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:43:44 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:43:44 UTC-05:00 | **SE2_CHECK** | === Active Status Effects on Character.Chinese_Food_Woman (class=NPCPuppet, entityID=9004551ULL) === |
| 2026-07-27 00:44:01 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:44:01 UTC-05:00 | **SE2_APPLY** | Applying 'Overheat' (BaseStatusEffect.Overheat) duration=10.0 instigator=1ULL |
| 2026-07-27 00:44:23 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:44:32 UTC-05:00 | **SE2_CYCLE** | Selected [2/23]: Burning (BaseStatusEffect.Burning) — TweakDB exists: true |
| 2026-07-27 00:44:33 UTC-05:00 | **SE2_CYCLE** | Selected [3/23]: Blind (Reboot Optics) (BaseStatusEffect.Blind) — TweakDB exists: true |
| 2026-07-27 00:44:38 UTC-05:00 | **SE2_CYCLE** | Selected [4/23]: Stun (BaseStatusEffect.Stun) — TweakDB exists: true |
| 2026-07-27 00:44:47 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:44:47 UTC-05:00 | **SE2_APPLY** | Applying 'Stun' (BaseStatusEffect.Stun) duration=10.0 instigator=1ULL |
| 2026-07-27 00:45:08 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:45:08 UTC-05:00 | **SE2_APPLY** | Applying 'Stun' (BaseStatusEffect.Stun) duration=10.0 instigator=1ULL |
| 2026-07-27 00:45:25 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:45:25 UTC-05:00 | **SE2_APPLY** | Applying 'Stun' (BaseStatusEffect.Stun) duration=10.0 instigator=1ULL |
| 2026-07-27 00:45:37 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:45:37 UTC-05:00 | **SE2_APPLY** | Applying 'Stun' (BaseStatusEffect.Stun) duration=10.0 instigator=1ULL |
| 2026-07-27 00:45:49 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:46:02 UTC-05:00 | **SE2_CYCLE** | Selected [5/23]: Ping (BaseStatusEffect.Ping) — TweakDB exists: true |
| 2026-07-27 00:46:13 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:46:13 UTC-05:00 | **SE2_APPLY** | Applying 'Ping' (BaseStatusEffect.Ping) duration=10.0 instigator=1ULL |
| 2026-07-27 00:46:23 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:46:23 UTC-05:00 | **SE2_APPLY** | Applying 'Ping' (BaseStatusEffect.Ping) duration=10.0 instigator=1ULL |
| 2026-07-27 00:47:53 UTC-05:00 | Target detect | Target: class=Reflector NPC=false Device=true Vehicle=false Active=true |
| 2026-07-27 00:47:53 UTC-05:00 | **SE2_APPLY** |   NOTE: Effect 'Ping' is for npc targets but target is NPC=false Device=true |
| 2026-07-27 00:48:09 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:48:09 UTC-05:00 | **SE2_APPLY** | Applying 'Ping' (BaseStatusEffect.Ping) duration=10.0 instigator=1ULL |
| 2026-07-27 00:48:32 UTC-05:00 | Target detect | Target: class=Reflector NPC=false Device=true Vehicle=false Active=true |
| 2026-07-27 00:48:32 UTC-05:00 | **SE2_APPLY** |   NOTE: Effect 'Ping' is for npc targets but target is NPC=false Device=true |
| 2026-07-27 00:48:38 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:48:38 UTC-05:00 | **SE2_APPLY** | Applying 'Ping' (BaseStatusEffect.Ping) duration=10.0 instigator=1ULL |
| 2026-07-27 00:48:49 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:49:24 UTC-05:00 | **SE2_CYCLE** | Selected [6/23]: Pain (BaseStatusEffect.Pain) — TweakDB exists: true |
| 2026-07-27 00:49:24 UTC-05:00 | **SE2_CYCLE** | Selected [7/23]: NPCForceStagger (BaseStatusEffect.NPCForceStagger) — TweakDB exists: true |
| 2026-07-27 00:49:25 UTC-05:00 | **SE2_CYCLE** | Selected [8/23]: LocomotionMalfunction (BaseStatusEffect.LocomotionMalfunction) — TweakDB exists: true |
| 2026-07-27 00:49:25 UTC-05:00 | **SE2_CYCLE** | Selected [9/23]: LocomotionMalfunction Lvl2 (BaseStatusEffect.LocomotionMalfunctionLevel2) — TweakDB exists: true |
| 2026-07-27 00:49:26 UTC-05:00 | **SE2_CYCLE** | Selected [10/23]: CyberwareMalfunctionBlackwall (BaseStatusEffect.CyberwareMalfunctionBlackwall) — TweakDB exists: true |
| 2026-07-27 00:49:26 UTC-05:00 | **SE2_CYCLE** | Selected [11/23]: ShortCircuit (BaseStatusEffect.ShortCircuit) — TweakDB exists: false |
| 2026-07-27 00:49:27 UTC-05:00 | **SE2_CYCLE** | Selected [12/23]: Contagion (BaseStatusEffect.Contagion) — TweakDB exists: false |
| 2026-07-27 00:49:38 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:49:38 UTC-05:00 | **SE2_APPLY** | Applying 'Contagion' (BaseStatusEffect.Contagion) duration=10.0 instigator=1ULL |
| 2026-07-27 00:50:20 UTC-05:00 | **SE2_DUMP_QH** | Quickhack-related records dump (224 entries) |
| 2026-07-27 00:50:25 UTC-05:00 | **SE2_DUMP** | Full TweakDB dump (1173 entries) |
| 2026-07-27 00:50:36 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:50:43 UTC-05:00 | **SE2_CYCLE** | Selected [13/23]: Madness (BaseStatusEffect.Madness) — TweakDB exists: true |
| 2026-07-27 00:50:57 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:50:57 UTC-05:00 | **SE2_APPLY** | Applying 'Madness' (BaseStatusEffect.Madness) duration=10.0 instigator=1ULL |
| 2026-07-27 00:51:21 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:51:21 UTC-05:00 | **SE2_APPLY** | Applying 'Madness' (BaseStatusEffect.Madness) duration=10.0 instigator=1ULL |
| 2026-07-27 00:51:26 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:51:26 UTC-05:00 | **SE2_APPLY** | Applying 'Madness' (BaseStatusEffect.Madness) duration=10.0 instigator=1ULL |
| 2026-07-27 00:51:43 UTC-05:00 | Target detect | Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| 2026-07-27 00:51:43 UTC-05:00 | **SE2_APPLY** | Applying 'Madness' (BaseStatusEffect.Madness) duration=10.0 instigator=1ULL |
| 2026-07-27 00:52:03 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:52:19 UTC-05:00 | **SE2_CYCLE** | Selected [14/23]: CyberwareMalfunction (BaseStatusEffect.CyberwareMalfunction) — TweakDB exists: true |
| 2026-07-27 00:52:20 UTC-05:00 | **SE2_CYCLE** | Selected [15/23]: RebootOptics (BaseStatusEffect.RebootOptics) — TweakDB exists: false |
| 2026-07-27 00:52:20 UTC-05:00 | **SE2_CYCLE** | Selected [16/23]: Distraction (BaseStatusEffect.Distraction) — TweakDB exists: false |
| 2026-07-27 00:52:39 UTC-05:00 | Target detect | Target: class=BasicDistractionDevice NPC=false Device=true Vehicle=false Active=true |
| 2026-07-27 00:52:39 UTC-05:00 | **SE2_APPLY** | Applying 'Distraction' (BaseStatusEffect.Distraction) duration=10.0 instigator=1ULL |
| 2026-07-27 00:52:54 UTC-05:00 | **SE2_LIST** | Catalog printed (#7) |
| 2026-07-27 00:53:32 UTC-05:00 | **SHUTDOWN** | Status Effect Tester 2 shut down |

## APPLY Results Breakdown

| # | Time | Effect | TweakDB | Target | API Methods | Verification |
|---|------|--------|---------|--------|-------------|--------------|
| 1 | 2026-07-27 00:44:01 UTC-05:00 | Overheat | true | Character.Chinese_Food_Woman (class=NPCPuppet, ent | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 2 | 2026-07-27 00:44:47 UTC-05:00 | Stun | true | Character.Chinese_Food_Woman (class=NPCPuppet, ent | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 3 | 2026-07-27 00:45:08 UTC-05:00 | Stun | true | Character.CorpoWomanCorporat (class=NPCPuppet, ent | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 4 | 2026-07-27 00:45:25 UTC-05:00 | Stun | true | Character.prevention_police_handgun_wa (class=NPCP | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 5 | 2026-07-27 00:45:37 UTC-05:00 | Stun | true | Character.prevention_police_handgun_wa (class=NPCP | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 6 | 2026-07-27 00:46:13 UTC-05:00 | Ping | true | Character.ChildAverage (class=NPCPuppet, entityID= | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 7 | 2026-07-27 00:46:23 UTC-05:00 | Ping | true | Character.ObeseMaleCorpo (class=NPCPuppet, entityI | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 8 | 2026-07-27 00:47:53 UTC-05:00 | ? | ? | <unknown> (class=Reflector, entityID=2361294508367 | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 9 | 2026-07-27 00:48:09 UTC-05:00 | Ping | true | Character.lch_maelstrom_grunt1_ranged1_copperhead_ | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 10 | 2026-07-27 00:48:32 UTC-05:00 | ? | ? | <unknown> (class=Reflector, entityID=2361294508367 | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 11 | 2026-07-27 00:48:38 UTC-05:00 | Ping | true | Character.lch_maelstrom_grunt1_ranged1_copperhead_ | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 12 | 2026-07-27 00:49:38 UTC-05:00 | Contagion | false | Character.lch_maelstrom_grunt1_ranged1_copperhead_ | 5/5 SUCCESS | FAILED (record missing) |
| 13 | 2026-07-27 00:50:57 UTC-05:00 | Madness | true | Character.lch_maelstrom_grunt1_ranged1_copperhead_ | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 14 | 2026-07-27 00:51:21 UTC-05:00 | Madness | true | Character.lch_maelstrom_grunt1_ranged1_lexington_w | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 15 | 2026-07-27 00:51:26 UTC-05:00 | Madness | true | Character.ma_wat_lch_07_maelstrom_onscreen_02 (cla | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 16 | 2026-07-27 00:51:43 UTC-05:00 | Madness | true | Character.lch_maelstrom_grunt1_ranged1_copperhead_ | 5/5 SUCCESS | PARTIAL (API ok, ObjectHasStatusEffect=false) |
| 17 | 2026-07-27 00:52:39 UTC-05:00 | Distraction | false | <unknown> (class=BasicDistractionDevice, entityID= | 5/5 SUCCESS | FAILED (record missing) |

## Key Findings

### ✅ What Worked
- **Target detection fixed**: `target.IsNPC(target)` correctly identifies NPCs (NPCPuppet=true) and devices (Device=true)
- **TweakDB validation working**: VALID effects confirmed to exist, MISSING effects correctly flagged
- **All 5 API methods return SUCCESS** for valid records (no Lua errors)
- **6 distinct effects tested**: Overheat, Stun, Ping, Contagion, Madness, Distraction

### ⚠️ Partial Success / Unresolved
- **ObjectHasStatusEffect always returns false** even after successful API calls — the verification check may not be querying the right record or the effect may require game-state conditions
- All valid-record APPLY events are marked **PARTIAL** (API succeeded but verification failed)

### ❌ What Failed
- **Contagion** (`BaseStatusEffect.Contagion`) — MISSING from TweakDB, silently no-ops
- **Distraction** (`BaseStatusEffect.Distraction`) — MISSING from TweakDB, silently no-ops (device target)
- Both failed as expected — the API returns SUCCESS but applies nothing for non-existent records

### 🚫 Not Tested
- **SE2_TARGET_INFO** — never pressed (only mentioned in init banner)
- **SE2_APPLY_PERM** — permanent duration variant not tested
- **SE2_REMOVE / SE2_REMOVE_ALL** — removal not tested
- **SE2_CYCLE_BACK** — reverse cycling not tested
- Effects #2 (Burning), #3 (Blind), #6 (Pain), #7 (NPCForceStagger), #8 (LocomotionMalfunction), #9 (LocomotionMalfunction Lvl2), #10 (CyberwareMalfunctionBlackwall), #17 (BlackwallHackUpload), #18-23 — selected but never applied

## Targets Encountered

| Target | Class | NPC | Device | Entity ID |
|--------|------|-----|--------|----------|
| Target: class=NPCPuppet NPC=true Device=false Vehicle=false Active=true |
| Target: class=Reflector NPC=false Device=true Vehicle=false Active=true |
| Target: class=BasicDistractionDevice NPC=false Device=true Vehicle=false Active=true |

## Catalog State (23 effects)

| # | Name | Type | TweakDB | Description |
|---|------|------|---------|-------------|
| 1 | Overheat | npc | VALID | Burns target, deals damage over time |
| 2 | Burning | npc | VALID | Fire burning effect |
| 3 | Blind (Reboot Optics) | npc | VALID | Blinds target (Reboot Optics effect) |
| 4 | Stun | npc | VALID | Stuns target |
| 5 | Ping | npc | VALID | Highlights target through walls |
| 6 | Pain | npc | VALID | Pain effect |
| 7 | NPCForceStagger | npc | VALID | Forces stagger animation |
| 8 | LocomotionMalfunction | npc | VALID | Disables locomotion (Cyberware Malfunction-style) |
| 9 | LocomotionMalfunction Lvl2 | npc | VALID | Stronger locomotion disable |
| 10 | CyberwareMalfunctionBlackwall | npc | VALID | Blackwall-style cyberware malfunction |
| 11 | ShortCircuit | npc | MISSING | EMP stun (needs verification) |
| 12 | Contagion | npc | MISSING | Poison damage (needs verification) |
| 13 | Madness | npc | VALID | Target attacks allies (needs verification) |
| 14 | CyberwareMalfunction | npc | VALID | Disables cyberware (needs verification) |
| 15 | RebootOptics | npc | MISSING | Blinds target (needs verification) |
| 16 | Distraction | device | MISSING | Distracts device (needs verification) |
| 17 | BlackwallHackUpload | npc | VALID | Blackwall hack upload (quest effect, confirmed working) |
| 18 | LegendaryFragGrenade | any | VALID | Frag grenade explosion effect |
| 19 | RoyceForceStagger | npc | VALID | Royce force stagger |
| 20 | Sandstorm | npc | VALID | Sandstorm effect |
| 21 | ReconGrenadeLegendaryPlus | any | VALID | Recon grenade highlight |
| 22 | ForceDive | npc | VALID | Force dive effect |
| 23 | JohnnySicknessHeavy | npc | VALID | Johnny sickness heavy |
