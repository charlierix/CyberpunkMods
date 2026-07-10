---
type: Mechanic Pattern
title: "ImGui Immediate-Mode Rendering"
description: "ImGui.Begin/End window lifecycle, nested containers, and tab/child window composition patterns"
tags: [ui, imgui, rendering, cet]
timestamp: 2026-07-04T00:00:00Z
---

# ImGui Immediate-Mode Rendering

Dear ImGui uses an immediate-mode paradigm where the entire UI is rebuilt every frame. CET mods call `ImGui.Begin()` to open a window, render widgets inside the returned block, and call `ImGui.End()` to close it. Nested containers like `BeginChild`, `BeginTabBar`/`BeginTabItem`, `BeginDisabled`/`EndDisabled`, and `BeginTable`/`EndTable` compose complex layouts within this Begin/End envelope.

## Approach

The core pattern is:

```lua
if ImGui.Begin("WindowName", open_var, window_flags) then
    -- render widgets here
    ImGui.End()
end
```

`ImGui.Begin` returns a boolean indicating whether the window is collapsed or visible. When true, all widget calls between Begin and End render into that window. The second argument is a mutable open/closed state variable. The third argument combines `ImGuiWindowFlags` constants (e.g., `AlwaysAutoResize`, `NoTitleBar`, `NoScrollbar`).

### Nested Container Patterns

- **BeginChild / EndChild**: Scrollers and sub-regions within a parent window. Used to create scrollable lists and split panes.
- **BeginTabBar / BeginTabItem / EndTabItem / EndTabBar**: Tabbed sections within a window.
- **BeginDisabled / EndDisabled**: Greys out sections conditionally.
- **BeginTable / EndTable**: Structured data tables with borders and resizable columns.
- **BeginTooltip / EndTooltip**: Hover tooltips triggered by `IsItemHovered()`.

### Window Flags

Common flag combinations:
- `ImGuiWindowFlags.AlwaysAutoResize` — window sizes to content
- `ImGuiWindowFlags.NoTitleBar` — removes the title bar (custom-drawn windows)
- `ImGuiWindowFlags.NoScrollbar` — hides scrollbars
- `ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoResize` — fixed position windows

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:1127` | `if ImGui.Begin("0-Engine") then` with nested BeginTooltip blocks |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/modules/Logger.lua:146` | BeginChild("LogScroll") for scrollable log output |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1989` | `ImGui.Begin(windowSettings.name, true, windowSettings.windowFlags)` with collapsed early-exit |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:792` | `ImGui.Begin(..., ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoTitleBar)` |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/modules/ui.lua:316` | Begin with BeginTabBar/BeginTabItem for Main/Headlights/Other tabs |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/modules/ui.lua:213` | BeginTable("ColorTable", 3, Borders + Resizable) |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:183` | `ImGui.Begin("Appearance Creator Mod", ImGuiWindowFlags.AlwaysAutoResize)` with BeginChild for categories |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/MainWindow.lua:95` | `ImGui.Begin(SM.modName, true, ImGuiWindowFlags.NoScrollbar)` with nested BeginChild |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/CloudCustomizer.lua:144` | `ImGui.Begin("Cloud Customizer", true, NoScrollbar + AlwaysUseWindowPadding)` |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/ui.lua` | Full ImGui window with tab bar and themed controls |
| grappling_hook | `ui/drawing.lua` | Custom-drawn ImGui window using ImDrawList primitives |
| grappling_hook | `ui_framework/util_controls.lua:40` | Draw_Tooltip uses `ImGui.Begin("tooltip", true, NoResize + NoMove + NoTitleBar + NoScrollbar)` |

*213 more mods use this pattern.*

## Related Concepts

- [Styling & Theming](styling-theming.md)
- [Interaction Patterns](interaction-patterns.md)
- [Custom Controls](custom-controls.md)
- [../index.md](../index.md)
- [/ui/hud-menus.md](../../ui/hud-menus.md)
