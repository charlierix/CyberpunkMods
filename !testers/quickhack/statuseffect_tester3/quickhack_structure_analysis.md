# Quickhack & Status Effect Structure Analysis

> **Source**: Examination of custom quickhack mods in `sources - extra/cyberware - quickhack/`
> Primary references: Zeusico Quickhacks (death_from_above, clone, solo, etc.), Charm Quickhack, Blackwall Quickhack, Teleport Quickhack
> Companion doc: `research_npc_damage_system.md`

## Verdict on the Hypothesis

> **"Quickhacks/status effects are like macros that do a chain of actions"**

**Partially confirmed, but the analogy needs refinement.** Quickhacks are not freeform scripts/macros. They are **structured networks of typed TweakDB records** that the game engine processes through a **fixed pipeline**. Each record is a strongly-typed data node (e.g., `gamedataObjectAction_Record`, `gamedataStatusEffect_Record`) with specific fields the engine knows how to interpret.

Think of it less as a macro language and more as a **data-driven component system** — you wire together pre-built engine components (actions, effects, costs, prereqs, status effects, items) by referencing each other by TweakDB ID. The engine reads the graph and executes it.

There IS a chain of execution, but it's a fixed pipeline, not arbitrary code:

```
Player triggers hack in scanner
  -> QuickhackSystem validates prerequisites (memory, ability, target type)
  -> Upload time elapses (activationTime stat modifiers)
  -> Memory cost deducted (StatPoolCost)
  -> startEffects fire immediately
  -> completionEffects fire when upload finishes
    -> Each ObjectActionEffect applies its referenced statusEffect to the target
      -> Status effect packages apply stat modifiers, effectors, VFX/SFX
  -> Optional Lua runtime code handles behavior TweakDB can't express
```

## The Full Record Network

A complete quickhack is built from **~13 interconnected TweakDB record types**. Each is a separate YAML file in `r6/tweaks/`. Here is the complete inventory, using **Death From Above** as the worked example:

### 1. QuickHack Action Record (the core action definition)

**File**: `QuickHack.BaseDeathFromAboveHack.yaml`
**TweakDB Type**: `gamedataObjectAction_Record`

This is the **engine of the quickhack**. It defines what happens when the hack executes.

| Field | Purpose | Example Value |
|-------|---------|---------------|
| `actionName` | Internal action identifier | `DeathFromAbove` |
| `hackCategory` | Links to category record | `HackCategory.DeathFromAboveHack` |
| `objectActionType` | What kind of action | `ObjectActionType.PuppetQuickHack` |
| `objectActionUI` | Links to scanner interaction | `Interactions.DeathFromAboveHack` |
| `interactionLayer` | Remote vs local | `remote` |
| `isQuickHack` | Flag marking this as a quickhack | `True` |
| `activationTime` | Upload time stat modifiers | list of inline stat modifier refs |
| `costs` | Memory cost definition | `StatPoolCost` -> `BaseStatPools.Memory` |
| `instigatorPrereqs` | Player-side requirements | `QuickHack.QuickHack_inline1` |
| `targetActivePrereqs` | Target-side checks | `Prereqs.QuickHackUploadingPrereq`, `Prereqs.ChimeraNoQuickHackPrereq` |
| `startEffects` | Effects fired at upload start | `QuickHack.QuickHack_inline10` |
| `completionEffects` | Effects fired when upload completes | list of `ObjectActionEffect` refs |
| `priority` | UI ordering priority | `0` (base), `4` (variant) |
| `awarenessCost` | Enemy awareness raise amount | shared inline record |

The **variant record** (`QuickHack.DeathFromAboveLvl4PlusPlusHack.yaml`) extends this with an additional `completionEffects` entry:

```yaml
QuickHack.DeathFromAboveLvl4PlusPlusHack_inline3:
  $type: gamedataObjectActionEffect_Record
  recipient: ObjectActionReference.Target
  statusEffect: BaseStatusEffect.DeathFromAboveLevel4PlusPlus
```

This is how the hack delivers its payload — `completionEffects` contain `ObjectActionEffect` records that each point to a `BaseStatusEffect.*` record applied to the target.

### 2. Item Record (the shard/program you equip)

**File**: `Items.DeathFromAboveLvl4PlusPlusProgram.yaml`
**TweakDB Type**: `gamedataItem_Record`

This is the **physical item** — the quickhack program shard the player equips in their cyberdeck.

Key fields:
- `itemType: ItemType.Prt_Program` — it's a program part
- `quality: Quality.Legendary` — rarity tier
- `objectActions:` — **links to the QuickHack action records**:
  ```yaml
  objectActions:
    - ItemAction.ProgramDisassemble
    - QuickHack.DeathFromAboveLvl4PlusPlusHack
  ```
- `OnAttach:` — **links to EquipmentGLP records** for tooltip/tier data:
  ```yaml
  OnAttach:
    - EquipmentGLP.DeathFromAboveLvl1Program
    - EquipmentGLP.DeathFromAboveLvl2Program
    - EquipmentGLP.DeathFromAboveLvl3Program
    - EquipmentGLP.DeathFromAboveLvl4Program
  ```
- `placementSlots:` — which cyberdeck slots it can occupy (`AttachmentSlots.CyberdeckProgram1-8`)
- `tags:` — categorization tags (`itemPart`, `SoftwareShard`, `Tier0Shard` through `Tier6Shard`)
- `shardType:` — custom shard type identifier
- `icon:` — links to UIIcon record
- `buyPrice` / `sellPrice` — pricing formulas

### 3. EquipmentGLP Records (tooltip/perk description packages)

**File**: `EquipmentGLP.DeathFromAbovePrograms.yaml`
**TweakDB Type**: `gamedataGameplayLogicPackage_Record`

These define the **tooltip text and perk descriptions for each tier level** of the quickhack. One per tier (Lvl1-Lvl4+). Each has a `_inline0` UIData sub-record with `localizedDescription` and `localizedName` LocKeys.

These are what appear in the cyberdeck UI showing what each tier of the hack does.

### 4. Status Effect Record (the payload)

**File**: `BaseStatusEffect.DeathFromAboveLevel4PlusPlus.yaml`
**TweakDB Type**: `gamedataStatusEffect_Record`

This is what actually gets applied to the target (or player). Key structure:

| Field | Purpose | Example |
|-------|---------|---------|
| `statusEffectType` | Category | `BaseStatusEffectTypes.Quickhack` |
| `duration` | How long it lasts | stat modifier group -> `MaxDuration: 10` |
| `maxStacks` | Stack limit | `RTDB.StatusEffect_inline0` |
| `packages` | Gameplay logic packages | list of `GameplayLogicPackage` refs |
| `gameplayTags` | Tags for filtering | `Debuff`, `Quickhack`, `DeathFromAbove` |
| `uiData` | Status effect UI display | icon, display name, priority |
| `VFX` / `SFX` | Visual/audio effects | (often empty for custom hacks) |

The status effect's `packages` field links to `GameplayLogicPackage` records that contain the actual **stat modifiers** and **effectors** — the mechanical effects:

```yaml
BaseStatusEffect.DFAPlayerStatusEffectPackage:
  $type: gamedataGameplayLogicPackage_Record
  stats:
    - BaseStatusEffect.DFACanGroundSlamInAir    # value: 1, stat: CanGroundSlamInAir
    - BaseStatusEffect.DFAJumpHeight            # value: 2 (Multiplier), stat: JumpHeight
    - BaseStatusEffect.DFAFallDamageReduction   # value: 1, stat: FallDamageReduction
```

**This is where the "action chain" lives** — the status effect packages contain stat modifiers that change game stats (jump height, fall damage, ground slam ability, movement speed, armor, etc.).

### 5. Attacks Record (damage definitions, if applicable)

**File**: `Attacks.DeathFromAboveGroundSlam.yaml`
**TweakDB Type**: Various attack/stat modifier records

Not all quickhacks have these. Damage-dealing hacks define **tiered damage values** via constant stat modifiers:

```yaml
Attacks.DFAGroundSlamNearTier1Damage:
  $type: gamedataConstantStatModifier_Record
  value: 200
  modifierType: Additive
  statType: BaseStats.PhysicalDamage
```

These scale per tier (Tier1: 200, Tier2: 280, Tier3: 400, Tier4: 500, Tier5: 700) and include a `CurveStatModifier` for quality-based multipliers.

### 6. Ability Record (unlock gate)

**File**: `Ability.CanDeathFromAboveQuickHack.yaml`
**TweakDB Type**: `gamedataGameplayAbility_Record`

Defines whether the player **can use** this hack. Contains `prereqsForUse` that gate availability (e.g., intelligence level, cyberdeck type, perk unlocks).

### 7. Interaction Record (scanner UI entry)

**File**: `Interactions.DeathFromAboveHack.yaml`
**TweakDB Type**: `gamedataInteractionBase_Record`

Defines how the hack **appears in the scanner** when looking at a target:

```yaml
Interactions.DeathFromAboveHack:
  $type: gamedataInteractionBase_Record
  action: Choice1
  captionIcon: ChoiceCaptionParts.DeathFromAboveIcon
  name: DeathFromAboveHack
  caption: LocKey#95700053
  description: LocKey#95700054
```

### 8. HackCategory Record

**File**: `HackCategory.DeathFromAboveHack.yaml`
**TweakDB Type**: `gamedataHackCategory_Record`

Simple enum-like record that categorizes the hack (Combat, Covert, Ultimate, or custom). Used for UI grouping and filtering.

### 9. UIIcon Records

**File**: `UIIcon.DeathFromAbove.yaml`
**TweakDB Type**: `gamedataUIIcon_Record`

Defines icon paths for the hack — typically 3 icons:
- Main icon (cyberdeck/inventory)
- Scanner icon (scanner UI)
- Status effect icon (active effect bar)

Each points to an `.inkatlas` resource with an atlas part name.

### 10. ChoiceCaptionParts Record (scanner caption icon)

**File**: `ChoiceCaptionParts.DeathFromAboveIcon.yaml`
**TweakDB Type**: `gamedataChoiceCaptionIconPart_Record`

Defines the icon shown next to the hack name in the scanner interaction list.

### 11. Prereqs Records (optional)

Some quickhacks (e.g., Platinum Package) include custom prerequisite records like `Prereqs.PlatinumPackageCooldown.yaml` for cooldown gating.

## The Reference Graph

All these records form a **directed graph of TweakDB ID references**:

```
Items.*Program
  +-- objectActions ---------> QuickHack.*Hack (the action)
  +-- OnAttach ---------------> EquipmentGLP.*Programs (tooltips per tier)
  +-- icon -------------------> UIIcon.* (inventory icon)
  +-- placementSlots ---------> AttachmentSlots.CyberdeckProgram1-8

QuickHack.*Hack
  +-- hackCategory -----------> HackCategory.*Hack
  +-- objectActionUI ---------> Interactions.*Hack (scanner entry)
  |                               +-- captionIcon -> ChoiceCaptionParts.*Icon
  |                                                   +-- texturePartID -> UIIcon.*
  +-- costs ------------------> StatPoolCost -> BaseStatPools.Memory
  +-- activationTime ---------> ConstantStatModifier (QuickHackUpload time)
  +-- instigatorPrereqs ------> Prereqs.* (player requirements)
  +-- targetActivePrereqs ----> Prereqs.* (target checks)
  +-- startEffects -----------> ObjectActionEffect (fired at upload start)
  +-- completionEffects ------> ObjectActionEffect
                                  +-- statusEffect -> BaseStatusEffect.*
                                        +-- packages -> GameplayLogicPackage
                                              +-- stats -> ConstantStatModifier
                                                           (stat changes)

Ability.Can*QuickHack
  +-- prereqsForUse ---------> Prereqs.* (unlock requirements)

BaseStatusEffect.*
  +-- duration --------------> StatModifierGroup -> ConstantStatModifier (MaxDuration)
  +-- uiData ----------------> StatusEffectUIData (icon, name, priority)
  +-- packages --------------> GameplayLogicPackage -> stats/effectors
  +-- VFX/SFX ---------------> effect records (visual/audio)
```

## The Lua Runtime Layer

TweakDB records define **what** happens through the engine's fixed pipeline. But some behaviors **cannot be expressed in TweakDB** and require **CET Lua runtime code**. This is the actual "macro" layer the user was thinking of.

### Pattern 1: Pure TweakDB Quickhack (Zeusico)

Zeusico Quickhacks are **100% TweakDB/YAML** — no Lua at all. All behavior is expressed through the record network. The engine handles everything: scanner UI, upload, memory cost, status effect application, stat changes. This works when the desired effect can be expressed as stat modifiers and status effects.

### Pattern 2: TweakDB + Lua Hybrid (Charm, Blackwall)

The Charm and Blackwall mods use TweakDB for the quickhack definition (so it appears in the scanner) but add Lua for runtime behavior:

**Charm** (`init.lua`):
- TweakDB defines the hack action, item, interaction (so it shows in scanner)
- Lua `AddActions()` function injects the hack into all NPC character records at runtime via `TweakDB:SetFlat()`
- When the hack completes, Lua `DoCharm(target)` function:
  - Creates an `AIFollowerRole` and assigns it to the target
  - Changes the target's attitude to `AIA_Friendly` toward the player
  - Issues a `AIFollowTargetCommand` so the NPC follows the player
  - Manages a followers list with cleanup for dead/undefined entities

**Blackwall** (`init.lua`):
- TweakDB defines the hack as a Canto-specific quickhack
- Lua handles the full execution pipeline manually:
  - Target acquisition via `Game.GetTargetingSystem():GetLookAtObject()`
  - Prerequisite checks (Canto cyberdeck equipped, memory/health costs)
  - Cooldown management (single/multi target)
  - Applies `BaseStatusEffect.SoMi_Q306_BlackwallHackUpload` (the quest effect with DealDamageModule)
  - Direct health manipulation via `StatPoolsSystem:RequestSettingMinValue()`
  - NPC state transition to `Collapse` (death)
  - VFX triggering via `GameObjectEffectHelper.StartEffectEvent()`

### Pattern 3: Pure Lua Quickhack (Teleport)

The Teleport mod uses a different approach — the **0-Engine framework** for registering quickhacks dynamically:

```lua
local mod = {
    name = "TeleportQuickhack",
    actionType = 5,        -- PuppetQuickHack
    cost = 8,              -- memory cost
    uploadTime = 1.0,
    iceLevel = 8,
    quality = 4,
    icon = "UIIcon.quickhack_icebreaker",
    ...
}
engine.Register(mod.name)  -- registers with 0-Engine
```

Lua handles everything: scanning, targeting, teleportation via `Game.GetTeleportationFacility():Teleport()`, effects. No TweakDB YAML at all.

## Status Effects: What's Inside One

A `gamedataStatusEffect_Record` contains these components:

### Duration
```yaml
duration: StatModifierGroup
  +-- statModifiers: ConstantStatModifier
        value: 10          # seconds
        statType: BaseStats.MaxDuration
```

### Packages (the mechanical effects)
```yaml
packages:
  - GameplayLogicPackage
      +-- stats: list of stat modifiers
      |     - ConstantStatModifier (value, modifierType, statType)
      |     - CurveStatModifier (tier-based scaling)
      |     - MultiplierStatModifier
      +-- effectors: list of effector records
      |     - game effects (AI state changes, behavioral mods)
      +-- statPools: pool modifications (health drain, etc.)
      +-- items: spawned items
```

### UI Data
```yaml
uiData: StatusEffectUIData
  +-- displayName: LocKey#...
  +-- iconPath: icon atlas part name
  +-- priority: display ordering
  +-- stats: displayed stat values
```

### VFX / SFX
```yaml
VFX: list of visual effect records
SFX: list of sound effect records
```

### Gameplay Tags
```yaml
gameplayTags:
  - Debuff
  - Quickhack
  - DeathFromAbove
  - DeathFromAboveLevel4PlusPlus
```

## Summary Table: Record Types in a Complete Quickhack

| # | Record Type | TweakDB Type | File Pattern | Purpose |
|---|------------|-------------|-------------|---------|
| 1 | QuickHack Action | `gamedataObjectAction_Record` | `QuickHack.Base*Hack.yaml` / `QuickHack.*Lvl4PlusPlusHack.yaml` | Core action: costs, prereqs, effects, upload time |
| 2 | Item (Program) | `gamedataItem_Record` | `Items.*Program.yaml` | The equippable shard in cyberdeck |
| 3 | EquipmentGLP | `gamedataGameplayLogicPackage_Record` | `EquipmentGLP.*Programs.yaml` | Per-tier tooltip descriptions |
| 4 | Status Effect | `gamedataStatusEffect_Record` | `BaseStatusEffect.*.yaml` | The payload: stat changes, effectors, VFX |
| 5 | Attacks | various attack records | `Attacks.*.yaml` | Damage values (if hack deals damage) |
| 6 | Ability | `gamedataGameplayAbility_Record` | `Ability.Can*QuickHack.yaml` | Unlock gate / usage prereqs |
| 7 | Interaction | `gamedataInteractionBase_Record` | `Interactions.*Hack.yaml` | Scanner UI entry (name, icon, description) |
| 8 | HackCategory | `gamedataHackCategory_Record` | `HackCategory.*Hack.yaml` | Category enum (Combat/Covert/Ultimate/custom) |
| 9 | UIIcon | `gamedataUIIcon_Record` | `UIIcon.*.yaml` | Icon atlas references (inventory, scanner, status) |
| 10 | ChoiceCaptionParts | `gamedataChoiceCaptionIconPart_Record` | `ChoiceCaptionParts.*Icon.yaml` | Scanner caption icon |
| 11 | Prereqs (optional) | various prereq records | `Prereqs.*.yaml` | Custom prerequisites (cooldowns, etc.) |
| 12 | Effectors (optional) | `gamedataEffector_Record` | `Effectors.*.yaml` | Special game effects (takedowns, etc.) |
| 13 | Character Records (optional) | `gamedataCharacter_Record` | `Character.*.yaml` | Custom NPC definitions for spawned allies |

## Key Insight: TweakDB vs Lua Division of Labor

| Concern | Handled By | How |
|---------|-----------|-----|
| Scanner UI appearance | TweakDB | `Interactions.*` + `UIIcon.*` + `ChoiceCaptionParts.*` |
| Memory cost | TweakDB | `StatPoolCost` in `QuickHack.*.costs` |
| Upload time | TweakDB | `activationTime` stat modifiers |
| Prerequisites (target/player) | TweakDB | `instigatorPrereqs` / `targetActivePrereqs` |
| Stat changes (speed, armor, etc.) | TweakDB | Status effect `packages` -> `stat modifiers` |
| Damage | TweakDB | `Attacks.*` records with damage stat modifiers |
| Visual/audio effects | TweakDB | Status effect `VFX`/`SFX` fields |
| AI behavior changes (follow, friendly) | **Lua** | `SetAIRole()`, `SetAttitudeTowards()`, AI commands |
| Dynamic TweakDB injection | **Lua** | `TweakDB:SetFlat()` at runtime |
| Direct health manipulation | **Lua** | `StatPoolsSystem:RequestSettingMinValue()` |
| Cooldown management | **Lua** (or TweakDB Prereqs) | Timer variables / `Prereqs.*Cooldown` |
| Custom targeting logic | **Lua** | `GetTargetingSystem():GetLookAtObject()` |
| Entity teleportation | **Lua** | `Game.GetTeleportationFacility():Teleport()` |

## Conclusion

Quickhacks are **not macros** in the traditional sense. They are:

1. **Data-driven action definitions** — a network of ~13 typed TweakDB record types referencing each other by ID
2. **Processed through a fixed engine pipeline** — scanner -> prereqs -> upload -> cost -> effects -> status effect packages
3. **Optionally extended by Lua** — for behaviors TweakDB cannot express (AI manipulation, direct health changes, dynamic injection, custom targeting)

The "chain of actions" the user observed is real, but it's a **fixed pipeline chain** (prereqs -> cost -> upload -> effects -> status effects -> stat packages), not arbitrary scripting. The actual "macro" capability comes from the Lua layer, which some mods use and some don't.

Status effects are the **payload delivery mechanism** — they're the containers that hold stat modifier packages, effectors, VFX/SFX, and duration data. The quickhack action references them via `completionEffects`, and the engine applies them to the target when the upload completes.
