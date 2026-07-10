---
type: API
title: RED4ext C++ API
description: C++ header for RED4ext plugin integration with ArchiveXL runtime.
resource: https://github.com/psiberx/cp2077-archive-xl/tree/main/support/red4ext
tags: [red4ext, cpp, api, plugin]
timestamp: 2026-07-09T00:43:14Z
---

# Overview

The RED4ext C++ API provides a header-only `ArchiveXL` class that allows other RED4ext plugins to register custom archives and archive directories with the ArchiveXL runtime. It uses RTTI to call into the ArchiveXL Redscript facade at runtime.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| ArchiveXL | C++ class | Static utility class for registering archives with ArchiveXL |

# Public Methods

| Method | Signature | Description |
|--------|-----------|-------------|
| RegisterArchive | `static bool RegisterArchive(std::filesystem::path aPath)` | Registers a single archive file at the given path |
| RegisterArchive | `static bool RegisterArchive(HMODULE aHandle, std::filesystem::path aPath)` | Registers an archive relative to a module handle |
| RegisterArchives | `static bool RegisterArchives(std::filesystem::path aPath)` | Registers all archives in a directory |
| RegisterArchives | `static bool RegisterArchives(HMODULE aHandle, std::filesystem::path aPath)` | Registers all archives in a directory relative to a module handle |

# Internal Methods

| Method | Visibility | Description |
|--------|-----------|-------------|
| Initialize | private | Initializes the RTTI facade by looking up the `ArchiveXL` class and its `Version` function |
| RegisterPathOrQueue | private | Registers a path immediately or queues it for later if ArchiveXL is not yet loaded |
| RegisterPath | private | Calls `RegisterArchive` or `RegisterDir` on the ArchiveXL RTTI facade |
| RegisterPendingPaths | private | Flushes queued paths once ArchiveXL is initialized, or re-queues via post-register callback |
| GetModulePath | private | Resolves a module handle to its parent directory path |

# Static State

| Member | Type | Description |
|--------|------|-------------|
| s_facade | `RED4ext::CClass*` | Cached RTTI class pointer to the ArchiveXL facade |
| s_paths | `std::vector<std::filesystem::path>` | Queue of paths pending registration |

# Usage Example

```cpp
#include <ArchiveXL.hpp>

// Register a single archive
ArchiveXL::RegisterArchive(GetModuleHandle(nullptr), "plugins\my_mod\my_mod.archive");

// Register all archives in a directory
ArchiveXL::RegisterArchives(GetModuleHandle(nullptr), "plugins\my_mod\archives\");
```

# Dependencies

- RED4ext SDK (`RED4ext/Callback.hpp`, `RED4ext/Memory/Allocators.hpp`, `RED4ext/RTTISystem.hpp`)
- Windows API (`libloaderapi.h`, `minwindef.h`)
- C++17 `<filesystem>`

# Citations

[1] [ArchiveXL.hpp](https://github.com/psiberx/cp2077-archive-xl/blob/main/support/red4ext/ArchiveXL.hpp)
