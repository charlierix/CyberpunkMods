// Add impulse to player puppet
// Copied from "Fly Like An Albatross" by McUsher1
// https://www.nexusmods.com/cyberpunk2077/mods/1550
@addMethod(PlayerPuppet)
public func GrapplingHook_AddImpulse(x: Float, y: Float, z: Float) -> Vector4 {
  let impulse = new Vector4(x, y, z, 1.0);

  //TODO: See if this reassignment is necessary
  impulse.X = x;
  impulse.Y = y;
  impulse.Z = z;

  let ev: ref<PSMImpulse>;
  ev = new PSMImpulse();
  ev.id = n"impulse";
  ev.impulse = impulse;

  this.QueueEvent(ev);

  return impulse;
}