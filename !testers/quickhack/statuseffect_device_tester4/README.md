# Status Effect Device Tester 4 (SEDevT4)

**DeviceOperations Pipeline Investigation** — accessing and triggering device-native effect operations from CET Lua.

## Focus

Based on `device hack summary.md` suggestion #2:

> Investigate DeviceOperations pipeline access from CET
> Research DeviceOperationsComponent API in okf
> Try accessing device operations container and triggering operations directly
> Key operations: PlayEffectDeviceOperation, ApplyDamageDeviceOperation, StimDeviceOperation

This tester explores the device's **native effect pipeline** — the internal operations system that devices use to play effects, apply damage, trigger stims, and change state. This is an untested path distinct from both QuickHack actions (confirmed dead end) and QuestForce actions (partially working).

## Strategy Matrix

### Access Strategies (finding the operations container/component)

| Strategy | Source | Method |
| --- | --- | --- |
| **A1** | PS | `ps:GetDeviceOperations()` |
| **A2** | PS | `ps:GetOperations()` |
| **A3** | PS | `ps.operationsContainer` field |
| **A4** | PS | `ps.deviceOperations` field |
| **A5** | PS | `ps:GetComponentByName("DeviceOperationsComponent")` |
| **B1** | Entity | `entity:FindComponentByName("DeviceOperationsComponent")` |
| **B2** | Entity | `entity:FindComponentByClassName("DeviceOperationsComponent")` |
| **B3** | Entity | `entity:GetComponent("DeviceOperationsComponent")` |
| **B4** | Entity | `entity:GetDeviceComponent():GetDeviceOperations()` |
| **B5** | Entity | `entity:FindComponentByClassName(CName.new(...))` |

### Enumeration Strategies (listing operations in the container)

| Strategy | Method |
| --- | --- |
| **C1** | `container.operations` field (CArray<CHandle<DeviceOperationBase>>) |
| **C2** | `container:GetOperations()` |
| **C3** | `container:GetByIndex(0..19)` brute-force scan |
| **C4** | `container:HasItem(i)` + `GetByIndex(i)` paired scan |

### Execution Strategies (triggering an operation)

| Strategy | Method | Target |
| --- | --- | --- |
| **D1** | `component:ToggleOperation(index, true/false)` | DeviceOperationsComponent |
| **D2** | `op:Execute(game)` / `op:Restore(game)` / lifecycle | Operation object directly |
| **D3** | `ToggleOperationEvent` via `QueuePSDeviceEvent` | PS event dispatch |
| **D4** | `SetDelayIdOnOperation` + `ToggleOperation` | Component with delay |
| **D5** | `OperationExecutionData` + `container:Execute()` | Container trigger |

## Hotkeys

| Hotkey ID | Label | Action |
| --- | --- | --- |
| `SE_DEV4_TOGGLE_WINDOW` | Toggle Info Window | Show/hide status window |
| `SE_DEV4_ENUMERATE` | Enumerate Operations | Run full discovery pipeline on targeted device |
| `SE_DEV4_EXECUTE` | Execute Selected Operation | Try all execution strategies (D1-D5) on selected operation |
| `SE_DEV4_CYCLE_OP` | Cycle Operation Selection | Move selection to next operation |

Bind in: **Settings > Key Bindings > SEDevT4**

Suggested: F8 = toggle, F9 = enumerate, F10 = execute, F11 = cycle

## Window

Shows:
- Target info (name, class, distance)
- Container/Component status (found or not, via which strategy)
- Last execution result (strategy used, success/fail, message)
- Operations list with selection indicator (`>` = selected) and status marks (`*` = success, `.` = tried)
- Access strategy results summary

## Workflow

1. Look at a hackable device
2. Press **F9** to enumerate — runs all access strategies (A1-A5, B1-B5), then enumerates operations (C1-C4)
3. Press **F11** to cycle through discovered operations
4. Press **F10** to execute the selected operation — tries D1 → D2 → D3 → D4 → D5 in sequence until one succeeds
5. Observe the game for visible effects (API success ≠ visible effect, as learned from previous testers)
6. Check `log.txt` for detailed strategy results

## Key Data Structures (from WolvenKit source analysis)

| Class | Key Fields | Methods |
| --- | --- | --- |
| `DeviceOperationsContainer` | `operations` (CArray<CHandle<DeviceOperationBase>>), `triggers` (CArray<CHandle<DeviceOperationsTrigger>>) | 23 methods |
| `DeviceOperations` (abstract) | `components`, `fxInstances` | Execute, Restore |
| `OperationExecutionData` | `operationName` (CName), `delay` (CFloat), `resetDelay` (CBool), `delayID`, `isDelayActive` | — |
| `ToggleOperationEvent` | `enable` (CBool), `index` (CInt32), `type` (EOperationClassType) | — |
| `StimRequest` | `stimuli`, `hasExpirationDate`, `duration`, `requestID` | — |

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester4/
```

## Log Analysis

After testing, check `log.txt` for:
- `[CONTAINER]` — which access strategy found the operations container
- `[COMPONENT]` — which entity strategy found the operations component
- `[OPS]` — number and types of operations discovered
- `[D1/D2/D3/D4/D5]` — per-strategy execution results
- `=== NEW DEVICE TYPE REPORT ===` — first encounter of each device type
- `Final Statistics` — summary on shutdown

## What This Tester Does NOT Do

- Does not use QuestForce actions (covered by tester3)
- Does not apply BaseStatusEffect records (confirmed dead end for devices)
- Does not use QuickHack action chain (confirmed dead end)
- Does not test EffectExecutor_Scripted classes (future tester)

## Expected DeviceOperations Classes

Based on okf `devices/core.md`:

| Operation Class | Purpose |
| --- | --- |
| PlayEffectDeviceOperation | Play visual effect on device |
| ApplyDamageDeviceOperation | Apply damage via device operation |
| StimDeviceOperation | Trigger AI stim via device |
| ApplyStatusEffectDeviceOperation | Apply status effect via device |
| PlaySoundDeviceOperation | Play sound via device |
| ItemsDeviceOperation | Spawn items via device |
| TeleportDeviceOperation | Teleport via device |
| MeshAppearanceDeviceOperation | Change mesh appearance |
| PlayTransformAnimationDeviceOperation | Play transform animation |
| FactsDeviceOperation | Set quest facts |
| ToggleComponentsDeviceOperation | Toggle components |
| PlayBinkDeviceOperation | Play bink video |