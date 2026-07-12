---
type: "System"
title: "Game Controllers"
description: "Game controller interfaces and implementations (IGameController, RED4Controller, Tw3Controller, MockGameController) — 5 files."
resource: "WolvenKit.App/Controllers/IGameController.cs"
tags: [app, controllers, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Game controller interfaces and implementations (IGameController, RED4Controller, Tw3Controller, MockGameController) — 5 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **5 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| IGameController.cs | 83 | interface IGameController |
| IGameControllerFactory.cs | 61 | class GameControllerFactory, interface IGameControllerFactory |
| MockGameController.cs | 34 | class MockGameController |
| RED4Controller.cs | 299 | class RED4Controller |
| Tw3Controller.cs | 257 | class Tw3Controller |

## Member Types

All **5** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | IGameController.cs |
| 2 | IGameControllerFactory.cs |
| 3 | MockGameController.cs |
| 4 | RED4Controller.cs |
| 5 | Tw3Controller.cs |

## Architecture

The analyzed files contain approximately **734 lines** of code across **5 files** (of 5 total).

### Notable Types

- class GameControllerFactory
- class MockGameController
- class RED4Controller
- class Tw3Controller
- interface IGameController
- interface IGameControllerFactory

## Dependencies

- using CommunityToolkit.Mvvm.ComponentModel
- using DynamicData
- using Newtonsoft.Json
- using ProtoBuf
- using ReactiveUI.Fody.Helpers
- using System
- using System.Collections.Generic
- using System.Diagnostics
- using System.IO
- using System.IO.Compression
- using System.Linq
- using System.Text
- using System.Text.Json
- using System.Text.Json.Serialization
- using System.Threading
- using System.Threading.Tasks
- using System.Windows
- using System.Xml.Linq
- using WolvenKit.App.Helpers
- using WolvenKit.App.Interaction

## Citations

[1] Source files under `WolvenKit.App/Controllers/` in the WolvenKit repository
