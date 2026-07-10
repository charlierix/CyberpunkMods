# Systems

10 concepts in systems

- [Compatibility Manager](./compatibility.md) — Abstract class managing cross-mod compatibility checks and version detection.
- [Dev Mode](./dev-mode.md) — Development mode toggle function returning true when debugging features are enabled.
- [EquipmentEx Facade](./facade.md) — Public API facade abstract EquipmentEx class exposing core operations for other modules and overrides.
- [Inventory Helper](./inventory-helper.md) — ScriptableSystem providing inventory query and manipulation utilities for equipment slot operations.
- [Migrations](./migrations.md) — Data structures for extracted set migration between outfit configuration versions.
- [Outfit Configuration](./outfit-config.md) — Configuration structs for outfit slots and base slot config, plus event types for outfit updates.
- [Outfit State](./outfit-state.md) — Outfit part and state tracking system. Manages equipped parts, visibility, garment state transitions, and slot assignment data.
- [Outfit System](./outfit-system.md) — Core outfit management system extending ScriptableSystem. Handles outfit assembly, slot management, equipment operations, and transaction logic. Largest module with 121 declared types.
- [Paperdoll Helper](./paperdoll.md) — ScriptableSystem assisting with paperdoll entity rendering and appearance management.
- [View Manager](./view-manager.md) — View management system handling UI view states, transitions, and events for the wardrobe/inventory interface.
