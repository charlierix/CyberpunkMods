//NOTE: These are named so that the default value of false is standard behavior (game acts normally
//if CET doesn't change it)

// This is to allow multiple mods to coexist that do flight and use the same controls.  Whenever a
// mod enters flight, set this to true so that other mods will know to not enter flight
@addField(PlayerPuppet)
public let Custom_IsFlying: Bool;

//REMOVING, it didn't work
// This is a way for overridden locomotion classes to know not to enter the death fall animation
// @addField(PlayerPuppet)
// public let Custom_SuppressFalling: Bool;
