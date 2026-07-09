---
type: Mechanic Pattern
title: "ImGui Interaction Patterns"
description: "InvisibleButton, IsItemHovered, IsItemClicked hit detection and hover/click state handling for custom interactive widgets"
tags: [ui, imgui, interaction, input, cet]
timestamp: 2026-07-04T00:00:00Z
---

# ImGui Interaction Patterns

ImGui provides query functions to detect mouse hover and click states on the most recently rendered item. Mods use `InvisibleButton` to create invisible hit-test regions, then check `IsItemHovered()` and `IsItemClicked()` to drive custom-drawn interactive widgets. This is the foundation for building controls that don't rely on ImGui's built-in widget appearance.

## Approach

### InvisibleButton for Hit Testing

`ImGui.InvisibleButton(name, width, height)` creates an invisible interactive area at the current cursor position. It returns `true` when clicked. The `name` parameter must be unique within the window — duplicate names silently break click detection.

```lua
local isClicked = ImGui.InvisibleButton("myButton", 100, 30)
local isHovered = ImGui.IsItemHovered()
```

The invisible button establishes a bounding box for mouse interaction. Custom rendering (via `ImDrawList` primitives like `ImDrawListAddRectFilled`, `ImDrawListAddText`) is drawn separately, and the hover/click state from the invisible button drives visual feedback.

### IsItemHovered

`ImGui.IsItemHovered()` returns `true` when the mouse is over the last submitted item. This is the standard pattern for showing tooltips, changing visual states, and detecting hover for custom-drawn controls.

```lua
ImGui.Button("Hover Me")
if ImGui.IsItemHovered() then
    ImGui.BeginTooltip()
    ImGui.Text("Explanation text")
    ImGui.EndTooltip()
end
```

### IsItemClicked

`ImGui.IsItemClicked()` returns `true` on the frame the mouse button is pressed over the last item. Combined with `IsMouseDoubleClicked`, this enables double-click actions.

```lua
if ImGui.IsItemClicked() and ImGui.IsMouseDoubleClicked(ImGuiMouseButton.Left) then
    -- handle double-click
end
```

### Wrapped Hit Detection (Draw_InvisibleButton)

The grappling_hook / jetpack / wall_hang mod family wraps `InvisibleButton` into a reusable `Draw_InvisibleButton` function in `ui_framework/util_controls.lua` that handles center-based positioning and padding:

```lua
function Draw_InvisibleButton(name, center_x, center_y, width, height, padding)
    padding = padding * 0.667
    local left = center_x - (width / 2)
    local top = center_y - (height / 2)
    ImGui.SetCursorPos(left - padding, top - padding)
    local isClicked = ImGui.InvisibleButton(name, width + (padding * 2), height + (padding * 2))
    local isHovered = ImGui.IsItemHovered()
    return isClicked, isHovered
end
```

Every custom control in the `ui_controls_generic` family (checkbox, slider, combobox, button, summary_button, etc.) calls `Draw_InvisibleButton` and uses the returned `isClicked`/`isHovered` to drive its custom rendering.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| grappling_hook | `ui_framework/util_controls.lua:8` | Draw_InvisibleButton wrapper with center-based positioning, padding, returns isClicked + isHovered |
| grappling_hook | `ui_controls_generic/checkbox.lua:54` | Draw_InvisibleButton for checkbox hit detection with hidden name suffix |
| grappling_hook | `ui_controls_generic/slider.lua:50` | Draw_InvisibleButton for slider grab area |
| grappling_hook | `ui_controls_generic/summary_button.lua:31` | Draw_InvisibleButton for expandable summary button |
| grappling_hook | `ui_controls_generic/help_button.lua:30` | Draw_InvisibleButton for small help/info button |
| grappling_hook | `ui_controls_generic/label_clickable.lua:29` | Draw_InvisibleButton for clickable text labels |
| grappling_hook | `ui_controls_generic/remove_button.lua:29` | Draw_InvisibleButton for remove/delete button |
| grappling_hook | `ui_controls_generic/updownbuttons.lua:26` | Two Draw_InvisibleButton calls for up/down increment buttons |
| jetpack | `ui_controls_generic/checkbox.lua:54` | Shared control pattern — identical Draw_InvisibleButton usage |
| jetpack | `ui_controls_generic/combobox.lua` | Draw_InvisibleButton for dropdown hit area |
| wall_hang | `ui_controls_generic/checkbox.lua` | Shared control pattern — identical Draw_InvisibleButton usage |
| wall_hang | `ui_controls_generic/gridview.lua` | Draw_InvisibleButton for grid cell selection |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:216` | CPStyle:InvisibleButton wrapper, then IsItemHovered for custom button rendering |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:239` | CPStyle:CPButton uses InvisibleButton + IsItemHovered for fully custom-drawn button |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/cpstyling.lua:296` | CPToggle: two InvisibleButton calls for off/on toggle halves |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:818` | IsItemClicked + IsMouseDoubleClicked(Left) for double-click row selection |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:546` | IsItemHovered triggers BeginTooltip/EndTooltip |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/init.lua:1189` | IsItemHovered for tooltip display on config entries |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:2000` | IsItemHovered for option tooltips throughout settings UI |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/modules/ui.lua:77` | IsItemHovered for color picker tooltip |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/elements.lua:81` | IsItemHovered + not open + tooltip for conditional tooltip display |
| Free_Lean-26535-1-4-1767654336 | `bin/x64/plugins/cyber_engine_tweaks/mods/FreeLean/init.lua:780` | IsItemHovered for slider option tooltips |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/ControlPanel.lua` | IsItemHovered for control panel option feedback |

*200+ more mods use IsItemHovered for tooltip and hover-state patterns.*

## Related Concepts

- [Immediate-Mode Rendering](immediate-mode-rendering.md)
- [Styling & Theming](styling-theming.md)
- [Custom Controls](custom-controls.md)
- [../index.md](../index.md)
- [/ui/hud-menus.md](../../ui/hud-menus.md)
- [/ui/input-hotkeys.md](../../ui/input-hotkeys.md)
