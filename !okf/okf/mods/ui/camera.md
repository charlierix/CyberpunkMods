---
type: Mechanic Pattern
title: "Camera"
description: "Camera system, FOV control, and camera preset manipulation patterns"
tags: [ui, camera]
timestamp: 2026-07-04T00:00:00Z
---

# Camera

Camera system, FOV control, and camera preset manipulation patterns.

## FOV Adjustment

Modifying camera FOV, view distance, and perspective settings via GetCameraSystem.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_stampede.yaml:26` | - Items.Base_Short_Scope_inline0 # fov |
| Lamborghini Aventador LP 700-4-22459-1-31-1759073224 | `r6/tweaks/_lamborghini_aventador_lp700-4/aventador_lp700-4.yaml:154` | fov: 64 |
| Lamborghini Aventador LP 750-4 SV-22575-1-31-1759072229 | `r6/tweaks/_lamborghini_aventador_lp750-4_sv/aventador_lp750-4_sv.yaml:206` | fov: 64 |
| McLaren Senna-26326-1-00-1767612033 | `r6/tweaks/_mclaren_senna_remake/mclaren_senna_remake.yaml:190` | fov: 65 |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:317` | fov: 75 #69 |
| Oranje 3 The Wobbler Monowheel 2.3 2.31-21069-1-10-1766742137 | `r6/tweaks/monowheel/oranje3_monowheel.yaml:219` | fov: 75 #69 |
| Pagani Huayra-21603-1-3-1757129558 | `r6/tweaks/pagani_huayra/pagani_huayra.yaml:191` | fov: 64 |
| Porsche 718 Cayman GT4-26047-1-10-1766434079 | `r6/tweaks/_porsche_718_cayman_gt4/porsche_718_cayman_gt4.yaml:126` | fov: 65 |

*65 more mods use this pattern.*

## Camera Presets

Creating or modifying camera presets for vehicles, photo mode, and custom camera angles.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/init.lua:1186` | camera = Codeware and player:FindComponentByType("vehicleTPPCameraComponent") |
| Weather Switcher CHS-21957-1-7-6-patch-1778993230 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/Debug.lua` | userVehicleFOV = tostring(Game.GetPlayer():GetFPPCameraComponent():GetFOV()), |
| Weather Switcher Traduction FR-27952-1-6-1-1772488397 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/Debug.lua` | userVehicleFOV = tostring(Game.GetPlayer():GetFPPCameraComponent():GetFOV()), |
| Weather Switcher-18027-1-7-6-1778258186 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/Debug.lua` | userVehicleFOV = tostring(Game.GetPlayer():GetFPPCameraComponent():GetFOV()), |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/init.lua:134` | local tpp_camera_list = {TweakDBID.new("Vehicle.VehicleTPP_v_militech_basilisk_CameraPreset_High_Clo |
| Jackie's Garage-20780-1-0-1743866245 | `bin/x64/plugins/cyber_engine_tweaks/mods/JackiesGarage/modules/workspots/coffeeWorkspot.lua:89` | GetPlayer():GetFPPCameraComponent():SetLocalOrientation(EulerAngles.new(0, currentPitch, 0):ToQuat() |
| Less Lethal Cops mod | `r6/tweaks/less_lethal_cops/Vehicle.border_patrol_villefort_cortes_heat_1.yaml:14` | cameraManagerParams: Camera.VehicleCameraManager_Default |
| gambling-system-blackjack-19575-1-1-4-1765431443 | `bin/x64/plugins/cyber_engine_tweaks/mods/gambling-system-blackjack/init.lua:76` | local camera = GetPlayer():GetFPPCameraComponent() |

*7 more mods use this pattern.*

## Custom Camera Modes

Implementing custom camera modes (first-person, third-person, free camera) via Redscript overrides.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameUI.lua:247` | local function updateVehicle(vehicleActive, cameraMode) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameUI.lua:246` | local function updateVehicle(vehicleActive, cameraMode) |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/UI/GameUI.lua:243` | local function updateVehicle(vehicleActive, cameraMode) |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/psiberx/GameUI.lua:246` | local function updateVehicle(vehicleActive, cameraMode) |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/external/GameUI.lua:250` | local function updateVehicle(vehicleActive, cameraMode) |
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/init.lua:1373` | function ResolveCameraModeData(preset, cameraMode) |
| Vehicle Durability Display - Top-16559-1-1-0-1755257087 | `bin/x64/plugins/cyber_engine_tweaks/mods/VehicleDurabilityDisplay/External/GameUI.lua:246` | local function updateVehicle(vehicleActive, cameraMode) |
| Vehicle Speed Limit-15542-1-2-2-1766933606 | `bin/x64/plugins/cyber_engine_tweaks/mods/VehicleSpeedLimit/modules/psiberx/GameUI.lua:246` | local function updateVehicle(vehicleActive, cameraMode) |

*65 more mods use this pattern.*


## Related Concepts

- [Photo Mode](..//ui/photomode.md) — related manipulation pattern
