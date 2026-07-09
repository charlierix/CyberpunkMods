---
type: "API"
title: "Callback System"
description: "Event-driven callback system with targets, events, and handlers for inter-system communication."
resource: "codeware/scripts/"
tags: "[callback]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Event-driven callback system with targets, events, and handlers for inter-system communication.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CallbackLifetime | enum | — | Session, Forever |
| CallbackRunMode | enum | — | Default, Once, OncePerTarget |
| CallbackSystem | class | IGameSystem | RegisterCallback, RegisterStaticCallback, UnregisterCallback, UnregisterStaticCallback, RegisterEvent |
| CallbackSystemEvent | class | — | GetEventName |
| CallbackSystemHandler | class | — | AddTarget, RemoveTarget, SetRunMode, SetLifetime, IsRegistered |
| CallbackSystemTarget | class | — | — |
| AxisInputEvent | class | KeyInputEvent | GetValue, GetMouseX, GetMouseY |
| EntityBuilderEvent | class | CallbackSystemEvent | GetEntityBuilder |
| EntityComponentEvent | class | EntityLifecycleEvent | GetComponent |
| EntityLifecycleEvent | class | CallbackSystemEvent | GetEntity |
| GameSessionEvent | class | CallbackSystemEvent | IsRestored, IsPreGame |
| inkWidgetSpawnEvent | class | CallbackSystemEvent | GetLibraryPath, GetItemName, GetItemInstance |
| KeyInputEvent | class | CallbackSystemEvent | GetAction, GetKey, IsShiftDown, IsControlDown, IsAltDown |
| ResourceEvent | class | CallbackSystemEvent | GetResource, GetPath, GetJobGroup |
| VehicleLightControlEvent | class | EntityLifecycleEvent | IsEnabled, IsLightType |
| ComponentTarget | class | CallbackSystemTarget | — |
| DynamicEntityTarget | class | CallbackSystemTarget | — |
| EntityTarget | class | CallbackSystemTarget | — |
| inkWidgetTarget | class | CallbackSystemTarget | — |
| InputTarget | class | CallbackSystemTarget | — |
| ResourceTarget | class | CallbackSystemTarget | — |
| StaticEntityTarget | class | CallbackSystemTarget | — |

# Citations

- `codeware/scripts/Callback/CallbackLifetime.reds`
- `codeware/scripts/Callback/CallbackRunMode.reds`
- `codeware/scripts/Callback/CallbackSystem.reds`
- `codeware/scripts/Callback/CallbackSystemEvent.reds`
- `codeware/scripts/Callback/CallbackSystemHandler.reds`
- `codeware/scripts/Callback/CallbackSystemTarget.reds`
- `codeware/scripts/Callback/Events/AxisInputEvent.reds`
- `codeware/scripts/Callback/Events/EntityBuilderEvent.reds`
- `codeware/scripts/Callback/Events/EntityComponentEvent.reds`
- `codeware/scripts/Callback/Events/EntityLifecycleEvent.reds`
- ... and 12 more source files
