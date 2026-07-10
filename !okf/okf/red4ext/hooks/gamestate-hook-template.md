---
type: Class
title: GameStateHook<T>
description: Template class for hooking game state virtual table functions (OnEnter, OnUpdate, OnExit) with memory protection handling.
resource: src/dll/GameStateHook.hpp
tags: [hooking, template, game-state, vtable, memory-protection]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

`GameStateHook<T>` is a template class for hooking the three virtual functions of a game state object (`OnEnter`, `OnUpdate`, `OnExit`). Unlike [Hook<T>](/hooks/hook-template.md) which uses Microsoft Detours for function-level detours, `GameStateHook<T>` directly swaps vtable entries with memory protection handling via `MemoryProtection`. The template constrains `T` to derive from `RED4ext::IGameState`.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `GameStateHook<T>` | Template class | Game state vtable hook wrapper |
| `Func_t` | Type alias | `bool (*)(T*, RED4ext::CGameApplication*)` — the vtable function signature |
| `FuncHook` | Internal struct | Holds detour pointer, original pointer, and shouldExecute flag |

# Class Definition

```cpp
template<typename T>
class GameStateHook
{
public:
    using Func_t = bool (*)(T*, RED4ext::CGameApplication*);

    static_assert(std::is_base_of_v<RED4ext::IGameState, T>,
                  "T should inherit IGameState");

    GameStateHook(Func_t aOnEnter, Func_t aOnUpdate, Func_t aOnExit);

    bool AttachAt(T* aState);
    bool DetachAt(T* aState);

    bool OnEnter(T* aState, RED4ext::CGameApplication* aApp);
    bool OnUpdate(T* aState, RED4ext::CGameApplication* aApp);
    bool OnExit(T* aState, RED4ext::CGameApplication* aApp);

private:
    struct FuncHook
    {
        FuncHook(Func_t aDetour);
        bool shouldExecute;
        Func_t detour;
        Func_t orig;
    };

    bool SwapVFuncs(T* aState, Func_t aOnEnter, Func_t aOnUpdate, Func_t aOnExit);

    bool m_isAttached;
    FuncHook m_onEnter;
    FuncHook m_onUpdate;
    FuncHook m_onExit;
};
```

# Methods

| Method | Return type | Description |
|--------|-------------|-------------|
| `GameStateHook(onEnter, onUpdate, onExit)` | — | Constructor; stores three detour functions |
| `AttachAt(state)` | `bool` | Swaps vtable entries at indices 3, 4, 5 (OnEnter/OnUpdate/OnExit) with the detour functions; saves originals |
| `DetachAt(state)` | `bool` | Restores the original vtable entries |
| `OnEnter(state, app)` | `bool` | Calls the original `OnEnter` once (guarded by `shouldExecute`); subsequent calls return `true` |
| `OnUpdate(state, app)` | `bool` | Calls the original `OnUpdate` once; subsequent calls return `true` |
| `OnExit(state, app)` | `bool` | Calls the original `OnExit` once; subsequent calls return `true` |

# Internal FuncHook Struct

| Member | Type | Description |
|--------|------|-------------|
| `shouldExecute` | `bool` | Guards one-shot execution of the original function |
| `detour` | `Func_t` | The replacement function pointer |
| `orig` | `Func_t` | The saved original function pointer |

# Vtable Layout

The hook targets three consecutive vtable entries:

| Vtable index | Function |
|-------------|----------|
| 3 | `OnEnter` |
| 4 | `OnUpdate` |
| 5 | `OnExit` |

The `SwapVFuncs` method temporarily changes memory protection to `PAGE_READWRITE` using a `MemoryProtection` RAII guard, writes the new function pointers, then restores the original protection.

# Error Handling

`SwapVFuncs` catches three exception types:

| Exception | Behavior |
|-----------|----------|
| `MemoryProtection::Exception` | Logs warning, returns `false` |
| `std::exception` | Logs warning with `e.what()`, returns `false` |
| `...` (catch-all) | Logs warning, returns `false` |

# Private Members

| Member | Type | Description |
|--------|------|-------------|
| `m_isAttached` | `bool` | Whether the hook is currently attached |
| `m_onEnter` | `FuncHook` | Hook state for OnEnter |
| `m_onUpdate` | `FuncHook` | Hook state for OnUpdate |
| `m_onExit` | `FuncHook` | Hook state for OnExit |

# Related Concepts

- Unlike [Hook<T>](/hooks/hook-template.md) which uses Detours, this hooks vtable entries directly
- Game states can also be registered via the SDK's [GameStates::Add](/apis/sdk-functions.md) function

# Citations

[1] [src/dll/GameStateHook.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/GameStateHook.hpp)
