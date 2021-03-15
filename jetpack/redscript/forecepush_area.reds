// Posted by Ming
//https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/core/gameplay/targetingSearchFilter.swift
//
// Also inspired by Push NPCs mod
//https://www.nexusmods.com/cyberpunk2077/mods/739

// This will push NPCs near the player.  The search is a bit unreliable.  It gets everyone in front of
// the player, won't always get unseen NPCs
@addMethod(PlayerPuppet)
public func RagdollNPCs_StraightUp(radius: Float, pushForce: Float, randHorz: Float, randVert: Float) -> Void {

    let searchQuery: TargetSearchQuery;
    searchQuery = TSQ_ALL();
    searchQuery.maxDistance = radius;
    //searchQuery.searchFilter = TSF_NPC();       // this is the contents of TSF_NPC: TSF_And(TSF_All(TSFMV.Obj_Puppet | TSFMV.St_Alive), TSF_Not(TSFMV.Obj_Player));
    //searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player), TSF_Not(TSFMV.Att_Friendly));       // allow dead, not sure if friendly is the same as companion
    searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player));       // allow dead

    let targetParts: array<TS_TargetPartInfo>;
    GameInstance.
        GetTargetingSystem(this.GetGame()).
        GetTargetParts(this, searchQuery, targetParts);

    let npc: ref<NPCPuppet>;

    let i: Int32;
    i = 0;

    while i < ArraySize(targetParts) {
        npc = (TS_TargetPartInfo.GetComponent(targetParts[i]).GetEntity() as NPCPuppet);

        if(NotEquals(npc, null)) {
            // Log("--------------------------");
            // Log("GetBodyType: " + NameToString(npc.GetBodyType()));
            // Log("GetClassName: " + NameToString(npc.GetClassName()));
            // Log("GetName: " + NameToString(npc.GetName()));
            // if(npc.IsPaperdoll()) { Log("RagdollNPCs: IsPaperdoll"); }
            // if(npc.IsPlayerCompanion()) { Log("RagdollNPCs: IsPlayerCompanion"); }
            // if(npc.CanEnableRagdollComponent()) { Log("RagdollNPCs: CanEnableRagdollComponent"); }
            // if(npc.IsHostile()) { Log("RagdollNPCs: IsHostile"); }

            // It might already be ragdollable, but go ahead and make sure
            npc.SetDisableRagdoll(false);       // named as a double negative :(

            if ScriptedPuppet.CanRagdoll(npc) {
                let mult: Float;
                if(npc.IsCrowd() || npc.IsCharacterCivilian()) {
                    mult = 6.00;
                } else {
                    mult = 1.00;
                };

                let pos: Vector4;
                pos = npc.GetWorldPosition();

                npc.QueueEvent(CreateForceRagdollEvent(Cast("Launch Up")));
                npc.QueueEvent(CreateRagdollApplyImpulseEvent(pos, new Vector4(0.00, 0.00, 1.00, 1.00), 3.00));

                let direction: Vector4;
                direction = new Vector4(
                    RandRangeF(-randHorz * mult, randHorz * mult),
                    RandRangeF(-randHorz * mult, randHorz * mult),
                    RandRangeF((pushForce - randVert) * mult, (pushForce + randVert) * mult),
                    1.00);

                // The first one just staggers them, set a delay and hit them again
                GameInstance.GetDelaySystem(this.GetGame()).
                    DelayEvent(npc, CreateRagdollApplyImpulseEvent(pos, direction, 3.00), 0.10, false);
            };
        };

        i += 1;
    };
}

// This pushes all NPCs away from the player, like an explosion
@addMethod(PlayerPuppet)
public func RagdollNPCs_ExplodeOut(radius: Float, pushForce: Float, upForce: Float) -> Void {

    let searchQuery: TargetSearchQuery;
    searchQuery = TSQ_ALL();
    searchQuery.maxDistance = radius;
    searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player));       // allow dead

    let targetParts: array<TS_TargetPartInfo>;
    GameInstance.
        GetTargetingSystem(this.GetGame()).
        GetTargetParts(this, searchQuery, targetParts);

    let npc: ref<NPCPuppet>;

    let playerPos: Vector4;
    playerPos = this.GetWorldPosition();

    let i: Int32;
    i = 0;

    while i < ArraySize(targetParts) {
        npc = (TS_TargetPartInfo.GetComponent(targetParts[i]).GetEntity() as NPCPuppet);

        if(NotEquals(npc, null)) {
            // It might already be ragdollable, but go ahead and make sure
            npc.SetDisableRagdoll(false);       // named as a double negative :(

            if ScriptedPuppet.CanRagdoll(npc) {
                let mult: Float;
                if(npc.IsCrowd() || npc.IsCharacterCivilian()) {
                    mult = 6.00;
                } else {
                    mult = 1.00;
                };

                let pos: Vector4;
                pos = npc.GetWorldPosition();

                let distance: Float;
                distance = Vector4.Distance(playerPos, pos);

                if(distance > 0.01 && distance <= radius) {        // avoiding divide by zero, also making sure the query doesn't come back with objects too far away (shouldn't, but it's easy to check)
                    let distScaled: Float;
                    distScaled = distance / radius;

                    let percent: Float;
                    percent = (1.00 - distScaled) * (1.00 - distScaled);        // give a dropoff to zero
                    //percent = 1.00 - (distScaled * distScaled);

                    let adjustedForce: Float;
                    adjustedForce = pushForce * percent;

                    let finalForce: Float;
                    finalForce = adjustedForce + RandRangeF(-adjustedForce / 12.00, adjustedForce / 12.00);

                    let direction: Vector4;
                    direction = (pos - playerPos) / distScaled;     // unit vector

                    let finalDirection: Vector4;
                    finalDirection = new Vector4(
                        (direction.X * finalForce) * mult,
                        (direction.Y * finalForce) * mult,
                        ((direction.Z * finalForce) + upForce) * mult,      // give the z a bit extra up so they get picked up off the ground
                        1.00);      

                    npc.QueueEvent(CreateForceRagdollEvent(Cast("Explosion")));
                    npc.QueueEvent(CreateRagdollApplyImpulseEvent(pos, new Vector4(0.00, 0.00, 1.00, 1.00), 3.00));

                    // The first one just staggers them, set a delay and hit them again
                    GameInstance.GetDelaySystem(this.GetGame()).
                        DelayEvent(npc, CreateRagdollApplyImpulseEvent(pos, finalDirection, 3.00), 0.10, false);
                };
            };
        };

        i += 1;
    };
}

// This function isn't seen by the other functions, need to copy contents to each
// // Some npcs require a stronger impulse
// @addMethod(PlayerPuppet)
// public func GetRagdollMultiplier() -> Float {
//     if(this.IsCrowd() || this.IsCharacterCivilian()) {
//         return 6.00;
//     } else {
//         return 1.00;
//     };
// }
