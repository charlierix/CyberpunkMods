---
okf_version: "0.1"
---

# Cyberpunk 2077 RED4EXT Mods — Game Mechanic Manipulation Patterns

An OKF knowledge bundle documenting how mods manipulate Cyberpunk 2077 game mechanics. 
Concepts are organized by **game system → manipulation approach**, not by mod name. 
Each concept file documents a technique (e.g., hit event wrapping, TweakDB damage record modification) 
and references the mods that demonstrate it.

**521 source mods** analyzed across `/a0/usr/projects/okf_builder/sources/mods_red4ext`. 
**93 concept files** across **8 categories**.

## Categories

* [Combat](./combat/) — 9 concepts
* [Economy](./economy/) — 6 concepts
* [Media](./media/) — 8 concepts
* [Player](./player/) — 17 concepts
* [Systems](./systems/) — 22 concepts
* [Ui](./ui/) — 20 concepts
* [Vehicle](./vehicle/) — 6 concepts
* [World](./world/) — 5 concepts

## How to Use This Bundle

1. Browse by category to find all manipulation patterns for a game system.
2. Open a concept file to understand the technique and see representative mod examples.
3. Each example includes the mod folder name, source file path (relative to mod folder), and a one-line note.
4. Cross-links connect related concepts (e.g., damage patterns link to weapon patterns).

## Code Types

| Type | Description |
|------|-------------|
| REDScript (.reds) | Native game script extensions via @wrapMethod, @replaceMethod, @addMethod |
| CET Lua (.lua) | Cyber Engine Tweaks runtime overrides via Observe/Override |
| TweakDB (.yaml) | Static game data modifications via YAML tweak files |
| Archive | Visual asset replacements (no code) |
