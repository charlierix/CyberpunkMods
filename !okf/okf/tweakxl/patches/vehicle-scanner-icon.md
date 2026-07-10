---
type: Patch
title: Vehicle Scanner Icon Fix
description: WrapMethod patch fixing vehicle manufacturer icon rendering in the scanner HUD.
resource: sources/TweakXL/scripts/VehicleScanner.reds
tags: [tweakxl, redscript, patch, vehicle, scanner, icon, ui]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

This patch wraps `ScannervehicleGameController.OnVehicleManufacturerChanged()` to fix vehicle manufacturer icon rendering in the scanner HUD. When the manufacturer changes, it resolves the manufacturer's icon from TweakDB's `UIIcon` records and applies the correct atlas resource to the scanner's manufacturer image element.

# Member Types

| Type | Kind | Source File | Key Members |
|------|------|------------|-------------|
| ScannervehicleGameController (wrapped) | `@wrapMethod` patch | scripts/VehicleScanner.reds | `OnVehicleManufacturerChanged(value: Variant)` |

# Patched Method

### ScannervehicleGameController.OnVehicleManufacturerChanged

```reds
@wrapMethod(ScannervehicleGameController)
protected cb func OnVehicleManufacturerChanged(value: Variant) -> Bool {
    wrappedMethod(value);
    if this.m_isValidVehicleManufacturer {
        let vehicleManufacturer = FromVariant<ref<ScannerVehicleManufacturer>>(value);
        let iconRecord = TweakDBInterface.GetUIIconRecord(
            TDBID.Create("UIIcon." + vehicleManufacturer.GetVehicleManufacturer())
        );
        inkImageRef.SetAtlasResource(this.m_vehicleManufacturer, iconRecord.AtlasResourcePath());
    }
}
```

# Behavior

1. Calls the original `wrappedMethod(value)` first
2. Checks if the vehicle manufacturer is valid (`m_isValidVehicleManufacturer`)
3. Extracts the `ScannerVehicleManufacturer` from the Variant parameter
4. Constructs a TweakDBID for the UIIcon record from the manufacturer name
5. Resolves the icon record via `TweakDBInterface.GetUIIconRecord`
6. Sets the atlas resource on the manufacturer image element

# Dependencies

- Uses [TweakDBInterface](/apis/tweakdb-api.md) extensions to resolve UIIcon records
- `inkImageRef` — ink UI framework for image manipulation
- `ScannerVehicleManufacturer` — engine record type for vehicle manufacturer data

# Citations

- [VehicleScanner.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/VehicleScanner.reds)
