// HoverRotPlayer7.reds - Redscript bridge for player rotation tester
//
// Provides access to native game functions that CET cannot reach:
// 1. Vehicle mounting (to mount player to a spawned vehicle)
// 2. Locomotion component access (to inspect/modify locomotion state)
// 3. Transform component access (to write orientation at a deeper level)
//
// CET access pattern:
//   local bridge = Game.GetScriptableSystemsContainer():Get('HoverRotPlayer7Bridge')
//   bridge:MethodName(args...)

public class HoverRotPlayer7Bridge extends ScriptableSystem {
    private let m_active: Bool;
    private let m_pitch: Float;
    private let m_yaw: Float;
    private let m_roll: Float;
    private let m_strategy: Int32;
    private let m_vehicleEntityID: EntityID;
    private let m_vehicleSpawned: Bool;

    private func OnAttach() -> Void {
        this.m_active = false;
        this.m_pitch = 0.0;
        this.m_yaw = 0.0;
        this.m_roll = 0.0;
        this.m_strategy = 1;
        this.m_vehicleSpawned = false;
    }

    // ============================================================
    // CET-callable methods
    // ============================================================

    public func SetRotation(pitch: Float, yaw: Float, roll: Float) -> Void {
        this.m_pitch = pitch;
        this.m_yaw = yaw;
        this.m_roll = roll;
    }

    public func SetActive(active: Bool) -> Void {
        this.m_active = active;
    }

    public func SetStrategy(strategy: Int32) -> Void {
        this.m_strategy = strategy;
    }

    public func GetState() -> String {
        return "active=" + ToString(this.m_active)
            + " pitch=" + ToString(this.m_pitch)
            + " yaw=" + ToString(this.m_yaw)
            + " roll=" + ToString(this.m_roll)
            + " strategy=" + ToString(this.m_strategy);
    }

    // ============================================================
    // Vehicle mounting (Strategy 4: Vehicle Mount Hybrid)
    // ============================================================

    public func SpawnVehicle() -> String {
        let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        if !IsDefined(player) {
            return "NO_PLAYER";
        }

        let transform = player.GetWorldTransform();
        let entitySystem = GameInstance.GetStaticEntitySystem();
        if !IsDefined(entitySystem) {
            return "NO_SPAWN_SYSTEM";
        }

        let spec: ref<StaticEntitySpec> = new StaticEntitySpec();
        spec.templatePath = r"base\\vehicles\\v_sportbike2_arch__basic.ent";
        spec.position = player.GetWorldPosition();
        spec.orientation = player.GetWorldOrientation();
        spec.attached = false;

        this.m_vehicleEntityID = entitySystem.SpawnEntity(spec);
        if EntityID.IsDefined(this.m_vehicleEntityID) {
            this.m_vehicleSpawned = true;
            return "SPAWNED";
        }

        return "SPAWN_FAILED";
    }

    public func DespawnVehicle() -> Void {
        if this.m_vehicleSpawned && EntityID.IsDefined(this.m_vehicleEntityID) {
            let entitySystem = GameInstance.GetStaticEntitySystem();
            if IsDefined(entitySystem) {
                entitySystem.DespawnEntity(this.m_vehicleEntityID);
            }
            this.m_vehicleEntityID = new EntityID();
            this.m_vehicleSpawned = false;
        }
    }

    public func MountPlayerToVehicle() -> String {
        if !this.m_vehicleSpawned || !EntityID.IsDefined(this.m_vehicleEntityID) {
            return "NO_VEHICLE";
        }

        let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        if !IsDefined(player) {
            return "NO_PLAYER";
        }

        // TODO: Mounting API in Redscript requires MountingRequest construction
        // which differs by game version. This is a stub for now.
        // CET handles mounting via Game.GetMountingSystem() instead.
        return "MOUNT_NOT_IMPLEMENTED";
    }

    public func RotateVehicle(pitch: Float, yaw: Float, roll: Float) -> String {
        if !this.m_vehicleSpawned || !EntityID.IsDefined(this.m_vehicleEntityID) {
            return "NO_VEHICLE";
        }

        let vehicle = GameInstance.FindEntityByID(this.GetGameInstance(), this.m_vehicleEntityID) as GameObject;
        if !IsDefined(vehicle) {
            return "VEHICLE_NOT_FOUND";
        }

        let pos = vehicle.GetWorldPosition();
        let euler = new EulerAngles();
        euler.Pitch = pitch;
        euler.Yaw = yaw;
        euler.Roll = roll;

        GameInstance.GetTeleportationFacility(this.GetGameInstance()).Teleport(vehicle, pos, euler);
        return "ROTATED";
    }

    // ============================================================
    // Locomotion component access
    // ============================================================

    public func GetLocomotionInfo() -> String {
        let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        if !IsDefined(player) {
            return "NO_PLAYER";
        }

        let blackboard = player.GetPlayerStateMachineBlackboard();
        if !IsDefined(blackboard) {
            return "NO_BLACKBOARD";
        }

        // PlayerStateMachine.LocomotionMode does not exist in the blackboard def.
        // Valid fields: Vision, HighLevel, Carrying, Melee, Swimming, DodgeTimeStamp.
        let highLevel = blackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
        return "highLevel=" + ToString(highLevel);
    }

    // ============================================================
    // Transform component access (deeper than CET)
    // ============================================================

    public func WriteOrientationDirect(pitch: Float, yaw: Float, roll: Float) -> String {
        let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        if !IsDefined(player) {
            return "NO_PLAYER";
        }

        let euler = new EulerAngles();
        euler.Pitch = pitch;
        euler.Yaw = yaw;
        euler.Roll = roll;

        // WorldTransform.orientation is not a native member (Codeware adds it via @addField).
        // Use TeleportationFacility.Teleport() instead — same pattern as RotateVehicle.
        let pos = player.GetWorldPosition();
        GameInstance.GetTeleportationFacility(this.GetGameInstance()).Teleport(player, pos, euler);

        return "WRITTEN";
    }

    // ============================================================
    // Force FELL state (experimental)
    // ============================================================

    public func ForceFellState() -> String {
        let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        if !IsDefined(player) {
            return "NO_PLAYER";
        }

        let blackboard = player.GetPlayerStateMachineBlackboard();
        if !IsDefined(blackboard) {
            return "NO_BB";
        }

        // PlayerStateMachine.LocomotionMode does not exist in the blackboard def.
        // Valid fields: Vision, HighLevel, Carrying, Melee, Swimming, DodgeTimeStamp.
        // This was tried in player6b and didn't work because the blackboard
        // is a read-only mirror of the actual state.
        return "LOCOMOTION_FIELD_NOT_AVAILABLE";
    }
}
