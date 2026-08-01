### Answers to your physics questions

**Is the impulse applied in world coords or model coords?**

**World coordinates.** The WolvenKit class definition (`enteventsPhysicalImpulseEvent.cs`) confirms `worldImpulse` is a `Vector3` in world space. So an impulse of `(0, 0, force)` always pushes straight up in world Z, regardless of how the vehicle is rotated.

**Can the impulse be applied at some point above the center of mass?**

Yes — `worldPosition` is the application point. But applying **above** center of mass creates a **torque arm**, which produces rotation (like a rocket nozzle on the bottom of the vehicle pushes the nose down). That's the opposite of what we want for a stable hover.

**Is there a version of the impulse function that is translation only (no torque)?**

**No separate function exists.** `PhysicalImpulseEvent` always applies both force and torque. The only way to get pure translation is to apply the impulse **at the center of mass** (zero torque arm). That's exactly what tester2 does.

**Why did impulse strength change with rotation?**

This was the key bug in tester 1. `PhysicalImpulseEvent` applies a **spherical** impulse — it only affects collision shapes that overlap a sphere at `worldPosition` with `radius`. Tester 1 split the impulse into two points at ±1.5m along the forward vector, each with `radius=1.0`. When the vehicle rotated, those small spheres at offset points partially missed the collision body, reducing effective force. Upright = maximum overlap = strongest; upside down = less overlap = weakest.

---

### Changes in tester2

| Aspect | Tester 1 | Tester 2 |
|--------|----------|----------|
| Application point | Front + rear split (±1.5m) | **Single point at vehicle center** |
| Radius | 1.0 | **5.0** (always encompasses collision body) |
| Torque | Pitch from offset torque arm | **Zero** (center of mass = no torque arm) |
| Rotation-dependent strength | Yes (spheres miss body when rotated) | **No** (center always inside body) |
| Strength multiplier | 1.0 | **1.1** (10% stronger) |
| Hotkey names | `HVT_Toggle`, `HVT_Nudge` | `HVT2_Toggle`, `HVT2_Nudge` |
| Mod log name | `HoverVehicleTester` | `HoverVehicleTester2` |

All other control logic (spring-damper tuning, anti-gravity, ground raycast, teleport nudge escape hatch, diagnostics) is carried over unchanged from tester 1.