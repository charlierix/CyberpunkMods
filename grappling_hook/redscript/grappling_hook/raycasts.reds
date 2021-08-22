//NOTE: Collision hulls don't reliably load in beyond about 50
@addMethod(PlayerPuppet)
public func GrapplingHook_RayCast(from: Vector4, to: Vector4, staticOnly: Bool) -> TraceResult {
    let spacialQuery: ref<SpatialQueriesSystem>;
    spacialQuery = GameInstance.GetSpatialQueriesSystem(this.GetGame());

    let result: TraceResult;
    let attempt: TraceResult;

    let distSqr: Float;
    distSqr = -1.00;

    let attemptDistSqr: Float;

    // Concrete, buildings
    if spacialQuery.SyncRaycastByCollisionGroup(from, to, n"Static", attempt) {
        attemptDistSqr = GrapplingHook_LenSqr(from, attempt.position);

        if distSqr < 0.00 || attemptDistSqr < distSqr {
            distSqr = attemptDistSqr;
            result = attempt;
            //Log("GrapplingHook_RayCast: static");
        };
    };

    // More objects, but it's not perfect.  The top part of street lights are seen, but the vertical
    // part never is.  I don't think trees will register either.  People aren't seen by this either
    if !staticOnly && spacialQuery.SyncRaycastByCollisionGroup(from, to, n"Dynamic", attempt) {
        attemptDistSqr = GrapplingHook_LenSqr(from, attempt.position);

        if distSqr < 0.00 || attemptDistSqr < distSqr {
            distSqr = attemptDistSqr;
            result = attempt;
            //Log("GrapplingHook_RayCast: dynamic");
        };
    };

    if !staticOnly && spacialQuery.SyncRaycastByCollisionGroup(from, to, n"Vehicle", attempt) {
        attemptDistSqr = GrapplingHook_LenSqr(from, attempt.position);

        if distSqr < 0.00 || attemptDistSqr < distSqr {
            distSqr = attemptDistSqr;
            result = attempt;
            //Log("GrapplingHook_RayCast: vehicle");
        };
    };

    // This never worked
    // if !staticOnly && spacialQuery.SyncRaycastByCollisionGroup(from, to, n"Simple Environment Collision", attempt) {
    //     attemptDistSqr = GrapplingHook_LenSqr(from, attempt.position);

    //     if distSqr < 0.00 || attemptDistSqr < distSqr {
    //         distSqr = attemptDistSqr;
    //         result = attempt;
    //         Log("GrapplingHook_RayCast: Simple Environment Collision");
    //     };
    // };

    // If the position's coords are infinite, then there was no hit
    //NOTE: CET can look at: tostring(result.position.x) == "inf", or result.position.x == tonumber("inf")
    return result;
}

// Can't use Vector4.DistanceSquared, since TraceResult's position is a Vector3 (calling cast would work, but
// it's seems cleaner to just make my own)
private func GrapplingHook_LenSqr(from: Vector4, to: Vector3) -> Float
{
    return
        ((to.X - from.X) * (to.X - from.X)) +
        ((to.Y - from.Y) * (to.Y - from.Y)) +
        ((to.Z - from.Z) * (to.Z - from.Z));
}





// @addMethod(PlayerPuppet)
// public func GrapplingHook_RayCast_Position_ATTEMPTS(from: Vector4, to: Vector4, staticOnly: Bool) -> String {
//     let filter: CName;
//     if staticOnly {
//         //filter = n"World Static";
//         filter = n"Static";
//     } else {
//         // nil gives a compile error, see if not set will work
//         //filter = nil;

//https://github.com/WolvenKit/cet-examples/blob/main/ai-components/TargetingHelper.lua#L11
// local filters = {
//     'Dynamic', -- Movable Objects
//     'Vehicle',
//     'Static', -- Buildings, Concrete Roads, Crates, etc.
//     'Water',
//     'Terrain',
//     'PlayerBlocker', -- Trees, Billboards, Barriers
// }

//         // this also gives a compile error
//         //filter = n"World Static" | n"Static" | n"Dynamic" | n"Vehicle" | n"Simple Environment Collision" | n"Vehicle Chassis" | n"Player Hitbox";

//         // I couldn't find any example of CNames being ORed together, so it would probably require multiple
//         // ray casts - one for each filter type
//         Log("TODO: Figure out how to do an unfiltered ray cast");
//         return "";
//     };

//     //NOTE: This returns nearly the same thing.  Position is nearly identical, but normal is different.  Going with preset, since
//     //more functions in adamsmasher use it.  Revisit this when normals are more important
//     let result: TraceResult;
//     if GameInstance.GetSpatialQueriesSystem(this.GetGame()).SyncRaycastByCollisionGroup(from, to, filter, result, true, false) {
//         //Log("Group hit" + result.position.X + "|" + result.position.Y + "|" + result.position.Z + "|" + result.normal.X + "|" + result.normal.Y + "|" + result.normal.Z + "|" + NameToString(result.material));
//         return result.position.X + "|" + result.position.Y + "|" + result.position.Z;
//     } else {
//         //Log("Group missed");
//         return "";
//     };

//     // This was just returning the from point, no matter what the to point was
//     // let result: TraceResult;
//     // GameInstance.GetSpatialQueriesSystem(this.GetGame()).SyncRaycastByCollisionPreset(from, to, filter, result);

//     // return result;
//     // };
// }