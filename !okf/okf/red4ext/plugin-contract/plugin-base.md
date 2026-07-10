---
type: Class
title: PluginBase
description: Abstract base class for plugins providing Query, Main, and metadata accessors.
resource: src/dll/PluginBase.hpp
tags: [plugin, base-class, abstract, lifecycle]
timestamp: 2026-07-08T13:27:00Z
---

# Overview

`PluginBase` is the abstract base class that the RED4ext runtime uses to manage a loaded plugin. It stores the plugin's DLL path and module handle, and delegates version-specific behavior to pure virtual methods implemented by subclasses such as [v1::Plugin](/plugin-contract/v1-plugin.md).

The runtime calls `Query()` to populate plugin info and `Main()` with an `EMainReason` to drive load/unload lifecycle events.

# Member Types

| Type | Kind | Description |
|------|------|-------------|
| `PluginBase` | Class | Abstract base for all plugin versions |

# Class Definition

```cpp
class PluginBase
{
public:
    PluginBase(const std::filesystem::path& aPath, wil::unique_hmodule aModule);
    virtual ~PluginBase() = default;

    virtual const uint32_t GetApiVersion() const = 0;
    virtual void* GetPluginInfo() = 0;
    virtual const void* GetSdkStruct() const = 0;

    virtual const std::wstring_view GetName() const = 0;
    virtual const std::wstring_view GetAuthor() const = 0;
    virtual const RED4ext::v1::SemVer& GetVersion() const = 0;
    virtual const RED4ext::v1::FileVer& GetRuntimeVersion() const = 0;
    virtual const RED4ext::v1::SemVer& GetSdkVersion() const = 0;

    const std::filesystem::path& GetPath() const;
    HMODULE GetModule() const;

    bool Query();
    bool Main(RED4ext::v1::EMainReason aReason);

private:
    std::filesystem::path m_path;
    wil::unique_hmodule m_module;
};
```

# Methods

## Public API

| Method | Return type | Description |
|--------|-------------|-------------|
| `PluginBase(path, module)` | — | Constructor; stores DLL path and module handle |
| `~PluginBase()` | virtual | Virtual default destructor |
| `GetApiVersion()` | `uint32_t` | Pure virtual — returns the API version (e.g. `RED4EXT_API_VERSION_1`) |
| `GetPluginInfo()` | `void*` | Pure virtual — returns pointer to the plugin info struct |
| `GetSdkStruct()` | `const void*` | Pure virtual — returns pointer to the SDK struct passed to `Main()` |
| `GetName()` | `wstring_view` | Pure virtual — returns plugin name |
| `GetAuthor()` | `wstring_view` | Pure virtual — returns plugin author |
| `GetVersion()` | `SemVer&` | Pure virtual — returns plugin semantic version |
| `GetRuntimeVersion()` | `FileVer&` | Pure virtual — returns target game runtime version |
| `GetSdkVersion()` | `SemVer&` | Pure virtual — returns SDK version the plugin was built against |
| `GetPath()` | `filesystem::path&` | Returns the DLL file path |
| `GetModule()` | `HMODULE` | Returns the loaded module handle |
| `Query()` | `bool` | Calls the plugin's exported `Query` function via the module |
| `Main(reason)` | `bool` | Calls the plugin's exported `Main` function with the SDK struct |

## Private Members

| Member | Type | Description |
|--------|------|-------------|
| `m_path` | `std::filesystem::path` | Path to the plugin DLL on disk |
| `m_module` | `wil::unique_hmodule` | RAII wrapper around the Windows `HMODULE` |

# Related Concepts

- The concrete v1 implementation is [v1::Plugin](/plugin-contract/v1-plugin.md)
- See [Plugin Lifecycle](/plugin-contract/plugin-lifecycle.md) for the export contract that `Query()` and `Main()` invoke

# Citations

[1] [src/dll/PluginBase.hpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/PluginBase.hpp)
[2] [src/dll/PluginBase.cpp](https://github.com/WopsS/RED4ext/blob/main/src/dll/PluginBase.cpp)
