---
type: Mechanic Pattern
title: "ImGui Custom Control Frameworks"
description: "Building reusable UI control libraries on top of ImGui primitives using invisible buttons, ImDrawList rendering, and shared framework modules"
tags: [ui, imgui, controls, framework, cet]
timestamp: 2026-07-04T00:00:00Z
---

# ImGui Custom Control Frameworks

When ImGui's built-in widgets don't provide enough visual customization, mods build reusable control frameworks that combine `InvisibleButton` hit detection, `ImDrawList` custom rendering, and `PushStyleColor`/`PopStyleColor` theming into self-contained control modules. Two prominent approaches exist in the modding ecosystem: the shared `ui_controls_generic` framework (grappling_hook / jetpack / wall_hang) and the `CPStyle` wrapper library (Cyberscript Core).

## Approach

### Pattern 1: Shared Control Module Framework (grappling_hook / jetpack / wall_hang)

This approach splits the framework into two layers:

**ui_framework/** — Low-level drawing utilities:
- `util_controls.lua` — `Draw_InvisibleButton`, `Draw_Border`, `Draw_Circle`, `Draw_Line`, `Draw_Arrow`, `Draw_Triangle`, `Draw_Tooltip`
- `util_layout.lua` — Layout calculations and positioning helpers
- `util_misc.lua` — Misc utilities (text measurement, color helpers)
- `util_setup.lua` — Control definition initialization
- `common_definitions.lua` — Shared data structures for control definitions

**ui_controls_generic/** — High-level controls, each in its own file:
- `button.lua`, `checkbox.lua`, `combobox.lua`, `listbox.lua`, `slider.lua`
- `summary_button.lua`, `help_button.lua`, `remove_button.lua`
- `label.lua`, `label_clickable.lua`, `textbox.lua`
- `updownbuttons.lua`, `orderedlist.lua`, `multiitem_displaylist.lua`
- `gridview.lua`, `colorsample.lua`, `progressbar_slim.lua`
- `okcancel_buttons.lua`

Each control file exports a draw function that:
1. Receives a `def` (definition) table with position, size, style, and state
2. Calls `Draw_InvisibleButton` for hit detection
3. Uses `Draw_Border` and ImDrawList primitives for custom rendering
4. Returns interaction state (isClicked, isHovered, value changes)

The framework uses center-based positioning (`center_x`, `center_y`) rather than top-left corners, with padding and scale factors built into the definition structure.

**Cross-mod reuse**: The grappling_hook, jetpack, and wall_hang mods share identical copies of `ui_controls_generic/` and `ui_framework/`, demonstrating a de-facto shared library pattern where control code is copied between mods rather than distributed as a dependency.

### Pattern 2: CPStyle Wrapper Library (Cyberscript Core)

Cyberscript's `cpstyling.lua` takes a different approach — wrapping ImGui's built-in widgets with themed versions:

- `CPStyle:InvisibleButton(label, sizex, sizey)` — themed invisible button
- `CPStyle:CPButton(label, sizex, sizey)` — custom-drawn button using InvisibleButton + ImDrawList
- `CPStyle:CPToggle(label, label_off, label_on, value, sizex, sizey)` — toggle with two invisible button halves
- `CPStyle:CPCollapsingHeader(label, sizex, sizey)` — themed collapsing header
- `CPStyle:CPToolTip1Begin/End`, `CPToolTip2Begin/End` — tooltip wrappers
- `CPStyle:CPRect`, `CPStyle:CPRect2` — rectangle drawing helpers
- `CPStyle:setThemeBegin/setThemeEnd` — batch theme application
- `CPStyle:colorBegin/colorEnd` — scoped color push/pop
- `CPStyle:styleBegin/styleEnd` — scoped style var push/pop

This approach provides a cleaner API surface but is tightly coupled to Cyberscript's theme system.

### Key Design Decisions

| Aspect | ui_controls_generic | CPStyle |
|--------|---------------------|---------|
| Rendering | Fully custom via ImDrawList | Mix of custom + ImGui built-ins |
| Positioning | Center-based (center_x, center_y) | Standard ImGui cursor flow |
| Theming | Per-control style definitions | Global theme with scoped overrides |
| Distribution | Copied between mods | Embedded in Cyberscript |
| Control count | 17+ control types | 10+ wrapper functions |

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| grappling_hook | `ui_framework/util_controls.lua` | Core drawing utilities: Draw_InvisibleButton, Draw_Border, Draw_Circle, Draw_Line, Draw_Arrow, Draw_Tooltip |
| grappling_hook | `ui_framework/util_layout.lua` | Layout and sizing calculations |
| grappling_hook | `ui_framework/common_definitions.lua` | Shared control definition structures |
| grappling_hook | `ui_controls_generic/combobox.lua` | Custom combobox with Draw_InvisibleButton + ImDrawList rendering |
| grappling_hook | `ui_controls_generic/listbox.lua` | Scrollable list box with custom item rendering |
| grappling_hook | `ui_controls_generic/checkbox.lua` | Custom checkbox with hidden InvisibleButton for hit detection |
| grappling_hook | `ui_controls_generic/slider.lua` | Custom slider with grab-area hit detection |
| grappling_hook | `ui_controls_generic/summary_button.lua` | Expandable summary button with hover/click states |
| grappling_hook | `ui_controls_generic/gridview.lua` | Grid view with per-cell InvisibleButton hit testing |
| grappling_hook | `ui_controls_generic/textbox.lua` | Custom text input control |
| grappling_hook | `ui_controls_generic/updownbuttons.lua` | Up/down increment controls with dual InvisibleButton calls |
| jetpack | `ui_controls_generic/` | Identical control set shared with grappling_hook |
| jetpack | `ui_framework/util_controls.lua` | Shared framework — same Draw_InvisibleButton implementation |
| jetpack | `ui_controls_generic/stackpanel.lua` | Additional control unique to jetpack — stack panel layout |
| wall_hang | `ui_controls_generic/` | Identical control set shared with grappling_hook |
| wall_hang | `ui_framework/util_controls.lua` | Shared framework — same drawing utilities |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:80` | CPStyle:New(mod_name) constructor for themed control factory |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:232` | CPStyle:CPButton — custom-drawn button via InvisibleButton + ImDrawList |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:279` | CPToggle — dual invisible buttons for off/on toggle |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:416` | CPCollapsingHeader — themed collapsing header |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:542` | CPRect — rectangle drawing with text alignment |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:136` | setThemeBegin/setThemeEnd — batched theme application |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:430` | Multiple ImGui.Begin windows with BeginChild for structured panel layout |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/ControlPanel.lua` | Control panel module with structured ImGui widget composition |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/BugReportForm.lua:71` | BeginCombo with ImGuiComboFlags.HeightLargest for form control |

*Additional mods compose ImGui built-in widgets into structured control panels without custom frameworks.*

## Related Concepts

- [Immediate-Mode Rendering](immediate-mode-rendering.md)
- [Styling & Theming](styling-theming.md)
- [Interaction Patterns](interaction-patterns.md)
- [../index.md](../index.md)
- [/ui/hud-menus.md](../../ui/hud-menus.md)
- [/ui/settings.md](../../ui/settings.md)
