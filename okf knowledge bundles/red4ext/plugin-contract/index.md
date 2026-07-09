# Plugin-Contract

3 concepts in plugin-contract

- [PluginBase](./plugin-base.md) — Abstract base class for plugins providing Query, Main, and metadata accessors.
- [Plugin Lifecycle](./plugin-lifecycle.md) — Plugin entry point contract — the three exports every RED4ext plugin must implement.
- [v1::Plugin](./v1-plugin.md) — Concrete v1 plugin implementation that assembles the SDK struct with function pointers for logging, hooking, game states, and scripts.
