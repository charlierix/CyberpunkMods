---
type: Class
title: Scriptable Tweak
description: Abstract native class for creating scriptable tweaks with custom apply logic.
resource: sources/TweakXL/scripts/ScriptableTweak.reds
tags: [tweakxl, redscript, scriptable, tweak, abstract]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

`ScriptableTweak` is an abstract native class that serves as the base class for scriptable tweaks — tweaks that require complex logic or dynamic changes beyond what declarative YAML or RED tweaks can express. Modders subclass `ScriptableTweak` and implement the `OnApply` callback to perform their TweakDB modifications.

This is the entry point for the script extensions feature of TweakXL, allowing mods to add arbitrary Redscript logic to the tweak application pipeline.

# Member Types

| Type | Kind | Source File | Key Members |
|------|------|------------|-------------|
| ScriptableTweak | Abstract native class | scripts/ScriptableTweak.reds | `OnApply()` callback |

# Methods

### ScriptableTweak.OnApply

```reds
protected cb func OnApply() -> Void
```

The callback invoked when the scriptable tweak is applied. Subclasses override this method to execute custom TweakDB operations using the [TweakDB API](/apis/tweakdb-api.md). This is a `cb func` (callback function) marked `protected`, so only subclasses can invoke it.

# Usage Example

```reds
public class MyCustomTweak extends ScriptableTweak {
    protected cb func OnApply() -> Void {
        let batch = TweakDBManager.StartBatch();
        batch.SetFlat(TDBID.Create("Items.BasePistol.damage"), 75.0);
        batch.Commit();
    }
}
```

# Related Concepts

- [TweakDB API](/apis/tweakdb-api.md) — Used inside OnApply for TweakDB operations
- [TweakXL Core](/apis/tweakxl-core.md) — Framework version checking

# Citations

- [ScriptableTweak.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/ScriptableTweak.reds)
- [Script Extensions Wiki](https://github.com/psiberx/cp2077-tweak-xl/wiki/Script-Extensions)
