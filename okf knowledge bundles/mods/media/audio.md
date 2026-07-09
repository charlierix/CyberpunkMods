---
type: Mechanic Pattern
title: "Audio System"
description: "Sound events, music control, and audio system manipulation patterns"
tags: [media, audio]
timestamp: 2026-07-04T00:00:00Z
---

# Audio System

Sound events, music control, and audio system manipulation patterns.

## Sound Event Triggering

Triggering custom sound events via AudioSystem during gameplay events.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameHUD.lua` | Game.GetAudioSystem():Play('ui_jingle_chip_malfunction') |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:482` | audioSystem = Game.GetAudioSystem() |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:459` | Game.GetAudioSystem():RequestSongOnRadioStation(current_station_evt, next_radio_track_data[2]) |
| Cyberpunk Glitch FPS-28256-v6-0-1776762686 | `Cyberpunk Glitch FPS/bin/x64/plugins/cyber_engine_tweaks/mods/GlitchFPS/Glitch.lua:1330` | player:PlaySoundEvent(eventName) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/quest.lua:481` | userData.soundEvent = CName("QuestNewPopup") |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameHUD.lua` | Game.GetAudioSystem():Play('ui_jingle_chip_malfunction') |
| Immersive V Dialogue Expanded-24377-1-1-0-1758901777 | `bin/x64/plugins/cyber_engine_tweaks/mods/ImmersiveVDialogueExpanded/init.lua:581` | local function PlaySound(soundName, speaker, playInMenus, ignoreAudioAlreadyInUse) |
| K_O_Cybernetic_Kinematic_System-16917-1-42-1728093225 | `bin/x64/plugins/cyber_engine_tweaks/mods/K_O_Cybernetic_Kinematic_System/init.lua:73` | Game.GetAudioSystem():Play('dev_pocket_radio_on', Game.GetPlayer(), nil) |

*140 more mods use this pattern.*

## Music Replacement

Replacing or modifying in-game music tracks and radio stations.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Trauma Team Opening-29584-1-2-1778516459 | `r6/audioware/MainMenuMusic/MainMenuMusic.yaml` | music: |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:459` | Game.GetAudioSystem():RequestSongOnRadioStation(current_station_evt, next_radio_track_data[2]) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:1381` | ["helper"] = "This action will Use Sound Manager Mod to stop a channel (sound, music or env) ", |
| K_O_Cybernetic_Kinematic_System-16917-1-42-1728093225 | `bin/x64/plugins/cyber_engine_tweaks/mods/K_O_Cybernetic_Kinematic_System/init.lua:73` | Game.GetAudioSystem():Play('dev_pocket_radio_on', Game.GetPlayer(), nil) |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/Modules/event.lua:321` | self.sound_obj:SetRestriction(Def.SoundRestrictionLevel.PriorityRadio) |
| SYDNEYPUNK-25549-2-0-1763390506 | `bin/x64/plugins/cyber_engine_tweaks/mods/LIDASKIP/modules/skip/skipLogic.lua` | skipLogic.audioSystem:Play("dev_pocket_radio_off") |
| CombatArena-Vortex.zip-27580-0-2-1771142680 | `bin/x64/plugins/cyber_engine_tweaks/mods/CombatArena/init.lua:508` | -- Arena music: play creepy combat track via REDscript audio system |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/data/ItemList.lua:2245` | "Items.generic_corporate_wars_musical_shard", |

*34 more mods use this pattern.*

## Ambient Audio Modification

Modifying ambient soundscapes, environment audio, and atmospheric sound systems.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CombatArena-Vortex.zip-27580-0-2-1771142680 | `r6/scripts/CombatArena/arena_spawner.reds:224` | // Uses the game's combat music system + dark ambient |
| all in one-24528-2-1778729893 | `mods with no requirement/red4ext/plugins/Codeware/Scripts/Codeware.Global.reds:10322` | public native class audioAmbientAreaContextActivatedASTCD extends audioAudioStateTransitionCondition |
| World Builder 1.0.81-20660-1-0-81-1777072042 | `bin/x64/plugins/cyber_engine_tweaks/mods/entSpawner/modules/classes/spawn/area/ambientArea.lua:81` | ["$type"] = "audioAmbientAreaNotifier", |
| Addicted-7480-1-0-0-1758637170 | `Addicted-mod-windows-v1.0.0/r6/scripts/Addicted/managers/AudioManager.reds:54` | private let ambientSFX: ref<PlaySoundEvent>; |
| AmbientSoundMixer_v1.1-16450-1-1-1725190141 | `r6/scripts/AmbientSoundMixer/AmbientSoundMixer.reds:29` | @runtimeProperty("ModSettings.displayName", "Mute ALL ambient sounds") |


## Related Concepts

- [HUD & Menus](..//ui/hud-menus.md) — related manipulation pattern
