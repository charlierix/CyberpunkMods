---
type: Class
title: TweakXL Core
description: Core framework class with version checking and Redscript module declaration.
resource: sources/TweakXL/scripts/TweakXL.reds
tags: [tweakxl, redscript, version, core]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

TweakXL is a modding tool and framework for modifying TweakDB — the proprietary database of REDengine 4 that stores essential information about game entities and behavior in Cyberpunk 2077. The core module provides version checking capabilities and the Redscript module declaration that all other TweakXL scripts depend on.

TweakXL supports YAML and RED declarative tweak formats, script extensions for complex logic, and hot reloading for development speed. It targets Cyberpunk 2077 2.3 with redscript 0.5.27+ and RED4ext 1.28.0+.

# Member Types

| Type | Kind | Source File | Key Members |
|------|------|------------|-------------|
| TweakXL | Abstract native class | scripts/TweakXL.reds | `Require(version: String) -> Bool`, `Version() -> String` |
| TweakXL (module) | Redscript module | scripts/Module.reds | `module TweakXL` |

# Methods

### TweakXL.Require

```reds
public static native func Require(version: String) -> Bool
```

Checks whether the loaded TweakXL version meets or exceeds the specified version string. Returns `true` if the requirement is satisfied, `false` otherwise. Used by mods to assert a minimum TweakXL version at runtime.

### TweakXL.Version

```reds
public static native func Version() -> String
```

Returns the current TweakXL version as a string (e.g. `"1.10.3"`).

# Dependencies

- **redscript** 0.5.27+ — Redscript compiler/runtime
- **RED4ext** 1.28.0+ — Plugin framework providing native function bindings
- The native `TweakXL` class is implemented in the C++ RED4ext plugin; see [RED4ext C++ Header](/apis/red4ext-header.md)

# Related Concepts

- [TweakDB API](/apis/tweakdb-api.md) — TweakDB record manipulation classes
- [Scriptable Tweak](/apis/scriptable-tweaks.md) — Abstract class for scriptable tweak types

# Citations

- [TweakXL.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/TweakXL.reds)
- [Module.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/Module.reds)
- [README.md](https://github.com/psiberx/cp2077-tweak-xl/blob/main/README.md)
