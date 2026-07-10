# Bundle Update Log

## 2026-07-04
* **Update**: Added `modding/` category for non-game-mechanic patterns.
* **Addition**: ImGui UI rendering concepts (immediate-mode rendering, styling/theming, interaction patterns, custom controls) — 423 mods covered.
* **Addition**: Data & utility concepts (SQLite databases, file I/O, JSON serialization, config persistence) — covers 345+ mods.
* **Gap fix**: Previous bundle only covered native game APIs (inkWidget, GetSingleton). Now covers ImGui, SQLite, file I/O, JSON, and config persistence patterns used by CET Lua mods.

## 2026-07-04

* **Creation**: Built complete OKF mods bundle from `mods/` source collection.
* **Structure**: 7 categories, 4 folder concepts with sub-approaches, 33 flat concepts.
* **Source**: 975 mods scanned, 13,094 code files analyzed, 1.4M pattern matches processed.
* **Approach**: Concepts are game mechanic manipulation patterns (not mods). Each concept file documents a technique with representative mod file references as examples.
