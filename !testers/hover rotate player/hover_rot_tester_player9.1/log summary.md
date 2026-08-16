# Log Summary — hover_rot_tester_player9.1

**Source file:** `log - cet.txt`  
**Lines:** 3,414  |  **Encoding:** UTF-8 (CRLF)  
**Time range:** 2026-08-15 19:08:26 → 19:35:56 (UTC-05:00)  
**Mod tag:** `[HoverRotPlayer9_1]`  

---

## Errors

| # | Line | Error | Source | Notes |
|---|------|-------|--------|-------|
| 1 | L1 | `Type 'AnimationControllerComponent' not found` | CET core | Timestamped 19:35:10 — appears at log top, placed before main log body |
| 2 | L2 | `Type 'AnimationControllerComponent' not found` | CET core | 19:35:43 |
| 3 | L3 | `Type 'AnimationControllerComponent' not found` | CET core | 19:35:45 |
| 4 | L4 | `Type 'AnimationControllerComponent' not found` | CET core | 19:35:51 |
| 5 | L934 | `ragdollComponent: not found` | Mod probing | Expected — player entity has no ragdoll component |
| 6 | L1835 | `ragdollComponent: not found` | Mod probing | Repeated each probing cycle |
| 7 | L2195 | `ragdollComponent: not found` | Mod probing | |
| 8 | L2906 | `ragdollComponent: not found` | Mod probing | |

**Key finding:** The `AnimationControllerComponent` type name is not directly resolvable by CET's type system, but `FindComponentByType('entAnimationControllerComponent')` **does** find the component during probing (L926, L1827, L2898). The bare `AnimationControllerComponent` name (without `ent` prefix) is what fails.

---

## Initialization

| Line | Time | Event |
|------|------|-------|
| L20 | 19:08:26 | `=== onInit ===` |
| L21 | 19:08:26 | Crash safeguard: all modes reset to inactive |
| L22 | 19:08:26 | `=== onInit complete ===` |
| L23 | 19:08:26 | `LuaVM: initialization finished!` |

Initialization was clean — no errors, crash safeguard engaged.

---

## Logging Sessions

| Session | Activated | Deactivated | Duration |
|---------|-----------|-------------|----------|
| 1 | L24 — 19:33:30 (60 ticks) | L717 — 19:33:39 | ~9 sec |
| 2 | L956 — 19:35:34 (60 ticks) | *(not deactivated — log ends)* | ~22 sec |

Session 1 captured 4 transform dumps (ticks 60–240).  
Session 2 captured 15 transform dumps (ticks 60–780, plus tick 3559/373 out-of-band).

---

## Transform Dumps (19 total)

All dumps show **166 total components, 0 placed** — no `IPlacedComponent` components were found on the player entity. This means component-level world transforms are inaccessible via `IsA('IPlacedComponent')` filtering.

### Entity Position & Orientation Over Time

| Tick | Line | WorldPos (X, Y, Z) | Yaw | Pitch | Roll | Phase |
|------|------|---------------------|-----|-------|------|-------|
| 60 | L26 | (-1640.20, 141.21, 6.32) | -74.72° | 0° | 0° | Pre-hover (ground) |
| 120 | L199 | (-1635.79, 142.60, 6.33) | -51.32° | 0° | 0° | Pre-hover |
| 180 | L372 | (-1632.34, 145.46, 6.33) | -43.12° | 0° | 0° | Pre-hover |
| 240 | L545 | (-1634.27, 147.30, 6.33) | 14.28° | 0° | 0° | Pre-hover |
| 3559 | L753 | (-1637.10, 145.69, 29.41) | -53.97° | 0° | 0° | Hover active (rising) |
| 60 | L958 | (-1607.51, 178.46, 35.95) | 39.83° | 0° | 0° | Hover active |
| 120 | L1131 | (-1611.33, 184.75, 36.36) | -47.97° | 0° | 0° | Hover active |
| 180 | L1304 | (-1609.42, 189.62, 36.81) | -62.32° | 0° | 0° | Hover active |
| 240 | L1479 | (-1605.45, 191.19, 37.24) | -62.32° | 0° | 0° | Hover active |
| 300 | L1654 | (-1600.74, 190.23, 37.68) | -62.32° | 0° | 0° | Hover active |
| 360 | L1841 | (-1595.36, 188.40, 38.12) | -62.32° | 0° | 0° | Hover active |
| 373 | L2014 | (-1593.90, 187.84, 38.39) | -62.32° | 0° | 0° | Hover active |
| 420 | L2197 | (-1589.12, 186.54, 38.58) | -62.32° | 0° | 0° | Hover active |
| 480 | L2379 | (-1581.70, 186.73, 39.04) | -58.37° | 0° | 0° | Hover active |
| 540 | L2552 | (-1575.25, 190.03, 39.48) | -37.97° | 0° | 0° | Hover active |
| 600 | L2725 | (-1569.47, 193.03, 39.91) | -37.97° | 0° | 0° | Hover active |
| 660 | L2908 | (-1564.48, 195.62, 40.35) | -37.97° | 0° | 0° | Hover active (peak) |
| 720 | L3082 | (-1560.26, 197.81, 39.64) | -37.97° | 0° | 0° | Post-deactivation (falling) |
| 780 | L3255 | (-1557.05, 199.47, 6.56) | -37.97° | 0° | 0° | Ground (landed) |

**Key observations:**
- **Pitch and roll are always 0.00°** — the player entity never rotates on any axis except yaw
- **Yaw changes only from player movement/look**, not from hover or any mod action
- **Z altitude rose from ~6.33 → ~40.35** during hover (gain of ~34 units), then **dropped to 6.56** after deactivation
- The hover PD controller successfully maintained altitude but **did not affect orientation**

### Camera Data

- Camera is always ~1.6 units above entity (Z offset ~1.6)
- **Camera local orientation is always (0°, 0°, 0°)** across all 19 dumps — camera orientation never changes independently
- Camera position tracks entity position with consistent Z offset

---

## Hover Sequence

| Line | Time | Event |
|------|------|-------|
| L718 | 19:33:47 | Hover ACTIVATED — target height=3.0 |
| L719 | — | Height increased to 4.0 |
| L720 | — | Height increased to 5.0 |
| L721 | — | Height increased to 6.0 |
| L722 | — | Height increased to 7.0 |
| L723 | — | Height increased to 8.0 |
| L724 | — | **Hover stopped** (duplicate #1) |
| L725 | — | **Hover stopped** (duplicate #2) |
| L726 | — | Height increased to 9.0 |
| L727 | — | Height increased to 10.0 |
| L728 | — | Hover ACTIVATED — target height=10.0 |
| L729 | — | Hover stopped |
| L730 | — | Hover ACTIVATED — target height=10.0 |
| L731 | — | Height decreased to 9.0 |
| L732 | — | Height decreased to 8.0 |
| L733 | — | Height decreased to 7.0 |
| L734 | — | Height decreased to 6.0 |
| L735 | — | Height decreased to 5.0 |
| L736 | — | Height decreased to 4.0 |
| L737 | — | Height decreased to 3.0 |
| L738 | — | Height decreased to 2.0 |
| L3080 | 19:35:54 | Hover DEACTIVATED |

**Anomaly:** Two consecutive `Hover stopped` messages at L724–L725 suggest a duplicate event fire or rapid toggle. The hover was then reactivated at height 10.0 (L728), stopped again (L729), and reactivated a third time (L730) before the descent sequence.

---

## Snapshot Comparisons (3 total)

### Snapshot 1 (L739–L751)

| Field | Snapshot A | Snapshot B | Delta |
|-------|-----------|-----------|-------|
| Entity Pos | (-1637.10, 145.69, 25.27) | (-1637.10, 145.69, 25.81) | (0, 0, 0.54) |
| Entity Orient | yaw=-76.87° | yaw=-76.87° | 0° all axes |
| Camera Orient | (0°, 0°, 0°) | (0°, 0°, 0°) | 0° all axes |

**Result:** Only Z position changed (+0.54) — pure vertical drift during hover. No orientation change.

### Snapshot 2 (L943–L955)

| Field | Snapshot A | Snapshot B | Delta |
|-------|-----------|-----------|-------|
| Entity Pos | (-1614.18, 170.82, 33.03) | (-1612.25, 172.90, 33.21) | (1.93, 2.08, 0.17) |
| Entity Orient | yaw=-84.47° | yaw=-129.02° | dYaw=-44.55° |
| Camera Orient | (0°, 0°, 0°) | (0°, 0°, 0°) | 0° all axes |

**Result:** Player moved and rotated (yaw delta -44.55°) between snapshots — likely from player input (walking/looking). Camera orientation still unchanged.

### Snapshot 3 (L1476–L1652, comparison L2369–L2377)

| Field | Snapshot A | Snapshot B | Delta |
|-------|-----------|-----------|-------|
| Entity Pos | (-1608.50, 190.67, 36.94) | (-1604.60, 191.02, 37.37) | (3.90, 0.35, 0.43) |
| Entity Orient | yaw=-62.32° | yaw=-62.32° | 0° all axes |
| Camera Orient | (0°, 0°, 0°) | (0°, 0°, 0°) | 0° all axes |

**Result:** Player moved horizontally (~3.9 units on X) with no orientation change — forward movement during hover.

---

## Animation / Skeleton Probing (3 cycles)

Probing ran at L925, L1826, and L2897 — all produced identical results:

| Probe | Result |
|-------|--------|
| `entAnimationControllerComponent` | **Found** |
| `gameHumanoidBody` | **Found** |
| `entAnimatedComponent` | **Found** |
| Bone access via CET API | **Not found** |
| `gamestateMachineComponent` | Found |
| `PlayerStateMachineBlackboard` | Accessible |
| `CanRagdoll` | false |
| `ragdollComponent` | Not found |

### Bone Dump Attempts (3 total)

All three bone dump attempts (L935, L939, L1836) produced the same result:

```
=== Full Skeleton Hierarchy Dump ===
Animation component: userdata: 0x0205ea24c710
GetSkeleton() returned nil
=== End Bone Dump ===
```

**Critical finding:** `GetSkeleton()` returns nil on the player's animation component. CET cannot access the player's skeleton/bone hierarchy through the available API. This blocks any bone-level rotation manipulation from Lua.

---

## Component Inventory

Each transform dump lists 166 components (all non-placed). Notable component types found:

| Component | Count | Notes |
|-----------|-------|-------|
| `entAnimatedComponent` | 5 | Animation playback |
| `entSkinnedMeshComponent` | 11 | Render meshes |
| `entSlotComponent` | 6 | Attachment slots |
| `entEffectSpawnerComponent` | 4 | VFX |
| `entAnimationSetupExtensionComponent` | 2 | Anim setup |
| `entLightComponent` | 2 | Dynamic lights |
| `gameHumanoidBody` | 1 | Humanoid body container |
| `entAnimationControllerComponent` | 1 | Animation controller |
| `gamestateMachineComponent` | 1 | State machine |
| `gameFPPCameraComponent` | 1 | First-person camera |
| `moveComponent` | 1 | Movement |
| `gameStatsComponent` | 1 | Stats |
| `gameInventory` | 1 | Inventory |
| `gameAttachmentSlots` | 1 | Weapon slots |
| `gamePuppetMountableComponent` | 1 | Mountable |
| `gameScanningComponent` | 1 | Scanning |
| `gameTPPRepresentationComponent` | 1 | TPP model |
| `gameStatusEffectComponent` | 1 | Status effects |
| `PlayerPhone` | 1 | Phone |
| `WeaponPositionComponent` | 1 | Weapon positioning |
| `CombatHUDManager` | 1 | Combat HUD |
| `WidgetHudComponent` | 1 | HUD widget |
| `gameFPPCameraComponent` | 1 | FPP camera |

**Zero components** passed `IsA('IPlacedComponent')` — no component has a queryable world transform.

---

## Summary of Key Findings

1. **No pitch/roll rotation possible via CET alone** — entity orientation only ever shows yaw changes, and those come from normal player movement, not mod actions
2. **Camera orientation is locked** — camera local orientation is always (0°, 0°, 0°), meaning the camera doesn't independently rotate relative to the entity
3. **Skeleton/bone access blocked** — `GetSkeleton()` returns nil on all attempts; CET cannot access bone transforms for the player
4. **No placed components** — 0/166 components implement `IPlacedComponent`, so component-level world transform queries return nothing
5. **Hover PD controller works** — successfully lifted player from Z≈6.3 to Z≈40.4 and maintained altitude, then player fell back to ground (Z≈6.56) after deactivation
6. **Duplicate hover stop events** — two consecutive `Hover stopped` messages at L724–725 suggest a bug in event handling
7. **AnimationControllerComponent type resolution** — the bare type name fails CET type lookup, but the `ent`-prefixed name works with `FindComponentByType()`
8. **State machine is accessible** — `gamestateMachineComponent` found, `PlayerStateMachineBlackboard` readable, `CanRagdoll` returns false
9. **ragdollComponent absent** — expected for player entity; not an error
10. **Player body rotation requires native hooks** — CET API surface is insufficient for direct bone/skeleton manipulation; RED4ext hooks are needed
