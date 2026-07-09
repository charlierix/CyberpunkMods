---
type: Reference
title: Plugin Lifecycle
description: Plugin entry point contract — the three exports every RED4ext plugin must implement.
resource: src/playground/Main.cpp
tags: [plugin, lifecycle, exports, entry-point]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

Every RED4ext plugin is a DLL that exports three C functions. The runtime calls these in order: `Supports` to query the API version, `Query` to populate plugin metadata, and `Main` for load/unload lifecycle events. This contract is the integration point between a plugin and the RED4ext runtime.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `Main` | Exported function | Called on load and unload; receives plugin handle, reason, and SDK pointer |
| `Query` | Exported function | Populates `RED4ext::v1::PluginInfo` with name, author, version, runtime, and SDK version |
| `Supports` | Exported function | Returns the highest API version the plugin supports |

# Export Details

## `Main`

```cpp
RED4EXT_C_EXPORT bool RED4EXT_CALL Main(
    RED4ext::v1::PluginHandle aHandle,
    RED4ext::v1::EMainReason aReason,
    const RED4ext::v1::Sdk* aSdk
);
```

- **aHandle** — opaque handle identifying this plugin instance; pass it to SDK functions
- **aReason** — `EMainReason::Load` or `EMainReason::Unload`
- **aSdk** — pointer to the SDK struct containing function pointers for logging, hooking, game states, and scripts
- **Returns** — `true` on success; returning `false` on load aborts plugin initialization

## `Query`

```cpp
RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo);
```

Populates the `PluginInfo` struct:

| Field | Type | Example |
|-------|------|---------|
| `name` | `wchar_t*` | `L"MyPlugin"` |
| `author` | `wchar_t*` | `L"AuthorName"` |
| `version` | `SemVer` | `RED4EXT_V1_SEMVER(1, 0, 0)` |
| `runtime` | `FileVer` | `RED4EXT_V1_RUNTIME_VERSION_LATEST` |
| `sdk` | `SemVer` | `RED4EXT_V1_SDK_VERSION_CURRENT` |

## `Supports`

```cpp
RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports();
```

Returns the API version the plugin was built against (e.g. `RED4EXT_API_VERSION_1`). The runtime uses this to instantiate the correct [PluginBase](/plugin-contract/plugin-base.md) subclass.

# Example

From `src/playground/Main.cpp`:

```cpp
RED4EXT_C_EXPORT bool RED4EXT_CALL Main(RED4ext::v1::PluginHandle aHandle,
                                         RED4ext::v1::EMainReason aReason,
                                         const RED4ext::v1::Sdk* aSdk)
{
    switch (aReason)
    {
    case RED4ext::v1::EMainReason::Load:
        // Initialize plugin, attach hooks, register game states
        break;
    case RED4ext::v1::EMainReason::Unload:
        // Detach hooks, free resources
        break;
    }
    return true;
}

RED4EXT_C_EXPORT void RED4EXT_CALL Query(RED4ext::v1::PluginInfo* aInfo)
{
    aInfo->name = L"RED4ext.Playground";
    aInfo->author = L"WopsS";
    aInfo->version = RED4EXT_V1_SEMVER(1, 0, 0);
    aInfo->runtime = RED4EXT_V1_RUNTIME_VERSION_LATEST;
    aInfo->sdk = RED4EXT_V1_SDK_VERSION_CURRENT;
}

RED4EXT_C_EXPORT uint32_t RED4EXT_CALL Supports()
{
    return RED4EXT_API_VERSION_1;
}
```

# Related Concepts

- The runtime creates a [PluginBase](/plugin-contract/plugin-base.md) instance from the exported info
- Use the SDK's [Logger API](/apis/logging.md) for plugin logging
- Call [SDK functions](/apis/sdk-functions.md) for hooking, game states, and scripts

# Citations

[1] [src/playground/Main.cpp](https://github.com/WopsS/RED4ext/blob/main/src/playground/Main.cpp)
