---
type: "System"
title: "App Interaction System"
description: "User interaction system (dialog options, checklist, scene input) — 5 files."
resource: "WolvenKit.App/Interaction/InteractionEnums.cs"
tags: [app, interaction, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

User interaction system (dialog options, checklist, scene input) — 5 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| InteractionEnums.cs | 124 | enum WMessageBoxImage, enum WMessageBoxButtons, enum WMessageBoxResult |
| Interactions.cs | 250 | class Interactions |
| ChecklistDialogOptions.cs | 37 | class ChecklistDialogOptions |
| SceneInputDialogOptions.cs | 46 | class SceneInputDialogOptions |
| ShowDictAsCopyableListDialogOptions.cs | 29 | class ShowDictAsCopyableListDialogOptions |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | InteractionEnums.cs |
| 2 | Interactions.cs |
| 3 | ChecklistDialogOptions.cs |
| 4 | SceneInputDialogOptions.cs |
| 5 | ShowDictAsCopyableListDialogOptions.cs |

## Architecture

The analyzed files contain approximately **486 lines** of code across **5 files** (of 5 total).

### Notable Types

- class ChecklistDialogOptions
- class Interactions
- class SceneInputDialogOptions
- class ShowDictAsCopyableListDialogOptions
- enum WMessageBoxButtons
- enum WMessageBoxImage
- enum WMessageBoxResult

## Dependencies

- using System
- using System.Collections.Generic
- using System.Threading.Tasks
- using WolvenKit.App.Factories
- using WolvenKit.App.Helpers
- using WolvenKit.App.Interaction.Options
- using WolvenKit.App.Models.ProjectManagement.Project
- using WolvenKit.App.Scripting
- using WolvenKit.App.Services
- using WolvenKit.App.ViewModels.Dialogs

## Citations

[1] Source files under `WolvenKit.App/Interaction/` in the WolvenKit repository
