// This is to allow multiple mods to coexist that do flight and use the same controls.  Whenever a
// mod enters flight, it sets this to the name of the mod
//
// There are two ways this can be used by the flight mods
//  1) If a mod wants to enter flight, it could check this first to make sure it won't interfere.
//
//     For example.  While flying with low flying v, holding in the spacebar means go up, but it
//     will also make jetpack want to activate.  But jetpack would know not to
//
//  2) A mod could decide to just enter flight, even though another mod is currently flying.  It
//     would change this string to its name, the other mod would notice that it's name is not
//     current, so it would drop out of flight
//
//     For example, while in the middle of jetpacking, the user decides to grapple.  So grapple
//     starts, jetpack sees that and turns off
//
//     The opposite would also be valid: While in the middle of a grapple swing, the user may hold
//     in spacebar to jetpack away, and grappling hook would know to stop its flight


@addField(PlayerPuppet)
public let Custom_CurrentlyFlying: String;


// ------------------------------------------- NOTE ------------------------------------------- //
//                                                                                              //
// Each flight mod that uses this property will have the same copy of this file, so it doesn't  //
// matter which overwrites which.  If a second shared property is ever needed, put it in its    //
// own file inside this folder so there's no chance of version conflicts                        //
//                                                                                              //
// -------------------------------------------------------------------------------------------- //
