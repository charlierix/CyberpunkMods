---
type: Mechanic Pattern
title: Lua OOP Patterns
description: Object-oriented programming in Lua using setmetatable, __index metamethods, and :new() constructor patterns across CET mods.
tags: [lua, cet, oop, setmetatable, metatables, classes, constructors]
timestamp: 2026-07-04T00:00:00Z
---

## Approach

Lua does not have native class-based OOP, but Cyberpunk 2077 CET mods establish strong conventions for simulating it using metatables. The dominant pattern uses `setmetatable` with an `__index` metamethod to create prototype-based inheritance, and a `:new()` factory method to instantiate objects with proper metatable linkage.

**Canonical constructor pattern:**

```lua
local MyClass = {}
MyClass.__index = MyClass

function MyClass:new()
    local o = setmetatable({}, self)
    o.field = nil  -- instance fields
    return o
end

function MyClass:method()
    -- instance method using self
end
```

Key characteristics:
- `setmetatable(obj, self)` with `__index = self` creates prototype inheritance where instances fall back to the class table for methods
- The `:new()` method is the conventional factory; `:` syntax binds `self` automatically
- Module-level `setmetatable(Module, {__index = ...})` is used for static-like module composition
- Shared libraries (GameSession, GameUI, cpstyling) are vendored across many mods, each using metatables internally
- `__index` can point to either a table (prototype lookup) or a function (custom indexing)

## Representative Examples

| Mod | File | Note |
|-----|------|------|
| 0-Engine Pure CET | `mods/lua/0-Engine Pure CET-27967-0-17-2-1773872517/bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua` (L1065) | `setmetatable(GameSession, {...})` for module-level OOP with session state |
| Appearance Creator Mod | `mods/lua/Appearance Creator Mod-10795-1-0-1-1699493978/bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/External/BigNum.lua` (L985) | `setmetatable(bignum, BigNum.mt)` for arbitrary-precision number class |
| Cyberscript Core | `mods/lua/Cyberscript Core-6475-5-1-4-1747724577/bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua` (L645) | `setmetatable(o, self)` for UI styling object factory |
| Equipment-Ex unlocker | `mods/lua/Equipment-Ex unlocker-11444-2-1-1703019878/bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/colour.lua` (L196) | `setmetatable({}, {__index = ...})` for Colour library with method chaining |
| ghost_forward | `mods/lua/ghost_forward/init.lua` (L153) | `GameObjectAccessor:new(wrappers)` constructor for game object access layer |
| grappling_hook | `mods/lua/grappling_hook/core/animation_curve.lua` (L196) | `AnimationCurve:new()` factory for bezier curve interpolation |
| Improved Neon Rims Controls | `mods/lua/Improved Neon Rims Controls - CET and UI only-5622-2-1-0-1685232197/bin/x64/plugins/cyber_engine_tweaks/mods/DWN_ToggleNeonRims/init.lua` | `DWN_ToggleNeonRims:new()` class with toggle state management |
| Interactive Accessories | `mods/lua/Interactive Accessories-22472-1-0-1751421384/bin/x64/plugins/cyber_engine_tweaks/mods/InteractiveAccessories/modules/accessory.lua` (L109) | `accessory:new()` object factory for wearable items |

*574 more mods use this pattern*

## Related Concepts

- [Error Handling](error-handling.md) — pcall frequently wraps :new() constructors for safe instantiation
- [String Operations](string-operations.md) — OOP objects often encapsulate string formatting methods
- [Math Operations](math-operations.md) — Math utility classes use setmetatable for fluent API design
