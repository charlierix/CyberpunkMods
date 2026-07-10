---
type: API
title: v1 SDK Functions
description: SDK function implementations for Hooking, GameStates, and Scripts that plugins call at runtime.
resource: src/dll/v1/Funcs.hpp
tags: [hooking, game-states, scripts, api, v1]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

The `v1` namespace provides three groups of SDK functions that plugins call through the SDK struct: `Hooking` (attach/detach function hooks), `GameStates` (register custom game state handlers), and `Scripts` (register script resources and reference types). These are the primary ways plugins interact with the game engine at runtime.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `v1::Hooking` | Namespace | Function hooking API (Attach/Detach) |
| `v1::GameStates` | Namespace | Game state registration API (Add) |
| `v1::Scripts` | Namespace | Script registration API (Add, RegisterNeverRefType, RegisterMixedRefType) |

# Complete Function Listing

## Hooking

| Function | Signature | Returns | Description |
|----------|-----------|---------|-------------|
| `Attach` | `bool Attach(PluginHandle aHandle, void* aTarget, void* aDetour, void** aOriginal)` | `bool` | Attaches a detour function to a target function; `aOriginal` receives the trampoline to call the original |
| `Detach` | `bool Detach(PluginHandle aHandle, void* aTarget)` | `bool` | Detaches a previously attached detour from the target function |

## GameStates

| Function | Signature | Returns | Description |
|----------|-----------|---------|-------------|
| `Add` | `bool Add(PluginHandle aHandle, RED4ext::EGameStateType aType, RED4ext::v1::GameState* aState)` | `bool` | Registers a custom game state handler for the specified game state type |

## Scripts

| Function | Signature | Returns | Description |
|----------|-----------|---------|-------------|
| `Add` | `bool Add(PluginHandle aHandle, const wchar_t* aPath)` | `bool` | Registers a script resource file (e.g. `.reds` Redscript file) with the script compilation system |
| `RegisterNeverRefType` | `bool RegisterNeverRefType(const char* aType)` | `bool` | Registers a native type that should never be garbage-collected by the script VM |
| `RegisterMixedRefType` | `bool RegisterMixedRefType(const char* aType)` | `bool` | Registers a native type with mixed reference semantics for the script VM |

# Usage

Plugins access these through the SDK struct:

```cpp
// Hooking
void* original = nullptr;
aSdk->hooking->Attach(aHandle, targetFunc, myDetour, &original);
// ... later
aSdk->hooking->Detach(aHandle, targetFunc);

// Game states
aSdk->gameStates->Add(aHandle, RED4ext::EGameStateType::Session, &myState);

// Scripts
aSdk->scripts->Add(aHandle, L"plugins/myplugin/scripts.reds");
```

# Related Concepts

- For in-process hooking with RAII, use the [Hook<T> template](/hooks/hook-template.md)
- For game state vtable hooking, see [GameStateHook<T>](/hooks/gamestate-hook-template.md)
- The [v1::Plugin](/plugin-contract/v1-plugin.md) constructor wires these into the SDK struct

# Citations

[1] [src/dll/v1/Funcs.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Funcs.hpp)
[2] [src/dll/v1/Funcs.cpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Funcs.cpp)
