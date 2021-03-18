-- NonameNonumber — 02/14/2021
-- Place a map pin at the player's current position: [shared credits with @b0kkr]
-- registerHotkey('PlaceCustomMapPin', 'Place a map pin at player\'s position', function()
--     local mappinData = NewObject('gamemappinsMappinData')
--     mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
--     mappinData.variant = Enum.new('gamedataMappinVariant', 'FastTravelVariant')
--     mappinData.visibleThroughWalls = true
    
--     local position = Game.GetPlayer():GetWorldPosition()
    
--     Game.GetMappinSystem():RegisterMappin(mappinData, position)
-- end)

-- Place a map pin on an object under the crosshair (NPC, Car, Terminal, etc.):
-- registerHotkey('PlaceObjectMapPin', 'Place a map pin on the target', function()
--     local target = Game.GetTargetingSystem():GetLookAtObject(Game.GetPlayer(), false, false)
    
--     if target then
--         local mappinData = NewObject('gamemappinsMappinData')
--         mappinData.mappinType = TweakDBID.new('Mappins.DefaultStaticMappin')
--         mappinData.variant = Enum.new('gamedataMappinVariant', 'FastTravelVariant')
--         mappinData.visibleThroughWalls = true
        
--         local slot = CName.new('poi_mappin')
--         local offset = ToVector3{ x = 0, y = 0, z = 2 } -- Move the pin a bit up relative to the target
        
--         Game.GetMappinSystem():RegisterMappinWithObject(mappinData, target, slot, offset)
--     end
-- end)

-- A map pin can be tracked (drawing path on the map and minimap) if the variant allows it. A map pin placed on an object follows the object if it moves.
-- Custom map pins remain after fast travel. But the "pinned" object can be disposed / teleported, in which case the pin will move to an unpredictable coordinate.
-- Change mappinData.variant to get a different appearance (and sometimes behavior) of the map pin.
-- https://github.com/WolvenKit/CyberCAT/blob/main/CyberCAT.Core/Enums/Dumped%20Enums/gamedataMappinVariant.cs



------------------------------- Alternatives:

--FxSystem
--SpawnEffect


--beam = GameInstance.GetFxSystem(this.GetGameInstance()).SpawnEffect(beamResource, rootEntityWorldTransform, true);




-- private final func CreateFxInstance(owner: wref<GameObject>, id: CName, resource: FxResource, transform: WorldTransform) -> ref<FxInstance> {
--     let fx: ref<FxInstance>;
--     let fxSystem: ref<FxSystem>;
--     fxSystem = GameInstance.GetFxSystem(owner.GetGame());
--     fx = fxSystem.SpawnEffect(resource, transform);
--     return fx;
--   }




-- public const func GetFxResourceByKey(key: CName) -> FxResource {
--     let resource: FxResource;
--     return resource;
--   }

-- GetFxResourceByKey(n"deviceLinkDefault")
-- GetFxResourceByKey(n"networkLinkBreached")
-- GetFxResourceByKey(n"networkLinkDefault")
-- GetFxResourceByKey(n"pingNetworkLink")
-- GetFxResourceByKey(n"ragdollFloorSplash")
-- GetFxResourceByKey(n"ragdollWallSplatter")
-- GetFxResourceByKey(n"revealNetworkLink")



----------------------------------

--EffectSystem
--public native CreateEffectStatic(effectName: CName, effectTag: CName, instigator: Entity, opt weapon: Entity): EffectInstance

-- CreateEffectStatic(n"applyStatusEffect"
-- CreateEffectStatic(n"debugStrike"
-- CreateEffectStatic(n"deviceEffects"
-- CreateEffectStatic(n"emp"
-- CreateEffectStatic(n"forceVisionAppearanceOnNPC"
-- CreateEffectStatic(n"healAll"
-- CreateEffectStatic(n"killAll"
-- CreateEffectStatic(n"landing"
-- CreateEffectStatic(n"loot_highlight"
-- CreateEffectStatic(n"npcBloodPuddle"
-- CreateEffectStatic(n"physicalImpulseSphere"
-- CreateEffectStatic(n"pingNetworkEffect"
-- CreateEffectStatic(n"playFinisher"
-- CreateEffectStatic(n"stats"
-- CreateEffectStatic(n"stimuli"
-- CreateEffectStatic(n"test_effect"
-- CreateEffectStatic(n"weaponShoot"



----------------------------------
--CameraSystem
--ProjectPoint(worldSpacePoint : Vector4) : Vector4;
--UnprojectPoint(screenSpacePoint : Vector2) : Vector4;






