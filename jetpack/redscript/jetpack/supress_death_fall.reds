//NOTE: This didn't work, and there was a report that removing this override prevented some CTDs
//Keeping the file, because people may not delete existing files before copying new ones

// This gets called from many places.  It seems to calculate terminal velocity based when the height
// that the player left the ground
// @replaceMethod(LocomotionTransition)
//   protected final const func GetFallingSpeedBasedOnHeight(scriptInterface: ref<StateGameScriptInterface>, height: Float) -> Float {
//     if height < 0.00 {
//       return 0.00;
//     };

//     let playerPuppet: ref<PlayerPuppet>;
//     playerPuppet = (scriptInterface.executionOwner as PlayerPuppet);

//     if NotEquals(playerPuppet, null) && playerPuppet.Custom_SuppressFalling {       // discord was talking about using NotEquals instead of RefToBool(playerPuppet)
//         // Return an insanely high value so there is no death animation and death on ground impact
//         return -99999.00;
//     } else {
//       // Default Behavior
//       let locomotionParameters: ref<LocomotionParameters>;
//       locomotionParameters = new LocomotionParameters();
//       this.GetStateDefaultLocomotionParameters(scriptInterface, locomotionParameters);

//       let acc: Float;
//       acc = AbsF(locomotionParameters.GetUpwardsGravity(this.GetStaticFloatParameter("defaultGravity", -16.00)));

//       let speed: Float;
//       speed = 0.00;

//       if acc != 0.00 {
//         speed = acc * SqrtF(2.00 * height / acc);
//       };

//       return speed * -1.00;
//     }
//   }
