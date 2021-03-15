//NOTE: These are named so that the default value of false is standard behavior (game acts normally
//if CET doesn't change it)

// This is defined in the jetpack mod.  The game errors on startup when multiple mods try to add
// the same field.  Grappling Hook doesn't need to use this property, just listing it here for
// completeness
//
// This is to allow multiple mods to coexist that do flight and use the same controls.  Whenever a
// mod enters flight, set this to true so that other mods will know to not enter flight
// @addField(PlayerPuppet)
// public let Custom_IsFlying: Bool;
