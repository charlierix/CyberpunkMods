---
type: Mechanic Pattern
title: TweakDB Base Stats Modification
description: Modifying BaseStats.* TweakDB records to alter base character statistics.
tags: [player stats tweakdb]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Base Stats Modification

Modifying BaseStats.* TweakDB records to alter base character statistics.

## Approach

Mods modify `BaseStats.*` TweakDB records to change base character stats like health, stamina, armor, or cyberware capacity. This is a static data approach — stats are modified at load time rather than computed at runtime.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/tweaks/ArmorUp/cyberware/heavyArmorPlating.yaml` | Modifies BaseStats.* records |
| DropPointsReimagined-29563-1-0-0-1778351569 | `r6/tweaks/DropPointsReimagined/Package/ServiceTier.yaml` | Modifies BaseStats.* records |
| Graven's Attribute Expansion-10250-1-01-1698033259 | `r6/tweaks/HealthPerLevelBaseStatDeclarations.yaml` | Modifies BaseStats.* records |
| Health Mod-10213-1-01-1697839946 | `r6/tweaks/HealthPerLevelBaseStatDeclarations.yaml` | Modifies BaseStats.* records |
| Immersive Cyberware-21916-1-0-2-1755792059 | `r6/tweaks/ImmersiveCyberware/biomon.yaml` | Modifies BaseStats.* records |

*17 more mods use this pattern.*

## Related Concepts

- [Stats System Modification](/player/stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
