# Quickhack Prerequisites Analysis

## Why Programmatic Quickhacks Fail & What the Game Actually Requires

---

## The Core Problem

Four tester versions (quickhack_tester through quickhack_tester4) all attempted to programmatically execute device quickhacks via CET Lua. **Every execution method failed to produce a visible effect.** This document analyzes why, by examining what the game's quickhack system actually requires and how successful community mods work around it.

### Tester Results Summary

| Tester | Discovery | StartAction | ProcessRPGAction | Direct PS | DeviceSystem Direct | Visual Effect |
|---|---|---|---|---|---|---|
| v1 | 4 actions found | Failed | Not tried | Failed | Not tried | None |
| v2 | Empty (wrong API convention) | N/A | N/A | N/A | N/A | None |
| v3 | 4 actions found | Always fails | Reports OK, no effect | Not tried | Not tried | None |
| v4 | 8 actions found | Always fails | Reports OK, no effect | Failed | Failed | None (RemoteBreach shows empty hack screen) |

### What Worked Across All Testers

- Targeting: `Game.GetTargetingSystem():GetObjectClosestToCrosshair` with `TSF_Quickhackable` filter
- Device PS access: `target:GetDevicePS()`
- Action discovery: `ps:GetQuickHackActions(context)` (return-value convention, not out-array)
- Action metadata extraction: `GetActionName()`, `GetClassName()`, `GetObjectActionRecord():GetID()`, `HackCategory():Type()`
- Caching and cycling through device's actual available hacks

### What Failed Across All Testers

- `action:StartAction(game)` — always throws an error
- `action:ProcessRPGAction(game)` — pcall returns true but no effect occurs
- `action:CompleteAction(game)` — fails
- `action:IsPossible(game)` — throws "error in error handling" (v4 log)
- `action:CanInterrupt()`, `action:IsVisible()` — same error
- Direct PS handler calls (`ps:OnQuickHackDistraction(action)`) — fail
- `ps:QueuePSDeviceEvent(action)` — fails
- `DeviceSystem:GetDeviceById()` + `device:ExecuteAction(action)` — fails
- `DeviceSystem:GetDeviceById()` + `device:ProcessAction(action)` — fails

The "error in error handling" message from tester4's log is particularly telling — it means the action objects returned by `GetQuickHackActions` are **incomplete or read-only descriptors**, not fully instantiated executable action instances. The methods exist on the class but the internal state needed for them to function is missing.

---

## The User's Theory: Quickhacks Can't Happen in a Vacuum

**The theory is correct.** The game's quickhack system is not a simple function call — it's a multi-layered pipeline with prerequisites at each stage. Based on analysis of the game source (okf), successful community mods, and REDscript decompilation, here are the actual requirements:

---

## Player Prerequisites for Quickhacking

### 1. Cyberdeck Equipment (Required)

The player **must** have a cyberdeck equipped in the **SystemReplacementCW** equipment slot. This is checked everywhere in the code:

```redscript
// From Black Chrome's CyberdeckHelpers.reds
public func IsCyberdeckEquipped(owner: ref<GameObject>) -> Bool {
    return EquipmentSystem.GetData(owner).FindItemInEquipAreaByTag(
        n"Cyberdeck", gamedataEquipmentArea.SystemReplacementCW
    ).IsValid();
}
```

The base game checks this via `Device:IsCyberdeckEquippedOnPlayer()`, `EquipmentSystem:IsCyberdeckEquipped()`, and the healthbar UI widget. Without a cyberdeck:
- The scan mode quickhack menu doesn't populate
- `RPGManager.GetPlayerQuickHackListWithQuality()` returns an empty array
- Device actions show as unavailable

### 2. Quickhack Programs Installed (Required)

Quickhacks are **items** in the player's inventory, equipped to the cyberdeck. The game builds the available quickhack list via:

```redscript
// From RPGManager (base game, shown in Black Chrome's override)
RPGManager.GetPlayerQuickHackListWithQuality(player)
```

This function:
1. Gets the equipped cyberdeck item record
2. Reads its `ObjectActions` array from TweakDB
3. Filters for action types: `DeviceQuickHack`, `PuppetQuickHack`, `VehicleQuickHack`
4. Returns `PlayerQuickhackData` array with action record, item ID, and quality

The returned list is cached on the player via `PlayerPuppet.ChacheQuickHackList()`. If no quickhack programs are installed, no quickhack actions are available — even if the device supports them.

### 3. RAM / Memory (Required for RPG-cost hacks)

Quickhacks cost RAM (the "Memory" stat pool). The cost comes from the action's TweakDB record:
- `GetCost()` returns the current cost (after perk reductions)
- `GetBaseCost()` returns the base cost
- `PayCost()` deducts RAM from the player's Memory stat pool

The testers tried `SetCanSkipPayCost(true)` to bypass RAM, but this flag only works if the action is properly flowing through the execution pipeline. Since `StartAction` fails, the flag never takes effect.

RAM is managed by:
- `Game.GetStatPoolsSystem()` with the "Memory" stat pool
- Max RAM determined by cyberdeck stats and perks
- RAM regenerates over time (rate affected by perks and cyberdeck stats)

### 4. Perks (Affect availability and cost, not strictly required)

The **Quickhacking perk tree** (under Intelligence) affects:
- Which quickhacks can be equipped (some require perk unlocks)
- RAM costs (reductions via perk nodes)
- Upload speed
- Effect duration and strength
- Chain hack capability
- RAM regeneration rate

However, basic quickhacks (Ping, Distraction, etc.) are available without specific perks as long as the player has a cyberdeck and the quickhack program installed.

### 5. Scanning Mode (Required for the normal UI flow)

The normal quickhack flow requires the player to be in scan mode (holding the scan button). This is observed in the Blackwall mod:

```lua
-- From Blackwall init.lua
Observe('PlayerPuppet', 'OnAction', function(_, action)
    if action:IsAction(action, 'VisionHold') then
        if actionType == 'BUTTON_HOLD_COMPLETE' then
            inScanner = true
        elseif actionType == 'BUTTON_RELEASED' then
            inScanner = false
        end
    end
end)
```

The `onlyFromHackingMode` setting in the Blackwall mod shows that some mods restrict quickhack usage to scan mode. The base game's `HUDQuickhackMenuController` only opens from scan mode.

### 6. Target Must Be Quickhackable

The targeting system filter `TSF_Quickhackable` ensures only hackable targets are selected. For devices, this means the device must:
- Have a `ScriptableDeviceComponentPS` with quickhack actions defined
- Not be already in a state that prevents hacking (e.g., already hacked, destroyed)
- Have `IsQuickHacksExposed` return true (or be breached)

For NPCs, the target must:
- Have `IsQuickHacksExposed` return true (via scanning/breaching)
- Not be friendly to the player (friendly NPCs can't normally be quickhacked)
- Be active (`ScriptedPuppet.IsActive()`)

---

## NPC Prerequisites for Hacking the Player

### What Netrunner NPCs Need to Hack the Player

Based on analysis of the game's AI system, the `WillCounterHack` tag, and the `QuickHackableHelper` class:

### 1. Character Record Setup (Required)

The NPC's `gamedataCharacter_Record` in TweakDB must have:
- **Object actions** with `PuppetQuickHack` type actions defined
- The **`WillCounterHack`** tag on the character record
- Appropriate AI setup for netrunner behavior

The `WillCounterHack` tag is checked in `QuickHackableHelper.WillHackRevealPlayer()`:

```redscript
let npcWillCounterHack: Bool = NPCManager.HasTag(targetRecordId, n"WillCounterHack");
```

### 2. AI Behavior Configuration

Netrunner NPCs need AI components configured for hacking behavior:
- **AI conditions** that check for valid hack targets (the player)
- **AI tasks** that execute the hack upload
- **AI commands** for combat behavior that include netrunner tactics

The game's AI system (documented in `okf/adamsmasher/core/ai/`) includes behavior tree nodes for:
- Target acquisition and validation
- Line-of-sight checks
- Distance/Range checks
- Awareness state checks

### 3. Awareness and Combat State

NPCs can only hack the player when:
- They are in **Combat** or **Alerted** high-level state
- They have detected the player (awareness level sufficient)
- They have line of sight to the player

The `ForcedQHUploadAwarenessBumps` status effect can force awareness bumps for quicker counter-hacking.

### 4. The Counter-Hack Pipeline

When an NPC hacks the player:
1. The NPC's AI decides to use a quickhack (behavior tree)
2. The hack is uploaded through the `QuickHackableHelper` pipeline
3. The player receives a status effect (e.g., `BaseStatusEffect.Overheat`, `BaseStatusEffect.CyberwareMalfunction`)
4. The player's cyberdeck may attempt to block the hack (based on cyberdeck stats)
5. If not blocked, the status effect applies

### 5. What NPCs Do NOT Need

Unlike the player, NPC netrunners do **not** need:
- A cyberdeck item equipped in the traditional sense — their quickhacks come from their character record's `objectActions` array, not from an inventory item
- RAM in the player's sense — their hack costs/cooldowns are managed by AI behavior timers
- Perks — their hacking capability is defined by their character record and AI configuration

---

## Why the Action Object Approach Fails

### The Real Quickhack Pipeline

The normal game flow for executing a quickhack is:

```
Player in Scan Mode
    -> Targets device/NPC via crosshair
    -> HUDQuickhackMenuController opens
    -> Shows available quickhacks (filtered by player's installed programs, target's exposed actions, etc.)
    -> Player selects a quickhack
    -> QuickhackSystem processes the request
    -> Creates a properly instantiated action with full context
    -> Upload pipeline begins (activation time, progress bar, etc.)
    -> PayCost deducts RAM
    -> Status effect / device event applied to target
    -> XP awarded
    -> Cooldown started
```

The key insight is that **the action objects returned by `ps:GetQuickHackActions(context)` are descriptors/templates, not executable instances**. They contain the TweakDB record reference, class name, and cost info — but they lack:

1. **Proper instantiation context** — The normal pipeline creates actions via `puppetAction = this.GetAction(actions[i])` (seen in Charm's REDscript), which calls `SetUp(this)` to initialize internal state

2. **Completion/failure callback objects** — `StartAction` likely requires callback objects to be set for the async upload pipeline

3. **Game state validation** — The normal flow checks scan mode, distance, line of sight, RAM availability, perk prerequisites, and target state before allowing execution

4. **The upload pipeline** — Quickhacks in the real game are not instant; they have an activation time (seen in tester4's log: `GetActivationTime: 0.5` for MalfunctionClassHack). The upload happens over time with a progress bar, and the action is completed when the upload finishes

### Evidence from the Charm Mod's REDscript

The Charm quickhack mod shows the real pipeline in `ScriptedPuppetPS.GetAllChoices()`:

```redscript
puppetAction = this.GetAction(Deref(actions)[i]);
puppetAction.SetExecutor(instigator);
puppetAction.RegisterAsRequester(PersistentID.ExtractEntityID(this.GetID()));
puppetAction.SetObjectActionID(Deref(actions)[i].GetID());
puppetAction.SetUp(this);
if puppetAction.IsQuickHack() {
    // ... attitude checks, exposure checks, etc.
    ArrayPush(Deref(puppetActions), puppetAction);
}
```

Notice the call to `puppetAction.SetUp(this)` — this is a critical initialization step that the CET testers never call. The testers call `SetExecutor`, `SetRequesterID`, `SetCanSkipPayCost`, and `SetObjectActionID`, but never `SetUp()`. This method likely initializes the action's internal state, connects it to the PS, and prepares it for execution.

However, `SetUp()` may not be exposed to CET's Lua bindings, or it may require a `ScriptableDeviceComponentPS` reference that CET can't properly provide. This is likely the missing piece.

### Evidence from the Tester4 Log

The tester4 log shows:
- `IsPossible: ERROR: error in error handling`
- `CanInterrupt: ERROR: error in error handling`
- `IsVisible: ERROR: error in error handling`
- `GetActivationTime: 0` (should be 0.5 for MalfunctionClassHack)
- `GetCost: 0` (should be 3 for MalfunctionClassHack)

Wait — `GetActivationTime` returns 0 and `GetCost` returns 0 for MalfunctionClassHack, but the log also shows `GetCost: 3` and `GetBaseCost: 3` for action [3] (MalfunctionClassHack). This inconsistency suggests the action objects may be returning metadata from the TweakDB record but lack the runtime state that `IsPossible`, `CanInterrupt`, and `IsVisible` need.

The "error in error handling" message is a CET-level error indicating that calling these methods on the action object causes an internal error — likely because the action object is not in a valid state for these methods to execute.

---

## How Successful Mods Handle Quickhacking

### Approach 1: Status Effect Direct Application (Blackwall Mod)

The Blackwall mod **completely bypasses the action system** and applies status effects directly:

```lua
-- From Blackwall init.lua
StatusEffectHelper.ApplyStatusEffect(
    target,
    "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload",
    0.0
)
```

This works because status effects are the actual mechanism that produces visible results. The quickhack action pipeline ultimately applies status effects — the Blackwall mod just skips all the intermediate steps.

**Pros**: Works reliably, immediate effect, no RAM cost
**Cons**: Bypasses the normal game flow (no upload animation, no RAM cost, no cooldown, no XP)

### Approach 2: TweakDB Action Registration (Charm Mod)

The Charm mod **adds custom quickhack actions via TweakDB** and lets the player use them through the normal scan-mode quickhack UI:

```lua
-- From Charm init.lua
function AddActions()
    for _, character in pairs(TweakDB:GetRecords("gamedataCharacter_Record")) do
        local objectActionsRecord = character:GetID() .. ".objectActions"
        -- ... adds "QuickHack.PingHack_modified_Charm" to the actions array
        TweakDB:SetFlat(objectActionsRecord, newArray)
    end
end
```

Then it observes the result:

```lua
Observe("NPCPuppet", "OnQuickHackEffectApplied", function(puppet, event)
    local recordID = TDBID.ToStringDEBUG(event.staticData:GetRecordID())
    if recordID == "BaseStatusEffect.Ping_Charm" then
        DoCharm(puppet)
    end
end)
```

This works because it uses the **normal game pipeline** — the player scans, sees the quickhack in the menu, selects it, and the game's quickhack system handles execution properly. The mod just adds new options to the menu and reacts to the result.

**Pros**: Full integration with game systems (RAM cost, upload time, UI, XP)
**Cons**: Requires the player to use the scan-mode UI; can't be triggered programmatically from a hotkey

### Approach 3: TweakDB + REDscript Overrides (Zeusico, Quickhack Weapon Mods)

These mods define new quickhack records in TweakDB (via YAML tweaks) and use REDscript to:
- Add the quickhacks to character/device records
- Override methods like `GetAllChoices` to expose them
- Handle the effects via status effect observation or custom effect executors

This is the most complete approach but requires REDscript (not just CET Lua).

---

## Recommendations for Making Programmatic Quickhacks Work

### Option A: Status Effect Approach (Most Likely to Work from CET)

Instead of trying to execute the action object, **apply the status effect that the quickhack would produce**. This is what the Blackwall mod does.

For **devices**, the status effects are different from NPC quickhacks. Device quickhacks trigger device operations (distraction, toggle, etc.), not status effects on the device itself. So for devices, you'd need to:

1. Identify which device operation the quickhack triggers
2. Call the device's operation directly (e.g., `ps:OnQuickHackDistraction()` with proper setup)
3. Or send a `QuestForceON` / `QuestStartGlitch` action via the quest action pipeline

**For NPC quickhacks**, apply the status effect directly:
```lua
-- Example: Apply Overheat to an NPC
StatusEffectHelper.ApplyStatusEffect(
    targetNpc,
    "BaseStatusEffect.Overheat",
    0.0  -- duration override, 0 = use default
)
```

### Option B: Quest Actions (For Devices)

The device system has **quest actions** that are designed to be triggered programmatically (by quest scripts, not by players). These are separate from quickhack actions:

| Quest Action | Effect |
|---|---|
| `QuestForceON` | Force device on |
| `QuestForceOFF` | Force device off |
| `QuestStartGlitch` | Start glitch effect |
| `QuestStopGlitch` | Stop glitch effect |
| `QuestForceEnabled` | Enable device |
| `QuestForceDisabled` | Disable device |
| `QuestForcePower` | Power on device |
| `QuestForceUnpower` | Unpower device |
| `QuestForceAuthorizationEnabled` | Enable authorization |
| `QuestForceSecuritySystemAlarmed` | Trigger alarm |

These quest actions are in the `baseDeviceActions.swift` source and have corresponding `OnQuestForce*` handlers in `ScriptableDeviceComponentPS`. They may be callable from CET because they're designed for external triggering.

Try:
```lua
-- Create a quest action and queue it as a PS device event
local questAction = NewObject('QuestStartGlitch')
questAction:SetExecutor(player)
questAction:SetRequesterID(player:GetEntityID())
ps:QueuePSDeviceEvent(questAction)
```

### Option C: Use the Game's Quickhack System via REDscript

If you can use REDscript (RED4ext + a .reds file), you can properly call:

```redscript
// Proper action creation and execution
let action = this.GetAction(record);
action.SetExecutor(player);
action.RegisterAsRequester(playerEntityID);
action.SetObjectActionID(record.GetID());
action.SetUp(ps);
// Then use the QuickhackSystem to process it
```

This is the approach the game itself uses and what the Charm mod's REDscript override shows.

### Option D: Simulate the Normal Flow

If you want to keep it in CET, simulate what the game does:

1. Force the player into scan mode (if not already)
2. Use the HUD quickhack menu controller to select and execute the hack
3. This may require interacting with the game's UI system, which is complex from CET

This is the least practical option from CET.

---

## Summary: Answering the Core Questions

### Can quickhacks happen in a vacuum?

**No.** Quickhacks require:

| Requirement | Player Hacking Devices | Player Hacking NPCs | NPCs Hacking Player |
|---|---|---|---|
| Cyberdeck equipped | Required | Required | Not needed (uses character record) |
| Quickhack programs installed | Required | Required | Not needed (uses character record) |
| RAM available | Required (or skip cost) | Required (or skip cost) | Not needed |
| Scan mode | Required for normal UI | Required for normal UI | Not needed |
| Target quickhackable | Device must support it | NPC must be exposed | Player is always a target |
| Target active/alive | Device must be functional | NPC must be active | Player must be alive |
| Line of sight | Via targeting | Via targeting | Via AI senses |
| Proper action instantiation | Via quickhack system | Via quickhack system | Via AI behavior tree |
| `WillCounterHack` tag | N/A | N/A | Required on NPC record |
| AI netrunner behavior | N/A | N/A | Required in AI setup |

### Why do the testers fail?

The action objects from `ps:GetQuickHackActions(context)` are **descriptors**, not executable instances. They lack:
- The `SetUp()` initialization that connects them to the device PS runtime
- Completion/failure callbacks for the async upload pipeline
- Game state validation context (scan mode, distance, etc.)
- The full execution pipeline that `QuickhackSystem` / `HUDQuickhackMenuController` provides

The CET testers are trying to call methods (`StartAction`, `IsPossible`, etc.) that require internal state the descriptor objects don't have. This is why `IsPossible` returns "error in error handling" — the method exists on the class but the object isn't in a valid state.

### What should be tried next?

1. **For NPC quickhacks**: Use `StatusEffectHelper.ApplyStatusEffect()` directly (proven by Blackwall mod)
2. **For device quickhacks**: Try quest actions (`QuestStartGlitch`, `QuestForceON`, etc.) via `QueuePSDeviceEvent` — these are designed for programmatic triggering
3. **For proper integration**: Use REDscript to call `SetUp()` and go through the real `QuickhackSystem` pipeline
4. **As a hybrid**: Add custom quickhack records via TweakDB (like the Charm mod) and let the player trigger them through the normal scan-mode UI, while observing the effect via CET `Observe()`

---

## Source References

| Source | Path | Key Insight |
|---|---|---|
| Tester 1-4 | `testers/quickhack/quickhack_tester*/` | All execution methods fail; discovery works |
| Tester 3 log summary | `testers/quickhack/quickhack_tester3/log_summary.md` | Comprehensive failure analysis |
| Tester 4 log | `testers/quickhack/quickhack_tester4/log.txt` | "error in error handling" for action methods |
| Blackwall mod | `sources - extra/cyberware - quickhack/blackwall-*/` | Status effect direct application bypasses action system |
| Charm mod (CET) | `sources - extra/cyberware - quickhack/charm */` | TweakDB action registration + Observe for effects |
| Charm mod (REDscript) | `charm */r6/scripts/CharmQuickhack/CharmQuickhack.reds` | Shows real pipeline: GetAction() then SetUp() then IsQuickHack() |
| Black Chrome | `sources - extra/cyberware - quickhack/Black Chrome-*/r6/scripts/BlackChrome/` | Cyberdeck equipment checks, aux cyberdeck support |
| Zeusico Quickhacks | `sources - extra/cyberware - quickhack/Zeusico Quickhacks */` | TweakDB + REDscript approach for custom quickhacks |
| Device core (okf) | `okf/adamsmasher/cyberpunk/devices/core.md` | Action classes, PS handlers, quest actions |
| ScriptableDeviceBasePS (okf) | `okf/adamsmasher/cyberpunk/devices/core.md` | OnQuickHack* handlers, GetQuickHackActionsExternal |
| Equipment system (okf) | `okf/adamsmasher/cyberpunk/systems.md` | EquipmentSystem, cyberdeck slot management |
| Cyberware UI (okf) | `okf/adamsmasher/cyberpunk/ui/cyberware.md` | CyberwareSlot, OverclockHudListener |
