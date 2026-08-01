## What it does

- **Hotkey toggle** — Bind "Toggle Entity Scanner" in Settings > Key Bindings > EntityScanner
- **Independent of CET console** — The ImGui window shows whenever enabled, no need to open the CET console
- **Real-time entity info** — Shows whatever the player is currently looking at via the crosshair targeting system

## What it displays

| Field | Source |
|---|---|
| **Type** | NPC / Vehicle / Device / Item / Container (or fallback class name) |
| **Class** | `record:ToString()` |
| **TweakDBID** | `record:GetRecordID().value` |
| **Template** | `record:EntityTemplatePath():ToString()` |
| **Appearance** | `entity:GetCurrentAppearanceName().value` |
| **Distance** | Calculated from world positions |
| **EntityID** | `entity:GetEntityID()` |

## How it works

- `onUpdate` refreshes scan data each frame using `Game.GetTargetingSystem():GetComponentClosestToCrosshair(Game.GetPlayer(), nil):GetEntity()`
- `onDraw` renders the ImGui window (fires every frame regardless of CET console state)
- `registerHotkey` is at file root level per the project's CET hotkey rule
- All entity API calls are wrapped in `pcall` for safety across entity types

## Install

Copy the `entity scanner` folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/entity scanner/
```

Then bind the hotkey in-game and press it to toggle the scanner window. Let me know what features you want to add as you use it!