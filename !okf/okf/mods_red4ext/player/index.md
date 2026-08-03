# Player — Game Mechanic Patterns

17 concept files in this category.

* [Action Input Handling](action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
* [Attachment Slot Tweaks](attachment-slot-tweaks.md) — Modifying AttachmentSlots.* TweakDB records to alter equipment attachment slots.
* [Attunement Tweaks](attunement-tweaks.md) — Modifying Attunements.* TweakDB records to alter cyberware attunement mechanics.
* [Combat State Transitions](combat-state-transitions.md) — Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.
* [Death and Defeat Handling](death-and-defeat-handling.md) — Wrapping OnDeath and OnDefeated on PlayerPuppet and ScriptedPuppet to intercept death/defeat events.
* [Equipment System Manipulation](equipment-system-manipulation.md) — Wrapping EquipmentSystemPlayerData to modify equipment and inventory management behavior.
* [First Equip System](first-equip-system.md) — Wrapping FirstEquipSystem and EquipCycleDecisions to modify weapon equipping behavior.
* [Healing System Tweaks](healing-system-tweaks.md) — Modifying ImmersiveHealing.* TweakDB records to alter healing item behavior.
* [Monowire Perk Tweaks](monowire-perk-tweaks.md) — Modifying MonowirePerkTree.* TweakDB records to alter monowire cyberware perks.
* [Movement Action Tweaks](movement-action-tweaks.md) — Modifying MovementActions.* TweakDB records to alter movement mechanics.
* [Movement State Events](movement-state-events.md) — Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
* [Player Development Overrides](player-development-overrides.md) — Wrapping PlayerDevelopmentData methods to modify perk, attribute, and skill progression.
* [Player Lifecycle Hooks](player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initializat...
* [Player Vision Mode](player-vision-mode.md) — Intercepting PlayerVisionModeController to modify scanning and vision modes.
* [Stats System Modification](stats-modification.md) — Using StatsSystem and stat modifiers to modify player and NPC stat values at runtime.
* [Status Effect Interception](status-effect-interception.md) — Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.
* [TweakDB Base Stats Modification](tweakdb-base-stats.md) — Modifying BaseStats.* TweakDB records to alter base character statistics.
