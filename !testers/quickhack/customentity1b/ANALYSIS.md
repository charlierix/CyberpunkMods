## OrbHackingBridge Not Loaded — Root Cause & Path Forward

### Short Answer

**Yes, you need Red4ext.** Redscript + CET alone cannot create a class that inherits from `Drone`. The "OrbHackingBridge not loaded" error is a Redscript **compilation failure**, not a runtime issue.

---

### Answering Your Specific Questions

**"Is this because OrbHackingBridge is outside the inheritance chain of the spawned drone?"**

It's the opposite — `OrbHackingBridge` *tries* to be inside the inheritance chain (`extends Drone`), but Redscript **won't let it join**. The `Drone` class is a **native C++ class** in the game's `die` module. Redscript can *see* it and *call methods on existing instances*, but it **cannot create new classes that inherit from native classes**. The compiler literally rejects `extends Drone` and says:

> `'Drone' class not found in scope. Did you mean 'ScriptablePuppet'?`
> `alternatives: ScriptablePuppet, ScriptablePuppetComponent, GenericDroneMaster`

The error message is misleading — `Drone` IS visible to Redscript, but only for method calls, **not for inheritance**. The "not found in scope" refers specifically to the inheritance scope, not visibility.

**"Or is OrbHackingBridge more of an expansion of some base class?"**

`OrbHackingBridge` is a **custom class name** you/previous work created — it doesn't exist in the game. The intent was to expand/extend the `Drone` class to add custom hacking behavior. That's a valid design goal, but it requires C++ RTTI access that only Red4ext provides.

**"Should we keep spinning on only using redscript and cet, or do we need red4ext?"**

You need **Red4ext** if you want true `Drone` inheritance. Here are your three options:

---

### The Drone Class Hierarchy

```
ScriptableEntity → ScriptablePuppet → Drone
```

| Capability | Redscript | CET | Red4ext |
|---|---|---|---|
| Call methods on existing Drone | Yes | Yes | Yes |
| Extend/inherit from Drone | No | No | Yes |
| Register new RTTI type | No | No | Yes |
| Hook native C++ functions | No | No | Yes |
| Extend ScriptablePuppet | Yes | No | Yes |

`Drone` is marked as `native` in RTTI — implemented in C++. Redscript's inheritance system only works with classes marked as `scriptable`. `Drone` is not scriptable for inheritance.

---

### Your Three Options

#### Option A: Red4ext (Recommended)

Create a C++ plugin that extends `Drone` directly:

```cpp
// Red4ext — this WORKS
class OrbHackingBridge : public Drone {
    // Full drone behavior (flight, AI, hacking) + your custom additions
};
```

- **Pros**: Gets all native Drone behavior, can hook/override virtual methods, true inheritance, game treats it as a legitimate Drone subclass
- **Cons**: Requires C++ compilation, Red4ext plugin setup, more complex deployment
- Your `customentity1/red4ext/README.md` already documents this plan — it's a skeleton waiting for implementation

#### Option B: Redscript + ScriptablePuppet (Limited)

```reds
// Redscript — this compiles, but no drone behavior
public class OrbHackingBridge extends ScriptablePuppet {
    // You get a new scriptable entity, but NO flight, NO drone AI, NO hacking
    // You'd have to reimplement ALL drone behavior from scratch
}
```

- **Pros**: Stays in Redscript, no C++ needed
- **Cons**: No native drone behavior whatsoever — you'd be building a custom entity from the puppet level up, which is a massive undertaking

#### Option C: Spawn Existing Drone + CET Control (Workaround)

```lua
-- CET — spawn a standard game drone, then control it
local drone = exEntitySpawner.Spawn("base\\gameplay\\devices\\drone.rdeent", playerPos)
if drone then
    -- Call methods, set properties via CET
    -- But can't add new class-level behavior through inheritance
end
```

- **Pros**: Simplest, no new class needed, works with existing Redscript + CET setup
- **Cons**: No custom class, no new entity type, limited to what existing Drone methods/properties expose

---

### What Happened in customentity1 to customentity1b

1. **customentity1**: Tried `extends Drone` in Redscript → compilation failed → `OrbHackingBridge not loaded` → created a `red4ext/README.md` skeleton documenting the need for Red4ext
2. **customentity1b**: Same approach, same failure — the Redscript package never compiled, so the CET hotkey had no entity class to spawn

The spawn failure you saw in customentity1 (entity paths returning nil) was a separate but related issue — even if the Redscript had compiled, the entity template paths likely weren't valid. But the **root cause** of the "OrbHackingBridge not loaded" error is the native class inheritance limitation.

---

### Recommendation

Stop spinning on Redscript-only. Move to **Option A (Red4ext)** — your `customentity1/red4ext/README.md` already has the right plan. The next step is to write the actual C++ Red4ext plugin that extends `Drone` via RTTI. The `okf/red4ext/` docs and `docs/c++ hooks/` have the plugin contract and hooking examples to get started.

If you want a faster prototype first, **Option C** (spawn existing drone + CET control) can get you a working drone in-game immediately while the Red4ext plugin is being developed.