# RED4ext -- Custom Entity Tester 1

## v1: Not Required

For v1, the tester uses a **real entity** (currently an AV vehicle) spawned via `GameEntitySpawner.SpawnEntity` from CET. This doesn't require a custom C++ entity class.

The REDscript bridge (`OrbHackingBridge.reds`) handles the `SetUp(ps)` call and native pipeline execution, which is the core fix being tested.

## v2/v3: Custom Entity Class

Future versions will need a RED4ext C++ plugin to define a **custom entity class** with:
- Minimal components (no rendering, no AI, no locomotion)
- Fake `EquipmentSystemData` reporting cyberdeck equipped
- Custom resource pool (replacing Memory/RAM)
- Optimized for companion orb use case

See the proposal document at `docs/device hacks/proposal - shell entity for device hacking.md`.

## What RED4ext Would Provide (Future)

| Feature | REDscript | RED4ext (C++) |
|---|---|---|
| Custom entity class | Limited | Full control |
| Component setup | Limited | Full control |
| Hook native methods | Via Override | Native hooks |
| Performance | Interpreted | Compiled |
| Entity registration | Not supported | Supported |

For v1, the REDscript bridge is sufficient to prove the core concept.
