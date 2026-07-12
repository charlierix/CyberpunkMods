---
type: "Service"
title: "WPF Audio Visualization Services"
description: "Audio visualization services (waveform, spectrum analyzer, notification) — 4 files."
resource: "WolvenKit/Services/NotificationService.cs"
tags: [ui, services, visualizations, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Audio visualization services (waveform, spectrum analyzer, notification) — 4 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **4 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| NotificationService.cs | 208 | class NotificationService |
| PolygonWaveFormVisualization.cs | 23 | class PolygonWaveFormVisualization |
| PolylineWaveFormVisualization.cs | 23 | class PolylineWaveFormVisualization |
| SpectrumAnalyzerVisualization.cs | 26 | class SpectrumAnalyzerVisualization |

## Member Types

All **4** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | NotificationService.cs |
| 2 | PolygonWaveFormVisualization.cs |
| 3 | PolylineWaveFormVisualization.cs |
| 4 | SpectrumAnalyzerVisualization.cs |

## Architecture

The analyzed files contain approximately **280 lines** of code across **4 files** (of 4 total).

### Notable Types

- class NotificationService
- class PolygonWaveFormVisualization
- class PolylineWaveFormVisualization
- class SpectrumAnalyzerVisualization

## Dependencies

- using HandyControl.Controls
- using HandyControl.Data
- using System
- using System.Windows
- using System.Windows.Threading
- using WolvenKit.App.Helpers
- using WolvenKit.Common.Services

## Citations

[1] Source files under `WolvenKit/Services/` in the WolvenKit repository
