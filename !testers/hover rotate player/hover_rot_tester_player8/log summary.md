# Log Summary — HoverRotTesterPlayer8

**Test date:** 2026-08-14, 21:53–22:01 (~8 minutes)  
**Game version:** Cyberpunk 2077 2.31 (file version 3.0.80.51928)  
**RED4ext:** v1.30.0  
**Plugin:** HoverRotTesterPlayer8 v1.0.0

---

## TL;DR

All three mod layers (RED4ext → Redscript → CET) loaded and communicated flawlessly. The C++ native function `ApplyRotation` was called **4,510 times with zero failures**, and readbacks confirm the quaternion **was successfully written and persists in memory**. Despite this, **no visible body rotation occurred**. The game's locomotion/rendering pipeline is either ignoring the written transform or using a different transform source.

---

## Loading Phase (21:53:39–21:54:08)

| Layer | Status | Details |
|-------|--------|--------|
| RED4ext | ✅ Clean | 4 plugins loaded (ArchiveXL, Codeware, HoverRotTesterPlayer8, TweakXL), 921,876 game addresses resolved |
| Redscript | ✅ Clean | Compiled `HoverRotPlayer8.reds` + 47 other scripts, no errors, saved to `final.redscripts.modded` |
| CET | ✅ Clean | Mod loaded, `onInit` completed, crash safeguard reset active→false, native functions detected as AVAILABLE |

**C++ plugin startup confirmed** (red4ext2.log):
- 3 native functions registered via RTTI: `ApplyRotation`, `GetStatus`, `ReadPlayerOrientation`
- Transform write path: `Entity[0xB0] → IPlacedComponent[0xE0] → WorldTransform[0x10] → Quaternion`

---

## Test Session Timeline

| Time (CDT) | Event | Pitch | Yaw | Roll | Readback Quaternion |
|------------|-------|-------|-----|------|---------------------|
| 21:58:52 | Toggle → **ACTIVATE** | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 21:58:52 | First ApplyRotation call — SUCCESS | 0 | 0 | 0 | entity & transform ptrs resolved |
| 21:59:38 | YawRight → yaw=2° | 0 | 2 | 0 | (0, 0, 0.01745, 0.99985) |
| 21:59:39 | YawLeft → yaw=0° | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 21:59:44 | RollRight → roll=2°, then 4° | 0 | 0 | 4 | (0, 0.03490, 0, 0.99939) |
| 21:59:46 | RollLeft → roll=0° | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 21:59:48 | PitchUp → 2°, 4°, back to 2° | 2 | 0 | 0 | (0.01745, 0, 0, 0.99985) |
| 21:59:49 | PitchDown → 0° | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 21:59:53 | Reset | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 21:59:59 | Complex combo: yaw→6°, pitch→-6°, roll→-6° | -6 | 6 | -6 | (-0.0495, -0.0549, 0.0549, 0.9958) |
| 22:00:06 | HoverUp → velocity=3, then HoverStop | -6 | 6 | -6 | unchanged (hover is separate) |
| 22:00:10 | Adjusted to pitch→-10°, roll→-8° | -10 | 4 | -8 | (-0.0845, -0.0725, 0.0408, 0.9930) |
| 22:00:14 | Settled at pitch→-6°, yaw→4°, roll→-2° | -6 | 4 | -2 | (-0.0517, -0.0192, 0.0358, 0.9978) |
| 22:00:18–22:00:36 | **Held steady for ~18 seconds** | -6 | 4 | -2 | **same value, stable across 15+ ticks** |
| 22:00:37 | Reset | 0 | 0 | 0 | (0, 0, 0, 1) identity |
| 22:00:47 | Final test: yaw=2° | 0 | 2 | 0 | (0, 0, 0.01745, 0.99985) |
| 22:00:53 | Toggle → **DEACTIVATE** | — | — | — | final stats: 4510 calls, 4510 ok, 0 fail |

---

## Final Statistics

| Metric | Value |
|--------|-------|
| Total ApplyRotation calls | 4,510 |
| Successful calls | 4,510 |
| Failed calls | **0** |
| Success rate | **100%** |
| Orientation reads | 75 |
| Read failures | 0 |
| Errors | none |
| Crashes | 0 |
| Session duration | ~2 min active (21:58:52–22:00:53) |

---

## Critical Finding: Write Succeeds But No Visual Effect

### What the logs prove

1. **The C++ function finds the player entity** — entity pointer `0000017498516E60` and transform component pointer `0000017091506FB0` resolved successfully on first call.

2. **The quaternion is written to the correct memory offset** — readbacks via `ReadPlayerOrientation` return the exact quaternion that was applied, every single time.

3. **The written value persists** — when pitch=-6°, yaw=4°, roll=-2° was held for ~18 seconds (ticks 3060–3900), the readback returned `(-0.0517, -0.0192, 0.0358, 0.9978)` consistently across **15 consecutive tick samples** with no drift or reset.

4. **The quaternion math is correct** — the game's native `EulerAngles.new(roll, pitch, yaw):ToQuat()` produces valid results matching expected values (e.g., yaw=2° → k=sin(1°)=0.01745, r=cos(1°)=0.99985).

### What the user observed

> *"None of the rotations seemed to do anything. The values in the imgui window show a change but then go back to zeros."*

The "go back to zeros" likely refers to the **Euler angle state** (pitch/yaw/roll) shown in ImGui — these are the user's input values that reset when pressing Reset or adjusting back to 0. The **quaternion readback** in the logs shows stable non-zero values that persist.

### What this means

The transform is being written and **stays in memory**, but the **game is not rendering the player body with this orientation**. The locomotion system or animation pipeline is either:

- **Overwriting the transform between render frames** (but not between CET tick intervals, since readbacks every 60 ticks still show the value)
- **Using a different transform source** (e.g., a bone-level or animation-driven transform rather than the entity-level worldTransform)
- **The entity-level worldTransform is read-only in practice** — the game may compute the visual transform from the animation/locomotion state each frame and overwrite our value before rendering

---

## Key Differences from 7 Series

| Aspect | 7 Series | Tester 8 |
|-------|----------|----------|
| C++ plugin | Shell, no functions | Real — 3 native functions, 4510 successful calls |
| Communication | TweakDB flats | Direct function call (CET → redscript → C++) |
| Quaternion | Custom EulerToQuat (wrong axes) | Game native `EulerAngles:ToQuat()` (correct) |
| Transform write | Not implemented | Direct memory write to worldTransform.Orientation |
| Readback | Not available | 75 reads, all matching applied values |
| Failures | N/A | 0 out of 4510 |
| Visual result | None | **Still none** |

---

## Diagnosis & Next Steps

The plumbing is now **fully proven end-to-end**. The problem is no longer in the communication or write path — it's in **which transform the game actually uses for rendering**.

### Likely root cause

The entity-level `worldTransform.Orientation` is **not the transform that drives visual rendering** for the player. The game's animation and locomotion systems likely compute the visual transform from:
- Skeleton/bone transforms (per-bone quaternions)
- Animation-driven pose data
- Locomotion state machine output

Writing to the entity-level worldTransform may only affect collision/physics, not visual orientation.

### Recommended approaches for tester 9

1. **Hook the locomotion update function** — intercept `gameLocomotionStateMachinePlayer::Update` or similar, and override the orientation output *after* the locomotion system computes it but *before* it's applied to the render transform

2. **Target the skeleton/bone transform** — instead of writing to entity-level `worldTransform`, write to the player's skeleton component bone orientations (e.g., the root bone or pelvis)

3. **Use the animation system** — inject rotation through the animation pipeline by overriding the animation pose or using an animation modifier

4. **Investigate which component the renderer reads** — dump all transform-bearing components on the player entity and compare which one changes when the player turns normally (via mouse look)

---

## Source Files

| File | Lines | Description |
|------|-------|-------------|
| `log - cet.txt` | 314 | CET console output with all hotkey events and tick diagnostics |
| `log - red4ext.txt` | 28 | RED4ext system log (plugin load/unload) |
| `log - red4ext2.log` | 25 | HoverRotTesterPlayer8 plugin log (ApplyRotation stats) |
| `log - redscript.txt` | 49 | Redscript compilation log |
| `TEST RESULTS.md` | 7 | User's manual observations and key question |
