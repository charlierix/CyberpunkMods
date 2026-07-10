---
type: Class
title: Hook<T>
description: Template class for function hooking via Microsoft Detours with address or hash-based resolution.
resource: src/dll/Hook.hpp
tags: [hooking, template, detours, function-hook, raii]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

`Hook<T>` is a template class that wraps a single function hook using Microsoft Detours. It supports two modes: direct address (pass the function pointer) or hash-based (pass a hash and the address is resolved lazily via the `Addresses` singleton). The class provides RAII-style `Attach()` and `Detach()` methods that are idempotent.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `Hook<T>` | Template class | Function hook wrapper with address or hash resolution |

# Class Definition

```cpp
template<typename T>
class Hook
{
public:
    Hook(T aAddress, T aDetour);
    Hook(std::uint32_t aHash, T aDetour);

    operator T() const;
    uintptr_t GetAddress() const;
    int32_t Attach();
    int32_t Detach();

private:
    bool m_isAttached;
    mutable T m_address;
    T m_detour;
    uint32_t m_hash;
};
```

# Constructors

| Constructor | Parameters | Description |
|-------------|-----------|-------------|
| `Hook(address, detour)` | `T aAddress`, `T aDetour` | Creates a hook with a known function address |
| `Hook(hash, detour)` | `uint32_t aHash`, `T aDetour` | Creates a hook that resolves the address lazily from `Addresses::Instance()->Resolve(hash)` |

# Methods

| Method | Return type | Description |
|--------|-------------|-------------|
| `operator T()` | `T` | Returns the current address (implicit conversion) |
| `GetAddress()` | `uintptr_t` | Resolves and returns the raw address; lazily resolves from hash if address is 0 |
| `Attach()` | `int32_t` | Calls `DetourAttach` on the address with the detour; idempotent (returns 0 if already attached) |
| `Detach()` | `int32_t` | Calls `DetourDetach` to restore the original function; idempotent |

# Private Members

| Member | Type | Description |
|--------|------|-------------|
| `m_isAttached` | `bool` | Whether the hook is currently attached |
| `m_address` | `mutable T` | The target function pointer (mutable for lazy resolution) |
| `m_detour` | `T` | The detour function pointer |
| `m_hash` | `uint32_t` | Hash for lazy address resolution (0 if direct address was used) |

# Usage Example

```cpp
using SomeFunc_t = void (*)(int);
SomeFunc_t originalFunc = nullptr;

void MyDetour(int param)
{
    // Pre-hook logic
    originalFunc(param);
    // Post-hook logic
}

// Direct address
Hook<SomeFunc_t> hook(reinterpret_cast<SomeFunc_t>(0x12345678), MyDetour);
hook.Attach();

// Hash-based
Hook<SomeFunc_t> hashHook(0xABCDEF01, MyDetour);
hashHook.Attach(); // Address resolved from Addresses singleton

// ... later
hook.Detach();
```

# Related Concepts

- For game state vtable hooking, see [GameStateHook<T>](/hooks/gamestate-hook-template.md)
- The SDK also exposes [Hooking::Attach/Detach](/apis/sdk-functions.md) for runtime-managed hooks

# Citations

[1] [src/dll/Hook.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/Hook.hpp)
