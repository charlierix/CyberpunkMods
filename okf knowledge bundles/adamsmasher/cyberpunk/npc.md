---
type: "Class System"
title: "NPC System"
description: "NPC puppet system with stats listeners, AI phase handlers, centaur shields, hit reactions, mechanical impacts, NPC states, squads, and status effects."
resource: "!cyberpunk/NPC/NPCPuppet.swift"
tags: ['cyberpunk', 'npc']
timestamp: 2026-07-01T13:00:55Z
---

# NPC System

NPC puppet system with stats listeners, AI phase handlers, centaur shields, hit reactions, mechanical impacts, NPC states, squads, and status effects.

## Source Files

- `cyberpunk/NPC/NPCPuppet.swift`
- `cyberpunk/NPC/components/aiPhaseStateHandler.swift`
- `cyberpunk/NPC/components/centaurShieldController.swift`
- `cyberpunk/NPC/components/eventHandlerComponent.swift`
- `cyberpunk/NPC/components/hitReactionComponent.swift`
- `cyberpunk/NPC/components/hitReactionMechComponent.swift`
- `cyberpunk/NPC/components/mechanicalImpactComponent.swift`
- `cyberpunk/NPC/components/npcStateComponent.swift`
- `cyberpunk/NPC/components/squadComponentImpl.swift`
- `cyberpunk/NPC/components/statusEffectComponent.swift`

## Member Types

**Total declarations: 32**

### Classs (19)

| Name | Bases | Source File |
|------|-------|-------------|
| PlayerStatsListener | ScriptStatsListener | cyberpunk/NPC/NPCPuppet.swift |
| NPCGodModeListener | ScriptStatsListener | cyberpunk/NPC/NPCPuppet.swift |
| NPCDeathListener | ScriptStatPoolsListener | cyberpunk/NPC/NPCPuppet.swift |
| NPCPoiseListener | ScriptStatPoolsListener | cyberpunk/NPC/NPCPuppet.swift |
| NPCPuppet | ScriptedPuppet | cyberpunk/NPC/NPCPuppet.swift |
| NonStealthQuickHackVictimEvent | Event | cyberpunk/NPC/NPCPuppet.swift |
| AIPhaseStateEventHandlerComponent | AIRelatedComponents | cyberpunk/NPC/components/aiPhaseStateHandler.swift |
| CentaurShieldController | AICustomComponents | cyberpunk/NPC/components/centaurShieldController.swift |
| HitReactionBehaviorData | IScriptable | cyberpunk/NPC/components/hitReactionComponent.swift |
| NPCHealthListener | ScriptStatPoolsListener | cyberpunk/NPC/components/hitReactionComponent.swift |
| NPCHitReactionComponentStatsListener | ScriptStatsListener | cyberpunk/NPC/components/hitReactionComponent.swift |
| HitReactionComponent | AIMandatoryComponents | cyberpunk/NPC/components/hitReactionComponent.swift |
| HitReactionMechComponent | HitReactionComponent | cyberpunk/NPC/components/hitReactionMechComponent.swift |
| MechanicalImpactComponent | IComponent | cyberpunk/NPC/components/mechanicalImpactComponent.swift |
| NPCStatesComponent | AINetStateComponent | cyberpunk/NPC/components/npcStateComponent.swift |
| SquadMemberBaseComponent | SquadMemberComponent | cyberpunk/NPC/components/squadComponentImpl.swift |
| PuppetSquadInterface | CombatSquadScriptInterface | cyberpunk/NPC/components/squadComponentImpl.swift |
| PlayerSquadInterface | PuppetSquadInterface | cyberpunk/NPC/components/squadComponentImpl.swift |
| StatusEffectManagerComponent | AIMandatoryComponents | cyberpunk/NPC/components/statusEffectComponent.swift |

### Static Funcs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| Cast |  | cyberpunk/NPC/components/eventHandlerComponent.swift |

### Funcs (12)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatChanged |  | cyberpunk/NPC/NPCPuppet.swift |
| OnGodModeChanged |  | cyberpunk/NPC/NPCPuppet.swift |
| Kill |  | cyberpunk/NPC/NPCPuppet.swift |
| UpdateAdditionalScanningData |  | cyberpunk/NPC/NPCPuppet.swift |
| OnStatPoolValueChanged |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| OnStatChanged |  | cyberpunk/NPC/NPCPuppet.swift |
| OnGameAttach |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| OnGameAttached |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| EvaluateHit |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| UpdateCoverDamage |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| OnGameAttached |  | cyberpunk/NPC/components/hitReactionComponent.swift |
| EvaluateHit |  | cyberpunk/NPC/components/hitReactionComponent.swift |

## Citations

- `cyberpunk/NPC/NPCPuppet.swift`
- `cyberpunk/NPC/components/aiPhaseStateHandler.swift`
- `cyberpunk/NPC/components/centaurShieldController.swift`
- `cyberpunk/NPC/components/eventHandlerComponent.swift`
- `cyberpunk/NPC/components/hitReactionComponent.swift`
- `cyberpunk/NPC/components/hitReactionMechComponent.swift`
- `cyberpunk/NPC/components/mechanicalImpactComponent.swift`
- `cyberpunk/NPC/components/npcStateComponent.swift`
- `cyberpunk/NPC/components/squadComponentImpl.swift`
- `cyberpunk/NPC/components/statusEffectComponent.swift`
