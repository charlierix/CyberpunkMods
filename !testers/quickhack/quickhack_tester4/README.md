### What's new vs tester3

| # | Recommendation | Implementation |
|---|---|---|
| 1 | Investigate StartAction failure cause | `xpcall` with `ErrorHandler` captures **real error messages** instead of silently swallowing them with `pcall` |
| 2 | Try device controller directly | **Strategy C:** `Game.GetDeviceSystem():GetDeviceById(game, entityID)` then `device:ExecuteAction()` / `device:ProcessAction()` |
| 3 | Try QueuePSDeviceEvent manually | **Strategy B:** Calls PS `On*` handlers directly (`OnQuickHackDistraction`, `OnQuickHackAuthorization`, `OnQuickHackToggleOn`) + `QueuePSDeviceEvent(action)` |
| 4 | Check if actions need activation | `SetObjectActionID(recID)` from TweakDB record + `IsPossible()` + `ResolveAction()` before `StartAction` |
| 5 | Research base game quickhack execution | Tries `GetQuickHackActionsExternal(context)` as alternative discovery path |
| 6 | Fix CNameToString | 4 fallback approaches: tostring regex, `string.format`, concatenation, hash table inspection |

### Hotkeys (6 total, all at root level per CET rules)

| Hotkey | Action |
|---|---|
| **Get Report** | Get a report of hackability |
| **Apply Quickhack** | Full execution chain: Strategy A → B → C (all fallbacks) |
| **Execute via PS** | Bypass action object, go straight to PS `On*` handlers |
| **Clear Cache** | Force-clear action cache |
| **Cycle Hack** | Rotate through device's available quickhacks |

### Install
Copy the folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester4/
```
Bind keys in **Settings > Key Bindings > QHTester4**

### Testing approach
1. Use **Get Report** to confirm 4 hacks found (same as tester3)
3. Use **Apply Quickhack** — the xpcall will now show the **actual error message** from StartAction instead of just "failed"
4. Use **Execute via PS** to test if direct PS handler calls produce visual effects
5. Share the CET console log for further analysis