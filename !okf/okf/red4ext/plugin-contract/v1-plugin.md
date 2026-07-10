---
type: Class
title: v1::Plugin
description: Concrete v1 plugin implementation that assembles the SDK struct with function pointers for logging, hooking, game states, and scripts.
resource: src/dll/v1/Plugin.hpp
tags: [plugin, v1, sdk, implementation]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

`v1::Plugin` is the concrete implementation of [PluginBase](/plugin-contract/plugin-base.md) for API version 1. Its constructor populates the `RED4ext::v1::Sdk` struct with function pointers from the [Logger](/apis/logging.md), [Hooking/GameStates/Scripts](/apis/sdk-functions.md) APIs, which are then passed to the plugin's exported `Main` function.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `v1::Plugin` | Class | Concrete `PluginBase` subclass for API v1 |

# Class Definition

```cpp
namespace v1
{
class Plugin : public PluginBase
{
public:
    Plugin(const std::filesystem::path& aPath, wil::unique_hmodule aModule);

    const uint32_t GetApiVersion() const final;
    void* GetPluginInfo() final;
    const void* GetSdkStruct() const final;

    virtual const std::wstring_view GetName() const final;
    virtual const std::wstring_view GetAuthor() const final;
    virtual const RED4ext::v1::SemVer& GetVersion() const final;
    virtual const RED4ext::v1::FileVer& GetRuntimeVersion() const final;
    virtual const RED4ext::v1::SemVer& GetSdkVersion() const final;

private:
    RED4ext::v1::PluginInfo m_info;
    RED4ext::v1::Sdk m_sdk;
    RED4ext::v1::SemVer m_runtime;
    RED4ext::v1::Logger m_logger;
    RED4ext::v1::Hooking m_hooking;
    RED4ext::v1::GameStates m_gameStates;
    RED4ext::v1::Scripts m_scripts;
};
} // namespace v1
```

# SDK Struct Assembly

The constructor wires function pointers into SDK sub-structs:

| SDK field | Sub-struct | Source functions |
|-----------|-----------|------------------|
| `m_sdk.runtime` | `SemVer` | `Image::Get()->GetProductVersion()` |
| `m_sdk.logger` | `Logger` | All 24 functions from [v1::Logger](/apis/logging.md) |
| `m_sdk.hooking` | `Hooking` | `v1::Hooking::Attach`, `v1::Hooking::Detach` |
| `m_sdk.gameStates` | `GameStates` | `v1::GameStates::Add` |
| `m_sdk.scripts` | `Scripts` | `v1::Scripts::Add`, `RegisterNeverRefType`, `RegisterMixedRefType` |

# Method Implementations

| Method | Returns | Description |
|--------|---------|-------------|
| `GetApiVersion()` | `RED4EXT_API_VERSION_1` | Returns the constant API version |
| `GetPluginInfo()` | `&m_info` | Pointer to the populated `PluginInfo` struct |
| `GetSdkStruct()` | `&m_sdk` | Pointer to the assembled `Sdk` struct |
| `GetName()` | `m_info.name` | Plugin name from `Query()` |
| `GetAuthor()` | `m_info.author` | Plugin author from `Query()` |
| `GetVersion()` | `m_info.version` | Plugin SemVer from `Query()` |
| `GetRuntimeVersion()` | `m_info.runtime` | Target runtime version from `Query()` |
| `GetSdkVersion()` | `m_info.sdk` | SDK version from `Query()` |

# Private Members

| Member | Type | Description |
|--------|------|-------------|
| `m_info` | `PluginInfo` | Populated by the plugin's exported `Query` function |
| `m_sdk` | `Sdk` | Struct passed to the plugin's `Main` function |
| `m_runtime` | `SemVer` | Game runtime version from the PE image |
| `m_logger` | `Logger` | SDK logger sub-struct with 24 function pointers |
| `m_hooking` | `Hooking` | SDK hooking sub-struct with Attach/Detach |
| `m_gameStates` | `GameStates` | SDK game states sub-struct with Add |
| `m_scripts` | `Scripts` | SDK scripts sub-struct with Add + type registration |

# Related Concepts

- Inherits from [PluginBase](/plugin-contract/plugin-base.md)
- Populates the SDK's [Logger struct](/apis/logging.md) with function pointers
- Populates the SDK's [Hooking/GameStates/Scripts structs](/apis/sdk-functions.md) with function pointers

# Citations

[1] [src/dll/v1/Plugin.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Plugin.hpp)
[2] [src/dll/v1/Plugin.cpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/v1/Plugin.cpp)
