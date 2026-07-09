---
type: Class
title: TweakDB API
description: TweakDB operation classes for record creation, cloning, batch operations, and querying.
resource: sources/TweakXL/scripts/TweakDBManager.reds
tags: [tweakdb, redscript, records, batch, query]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

The TweakDB API provides three Redscript classes that together expose TweakDB manipulation to modders. `TweakDBManager` offers static methods for direct record and flat operations. `TweakDBBatch` provides the same operations in a batched transaction with a `Commit()` call. `TweakDBInterface` adds query methods to the existing engine class via `@addMethod`.

These classes are the primary programmatic interface for mods that need to create, modify, or query TweakDB records at runtime.

# Member Types

| Type | Kind | Source File | Key Methods |
|------|------|------------|-------------|
| TweakDBManager | Abstract native class | scripts/TweakDBManager.reds | SetFlat, CreateRecord, CloneRecord, UpdateRecord, RegisterEnum, RegisterName, StartBatch |
| TweakDBBatch | Native class | scripts/TweakDBBatch.reds | SetFlat, CreateRecord, CloneRecord, UpdateRecord, RegisterEnum, RegisterName, Commit |
| TweakDBInterface | Method extensions (@addMethod) | scripts/TweakDBInterface.reds | GetFlat, GetRecord, GetRecords, GetRecordCount, GetRecordByIndex, GetRecords(keys), GetRecordIDs |

# TweakDBManager Methods

| Method | Signature | Description |
|--------|-----------|-------------|
| SetFlat | `(id: TweakDBID, value: Variant) -> Bool` | Sets a flat value on an existing TweakDB record by ID |
| SetFlat | `(name: CName, value: Variant) -> Bool` | Convenience overload that converts CName to TweakDBID and registers the name |
| CreateRecord | `(id: TweakDBID, type: CName) -> Bool` | Creates a new record with the given ID and type |
| CreateRecord | `(name: CName, type: CName) -> Bool` | Convenience overload with CName and auto-registration |
| CloneRecord | `(id: TweakDBID, base: TweakDBID) -> Bool` | Clones an existing record as a new record |
| CloneRecord | `(name: CName, base: TweakDBID) -> Bool` | Convenience overload with CName and auto-registration |
| UpdateRecord | `(id: TweakDBID) -> Bool` | Triggers an update/refresh of a record after flat modifications |
| RegisterEnum | `(id: TweakDBID)` | Registers a flat as an enum value for TweakDB validation |
| RegisterName | `(name: CName) -> Bool` | Registers a CName in TweakDB's name registry |
| StartBatch | `() -> ref<TweakDBBatch>` | Starts a batch operation context, returns a TweakDBBatch instance |

# TweakDBBatch Methods

| Method | Signature | Description |
|--------|-----------|-------------|
| SetFlat | `(id: TweakDBID, value: Variant) -> Bool` | Queues a flat set operation in the batch |
| SetFlat | `(name: CName, value: Variant) -> Bool` | Convenience overload with CName and auto-registration |
| CreateRecord | `(id: TweakDBID, type: CName) -> Bool` | Queues a record creation in the batch |
| CreateRecord | `(name: CName, type: CName) -> Bool` | Convenience overload with CName and auto-registration |
| CloneRecord | `(id: TweakDBID, base: TweakDBID) -> Bool` | Queues a record clone in the batch |
| CloneRecord | `(name: CName, base: TweakDBID) -> Bool` | Convenience overload with CName and auto-registration |
| UpdateRecord | `(id: TweakDBID) -> Bool` | Queues a record update in the batch |
| RegisterEnum | `(id: TweakDBID)` | Queues an enum registration in the batch |
| RegisterName | `(name: CName) -> Bool` | Queues a name registration in the batch |
| Commit | `()` | Commits all queued operations to TweakDB atomically |

# TweakDBInterface Extensions

| Method | Signature | Description |
|--------|-----------|-------------|
| GetFlat | `(path: TweakDBID) -> Variant` | Retrieves a flat value by TweakDBID |
| GetRecord | `(path: TweakDBID) -> ref<TweakDBRecord>` | Retrieves a record by TweakDBID |
| GetRecords | `(type: CName) -> array<ref<TweakDBRecord>>` | Retrieves all records of a given type |
| GetRecordCount | `(type: CName) -> Uint32` | Returns the count of records of a given type |
| GetRecordByIndex | `(type: CName, index: Uint32) -> ref<TweakDBRecord>` | Retrieves a record by type and index |
| GetRecords | `(keys: array<TweakDBID>) -> array<ref<TweakDBRecord>>` | Retrieves multiple records by TweakDBID array (filters undefined) |
| GetRecordIDs | `(type: CName) -> array<TweakDBID>` | Returns all TweakDBIDs for records of a given type |

# Usage Examples

### Direct flat modification

```reds
TweakDBManager.SetFlat(TDBID.Create("Items.BasePistol.damage"), 50.0);
```

### Batch operations

```reds
let batch = TweakDBManager.StartBatch();
batch.SetFlat(TDBID.Create("Items.BasePistol.damage"), 50.0);
batch.CreateRecord(TDBID.Create("Items.MyCustomPistol"), n"Item");
batch.CloneRecord(TDBID.Create("Items.MyPistolClone"), TDBID.Create("Items.BasePistol"));
batch.Commit();
```

### Querying records

```reds
let allItems = TweakDBInterface.GetRecords(n"Item");
let itemIDs = TweakDBInterface.GetRecordIDs(n"Item");
let count = TweakDBInterface.GetRecordCount(n"Item");
```

# Related Concepts

- [TweakXL Core](/apis/tweakxl-core.md) — Version checking for the framework
- [Scriptable Tweak](/apis/scriptable-tweaks.md) — Uses these TweakDB operations in OnApply callbacks
- [Extra Flats](/references/extra-flats.md) — Defines flat fields consumed by these operations
- [Inheritance Map](/references/inheritance-map.md) — Provides inheritance chains for CloneRecord

# Citations

- [TweakDBManager.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/TweakDBManager.reds)
- [TweakDBBatch.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/TweakDBBatch.reds)
- [TweakDBInterface.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/TweakDBInterface.reds)
