// ============================================================
// HoverRotPlayer8.reds — Redscript Bridge for Player Body Rotation
// ============================================================
//
// Declares native global functions implemented by the RED4ext C++ plugin
// and provides a ScriptableSystem bridge for CET Lua to call them.
//
// CET access pattern:
//   local bridge = Game.GetScriptableSystemsContainer():Get('HoverRotPlayer8Bridge')
//   bridge:ApplyRotation(quat)       — returns Bool
//   bridge:GetStatus()               — returns String
//   bridge:ReadPlayerOrientation()   — returns String
//
// Deploy: r6/scripts/HoverRotPlayer8/HoverRotPlayer8.reds
// ============================================================

// ============================================================
// Native function declarations (implemented in C++ Main.cpp)
// ============================================================

// Writes quaternion to player's transformComponent->worldTransform.Orientation
// Returns true if the write succeeded
public static native func HoverRotPlayer8_ApplyRotation(quat: Quaternion) -> Bool

// Returns diagnostic string: calls, ok, fail, reads, lastQuat, lastError
public static native func HoverRotPlayer8_GetStatus() -> String

// Returns player's current orientation quaternion as string: "i=X j=Y k=Z r=W"
public static native func HoverRotPlayer8_ReadPlayerOrientation() -> String

// ============================================================
// CET-callable bridge system
// ============================================================

public class HoverRotPlayer8Bridge extends ScriptableSystem {
    private let m_nativeAvailable: Bool;

    private func OnAttach() -> Void {
        this.m_nativeAvailable = false;
    }

    private func OnDetach() -> Void {
        this.m_nativeAvailable = false;
    }

    // Called from CET onInit to verify the plugin is loaded
    // If the native function call succeeds, the plugin is available
    public func CheckNativeAvailable() -> Bool {
        let status = HoverRotPlayer8_GetStatus();
        this.m_nativeAvailable = StrLen(status) > 0;
        return this.m_nativeAvailable;
    }

    // Called from CET onUpdate every frame when active
    // quat is pre-computed by CET using EulerAngles.new(roll, pitch, yaw):ToQuat()
    // Returns true if the rotation was successfully written to player transform
    public func ApplyRotation(quat: Quaternion) -> Bool {
        if !this.m_nativeAvailable {
            return false;
        }
        return HoverRotPlayer8_ApplyRotation(quat);
    }

    // Returns diagnostic info for ImGui panel
    public func GetStatus() -> String {
        return HoverRotPlayer8_GetStatus();
    }

    // Returns the player's current orientation quaternion as string
    public func ReadPlayerOrientation() -> String {
        return HoverRotPlayer8_ReadPlayerOrientation();
    }

    // Check if native functions are available (plugin loaded)
    public func IsNativeAvailable() -> Bool {
        return this.m_nativeAvailable;
    }
}
