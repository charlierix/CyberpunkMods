# Player Rotation Testing Program — Master Goals

> **Status:** Active planning document  
> **Created:** 2026-08-15  
> **Supersedes:** `goals1.md` (kept as historical reference for the original combined plan)

---

## 1. Background

Tester 8 proved the full CET → Redscript → RED4ext pipeline works. Quaternion writes to the entity-level `worldTransform` persist in memory (4,510 successful calls, 0 failures) but produce **no visible body rotation**. The game's locomotion system overrides visual orientation every frame.

**The problem is no longer communication or write-path.** It's *which transform the game uses for rendering* and *how to override it effectively*.

Root cause: `gamestateMachineComponent` enforces `roll=0, pitch=0` every frame. The player is locomotion-driven, not physics-driven. See `docs/c++ hooks/free player manipulation - analysis.md` for full details.

---

## 2. Testing Philosophy

Each tester focuses on **one strategy** to keep scope manageable and allow logging from each tester to inform the next. Testers are sequential — results from one may change priorities for subsequent testers.

---

## 3. Tester Roadmap

| Tester | Focus | Strategy | Doc | Status |
|--------|-------|----------|-----|--------|
| **9.1** | Diagnostic logging | Observe transform chain, identify render-source | [goals 1 - logging.md](goals 1 - logging.md) | Planning |
| **9.2** | Locomotion hook | Approach A — skip orientation clamp in C++ | [goals 2 - locomotion-hook.md](goals 2 - locomotion-hook.md) | Pending T9.1 |
| **9.3** | Animation override | Approach B — VR-style full-body bone override | [goals 3 - animation-override.md](goals 3 - animation-override.md) | Pending T9.1 |
| **9.4** | Physics injection | Approach C — add rigid body to player entity | [goals 4 - physics-injection.md](goals 4 - physics-injection.md) | Pending T9.1 |
| **9.5** | Workspot vehicle | Approach D — mount player on invisible vehicle | [goals 5 - workspot-vehicle.md](goals 5 - workspot-vehicle.md) | Pending T9.1 |
| **9.6** | Workspot anchor | Approach E — custom workspot with dynamic anchor | [goals 6 - workspot-anchor.md](goals 6 - workspot-anchor.md) | Pending T9.1 |

### Recommended Priority Order

Based on `docs/c++ hooks/free player manipulation - analysis.md`:

1. **Tester 9.1 (Logging)** — must come first; answers "what does the renderer read?"
2. **Tester 9.2 (Locomotion Hook)** — primary recommendation; directly addresses root cause
3. **Tester 9.5 (Workspot Vehicle)** — fallback if A fails; uses proven vehicle APIs
4. **Tester 9.3 (Animation Override)** — proven by VR mod but high complexity (full-body IK)
5. **Tester 9.6 (Workspot Anchor)** — untested; partial 6DOF potential
6. **Tester 9.4 (Physics Injection)** — highest complexity and risk; last resort

**Note:** This order is a starting point. Logging results from Tester 9.1 may reshuffle priorities.

---

## 4. Strategy Comparison

| Approach | Proven? | Complexity | Risk | 6DOF? | Collision |
|----------|---------|------------|------|-------|----------|
| A: Locomotion Hook | No (theoretical) | Medium | Medium | Full | Rotates capsule |
| B: Animation Override | Yes (VR mod, hands only) | High | Medium | Full | Capsule stays upright |
| C: Physics Injection | No | Very High | High | Full | Physics-based |
| D: Workspot Vehicle | No (vehicle APIs proven) | Low | Low | Full (via vehicle) | Vehicle-shaped |
| E: Workspot Anchor | No | Medium | Medium | Partial? | Upright? |

---

## 5. Shared Infrastructure

All testers build on infrastructure from prior testers:

| Infrastructure | Source | Reused By |
|----------------|--------|-----------|
| CET→RED4ext native function registration | Tester 8 | T9.2, T9.3, T9.4 |
| Redscript bridge pattern | Tester 8 | T9.2, T9.3, T9.4 |
| Quaternion math (`EulerAngles:ToQuat()`) | Tester 8 | All |
| Hover PD controller (height lock) | Tester 9.1 | All subsequent |
| Component/bone transform logging | Tester 9.1 | Informs all |
| CET hotkey registration (root level) | All | All |
| Crash safeguard (reset state on init) | Tester 7b | All |

---

## 6. Decision Flow

```
Tester 9.1 (Logging)
  │
  ├── Which transform changes on mouse-look turn?
  ├── Can CET access bone transforms?
  ├── What components exist on the player?
  │
  ▼
Based on findings:
  │
  ├─ If renderer reads entity transform → Tester 9.2 (Locomotion Hook)
  ├─ If renderer reads bone transforms  → Tester 9.3 (Animation Override)
  ├─ If neither accessible from CET      → Tester 10 (C++ hook regardless)
  ├─ If both seem hard                   → Tester 13 (Workspot Vehicle fallback)
  └─ Results may suggest other approaches
```

---

## 7. Key Research Documents

| Document | Path | Key Insight |
|----------|------|-------------|
| Free Player Manipulation | `docs/c++ hooks/free player manipulation - analysis.md` | 5 approaches; root cause = locomotion clamp |
| Player Class Hierarchy | `docs/c++ hooks/player class hierarchy - physics perspective.md` | 174 components; no ragdoll; no physicsData |
| VR Mod C++ Hooks | `docs/c++ hooks/cyberpunk vr port - c++ hooks.md` | Pose-apply detour; bone transform write |
| VR Mod VRIK | `sources - extra/vr/.../CyberpunkVRPort_VRIK/init.lua` | Bone-level pose hooks work |
| LTBF C++ Hooks | `docs/c++ hooks/let there be flight - c++ hooks.md` | Vehicle physics hook pattern |
| Tester 8 Log Summary | `testers/hover rotate player/hover_rot_tester_player8/log summary.md` | Entity write succeeds, no visual effect |
| Vehicle Hover Tester 2 | `testers/hover rotate vehicle/hover_vehicle_tester2/init.lua` | PD controller for hover height |
