## What It Tests

**Step 1** from `testers/hover_rot_tester_player3/next steps.md`: `EnableTransformUpdates(false)` + `SetWorldTransform` — the highest-priority untested approach.

## How It Works

| Phase | What Happens |
|-------|-------------|
| **Activate** | `EnableTransformUpdates(false)` → lock camera → teleport player to `z+100` → re-apply `EnableTransformUpdates(false)` |
| **Each frame** | Check if `z < initialZ+10` — if so, re-teleport to `z+100` + re-apply locomotion disable. Otherwise: call `SetWorldTransform` with target orientation (the core test) |
| **Deactivate** | `EnableTransformUpdates(true)` — **only time locomotion is re-enabled** |

## Key Design Decisions

- **Teleport only for position management** (initial + when falling below `z+10`), **not every frame** — avoids interfering with the `SetWorldTransform` test
- **After every teleport**: re-applies `EnableTransformUpdates(false)` in case Teleport resets locomotion state
- **Player stays airborne**: teleported to `z+100`, re-teleported when `z` drops below `z+10`
- **Locomotion re-enabled only on deactivate** via the toggle hotkey — never during the update loop

## Hotkeys (bind in Settings > Key Bindings > HoverRotTesterPlayer5)

| # | Label | Action |
|---|-------|--------|
| 1 | Toggle Hover (Player5) | Enable/disable tester |
| 2 | Yaw +30 (Player5) | Yaw +30° |
| 3 | Yaw -30 (Player5) | Yaw -30° |
| 4 | Pitch +30 (Player5) | Pitch +30° |
| 5 | Pitch -30 (Player5) | Pitch -30° |
| 6 | Roll +30 (Player5) | Roll +30° |
| 7 | Roll -30 (Player5) | Roll -30° |

All `registerHotkey` calls are at **root level** per the CET hotkey rule.

## Install

Copy the folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player5
```

## What to Look For in Logs

The diagnostic output (3 frames after each change) shows:
- `DIAG BEFORE SetWorldTransform` — current orientation before our call
- `SetWorldTransform SUCCESS/FAILED` — whether the call errored
- `DIAG AFTER SetWorldTransform` — whether orientation actually changed
- `DIAG MATCH: roll=? pitch=? yaw=?` — which axes stuck vs got overridden

If `MATCH` shows all three axes sticking, **Step 1 works** — `EnableTransformUpdates(false)` unblocks `SetWorldTransform` for full 6DOF player rotation.