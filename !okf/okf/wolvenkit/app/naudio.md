---
type: "Service"
title: "Audio Playback (NAudio)"
description: "NAudio audio playback system (AudioPlayback, VorbisWaveReader, SampleAggregator, visualization plugin) — 6 files."
resource: "WolvenKit.App/Naudio/AudioPlayback.cs"
tags: [app, naudio, service]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

NAudio audio playback system (AudioPlayback, VorbisWaveReader, SampleAggregator, visualization plugin) — 6 files.

This is a **peripheral subsystem** with limited scope.

## Key Source Files

This concept comprises **6 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AudioPlayback.cs | 143 | class AudioPlayback |
| EndOfStreamEventArgs.cs | 28 | class EndOfStreamEventArgs |
| IVisualizationPlugin.cs | 18 | interface IVisualizationPlugin |
| SampleAggregator.cs | 121 | class SampleAggregator, class MaxSampleEventArgs, class FftEventArgs |
| VorbisSampleProvider.cs | 280 | class VorbisSampleProvider, delegate T |
| VorbisWaveReader.cs | 229 | class VorbisWaveReader |

## Member Types

All **6** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AudioPlayback.cs |
| 2 | EndOfStreamEventArgs.cs |
| 3 | IVisualizationPlugin.cs |
| 4 | SampleAggregator.cs |
| 5 | VorbisSampleProvider.cs |
| 6 | VorbisWaveReader.cs |

## Architecture

The analyzed files contain approximately **819 lines** of code across **6 files** (of 6 total).

### Notable Types

- class AudioPlayback
- class EndOfStreamEventArgs
- class FftEventArgs
- class MaxSampleEventArgs
- class SampleAggregator
- class VorbisSampleProvider
- class VorbisWaveReader
- delegate T
- interface IVisualizationPlugin

## Dependencies

No specific namespace dependencies detected.

## Citations

[1] Source files under `WolvenKit.App/Naudio/` in the WolvenKit repository
