---
type: "Interface"
title: "Common Interfaces"
description: "Shared interfaces (IArchiveManager, IGameArchive, IGameFile, IModTools, ISelectableViewModel) — 6 files."
resource: "WolvenKit.Common/Interfaces/IArchiveManager.cs"
tags: [common, interfaces, interface]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Shared interfaces (IArchiveManager, IGameArchive, IGameFile, IModTools, ISelectableViewModel) — 6 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **6 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| IArchiveManager.cs | 103 | interface IArchiveManager |
| IFileSystemViewModel.cs | 23 | interface IFileSystemViewModel |
| IGameArchive.cs | 11 | interface IWitcherGameArchive |
| IGameFile.cs | 15 | interface Tw3GameFile |
| IModTools.cs | 83 | interface IModTools |
| ISelectableViewModel.cs | 9 | interface ISelectableViewModel |

## Member Types

All **6** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | IArchiveManager.cs |
| 2 | IFileSystemViewModel.cs |
| 3 | IGameArchive.cs |
| 4 | IGameFile.cs |
| 5 | IModTools.cs |
| 6 | ISelectableViewModel.cs |

## Architecture

The analyzed files contain approximately **244 lines** of code across **6 files** (of 6 total).

### Notable Types

- interface IArchiveManager
- interface IFileSystemViewModel
- interface IModTools
- interface ISelectableViewModel
- interface IWitcherGameArchive
- interface Tw3GameFile

## Dependencies

- using DynamicData
- using DynamicData.Kernel
- using System.Collections.Generic
- using System.ComponentModel
- using System.ComponentModel.DataAnnotations
- using System.IO
- using System.Threading.Tasks
- using WolvenKit.Common.Model
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Core.Interfaces
- using WolvenKit.RED4.Archive
- using WolvenKit.RED4.Archive.CR2W
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.Common/Interfaces/` in the WolvenKit repository
