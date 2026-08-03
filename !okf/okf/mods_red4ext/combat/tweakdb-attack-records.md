---
type: Mechanic Pattern
title: TweakDB Attack Record Modification
description: Modifying Attacks.* TweakDB records to alter static attack damage values and properties.
tags: [combat tweakdb attacks]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Attack Record Modification

Modifying Attacks.* TweakDB records to alter static attack damage values and properties.

## Approach

Mods modify `Attacks.*` TweakDB records via YAML tweak files to change base damage values, damage types, or attack properties. This is a static data approach compared to runtime hit event interception — the values are set at load time rather than computed per-hit.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 03. EX-1 Cybercriminal-28768-1-0-1775734058 | `r6/tweaks/EX1/EX1_Cybercriminal.yaml` | Modifies Attacks.* TweakDB records |
| Carnage Grenade Launcher - Slower Reload-27730-1-0-1772155585 | `r6/tweaks/Carnage MPGL/Carnage_MPGL.yaml` | Modifies Attacks.* TweakDB records |
| Doctrine Hydra V1.0.3 32034 1.0.3 2026-08-03T07-48Z psSjsvrFY | `r6/tweaks/DoctrineMultiTargetLauncher/attacks_and_rounds.yaml` | Modifies Attacks.* TweakDB records |
| Exagryph Iconic Smart LMG-24124-1-0-0-1757971368 | `r6/tweaks/ZZZBSG_iconic/exagryph.yaml` | Modifies Attacks.* TweakDB records |
| ExplosionShake V2.11 31285 2.11 2026-07-13T15-41Z 8ViLVPoT0 | `r6/tweaks/ExplosionShake/ExplosionStandupFix.yaml` | Modifies Attacks.* TweakDB records |

*15 more mods use this pattern.*

## Related Concepts

- [Attack Data Modification](/combat/attack-data-modification.md) — Manipulating AttackData structures to change attack properties like damage type, range, or impact.
- [Runtime TweakDB Modification](/systems/tweakdb-runtime-modification.md) — Using CET or REDScript to modify TweakDB records at runtime rather than via static YAML files.
