--SpatialQueriesSystem

-- this call gets raycastResult:
-- public native struct TraceResult
--      position: Vector3
--      normal: Vector3
--      material: CName


-- public native SyncRaycastByCollisionPreset(start: Vector4, end: Vector4, opt collisionPreset: CName, out result: TraceResult, opt staticOnly: Bool, opt dynamicOnly: Bool): Bool
-- public native SyncRaycastByCollisionGroup(start: Vector4, end: Vector4, opt collisionGroup: CName, out result: TraceResult, opt staticOnly: Bool, opt dynamicOnly: Bool): Bool



-- public final static func GetFloorAngle(sourceObject: wref<GameObject>, out floorAngle: Float) -> Bool {
--     let startPosition: Vector4;
--     let endPosition: Vector4;
--     let raycastSuccess: Bool;
--     let raycastResult: TraceResult;
--     startPosition = sourceObject.GetWorldPosition() + new Vector4(0.00, 0.00, 0.10, 0.00);
--     endPosition = sourceObject.GetWorldPosition() + new Vector4(0.00, 0.00, -0.30, 0.00);
--     if GameInstance.GetSpatialQueriesSystem(sourceObject.GetGame()).SyncRaycastByCollisionGroup(startPosition, endPosition, n"Static", raycastResult, true, false) {
--       floorAngle = Vector4.GetAngleBetween(Cast(raycastResult.normal), sourceObject.GetWorldUp());
--       return true;
--     };
--     return false;
--   }


--GameInstance.GetSpatialQueriesSystem(this.GetOwner().GetGame()).SyncRaycastByCollisionPreset(this.GetOwner().GetWorldPosition() + new Vector4(0.00, 0.00, 0.50, 0.00), stimEvent.sourcePosition, n"Player Hitbox", raycastTrace);
--GameInstance.GetSpatialQueriesSystem(owner.GetGame()).SyncRaycastByCollisionPreset(WorldPosition.ToVector4(WorldTransform.GetWorldPosition(originTransform)) + new Vector4(0.00, 0.00, 0.10, 0.00), WorldPosition.ToVector4(WorldTransform.GetWorldPosition(originTransform)) + new Vector4(0.00, 0.00, -0.70, 0.00), n"Vehicle Chassis", vehicleCheckTrace);
--GameInstance.GetSpatialQueriesSystem(owner.GetGame()).SyncRaycastByCollisionPreset(WorldPosition.ToVector4(WorldTransform.GetWorldPosition(originTransform)) + new Vector4(0.00, 0.00, 0.10, 0.00), WorldPosition.ToVector4(WorldTransform.GetWorldPosition(originTransform)) + new Vector4(0.00, 0.00, -5.00, 0.00), n"World Static", queryPositionTrace);
--GameInstance.GetSpatialQueriesSystem(EffectScriptContext.GetGameInstance(ctx)).SyncRaycastByCollisionPreset(startPoint, endPoint, n"World Static", raycastResult);


-----------------------


-- There are a bunch of ray cast functions off of StateGameScriptInterface, but how to get an instance of it?


-- public native struct QueryFilter
-- methods
-- public static native ALL(): QueryFilter
-- public static native ZERO(): QueryFilter
-- public static native AddGroup(out filter: QueryFilter, group: CName): Void

--foundCollision = scriptInterface.RayCastWithCollisionFilter(fppPosition, targetPosition, queryFilter);

--foundCollision is of type TraceResult





--rayCastTraceResult2 = scriptInterface.RayCast(rayCastSourcePosition2, rayCastDestinationPosition2, n"Simple Environment Collision");




---------------------

--https://www.lua.org/pil/20.1.html


-- local t = {}                   -- table to store the indices
-- local i = 0
-- while true do
--   i = string.find(s, "\n", i+1)    -- find 'next' newline
--   if i == nil then break end
--   table.insert(t, i)
-- end



-- s = "hello world"
-- i, j = string.find(s, "hello")
-- print(i, j)                      --> 1    5
-- print(string.sub(s, i, j))       --> hello
-- print(string.find(s, "world"))   --> 7    11
-- i, j = string.find(s, "l")
-- print(i, j)                      --> 3    3
-- print(string.find(s, "lll"))     --> nil
