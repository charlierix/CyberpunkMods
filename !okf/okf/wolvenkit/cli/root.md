---
type: "CLI"
title: "CLI Root"
description: "CLI root files (Program, GenericHost, color console logger, Microsoft logger service) — 4 files."
resource: "WolvenKit.CLI/Commands/ArchiveCommand.cs"
tags: [cli, root]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

CLI root files (Program, GenericHost, color console logger, Microsoft logger service) — 4 files.

This is a **supporting subsystem** that enhances functionality.

## Key Source Files

This concept comprises **22 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| ArchiveCommand.cs | 53 | class ArchiveCommand |
| BuildCommand.cs | 38 | class BuildCommand |
| CR2WCommand.cs | 59 | class CR2WCommand |
| CommandBase.cs | 31 | class CommandBase |
| ConflictsCommand.cs | 56 | class ConflictsCommand |
| ConvertCommand.cs | 100 | class ConvertCommand, class DeserializeCommand, class SerializeCommand |
| ExportCommand.cs | 65 | class ExportCommand |
| HashCommand.cs | 29 | class HashCommand |
| ImportCommand.cs | 47 | class ImportCommand |
| OodleCommand.cs | 63 | class OodleCommand, class DecompressCommand, class CompressCommand |
| PackCommand.cs | 44 | class PackCommand |
| SettingsCommand.cs | 58 | class SettingsCommand |
| UnbundleCommand.cs | 71 | class UnbundleCommand |
| UncookCommand.cs | 100 | class UncookCommand, record UncookArguments |
| WwiseCommand.cs | 32 | class WwiseCommand |
| GenericHost.cs | 80 | class GenericHost |
| Program.cs | 84 | class Program |
| ColorConsoleLogger.cs | 133 | class ColorConsoleLoggerProvider, class ColorConsoleLoggerExtensions, class ColorConsoleLoggerConfiguration, class ColorConsoleLogger |
| MicrosoftLoggerService.cs | 91 | class MicrosoftLoggerService |
| WolvenKit.CLI.csproj | 63 | N/A |

## Member Types

All **22** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | ArchiveCommand.cs |
| 2 | BuildCommand.cs |
| 3 | CR2WCommand.cs |
| 4 | CommandBase.cs |
| 5 | ConflictsCommand.cs |
| 6 | ConvertCommand.cs |
| 7 | ExportCommand.cs |
| 8 | HashCommand.cs |
| 9 | ImportCommand.cs |
| 10 | OodleCommand.cs |
| 11 | PackCommand.cs |
| 12 | SettingsCommand.cs |
| 13 | UnbundleCommand.cs |
| 14 | UncookCommand.cs |
| 15 | WwiseCommand.cs |
| 16 | GenericHost.cs |
| 17 | Program.cs |
| 18 | ColorConsoleLogger.cs |
| 19 | MicrosoftLoggerService.cs |
| 20 | WolvenKit.CLI.csproj |
| 21 | appsettings.json |
| 22 | changelog.txt |

## Architecture

The analyzed files contain approximately **1369 lines** of code across **22 files** (of 22 total).

### Notable Types

- class ArchiveCommand
- class BuildCommand
- class CR2WCommand
- class ColorConsoleLogger
- class ColorConsoleLoggerConfiguration
- class ColorConsoleLoggerExtensions
- class ColorConsoleLoggerProvider
- class CommandBase
- class CompressCommand
- class ConflictsCommand
- class ConvertCommand
- class DecompressCommand
- class DeserializeCommand
- class ExportCommand
- class GenericHost
- class HashCommand
- class ImportCommand
- class MicrosoftLoggerService
- class OodleCommand
- class PackCommand
- class Program
- class SerializeCommand
- class SettingsCommand
- class UnbundleCommand
- class UncookCommand
- class WwiseCommand
- record UncookArguments

## Dependencies

- using CP77Tools.Tasks
- using Microsoft.Extensions.DependencyInjection
- using Microsoft.Extensions.Hosting
- using Microsoft.Extensions.Options
- using System
- using System.CommandLine
- using System.CommandLine.NamingConventionBinder
- using System.IO
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Core.Interfaces
- using WolvenKit.RED4.Types

## Citations

[1] Source files under `WolvenKit.CLI/Commands/` in the WolvenKit repository
