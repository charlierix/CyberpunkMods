// ============================================================
// HoverRotPlayer9_1a.reds — Redscript Bridge for Diagnostic Logging
// ============================================================
//
// Declares native global functions implemented by the RED4ext C++ plugin
// and provides a ScriptableSystem bridge for CET Lua to call them.
//
// CET access pattern (proven from Tester 8):
//   local bridge = Game.GetScriptableSystemsContainer():Get('HoverRotPlayer9_1aBridge')
//   bridge:DumpComponents()       — returns String (all component class names)
//   bridge:DumpSkeleton()         — returns String (bone hierarchy + transforms)
//   bridge:DumpEntityTransform()  — returns String (entity worldTransform readback)
//   bridge:GetStatus()            — returns String (plugin diagnostics)
//
// Deploy: r6/scripts/HoverRotPlayer9_1a/HoverRotPlayer9_1a.reds
// ============================================================

// ============================================================
// Native function declarations (implemented in C++ Main.cpp)
// ============================================================

// Returns all component class names, one per line: "index|className"
public static native func HoverRotPlayer9_1a_DumpComponents() -> String

// Returns bone hierarchy with transforms: "boneIndex|boneName|parentIdx|tx|ty|tz|qi|qj|qk|qr"
public static native func HoverRotPlayer9_1a_DumpSkeleton() -> String

// Returns entity worldTransform: "posRaw(x,y,z)|orient(i,j,k,r)"
public static native func HoverRotPlayer9_1a_DumpEntityTransform() -> String

// Returns plugin diagnostics: "plugin=...|loaded=...|dumpComp=...|dumpSkel=...|..."
public static native func HoverRotPlayer9_1a_GetStatus() -> String

// ============================================================
// CET-callable bridge system
// ============================================================

public class HoverRotPlayer9_1aBridge extends ScriptableSystem {
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
        let status = HoverRotPlayer9_1a_GetStatus();
        this.m_nativeAvailable = StrLen(status) > 0;
        return this.m_nativeAvailable;
    }

    // Returns all component class names (one per line)
    public func DumpComponents() -> String {
        if !this.m_nativeAvailable {
            return "ERROR: native not available — plugin not loaded";
        }
        return HoverRotPlayer9_1a_DumpComponents();
    }

    // Returns bone hierarchy with transforms
    public func DumpSkeleton() -> String {
        if !this.m_nativeAvailable {
            return "ERROR: native not available — plugin not loaded";
        }
        return HoverRotPlayer9_1a_DumpSkeleton();
    }

    // Returns entity worldTransform readback
    public func DumpEntityTransform() -> String {
        if !this.m_nativeAvailable {
            return "ERROR: native not available — plugin not loaded";
        }
        return HoverRotPlayer9_1a_DumpEntityTransform();
    }

    // Returns plugin diagnostics
    public func GetStatus() -> String {
        return HoverRotPlayer9_1a_GetStatus();
    }

    // Check if native functions are available (plugin loaded)
    public func IsNativeAvailable() -> Bool {
        return this.m_nativeAvailable;
    }
}
