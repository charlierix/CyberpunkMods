## Hotkeys

| Hotkey | Action |
|---|---|
| **Toggle Logging** | Start/stop periodic dumps |
| **Dump All** | One key runs everything in series: CET transforms, camera, components, state machine, CET bone attempt, C++ bones, C++ components, C++ entity transform, C++ status |
| **Snapshot A** | Capture before state |
| **Snapshot B** | Capture after state + **auto-compares** against A (no separate Compare key) |
| **Hover Toggle** | On/off |
| **Hover Up / Down** | ±1m |
| **Hover Stop** | Emergency stop |

## What Snapshots A/B Are For

The snapshots are a **before/after diff tool** for the core investigation: *which transform does the renderer actually read for player body orientation?*

**The workflow:**
1. Look forward → press **Snap A** (captures entity, camera, all components, C++ entity transform, bones — everything)
2. Do the thing that should rotate the body — move mouse to look around, enter a vehicle, enter a workspot, whatever you're testing
3. Press **Snap B** → captures the new state and **immediately diffs against A**

The diff tells you exactly which transforms/bones changed and which didn't. That's your render source — the transform that changed is the one the game is actually using.

So it could be before/after entering a vehicle or workspot, but the primary use case is **before/after mouse-look** — the thing that should rotate the body but doesn't when CET tries to override it. If you Snap A while looking forward, then look left with the mouse, then Snap B, the diff shows which component/bone actually rotated. Whatever that is, that's the thing future rotation testers need to target.