---
type: API
title: RED4ext C++ Header
description: C++ header class for RED4ext plugins to register tweaks with TweakXL at the native level.
resource: sources/TweakXL/support/red4ext/TweakXL.hpp
tags: [tweakxl, red4ext, cpp, header, native, plugin]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

The `TweakXL.hpp` header provides a C++ API for RED4ext plugin developers to register tweak files (YAML, RED) and tweak directories with TweakXL from native code. It handles deferred registration via RTTI callbacks when TweakXL's Redscript facade is not yet available, and resolves paths relative to the calling module.

This is the native-side counterpart to the Redscript [TweakXL Core](/apis/tweakxl-core.md) class. The C++ class calls into the Redscript `TweakXL` class via RTTI function execution (`RegisterTweak` / `RegisterDir`).

# Member Types

| Type | Kind | Source File | Key Members |
|------|------|------------|-------------|
| TweakXL | C++ static class | support/red4ext/TweakXL.hpp | RegisterTweak, RegisterTweaks, Initialize, RegisterPathOrQueue, RegisterPath, RegisterPendingPaths, GetModulePath |

# Public API

### TweakXL::RegisterTweak(path)

```cpp
static bool RegisterTweak(std::filesystem::path aPath)
```

Registers a single tweak file. Returns `false` if the path does not exist or is not a regular file.

### TweakXL::RegisterTweak(handle, path)

```cpp
static bool RegisterTweak(HMODULE aHandle, std::filesystem::path aPath)
```

Registers a tweak file relative to the calling module's directory. Resolves relative paths using `GetModulePath(aHandle)`.

### TweakXL::RegisterTweaks(path)

```cpp
static bool RegisterTweaks(std::filesystem::path aPath)
```

Registers a directory of tweak files. Returns `false` if the path does not exist or is not a directory.

### TweakXL::RegisterTweaks(handle, path)

```cpp
static bool RegisterTweaks(HMODULE aHandle, std::filesystem::path aPath)
```

Registers a directory of tweak files relative to the calling module's directory.

# Internal Methods

| Method | Visibility | Description |
|--------|-----------|-------------|
| Initialize | private static | Checks if TweakXL's RTTI facade is available; sets `s_facade` |
| RegisterPathOrQueue | private static | If initialized, registers immediately; otherwise queues the path for deferred registration |
| RegisterPath | private static | Executes `RegisterTweak` or `RegisterDir` via RTTI on the `TweakXL` Redscript class |
| RegisterPendingPaths | private static | Flushes queued paths once RTTI is ready; re-registers callback if still not ready |
| GetModulePath | private static | Returns the parent directory of the given HMODULE |

# Static State

| Member | Type | Description |
|--------|------|-------------|
| s_facade | `RED4ext::CClass*` | Cached RTTI class pointer for the Redscript `TweakXL` class |
| s_paths | `std::vector<std::filesystem::path>` | Queue of paths awaiting registration when RTTI is not yet ready |

# Deferred Registration Flow

1. Plugin calls `RegisterTweak` or `RegisterTweaks` during module load
2. If TweakXL's RTTI facade is not yet available, the path is queued in `s_paths`
3. `RegisterPendingPaths` is called via `AddPostRegisterCallback` — a RED4ext RTTI lifecycle hook
4. Once RTTI registration completes, queued paths are flushed and registered via `RegisterPath`

# Dependencies

- **RED4ext SDK** — `RED4ext::CRTTISystem`, `RED4ext::CClass`, `RED4ext::CStackType`, `RED4ext::Callback`
- **Windows API** — `HMODULE`, `GetModuleFileNameW`, `MAX_PATH`
- **C++17** — `std::filesystem`

# Usage Example

```cpp
#include <TweakXL.hpp>

// Register a single tweak file relative to the plugin's directory
TweakXL::RegisterTweak(hModule, "tweaks/my_tweak.yaml");

// Register an entire directory of tweaks
TweakXL::RegisterTweaks(hModule, "tweaks/");
```

# Related Concepts

- [TweakDB API](/apis/tweakdb-api.md) — The Redscript-side TweakDB operations this header hooks into
- [TweakXL Core](/apis/tweakxl-core.md) — The Redscript class whose `Version()` function is checked during initialization

# Citations

- [TweakXL.hpp](https://github.com/psiberx/cp2077-tweak-xl/blob/main/support/red4ext/TweakXL.hpp)
- [RED4ext Documentation](https://docs.red4ext.com)
