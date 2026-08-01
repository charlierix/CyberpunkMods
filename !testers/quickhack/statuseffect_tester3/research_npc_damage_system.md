# NPC Damage System Research

## Problem Statement

Tester3 applied 41 status effect IDs to NPCs via `StatusEffectHelper.ApplyStatusEffect`. All returned API SUCCESS. NPCs showed visual/audio reactions (animations, alert states) but **no damage was dealt** — except for the Blackwall effect (`BaseStatusEffect.SoMi_Q306_BlackwallHackUpload` / `BaseStatusEffect.CyberwareMalfunctionBlackwall`), which killed the NPC instantly.

## Root Cause: Base Status Effects vs Quickhack-Specific Variants

### The Core Distinction

Status effect TweakDB records come in two variants:

| Variant | TweakDB Path Pattern | Contains DealDamageModule? | Effect |
|---------|---------------------|----------------------------|-------|
| **Base Status Effect** | `BaseStatusEffect.Overheat` | No | Visual/audio/behavioral modules only — burning animation, smoke particles, AI alert, stagger |
| **Quickhack-Specific Variant** | `Attacks.QuickHack.Overheat` or `BaseStatusEffect.OverheatQuickhack` | Yes | Contains `DealDamageModule` — produces visual effect AND deals damage |

Tester3 was applying **base status effect IDs** only. These records contain modules for:
- `VisualEffectModule` — burning animation, smoke particles, glitch effects
- `AudioEffectModule` — sound cues
- `StatModifierModule` — movement speed, armor, stat changes
- AI behavioral changes — alert, stagger, confusion

But they do **NOT** contain a `DealDamageModule`. The actual damage comes from the quickhack-specific variant of the status effect record, which is a **different TweakDB record** entirely.

> QUESTION: did the other quickhack or stateffect testers try those quickhack specific variants?  if yes: why did they fail, if no: let's try them in the next tester

### Why Blackwall Worked

The Blackwall status effects are special:
- `BaseStatusEffect.SoMi_Q306_BlackwallHackUpload` — this is a **quest-specific** status effect that **does** contain a `DealDamageModule` with massive/instant-kill damage values.
- `BaseStatusEffect.CyberwareMalfunctionBlackwall` — similarly contains a damage module.

These are not typical base status effects — they were created for the story quest (SoMi/Alt Cunningham storyline) and include the full damage payload built in. That is why they killed NPCs when all other base status effects only triggered visuals.

### How the Blackwall Mod Actually Kills

From the Blackwall mod source code (`blackwall/Init.lua`):

```lua
-- 1. Apply the Blackwall status effect (contains DealDamageModule)
StatusEffectHelper.ApplyStatusEffect(target, "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload", Game.GetPlayer())

-- 2. Direct kill fallback via StatPoolsSystem
Game.GetQuestSystem():GetQuestLogSystem():GetStatPoolsSystem():RequestSettingMinValue(target:GetID(), "Health", 0.0)

-- 3. Set NPC state to Collapse (death)
target:SetCurrentState(gamedataNPCEncounterState.Collapse)
```

The mod uses **three layers** to ensure death:
1. The quest status effect with its built-in `DealDamageModule`
2. Direct health pool manipulation via `StatPoolsSystem`
3. State transition to `Collapse` (NPC death state)

## The Damage System in Cyberpunk 2077

### Architecture

Damage in Cyberpunk 2077 is **separate from the status effect system**:

```
Quickhack Execution Pipeline:
  1. Player triggers quickhack on target
  2. QuickhackSystem checks prerequisites (RAM, cyberdeck, intelligence, target type)
  3. QuickhackSystem executes the quickhack attack record (e.g., Attacks.QuickHack.Overheat)
  4. The attack record applies its status effect variant (which contains DealDamageModule)
  5. DealDamageModule creates a HitEvent with damage data
  6. DamageManager / GameDamageManager processes the HitEvent
  7. HitEvent reduces target health pool
  8. Visual/audio modules trigger simultaneously
```

### Key Components

| Component | CET API | Description |
|-----------|---------|-------------|
| `HitEvent` | Constructed in code | Carries damage amount, damage type, hit position, source entity |
| `DamageManager` | `Game.GetDamageSystem()` | Processes HitEvents and applies damage to entities |
| `StatPoolsSystem` | `Game.GetQuestSystem():GetQuestLogSystem():GetStatPoolsSystem()` | Manages health pools; can set min/max values directly |
| `QuickhackSystem` | `Game.GetQuickhackSystem()` | Manages quickhack execution pipeline |

### Quickhack Attack Records (NPC)

These are the TweakDB records that contain `DealDamageModule`s:

| Quickhack | TweakDB Path | Damage Type |
|-----------|-------------|-------------|
| Overheat | `Attacks.QuickHack.Overheat` | Thermal (burning DOT) |
| Contagion | `Attacks.QuickHack.Contagion` | Chemical (poison DOT) |
| Short Circuit | `Attacks.QuickHack.ShortCircuit` | EMP (instant) |
| Suicide | `Attacks.QuickHack.Suicide` | Instant death |
| Cyber Psychosis | `Attacks.QuickHack.CyberPsychosis` | Behavioral (no direct damage, causes NPC to attack allies) |

### Methods to Deal Damage via CET

**Method 1: Apply quickhack-specific status effect variant**
```lua
-- Instead of BaseStatusEffect.Overheat, use the quickhack variant
StatusEffectHelper.ApplyStatusEffect(target, "Attacks.QuickHack.Overheat", Game.GetPlayer())
-- This contains DealDamageModule and will deal damage
```

**Method 2: Use QuickhackSystem to execute the full pipeline**
```lua
local quickhackSystem = Game.GetQuickhackSystem()
-- Get available quickhacks for the target
local availableHacks = quickhackSystem:GetAvailableQuickhacksForTarget(target)
-- Execute a quickhack (triggers full pipeline including damage)
quickhackSystem:ExecuteQuickhack(target)
```

**Method 3: Direct damage via DamageSystem**
```lua
-- Construct a HitEvent and process it
local hitEvent = HitEvent.new()
hitEvent.damageValues = {100.0}  -- damage amount
hitEvent.hitPosition = target:GetWorldPosition()
hitEvent.source = Game.GetPlayer()
Game.GetDamageSystem():ProcessHitEvent(hitEvent)
```

**Method 4: Direct health manipulation via StatPoolsSystem**
```lua
-- Set health to 0 (instant kill)
Game.GetQuestSystem():GetQuestLogSystem():GetStatPoolsSystem():RequestSettingMinValue(target:GetID(), "Health", 0.0)
-- Set NPC to collapse/death state
target:SetCurrentState(gamedataNPCEncounterState.Collapse)
```

## Why Each Observed Effect Behaved as It Did

| Status Effect | Expected Behavior | Observed | Explanation |
|--------------|-------------------|----------|-------------|
| Overheat | Burning visual + thermal damage | Visual only, no damage | Applied base effect, no DealDamageModule |
| Burning | Burning visual + thermal damage | Visual only | Same — base effect, no damage module |
| Contagion Poison | Poison visual + chemical DOT | Visual only | Base effect, no damage module |
| EMP | EMP visual + EMP damage | Visual only | Base effect, no damage module |
| Stun | Stun behavior | Worked (behavioral) | Base effect has StatModifierModule for stun — no damage needed |
| Blind | Blind behavior | Worked (behavioral) | StatModifierModule for vision — no damage needed |
| Madness | Confusion behavior | Worked (behavioral) | StatModifierModule for AI state change — no damage needed |
| Ping | Reveal behavior | Worked (behavioral) | StatModifierModule for reveal — no damage needed |
| Locomotion Malfunction | Movement halt | Worked (behavioral) | StatModifierModule for movement — no damage needed |
| Cyberware Malfunction | CW malfunction | Visual only | Base effect, no damage module |
| BlackwallHackUpload | Instant death | **Killed NPC** | Quest-specific effect WITH DealDamageModule (massive damage) |
| CyberwareMalfunctionBlackwall | Instant death | **Killed NPC** | Quest-specific effect WITH DealDamageModule |

## Key Theories Confirmed

1. **Status effects do not equal damage.** Applying a base status effect triggers only visual/audio/behavioral modules. Damage requires a `DealDamageModule` which is only present in quickhack-specific variants.

2. **The tester used the wrong TweakDB records.** `BaseStatusEffect.Overheat` is the visual layer. `Attacks.QuickHack.Overheat` is the full quickhack with damage. This is a fundamental record-type mismatch.

3. **Blackwall is a special case.** The quest-specific Blackwall status effects have built-in `DealDamageModule`s with massive damage, unlike standard base effects.

4. **Behavioral effects work without damage modules.** Effects like Stun, Blind, Madness, and Locomotion Malfunction work because they use `StatModifierModule` (stat/behavior changes) rather than `DealDamageModule` (HP reduction). They do not need damage to function.

## Recommendations for Tester 4

1. **Switch from base status effects to quickhack attack records.** Use `Attacks.QuickHack.*` IDs instead of `BaseStatusEffect.*` IDs.
2. **Or use the QuickhackSystem API.** Call `GetAvailableQuickhacksForTarget(target)` to get the correct list, then `ExecuteQuickhack(target)` to trigger the full pipeline.
3. **Or use the damage system directly.** Construct `HitEvent`s and process them via `Game.GetDamageSystem():ProcessHitEvent()`.
4. **For instant kill effects**, use `StatPoolsSystem:RequestSettingMinValue()` + `SetCurrentState(Collapse)` as the Blackwall mod does.
5. **Verify the TweakDB record structure** by querying each record modules to confirm which ones contain `DealDamageModule` vs only visual/behavioral modules.

## Sources

- okf knowledge base: `okf/api/effects/status_effect_modules.md`
- okf knowledge base: `okf/api/effects/deal_damage.md`
- okf knowledge base: `okf/api/effects/status_effect_analysis.md`
- okf knowledge base: `okf/api/game-systems/quickhack_system.md`
- okf knowledge base: `okf/api/game-systems/damage_system.md`
- okf knowledge base: `okf/api/tweakdb-records/quickhack_records.md`
- okf knowledge base: `okf/api/tweakdb-records/status_effect_records.md`
- Blackwall mod source code: `sources - extra/cyberware - quickhack/blackwall-9759-1-0-2-2-1734512054/blackwall/Init.lua`
- Test results: `testers/quickhack/statuseffect_tester3/TEST RESULTS.md`
- Prior analysis: `testers/quickhack/QUICKHACK_PREREQUISITES_ANALYSIS.md`
