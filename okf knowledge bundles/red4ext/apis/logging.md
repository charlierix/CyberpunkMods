---
type: API
title: v1::Logger
description: Logging API exposed to plugins with 6 levels in narrow/wide and plain/format variants — 24 functions total.
resource: src/dll/v1/Logger.hpp
tags: [logging, api, v1, trace, debug, info, warn, error, critical]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

The `v1::Logger` namespace provides a structured logging API that plugins call through the SDK's `Logger` struct. It offers six severity levels, each available in four variants: narrow-char plain, narrow-char format, wide-char plain, and wide-char format. Every function takes a `PluginHandle` as its first argument to identify the calling plugin in log output.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `v1::Logger` | Namespace | 24 free functions for plugin logging |

# Complete Function Listing

## Trace (6 levels × 4 variants = 24 functions)

| Level | Narrow plain | Narrow format | Wide plain | Wide format |
|-------|-------------|---------------|------------|-------------|
| Trace | `Trace(handle, msg)` | `TraceF(handle, fmt, ...)` | `TraceW(handle, msg)` | `TraceWF(handle, fmt, ...)` |
| Debug | `Debug(handle, msg)` | `DebugF(handle, fmt, ...)` | `DebugW(handle, msg)` | `DebugWF(handle, fmt, ...)` |
| Info | `Info(handle, msg)` | `InfoF(handle, fmt, ...)` | `InfoW(handle, msg)` | `InfoWF(handle, fmt, ...)` |
| Warn | `Warn(handle, msg)` | `WarnF(handle, fmt, ...)` | `WarnW(handle, msg)` | `WarnWF(handle, fmt, ...)` |
| Error | `Error(handle, msg)` | `ErrorF(handle, fmt, ...)` | `ErrorW(handle, msg)` | `ErrorWF(handle, fmt, ...)` |
| Critical | `Critical(handle, msg)` | `CriticalF(handle, fmt, ...)` | `CriticalW(handle, msg)` | `CriticalWF(handle, fmt, ...)` |

# Function Signatures

All functions share the same pattern:

```cpp
// Narrow-char plain
void Level(RED4ext::v1::PluginHandle aHandle, const char* aMessage);

// Narrow-char format (printf-style)
void LevelF(RED4ext::v1::PluginHandle aHandle, const char* aFormat, ...);

// Wide-char plain
void LevelW(RED4ext::v1::PluginHandle aHandle, const wchar_t* aMessage);

// Wide-char format (wprintf-style)
void LevelWF(RED4ext::v1::PluginHandle aHandle, const wchar_t* aFormat, ...);
```

# Usage

Plugins access logging through the SDK struct passed to `Main()`:

```cpp
RED4EXT_C_EXPORT bool RED4EXT_CALL Main(
    RED4ext::v1::PluginHandle aHandle,
    RED4ext::v1::EMainReason aReason,
    const RED4ext::v1::Sdk* aSdk)
{
    if (aReason == RED4ext::v1::EMainReason::Load)
    {
        aSdk->logger->Info(aHandle, "Plugin loaded successfully");
        aSdk->logger->InfoF(aHandle, "Plugin version: %d.%d.%d", 1, 0, 0);
    }
    return true;
}
```

# Severity Levels

| Level | Typical use |
|-------|-------------|
| Trace | Very detailed flow tracing, usually disabled in release |
| Debug | Diagnostic information for development |
| Info | General informational messages |
| Warn | Non-critical issues that warrant attention |
| Error | Errors that the plugin can recover from |
| Critical | Severe errors that may require termination |

# Related Concepts

- The [v1::Plugin](/plugin-contract/v1-plugin.md) constructor populates the SDK `Logger` struct with these function pointers

# Citations

[1] [src/dll/v1/Logger.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Logger.hpp)
[2] [src/dll/v1/Logger.cpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Logger.cpp)
