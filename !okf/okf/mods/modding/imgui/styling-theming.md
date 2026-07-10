---
type: Mechanic Pattern
title: "ImGui Styling & Theming"
description: "PushStyleColor/PopStyleColor and PushStyleVar/PopStyleVar style stack manipulation for custom ImGui themes"
tags: [ui, imgui, styling, theming, cet]
timestamp: 2026-07-04T00:00:00Z
---

# ImGui Styling & Theming

ImGui uses a push/pop style stack for colors and layout variables. Mods call `PushStyleColor` / `PushStyleVar` before rendering widgets, then `PopStyleColor` / `PopStyleVar` after to restore defaults. This enables per-window, per-widget, and full theme customization without permanent state changes.

## Approach

### Color Stack (PushStyleColor / PopStyleColor)

Each `PushStyleColor(ImGuiCol.X, r, g, b, a)` pushes a color onto ImGui's internal stack for a given color slot (`ImGuiCol.WindowBg`, `ImGuiCol.Button`, `ImGuiCol.Text`, etc.). The matching `PopStyleColor(count)` pops the specified number of entries. Multiple colors can be pushed in sequence and popped in bulk.

```lua
ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.05, 0.05, 0.08, 1.0)
ImGui.PushStyleColor(ImGuiCol.Text, 0.85, 0.85, 0.95, 1.0)
-- render widgets with custom colors
ImGui.PopStyleColor(2)  -- pop both
```

### Variable Stack (PushStyleVar / PopStyleVar)

`PushStyleVar(ImGuiStyleVar.X, value)` or `PushStyleVar(ImGuiStyleVar.X, val1, val2)` pushes layout variables like rounding, padding, spacing, and border sizes. `PopStyleVar(count)` restores them.

Common variables:
- `WindowRounding` — corner radius of windows
- `FrameRounding` — corner radius of frames/buttons
- `WindowPadding` — inner padding (x, y)
- `FramePadding` — frame widget padding (x, y)
- `ItemSpacing` — spacing between widgets (x, y)
- `WindowBorderSize` — border thickness
- `FrameBorderSize` — frame border thickness

### Theme Application Pattern

Mods typically push all style colors and variables at the start of their draw function, render the full window, then pop everything. Some mods (e.g., A CET Mod Logger) define multiple complete themes and switch between them based on user preference.

### Wrapper Frameworks

Cyberscript's `cpstyling.lua` wraps this pattern into `CPStyle:setThemeBegin()` / `CPStyle:setThemeEnd()` and `CPStyle.colorBegin(style, color)` / `CPStyle.colorEnd(count)`, providing a cleaner API for theme management.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:85` | Full theme: 20+ PushStyleColor calls (WindowBg, Border, Text, Button, FrameBg, TitleBg, CheckMark, Tab, SliderGrab, Header) |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:110` | PushStyleVar for WindowRounding, FrameRounding, PopupRounding, ScrollbarRounding, GrabRounding, TabRounding |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:117` | PushStyleVar for WindowPadding, FramePadding, ItemSpacing (x, y pairs) |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:126` | Second complete theme (red/gold variant) with 20+ different PushStyleColor calls |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/modules/Logger.lua:173` | PushStyleColor(ImGuiCol.Text, color[1..4]) for per-line log coloring |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:92` | CPStyle:colorBegin(style, color) wrapper around PushStyleColor |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:120` | CPStyle:styleBegin(style, var1, var2) wrapper around PushStyleVar |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:136` | CPStyle:setThemeBegin() applies full theme via batched Push calls |
| grappling_hook | `ui_framework/util_controls.lua:49` | Draw_Tooltip pushes WindowRounding, WindowBorderSize, Text, WindowBg, Border colors then pops 3 colors + 2 vars after End() |
| grappling_hook | `ui_controls_generic/summary_button.lua` | PushStyleColor/PopStyleColor for hovered vs standard button states |
| jetpack | `ui_controls_generic/combobox.lua` | PushStyleColor for dropdown item hover/selection coloring |

*Numerous additional mods use PushStyleColor for targeted widget coloring.*

## Related Concepts

- [Immediate-Mode Rendering](immediate-mode-rendering.md)
- [Interaction Patterns](interaction-patterns.md)
- [Custom Controls](custom-controls.md)
- [../index.md](../index.md)
- [/ui/hud-menus.md](../../ui/hud-menus.md)
